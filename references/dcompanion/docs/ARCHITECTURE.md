# ARCHITECTURE.md — D Companion Web Platform

---

## 1. Folder Structure (Intended vs Actual)

### Intended (per HANDOVER.md)
```
dcompanion-web/
├── app/
│   ├── layout.tsx              ← Root layout with AuthProvider
│   ├── page.tsx                ← Redirects to /login
│   ├── globals.css             ← Brand CSS + utility classes
│   ├── login/page.tsx
│   ├── register/page.tsx
│   ├── chat/page.tsx
│   ├── student/...
│   ├── teacher/...
│   ├── parent/...
│   ├── admin/...
│   └── api/
│       ├── assignment-aid/route.ts
│       ├── daily/create-room/route.ts
│       ├── daily/token/route.ts
│       └── paystack/verify/route.ts
├── components/
│   ├── Sidebar.tsx
│   ├── Topbar.tsx
│   ├── DashboardShell.tsx
│   ├── ContactForm.tsx
│   └── SettingsPage.tsx
├── lib/
│   ├── auth/AuthContext.tsx
│   ├── auth/actions.ts
│   ├── daily/useDaily.ts
│   ├── hooks/useSessionTimeout.ts
│   ├── supabase/client.ts
│   ├── supabase/server.ts
│   ├── env.ts
│   ├── rateLimit.ts
│   ├── types.ts
│   └── validate.ts
├── supabase/
│   ├── schema.sql
│   └── rls_upgrade.sql
├── middleware.ts
├── tailwind.config.ts
├── package.json
└── tsconfig.json
```

### Actual State of Repository
```
dcompanion-web/
├── app/
│   ├── layout.tsx              ← DEFAULT Next.js template (no AuthProvider)
│   ├── page.tsx                ← DEFAULT Next.js template (not redirecting)
│   ├── globals.css             ← DEFAULT Next.js CSS (no brand tokens)
│   └── favicon.ico
├── mnt/user-data/outputs/dcompanion-web/app/
│   ├── admin/payments/page.tsx
│   ├── admin/sessions/page.tsx
│   ├── admin/users/page.tsx
│   ├── admin/verify/page.tsx
│   ├── api/assignment-aid/route.ts
│   ├── api/daily/token/route.ts
│   ├── api/paystack/verify/route.ts
│   ├── parent/attendance/page.tsx
│   ├── parent/payments/page.tsx
│   ├── parent/progress/page.tsx
│   ├── parent/tutors/page.tsx
│   ├── register/page.tsx
│   ├── student/assignment-aid/page.tsx
│   ├── student/lessons/page.tsx
│   ├── student/live/page.tsx
│   ├── student/past-questions/page.tsx
│   ├── student/tutors/page.tsx
│   ├── teacher/assessments/page.tsx
│   ├── teacher/earnings/page.tsx
│   ├── teacher/live/page.tsx
│   ├── teacher/rooms/page.tsx
│   ├── teacher/students/page.tsx
│   └── teacher/upload/page.tsx
│
│ ← ROOT-LEVEL (misplaced — should be in components/ or lib/)
├── AuthContext.tsx              ← should be lib/auth/AuthContext.tsx
├── actions.ts                  ← should be lib/auth/actions.ts
├── Sidebar.tsx                 ← should be components/Sidebar.tsx
├── ContactForm.tsx             ← should be components/ContactForm.tsx
├── SettingsPage.tsx            ← should be components/SettingsPage.tsx
├── useDaily.ts                 ← should be lib/daily/useDaily.ts
├── schema.sql                  ← should be supabase/schema.sql
├── route.ts                    ← should be app/api/daily/create-room/route.ts
├── middleware.ts               ← CORRECT location
├── tailwind.config.ts          ← EXISTS but no brand tokens
├── package.json                ← correct dependencies
└── tsconfig.json
```

### ⚠️ Assembly Required
All page files in `mnt/user-data/outputs/dcompanion-web/` and root-level component files must be moved into the correct Next.js directories before the app will function.

---

## 2. Frontend Architecture

- **Framework:** Next.js 14 App Router
- **Rendering:** Server Components by default; `'use client'` for interactive components
- **Auth state:** React Context (`AuthContext.tsx`) — wraps all authenticated pages
- **Data fetching:** Direct Supabase client calls inside components (no React Query / SWR)
- **Layout pattern:** Every authenticated page wraps content in `<DashboardShell>`
- **Navigation:** `Sidebar.tsx` reads `profile.role` from AuthContext → renders role-specific nav

---

## 3. Backend Architecture

- **Supabase** handles all database + authentication (no custom Express/Node server)
- **Next.js API Routes** for third-party integrations only:
  - `/api/daily/create-room` — Daily.co room creation (server-side key)
  - `/api/daily/token` — Daily.co meeting token generation
  - `/api/paystack/verify` — Paystack payment verification
  - `/api/assignment-aid` — Anthropic Claude AI call

---

## 4. Navigation Structure

```
/ (root)           → redirects to /login  [NOT YET WIRED]
/login             → public
/register          → public
/student           → student dashboard
/student/lessons
/student/live
/student/past-questions
/student/assignment-aid
/student/analysis
/student/tutors
/student/contact
/student/settings
/teacher           → teacher dashboard
/teacher/live
/teacher/upload
/teacher/rooms
/teacher/students
/teacher/assessments
/teacher/earnings
/teacher/contact
/teacher/settings
/parent            → parent dashboard
/parent/progress
/parent/attendance
/parent/payments
/parent/tutors
/parent/contact
/parent/settings
/admin             → admin dashboard
/admin/users
/admin/verify
/admin/sessions
/admin/payments
/chat              → real-time chat [EXISTS but NOT in Sidebar nav]
```

Middleware enforces: unauthenticated → `/login`; wrong role path → correct dashboard.

---

## 5. Component Hierarchy

```
RootLayout (app/layout.tsx)
└── AuthProvider (AuthContext.tsx)
    └── [page content]
        └── DashboardShell (components/DashboardShell.tsx)
            ├── Sidebar (components/Sidebar.tsx)
            │   └── reads: useAuth() → profile.role
            ├── Topbar (components/Topbar.tsx)
            └── <main> — page-specific content
```

**Shared leaf components (no dedicated file — inline per page):**
- Stat cards, filter buttons, table rows, loading spinners

**Shared reusable components:**
- `ContactForm` — used by all roles' contact pages; accepts `role` prop
- `SettingsPage` — used by all roles' settings pages; reads from AuthContext

---

## 6. State Flow

See `STATE_FLOW.md` for full detail. Summary:
- Global auth state: React Context (AuthContext)
- Local UI state: `useState` inside each page component
- No global state library (no Zustand/Redux on web)

---

## 7. API Architecture

All API routes are Next.js Route Handlers under `app/api/`:

| Route | Method | Auth | Purpose |
|-------|--------|------|---------|
| `/api/daily/create-room` | POST | None (server key) | Create Daily.co room |
| `/api/daily/token` | POST | None (server key) | Issue Daily.co meeting token |
| `/api/paystack/verify` | POST | None | Verify Paystack payment server-side |
| `/api/assignment-aid` | POST | None | Anthropic Claude AI math solver |

**Note:** API routes have no auth middleware — any request can call them. Rate limiting is described in HANDOVER but `lib/rateLimit.ts` does not exist in the repo.

---

## 8. Authentication Flow

```
1. User submits login form
2. signIn() server action → supabase.auth.signInWithPassword()
3. Fetches role from public.users
4. redirect() to role dashboard
5. AuthContext on client: getSession() → fetchProfile() → sets user + profile state
6. middleware.ts: on every request → getUser() → profile role check → redirect if wrong path
```

**Sign-up flow:**
```
1. signUp() server action
2. supabase.auth.signUp() → creates auth.users entry
3. Insert into public.users (id, name, email, phone, role)
4. Insert into role-specific table (students / teachers / parents)
5. Students: also insert empty progress record
6. redirect() to role dashboard
```

---

## 9. Database Interaction Flow

- **Client-side pages:** Import `createClient()` from `@/lib/supabase/client` → direct `.from().select()` etc.
- **Server actions / API routes:** Import `createClient()` from `@/lib/supabase/server` → uses cookie-based session
- **Middleware:** Creates Supabase client inline using `@supabase/ssr` createServerClient

**No ORM** — raw Supabase query builder throughout.

---

## 10. Shared Utilities

| Utility | Location | Status |
|---------|----------|--------|
| Supabase browser client | `lib/supabase/client.ts` | Referenced but file absent |
| Supabase server client | `lib/supabase/server.ts` | Referenced but file absent |
| TypeScript types | `lib/types.ts` | Referenced (Role type used in actions.ts) |
| Env validation | `lib/env.ts` | Referenced in HANDOVER; file absent |
| Rate limiting | `lib/rateLimit.ts` | Referenced in HANDOVER; file absent |
| Input validation | `lib/validate.ts` | Referenced in HANDOVER; file absent |
| Session timeout hook | `lib/hooks/useSessionTimeout.ts` | Referenced in HANDOVER; file absent |

---

## 11. Styling System

- **Tailwind CSS** — utility-first
- **Brand color tokens** — defined in `tailwind.config.ts` as custom colors (NOT YET ADDED to config)
- **Custom utility classes** — `.card`, `.btn-primary`, `.btn-secondary`, `.stat-card`, `.nav-link`, `.animate-fade-up` (NOT YET in `globals.css`)
- **Font classes** — `font-display`, `font-body`, `font-700`, `font-800` referenced throughout (NOT YET in config)

**Required tailwind.config.ts additions:**
```js
colors: {
  'brand-blue':       '#42A5F5',
  'brand-blue-dark':  '#1565C0',
  'brand-blue-light': '#BBDEFB',
  'brand-blue-pale':  '#E3F2FD',
  'brand-green':      '#66BB6A',
  'brand-green-light':'#C8E6C9',
  'brand-navy':       '#1A2B4A',
  'brand-navy-light': '#2C3E6B',
}
```

---

## 12. Theme Architecture

- No dark mode implemented
- Single light theme with brand colors
- Role-based accent colors via `roleColor` map in Sidebar
- Background: `#F7FBFF` (brand-blue-pale equivalent)

---

## 13. RTL Architecture

**Not applicable.** English-only platform. No RTL support implemented or required.

---

## 14. Audio/Media Systems

- **Daily.co** — handles all audio/video for live classes via WebRTC iframe
- **Lesson materials** — PDFs/videos served directly from Supabase Storage URLs
- **Video player** — no custom player; videos open via `<a target="_blank">` or native `<video>` tag
- **Camera (Assignment Aid)** — web: uses `<input type="file" accept="image/*" capture="camera">`

---

## 15. Offline/Cache Systems

**Web:** None.

---

## 16. Error Handling Architecture

- API routes: `try/catch` → `NextResponse.json({ error: e.message }, { status: 500 })`
- Client pages: inline error state (`useState`) — shown as red alert banners
- Auth errors: returned from server actions as `{ error: string }` — shown in form UI
- Daily.co errors: `useDaily` exposes `error` string state

---

## 17. Dependency Relationships

```
Sidebar ──────────────── depends on: AuthContext (useAuth)
DashboardShell ────────── depends on: Sidebar, Topbar
All pages ─────────────── depend on: DashboardShell, AuthContext, Supabase client
TeacherLivePage ────────── depends on: useDaily, AuthContext, Supabase client
ParentPaymentsPage ─────── depends on: Paystack inline JS, /api/paystack/verify, Supabase client
StudentAssignmentAid ───── depends on: /api/assignment-aid
middleware.ts ──────────── depends on: Supabase server client, public.users table
actions.ts ─────────────── depends on: Supabase server client, public.users + role tables
```

---

## Tightly Coupled Systems

1. **middleware ↔ `public.users` table** — every request queries the DB for role; if table or connection fails, all routes break
2. **AuthContext ↔ `public.users`** — profile fetch on every auth state change
3. **TeacherLivePage ↔ useDaily ↔ Daily.co API** — session creation + join are tightly sequential

## Fragile Systems

1. **`app/layout.tsx`** — AuthProvider not yet wired; every authenticated page will break without it
2. **`tailwind.config.ts`** — brand classes not yet added; all UI will render broken without them
3. **`globals.css`** — `.card`, `.btn-primary`, etc. not defined; all styled components will break
4. **Paystack inline JS** — loaded dynamically via DOM script injection; fails silently if network slow

## Critical Production Systems

1. `middleware.ts` — route protection; must not be broken
2. `AuthContext.tsx` — global auth state; all pages depend on it
3. `schema.sql` — DB foundation; must be run in correct order with `rls_upgrade.sql`
4. `actions.ts` — signIn/signUp/signOut; auth entry points
