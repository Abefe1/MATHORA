export type SectionKey =
  | 'hero'
  | 'trust_strip'
  | 'features'
  | 'how_it_works'
  | 'roles'
  | 'cta_banner'
  | 'footer'

export type ButtonKey = 'free_trial_cta' | 'pricing_cta' | 'waitlist_cta' | 'demo_cta'

// ─── Per-section content shapes ──────────────────────────────────────────────

export interface HeroContent {
  eyebrow_text: string
  eyebrow_subtext: string
  headline_line1: string
  headline_line2: string
  subheadline: string
  primary_cta_label: string
  secondary_cta_label: string
  trust_badges: Array<{ icon_key: 'shield' | 'star' | 'sparkles'; text: string }>
}

export interface TrustStripContent {
  stats: Array<{ value: string; label: string }>
}

export interface FeaturesContent {
  section_eyebrow: string
  heading: string
  heading_highlight: string
  subheading: string
  features: Array<{ title: string; body: string }>
}

export interface HowItWorksContent {
  section_eyebrow: string
  heading: string
  heading_highlight: string
  heading_suffix: string
  steps: Array<{ title: string; body: string }>
}

export interface RolesContent {
  section_eyebrow: string
  heading: string
  heading_highlight: string
  roles: Array<{ title: string; tagline: string; body: string; cta_label: string }>
}

export interface CtaBannerContent {
  badge_text: string
  heading_line1: string
  heading_line2: string
  subheading: string
  primary_cta_label: string
  secondary_cta_label: string
}

export interface FooterContent {
  tagline: string
  partners_text: string
  contact_email: string
  contact_phone: string
  contact_whatsapp: string
}

export type SectionContent =
  | HeroContent
  | TrustStripContent
  | FeaturesContent
  | HowItWorksContent
  | RolesContent
  | CtaBannerContent
  | FooterContent

// ─── Row shapes ───────────────────────────────────────────────────────────────

export interface LandingSection {
  id: string
  section_key: SectionKey
  label: string
  visible: boolean
  order_position: number
  live_content: SectionContent
  draft_content: SectionContent
  has_draft: boolean
  scheduled_publish_at: string | null
  scheduled_unpublish_at: string | null
  created_at: string
  updated_at: string
}

export interface ButtonVisibility {
  button_key: ButtonKey
  label: string
  visible: boolean
}

// ─── Aggregate passed to landing components ───────────────────────────────────

export interface CmsData {
  sections: LandingSection[]
  buttons: ButtonVisibility[]
}
