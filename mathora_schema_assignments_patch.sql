-- ==========================================
-- MATHORA — Assignments Patch
-- Run after mathora_schema_admin_cms_and_rls_recursion_fix_patch.sql and
-- mathora_schema_notifications_patch.sql (needs current_teacher_id(),
-- current_student_id(), my_class_ids_as_student(), queue_notification()).
--
-- Adds: teacher-authored questions, teacher-curated assignment question
-- sets, assignment duration, per-question answers, a focus-loss deterrent
-- (generalizes screenshot_events rather than a new sibling table), and
-- topics.week (unrelated to assignments, but consolidated into this same
-- patch rather than opening a second ad-hoc file for one column).
-- ==========================================

-- ------------------------------------------
-- 1. questions: teacher-authored custom questions, published immediately
-- ------------------------------------------

alter table public.questions
  add column if not exists created_by_teacher_id uuid references public.teachers(id) on delete set null;

create index if not exists questions_created_by_teacher_idx on public.questions (created_by_teacher_id);

-- questions_read_published_or_own_draft (content_pipeline_patch) already
-- lets a teacher SELECT every question regardless of status — its exists
-- clause is OR'd with status='published', not AND'd, and has no
-- authorship condition. No SELECT policy change needed here.

-- Widen INSERT to teachers, additive alongside questions_insert_by_admin.
-- Teachers write status='published' directly — no draft/review step for
-- teacher-authored questions (scope decision: immediate use, no admin
-- review gate), unlike the AI content pipeline.
drop policy if exists "questions_insert_by_teacher" on public.questions;
create policy "questions_insert_by_teacher" on public.questions for insert
  with check (
    created_by_teacher_id = public.current_teacher_id()
    and status = 'published'
  );

-- ------------------------------------------
-- 2. assignments: duration + curated question set
-- ------------------------------------------

alter table public.assignments
  add column if not exists duration_minutes integer check (duration_minutes is null or duration_minutes > 0);

-- question_count is kept, not dropped — nothing in mathora-web or
-- mathora-mobile writes or reads it today (confirmed: the only other
-- "question_count" hits in the app are an unrelated content-ingest form
-- field), so there's no live behavior to preserve, but dropping an
-- already-applied column a stale client type still references is an
-- avoidable footgun for zero benefit. Repurposed as a derived/legacy
-- display value, auto-maintained by the trigger in section 3.
comment on column public.assignments.question_count is
  'Legacy/derived: count of rows in assignment_questions for this assignment. Superseded by assignment_questions as the source of truth for which questions are on this assignment; kept for backward display compat only. Auto-maintained by trg_assignment_questions_count.';

-- ------------------------------------------
-- 3. assignment_questions: teacher-curated question set
-- ------------------------------------------

create table if not exists public.assignment_questions (
  assignment_id uuid references public.assignments(id) on delete cascade not null,
  question_id uuid references public.questions(id) on delete cascade not null,
  order_index integer not null default 1,
  primary key (assignment_id, question_id)
);

create index if not exists assignment_questions_assignment_idx on public.assignment_questions (assignment_id, order_index);

alter table public.assignment_questions enable row level security;

drop policy if exists "assignment_questions_select_owner_or_enrolled" on public.assignment_questions;
create policy "assignment_questions_select_owner_or_enrolled" on public.assignment_questions for select
  using (
    assignment_id in (
      select a.id from public.assignments a
      join public.classes c on c.id = a.class_id
      where c.teacher_id = public.current_teacher_id()
    )
    or assignment_id in (
      select a.id from public.assignments a
      where a.class_id in (select public.my_class_ids_as_student())
    )
  );

drop policy if exists "assignment_questions_write_owner" on public.assignment_questions;
create policy "assignment_questions_write_owner" on public.assignment_questions for insert
  with check (
    assignment_id in (
      select a.id from public.assignments a
      join public.classes c on c.id = a.class_id
      where c.teacher_id = public.current_teacher_id()
    )
  );

drop policy if exists "assignment_questions_delete_owner" on public.assignment_questions;
create policy "assignment_questions_delete_owner" on public.assignment_questions for delete
  using (
    assignment_id in (
      select a.id from public.assignments a
      join public.classes c on c.id = a.class_id
      where c.teacher_id = public.current_teacher_id()
    )
  );
-- No update policy: reordering/swapping is a delete+insert from the
-- builder UI, not an in-place update.

-- Keep assignments.question_count in sync for the legacy display path.
create or replace function public.sync_assignment_question_count()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  target_id uuid := coalesce(new.assignment_id, old.assignment_id);
begin
  update public.assignments
    set question_count = (select count(*) from public.assignment_questions where assignment_id = target_id)
    where id = target_id;
  return null;
end;
$$;

drop trigger if exists trg_assignment_questions_count on public.assignment_questions;
create trigger trg_assignment_questions_count
  after insert or delete on public.assignment_questions
  for each row execute function public.sync_assignment_question_count();

-- ------------------------------------------
-- 4. assignment_submissions: started_at for duration enforcement
-- ------------------------------------------

alter table public.assignment_submissions
  add column if not exists started_at timestamptz;
-- Nullable: set once, at first open, by the take-flow's
-- startAssignmentAttempt() — never overwritten on reopen, since the
-- countdown depends on it staying stable across reloads.

-- ------------------------------------------
-- 5. assignment_answers: per-question answers, mirrors attempts
-- ------------------------------------------

create table if not exists public.assignment_answers (
  id uuid primary key default gen_random_uuid(),
  assignment_id uuid references public.assignments(id) on delete cascade not null,
  student_id uuid references public.students(id) on delete cascade not null,
  question_id uuid references public.questions(id) on delete cascade not null,
  selected_option char(1) not null check (selected_option in ('A','B','C','D','E')),
  is_correct boolean not null,
  answered_at timestamptz not null default now(),
  unique (assignment_id, student_id, question_id)
);
-- assignment_id + student_id kept as direct columns (denormalized off
-- assignment_submissions) rather than a submission-row FK: every RLS
-- policy elsewhere in this schema scopes through assignment_id/student_id
-- directly, and the take-flow needs to record an answer before the
-- submission row's final shape is necessarily decided — avoids a
-- chicken-and-egg ordering requirement.

create index if not exists assignment_answers_assignment_student_idx
  on public.assignment_answers (assignment_id, student_id);

alter table public.assignment_answers enable row level security;

drop policy if exists "assignment_answers_select_owner_or_related" on public.assignment_answers;
create policy "assignment_answers_select_owner_or_related" on public.assignment_answers for select
  using (
    student_id = public.current_student_id()
    or assignment_id in (
      select a.id from public.assignments a
      join public.classes c on c.id = a.class_id
      where c.teacher_id = public.current_teacher_id()
    )
  );

drop policy if exists "assignment_answers_insert_own" on public.assignment_answers;
create policy "assignment_answers_insert_own" on public.assignment_answers for insert
  with check (
    student_id = public.current_student_id()
    and assignment_id in (
      select a.id from public.assignments a
      where a.class_id in (select public.my_class_ids_as_student())
    )
  );
-- No update/delete policy: an answer, once submitted, is final — same
-- one-shot semantics as attempts. Re-answering the same question is
-- blocked by the unique constraint.

-- ------------------------------------------
-- 6. Focus-loss events: generalize screenshot_events
--
-- Generalized rather than a new sibling table: same shape (user_id, a
-- "what screen"/context, created_at), same RLS shape (insert-own,
-- teacher-select via the identical students -> class_students ->
-- classes -> current_teacher_id() join), same purpose (log-only
-- deterrent, teacher-visible, never read back by the student). A
-- sibling table would duplicate that exact join in a second policy for
-- no behavioral difference, and the teacher-facing UI would need to
-- query two tables and merge them. event_type defaults to 'screenshot'
-- so every existing row and the untouched mobile insert path (which
-- never sets event_type) are unaffected; assignment_id stays nullable so
-- non-assignment contexts (e.g. mock-exam) keep working unchanged.
-- ------------------------------------------

alter table public.screenshot_events
  add column if not exists event_type text not null default 'screenshot'
  check (event_type in ('screenshot', 'focus_loss'));

alter table public.screenshot_events
  add column if not exists assignment_id uuid references public.assignments(id) on delete cascade;

create index if not exists screenshot_events_assignment_idx on public.screenshot_events (assignment_id) where assignment_id is not null;

-- Existing screenshot_events_insert_own / _select_teacher policies are
-- unchanged in shape — the new columns ride along under the same
-- USING/WITH CHECK clauses, no policy rewrite needed.

-- ------------------------------------------
-- 7. Focus-loss -> teacher notification
--
-- 1 student -> 1 teacher (via assignments -> classes.teacher_id), NOT a
-- fan-out loop like notify_mastery_drop() (which fans out to every
-- teacher across every class a student is in, because mastery is
-- student-scoped, not assignment-scoped). assignment_id pins this to
-- exactly one class and therefore exactly one teacher.
-- ------------------------------------------

create or replace function public.notify_focus_loss()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_teacher_user_id uuid;
  v_student_name text;
  v_assignment_title text;
begin
  if new.event_type <> 'focus_loss' or new.assignment_id is null then
    return new;
  end if;

  select tu.id, coalesce(su.full_name, 'A student'), a.title
    into v_teacher_user_id, v_student_name, v_assignment_title
  from public.assignments a
  join public.classes c on c.id = a.class_id
  join public.teachers t on t.id = c.teacher_id
  join public.users tu on tu.id = t.user_id
  left join public.students st on st.user_id = new.user_id
  left join public.users su on su.id = st.user_id
  where a.id = new.assignment_id;

  if v_teacher_user_id is not null then
    perform public.queue_notification(
      v_teacher_user_id,
      'assignment_focus_loss',
      'Possible focus loss during an assignment',
      v_student_name || ' switched away from "' || coalesce(v_assignment_title, 'an assignment') || '" while it was in progress.',
      jsonb_build_object('assignment_id', new.assignment_id, 'event_id', new.id)
    );
  end if;

  return new;
end;
$$;

drop trigger if exists on_focus_loss_event on public.screenshot_events;
create trigger on_focus_loss_event
  after insert on public.screenshot_events
  for each row execute function public.notify_focus_loss();

-- ------------------------------------------
-- 8. topics.week — links every topic to its syllabus week, alongside
-- the class_level/term it already carries. Nullable: filled where the
-- source document gives a reliable week number, left null where it
-- doesn't (see SYLLABUS/build_topics_seed.py's DATA comments for which
-- entries are inferred rather than verbatim). Range widened to 1-15
-- (not 1-13) to accommodate one confirmed 14-week term.
-- ------------------------------------------

alter table public.topics
  add column if not exists week smallint check (week is null or week between 1 and 15);

create index if not exists topics_class_term_week_idx on public.topics (class_level, term, week);
