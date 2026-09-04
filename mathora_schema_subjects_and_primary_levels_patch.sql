-- ==========================================
-- MATHORA — Multi-subject & primary-level scaffolding
-- Run after mathora_schema.sql and every other existing patch.
--
-- MATHORA is launching as a Mathematics-only, JSS/SSS-only product,
-- but the plan is to expand to every subject and to primary ("basic")
-- levels once the math pilot in secondary schools validates the
-- model. Two structural gaps would block that expansion if left
-- until then:
--
--   1. `curricula.subject` is free text (default 'Mathematics') with
--      nothing to join against — there's no subjects table, so a
--      topic/lesson/question can't be reliably scoped or filtered by
--      subject, and the UI has no stable id/icon/color to key a
--      subject switcher on.
--   2. `class_level` is a Postgres enum containing only
--      JSS1-JSS3/SS1-SS3 — Postgres enums can only grow
--      (ALTER TYPE ... ADD VALUE), never be reordered or restructured,
--      so adding primary levels later, after real rows reference the
--      enum, is far more disruptive than adding them now while the
--      dataset is still math-and-secondary-only.
--
-- Both changes are purely additive: existing rows, RLS policies, and
-- every current app query (`select('*')`, no subject filter) keep
-- working unchanged. Nothing here requires touching page/component
-- code — it just stops the schema from having to be reworked when
-- the second subject or the first primary-level class actually ships.
-- ==========================================

-- ------------------------------------------
-- 1. SUBJECTS TABLE
-- ------------------------------------------
create table if not exists public.subjects (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,               -- e.g. 'Mathematics', 'English Language'
  code text not null unique,                -- short stable key, e.g. 'MTH', 'ENG' — safe for URLs/analytics
  icon text not null default 'BookOpen',    -- lucide icon name, mirrors topics.icon's convention
  color text,                               -- optional hex accent for a future subject switcher
  created_at timestamptz not null default now()
);

alter table public.subjects enable row level security;

drop policy if exists "subjects_read_public" on public.subjects;
create policy "subjects_read_public" on public.subjects for select using (true);

-- Seed the subjects that exist today (the live project has two
-- curricula: 'Mathematics' and 'Further Mathematics' — both are
-- seeded so the backfill below maps each curriculum to its actual
-- subject instead of collapsing Further Maths into Maths).
-- ON CONFLICT keeps this re-runnable.
insert into public.subjects (name, code, icon)
values
  ('Mathematics', 'MTH', 'Calculator'),
  ('Further Mathematics', 'FMT', 'Sigma')
on conflict (name) do nothing;

-- ------------------------------------------
-- 2. curricula.subject_id — normalize the existing free-text column
-- ------------------------------------------
alter table public.curricula
  add column if not exists subject_id uuid references public.subjects(id);

-- Backfill every existing curriculum from its legacy `subject` text.
-- Anything that doesn't match a seeded subject falls back to
-- Mathematics rather than being left null, since that's the only
-- subject this platform has ever actually served.
update public.curricula c
set subject_id = coalesce(
  (select s.id from public.subjects s where s.name = c.subject),
  (select s.id from public.subjects s where s.name = 'Mathematics')
)
where c.subject_id is null;

-- `subject` (text) is left in place, not dropped: it's still read as
-- a display fallback anywhere that hasn't been migrated to join
-- subjects, and dropping a live column is not worth the risk here.
-- New code should prefer subject_id -> subjects over this column.
comment on column public.curricula.subject is
  'Legacy free-text subject label. Prefer subject_id (-> public.subjects) for new code.';

create index if not exists curricula_subject_id_idx on public.curricula (subject_id);

-- ------------------------------------------
-- 3. class_level — extend the enum with primary levels
-- ------------------------------------------
-- Nigerian "basic education" runs Primary 1-6 before JSS1-3. Inserting
-- each PRI value immediately before 'JSS1', in ascending order, keeps
-- the enum's native ordering (and therefore plain `<`/`>`/ORDER BY)
-- correct: PRI1 < PRI2 < ... < PRI6 < JSS1 < JSS2 < JSS3 < SS1 < SS2 < SS3.
--
-- NOTE: run each ALTER TYPE ... ADD VALUE as its own statement/commit
-- (standard for a Supabase SQL editor run or a plain psql session).
-- Postgres forbids using a brand-new enum value in the same
-- transaction that added it, but nothing below does that.
alter type class_level add value if not exists 'PRI1' before 'JSS1';
alter type class_level add value if not exists 'PRI2' before 'JSS1';
alter type class_level add value if not exists 'PRI3' before 'JSS1';
alter type class_level add value if not exists 'PRI4' before 'JSS1';
alter type class_level add value if not exists 'PRI5' before 'JSS1';
alter type class_level add value if not exists 'PRI6' before 'JSS1';

-- Metadata the enum itself can't carry (a human-readable stage
-- grouping for dashboards/filters — "Primary" vs "Junior Secondary"
-- vs "Senior Secondary"). A function, not a table, so it can't drift
-- out of sync with the enum and needs no join for a simple lookup.
create or replace function public.class_level_stage(lvl class_level)
returns text
language sql
immutable
as $$
  select case
    when lvl::text like 'PRI%' then 'primary'
    when lvl::text like 'JSS%' then 'jss'
    else 'sss'
  end;
$$;
