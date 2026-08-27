-- ==========================================
-- MATHORA PLATFORM — Complete Supabase Database Schema
-- Nigerian Mathematics Learning & Mastery Platform
-- ==========================================

-- 1. ENUMS & CONSTANTS
create type user_role as enum (
  'student',
  'teacher',
  'parent',
  'content_admin',
  'academic_admin',
  'support_admin',
  'finance_admin',
  'super_admin'
);

create type exam_type as enum (
  'WAEC',
  'BECE',
  'JAMB',
  'NECO',
  'GENERAL'
);

create type class_level as enum (
  'JSS1', 'JSS2', 'JSS3',
  'SS1', 'SS2', 'SS3'
);

-- 2. USERS TABLE
create table public.users (
  id uuid references auth.users(id) on delete cascade primary key,
  full_name text not null,
  email text not null unique,
  phone text,
  role user_role not null default 'student',
  avatar_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- 3. ROLE-SPECIFIC PROFILES
create table public.students (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.users(id) on delete cascade unique not null,
  current_level class_level not null default 'SS2',
  parent_id uuid references public.users(id) on delete set null,
  created_at timestamptz not null default now()
);

create table public.teachers (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.users(id) on delete cascade unique not null,
  school_name text,
  state text default 'Lagos',
  verified boolean not null default false,
  created_at timestamptz not null default now()
);

-- 4. CURRICULUM & CONTENT ENGINE
create table public.curricula (
  id uuid primary key default gen_random_uuid(),
  title text not null default 'Nigerian National Curriculum (NERDC)',
  subject text not null default 'Mathematics',
  description text,
  created_at timestamptz not null default now()
);

create table public.topics (
  id uuid primary key default gen_random_uuid(),
  curriculum_id uuid references public.curricula(id) on delete cascade not null,
  class_level class_level not null default 'SS2',
  title text not null,
  description text,
  order_index integer not null default 1,
  icon text default 'Calculator',
  created_at timestamptz not null default now()
);

create table public.lessons (
  id uuid primary key default gen_random_uuid(),
  topic_id uuid references public.topics(id) on delete cascade not null,
  title text not null,
  summary text not null,
  content_body text not null, -- Markdown/HTML with LaTeX support
  video_url text,
  audio_url text,
  order_index integer not null default 1,
  created_at timestamptz not null default now()
);

create table public.worked_examples (
  id uuid primary key default gen_random_uuid(),
  lesson_id uuid references public.lessons(id) on delete cascade not null,
  title text not null,
  problem_statement text not null,
  solution_steps jsonb not null default '[]', -- Array of step strings or objects
  exam_shortcut text,
  common_trap_warning text,
  order_index integer not null default 1,
  created_at timestamptz not null default now()
);

-- 5. QUESTION BANK & MASTERY
--
-- Options are stored as four flattened columns (option_a..option_d +
-- correct_letter) rather than a normalized question_options table.
-- This matches how mathora-web/src/lib/supabase.ts,
-- mathora-mobile/src/services/supabaseService.ts, and the shared
-- Question/QuestionOption types (lib/types.ts) already read and
-- render questions across both apps — reconciling the schema to the
-- app's shape rather than the other way around, since the app's data
-- model spans every question-rendering page on web and mobile while
-- the schema was still unused by any live project.
create table public.questions (
  id uuid primary key default gen_random_uuid(),
  topic_id uuid references public.topics(id) on delete cascade not null,
  lesson_id uuid references public.lessons(id) on delete set null,
  question_text text not null,
  question_latex text,
  option_a text not null,
  option_b text not null,
  option_c text not null,
  option_d text not null,
  correct_letter char(1) not null check (correct_letter in ('A', 'B', 'C', 'D')),
  difficulty integer not null default 2 check (difficulty between 1 and 5),
  exam_type exam_type not null default 'GENERAL',
  explanation text not null,
  exam_shortcut text,
  created_at timestamptz not null default now()
);

create table public.attempts (
  id uuid primary key default gen_random_uuid(),
  student_id uuid references public.students(id) on delete cascade not null,
  question_id uuid references public.questions(id) on delete cascade not null,
  topic_id uuid references public.topics(id) on delete cascade not null,
  selected_option char(1) not null check (selected_option in ('A', 'B', 'C', 'D')),
  is_correct boolean not null,
  time_taken_seconds integer not null default 0,
  rescue_mode_triggered boolean not null default false,
  attempted_at timestamptz not null default now()
);

create table public.topic_mastery (
  id uuid primary key default gen_random_uuid(),
  student_id uuid references public.students(id) on delete cascade not null,
  topic_id uuid references public.topics(id) on delete cascade not null,
  mastery_percentage numeric(5,2) not null default 0.00,
  total_attempted integer not null default 0,
  total_correct integer not null default 0,
  updated_at timestamptz not null default now(),
  unique (student_id, topic_id)
);

-- 6. TEACHER CLASSES & ASSIGNMENTS
create table public.classes (
  id uuid primary key default gen_random_uuid(),
  teacher_id uuid references public.teachers(id) on delete cascade not null,
  name text not null,
  class_level class_level not null default 'SS2',
  join_code text not null unique,
  created_at timestamptz not null default now()
);

create table public.class_students (
  class_id uuid references public.classes(id) on delete cascade not null,
  student_id uuid references public.students(id) on delete cascade not null,
  joined_at timestamptz not null default now(),
  primary key (class_id, student_id)
);

create table public.assignments (
  id uuid primary key default gen_random_uuid(),
  class_id uuid references public.classes(id) on delete cascade not null,
  topic_id uuid references public.topics(id) on delete cascade not null,
  title text not null,
  question_count integer not null default 5,
  due_date timestamptz not null,
  created_at timestamptz not null default now()
);

create table public.assignment_submissions (
  id uuid primary key default gen_random_uuid(),
  assignment_id uuid references public.assignments(id) on delete cascade not null,
  student_id uuid references public.students(id) on delete cascade not null,
  score numeric(5,2) not null default 0.00,
  completed boolean not null default false,
  submitted_at timestamptz not null default now(),
  unique (assignment_id, student_id)
);

-- 7. ENABLE ROW LEVEL SECURITY
do $$ declare t text; begin
  for t in select unnest(array[
    'users', 'students', 'teachers', 'curricula', 'topics', 'lessons',
    'worked_examples', 'questions', 'attempts',
    'topic_mastery', 'classes', 'class_students', 'assignments', 'assignment_submissions'
  ]) loop
    execute format('alter table public.%I enable row level security', t);
  end loop;
end $$;

-- RLS POLICIES
--
-- NOTE: the policies below only check auth.role() = 'authenticated',
-- i.e. "is anyone logged in" — not "is this the caller's own row".
-- They are placeholders so the schema is runnable on its own.
-- mathora_schema_auth_patch.sql MUST be run immediately after this
-- file (same project) — it drops every policy below and replaces it
-- with ownership-scoped ones (a student only sees their own data, a
-- teacher only their own classes, a parent only their own child) plus
-- the handle_new_user() signup trigger and current_student_id() /
-- current_teacher_id() helpers those policies depend on. Do not run
-- this schema against a live project without immediately following it
-- with the patch.
create policy "users_select_all" on public.users for select using (auth.role() = 'authenticated');
create policy "users_update_own" on public.users for update using (auth.uid() = id);

create policy "students_read" on public.students for select using (auth.role() = 'authenticated');
create policy "teachers_read" on public.teachers for select using (auth.role() = 'authenticated');

create policy "content_read_public" on public.curricula for select using (true);
create policy "topics_read_public" on public.topics for select using (true);
create policy "lessons_read_public" on public.lessons for select using (true);
create policy "worked_examples_read_public" on public.worked_examples for select using (true);
create policy "questions_read_public" on public.questions for select using (true);

create policy "attempts_insert_student" on public.attempts for insert with check (auth.role() = 'authenticated');
create policy "attempts_select_own" on public.attempts for select using (auth.role() = 'authenticated');

create policy "topic_mastery_all" on public.topic_mastery for all using (auth.role() = 'authenticated');
create policy "classes_all" on public.classes for all using (auth.role() = 'authenticated');
create policy "class_students_all" on public.class_students for all using (auth.role() = 'authenticated');
create policy "assignments_all" on public.assignments for all using (auth.role() = 'authenticated');
create policy "assignment_submissions_all" on public.assignment_submissions for all using (auth.role() = 'authenticated');

-- ------------------------------------------
-- MASTERY AUTO-UPDATE
-- topic_mastery has no client-facing INSERT/UPDATE policy in the
-- patch (clients can only SELECT it) — it's derived, not authored.
-- This trigger recomputes it from attempts as they're inserted, using
-- attempts.topic_id directly rather than joining through questions.
-- ------------------------------------------

create or replace function public.update_topic_mastery()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.topic_mastery (student_id, topic_id, total_attempted, total_correct, mastery_percentage, updated_at)
  values (
    new.student_id,
    new.topic_id,
    1,
    case when new.is_correct then 1 else 0 end,
    case when new.is_correct then 100.00 else 0.00 end,
    now()
  )
  on conflict (student_id, topic_id) do update set
    total_attempted = public.topic_mastery.total_attempted + 1,
    total_correct = public.topic_mastery.total_correct + (case when new.is_correct then 1 else 0 end),
    mastery_percentage = round(
      (public.topic_mastery.total_correct + (case when new.is_correct then 1 else 0 end))::numeric
      / (public.topic_mastery.total_attempted + 1) * 100,
      2
    ),
    updated_at = now();

  return new;
end;
$$;

drop trigger if exists on_attempt_recorded on public.attempts;
create trigger on_attempt_recorded
  after insert on public.attempts
  for each row execute function public.update_topic_mastery();
