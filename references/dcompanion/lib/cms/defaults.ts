import type {
  HeroContent, TrustStripContent, FeaturesContent,
  HowItWorksContent, RolesContent, CtaBannerContent, FooterContent,
  ButtonVisibility, LandingSection, ButtonKey,
} from './types'

export const DEFAULT_HERO: HeroContent = {
  eyebrow_text: 'Built for the Nigerian Curriculum',
  eyebrow_subtext: 'WAEC · BECE · JSS · SS',
  headline_line1: 'Master Maths.',
  headline_line2: 'Pass with confidence.',
  subheadline:
    'Live classes, AI-powered assignment help, past questions, and progress tracking — all built for Nigerian secondary school students, teachers, and parents.',
  primary_cta_label: 'Start Learning Free',
  secondary_cta_label: 'I already have an account',
  trust_badges: [
    { icon_key: 'shield',   text: 'Secured by Paystack' },
    { icon_key: 'star',     text: 'Trusted by teachers nationwide' },
    { icon_key: 'sparkles', text: 'AI-powered learning' },
  ],
}

export const DEFAULT_TRUST_STRIP: TrustStripContent = {
  stats: [
    { value: '12K+', label: 'Active students' },
    { value: '500+', label: 'Verified teachers' },
    { value: '98%',  label: 'WAEC pass rate' },
    { value: '24/7', label: 'AI tutor access' },
  ],
}

export const DEFAULT_FEATURES: FeaturesContent = {
  section_eyebrow: 'Features',
  heading: 'Everything you need to',
  heading_highlight: 'crush maths',
  subheading:
    'One platform, every tool — live teaching, AI tutoring, exam prep, and progress tracking in your pocket.',
  features: [
    { title: 'Live Classes',         body: 'Join high-definition video classes hosted by verified teachers. Raise your hand, chat, and learn live.' },
    { title: 'AI Assignment Aid',    body: 'Snap a photo or type a problem — get instant step-by-step solutions tuned for Nigerian curriculum.' },
    { title: 'WAEC & BECE Practice', body: 'Drill past questions with instant scoring. Build exam stamina before the real thing.' },
    { title: 'Progress Analytics',   body: 'See exactly where you stand. Charts show lessons done, chapter mastery, and assessment averages.' },
    { title: 'Lesson Library',       body: 'Browse PDFs, videos and notes uploaded by your teachers — organized by topic and downloadable.' },
    { title: 'Hire a Tutor',         body: 'Find a verified private tutor by subject and rate. Pay safely through Paystack, get sessions on demand.' },
  ],
}

export const DEFAULT_HOW_IT_WORKS: HowItWorksContent = {
  section_eyebrow: 'How it Works',
  heading: 'From zero to',
  heading_highlight: 'A grade',
  heading_suffix: 'in three steps.',
  steps: [
    { title: 'Create your account',         body: 'Pick your role — student, teacher, or parent — and tell us about yourself. Free to start, no card required.' },
    { title: 'Join live classes & lessons', body: "Browse your teacher's uploaded materials, join live sessions, or get instant help from our AI tutor." },
    { title: 'Track progress & ace exams',  body: 'Practice past questions, take assessments, and watch your weekly progress charts climb.' },
  ],
}

export const DEFAULT_ROLES: RolesContent = {
  section_eyebrow: 'Built for everyone',
  heading: 'One platform.',
  heading_highlight: 'Three powerful experiences.',
  roles: [
    { title: 'For Students', tagline: 'JSS1 – SS3',          body: 'Live classes, AI tutoring, past question banks, and progress analysis. Built for your curriculum.', cta_label: 'Start learning' },
    { title: 'For Teachers', tagline: 'Earn while you teach', body: 'Host live classes, upload materials, build assessments, and get paid through Paystack — all in one place.', cta_label: 'Start teaching' },
    { title: 'For Parents',  tagline: 'Stay in the loop',    body: "Monitor your child's progress, attendance, and assessment results. Hire tutors and pay safely.", cta_label: 'Track your child' },
  ],
}

export const DEFAULT_CTA_BANNER: CtaBannerContent = {
  badge_text: 'Free to start · No card required',
  heading_line1: 'Ready to ace',
  heading_line2: 'your next maths exam?',
  subheading: 'Join thousands of Nigerian students already mastering maths with D Companion.',
  primary_cta_label: 'Create Free Account',
  secondary_cta_label: 'Sign In Instead',
}

export const DEFAULT_FOOTER: FooterContent = {
  tagline: 'Mastering mathematics for Nigerian secondary school students — one lesson at a time.',
  partners_text: 'Secured by Paystack · Powered by Daily.co · AI by Anthropic',
  contact_email: 'support@dcompanion.ng',
  contact_phone: '+234 800 DCOMP AN',
  contact_whatsapp: 'WhatsApp Support',
}

export const DEFAULT_BUTTONS: ButtonVisibility[] = [
  { button_key: 'free_trial_cta' as ButtonKey, label: 'Free Trial / Start Learning CTA', visible: true },
  { button_key: 'pricing_cta'    as ButtonKey, label: 'Pricing CTA',                     visible: false },
  { button_key: 'waitlist_cta'   as ButtonKey, label: 'Waitlist CTA',                    visible: false },
  { button_key: 'demo_cta'       as ButtonKey, label: 'Book a Demo CTA',                 visible: false },
]

export const DEFAULT_SECTIONS: LandingSection[] = [
  { id: 'default-hero',      section_key: 'hero',         label: 'Hero',                  visible: true, order_position: 1, live_content: DEFAULT_HERO,         draft_content: DEFAULT_HERO,         has_draft: false, scheduled_publish_at: null, scheduled_unpublish_at: null, created_at: '', updated_at: '' },
  { id: 'default-trust',     section_key: 'trust_strip',  label: 'Trust Strip (Stats)',   visible: true, order_position: 2, live_content: DEFAULT_TRUST_STRIP,  draft_content: DEFAULT_TRUST_STRIP,  has_draft: false, scheduled_publish_at: null, scheduled_unpublish_at: null, created_at: '', updated_at: '' },
  { id: 'default-features',  section_key: 'features',     label: 'Feature Highlights',    visible: true, order_position: 3, live_content: DEFAULT_FEATURES,     draft_content: DEFAULT_FEATURES,     has_draft: false, scheduled_publish_at: null, scheduled_unpublish_at: null, created_at: '', updated_at: '' },
  { id: 'default-how',       section_key: 'how_it_works', label: 'How It Works',          visible: true, order_position: 4, live_content: DEFAULT_HOW_IT_WORKS, draft_content: DEFAULT_HOW_IT_WORKS, has_draft: false, scheduled_publish_at: null, scheduled_unpublish_at: null, created_at: '', updated_at: '' },
  { id: 'default-roles',     section_key: 'roles',        label: 'Roles Section',         visible: true, order_position: 5, live_content: DEFAULT_ROLES,        draft_content: DEFAULT_ROLES,        has_draft: false, scheduled_publish_at: null, scheduled_unpublish_at: null, created_at: '', updated_at: '' },
  { id: 'default-cta',       section_key: 'cta_banner',   label: 'CTA Banner',            visible: true, order_position: 6, live_content: DEFAULT_CTA_BANNER,   draft_content: DEFAULT_CTA_BANNER,   has_draft: false, scheduled_publish_at: null, scheduled_unpublish_at: null, created_at: '', updated_at: '' },
  { id: 'default-footer',    section_key: 'footer',       label: 'Footer',                visible: true, order_position: 7, live_content: DEFAULT_FOOTER,       draft_content: DEFAULT_FOOTER,       has_draft: false, scheduled_publish_at: null, scheduled_unpublish_at: null, created_at: '', updated_at: '' },
]
