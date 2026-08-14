# DO_NOT_BREAK.md — D Companion Web Platform

Critical systems that must not be regressed. Read this before modifying any of the listed files.

---

## 1. Authentication / Session Logic

**Files:** `middleware.ts`, `AuthContext.tsx`, `actions.ts`, `lib/supabase/client.ts`, `lib/supabase/server.ts`

**Fragility:**
- `middleware.ts` runs on every single request. Any syntax error or DB query failure blocks the entire app.
- `AuthContext.tsx` is the source of truth for `user` and `profile` in all client components. Breaking `fetchProfile()` or the auth listener makes every page render with null profile.
- `actions.ts` signIn/signUp/signOut are the only entry points into the system. Breaking redirects or role lookup locks users out.

**Dependencies:**
- `public.users` table must exist and be readable — middleware queries it on every request
- Supabase browser client from `@/lib/supabase/client` must be importable
- Supabase server client from `@/lib/supabase/server` must use `@supabase/ssr` correctly

**Regression risks:**
- Adding a new route without including it in `PUBLIC_ROUTES` → infinite redirect loop
- Changing the `users.role` column values → ROLE_PATHS map breaks
- Changing `dashboardMap` in `actions.ts` without updating `ROLE_PATHS` in middleware → role redirect mismatch
- Removing the `subscription.unsubscribe()` cleanup in AuthContext → memory leak + duplicate listeners

**Safe modification strategy:**
- Add new public routes to the `PUBLIC_ROUTES` array in `middleware.ts`
- Add new roles to both `ROLE_PATHS` (middleware) AND `dashboardMap` (actions.ts) simultaneously
- Never change the `users.role` CHECK constraint values without updating all role maps
- Test signIn, signUp, and signOut after any auth change

---

## 2. Subscription/Payment Systems

**Files:** `mnt/.../app/parent/payments/page.tsx`, `mnt/.../app/api/paystack/verify/route.ts`

**Fragility:**
- Paystack inline JS loaded dynamically. If script load fails silently, `window.PaystackPop` is undefined → `payNow()` shows an alert but doesn't fail gracefully in other paths.
- `payment_id` passed from client to `/api/paystack/verify`. If payment record is deleted between initiation and verification, the update is a no-op.

**Dependencies:**
- `PAYSTACK_SECRET_KEY` env variable must be set
- `NEXT_PUBLIC_PAYSTACK_PUBLIC_KEY` must be set on client
- `payments` table must have correct `status` enum values: `'paid'|'pending'|'debt'`

**Regression risks:**
- Changing `payments.status` DB enum → status badge styles break; filter logic breaks
- Removing Paystack script load from `useEffect` → `window.PaystackPop` never available
- Changing the verify endpoint URL → client hardcoded POST to `/api/paystack/verify`

**Safe modification strategy:**
- Test with Paystack test keys before any payment flow change
- Never change the payment `status` values without updating `statusStyles` map in ParentPaymentsPage
- `/api/paystack/verify` must always return `{ success: true }` or `{ error }` — don't change response shape

---

## 3. RTL Rendering

**Not applicable.** English-only platform. No RTL system to protect.

---

## 4. Navigation Architecture

**Files:** `middleware.ts`, `Sidebar.tsx`, `actions.ts`

**Fragility:**
- `ROLE_PATHS` in middleware must stay in sync with `navByRole` in Sidebar and `dashboardMap` in actions
- Sidebar reads `profile.role` from AuthContext — if role is null or unexpected value, nav renders empty

**Dependencies:**
- AuthContext must be mounted above Sidebar in component tree
- `navByRole` must have entries for all valid roles

**Regression risks:**
- Adding a new role without updating all three: `ROLE_PATHS`, `navByRole`, `dashboardMap` → new role gets lost
- Removing a nav item from `navByRole` without also removing the route → dead links in sidebar
- The `active` detection logic: `pathname === href || (href !== '/${role}' && pathname.startsWith(href))` — changing this breaks active state

**Safe modification strategy:**
- When adding a new page: add route, add to `navByRole`, test navigation
- When adding a new role: update middleware + actions + Sidebar + role colors + DashboardShell simultaneously

---

## 5. Database Assumptions

**Files:** `schema.sql`, all Supabase client calls throughout pages

**Fragility:**
- Entire app assumes `public.users.id = auth.users.id`
- Role-specific tables (`students`, `teachers`, `parents`) accessed via `user_id` FK
- `progress` table has a UNIQUE constraint on `student_id` — only one row per student; INSERT will fail if row already exists
- Supabase join syntax `.select('uploads, teachers(users(name))')` relies on exact FK relationships

**Dependencies:**
- Schema must be applied in exact order: `schema.sql` → `rls_upgrade.sql`
- Storage buckets (`lesson-materials`, `avatars`) must exist

**Regression risks:**
- Renaming any column → all `.select()` and `.update()` calls using that column name break
- Dropping a table → immediate runtime errors
- Changing the `role` CHECK values → middleware + actions break
- Changing JSONB structure for `teacher_assessments.questions` → assessment builder/renderer breaks

**Safe modification strategy:**
- Always add columns; never rename or drop without updating all client references
- Test all affected pages after schema changes
- Document migrations before executing them

---

## 6. Audio Synchronization

**Not applicable.** Audio system is Daily.co's embedded iframe — no custom synchronization code exists in this repo.

---

## 7. Offline / Cache Systems

**Not applicable on web.** No offline system on web.

---

## 8. Shared Global Utilities

**Files:** `AuthContext.tsx` (`useAuth`), `lib/supabase/client.ts`, `lib/types.ts`

**Fragility:**
- `useAuth()` is called in virtually every component. Changing the `AuthContextType` interface breaks all consumers.
- The `Role` type from `lib/types.ts` is used in `actions.ts`, `AuthContext`, and Sidebar. Changing it breaks the chain.

**Regression risks:**
- Removing `signOut` from context → Sidebar breaks
- Removing `profile` from context → Sidebar, SettingsPage, all pages break
- Changing `Profile` interface fields → TypeScript errors throughout

**Safe modification strategy:**
- Only add fields to `AuthContextType` and `Profile` — never remove existing fields
- If a field needs renaming, add the new name alongside the old until all consumers are updated

---

## 9. Global Components

**Files:** `DashboardShell.tsx`, `Sidebar.tsx`

**Fragility:**
- Every authenticated page renders inside `DashboardShell`. Changing its props interface without updating all callers → TypeScript errors on every page.
- `Sidebar` is the navigation backbone. Any error in Sidebar propagates to all authenticated pages.

**Regression risks:**
- Changing `pageTitle` or `pageSubtitle` prop names → every page import breaks
- Adding a required prop to `DashboardShell` → every existing page must be updated
- Breaking the `usePathname()` active detection in Sidebar → navigation looks broken

**Safe modification strategy:**
- Only add optional props to `DashboardShell`; never change required prop names
- Test Sidebar rendering with all four role types after any nav change

---

## 10. API Contracts

**Files:** All files under `app/api/` + their consumers

**Consumer ↔ API contracts that must not change:**

| Consumer | API | Expected Response Shape |
|----------|-----|------------------------|
| `useDaily.createRoom()` | POST `/api/daily/create-room` | `{ url: string, name: string, id: string }` |
| `TeacherLivePage` | POST `/api/daily/token` | `{ token: string }` |
| `ParentPaymentsPage` | POST `/api/paystack/verify` | `{ success: true }` or `{ error }` |
| `StudentAssignmentAidPage` | POST `/api/assignment-aid` | `{ problem, steps[], answer, tips }` |

**Regression risks:**
- Renaming `token` key in Daily token response → `TeacherLivePage` destructuring breaks
- Changing assignment-aid response structure → solution display UI breaks
- Changing verify response from `{ success: true }` to something else → client ignores it silently

**Safe modification strategy:**
- Never change response field names — add new fields alongside existing ones
- If response shape must change, update both the API route and all consumers simultaneously
