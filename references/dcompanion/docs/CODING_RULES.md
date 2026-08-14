# CODING_RULES.md — D Companion Web Platform

Conventions derived from verified source files only.

---

## 1. Naming Conventions

| Element | Convention | Example |
|---------|-----------|---------|
| Components | PascalCase | `DashboardShell`, `ContactForm` |
| Pages | PascalCase function, file is `page.tsx` | `export default function TeacherLivePage()` |
| API routes | file is `route.ts`, export named by method | `export async function POST(req: NextRequest)` |
| Hooks | camelCase, `use` prefix | `useDaily`, `useAuth` |
| Types/interfaces | PascalCase | `Profile`, `DailyRoom`, `Payment` |
| Variables | camelCase | `sessionTitle`, `roomUrl`, `paying` |
| DB table names | snake_case (Supabase convention) | `teacher_assessments`, `room_students` |
| Env variables | SCREAMING_SNAKE_CASE | `DAILY_API_KEY`, `PAYSTACK_SECRET_KEY` |

---

## 2. File Organization

- Pages: `app/[role]/[feature]/page.tsx`
- API routes: `app/api/[service]/[action]/route.ts`
- Shared components: `components/ComponentName.tsx`
- Hooks: `lib/[domain]/useHookName.ts`
- Auth utilities: `lib/auth/`
- Supabase clients: `lib/supabase/client.ts` + `lib/supabase/server.ts`
- Types: `lib/types.ts` (single file for all shared types)
- DB schema: `supabase/schema.sql`, `supabase/rls_upgrade.sql`

---

## 3. Import Ordering

From observed files:
1. Framework imports (`react`, `next/*`)
2. Third-party libraries (`lucide-react`, `clsx`, `@supabase/*`)
3. Internal aliases (`@/lib/...`, `@/components/...`)
4. Types (often inline with other imports)

No enforced ESLint import order rule observed.

---

## 4. Component Patterns

### Client components
```tsx
'use client'
import { useState, useEffect } from 'react'
// ...
export default function PageName() {
  const { profile } = useAuth()
  const supabase = createClient()
  const [data, setData] = useState<Type[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => { fetchData() }, [])

  async function fetchData() {
    setLoading(true)
    const { data } = await supabase.from('table').select('...')
    setData(data || [])
    setLoading(false)
  }

  return (
    <DashboardShell pageTitle="..." pageSubtitle="...">
      {loading ? <LoadingState /> : <Content />}
    </DashboardShell>
  )
}
```

### Server actions
```ts
'use server'
export async function actionName(formData: FormData) {
  const supabase = createClient()
  // ... operations ...
  redirect('/path')
  // OR: return { error: 'message' }
}
```

---

## 5. Styling Conventions

- **Tailwind utilities only** — no inline styles, no CSS Modules
- **Custom brand classes** (defined in `globals.css`):
  - `.card` — white card with border radius and shadow
  - `.btn-primary` — solid blue button
  - `.btn-secondary` — outlined button
  - `.stat-card` — smaller stats display card
  - `.nav-link` — sidebar navigation link
  - `.animate-fade-up`, `.animate-fade-up-2`, `.animate-fade-up-3` — staggered entry animations
- **Brand colors** via Tailwind tokens: `bg-brand-blue`, `text-brand-navy`, `bg-brand-blue-pale`, etc.
- **Font weight classes**: `font-700`, `font-800`, `font-900` (custom Tailwind extension)
- **Font families**: `font-display` (headings), `font-body` (body text)
- **Responsive**: `grid-cols-1 md:grid-cols-2 xl:grid-cols-3` pattern used for grids

**Do not use:**
- Inline `style={{ }}` props (except unavoidable dynamic values)
- Hardcoded color hex values in JSX
- CSS Modules

---

## 6. API Conventions

- All API routes export named functions by HTTP method: `export async function POST()`
- Always `try/catch` → `NextResponse.json({ error: e.message }, { status: 500 })`
- Server-side secrets accessed via `process.env.SECRET_NAME!` (non-null assertion)
- Never expose `SUPABASE_SERVICE_ROLE_KEY` or payment secrets to client

---

## 7. State Conventions

- One `useState` per distinct piece of state (not a single state object)
- Loading state: `const [loading, setLoading] = useState(true)`
- Saving state: `const [saving, setSaving] = useState(false)` + `const [saved, setSaved] = useState(false)`
- Error messages: `const [error, setError] = useState<string | null>(null)` (or string)
- No global state mutations — always `setState(value)` or `setState(prev => ...)`

---

## 8. Error Handling

- API routes: `try/catch` → return JSON error with appropriate status
- Client pages: catch errors inline, show error banners (red alert div)
- Auth errors: server actions return `{ error: string }` — shown in form
- Never `console.log` in production code (no logging framework used)

---

## 9. Form Handling

- Forms use controlled components (`value` + `onChange`)
- No form library (no React Hook Form / Zod in web app)
- Server actions used for auth forms (signIn, signUp)
- Regular `async function` handlers for client-side forms
- Disabled buttons during async operations: `disabled={saving || !fieldValue}`

---

## 10. TypeScript Patterns

- Interfaces preferred over `type` for object shapes
- Page-local interfaces defined at top of file (not exported)
- Shared types go in `lib/types.ts`
- `Role` type: `'student' | 'teacher' | 'parent' | 'admin'`
- `any` used in some join query results (e.g. `(u: any) => ({ ...u, teacher_name: u.teachers?.users?.name })`)
- Non-null assertion `!` used for env variables that are guaranteed at startup

---

## 11. Performance Rules

- Dynamic import for Daily.co SDK: `await import('@daily-co/daily-js')` — prevents SSR bundle bloat
- Paystack script loaded only when payments page mounts (DOM injection)
- No memoization (`useMemo`/`useCallback`) used except in `useDaily.ts` (via `useCallback`)
- No image optimization beyond Next.js built-in (public assets)

---

## 12. RTL Handling

**Not applicable.** Platform is English-only. No RTL rules apply.

---

## 13. Accessibility Conventions

- Form labels: `<label>` elements with explicit `htmlFor` not used — labels are visual only (above inputs)
- Buttons have text content (not icon-only)
- No `aria-*` attributes observed
- Focus: `focus:border-brand-blue outline-none` — removes default outline, replaces with border

---

## 14. Animation Conventions

- Entry animations via custom Tailwind classes: `animate-fade-up`, `animate-fade-up-2`, `animate-fade-up-3`
- Stagger effect: sequential pages/cards use `-2`, `-3` suffixes
- Loading spinners: `<Loader2 size={16} className="animate-spin" />` from lucide-react
- Live indicator: `animate-pulse` on red dot in TeacherLivePage

---

## 15. Patterns to Follow

- Always wrap page content in `<DashboardShell pageTitle="..." pageSubtitle="...">`
- Always handle loading state and empty state explicitly
- Join Supabase queries inline: `.select('id, name, teachers(users(name))')` not multiple queries
- Group related state (loading/data/error) at the top of the component
- Use `|| []` fallback for Supabase data: `setData(data || [])`
- Use `.map(item => ({ ...item, derived: item.relation?.nested?.value || 'Default' }))` for joins

---

## Anti-patterns — Do NOT Introduce

| Anti-pattern | Why |
|-------------|-----|
| New global state library | Zustand/Redux not used on web; use Context or local state |
| Separate API client class | Direct Supabase + fetch calls; no abstraction layer |
| CSS Modules or styled-components | Tailwind only |
| Multiple Supabase clients | Use existing `client.ts` and `server.ts` |
| Hardcoded API URLs | Daily.co and Paystack base URLs defined at top of route files |
| Nested contexts | Single AuthContext; no additional providers |
| `useEffect` for derived state | Use inline computed variables or `useMemo` |
