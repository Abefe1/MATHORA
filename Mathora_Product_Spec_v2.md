# Mathora — Product Spec (Rebuilt)

*A Nigerian Mathematics learning & mastery platform, built from a concerned Teacher's Experience.*

This document rebuilds `Gamified_Mathematics_Learning_Platform_Features(3).md` into something buildable: deduplicated, prioritized into phases, and separated into "build now" vs "backlog." The original file is left untouched as a reference brainstorm — this is the working spec.

---

## 1. Positioning

Not: *"An app for learning mathematics."*

> **Mathora — a Nigerian Mathematics learning & mastery platform that connects students, teachers, parents and schools around one curriculum-based system.**

**Tagline:** Understand. Solve. Master.

Start with Mathematics + Further Mathematics (the founder's direct subject expertise). Architecture should separate the *learning engine* from *subject content*, so Physics/Chemistry/Biology/English can be added later without a rebuild.

---

## 2. Core Learning Loop (the one idea everything else serves)

```
Student attempts a question
        ↓
System analyses the mistake (not just right/wrong)
        ↓
Identifies the misunderstanding / missing prerequisite
        ↓
Re-explains simply, with a worked example
        ↓
Guided practice
        ↓
Exam shortcut / technique (where relevant)
        ↓
Independent mastery check (later, not immediately)
        ↓
Scheduled revision (spaced repetition)
        ↓
Retention measured → learning path updates
```

Everything in this spec is in service of this loop. If a proposed feature doesn't feed it, it's a nice-to-have, not core.

**Three abilities the platform builds, in order:** Understand → Solve → Solve Efficiently (the last one is exam technique, and it's optional/secondary to genuine understanding).

---

## 3. Roles

```
Student → Group Admin → Teacher → School Admin → Platform Admin → Site Owner
```

Admin is **not** one role — split by function so nobody has more access than their job needs:

| Role | Manages |
|---|---|
| Super Admin | Everything |
| Content Admin | Lessons, questions, curriculum, explanations |
| Academic Admin | Teachers, classes, curriculum, assessments |
| Support Admin | Complaints, account issues, reports |
| Finance Admin | Payments, subscriptions, invoices |
| Moderator | Reports, community, user behaviour |

Groups (student-created accountability squads) are **separate from teacher-owned classes** — a student can be in a teacher's class and in a self-organized WAEC study group at the same time.

---

## 4. Phase 1 — MVP

**Goal:** prove students learn better with this than without it, in real secondary school classrooms, before building anything else.

### Student
- Lessons with simplified explanations
- Step-by-step worked examples
- Quiz per topic, with solutions shown on failure
- Basic mastery indicator per topic (%, not yet predictive)
- Content organised by class → curriculum → topic (aligned to the textbooks actually in use)

### Teacher
- Create a class, add/invite students
- Create assignments (topic, question count, deadline)
- See class performance by topic (simple table, not full analytics yet)

### Admin
- Manage users, curriculum, questions, content
- Basic usage stats (active users, questions answered)

### Explicitly deferred out of MVP
Voice narration, streaks/XP, notifications system, diagnostic assessment, personalised learning paths, groups, parent accounts, BECE/SSCE dedicated tracks, exam-shortcut library. These are real, but each is weeks of build/design work that isn't needed to answer the only question that matters first: **do students who use this improve faster than students who don't?**

**Rationale:** the original doc's own closing principle says *"build the smallest version that can prove students actually learn better, rather than the largest version possible from day one."* The MVP list in the source doc didn't follow that principle — this one does.

---

## 5. Phase 2 — Once MVP is validated with real classes

Add, roughly in this order:

1. **Diagnostic assessment on join** → auto-generates a personalised starting path (strong/average/weak per topic)
2. **Streaks, XP, badges** — separate from mastery %, framed explicitly as "XP is fun; mastery is the real goal"
3. **Notification system** — start narrow: streak-at-risk, assignment due, weak-topic reminder. Let students pick a time window (morning/afternoon/evening/custom/off) rather than guessing.
4. **Voice narration** — play/pause/speed controls on explanations; Nigerian-English voice option later
5. **Groups** — student-created accountability squads, group admin tools, group challenges/progress bars
6. **Parent accounts** — calm, non-gamified dashboard: mastery %, weekly change, study time, one "needs attention" topic, teacher's note. Parents don't need to see every question.
7. **School administration** — org structure (departments → classes), bulk CSV student import, school-wide analytics
8. **BECE/SSCE dedicated tracks** — exam countdown, mock-exam engine (timer, flag question, auto-submit, topic-by-topic result breakdown)
9. **Exam-technique layer** — after-answer shortcut, common-trap warnings, "show me the faster method" button, multiple solution methods where relevant. This is a real differentiator, but it depends on Phase 1's question-authoring pipeline already existing.
10. **Spaced revision scheduling** (Day 1 → 3 → 7 → 14 → 30) — needs mastery-check data from Phase 1/2 to work at all

---

## 6. Phase 3 — Once the platform has real usage data

- Predicted examination readiness score
- Concept dependency map (prerequisite-aware remediation: "you're struggling with quadratics because of a factorisation gap")
- Teacher intervention recommendations ("reteach X, assign Y, reassess in 48h")
- "Why Am I Struggling?" — signature feature, analyses last N questions and names the *specific* recurring error (e.g. sign errors when expanding brackets), not just the topic
- Question quality monitoring + AI-assisted content generation (draft → human review → approve → publish, never auto-publish AI content)
- Difficulty auto-calibration from real performance data
- Live class integration, teacher voice recordings, verified teacher profiles
- Handwritten working recognition (photo of working → identifies where the method broke)
- School licensing, sponsored-access model, competitions
- Multi-subject expansion (Physics, Chemistry, Biology, English)

Everything here is legitimate — none of it belongs in the first 12 months.

---

## 7. Cross-Cutting Constraints (apply from day one, not bolted on later)

These aren't features to schedule — they're design constraints that get expensive to retrofit if ignored early.

- **Nigerian connectivity/cost reality:** offline lesson download + local sync queue, low-data mode (compressed audio, Wi-Fi-only downloads, low-res diagrams). Don't build the online-only version first and "add offline later" — that's usually a rewrite, not an add-on.
- **Minors on the platform:** student-to-student messaging off or heavily restricted by default; any peer-mentor or discussion feature needs moderation, reporting, and parent/school controls *before* launch, not after an incident.
- **Copyright:** textbook content and past exam questions must only be reproduced/adapted where you hold the rights or a lawful basis. Build the content pipeline to distinguish licensed/original questions from anything else from day one — retrofitting rights-tracking onto an existing question bank is painful.
- **Accessibility:** adjustable font size, screen-reader support, captions on audio, don't rely on colour alone for status (⚠️/🟢 symbols alongside colour, not instead of).
- **Audit logs:** once more than one admin type exists (Phase 2+), log who changed what and when. Cheap to add early, expensive to reconstruct retroactively.

---

## 8. Architecture Sketch

```
                    PLATFORM OWNER
                          │
              ┌───────────┴───────────┐
            ADMINS                 CONTENT
              │                       │
      ┌───────┼────────┐              │
   Schools  Teachers  Moderators      │
      │        │                     │
      │      Classes                 │
      └────────┼─────────────────────┘
               │
            STUDENTS
           /         \
   Teacher Class   Independent
          │             │
          └──────┬──────┘
                 │
          ACCOUNTABILITY GROUPS
                 │
             Group Admin
```

**Learning engine (subject-agnostic core):**

```
Curriculum → Topics → Lessons → Examples → Questions
    → Assessment → Mistake Analysis → Mastery
    → Personalised Recommendation → Revision
```

Keep this engine separate from Mathematics-specific content so other subjects can plug in later.

---

## 9. Brand (condensed — revisit after MVP validates, not before)

- **Name:** Mathora (top pick; runner-ups: Numera, Mathwise) — **check CAC/business-name, domain, app-store and trademark availability before committing.**
- **Tagline:** Understand. Solve. Master.
- **Colours:** Indigo `#4338CA` primary, Cyan `#06B6D4` secondary/interactive, Amber `#F59E0B` for XP/rewards, Green `#16A34A` success, Red `#DC2626` error, `#F8FAFC` light bg / `#0F172A` dark bg.
- **Typography:** Inter for UI, a proper math-typesetting renderer for equations (not plain text).
- **Tone:** modern + academic + energetic — not a cartoonish kids' app, not a dry admin tool. Duolingo's engagement + Khan Academy's credibility, own identity.
- **Nigerian identity:** carried through curriculum, word-problem context ("A trader in Lagos…"), and teacher voices — not through decorative visual patterning.
- **Core nav (mobile):** Home · Learn · Practice · Progress · Profile — resist the urge to add more top-level tabs as features grow.

---

## 10. Before Writing Code

1. Confirm the MVP scope in §4 with 2–3 teacher colleagues — cut further if it still feels big.
2. Pick the actual textbook(s)/curriculum for one class (e.g. SS2 Mathematics) to seed content — don't try to cover all classes at once.
3. Define the data model for: user/role, class, topic/question/lesson, attempt, mastery score.
4. Decide the stack (web-first PWA is the pragmatic choice given the offline/low-data constraints and avoids app-store friction for a v1 pilot).
5. Build, then pilot with real secondary school students before touching Phase 2.

---

## What changed from the original file

- Cut from ~50 numbered feature sections down to 3 phases + constraints, removing near-duplicate content (the "learning loop," architecture diagram, and competitive-advantage list each appeared twice in the source).
- Moved voice narration, notifications, streaks/XP, diagnostics, and groups out of MVP into Phase 2 — the source listed all of these in v1, which is too much to build before validating the core loop with real students.
- Pulled Nigerian-connectivity, minor-safety, copyright, and accessibility concerns into one "constraints" section instead of leaving them scattered as isolated feature ideas — these need to shape the MVP's architecture now, not get added post-launch.
- Compressed the branding/design section, since it's premature relative to validating the product.

---

## 11. Additional Suggestions (beyond the original brainstorm)

1. **NDPR compliance.** Nigeria has its own data protection law (Nigeria Data Protection Act 2023, enforced by the NDPC) — the local equivalent of GDPR/COPPA. Most users are minors, so consent flow, data retention, and parental-consent design need to be decided before launch, not retrofitted. Same category as the copyright/safeguarding points in §7.

2. **WhatsApp as a first-class notification channel, not just push.** WhatsApp penetration in Lagos is far higher and more trusted than app push notifications, especially for parents. A "streak at risk" push competes with muted notifications; a WhatsApp message gets read. Consider it the primary parent channel in Phase 2, not an afterthought to push.

3. **Validate the content model before building a CMS.** Draft the first 50–100 questions for one topic in a spreadsheet with a fixed schema before investing in a full admin authoring UI. Proves the data model works and gives the MVP real content on day one without waiting on tooling. (See §12 below.)

4. **Consider a pre-software pilot.** Run the diagnostic + a week of practice questions through Google Forms/Typeform + WhatsApp for one class, manually, before writing product code. Tests whether the *pedagogy* (rescue mode, mistake explanations, spaced revision) actually moves scores — the real risk — before spending engineering time.

5. **Use a pilot class and a control class.** To credibly claim "students using Mathora improved faster," compare against a control group from the start, not just before/after on self-selected opted-in users.

---

## 12. Question Database: Spreadsheet vs Supabase

**Answer: both — spreadsheet for authoring, Supabase for serving. Not either/or.**

### Why not spreadsheet-as-database long-term
- No real query performance at scale, no relational integrity (a question referencing a deleted topic silently breaks), no concurrent-write safety, no row-level security to gate what students/teachers/admins can each see or edit.
- Google Sheets has an API and *can* be queried live, but wasn't built for it — rate limits and latency show up fast under real traffic, and every relationship (question → topic → curriculum) has to be maintained by hand.

### Why not Supabase-only from day one
- Hand-typing rows into Postgres, or building an admin UI, before you have real content is wasted motion. Authoring in a spreadsheet is faster for a non-technical content workflow: bulk entry, copy-paste from existing materials, easy review by other teachers.

### The actual pipeline
1. **Author in Google Sheets** with a fixed schema: `topic, subtopic, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, difficulty, exam_type, tags`. This is the Phase 1 content pipeline — cheap, fast, no code required to contribute.
2. **Import into Supabase (Postgres)** as the system of record the app actually queries — via a script (Sheets API → Supabase insert) or manual CSV import to start.
3. **Supabase is what the live app reads/writes** — student attempts, mastery scores, teacher assignments all need real relational data and real-time sync, which a spreadsheet cannot support.
4. Later (Phase 2/3 — see the Draft → Review → Test → Approve → Publish workflow), replace the spreadsheet step with a proper in-app admin UI once the schema is stable and volume makes spreadsheet-editing the bottleneck.

---

## 13. Recommended Tech Stack

Chosen for: solo/small-team founder, Nigerian connectivity constraints, need to move fast and cheap, and a multi-role/multi-tenant data model.

| Layer | Recommendation | Why |
|---|---|---|
| Frontend | Next.js (React) + TypeScript, built as a PWA | One codebase for web + installable mobile-like experience; avoids app-store friction for MVP |
| Styling | Tailwind CSS + shadcn/ui | Fast, consistent UI without a design team |
| Backend/DB | **Supabase** (Postgres + Auth + Storage + Edge Functions) | Row-level security maps naturally onto the role hierarchy (student/teacher/school/admin); generous free tier |
| Auth | Supabase Auth (email/phone + magic link) | Handles multi-role login cleanly via RLS policies |
| Math rendering | KaTeX | Fast, lightweight, renders equations properly instead of plain text |
| Hosting | Vercel (frontend) + Supabase (backend) | Simple CI/deploy story, minimal ops overhead |
| Offline support | Service worker + IndexedDB (e.g. Dexie.js) for cached lessons, plus a `sync_queue` table in Postgres | Matches the offline/low-data requirement (§7) from day one instead of retrofitting |
| Voice/TTS | Pre-recorded audio (own/colleague's voice) in Supabase Storage for MVP; evaluate Azure/Google Neural TTS or ElevenLabs for Phase 2 scale | Live TTS cost adds up fast; Nigerian-accented options are still limited; pre-recorded is cheaper and higher quality for a small question set |
| Payments | Paystack or Flutterwave (not Stripe) | Local cards, bank transfer, USSD support; better conversion for Nigerian users |
| SMS/WhatsApp | Termii or Africa's Talking | Nigeria/Africa-focused providers, cheaper than Twilio for this market |
| Email | Resend or Postmark | Simple transactional email for receipts, weekly reports |
| Analytics | PostHog | Product analytics + feature flags in one tool, generous free tier |
| Error tracking | Sentry | Standard, free tier sufficient at MVP scale |
| Mobile (later) | Expo/React Native reusing the same business logic | Build native apps only once the PWA validates demand |

**Why this combo:** near-zero infrastructure cost until there's real usage, offline/low-data support built in rather than bolted on, Supabase's row-level security absorbs most of the multi-role access-control work, and Paystack/Termii instead of Stripe/Twilio materially improve conversion and cost per user in this market.

---

## 14. Relationship to D Companion

An existing project, **D Companion** (`dcompanion-web` + `dcompanion-mobile`, in this same workspace), already runs a closely related stack: Next.js 14 + Supabase + Vercel, role-based auth (student/teacher/parent/admin), Paystack payments, an AI assignment-help solver (Claude/Gemini/Groq fallback), live classes via Daily.co, push notifications, and offline mobile caching. It's currently framed as a tutor-hire marketplace with debt tracking, not a curriculum-mastery platform.

**Decision: Mathora will be built as its own standalone codebase for now.** Not a module inside D Companion, not a shared repo. D Companion is left untouched. Absorbing Mathora into D Companion (or vice versa) is a decision to revisit later, once Mathora has been piloted and its product shape is proven — not before.

**What this means practically:**
- New, separate repository/repositories for Mathora (e.g. `mathora-web`, later `mathora-mobile`) — no code sharing, no shared database, no shared Supabase project with D Companion.
- Free to make schema and product decisions purely for Mathora's mastery-learning model without contorting D Companion's tutor-marketplace tables (`payments` as debt, `rooms`/`sessions` as live-class groups, etc.) to fit.
- Deliberately keep the same technology choices (Next.js, Supabase, Vercel, Paystack) as D Companion anyway — not because they're shared now, but because it keeps a future merge *possible* without a rewrite, if that turns out to be the right call later. This is a "stay compatible, don't couple" approach.
- Nothing here blocks reusing *patterns* from D Companion (its auth/RLS setup, middleware role-redirects, Paystack integration approach) as a reference while building Mathora — copying a working pattern into a new codebase is fine; sharing one codebase between two different products right now is what's being avoided.

### Immediate next steps
1. Create a new Supabase project for Mathora (separate from D Companion's).
2. Scaffold a new Next.js app (`mathora-web`) — reuse D Companion's auth/RLS/middleware pattern as a reference, not as shared code.
3. Design the curriculum data model (`curricula → topics → lessons → questions → attempts`) — this is the core piece that doesn't exist anywhere yet and is unique to Mathora.
4. Seed content for one class/topic via the spreadsheet pipeline (§12) and import into the new Supabase project.
5. Build the Phase 1 MVP (§4) against this fresh schema.
