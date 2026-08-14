# D Companion — Project Handover Document
# Paste this entire file at the start of a new Claude conversation

---

## 🎯 PROJECT OVERVIEW

**Name:** D Companion
**Type:** Mathematics Learning Platform for Nigerian secondary school students
**Target Users:** Students (JSS1–SS3), Teachers, Parents, Admin
**Nigerian Curriculum:** WAEC, BECE, JSS, SS levels

---

## 📦 WHAT HAS BEEN BUILT (COMPLETE)

### 1. Web App — `dcompanion-web` (Next.js 14)
### 2. Mobile App — `dcompanion-mobile` (React Native + Expo)

Both are fully coded, zipped, and downloaded by the user.

---

## 🏗️ TECH STACK

### Web (`dcompanion-web`)
- **Framework:** Next.js 14 (App Router)
- **Styling:** Tailwind CSS with custom D Companion brand tokens
- **Database + Auth:** Supabase (PostgreSQL + RLS)
- **Live Classes:** Daily.co (WebRTC)
- **Payments:** Paystack (NGN, Nigerian payment gateway)
- **AI (Assignment Aid):** Anthropic Claude / Google Gemini / Groq (fallback chain)
- **Hosting:** Vercel (frontend) + Supabase (backend)

### Mobile (`dcompanion-mobile`)
- **Framework:** React Native + Expo (SDK 51)
- **Routing:** Expo Router (file-based, like Next.js)
- **State:** Zustand (`lib/store/authStore.ts`)
- **Auth Storage:** Expo SecureStore
- **Push Notifications:** Expo Notifications
- **Offline Cache:** AsyncStorage with TTL (`lib/cache.ts`)
- **Live Classes:** Daily.co WebView (students join; teachers go live on WEB only)
- **Payments:** react-native-paystack-webview
- **Build/Deploy:** EAS (Expo Application Services)

---

## 🎨 BRAND / DESIGN

**App Name:** D Companion
**Logo:** "D" icon in blue circle + "COMPANION" text with blue "A"
**Figma:** Mobile-first design already done by the user

### Color Tokens
```
brand-blue:       #42A5F5  (primary)
brand-blue-dark:  #1565C0
brand-blue-light: #BBDEFB
brand-blue-pale:  #E3F2FD  (backgrounds)
brand-green:      #66BB6A  (teacher role color, success)
brand-green-light:#C8E6C9
brand-navy:       #1A2B4A  (parent role color, text)
brand-navy-light: #2C3E6B
Background:       #F7FBFF
```

### Role Colors
- Student → Blue (#42A5F5)
- Teacher → Green (#66BB6A)
- Parent  → Navy (#1A2B4A)
- Admin   → Orange (#FF9800)

---

## 📁 COMPLETE FILE STRUCTURE

### Web App
```
dcompanion-web/
├── app/
│   ├── layout.tsx                    ← Root layout (AuthProvider + env validation)
│   ├── page.tsx                      ← Redirects to /login
│   ├── globals.css                   ← Brand CSS + utility classes
│   ├── login/page.tsx                ← Role-tab login (Student/Parent tabs)
│   ├── register/page.tsx             ← Role-specific registration
│   ├── chat/page.tsx                 ← Real-time in-app messaging
│   ├── student/
│   │   ├── page.tsx                  ← Student dashboard
│   │   ├── lessons/page.tsx          ← Browse uploaded lesson materials
│   │   ├── live/page.tsx             ← Join Daily.co live classes
│   │   ├── past-questions/page.tsx   ← WAEC/BECE MCQ practice
│   │   ├── assignment-aid/page.tsx   ← AI math solver (text + camera)
│   │   ├── aid-history/page.tsx      ← History of AI-solved problems
│   │   ├── analysis/page.tsx         ← Progress charts (Recharts)
│   │   ├── tutors/page.tsx           ← Browse verified tutors
│   │   ├── contact/page.tsx          ← Contact support
│   │   └── settings/page.tsx         ← Profile + password + notifications
│   ├── teacher/
│   │   ├── page.tsx                  ← Teacher dashboard
│   │   ├── live/page.tsx             ← Start Daily.co live class + notify students
│   │   ├── upload/page.tsx           ← Drag-drop upload to Supabase Storage
│   │   ├── rooms/page.tsx            ← Manage student groups
│   │   ├── students/page.tsx         ← Student roster with progress/payments
│   │   ├── assessments/page.tsx      ← Create MCQ quizzes
│   │   ├── earnings/page.tsx         ← Paystack earnings + charts
│   │   ├── availability/page.tsx     ← Weekly availability schedule
│   │   ├── contact/page.tsx
│   │   └── settings/page.tsx
│   ├── parent/
│   │   ├── page.tsx                  ← Parent dashboard (child overview + debt alert)
│   │   ├── progress/page.tsx         ← Child progress charts + assessment history
│   │   ├── attendance/page.tsx       ← Monthly attendance records
│   │   ├── payments/page.tsx         ← Paystack payment + debt clearing
│   │   ├── tutors/page.tsx           ← Hire tutors with session modal
│   │   ├── link-child/page.tsx       ← 4-step parent-child phone linking
│   │   ├── contact/page.tsx
│   │   └── settings/page.tsx
│   ├── admin/
│   │   ├── page.tsx                  ← Platform overview dashboard
│   │   ├── users/page.tsx            ← User management table
│   │   ├── verify/page.tsx           ← Approve/reject teacher applications
│   │   ├── sessions/page.tsx         ← All platform sessions
│   │   ├── payments/page.tsx         ← Revenue overview
│   │   └── settings/page.tsx
│   └── api/
│       ├── assignment-aid/route.ts   ← AI solver (Anthropic→Gemini→Groq→Mock)
│       ├── daily/
│       │   ├── create-room/route.ts  ← Creates Daily.co room
│       │   └── token/route.ts        ← Issues participant token
│       └── paystack/
│           └── verify/route.ts       ← Server-side payment verification
├── components/
│   ├── Sidebar.tsx                   ← Role-aware navigation (reads from AuthContext)
│   ├── Topbar.tsx                    ← Search + notifications header
│   ├── DashboardShell.tsx            ← Layout wrapper (Sidebar + Topbar + main)
│   ├── ContactForm.tsx               ← Shared contact form (role-aware topics)
│   └── SettingsPage.tsx              ← Shared settings (profile/password/notifs)
├── lib/
│   ├── auth/
│   │   ├── AuthContext.tsx           ← React context (user, profile, signOut)
│   │   └── actions.ts                ← Server actions: signIn, signUp, signOut
│   ├── daily/
│   │   └── useDaily.ts               ← Daily.co hook (createRoom, joinRoom, leave)
│   ├── hooks/
│   │   └── useSessionTimeout.ts      ← Auto sign-out after 30min inactivity
│   ├── supabase/
│   │   ├── client.ts                 ← Browser Supabase client
│   │   └── server.ts                 ← Server Supabase client
│   ├── env.ts                        ← Environment variable validation + typed accessor
│   ├── rateLimit.ts                  ← Rate limiting for API routes
│   ├── types.ts                      ← All TypeScript interfaces
│   └── validate.ts                   ← Input validation + sanitization
├── middleware.ts                     ← Route protection + role-based redirects
├── supabase/
│   ├── schema.sql                    ← Full DB schema (15 tables)
│   ├── rls_upgrade.sql               ← Tightened RLS production policies
│   └── functions/
│       └── notify-live/index.ts      ← Edge Function: push notifications when teacher goes live
├── tailwind.config.js                ← Brand color tokens
├── package.json
├── tsconfig.json
└── .env.example
```

### Mobile App
```
dcompanion-mobile/
├── app/
│   ├── _layout.tsx                   ← Root (auth listener + notification setup + fonts)
│   ├── index.tsx                     ← Smart redirect by role
│   ├── chat.tsx                      ← Real-time chat screen
│   ├── (auth)/
│   │   ├── splash.tsx                ← Animated splash (matches Figma)
│   │   ├── onboarding.tsx            ← 4-slide onboarding
│   │   ├── login.tsx                 ← Role-tab login
│   │   └── register.tsx              ← Role-specific registration
│   ├── (student)/
│   │   ├── home.tsx                  ← Grid layout matching Figma
│   │   ├── lessons.tsx               ← Offline-cached lesson browser
│   │   ├── live.tsx                  ← Join Daily.co sessions (WebView)
│   │   ├── past-questions.tsx        ← WAEC/BECE MCQ with scoring
│   │   ├── assignment-aid.tsx        ← Camera + text AI solver
│   │   ├── analysis.tsx              ← Progress rings + assessment charts
│   │   ├── tutors.tsx                ← Browse tutors + share with parent
│   │   ├── more.tsx                  ← Menu (hire tutor, contact, settings)
│   │   ├── contact.tsx
│   │   └── settings.tsx
│   ├── (teacher)/                    ← NO live class (web only for teachers)
│   │   ├── home.tsx                  ← Earnings + upcoming sessions + notice about web
│   │   ├── upload.tsx                ← File picker → Supabase Storage
│   │   ├── students.tsx              ← Roster with progress/payments
│   │   ├── rooms.tsx                 ← View rooms + members (read-only on mobile)
│   │   ├── earnings.tsx              ← Payment history + Paystack withdrawal
│   │   ├── more.tsx
│   │   ├── contact.tsx
│   │   └── settings.tsx
│   └── (parent)/
│       ├── home.tsx                  ← Child overview + debt alert + quick actions
│       ├── progress.tsx              ← Charts + assessment history + grade breakdown
│       ├── attendance.tsx            ← Monthly grouped attendance records
│       ├── payments.tsx              ← Paystack WebView modal payment
│       ├── tutors.tsx                ← Hire tutor modal (records as debt)
│       ├── more.tsx
│       ├── contact.tsx
│       └── settings.tsx
├── components/
│   ├── ui.tsx                        ← Button, Card, Input, Badge, ProgressBar, Colors
│   ├── Header.tsx                    ← Blue header with back button
│   ├── ScreenWrapper.tsx             ← SafeAreaView + ScrollView
│   ├── ContactScreen.tsx             ← Shared contact form
│   └── SettingsScreen.tsx            ← Shared settings screen
├── lib/
│   ├── supabase.ts                   ← Supabase client (SecureStore adapter)
│   ├── types.ts                      ← TypeScript interfaces
│   ├── cache.ts                      ← Offline cache (AsyncStorage + TTL)
│   ├── notifications.ts              ← Push registration + tap handlers
│   └── store/
│       └── authStore.ts              ← Zustand: signIn, signUp, signOut, profile
├── app.json                          ← Expo config (icons, permissions, scheme)
├── babel.config.js
├── eas.json                          ← EAS build profiles (preview APK + production)
├── tailwind.config.js
├── package.json
└── .env.example
```

---

## 🗄️ DATABASE SCHEMA (Supabase PostgreSQL)

### Tables (15 total)
```
users              ← id, name, email, phone, role, avatar_url
students           ← user_id, class (JSS1/SS3/etc), parent_id, age
teachers           ← user_id, subject, experience_years, hourly_rate, bio, verified, rating
parents            ← user_id, phone
parent_child       ← parent_id ↔ student_id (linking table)
rooms              ← teacher_id, name (class groups)
room_students      ← room_id ↔ student_id
sessions           ← teacher_id, room_id, title, date, live_link, type (live/recorded)
attendance         ← student_id, session_id, present, date
progress           ← student_id, lessons_done, chapters_done, assessments_done, totals
assessments        ← student_id, topic, score, max_score, date
teacher_assessments← teacher_id, title, topic, questions (JSONB array of MCQs)
assessment_submissions ← assessment_id, student_id, answers, score
payments           ← parent_id, teacher_id, amount, status (paid/pending/debt), date
uploads            ← teacher_id, name, size, type, url, topic, uploaded_at
push_tokens        ← user_id, token, platform (for push notifications)
aid_history        ← student_id, problem, solution (JSONB), mode, created_at
messages           ← sender_id, receiver_id, content, read, created_at
teacher_availability← teacher_id, day, start_time, end_time
```

### SQL Files to Run in Order
1. `supabase/schema.sql` — creates all tables + basic policies
2. `supabase/rls_upgrade.sql` — tightens RLS to production-safe policies

### Auto-Progress Trigger (already in rls_upgrade.sql)
```sql
-- Fires when assessment inserted → auto-increments assessments_done in progress table
trigger: on_assessment_insert → function: increment_assessments_done()
```

---

## 🔑 ENVIRONMENT VARIABLES

### Web (`dcompanion-web/.env.local`)
```env
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=
DAILY_API_KEY=                        ← daily.co (live classes)
ANTHROPIC_API_KEY=                    ← optional (Assignment Aid)
GEMINI_API_KEY=                       ← optional FREE alternative
GROQ_API_KEY=                         ← optional FREE alternative
NEXT_PUBLIC_PAYSTACK_PUBLIC_KEY=      ← optional (can mock)
PAYSTACK_SECRET_KEY=                  ← optional (can mock)
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

### Mobile (`dcompanion-mobile/.env.local`)
```env
EXPO_PUBLIC_SUPABASE_URL=
EXPO_PUBLIC_SUPABASE_ANON_KEY=
EXPO_PUBLIC_API_URL=http://localhost:3000   ← points to web app
EXPO_PUBLIC_PAYSTACK_PUBLIC_KEY=
EXPO_PUBLIC_EAS_PROJECT_ID=                ← from expo.dev after eas init
```

---

## 🔐 SECURITY FEATURES IMPLEMENTED

1. **Tightened RLS** — each table has granular policies (students see own data only, etc.)
2. **Rate Limiting** — all API routes protected (10 req/min for AI, 5 for payments)
3. **Input Validation** — sanitization on all API inputs (`lib/validate.ts`)
4. **Env Validation** — startup check with clear error messages (`lib/env.ts`)
5. **Middleware** — admin-only routes locked, role mismatch redirects (`middleware.ts`)
6. **Session Timeout** — auto sign-out after 30min inactivity (`useSessionTimeout`)
7. **File Upload Validation** — allowed MIME types + 100MB max size limit
8. **AI Fallback Chain** — Anthropic → Gemini → Groq → Mock (never crashes)

---

## 🚀 FEATURES IMPLEMENTED

### Student
- Dashboard with Figma grid layout (Lessons, Live Class, Assignment Aid, Past Questions, Hire Tutor, Contact)
- Assignment Aid: type OR camera → AI solves step-by-step → saved to history
- Past Questions: WAEC/BECE MCQ with check answer + scoring
- Live class: joins Daily.co via WebView, auto-marks attendance
- Progress analysis with charts + rings
- Offline-cached lessons (works without internet)
- Tutor browser (share with parent feature)

### Teacher
- Dashboard: earnings overview + upcoming sessions
- **Live class: WEB ONLY** (teachers go live from browser, not mobile — by design for writing efficiency)
- Upload: drag-drop on web, file picker on mobile → Supabase Storage
- Rooms: group students, add/remove members
- Assessment builder: MCQ with correct answer marking
- Student roster: progress %, avg score, attendance rate, payment status
- Earnings: Paystack payout, monthly bar chart
- Availability schedule: set available days/hours for private hire

### Parent
- Dashboard: child overview card + debt alert banner
- Progress: bar charts + line charts + assessment history + grade (A/B/C/D/F)
- Attendance: monthly grouped, attendance rate, absent/present badges
- Payments: Paystack integration, debt clearing
- Hire tutor: browse verified teachers, session modal, recorded as debt
- Link child: 4-step phone number linking flow

### Admin
- Platform overview: user counts, revenue, pending verifications
- User management: search, filter by role, delete
- Teacher verification: approve/reject applications
- Session monitor: all live/recorded sessions
- Payment overview: revenue charts + transaction history

### Shared
- In-app chat: real-time messaging (parent ↔ teacher)
- Contact forms: role-aware support topics
- Settings: profile edit, password change, notification toggles
- Push notifications: students notified when teacher goes live

---

## 📱 MOBILE-SPECIFIC NOTES

- **Teachers go live on WEB only** — mobile teacher app shows a notice directing them to browser
- **Daily.co on mobile** — students join via WebView pointing at the room URL
- **Paystack on mobile** — uses react-native-paystack-webview Modal
- **Offline lessons** — AsyncStorage cache with 24hr TTL, background refresh
- **Assignment Aid camera** — uses expo-camera with base64 → sent to web API

---

## 🏪 DEPLOYMENT PLAN

### Web → Vercel
```bash
cd dcompanion-web
npm install -g vercel
vercel
# Add all .env.local keys to Vercel dashboard → Settings → Environment Variables
```

### Mobile → EAS (Android APK first)
```bash
cd dcompanion-mobile
npm install -g eas-cli
eas login
eas init
eas secret:create --scope project --name EXPO_PUBLIC_SUPABASE_URL --value xxx
eas build --platform android --profile preview
# Downloads an APK anyone can install directly
```

### Supabase Edge Function
```bash
supabase functions deploy notify-live
# This sends push notifications to students when teacher goes live
```

---

## 🔧 HOW TO RUN LOCALLY

```bash
# Web
cd dcompanion-web
npm install
cp .env.example .env.local   # fill in keys
npm run dev                   # → http://localhost:3000

# Mobile (separate terminal)
cd dcompanion-mobile
npm install
cp .env.example .env.local   # fill in keys
npx expo start                # → scan QR with Expo Go app
```

---

## ⚠️ KNOWN PENDING ITEMS / WHAT TO BUILD NEXT

These features were designed but not yet fully implemented or need refinement:

1. **Assessment submission flow** — students can view teacher-created quizzes but the
   submit + auto-score + record to `assessment_submissions` table flow needs building

2. **Assignment Aid history on mobile** — web version done (`/student/aid-history`),
   mobile screen not yet created

3. **In-app chat on web** — built at `/chat` but not linked in Sidebar nav yet
   → Add to Sidebar.tsx navByRole for student and parent roles

4. **Teacher availability shown on hire page** — schedule table built, but the
   parent/student hire page doesn't yet display teacher availability slots

5. **Admin role creation** — no UI to promote user to admin, must do manually in Supabase:
   `update public.users set role = 'admin' where email = 'your@email.com';`

6. **Email notifications** — push notifications done, email via Resend/SendGrid not yet set up

7. **Recorded lessons** — upload works but there is no video player UI for recorded sessions
   (type = 'recorded' in sessions table)

8. **Paystack is mocked** — both projects have mock payment that marks as 'paid' directly.
   Real Paystack keys need to be added when going live.

9. **Past questions are hardcoded** — 4 sample questions in the code.
   Need a `past_questions` table in Supabase and an admin UI to add more.

10. **Parent chat initiation** — chat screen exists but parents need a way to find
    and start a new conversation with a teacher they've hired

11. **Teacher assessment results** — teacher can create quizzes but there's no screen
    to view individual student submission results yet

12. **Mobile assignment aid history** — screen built for web, needs mobile equivalent
    in `app/(student)/` folder

---

## 💰 COST TO RUN (Development / Free Tier)

| Service | Free Tier |
|---------|-----------|
| Supabase | 500MB DB, 1GB storage, 50K MAU |
| Vercel | 100GB bandwidth, unlimited deploys |
| Daily.co | 1,000 participant minutes/month |
| Expo/EAS | 30 builds/month |
| Gemini API | 1,500 requests/day, 1M tokens/month |
| Groq API | 14,400 requests/day |

**Paid when ready:**
- Paystack: 1.5% + ₦100 per transaction
- Google Play: $25 one-time
- Apple App Store: $99/year

---

## 📞 HOW TO CONTINUE IN THIS CHAT

Tell Claude any of the following to continue:

- "Build the assessment submission flow for students"
- "Link the chat page in the Sidebar navigation"
- "Build the mobile assignment aid history screen"
- "Show teacher availability on the hire tutor page"
- "Build the past questions admin upload UI"
- "Set up email notifications with Resend"
- "Build the recorded lessons video player"
- "Build the teacher assessment results view"
- "Fix [specific bug or issue]"
- "Add [new feature]"

Claude has full context of every file, every table, every component.
Just describe what you want and it will write the exact code to drop into the right file.
