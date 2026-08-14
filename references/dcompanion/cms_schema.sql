-- Landing Page CMS Schema
-- Run after the main schema.sql in: Supabase Dashboard → SQL Editor

-- ─────────────────────────────────────────────
-- landing_sections: one row per section
-- ─────────────────────────────────────────────
create table public.landing_sections (
  id                     uuid primary key default gen_random_uuid(),
  section_key            text not null unique,
  label                  text not null,
  visible                boolean not null default true,
  order_position         int  not null default 0,
  live_content           jsonb not null default '{}',
  draft_content          jsonb not null default '{}',
  has_draft              boolean not null default false,
  scheduled_publish_at   timestamptz,
  scheduled_unpublish_at timestamptz,
  created_at             timestamptz default now(),
  updated_at             timestamptz default now()
);

-- ─────────────────────────────────────────────
-- landing_button_visibility: CTA button toggles
-- ─────────────────────────────────────────────
create table public.landing_button_visibility (
  button_key  text primary key,
  label       text not null,
  visible     boolean not null default true,
  updated_at  timestamptz default now()
);

-- ─────────────────────────────────────────────
-- RLS
-- ─────────────────────────────────────────────
alter table public.landing_sections          enable row level security;
alter table public.landing_button_visibility enable row level security;

-- Public can read sections (live landing page needs this)
create policy "public_read_sections"
  on public.landing_sections for select
  using (true);

create policy "public_read_buttons"
  on public.landing_button_visibility for select
  using (true);

-- Only admins can write
create policy "admin_write_sections"
  on public.landing_sections for all
  using (
    exists (
      select 1 from public.users
      where id = auth.uid() and role = 'admin'
    )
  );

create policy "admin_write_buttons"
  on public.landing_button_visibility for all
  using (
    exists (
      select 1 from public.users
      where id = auth.uid() and role = 'admin'
    )
  );

-- ─────────────────────────────────────────────
-- Seed default sections (mirrors current hard-coded content)
-- ─────────────────────────────────────────────
insert into public.landing_sections (section_key, label, order_position, live_content, draft_content) values

('hero', 'Hero', 1,
  '{
    "eyebrow_text": "Built for the Nigerian Curriculum",
    "eyebrow_subtext": "WAEC · BECE · JSS · SS",
    "headline_line1": "Master Maths.",
    "headline_line2": "Pass with confidence.",
    "subheadline": "Live classes, AI-powered assignment help, past questions, and progress tracking — all built for Nigerian secondary school students, teachers, and parents.",
    "primary_cta_label": "Start Learning Free",
    "secondary_cta_label": "I already have an account",
    "trust_badges": [
      { "icon_key": "shield", "text": "Secured by Paystack" },
      { "icon_key": "star",   "text": "Trusted by teachers nationwide" },
      { "icon_key": "sparkles","text": "AI-powered learning" }
    ]
  }',
  '{}'
),

('trust_strip', 'Trust Strip (Stats)', 2,
  '{
    "stats": [
      { "value": "12K+", "label": "Active students" },
      { "value": "500+", "label": "Verified teachers" },
      { "value": "98%",  "label": "WAEC pass rate" },
      { "value": "24/7", "label": "AI tutor access" }
    ]
  }',
  '{}'
),

('features', 'Feature Highlights', 3,
  '{
    "section_eyebrow": "Features",
    "heading": "Everything you need to",
    "heading_highlight": "crush maths",
    "subheading": "One platform, every tool — live teaching, AI tutoring, exam prep, and progress tracking in your pocket.",
    "features": [
      { "title": "Live Classes",          "body": "Join high-definition video classes hosted by verified teachers. Raise your hand, chat, and learn live." },
      { "title": "AI Assignment Aid",     "body": "Snap a photo or type a problem — get instant step-by-step solutions tuned for Nigerian curriculum." },
      { "title": "WAEC & BECE Practice",  "body": "Drill past questions with instant scoring. Build exam stamina before the real thing." },
      { "title": "Progress Analytics",    "body": "See exactly where you stand. Charts show lessons done, chapter mastery, and assessment averages." },
      { "title": "Lesson Library",        "body": "Browse PDFs, videos and notes uploaded by your teachers — organized by topic and downloadable." },
      { "title": "Hire a Tutor",          "body": "Find a verified private tutor by subject and rate. Pay safely through Paystack, get sessions on demand." }
    ]
  }',
  '{}'
),

('how_it_works', 'How It Works', 4,
  '{
    "section_eyebrow": "How it Works",
    "heading": "From zero to",
    "heading_highlight": "A grade",
    "heading_suffix": "in three steps.",
    "steps": [
      { "title": "Create your account",          "body": "Pick your role — student, teacher, or parent — and tell us about yourself. Free to start, no card required." },
      { "title": "Join live classes & lessons",  "body": "Browse your teacher''s uploaded materials, join live sessions, or get instant help from our AI tutor." },
      { "title": "Track progress & ace exams",   "body": "Practice past questions, take assessments, and watch your weekly progress charts climb." }
    ]
  }',
  '{}'
),

('roles', 'Roles Section', 5,
  '{
    "section_eyebrow": "Built for everyone",
    "heading": "One platform.",
    "heading_highlight": "Three powerful experiences.",
    "roles": [
      { "title": "For Students", "tagline": "JSS1 – SS3",         "body": "Live classes, AI tutoring, past question banks, and progress analysis. Built for your curriculum.", "cta_label": "Start learning" },
      { "title": "For Teachers", "tagline": "Earn while you teach","body": "Host live classes, upload materials, build assessments, and get paid through Paystack — all in one place.", "cta_label": "Start teaching" },
      { "title": "For Parents",  "tagline": "Stay in the loop",   "body": "Monitor your child''s progress, attendance, and assessment results. Hire tutors and pay safely.", "cta_label": "Track your child" }
    ]
  }',
  '{}'
),

('cta_banner', 'CTA Banner', 6,
  '{
    "badge_text": "Free to start · No card required",
    "heading_line1": "Ready to ace",
    "heading_line2": "your next maths exam?",
    "subheading": "Join thousands of Nigerian students already mastering maths with D Companion.",
    "primary_cta_label": "Create Free Account",
    "secondary_cta_label": "Sign In Instead"
  }',
  '{}'
),

('footer', 'Footer', 7,
  '{
    "tagline": "Mastering mathematics for Nigerian secondary school students — one lesson at a time.",
    "partners_text": "Secured by Paystack · Powered by Daily.co · AI by Anthropic",
    "contact_email": "support@dcompanion.ng",
    "contact_phone": "+234 800 DCOMP AN",
    "contact_whatsapp": "WhatsApp Support"
  }',
  '{}'
);

-- Seed default button visibility
insert into public.landing_button_visibility (button_key, label, visible) values
  ('free_trial_cta', 'Free Trial / Start Learning CTA',     true),
  ('pricing_cta',    'Pricing CTA',                          false),
  ('waitlist_cta',   'Waitlist CTA',                         false),
  ('demo_cta',       'Book a Demo CTA',                      false);
