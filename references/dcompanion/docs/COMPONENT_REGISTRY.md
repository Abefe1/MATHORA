# COMPONENT_REGISTRY.md — D Companion Web Platform

All components verified from actual source files.
Note: Component files currently sit at root level — target locations shown are the intended final paths.

---

## LAYOUTS

### DashboardShell
- **Current file:** `components/DashboardShell.tsx` (referenced by all pages; file not read — assumed to exist based on universal usage)
- **Purpose:** Master layout wrapper for all authenticated pages
- **Props:** `pageTitle: string`, `pageSubtitle: string`, `children: ReactNode`
- **Dependencies:** `Sidebar`, `Topbar`, AuthContext (via Sidebar)
- **Used by:** Every student/teacher/parent/admin page
- **RTL:** N/A
- **Extension notes:** Do not add role-specific logic here; keep it generic. Pass extra content via children only.

---

## NAVIGATION

### Sidebar
- **Current file:** `Sidebar.tsx` (root) → **target:** `components/Sidebar.tsx`
- **Purpose:** Role-aware left navigation with logo, user chip, nav links, settings, sign-out
- **Props:** None (reads context internally)
- **Dependencies:** `useAuth()` from AuthContext, `lucide-react`, `clsx`, `next/link`, `next/navigation`
- **Key internals:**
  - `navByRole` — hardcoded nav items per role (student/teacher/parent/admin)
  - `roleColor` — role → Tailwind bg class mapping
  - Active link detection via `usePathname()`
- **Used by:** `DashboardShell`
- **RTL:** N/A
- **Extension notes:**
  - To add a nav item: add entry to `navByRole[role]` array with `{ label, href, icon }`
  - Chat link missing for student/parent — add `{ label: 'Chat', href: '/chat', icon: MessageSquare }` to both
  - Do not hardcode role logic outside `navByRole`

---

## FORMS

### ContactForm
- **Current file:** `ContactForm.tsx` (root) → **target:** `components/ContactForm.tsx`
- **Purpose:** Shared contact/support form with role-aware topic dropdown
- **Props:** `role: 'student' | 'teacher' | 'parent'`
- **Dependencies:** `lucide-react`, local `useState`
- **Used by:** `/student/contact`, `/teacher/contact`, `/parent/contact`
- **RTL:** N/A
- **Extension notes:**
  - Contact submission is currently mocked (1.2s fake delay)
  - To wire real email: POST to `/api/contact` with subject + message (not yet built)
  - Add new topic options per role inside the `<select>` blocks

---

## SHARED SYSTEMS

### SettingsPage
- **Current file:** `SettingsPage.tsx` (root) → **target:** `components/SettingsPage.tsx`
- **Purpose:** Full settings UI — profile edit, password change, notification toggles
- **Props:** None (reads context internally)
- **Dependencies:** `useAuth()`, Supabase client, `lucide-react`, `DashboardShell`
- **Used by:** All role settings pages (`/student/settings`, `/teacher/settings`, `/parent/settings`, `/admin/settings`)
- **Key behaviour:**
  - Profile save: `supabase.from('users').update({ name, phone })`
  - Password change: `supabase.auth.updateUser({ password: newPwd })`
  - Notification toggles: UI only — not persisted to DB
- **RTL:** N/A
- **Extension notes:**
  - Notification preferences not saved — wire to `push_tokens` table or a `user_preferences` table
  - Email field is read-only (can't change email)

---

## HOOKS

### useDaily
- **Current file:** `useDaily.ts` (root) → **target:** `lib/daily/useDaily.ts`
- **Purpose:** Wrapper around Daily.co REST API + client SDK for live video
- **Returns:** `{ createRoom, joinRoom, leaveRoom, isJoined, isLoading, error, containerRef }`
- **Dependencies:** `@daily-co/daily-js` (dynamically imported), fetch to `/api/daily/create-room`
- **Used by:** `TeacherLivePage`, `StudentLivePage`
- **Key behaviour:**
  - `createRoom(sessionTitle)` → POST `/api/daily/create-room` → returns `{ id, name, url }`
  - `joinRoom(roomUrl, token, container)` → dynamically imports Daily SDK → creates iframe in container div
  - `leaveRoom()` → calls `callFrameRef.current?.leave()`
  - Daily.co SDK import is deferred to avoid SSR errors
- **RTL:** N/A
- **Extension notes:**
  - `containerRef` is returned but not used internally — consumer must pass `containerRef.current` to `joinRoom()`
  - `callFrameRef` is internal — do not expose
  - Do not add polling or timers here; Daily SDK fires events

---

## PAGES (Student)

### StudentLessonsPage
- **File:** `mnt/.../app/student/lessons/page.tsx`
- **Purpose:** Browse and open all teacher-uploaded lesson materials
- **Dependencies:** Supabase client, `DashboardShell`, `lucide-react`
- **Data:** Reads from `uploads` table with join to `teachers → users`
- **Features:** Topic filter, text search, image/video/PDF previews, external link open
- **RTL:** N/A

### StudentLivePage
- **File:** `mnt/.../app/student/live/page.tsx`
- **Purpose:** Join active Daily.co live sessions
- **Dependencies:** `useDaily`, AuthContext, Supabase client, `DashboardShell`

### StudentAssignmentAidPage
- **File:** `mnt/.../app/student/assignment-aid/page.tsx`
- **Purpose:** Text or image input → POST to `/api/assignment-aid` → display step-by-step solution
- **Dependencies:** `/api/assignment-aid`, Supabase client (save to `aid_history`), `DashboardShell`

### StudentPastQuestionsPage
- **File:** `mnt/.../app/student/past-questions/page.tsx`
- **Purpose:** WAEC/BECE MCQ practice with scoring
- **Note:** Questions are hardcoded (4 samples). No DB table yet.

### StudentTutorsPage
- **File:** `mnt/.../app/student/tutors/page.tsx`
- **Purpose:** Browse verified teachers; share with parent

---

## PAGES (Teacher)

### TeacherLivePage
- **File:** `mnt/.../app/teacher/live/page.tsx`
- **Purpose:** Start a Daily.co live session; embed video frame
- **Dependencies:** `useDaily`, AuthContext, Supabase client, `/api/daily/token`
- **Flow:** Enter title → createRoom → fetch owner token → insert `sessions` row → joinRoom
- **Note:** Web-only by design

### TeacherUploadPage
- **File:** `mnt/.../app/teacher/upload/page.tsx`
- **Purpose:** Drag-drop or click upload to Supabase Storage; insert into `uploads` table

### TeacherRoomsPage
- **File:** `mnt/.../app/teacher/rooms/page.tsx`
- **Purpose:** Create and manage student group rooms

### TeacherStudentsPage
- **File:** `mnt/.../app/teacher/students/page.tsx`
- **Purpose:** Roster of students with progress %, avg score, attendance rate, payment status

### TeacherAssessmentsPage
- **File:** `mnt/.../app/teacher/assessments/page.tsx`
- **Purpose:** Build MCQ quizzes and save to `teacher_assessments` table

### TeacherEarningsPage
- **File:** `mnt/.../app/teacher/earnings/page.tsx`
- **Purpose:** Payment history chart (Recharts) and Paystack payout

---

## PAGES (Parent)

### ParentPaymentsPage
- **File:** `mnt/.../app/parent/payments/page.tsx`
- **Purpose:** View debt/paid payments; initiate Paystack payment
- **Dependencies:** Paystack inline JS, `/api/paystack/verify`, AuthContext, Supabase client
- **Key:** Loads Paystack script dynamically via DOM; calls `PaystackPop.setup()`

### ParentProgressPage
- **File:** `mnt/.../app/parent/progress/page.tsx`
- **Purpose:** Child's progress bar charts, line charts, assessment history, grade

### ParentAttendancePage
- **File:** `mnt/.../app/parent/attendance/page.tsx`
- **Purpose:** Monthly grouped attendance records

### ParentTutorsPage
- **File:** `mnt/.../app/parent/tutors/page.tsx`
- **Purpose:** Browse verified teachers; hire tutor (records as debt in payments)

---

## PAGES (Admin)

### AdminUsersPage
- **File:** `mnt/.../app/admin/users/page.tsx`

### AdminVerifyPage
- **File:** `mnt/.../app/admin/verify/page.tsx`
- **Purpose:** Approve/reject teacher applications (sets `teachers.verified = true/false`)

### AdminSessionsPage
- **File:** `mnt/.../app/admin/sessions/page.tsx`

### AdminPaymentsPage
- **File:** `mnt/.../app/admin/payments/page.tsx`

---

## API ROUTE HANDLERS

### `/api/daily/create-room`
- **Current file:** `route.ts` (root) → **target:** `app/api/daily/create-room/route.ts`
- **Purpose:** Server-side Daily.co room creation with properties
- **Props (body):** `{ name: string }`
- **Returns:** Daily.co room object (`{ id, name, url, ... }`)

### `/api/daily/token`
- **File:** `mnt/.../app/api/daily/token/route.ts`
- **Purpose:** Issue Daily.co meeting token
- **Props (body):** `{ roomName, isOwner?, userName }`
- **Returns:** `{ token: string }`

### `/api/paystack/verify`
- **File:** `mnt/.../app/api/paystack/verify/route.ts`
- **Purpose:** Server-side Paystack verification + DB update
- **Props (body):** `{ reference, payment_id }`
- **Returns:** `{ success: true }` or `{ error }`

### `/api/assignment-aid`
- **File:** `mnt/.../app/api/assignment-aid/route.ts`
- **Purpose:** Send math problem to Anthropic Claude; return structured JSON solution
- **Props (body):** `{ mode: 'text'|'image', text?, image? }`
- **Returns:** `{ problem, steps[], answer, tips }`
- **Model:** `claude-opus-4-5`
- **Note:** No fallback — if Anthropic fails, returns 500
