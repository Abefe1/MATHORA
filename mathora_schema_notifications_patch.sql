-- ==========================================
-- MATHORA — Push Notifications Patch
-- Run this AFTER mathora_schema.sql, mathora_schema_auth_patch.sql,
-- and mathora_schema_notifications requires that patch's
-- current_student_id()/current_teacher_id() helpers.
--
-- What this adds:
--   1. push_tokens        — one row per device (mobile Expo token, or
--                            web Push subscription), owned by a user.
--   2. notification_log   — a durable record of what was sent, doubling
--                            as an in-app notification center's data
--                            source if one gets built later.
--   3. notification_queue — a durable outbox. DB triggers below INSERT
--                            here instead of calling out to a webhook
--                            directly; a dispatcher (mathora-web's
--                            /api/notifications/dispatch route) polls
--                            it and does the actual sending. This keeps
--                            "something happened in the DB" and
--                            "a push was actually delivered" decoupled,
--                            so a dispatcher outage doesn't lose events.
--   4. Trigger functions that queue the three notification types this
--      project asked for: study/streak reminders, teacher/parent
--      alerts (mastery drop, assignment due), and Rescue Mode
--      follow-ups.
--
-- DEPLOYMENT — none of this fires on its own. You still need to, in
-- the Supabase dashboard:
--   a) Enable the `pg_cron` extension (Database -> Extensions) and
--      schedule:
--        select cron.schedule('mathora-dispatch-notifications',
--          '*/5 * * * *',
--          $$select net.http_post(
--            url := 'https://<your-domain>/api/notifications/dispatch',
--            headers := jsonb_build_object(
--              'content-type', 'application/json',
--              'x-notification-secret', '<NOTIFICATIONS_DISPATCH_SECRET>'
--            )
--          )$$);
--      (requires the `pg_net` extension too, for net.http_post)
--   b) Schedule the two daily queue-producing functions the same way:
--        select cron.schedule('mathora-streak-reminders', '0 17 * * *',
--          $$select public.queue_streak_reminders()$$);
--        select cron.schedule('mathora-assignment-due-reminders', '0 8 * * *',
--          $$select public.queue_due_assignment_reminders()$$);
--   c) Set NOTIFICATIONS_DISPATCH_SECRET, EXPO_ACCESS_TOKEN (optional,
--      raises Expo's push rate limit), VAPID_PUBLIC_KEY,
--      VAPID_PRIVATE_KEY, and SUPABASE_SERVICE_ROLE_KEY as
--      server-only env vars on whatever hosts mathora-web.
-- ==========================================

-- ------------------------------------------
-- 1. PUSH TOKENS
-- ------------------------------------------

create table if not exists public.push_tokens (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade not null,
  platform text not null check (platform in ('ios', 'android', 'web')),
  -- Expo push token string for ios/android; JSON-stringified
  -- PushSubscription (endpoint + keys) for web.
  token text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, token)
);

alter table public.push_tokens enable row level security;

drop policy if exists "push_tokens_manage_own" on public.push_tokens;
create policy "push_tokens_manage_own" on public.push_tokens for all
  using (user_id = auth.uid())
  with check (user_id = auth.uid());
-- No policy grants any other user (including teachers/admins) select
-- on this table — the dispatcher reads it with the service-role key,
-- which bypasses RLS entirely, so it doesn't need one.

-- ------------------------------------------
-- 2. NOTIFICATION LOG
-- Client-read-only (own rows). Only the service role (the dispatcher)
-- inserts into it — there is deliberately no client-facing insert
-- policy, same reasoning as topic_mastery in the auth patch.
-- ------------------------------------------

create table if not exists public.notification_log (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade not null,
  type text not null, -- 'streak_reminder' | 'assignment_due' | 'mastery_drop' | 'rescue_followup'
  title text not null,
  body text not null,
  data jsonb not null default '{}',
  created_at timestamptz not null default now(),
  read_at timestamptz
);

alter table public.notification_log enable row level security;

drop policy if exists "notification_log_select_own" on public.notification_log;
create policy "notification_log_select_own" on public.notification_log for select
  using (user_id = auth.uid());

drop policy if exists "notification_log_mark_read_own" on public.notification_log;
create policy "notification_log_mark_read_own" on public.notification_log for update
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

-- ------------------------------------------
-- 3. NOTIFICATION QUEUE (outbox)
-- No client-facing policies at all — this table is only ever touched
-- by trigger functions (SECURITY DEFINER, run as the DB) and the
-- dispatcher (service-role key, bypasses RLS).
-- ------------------------------------------

create table if not exists public.notification_queue (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade not null,
  type text not null,
  title text not null,
  body text not null,
  data jsonb not null default '{}',
  status text not null default 'pending' check (status in ('pending', 'sent', 'failed')),
  created_at timestamptz not null default now(),
  sent_at timestamptz
);

alter table public.notification_queue enable row level security;
-- (RLS enabled with zero policies = no client access at all, by design.)

create index if not exists notification_queue_pending_idx
  on public.notification_queue (status, created_at)
  where status = 'pending';

create or replace function public.queue_notification(
  p_user_id uuid,
  p_type text,
  p_title text,
  p_body text,
  p_data jsonb default '{}'
)
returns void
language sql
security definer
set search_path = public
as $$
  insert into public.notification_queue (user_id, type, title, body, data)
  values (p_user_id, p_type, p_title, p_body, p_data);
$$;

-- ------------------------------------------
-- 4a. RESCUE MODE FOLLOW-UP
-- Fires when a student gets a question wrong (rescue_mode_triggered).
-- Queued as a same-day nudge back into that topic rather than an
-- instant duplicate of the in-app Rescue Mode modal they're already
-- looking at.
-- ------------------------------------------

create or replace function public.notify_rescue_followup()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  target_user_id uuid;
  topic_title text;
begin
  if not new.rescue_mode_triggered then
    return new;
  end if;

  select s.user_id into target_user_id from public.students s where s.id = new.student_id;
  select t.title into topic_title from public.topics t where t.id = new.topic_id;

  if target_user_id is not null then
    perform public.queue_notification(
      target_user_id,
      'rescue_followup',
      'Ready for another go?',
      coalesce('Revisit ' || topic_title || ' — a quick retry now helps it stick.', 'Revisit that last topic — a quick retry now helps it stick.'),
      jsonb_build_object('topic_id', new.topic_id, 'question_id', new.question_id)
    );
  end if;

  return new;
end;
$$;

drop trigger if exists on_attempt_rescue_followup on public.attempts;
create trigger on_attempt_rescue_followup
  after insert on public.attempts
  for each row execute function public.notify_rescue_followup();

-- ------------------------------------------
-- 4b. MASTERY DROP ALERT (teacher + parent)
-- Fires from the same trigger that recomputes topic_mastery
-- (update_topic_mastery, in mathora_schema.sql) via a second trigger
-- on topic_mastery itself, comparing OLD vs NEW mastery_percentage.
-- ------------------------------------------

create or replace function public.notify_mastery_drop()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  drop_amount numeric;
  student_user_id uuid;
  parent_user_id uuid;
  topic_title text;
  teacher_user_ids uuid[];
  i int;
begin
  drop_amount := coalesce(old.mastery_percentage, 0) - new.mastery_percentage;

  -- Only alert on a meaningful drop (>= 15 points) with enough attempts
  -- behind it to not be noise from a single early guess.
  if drop_amount < 15 or new.total_attempted < 3 then
    return new;
  end if;

  select s.user_id, s.parent_id into student_user_id, parent_user_id
    from public.students s where s.id = new.student_id;
  select t.title into topic_title from public.topics t where t.id = new.topic_id;

  select array_agg(distinct tc.user_id) into teacher_user_ids
    from public.class_students cs
    join public.classes c on c.id = cs.class_id
    join public.teachers t2 on t2.id = c.teacher_id
    join public.users tc on tc.id = t2.user_id
    where cs.student_id = new.student_id;

  if parent_user_id is not null then
    perform public.queue_notification(
      parent_user_id,
      'mastery_drop',
      'A topic needs attention',
      coalesce('Mastery in ' || topic_title || ' dropped to ' || new.mastery_percentage || '%. A little extra practice this week could help.', 'A recent topic''s mastery dropped — a little extra practice this week could help.'),
      jsonb_build_object('topic_id', new.topic_id, 'student_id', new.student_id, 'mastery_percentage', new.mastery_percentage)
    );
  end if;

  if teacher_user_ids is not null then
    -- Explicit loop rather than perform func(unnest(array)): relying
    -- on a set-returning function inside a volatile scalar call's
    -- argument list to fan out once per element is a real Postgres
    -- behavior but an unobvious one to read and reason about for a
    -- function with an INSERT side effect — the loop says exactly
    -- what happens.
    for i in 1 .. array_length(teacher_user_ids, 1) loop
      perform public.queue_notification(
        teacher_user_ids[i],
        'mastery_drop',
        'Student mastery dropped',
        coalesce('A student''s mastery in ' || topic_title || ' dropped to ' || new.mastery_percentage || '%.', 'A student''s topic mastery dropped recently.'),
        jsonb_build_object('topic_id', new.topic_id, 'student_id', new.student_id, 'mastery_percentage', new.mastery_percentage)
      );
    end loop;
  end if;

  return new;
end;
$$;

drop trigger if exists on_mastery_drop on public.topic_mastery;
create trigger on_mastery_drop
  after update on public.topic_mastery
  for each row execute function public.notify_mastery_drop();

-- ------------------------------------------
-- 4c. ASSIGNMENT DUE REMINDER (cron-driven, not trigger-driven —
-- "due tomorrow" depends on the current time, not on any row change)
-- ------------------------------------------

create or replace function public.queue_due_assignment_reminders()
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.notification_queue (user_id, type, title, body, data)
  select
    s.user_id,
    'assignment_due',
    'Assignment due tomorrow',
    a.title || ' is due ' || to_char(a.due_date, 'FMDay, Mon DD') || '.',
    jsonb_build_object('assignment_id', a.id, 'class_id', a.class_id)
  from public.assignments a
  join public.class_students cs on cs.class_id = a.class_id
  join public.students s on s.id = cs.student_id
  left join public.assignment_submissions sub
    on sub.assignment_id = a.id and sub.student_id = s.id
  where a.due_date::date = (now() + interval '1 day')::date
    and (sub.completed is null or sub.completed = false)
    -- avoid re-queuing the same reminder if the cron job runs more
    -- than once inside the reminder window
    and not exists (
      select 1 from public.notification_queue nq
      where nq.user_id = s.user_id
        and nq.type = 'assignment_due'
        and (nq.data ->> 'assignment_id')::uuid = a.id
        and nq.created_at > now() - interval '20 hours'
    );
end;
$$;

-- ------------------------------------------
-- 4d. STUDY / STREAK REMINDER (cron-driven, daily)
-- Nudges any student with no attempts recorded so far today.
-- ------------------------------------------

create or replace function public.queue_streak_reminders()
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.notification_queue (user_id, type, title, body, data)
  select s.user_id, 'streak_reminder', 'Keep your streak alive', 'You haven''t practiced today — a quick 5-minute session keeps your streak going.', '{}'::jsonb
  from public.students s
  where not exists (
    select 1 from public.attempts att
    where att.student_id = s.id
      and att.attempted_at::date = now()::date
  )
  and not exists (
    select 1 from public.notification_queue nq
    where nq.user_id = s.user_id
      and nq.type = 'streak_reminder'
      and nq.created_at::date = now()::date
  );
end;
$$;
