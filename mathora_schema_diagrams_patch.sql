-- ==========================================
-- MATHORA — Real-Life Context & Animated Diagram Fields
-- Run after mathora_schema.sql (+ patches applied so far).
--
-- Adds the fields Stage 2 content generation needs: an explicit
-- real-life-scenario slot (not just buried in problem_statement text,
-- so the UI can badge it distinctly), and a diagram_type/diagram_data
-- pair that drives mathora-web's src/components/diagrams/ renderer.
--
-- diagram_type is intentionally a fixed enum, not free text — it must
-- match one of the components DiagramRenderer.tsx actually knows how
-- to draw. 'none' is a real, expected value for topics with no
-- natural visual (e.g. algebraic fraction simplification) — the
-- content-worker prompt is instructed not to force a diagram where
-- one doesn't help.
-- ==========================================

do $$ begin
  create type diagram_type as enum (
    'none',
    'number_line',
    'venn_diagram',
    'coordinate_plane',
    'triangle',
    'circle',
    'unit_circle',
    'bar_chart',
    'pie_chart',
    'image'
  );
exception when duplicate_object then null;
end $$;

alter table public.worked_examples
  add column if not exists real_life_context text,
  add column if not exists diagram_type diagram_type not null default 'none',
  add column if not exists diagram_data jsonb not null default '{}';

alter table public.questions
  add column if not exists diagram_type diagram_type not null default 'none',
  add column if not exists diagram_data jsonb not null default '{}';

-- ------------------------------------------
-- STORAGE: extracted diagram images
-- content-worker uploads figures it pulls out of an uploaded PDF/DOCX
-- here (see db.py's upload_extracted_image); ImageDiagram.tsx reads
-- them back via a plain public URL.
--
-- Deliberately public (not scoped like content-uploads' bucket): the
-- only content here is diagram images with no question text attached,
-- so a draft image being guessable before admin approval is a low-
-- value leak (a picture of a triangle in isolation reveals little),
-- and a public bucket avoids the complexity of signed-URL rotation
-- for something the images end up genuinely public for anyway once
-- the worked example/question is approved. Revisit if this pipeline
-- ever handles genuinely sensitive source material.
-- ------------------------------------------

insert into storage.buckets (id, name, public)
values ('lesson-diagrams', 'lesson-diagrams', true)
on conflict (id) do nothing;

-- No insert policy for authenticated users — only the content-worker
-- (service-role key, bypasses RLS) writes here.
drop policy if exists "lesson_diagrams_public_read" on storage.objects;
create policy "lesson_diagrams_public_read" on storage.objects for select
  using (bucket_id = 'lesson-diagrams');
