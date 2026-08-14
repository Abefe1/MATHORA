import { createClient } from '@/lib/supabase/server'
import { DEFAULT_SECTIONS, DEFAULT_BUTTONS } from './defaults'
import type { CmsData, LandingSection, ButtonVisibility } from './types'

/**
 * Fetches CMS data for the landing page.
 * draft=false → returns live_content (shown to public)
 * draft=true  → returns draft_content when has_draft=true, else live_content (admin preview)
 *
 * Scheduling is applied at read time:
 *  - If scheduled_unpublish_at is set and in the past, the section is hidden.
 *  - If scheduled_publish_at is set and in the past and has_draft=true,
 *    the draft content is treated as live (auto-applied).
 */
export async function getCmsData(opts: { draft?: boolean } = {}): Promise<CmsData> {
  try {
    const supabase = createClient()
    const now = new Date().toISOString()

    const [{ data: rawSections }, { data: rawButtons }] = await Promise.all([
      supabase
        .from('landing_sections')
        .select('*')
        .order('order_position', { ascending: true }),
      supabase
        .from('landing_button_visibility')
        .select('*'),
    ])

    const sections: LandingSection[] = (rawSections ?? DEFAULT_SECTIONS).map((s) => {
      // Scheduling: auto-unpublish
      let visible = s.visible
      if (s.scheduled_unpublish_at && s.scheduled_unpublish_at <= now) {
        visible = false
      }

      // Scheduling: auto-publish draft → live if scheduled_publish_at has passed
      let liveContent = s.live_content
      const scheduledPub = s.scheduled_publish_at
      if (scheduledPub && scheduledPub <= now && s.has_draft) {
        liveContent = s.draft_content
      }

      const content = opts.draft && s.has_draft ? s.draft_content : liveContent

      return { ...s, visible, live_content: content, draft_content: s.draft_content }
    })

    const buttons: ButtonVisibility[] = rawButtons ?? DEFAULT_BUTTONS

    return { sections, buttons }
  } catch {
    // Fall back to defaults if DB is unreachable (e.g., schema not yet applied)
    return { sections: DEFAULT_SECTIONS, buttons: DEFAULT_BUTTONS }
  }
}

/** Used only in admin API routes — returns full rows including both live and draft content. */
export async function getAllSectionsAdmin(): Promise<LandingSection[]> {
  const supabase = createClient()
  const { data, error } = await supabase
    .from('landing_sections')
    .select('*')
    .order('order_position', { ascending: true })
  if (error) throw error
  return data as LandingSection[]
}
