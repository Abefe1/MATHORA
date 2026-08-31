# MATHORA: continuation prompt (methodology + conventions established for SS1)

Paste this whole file as your first message in a new Claude Code session
(pointed at this repo directory) to continue the work below for a new
level/term without re-deriving any of it. Swap "SS1" for "SS2" or "SS3"
and adjust term/topic numbers as needed; everything else applies as-is.

## What this project is

MATHORA (brand name DCOMPANION) is a Nigerian secondary school Mathematics
learning platform: `mathora-web` (Next.js/Tailwind/Supabase), `mathora-mobile`
(Expo), and `content-worker` (a PDF-to-content ingestion pipeline). The
immediate goal across this whole thread of work: take the WAEC/NECO-aligned
SS1-SS3 Mathematics syllabus, curate it into rich lesson content with a real
step-by-step, glossary-aware, exam-ready teaching voice, and get it live in
the actual product (not just as demos), with a working score dashboard.

## Source of truth for content

`SS1-SS3_MATHEMATICS_CURATED.md` at the repo root already has ALL of SS1,
SS2, and SS3 core Mathematics curated, term by term, week by week, in this
shape per topic:
- **Teaching Notes**: definitions, formulas, and 1-3 fully worked examples,
  each with explicit **Step 1 - .../Step 2 - .../Answer:** labelled steps
  (no example skips straight to an answer).
- **⚡ Shortcut & Speed Tips**: genuine WAEC-style exam-speed techniques
  specific to that topic.
- **Gamified Exercise Bank**: every question found for that topic, numbered,
  with a verified answer (or explicitly marked "not given in source" only
  when genuinely unrecoverable).

This file was built and then revised through several fine-tuning passes;
apply the SAME fine-tuning when working on a level/term not yet done:
1. **No em dashes anywhere, ever.** Not in lesson content, not in SQL
   comments, not in code comments you write, not in generated distractors.
   Rewrite with periods/commas/colons. Check your own newly-written text
   specifically, quoted source text is usually already clean but anything
   you add (a distractor, an extra explanation) must be too.
2. **Multiple real-life examples per topic** (2-3, not 1), each grounded in
   something a Nigerian student recognizes (market trading, phone
   credit/data, transport fares, land measurement, school fees, sports,
   ₦ Naira amounts, etc.), not one token example.
3. **A beginner glossary** for genuinely new vocabulary (e.g. "magnitude",
   "significant figure") before it's used, in plain words with a concrete
   tiny example, not a formal definition alone.
4. **Speed tips placed directly under their own topic/subtopic**, not
   collected into one separate section at the end.
5. **Every worked example fully explained**: define terms as they're first
   used, show every algebraic step, never jump from problem to answer.
6. **Verify, don't trust, every stated answer.** Re-derive it yourself. The
   curated source itself has had errors caught and fixed this way multiple
   times (wrong AP/GP terms, a bad quadratic factorization, an OCR-corrupted
   equation, wrong option letters, an "always A" bug in a draft answer key).
   Fix what's wrong; flag (don't fabricate) what's genuinely unrecoverable.

## Three deliverable shapes built so far (in priority order for new work)

### 1. Platform integration (the real product), highest priority

This is what "adds it into the platform" means: real Supabase rows the
actual Next.js app renders, not a standalone demo page.

**Schema** (repo root `.sql` files, run in this order against a fresh DB):
`mathora_schema.sql` → `mathora_schema_auth_patch.sql` →
`mathora_schema_topics_term_patch.sql` → `mathora_schema_content_pipeline_patch.sql`
→ `mathora_schema_five_option_patch.sql` (adds a nullable `option_e` +
extends `correct_letter`/`selected_option` checks to A-E, since a real share
of curated WAEC questions are genuinely 5-option and should NOT be trimmed
to 4) → `mathora_seed_topics_ss1_ss2_ss3.sql` (topics for ALL of SS1-SS3
Mathematics AND Further Mathematics already exist here, do not re-create
topic rows, only reference them by subquery) → `mathora_seed_exemplar_lessons.sql`
(6 hand-verified topics, a style reference, don't duplicate its lesson rows).

**Seed content convention** (see `mathora_seed_ss1_term1_content.sql`,
`..._term2_content.sql`, `..._term3_content.sql` as the exact pattern to
replicate for a new level): one file per term, following
`mathora_seed_exemplar_lessons.sql`'s exact CTE SQL shape
(`with lesson as (insert into lessons ... returning id) insert into
worked_examples select id, ... from lesson`), topic lookup by subquery
(`select t.id from public.topics t join public.curricula c on c.id =
t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS2'
and t.term = 1 and t.order_index = 101`), never a hardcoded topic UUID. Per
topic: one `lessons` row (content_body = teaching notes as Markdown+LaTeX,
`$..$` inline math, NOT `\(..\)`), 2-4 `worked_examples` rows (solution_steps
as a jsonb array of full step strings, real_life_context, exam_shortcut
drawn from the speed tips, common_trap_warning where genuinely implied,
diagram_type/diagram_data only where a real shape exists per
`mathora-web/src/lib/diagramTypes.ts`, `status = 'published'`), and a
`questions` row for EVERY exercise-bank question for that topic (don't
sample, use them all): 5-option questions keep option_e as-is,
open-response questions get converted to 4-option MCQ with 3 genuinely
plausible wrong-answer distractors (common student errors, not random
numbers), correct_letter varied across A-D (not always the same slot),
difficulty estimated 1-5, exam_type 'WAEC' only if the curated file marks
it as a real past question else 'GENERAL', full explanation, status
'published'. Every currency example uses ₦.

**Score dashboard** (already fully built, reuse as-is, no changes needed
for a new level, it's level-agnostic): `mathora-web/src/lib/supabase.ts` has
`fetchTopicScores`, `fetchTermSummaries`, `fetchClassScoreSummary` (all
built on the existing `attempts`/`topic_mastery` tables plus `topics.term`,
no new schema needed). `/student/analysis` shows per-exercise and
per-term cumulative scores. `/teacher/class/[classId]/scores` shows
cumulative class scores, ranked. `/student/learn` and `/student/practice`
are wired to real Supabase data (`fetchTopics`/`fetchQuestions`/
`fetchWorkedExamples`), grouped into Term 1/2/3 tabs (topic count per level
is too large for a flat list), mobile-first (tabs scroll horizontally
rather than wrap). `DEFAULT_LEVEL` is currently hardcoded to `'SS1'` in both
files (`termOf()` helper derives term from `order_index`'s hundreds digit,
`101..1xx`=term 1 etc.), there's a TODO there to make it dynamic off the
student's own profile once auth exposes `current_level`, until then, if you
bring SS2 online, either add a level switcher or update the constant.

**Supabase access**: the hosted claude.ai connector only authorizes one
Supabase organization; MATHORA's real project needed a second path. See
`.mcp.json` at repo root, it references `${MATHORA_SUPABASE_PAT}` in a
`headers.Authorization` field for a `supabase` MCP server entry pointed at
`project_ref=gradrjyoknebmqhwwttv`. The actual PAT lives in the
repo-root `.env` (gitignored, never commit it). A NEW Claude Code session
started in this directory picks this up automatically at startup (MCP
servers load once at session start, an already-running session can't
hot-reload one). Verify with a Supabase MCP tool call (e.g. list projects)
before assuming you're connected, if you only see other people's unrelated
projects (not MATHORA), the connector isn't live yet, tell the user rather
than guessing.

**Known pitfalls hit while doing this for SS1** (avoid repeating):
- A background subagent claimed "done" without ever calling Write, always
  verify a file actually exists and is non-empty after a completion
  notification before trusting the summary.
- A background subagent accidentally emptied an unrelated file
  (`mathora_schema_five_option_patch.sql`) while inspecting it as a
  prerequisite. After any batch of parallel agent work, do a quick sweep
  (`wc -l` on every schema/seed file) to confirm nothing else got clobbered.
  Fix such a wipe by rewriting from the specification above, byte-for-byte
  where possible, rather than assuming it's unrecoverable.
- A background subagent hit a mid-task rate limit, wrote a premature
  "-- END-OF-FILE-MARKER" comment, and stopped after only 5 of 14 required
  topics. Always verify actual topic coverage (grep the expected
  `order_index` values) against the target count before trusting a
  "complete" claim, not just that the file exists.
- Parenthesis-balance checks on generated SQL must be quote-and-comment
  aware (naive `str.count('(') - str.count(')')` gives false positives from
  parens inside string literals or `--` comments); use a small stateful
  parser that tracks single-quote spans and skips `--`-to-end-of-line
  before counting.
- Running 3 large content-generation agents in parallel plus other
  foreground work burns through the session's rate limit fast, expect at
  least one round of hitting a limit and needing to resume agents after it
  resets; this is normal, not a sign something is broken.

### 2. The reference standalone Artifact ("Balancing the Signs" type)

One flagship week (SS1 First Term Week 1: directed numbers, BODMAS,
rounding, percentage error) was built as a full interactive Claude Artifact
demonstrating the fine-tuned design before committing to it everywhere.
Structure: topic-by-topic blocks (rule explanation → glossary as needed →
2-3 real-life examples → speed tips → worked example with a "Reveal next
step" click-through AND a "Watch & listen" Web-Speech-API narrated
walkthrough that auto-advances steps in sync with `speechSynthesis`), then
a 20-question gamified quiz with score/streak tracking in `localStorage`.
Visual design matches DCOMPANION's actual brand tokens (pulled from
`mathora-web/src/app/globals.css`, `Primitives.tsx`,
`mathora-mobile/src/constants/theme.ts`): Space Grotesk display / Plus
Jakarta Sans body / JetBrains Mono numerals, amber `#F59E0B`/`#D97706`
primary, emerald `#10B981` correct, rose `#F43F5E` incorrect, indigo
`#6366F1` secondary, light `#F8FAFC`/dark `#090D16` backgrounds, an
exercise-book graph-paper texture. This is a DEMO/PROOF artifact, not
itself "the platform", useful for design review before generating real
seed content, not a substitute for deliverable #1 above.

### 3. `content-motion`: narrated video-style lesson engine (separate track)

A prototype engine at `content-motion/` (modeled on a sibling project's
Quran-lesson video style): a fixed-timeline "video" built from HTML/CSS/JS
with real play/pause/scrub/speed/gender-voice controls, backed by real
audio files with a graceful caption-only fallback when audio is missing.
Read `content-motion/README.md` in full before touching this, it documents
the two lesson shapes (single worked example with a fixed STEP map, vs. a
full topic with a generic numbered "beat" timeline built from a richer
`LESSON` object), why it's built this way, and open next-steps. Visual
design was retrofitted to match DCOMPANION (was originally a
generic-blue/Baloo-2 borrowed look). Narration audio is generated via
Gemini TTS (`gemini-2.5-flash-preview-tts`, voices "Puck"=male/"Kore"=
female) using a key in `content-worker/.env` (`GEMINI_API_KEY`, gitignored)
and `content-motion/scripts/generate_tts.py` / `generate_topic_b.py`
(the latter is a per-lesson driver script, copy its pattern for a new
lesson's clip list). **Hard constraint**: Gemini's TTS free tier caps at
10 requests/day, a single topic-shaped lesson needs ~40 calls (20 clips x
2 voices), so full narration for many lessons requires either trickling
generation across many days, or enabling billing on that API key to remove
the cap, flag this to the user rather than assuming it's solvable in one
pass. This track is lower priority than #1, it's a nice narrated-video
extra, not where students actually see content day to day yet.

## What to actually do for a new level/term

1. Confirm the target level's exact topic list/order_index ranges from
   `mathora_seed_topics_ss1_ss2_ss3.sql` (grep `'SS2'` or `'SS3'`, note
   Mathematics is `curriculum_id ...0001`, Further Mathematics is
   `...0002`, this project's curated content is core Mathematics only).
2. Dispatch one background content-generation agent per term (matching the
   exact brief style used for SS1, adjust topic titles/order_index/term
   count per what you found in step 1), each producing one
   `mathora_seed_ss{N}_term{T}_content.sql` file, following every
   convention in section 1 above.
3. After each agent reports "complete", verify independently: file exists
   and is non-empty, topic coverage matches the expected count, em-dash
   count is zero, parens are balanced (quote/comment-aware).
4. Once verified, hand the files to a Supabase-connected session (or run
   them yourself if this session has that connection) in schema-then-seed
   order as listed in section 1.
5. If asked to also build the Artifact-style demo or a content-motion
   lesson for the new level, follow sections 2/3 the same way, they're
   independent of the seed-SQL work and can happen in parallel.
