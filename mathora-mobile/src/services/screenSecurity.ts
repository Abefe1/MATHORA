import { supabase } from './supabaseService';

/**
 * Logs an iOS screenshot attempt against exam/practice content (see
 * hooks/useBlockScreenCapture.ts — iOS has no API to actually block a
 * screenshot, only to detect it after the fact). Best-effort: no
 * session means no user_id to attribute it to, so it's silently
 * skipped rather than queued, since an anonymous screenshot report is
 * not actionable.
 */
export async function reportScreenshotAttempt(screen: string) {
  if (!supabase) return;
  const { data } = await supabase.auth.getSession();
  const userId = data.session?.user.id;
  if (!userId) return;

  await supabase.from('screenshot_events').insert({ user_id: userId, screen });
}
