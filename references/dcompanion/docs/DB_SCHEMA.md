# DB_SCHEMA.md — D Companion Web Platform

Based on verified `schema.sql` at root of repository.

---

## 1. Tables Overview (15 tables)

| Table | Purpose |
|-------|---------|
| `users` | All user accounts (mirrors auth.users) |
| `students` | Student profiles |
| `teachers` | Teacher profiles |
| `parents` | Parent profiles |
| `parent_child` | Parent ↔ student link (many-to-many) |
| `rooms` | Teacher-created class groups |
| `room_students` | Room ↔ student membership |
| `sessions` | Live and recorded class sessions |
| `attendance` | Per-student session attendance |
| `progress` | Cumulative progress counters per student |
| `assessments` | Student assessment score records |
| `teacher_assessments` | Teacher-created MCQ quizzes |
| `assessment_submissions` | Student quiz submission + score |
| `payments` | Parent → teacher payment records |
| `uploads` | Teacher-uploaded lesson materials |

**Tables mentioned in HANDOVER but NOT in schema.sql:**
- `push_tokens` — for push notifications
- `aid_history` — AI assignment aid history
- `messages` — in-app chat
- `teacher_availability` — weekly schedule

---

## 2. Table Definitions

### `users`
```sql
id          uuid  PK → references auth.users(id) ON DELETE CASCADE
name        text  NOT NULL
email       text  NOT NULL
phone       text
role        text  NOT NULL CHECK (role IN ('student','teacher','parent','admin'))
avatar_url  text
created_at  timestamptz DEFAULT now()
```
**Notes:** `id` = Supabase auth UUID. Role enforced at DB level.

---

### `students`
```sql
id        uuid  PK DEFAULT gen_random_uuid()
user_id   uuid  UNIQUE → references users(id) ON DELETE CASCADE
class     text  NOT NULL  -- e.g. 'JSS1', 'SS3'
parent_id uuid  → references users(id)
age       int
```
**Notes:** `parent_id` is a direct FK to `users.id` (not `parents.id`) — this is a denormalized shortcut. The normalized path uses `parent_child`.

---

### `teachers`
```sql
id               uuid      PK DEFAULT gen_random_uuid()
user_id          uuid      UNIQUE → references users(id) ON DELETE CASCADE
subject          text      NOT NULL
experience_years int       DEFAULT 0
hourly_rate      numeric(10,2) NOT NULL DEFAULT 0
bio              text
verified         boolean   DEFAULT false
rating           numeric(3,1)
```

---

### `parents`
```sql
id      uuid  PK DEFAULT gen_random_uuid()
user_id uuid  UNIQUE → references users(id) ON DELETE CASCADE
phone   text  NOT NULL
```

---

### `parent_child`
```sql
parent_id   uuid → references parents(id) ON DELETE CASCADE
student_id  uuid → references students(id) ON DELETE CASCADE
PRIMARY KEY (parent_id, student_id)
```
**Notes:** Normalized many-to-many. `students.parent_id` is the denormalized version.

---

### `rooms`
```sql
id         uuid  PK DEFAULT gen_random_uuid()
teacher_id uuid  → references teachers(id) ON DELETE CASCADE
name       text  NOT NULL
created_at timestamptz DEFAULT now()
```

---

### `room_students`
```sql
room_id    uuid → references rooms(id) ON DELETE CASCADE
student_id uuid → references students(id) ON DELETE CASCADE
PRIMARY KEY (room_id, student_id)
```

---

### `sessions`
```sql
id               uuid  PK DEFAULT gen_random_uuid()
teacher_id       uuid  → references teachers(id) ON DELETE CASCADE
room_id          uuid  → references rooms(id)
title            text  NOT NULL
date             timestamptz NOT NULL DEFAULT now()
duration_minutes int   DEFAULT 60
live_link        text
type             text  DEFAULT 'live' CHECK (type IN ('live','recorded'))
created_at       timestamptz DEFAULT now()
```
**Notes:** `room_id` is nullable — sessions can exist without a room. `live_link` stores Daily.co room URL.

---

### `attendance`
```sql
id         uuid    PK DEFAULT gen_random_uuid()
student_id uuid    → references students(id) ON DELETE CASCADE
session_id uuid    → references sessions(id) ON DELETE CASCADE
present    boolean DEFAULT false
date       date    NOT NULL DEFAULT current_date
```

---

### `progress`
```sql
id               uuid  PK DEFAULT gen_random_uuid()
student_id       uuid  UNIQUE → references students(id) ON DELETE CASCADE
lessons_done     int   DEFAULT 0
chapters_done    int   DEFAULT 0
assessments_done int   DEFAULT 0
total_lessons    int   DEFAULT 100
total_chapters   int   DEFAULT 22
updated_at       timestamptz DEFAULT now()
```
**Notes:** UNIQUE on `student_id` — one row per student. Updated in place. `total_lessons` / `total_chapters` are hardcoded defaults.

---

### `assessments`
```sql
id         uuid         PK DEFAULT gen_random_uuid()
student_id uuid         → references students(id) ON DELETE CASCADE
topic      text         NOT NULL
score      numeric(5,2) DEFAULT 0
max_score  numeric(5,2) DEFAULT 100
date       date         DEFAULT current_date
```
**Notes:** Records individual test results. Has auto-increment trigger described in HANDOVER (in `rls_upgrade.sql` — file not in repo).

---

### `teacher_assessments`
```sql
id         uuid      PK DEFAULT gen_random_uuid()
teacher_id uuid      → references teachers(id) ON DELETE CASCADE
title      text      NOT NULL
topic      text      NOT NULL
questions  jsonb     NOT NULL DEFAULT '[]'
created_at timestamptz DEFAULT now()
```
**JSONB structure for `questions`:**
```json
[
  {
    "question": "...",
    "options": ["A", "B", "C", "D"],
    "correct": 0
  }
]
```

---

### `assessment_submissions`
```sql
id            uuid         PK DEFAULT gen_random_uuid()
assessment_id uuid         → references teacher_assessments(id) ON DELETE CASCADE
student_id    uuid         → references students(id) ON DELETE CASCADE
answers       jsonb        NOT NULL DEFAULT '[]'
score         numeric(5,2)
submitted_at  timestamptz  DEFAULT now()
```

---

### `payments`
```sql
id          uuid         PK DEFAULT gen_random_uuid()
parent_id   uuid         → references parents(id) ON DELETE CASCADE
teacher_id  uuid         → references teachers(id) ON DELETE CASCADE
amount      numeric(10,2) NOT NULL
status      text         DEFAULT 'pending' CHECK (status IN ('paid','pending','debt'))
description text
date        timestamptz  DEFAULT now()
```

---

### `uploads`
```sql
id          uuid    PK DEFAULT gen_random_uuid()
teacher_id  uuid    → references teachers(id) ON DELETE CASCADE
name        text    NOT NULL
size        bigint  NOT NULL
type        text    NOT NULL  -- MIME type
url         text    NOT NULL  -- Supabase Storage URL
topic       text    NOT NULL DEFAULT 'Other'
uploaded_at timestamptz DEFAULT now()
```

---

## 3. Relationships Diagram

```
auth.users (1)
    └── users (1)
            ├── students (1)
            │       ├── parent_child (M)────────── parents (1) ── users
            │       ├── room_students (M)────────── rooms (1) ── teachers
            │       ├── attendance (M)────────────── sessions (1) ── teachers
            │       ├── progress (1)
            │       ├── assessments (M)
            │       └── assessment_submissions (M) ── teacher_assessments ── teachers
            ├── teachers (1)
            │       ├── rooms (M)
            │       ├── sessions (M)
            │       ├── teacher_assessments (M)
            │       ├── uploads (M)
            │       └── payments (M) ── parents
            └── parents (1)
                    ├── parent_child (M)
                    └── payments (M)
```

---

## 4. RLS Policies (Current State)

From `schema.sql` — **development-only, permissive policies:**

| Table | Policy | Condition |
|-------|--------|-----------|
| `users` | SELECT | `auth.role() = 'authenticated'` |
| `users` | UPDATE | `auth.uid() = id` (own row only) |
| All other tables | ALL | `auth.role() = 'authenticated'` |

**These are NOT production-safe** — any authenticated user can read/write any row in most tables. `rls_upgrade.sql` (mentioned in HANDOVER) is needed but not present.

---

## 5. Auth-Related Structures

- `auth.users` — Supabase managed (email, hashed password, session tokens)
- `public.users` — application profile, mirrors `auth.users.id`
- Session: stored in browser cookies by `@supabase/ssr`

---

## 6. Missing Tables (Need to Create)

| Table | Purpose | When Needed |
|-------|---------|------------|
| `push_tokens` | Store Expo push tokens for web notifications | Email/push notifications |
| `aid_history` | Store AI assignment aid results | Already referenced in code |
| `messages` | In-app chat messages | Chat feature |
| `teacher_availability` | Weekly availability slots | Hire tutor availability display |
| `past_questions` | WAEC/BECE question bank | Replace hardcoded questions |

---

## 7. Storage Buckets (Supabase Storage)

Per HANDOVER (not verifiable from code alone):
- `lesson-materials` — public bucket for teacher uploads
- `avatars` — public bucket for profile pictures

---

## 8. Known Risks

| Risk | Detail |
|------|--------|
| Permissive RLS | All tables open to any authenticated user — students can read other students' data |
| `rls_upgrade.sql` missing | Production tightening not in repo |
| Denormalized `students.parent_id` | Duplicates `parent_child` relationship — can drift out of sync |
| `total_lessons/total_chapters` hardcoded | Progress % calculation depends on static defaults |
| No indexes | No explicit indexes defined beyond PKs and UNIQUEs |
| `questions` JSONB not validated | Schema doesn't enforce question structure |
| No `past_questions` table | Questions hardcoded in frontend |
| Missing tables | `push_tokens`, `aid_history`, `messages`, `teacher_availability` not in schema |
