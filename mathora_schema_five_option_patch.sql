-- ==========================================
-- MATHORA: Questions, support a 5th option (A-E)
-- Run after mathora_schema.sql (any time before the SS1 question bank
-- is seeded; it needs this column to exist for the ~40% of curated
-- questions that come as 5-option WAEC-style MCQs).
--
-- mathora_schema.sql's `questions` table hardcodes exactly four options
-- (option_a..option_d) and a correct_letter check constrained to
-- 'A'..'D'. The curated SS1-SS3 exercise bank (SS1-SS3_MATHEMATICS_CURATED.md)
-- has a substantial share of genuine 5-option WAEC/NECO past questions;
-- trimming those to 4 would mean silently rewriting real exam options
-- rather than preserving them as set. option_e is nullable, so every
-- existing 4-option question (and any future one) is unaffected. The
-- frontend (mathora-web, mathora-mobile) renders however many of A..E
-- are non-null.
-- ==========================================

alter table public.questions
  add column if not exists option_e text;

alter table public.questions
  drop constraint if exists questions_correct_letter_check;
alter table public.questions
  add constraint questions_correct_letter_check
  check (correct_letter in ('A', 'B', 'C', 'D', 'E'));

-- A question whose correct_letter is 'E' must actually have an option_e
-- (catches a seeding mistake immediately rather than as a silent bad UI).
alter table public.questions
  drop constraint if exists questions_option_e_required_if_correct;
alter table public.questions
  add constraint questions_option_e_required_if_correct
  check (correct_letter <> 'E' or option_e is not null);

-- attempts.selected_option needs the same extension so a student can
-- actually record picking E.
alter table public.attempts
  drop constraint if exists attempts_selected_option_check;
alter table public.attempts
  add constraint attempts_selected_option_check
  check (selected_option in ('A', 'B', 'C', 'D', 'E'));
