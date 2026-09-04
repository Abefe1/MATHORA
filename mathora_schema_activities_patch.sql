-- ==========================================
-- MATHORA — Interactive activities (Educaplay-style practice games)
-- Run after mathora_schema.sql, mathora_schema_auth_patch.sql, and
-- mathora_schema_content_pipeline_patch.sql (reuses their status/RLS
-- conventions and current_student_id()/current_teacher_id() helpers).
--
-- Adds a second practice mode alongside MCQ `questions`: short
-- interactive activities (step ordering, matching pairs, fill-blank,
-- classification) scoped to a topic, same as lessons/worked_examples/
-- questions already are. `activity_data` is a single jsonb column
-- rather than one table per activity_type — new types are additive
-- (new activity_type value + a new activity_data shape the frontend's
-- ActivityPlayer knows how to render), never a schema change.
--
-- Deliberately subject-agnostic: everything hangs off topic_id, which
-- already carries subject (via curricula.subject_id) and class_level
-- — see mathora_schema_subjects_and_primary_levels_patch.sql. Nothing
-- here assumes Mathematics.
-- ==========================================

create table if not exists public.activities (
  id uuid primary key default gen_random_uuid(),
  topic_id uuid references public.topics(id) on delete cascade not null,
  activity_type text not null check (activity_type in ('ordering', 'matching', 'fill_blank', 'classify')),
  title text not null,
  instructions text,
  -- Shape depends on activity_type — see mathora-web/src/lib/types.ts
  -- ActivityData for the exact per-type contract the frontend expects:
  --   ordering:  { items: string[], correct_order: number[] }
  --   matching:  { pairs: { left: string, right: string }[] }
  --   fill_blank: { text: string, blanks: { token: string, answer: string }[] }
  --   classify:  { groups: string[], items: { text: string, group: string }[] }
  activity_data jsonb not null,
  -- Mirrors questions/worked_examples' status convention from
  -- mathora_schema_content_pipeline_patch.sql. Defaults to 'published'
  -- (not 'draft'): unlike AI-ingested content, activities are always
  -- directly authored by a teacher or admin for their own topic/class,
  -- same trust level as them creating a class or assignment directly.
  status text not null default 'published' check (status in ('draft', 'published', 'rejected')),
  created_by uuid references public.users(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists activities_topic_id_idx on public.activities (topic_id);
create index if not exists activities_status_idx on public.activities (status);

alter table public.activities enable row level security;

create policy "activities_read_published_or_own" on public.activities for select
  using (
    status = 'published'
    or created_by = auth.uid()
    or exists (
      select 1 from public.users u
      where u.id = auth.uid() and u.role in ('content_admin', 'academic_admin', 'super_admin')
    )
  );

create policy "activities_insert_teacher_or_admin" on public.activities for insert
  with check (
    created_by = auth.uid()
    and exists (
      select 1 from public.users u
      where u.id = auth.uid() and u.role in ('teacher', 'content_admin', 'academic_admin', 'super_admin')
    )
  );

create policy "activities_update_own_or_admin" on public.activities for update
  using (
    created_by = auth.uid()
    or exists (
      select 1 from public.users u
      where u.id = auth.uid() and u.role in ('content_admin', 'academic_admin', 'super_admin')
    )
  );

create policy "activities_delete_own_or_admin" on public.activities for delete
  using (
    created_by = auth.uid()
    or exists (
      select 1 from public.users u
      where u.id = auth.uid() and u.role in ('content_admin', 'academic_admin', 'super_admin')
    )
  );

-- ------------------------------------------
-- ACTIVITY ATTEMPTS — a student's play-through of one activity
-- Separate from `attempts` (MCQ-only, binary is_correct) since an
-- activity's grading is a 0-100 score (e.g. 4/5 pairs matched), not a
-- single right/wrong. Deliberately NOT wired into the topic_mastery
-- trigger yet — that trigger assumes attempts.is_correct's binary
-- shape; folding a percentage score into the same mastery number needs
-- its own weighting decision, left as a follow-up once activities have
-- real usage to weight against.
-- ------------------------------------------
create table if not exists public.activity_attempts (
  id uuid primary key default gen_random_uuid(),
  student_id uuid references public.students(id) on delete cascade not null,
  activity_id uuid references public.activities(id) on delete cascade not null,
  score numeric(5,2) not null default 0.00 check (score between 0 and 100),
  time_taken_seconds integer not null default 0,
  attempted_at timestamptz not null default now()
);

create index if not exists activity_attempts_student_id_idx on public.activity_attempts (student_id);
create index if not exists activity_attempts_activity_id_idx on public.activity_attempts (activity_id);

alter table public.activity_attempts enable row level security;

create policy "activity_attempts_insert_own" on public.activity_attempts for insert
  with check (student_id = public.current_student_id());

create policy "activity_attempts_select_own_or_related" on public.activity_attempts for select
  using (
    student_id = public.current_student_id()
    or student_id in (select id from public.students where parent_id = auth.uid())
    or student_id in (
      select cs.student_id from public.class_students cs
      join public.classes c on c.id = cs.class_id
      where c.teacher_id = public.current_teacher_id()
    )
  );
