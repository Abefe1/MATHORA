import { createServerClient } from '@supabase/ssr';
import { cookies } from 'next/headers';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || '';
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || '';

/**
 * Server-side Supabase client for use inside Server Components, Route
 * Handlers, and Server Actions. Reads/writes the session cookie so it
 * stays in sync with proxy.ts and the browser client.
 *
 * Returns null when env vars aren't configured yet, matching the
 * existing fallback-to-mock-data pattern in lib/supabase.ts.
 */
export async function createClient() {
  if (!supabaseUrl || !supabaseAnonKey) return null;
  const cookieStore = await cookies();

  return createServerClient(supabaseUrl, supabaseAnonKey, {
    cookies: {
      getAll() {
        return cookieStore.getAll();
      },
      setAll(cookiesToSet) {
        try {
          cookiesToSet.forEach(({ name, value, options }) =>
            cookieStore.set(name, value, options)
          );
        } catch {
          // setAll called from a Server Component — safe to ignore
          // because proxy.ts already refreshes the session cookie.
        }
      },
    },
  });
}
