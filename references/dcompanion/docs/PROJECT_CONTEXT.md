# PROJECT_CONTEXT.md — D Companion Web Platform

---

## 1. Full App Overview

D Companion is a mathematics learning platform for Nigerian secondary school students. It connects students, teachers, and parents through a web dashboard and a paired mobile app (React Native/Expo — separate repo: `dcompanion-mobile`).

---

## 2. Primary Purpose

Deliver structured maths education (JSS1–SS3, WAEC/BECE curriculum) via:
- Live video classes
- Uploaded lesson materials
- AI-powered assignment help
- MCQ past-question practice
- Teacher–parent payment and debt management

---

## 3. Target Users

| Role    | Description |
|---------|-------------|
| Student | JSS1–SS3 secondary school student |
| Teacher | Verified maths tutor running classes |
| Parent  | Pays fees, monitors child progress |
| Admin   | Platform operator — manages users and verifications |

---

## 4. User Roles

Four roles are enforced at DB level via `public.users.role` CHECK constraint:
`'student' | 'teacher' | 'parent' | 'admin'`

Admin role can only be set manually in Supabase:
```sql
update public.users set role = 'admin' where email = 'admin@email.com';
```

---

## 5. Main Features

### Student
- Dashboard grid (Lessons, Live, Assignment Aid, Past Questions, Hire Tutor, Analysis)
- Lesson browser (filtered by topic, search)
- Live class attendance via Daily.co WebRTC
- AI Assignment Aid: text or image → Claude AI → step-by-step solution
- Past questions: WAEC/BECE MCQ with scoring (currently hardcoded — 4 sample questions)
- Progress analysis charts (Recharts)
- Tutor browser

### Teacher
- Live Class Studio: create Daily.co room, go live, copy invite link (**web only — by design**)
- File upload to Supabase Storage (lessons)
- Student room management
- MCQ assessment builder
- Student roster with progress/payments
- Earnings dashboard

### Parent
- Child progress overview with debt alert banner
- Progress charts (bar + line)
- Attendance records
- Paystack payment / debt clearing
- Hire tutor (records as debt in `payments` table)
- Link child via 4-step phone flow

### Admin
- Platform overview (user counts, revenue)
- User management (search/filter/delete)
- Teacher verification (approve/reject)
- Session monitor
- Payment overview

### Shared
- In-app chat (`/chat` page — **not yet linked in Sidebar**)
- Contact forms (role-aware)
- Settings: profile edit, password change, notification toggles

---

## 6. Core Workflows

**Student login → dashboard → join live class:**
1. `/login` → `signIn()` server action → reads `users.role` → redirect `/student`
2. Student clicks Live Classes → `/student/live` → fetches active sessions
3. Joins Daily.co room via `useDaily.joinRoom()` → attendance auto-marked

**Teacher goes live:**
1. `/teacher/live` → enters session title → `createRoom()` → POST `/api/daily/create-room`
2. Fetches owner token via `/api/daily/token` (isOwner: true)
3. Session saved to `sessions` table → `useDaily.joinRoom()` embeds Daily iframe

**Parent pays debt:**
1. `/parent/payments` → loads Paystack inline JS → `PaystackPop.setup()` → opens iframe
2. On success: POST `/api/paystack/verify` → updates `payments.status = 'paid'`

---

## 7. Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Next.js 14 (App Router) |
| Styling | Tailwind CSS + custom brand tokens |
| Database/Auth | Supabase (PostgreSQL + RLS + Auth) |
| Live Video | Daily.co WebRTC (`@daily-co/daily-js`) |
| Payments | Paystack (NGN) |
| AI (Assignment Aid) | Anthropic Claude (`claude-opus-4-5`) |
| Charts | Recharts |
| Icons | Lucide React |
| Utilities | clsx, tailwind-merge |
| TypeScript | v5 |
| Hosting | Vercel (frontend) + Supabase (backend) |

---

## 8. Architecture Overview

- **Next.js App Router** — file-based routing under `app/`
- **Server Components** — default; client components marked `'use client'`
- **Server Actions** — `actions.ts` handles signIn/signUp/signOut (server-side Supabase)
- **Middleware** — `middleware.ts` protects all non-public routes; enforces role-based redirects
- **AuthContext** — client-side React context providing `user`, `profile`, `loading`, `signOut`
- **Supabase RLS** — row-level security on all 15 tables
- **API Routes** — `/api/daily/*` and `/api/paystack/*` and `/api/assignment-aid`

---

## 9. Current Implementation Status

### ⚠️ CRITICAL: Project Structure Is Unassembled

The HANDOVER.md describes a complete project, but the **actual files are NOT in the expected Next.js directory structure**. Specifically:

| What HANDOVER says | What actually exists |
|--------------------|---------------------|
| `components/Sidebar.tsx` | `Sidebar.tsx` at **root level** |
| `components/ContactForm.tsx` | `ContactForm.tsx` at **root level** |
| `components/SettingsPage.tsx` | `SettingsPage.tsx` at **root level** |
| `lib/auth/AuthContext.tsx` | `AuthContext.tsx` at **root level** |
| `lib/auth/actions.ts` | `actions.ts` at **root level** |
| `lib/daily/useDaily.ts` | `useDaily.ts` at **root level** |
| `supabase/schema.sql` | `schema.sql` at **root level** |
| `app/api/daily/create-room/route.ts` | `route.ts` at **root level** |
| `app/` pages (student/teacher/parent/admin) | Under `mnt/user-data/outputs/dcompanion-web/app/` |
| `app/layout.tsx` with AuthProvider | Default Next.js template (no AuthProvider) |
| `app/globals.css` with brand tokens | Default Next.js CSS (no brand utility classes) |
| `tailwind.config.ts` with brand colors | Default config (no brand color tokens) |

**Before any feature work, the project must be assembled** — files moved to correct directories, layout wired, Tailwind configured.

---

## 10. Existing Integrations

| Integration | Status | Notes |
|-------------|--------|-------|
| Supabase Auth + DB | Implemented | Schema SQL file exists but needs DB execution |
| Daily.co | Implemented | API routes + useDaily hook ready |
| Paystack | Implemented | Uses inline JS popup; server-side verify route ready |
| Anthropic Claude | Implemented | `claude-opus-4-5` model; no fallback in current route |
| Recharts | Dependency installed | Used in earnings/progress pages in mnt/ outputs |

**Note:** HANDOVER.md mentions a Gemini/Groq fallback chain but the actual `/api/assignment-aid/route.ts` only uses Anthropic. No fallback implemented.

---

## 11. Security Architecture

| Feature | Implemented |
|---------|-------------|
| Supabase RLS | `schema.sql` enables RLS on all tables; basic `authenticated` policies only |
| Production RLS | `rls_upgrade.sql` mentioned in HANDOVER but **not present in repo** |
| Middleware route protection | `middleware.ts` — verifies session + role on every request |
| Role-based redirects | middleware + `actions.ts` |
| Rate limiting | `lib/rateLimit.ts` mentioned but **file not present in repo** |
| Input validation | `lib/validate.ts` mentioned but **file not present in repo** |
| Env validation | `lib/env.ts` mentioned but **file not present in repo** |
| Session timeout hook | `lib/hooks/useSessionTimeout.ts` mentioned but **file not present in repo** |
| File upload validation | Mentioned in HANDOVER; no implementation file found |

---

## 12. Performance Considerations

- Daily.co SDK dynamically imported in `useDaily.ts` to avoid SSR issues
- Client components only where interactivity is required
- No caching layer implemented (web — mobile has AsyncStorage TTL cache)

---

## 13. Arabic/RTL-Specific Systems

**Not applicable.** D Companion is an English-language Nigerian maths platform. No Arabic or RTL support exists or is needed.

---

## 14. Offline Support Systems

**Web:** No offline support implemented.
**Mobile (separate repo):** AsyncStorage cache with 24hr TTL (`lib/cache.ts`).

---

## 15. Existing Conventions

- All client components start with `'use client'`
- Server actions in `actions.ts` start with `'use server'`
- Supabase browser client: `createClient()` from `@/lib/supabase/client`
- Supabase server client: `createClient()` from `@/lib/supabase/server`
- All pages wrapped in `<DashboardShell pageTitle="..." pageSubtitle="...">`
- Icons from `lucide-react` only
- Brand class names: `.card`, `.btn-primary`, `.btn-secondary`, `.stat-card`, `.nav-link` (defined in globals.css — **not yet implemented in current globals.css**)

---

## 16. Known Incomplete Systems

1. **Assessment submission flow** — students can't submit teacher-created quizzes
2. **Chat not in Sidebar** — `/chat` route exists but not linked in nav
3. **Teacher availability on hire page** — schedule table built, not shown to hirers
4. **Admin role creation UI** — manual SQL only
5. **Email notifications** — not implemented
6. **Recorded lessons video player** — upload works, no playback UI
7. **Past questions are hardcoded** — no DB table or admin UI
8. **Parent chat initiation** — no flow to start new conversation
9. **Teacher assessment results view** — no screen to see student submissions
10. **Mobile assignment aid history** — web done, mobile screen missing

---

## 17. Important Architectural Decisions

- **Teachers live on web only** — by design, for writing whiteboard efficiency
- **Students join Daily.co on mobile via WebView** — not native SDK
- **Paystack inline JS** — loaded dynamically via `<script>` tag, not npm package (web)
- **`users` table mirrors `auth.users`** — id is the Supabase auth UUID; profile data stored in `public.users`
- **Role-specific tables** (`students`, `teachers`, `parents`) extend `users` — look up by `user_id`
- **`progress` table has a unique constraint on `student_id`** — one record per student, updated in place
