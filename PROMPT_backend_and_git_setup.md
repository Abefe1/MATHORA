# Mathora — Backend Wiring, Git Setup & Mobile Scaffold Prompt

Use this prompt once git is set up (or to set it up) and you're ready to tackle what's not yet achieved.

---

```
You are working on the Mathora project at c:\Users\Admin\Documents\MATHORA — a Nigerian Mathematics & Further Mathematics learning platform (WAEC/BECE-focused) with two apps:

- mathora-web: Next.js 16 (App Router, Turbopack) + React 19 + Tailwind 4 + Supabase (@supabase/ssr, @supabase/supabase-js) + KaTeX for math rendering.
- mathora-mobile: an Expo/React Native scaffold that is currently just the default `create-expo-app` template with no real screens.

Reference docs already in the repo root: Mathora_Product_Spec_v2.md (product spec), mathora_schema.sql (Postgres/Supabase schema), seed_data.json (seed content), Gamified_Mathematics_Learning_Platform_Features(3).md.

Current diagnosed state of mathora-web:
- Builds cleanly (`next build` succeeds, TypeScript passes) with 16 routes: /, /admin, /parent, /student, /student/diagnostic, /student/groups, /student/learn, /student/mock-exam, /student/practice, /student/revision, /student/settings, /student/struggling-analysis, /teacher.
- All student/teacher/parent pages currently render from src/lib/mockData.ts — there is no confirmed live Supabase read/write wiring yet.
- src/middleware.ts exists but Next.js 16 has deprecated the `middleware` file convention in favor of `proxy` (a codemod is available: `npx @next/codemod@canary middleware-to-proxy .`).
- src/lib/offlineSync.ts and src/lib/themeContext.tsx exist as scaffolding but their integration depth is unverified.
- Git only has ONE commit ("Initial commit from Create Next App"). Everything else — every page beyond that, all the styling, Navbar, RescueModeModal, MathRenderer — is uncommitted working-tree state (`git status` shows package.json, package-lock.json, globals.css, layout.tsx, page.tsx, teacher/page.tsx, Navbar.tsx as modified, and a large list of untracked new files/dirs: scripts/, app/parent/, app/student/diagnostic|groups|mock-exam|revision|settings|struggling-analysis, lib/offlineSync.ts, lib/themeContext.tsx, middleware.ts). This is at real risk of accidental loss.
- mathora-mobile has zero app-specific code — it's the unmodified Expo template.

Your job, in priority order:

1. **Save the work.** Before anything else, create a proper git history for mathora-web: stage and commit the current working tree in logical, well-scoped commits (e.g. "add student portal pages", "add teacher/parent/admin pages", "add math rendering + navbar + rescue mode", "add offline sync + theme context + middleware scaffolding"). Do not squash away history. Confirm nothing in .gitignore is being force-added (node_modules, .next, etc.).

2. **Wire real Supabase data.** Using mathora_schema.sql as the source of truth for table shapes and seed_data.json as sample content, replace the mockData.ts-driven pages with real Supabase queries (server components / route handlers where appropriate for Next 16 App Router). Cover at minimum: student topic browsing, practice question fetching + answer submission, diagnostic placement, teacher class/join-code creation, parent child-progress view. Add proper loading/error/empty states. Keep RLS-appropriate query patterns (respect the schema's row-level security intent if present in mathora_schema.sql).

3. **Migrate middleware → proxy.** Run the codemod or do it manually per Next 16's new convention; verify build stays green and any auth/route-guarding behavior in the old middleware.ts is preserved.

4. **Stand up the mobile app skeleton.** In mathora-mobile, scaffold the equivalent core screens (student home, practice, diagnostic) matching the web app's information architecture from the product spec, sharing Supabase auth/session with the web app where feasible. Keep this to structural scaffolding + navigation + basic data fetching, not full parity with web.

5. **Sanity-check offline sync and theme context** — confirm offlineSync.ts is actually invoked somewhere (or wire it in), and that themeContext.tsx is applied at the root layout, not just defined.

After each numbered step, run `npm run build` (and `npm run lint` if configured) in mathora-web and report pass/fail before moving to the next step. Do not silently skip a step — if something in the spec is ambiguous, state your assumption explicitly and proceed.
```
