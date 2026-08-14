# STATE_FLOW.md — D Companion Web Platform

---

## 1. Global State Systems

The web app has **one global state system**: React Context via `AuthContext.tsx`.

There is **no Zustand, Redux, or other global state library** on the web (Zustand is used in the mobile app only).

---

## 2. AuthContext — Global Auth State

**File:** `AuthContext.tsx` (root) → target: `lib/auth/AuthContext.tsx`

### State shape
```ts
{
  user: User | null         // Supabase auth user object
  profile: Profile | null   // Row from public.users table
  loading: boolean
  signOut: () => Promise<void>
}
```

### Profile shape
```ts
{
  id: string
  name: string
  email: string
  phone?: string
  role: 'student' | 'teacher' | 'parent' | 'admin'
  avatar_url?: string
}
```

### Initialization flow
```
1. Component mounts (AuthProvider)
2. supabase.auth.getSession() → sets user + triggers fetchProfile() → loading = false
3. supabase.auth.onAuthStateChange() subscribed → updates user/profile on any session change
4. On unmount: subscription.unsubscribe()
```

### fetchProfile()
```
supabase.from('users').select('*').eq('id', userId).single()
→ setProfile(data)
```

### signOut()
```
supabase.auth.signOut() → window.location.href = '/login'
```
Note: Uses `window.location.href` (hard reload), not `router.push()`. Clears all React state.

---

## 3. Local State Patterns

Every page manages its own local state via `useState`. Common patterns:

| Pattern | Pages using it |
|---------|---------------|
| `loading + data[]` | All data-fetching pages (lessons, payments, students, etc.) |
| `step: 'setup'\|'live'` | TeacherLivePage (setup → live state machine) |
| `paying: string\|null` | ParentPaymentsPage (tracks which payment is being processed) |
| `sending + sent` | ContactForm (tracks form submission state) |
| `saving + saved` | SettingsPage (profile save feedback) |
| `search + topic filter` | StudentLessonsPage |
| `error: string\|null` | useDaily hook, API calls |

No shared local state between pages. Each page is independent.

---

## 4. Authentication State Flow

```
User visits protected route
        ↓
middleware.ts: supabase.auth.getUser()
        ↓
No user → redirect /login
        ↓
User at /login → signIn() server action
        ↓
Supabase sets session cookies
        ↓
redirect() to role dashboard
        ↓
AuthProvider mounts on client
        ↓
getSession() resolves → fetchProfile() called
        ↓
profile.role available in all child components via useAuth()
```

---

## 5. Subscription State Flow

No subscription system implemented. The platform uses payments (one-off or per-session debt model), not recurring subscriptions.

---

## 6. Lesson Progress Flow

```
Student completes lesson/chapter (not yet tracked automatically)
        ↓
progress table: { lessons_done, chapters_done, assessments_done }
        ↓
Updated manually or via trigger (assessments_done has auto-increment trigger)
        ↓
ParentProgressPage / StudentAnalysisPage reads progress table
        ↓
Recharts renders bar/line charts
```

Auto-trigger (in `rls_upgrade.sql` per HANDOVER — file not present):
```sql
trigger: on_assessment_insert → increment_assessments_done()
```

---

## 7. Live Class State Flow (TeacherLivePage)

```
step = 'setup'
        ↓
Teacher enters session title → handleStart()
        ↓
createRoom() → POST /api/daily/create-room → roomUrl set
        ↓
fetch /api/daily/token (isOwner: true) → token received
        ↓
supabase.from('sessions').insert(...)
        ↓
step = 'live'
        ↓
joinRoom(roomUrl, token, containerRef.current) → Daily.co iframe rendered
        ↓
isJoined = true (via Daily 'joined-meeting' event)
        ↓
Teacher clicks End Session → leaveRoom() → step = 'setup'
```

**State in useDaily hook:**
```ts
isJoined: boolean
isLoading: boolean
error: string | null
callFrameRef: RefObject<any>  // Daily.co frame instance
```

---

## 8. Payment State Flow (ParentPaymentsPage)

```
Component mounts → fetchPayments() → payments[] loaded
        ↓
Paystack script loaded via DOM script tag
        ↓
User clicks Pay → payNow(payment)
        ↓
paying = payment.id  (disables button)
        ↓
PaystackPop.setup().openIframe() → Paystack modal opens
        ↓
User completes payment → callback(response)
        ↓
POST /api/paystack/verify { reference, payment_id }
        ↓
Server verifies → updates payments.status = 'paid'
        ↓
paying = null → fetchPayments() re-runs
```

---

## 9. Notifications State Flow

- **Push notifications:** Not implemented on web (implemented in mobile)
- **Notification toggles in SettingsPage:** Local state only — `notifEmail`, `notifClass` — not persisted

---

## 10. Cache / Persistence

- **Web:** No caching. All data fetched fresh on component mount.
- **Auth session:** Persisted via Supabase cookies (managed by `@supabase/ssr`)

---

## 11. Derived States

| Derived value | Source | Used in |
|---------------|--------|---------|
| `totalDebt` | `payments.filter(p => p.status !== 'paid').reduce(sum of amount)` | ParentPaymentsPage |
| `totalPaid` | `payments.filter(p => p.status === 'paid').reduce(sum of amount)` | ParentPaymentsPage |
| `filtered` lessons | `lessons` filtered by `topic` + `search` | StudentLessonsPage |
| `roleLabel` | `profile.role` → display string | Sidebar, SettingsPage |

---

## 12. Synchronization Logic

- No optimistic updates
- No real-time subscriptions on web (Supabase Realtime not used for web)
- All mutations followed by manual re-fetch: `fetchPayments()`, `fetchLessons()`, etc.

---

## Identified Issues

| Issue | Risk |
|-------|------|
| `fetchProfile()` called on every auth state change | Extra DB call on each session refresh |
| No loading guard on `AuthContext` | Pages render with `profile = null` briefly; components must handle null profile |
| Auth state only in React Context | If context unmounts and remounts (hot reload), brief flash of unauthenticated state |
| No error state for `fetchProfile()` | Silent failure if `public.users` row doesn't exist |
| `window.location.href` in signOut | Forces full page reload — not a bug but may feel slow |
| Notification state not persisted | User toggles revert on refresh |
