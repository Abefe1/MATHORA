-- ==========================================
-- MATHORA — Topics: add `term` column
-- Run after mathora_schema.sql (before mathora_seed_topics_ss1_ss2_ss3.sql,
-- which sets this column on every row it inserts).
--
-- mathora_schema.sql's `topics` table has class_level (SS1/SS2/SS3)
-- but no way to express which of the three school terms a topic
-- belongs to. The WAEC-aligned SS1-SS3 syllabus is inherently
-- term-structured (see SYLLABUS/lagos_ss_syllabus_consolidated.md),
-- so this is needed to seed it correctly and to let the student UI
-- filter/pace by term later.
-- ==========================================

alter table public.topics
  add column if not exists term smallint check (term between 1 and 3);

-- Natural sort key for "all topics in this class, in syllabus order"
-- — order_index alone was already used for this but combining with
-- term makes the intent explicit and lets a (class_level, term)
-- filtered query stay correctly ordered.
create index if not exists topics_class_term_order_idx
  on public.topics (curriculum_id, class_level, term, order_index);

-- Lets the seed script use ON CONFLICT DO UPDATE — safe to re-run
-- after fixing a typo in the source data without creating duplicates.
create unique index if not exists topics_curriculum_class_term_order_uidx
  on public.topics (curriculum_id, class_level, term, order_index);
