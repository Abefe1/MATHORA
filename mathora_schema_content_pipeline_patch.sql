-- ==========================================
-- MATHORA — Content Ingestion Pipeline Patch
-- Run after mathora_schema.sql + mathora_schema_auth_patch.sql.
--
-- Supports: teacher/admin uploads a PDF/DOCX -> content-worker/ parses
-- it (Docling) and asks an LLM to generate questions/worked_examples
-- matching this schema's exact column shape -> writes them in as
-- status='draft' -> an admin reviews and approves before students
-- ever see them.
--
-- IMPORTANT: this is the piece that makes AI-generated content safe.
-- Before this patch, questions_read_public / worked_examples_read_public
-- were `using (true)` — ANY row, published or not, was publicly
-- readable. Adding a status column without fixing those policies would
-- have made unreviewed AI-generated drafts visible to students
-- immediately. Fixed below.
-- ==========================================

-- ------------------------------------------
-- 1. STATUS ON CONTENT TABLES
-- Existing rows (seed data, manually-authored content) default to
-- 'published' so nothing already live gets hidden by this migration.
-- ------------------------------------------

alter table public.questions
  add column if not exists status text not null default 'published'
  check (status in ('draft', 'published', 'rejected'));

alter table public.worked_examples
  add column if not exists status text not null default 'published'
  check (status in ('draft', 'published', 'rejected'));

create index if not exists questions_status_idx on public.questions (status);
create index if not exists worked_examples_status_idx on public.worked_examples (status);

-- Fix the public-read policies: published-only for everyone; an
-- uploader (or any content/academic admin) can also see their own
-- pending drafts to review them.
drop policy if exists "questions_read_public" on public.questions;
create policy "questions_read_published_or_own_draft" on public.questions for select
  using (
    status = 'published'
    or exists (
      select 1 from public.users u
      where u.id = auth.uid() and u.role in ('content_admin', 'academic_admin', 'super_admin', 'teacher')
    )
  );

drop policy if exists "worked_examples_read_public" on public.worked_examples;
create policy "worked_examples_read_published_or_own_draft" on public.worked_examples for select
  using (
    status = 'published'
    or exists (
      select 1 from public.users u
      where u.id = auth.uid() and u.role in ('content_admin', 'academic_admin', 'super_admin', 'teacher')
    )
  );

-- Approve/reject: content/academic admins only. (The content-worker
-- itself writes drafts using the service-role key, which bypasses RLS
-- entirely — these policies are for the review UI's client-side
-- update call.)
create policy "questions_review_by_admin" on public.questions for update
  using (
    exists (
      select 1 from public.users u
      where u.id = auth.uid() and u.role in ('content_admin', 'academic_admin', 'super_admin')
    )
  );

create policy "worked_examples_review_by_admin" on public.worked_examples for update
  using (
    exists (
      select 1 from public.users u
      where u.id = auth.uid() and u.role in ('content_admin', 'academic_admin', 'super_admin')
    )
  );

-- ------------------------------------------
-- 2. CONTENT UPLOADS
-- One row per uploaded file, tracking it through the pipeline. The
-- content-worker updates `status` and `error_message` as it goes;
-- the admin UI polls/subscribes to this row to show progress.
-- ------------------------------------------

create table if not exists public.content_uploads (
  id uuid primary key default gen_random_uuid(),
  uploaded_by uuid references auth.users(id) on delete set null,
  topic_id uuid references public.topics(id) on delete set null,
  original_filename text not null,
  storage_path text not null, -- path within the 'content-uploads' Storage bucket
  requested_question_count integer not null default 10 check (requested_question_count between 1 and 50),
  status text not null default 'pending'
    check (status in ('pending', 'parsing', 'generating', 'ready_for_review', 'published', 'failed')),
  error_message text,
  generated_question_ids uuid[] not null default '{}',
  generated_worked_example_ids uuid[] not null default '{}',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.content_uploads enable row level security;

create index if not exists content_uploads_status_idx on public.content_uploads (status);

drop policy if exists "content_uploads_select_own_or_admin" on public.content_uploads;
create policy "content_uploads_select_own_or_admin" on public.content_uploads for select
  using (
    uploaded_by = auth.uid()
    or exists (
      select 1 from public.users u
      where u.id = auth.uid() and u.role in ('content_admin', 'academic_admin', 'super_admin')
    )
  );

drop policy if exists "content_uploads_insert_teacher_or_admin" on public.content_uploads;
create policy "content_uploads_insert_teacher_or_admin" on public.content_uploads for insert
  with check (
    uploaded_by = auth.uid()
    and exists (
      select 1 from public.users u
      where u.id = auth.uid() and u.role in ('teacher', 'content_admin', 'academic_admin', 'super_admin')
    )
  );
-- No client-facing UPDATE policy: only the content-worker (service-role
-- key, bypasses RLS) advances `status`/writes generated ids/logs errors.
-- This prevents a teacher from e.g. hand-editing their own upload's
-- status to 'published' and skipping review.

-- ------------------------------------------
-- 3. STORAGE BUCKET + POLICIES
-- Run the bucket creation from the Supabase dashboard (Storage ->
-- New bucket -> name it exactly "content-uploads", private) or via
-- the SQL below if you have the storage schema's insert privilege.
-- Policies are on storage.objects, scoped by the bucket_id and the
-- first path segment being the uploader's own auth.uid() (i.e. files
-- must be stored as `content-uploads/<uploader-uid>/<filename>`).
-- ------------------------------------------

insert into storage.buckets (id, name, public)
values ('content-uploads', 'content-uploads', false)
on conflict (id) do nothing;

drop policy if exists "content_uploads_storage_insert_own" on storage.objects;
create policy "content_uploads_storage_insert_own" on storage.objects for insert
  with check (
    bucket_id = 'content-uploads'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "content_uploads_storage_select_own_or_admin" on storage.objects;
create policy "content_uploads_storage_select_own_or_admin" on storage.objects for select
  using (
    bucket_id = 'content-uploads'
    and (
      (storage.foldername(name))[1] = auth.uid()::text
      or exists (
        select 1 from public.users u
        where u.id = auth.uid() and u.role in ('content_admin', 'academic_admin', 'super_admin')
      )
    )
  );
-- No client-facing delete/update storage policy — the content-worker
-- (service-role) is the only thing that needs to read an uploaded
-- file back out to parse it; nothing should be mutating it afterward.
