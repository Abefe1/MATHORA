import 'server-only';
import { createClient as createSupabaseClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || '';
const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY || '';

/**
 * Service-role Supabase client — bypasses RLS entirely. Only ever
 * import this from server-only code that has no client bundle (the
 * `server-only` import above throws a build error if it leaks into
 * one). Used exclusively by the notification dispatcher, which
 * legitimately needs to read every user's push_tokens across roles —
 * something no RLS policy should ever grant to a normal session.
 *
 * SUPABASE_SERVICE_ROLE_KEY must never be prefixed NEXT_PUBLIC_ and
 * must never appear in any client component.
 */
export function createAdminClient() {
  if (!supabaseUrl || !serviceRoleKey) return null;
  return createSupabaseClient(supabaseUrl, serviceRoleKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  });
}
