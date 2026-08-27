-- ==========================================
-- MATHORA — Screen Capture Reporting Patch
-- Run after mathora_schema_auth_patch.sql (needs current_teacher_id()).
--
-- Supports mathora-mobile/src/hooks/useBlockScreenCapture.ts, whose
-- own doc comment has the full platform explanation. Short version:
-- Android's FLAG_SECURE (set via expo-screen-capture) genuinely
-- BLOCKS both screenshots and screen recording — no logging is needed
-- there because the capture never produces usable content. iOS has no
-- public API to block a screenshot; it can only be detected after the
-- fact, which is what this table records — a deterrent and a
-- visibility tool for teachers, not a technical prevention.
-- ==========================================

create table if not exists public.screenshot_events (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade not null,
  screen text not null, -- e.g. 'practice', 'mock_exam'
  created_at timestamptz not null default now()
);

alter table public.screenshot_events enable row level security;

-- Insert-only from the client, and only your own events — this table
-- is a report, not a chat log; there's nothing to read back as a
-- student, only something to see as a teacher.
drop policy if exists "screenshot_events_insert_own" on public.screenshot_events;
create policy "screenshot_events_insert_own" on public.screenshot_events for insert
  with check (user_id = auth.uid());

-- A teacher can see screenshot attempts from students in their own
-- classes — the actual "here's who tried to leak a question" view.
drop policy if exists "screenshot_events_select_teacher" on public.screenshot_events;
create policy "screenshot_events_select_teacher" on public.screenshot_events for select
  using (
    user_id in (
      select s.user_id from public.students s
      join public.class_students cs on cs.student_id = s.id
      join public.classes c on c.id = cs.class_id
      where c.teacher_id = public.current_teacher_id()
    )
  );
