'use client';

import { createBrowserClient } from '@supabase/ssr';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || '';
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || '';

/**
 * Browser-side Supabase client for use inside Client Components.
 * Session lives in cookies (via @supabase/ssr) so it's readable by
 * both the server (proxy.ts, server components) and the browser.
 *
 * Returns null when env vars aren't configured yet, matching the
 * existing fallback-to-mock-data pattern in lib/supabase.ts.
 */
export function createClient() {
  if (!supabaseUrl || !supabaseAnonKey) return null;
  return createBrowserClient(supabaseUrl, supabaseAnonKey);
}
