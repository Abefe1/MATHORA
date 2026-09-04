-- ==========================================
-- MATHORA — Assignments Security Hardening Patch
-- Run after mathora_schema_assignments_patch.sql.
--
-- Fixes a real gap found in security review: assignment_answers_insert_own
-- checked student/assignment ownership but never that question_id
-- actually belonged to that assignment's curated set, and both
-- attempts.is_correct and assignment_answers.is_correct were trusted
-- verbatim from the client — a student's own request could self-report
-- a perfect score. Also closes the same hole one level up:
-- assignment_submissions.score was written by a raw client .update(),
-- so even a fully-honest per-answer trail didn't stop a forged final
-- score. And adds a lightweight, DB-only rate limit (no new infra) on
-- the two request-shaped endpoints most exposed to scripted abuse:
-- find_or_request_class_join (a low-entropy verification-value
-- guessing oracle) and the attempts/assignment_answers insert paths.
-- ==========================================

-- ------------------------------------------
-- 1. assignment_answers: question must belong to the assignment
-- ------------------------------------------

drop policy if exists "assignment_answers_insert_own" on public.assignment_answers;
create policy "assignment_answers_insert_own" on public.assignment_answers for insert
  with check (
    student_id = public.current_student_id()
    and assignment_id in (
      select a.id from public.assignments a
      where a.class_id in (select public.my_class_ids_as_student())
    )
    and question_id in (
      select aq.question_id from public.assignment_questions aq where aq.assignment_id = assignment_id
    )
  );

-- ------------------------------------------
-- 2. Lightweight rate limiter — a plain table + rolling-window count,
-- no new infra/dependency. Never touched directly by clients: only
-- SECURITY DEFINER functions/triggers call it, and RLS is enabled with
-- no policies so even a client that somehow addressed it directly gets
-- an implicit deny.
-- ------------------------------------------

create table if not exists public.rate_limit_events (
  id bigserial primary key,
  rate_key text not null,
  created_at timestamptz not null default now()
);

create index if not exists rate_limit_events_key_time_idx on public.rate_limit_events (rate_key, created_at);

alter table public.rate_limit_events enable row level security;
-- Deliberately no policies — deny-all to every client role. Only
-- SECURITY DEFINER functions (which bypass RLS) ever touch this table.

create or replace function public.check_rate_limit(p_key text, p_max_calls integer, p_window interval)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
declare
  v_count integer;
begin
  -- Opportunistic cleanup scoped to this key only — bounds each key's
  -- own row count without needing a separate cron/vacuum job.
  delete from public.rate_limit_events
  where rate_key = p_key and created_at < now() - p_window;

  select count(*) into v_count
  from public.rate_limit_events
  where rate_key = p_key and created_at >= now() - p_window;

  if v_count >= p_max_calls then
    return false;
  end if;

  insert into public.rate_limit_events (rate_key) values (p_key);
  return true;
end;
$$;

-- ------------------------------------------
-- 3. find_or_request_class_join: throttle per calling student. This is
-- the guessing-oracle flagged in review — a roster row's
-- verification_value is often just a phone/admission number, and a
-- match auto-joins the caller.
-- ------------------------------------------

create or replace function public.find_or_request_class_join(
  p_class_id uuid,
  p_verification_value text default null
)
returns jsonb -- {"status": "joined" | "already_member" | "pending"}
language plpgsql
security definer
set search_path = public
as $$
declare
  sid uuid := public.current_student_id();
  caller_name text;
  match_row public.class_roster_entries;
  match_count integer;
begin
  if sid is null then
    raise exception 'Only a student profile can request to join a class';
  end if;

  if not public.check_rate_limit('class_join:' || sid::text, 10, interval '5 minutes') then
    raise exception 'Too many join attempts — please wait a few minutes and try again.';
  end if;

  if exists (select 1 from public.class_students where class_id = p_class_id and student_id = sid) then
    return jsonb_build_object('status', 'already_member');
  end if;

  select full_name into caller_name from public.users where id = auth.uid();

  select count(*) into match_count
  from public.class_roster_entries
  where class_id = p_class_id
    and claimed_by_student_id is null
    and lower(full_name) = lower(caller_name)
    and (verification_value is null or lower(verification_value) = lower(p_verification_value));

  if match_count = 1 then
    select * into match_row
    from public.class_roster_entries
    where class_id = p_class_id
      and claimed_by_student_id is null
      and lower(full_name) = lower(caller_name)
      and (verification_value is null or lower(verification_value) = lower(p_verification_value))
    limit 1;

    update public.class_roster_entries
    set claimed_by_student_id = sid, claimed_at = now()
    where id = match_row.id;

    insert into public.class_students (class_id, student_id)
    values (p_class_id, sid)
    on conflict (class_id, student_id) do nothing;

    return jsonb_build_object('status', 'joined');
  end if;

  insert into public.class_join_requests (class_id, student_id, verification_value)
  values (p_class_id, sid, p_verification_value)
  on conflict (class_id, student_id) where status = 'pending' do nothing;

  return jsonb_build_object('status', 'pending');
end;
$$;

grant execute on function public.find_or_request_class_join(uuid, text) to authenticated;

-- ------------------------------------------
-- 4. attempts + assignment_answers: recompute is_correct server-side
-- (ignore whatever the client sent) and throttle per student. BEFORE
-- INSERT so the row that actually lands is always honest — no separate
-- fix-up pass needed, and topic_mastery's existing AFTER-insert trigger
-- reads the corrected value for free since BEFORE triggers finish
-- before AFTER triggers run.
-- ------------------------------------------

create or replace function public.enforce_attempt_integrity()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_correct_letter char(1);
begin
  if not public.check_rate_limit('attempt:' || new.student_id::text, 60, interval '1 minute') then
    raise exception 'Too many submissions — please slow down.';
  end if;

  select correct_letter into v_correct_letter from public.questions where id = new.question_id;
  if v_correct_letter is null then
    raise exception 'Question not found';
  end if;

  new.is_correct := (new.selected_option = v_correct_letter);
  return new;
end;
$$;

drop trigger if exists trg_enforce_attempt_integrity on public.attempts;
create trigger trg_enforce_attempt_integrity
  before insert on public.attempts
  for each row execute function public.enforce_attempt_integrity();

create or replace function public.enforce_assignment_answer_integrity()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_correct_letter char(1);
begin
  if not public.check_rate_limit('assignment_answer:' || new.student_id::text, 60, interval '1 minute') then
    raise exception 'Too many submissions — please slow down.';
  end if;

  select correct_letter into v_correct_letter from public.questions where id = new.question_id;
  if v_correct_letter is null then
    raise exception 'Question not found';
  end if;

  new.is_correct := (new.selected_option = v_correct_letter);
  return new;
end;
$$;

drop trigger if exists trg_enforce_assignment_answer_integrity on public.assignment_answers;
create trigger trg_enforce_assignment_answer_integrity
  before insert on public.assignment_answers
  for each row execute function public.enforce_assignment_answer_integrity();

-- ------------------------------------------
-- 5. assignment_submissions: stop trusting a client-supplied score.
-- Even with per-answer integrity fixed above, completeAssignmentSubmission
-- previously wrote `score` via a plain client .update() — a forged
-- score there would still show up in the teacher's dashboard untouched
-- by anything above. Move completion to a SECURITY DEFINER RPC that
-- derives score from the actual assignment_answers rows, and revoke
-- direct client UPDATE on the table entirely (same column-lockdown
-- pattern mathora_schema_auth_patch.sql already uses for users.role) —
-- the RPC bypasses grants since it runs as the function owner.
-- ------------------------------------------

create or replace function public.complete_assignment_submission(p_assignment_id uuid)
returns jsonb -- {"score": numeric, "total": int, "correct": int}
language plpgsql
security definer
set search_path = public
as $$
declare
  sid uuid := public.current_student_id();
  v_total integer;
  v_correct integer;
  v_score numeric(5,2);
begin
  if sid is null then
    raise exception 'Only a student profile can complete an assignment';
  end if;

  select count(*) into v_total from public.assignment_questions where assignment_id = p_assignment_id;
  select count(*) into v_correct
  from public.assignment_answers
  where assignment_id = p_assignment_id and student_id = sid and is_correct;

  v_score := case when v_total > 0 then round((v_correct::numeric / v_total::numeric) * 100, 2) else 0 end;

  update public.assignment_submissions
  set completed = true, score = v_score, submitted_at = now()
  where assignment_id = p_assignment_id and student_id = sid;

  if not found then
    -- Guards against completion racing ahead of startAssignmentAttempt's
    -- upsert somehow never landing — this RPC should never silently no-op.
    insert into public.assignment_submissions (assignment_id, student_id, started_at, completed, score, submitted_at)
    values (p_assignment_id, sid, now(), true, v_score, now());
  end if;

  return jsonb_build_object('score', v_score, 'total', v_total, 'correct', v_correct);
end;
$$;

grant execute on function public.complete_assignment_submission(uuid) to authenticated;

revoke update on public.assignment_submissions from authenticated;
