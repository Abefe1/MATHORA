# API_MAP.md — D Companion Web Platform

All endpoints verified from actual source files.

---

## 1. Next.js API Route Handlers

### POST `/api/daily/create-room`
- **File:** `route.ts` (root) → target: `app/api/daily/create-room/route.ts`
- **Auth:** None (server-side DAILY_API_KEY)
- **Request body:** `{ name: string }`
- **Response:** Daily.co room object `{ id, name, url, ... }`
- **Room config:** expires 2 hours, max 50 participants, cloud recording, chat enabled, hand-raising enabled
- **Error:** `{ error: string }` with Daily.co status code

---

### POST `/api/daily/token`
- **File:** `mnt/.../app/api/daily/token/route.ts`
- **Auth:** None (server-side DAILY_API_KEY)
- **Request body:** `{ roomName: string, isOwner?: boolean, userName: string }`
- **Response:** `{ token: string }`
- **Token config:** Valid 3 hours; owner tokens enable cloud recording; non-owner tokens disable recording
- **Role distinction:** `isOwner: true` → teacher (can mute/kick); `isOwner: false` → student
- **Error:** `{ error: string }`

---

### POST `/api/paystack/verify`
- **File:** `mnt/.../app/api/paystack/verify/route.ts`
- **Auth:** None (server-side PAYSTACK_SECRET_KEY)
- **Request body:** `{ reference: string, payment_id: string }`
- **Process:**
  1. GET `https://api.paystack.co/transaction/verify/{reference}`
  2. If verified: `supabase.from('payments').update({ status: 'paid' }).eq('id', payment_id)`
- **Response:** `{ success: true }` or `{ error: 'Payment verification failed' }` (400)
- **Note:** Uses Supabase server client (service role via cookies)

---

### POST `/api/assignment-aid`
- **File:** `mnt/.../app/api/assignment-aid/route.ts`
- **Auth:** None
- **Request body:** `{ mode: 'text' | 'image', text?: string, image?: string }`
  - `image` is a base64 data URL (`data:image/jpeg;base64,...`)
- **Process:** Calls Anthropic `claude-opus-4-5` with structured system prompt
- **Response:** Parsed JSON `{ problem: string, steps: string[], answer: string, tips: string }`
- **Error:** `{ error: string }` (500) — no fallback to Gemini/Groq
- **System prompt:** Instructs Claude to act as Nigerian secondary school math tutor; respond only as JSON
- **Note:** No rate limiting, no auth — any caller can use this endpoint

---

## 2. Supabase Direct Client Calls (not API routes)

These happen directly in client components via `createClient()`:

### Authentication
- `supabase.auth.signInWithPassword({ email, password })` — in `actions.ts` (server)
- `supabase.auth.signUp({ email, password, options: { data: { name, role } } })` — in `actions.ts`
- `supabase.auth.signOut()` — in `actions.ts` + `AuthContext.tsx`
- `supabase.auth.getSession()` — in `AuthContext.tsx`
- `supabase.auth.getUser()` — in `middleware.ts`
- `supabase.auth.onAuthStateChange()` — in `AuthContext.tsx`
- `supabase.auth.updateUser({ password })` — in `SettingsPage.tsx`

### Users Table
- `supabase.from('users').select('*').eq('id', userId).single()` — AuthContext
- `supabase.from('users').select('role').eq('id', user.id).single()` — middleware, actions
- `supabase.from('users').update({ name, phone }).eq('id', profile.id)` — SettingsPage
- `supabase.from('users').insert({ id, name, email, phone, role })` — signUp action

### Role-Specific Tables
- `supabase.from('students').insert({ user_id, class })` — signUp
- `supabase.from('teachers').insert({ user_id, subject, experience_years, hourly_rate, verified: false })` — signUp
- `supabase.from('parents').insert({ user_id, phone })` — signUp
- `supabase.from('progress').insert({ student_id })` — signUp (empty progress row)

### Lessons / Uploads
- `supabase.from('uploads').select('id, name, type, url, topic, uploaded_at, teachers(users(name))').order('uploaded_at', { ascending: false })` — StudentLessonsPage

### Sessions (Live Classes)
- `supabase.from('sessions').insert({ teacher_id, title, date, live_link, type: 'live' })` — TeacherLivePage

### Payments
- `supabase.from('parents').select('id').eq('user_id', profile.id).single()` — ParentPaymentsPage
- `supabase.from('payments').select('id, amount, status, description, date, teachers(users(name))').eq('parent_id', parentData.id).order('date', { ascending: false })` — ParentPaymentsPage
- `supabase.from('payments').update({ status: 'paid' }).eq('id', payment_id)` — `/api/paystack/verify`

---

## 3. External API Calls

### Daily.co REST API
- Base URL: `https://api.daily.co/v1`
- Auth: `Bearer ${DAILY_API_KEY}` (server-side only)
- Endpoints used:
  - `POST /rooms` — create room
  - `POST /meeting-tokens` — issue token

### Paystack API
- Base URL: `https://api.paystack.co`
- Auth: `Bearer ${PAYSTACK_SECRET_KEY}` (server-side only)
- Endpoints used:
  - `GET /transaction/verify/{reference}` — verify payment

### Anthropic API
- SDK: `@anthropic-ai/sdk`
- Auth: `ANTHROPIC_API_KEY`
- Model: `claude-opus-4-5`
- Method: `anthropic.messages.create()`

### Paystack Inline JS (Client-Side)
- Script: `https://js.paystack.co/v1/inline.js` — loaded dynamically via DOM
- Usage: `window.PaystackPop.setup({ key, email, amount, currency, ref, metadata, onClose, callback })`
- Called from: `ParentPaymentsPage`

---

## 4. Authentication / Session Handling

- Supabase cookies-based session (set by `@supabase/ssr` in middleware)
- Middleware refreshes session cookies on every request
- Server actions use `@supabase/ssr` createServerClient
- Client components use `@supabase/supabase-js` createClient
- Auth token: stored in browser cookies (managed by Supabase)

---

## 5. Identified Issues

| Issue | Detail |
|-------|--------|
| No auth on API routes | `/api/daily/*`, `/api/paystack/verify`, `/api/assignment-aid` are open to any caller |
| No rate limiting | `lib/rateLimit.ts` referenced in HANDOVER but not present |
| No input validation | `lib/validate.ts` referenced in HANDOVER but not present |
| No AI fallback | Route uses only Anthropic; Gemini/Groq fallback not implemented |
| Contact form not wired | Currently mocks send with `setTimeout`; no `/api/contact` route exists |
| Notification toggle not persisted | Settings UI only — preferences not saved to DB |
