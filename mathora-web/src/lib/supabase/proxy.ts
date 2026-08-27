import { createServerClient } from '@supabase/ssr';
import { NextResponse, type NextRequest } from 'next/server';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || '';
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || '';

/**
 * Refreshes the Supabase session cookie on every request and returns
 * both the response to send downstream and the resolved user (or null).
 * Used by src/proxy.ts to enforce auth before a page ever renders.
 */
export async function updateSession(request: NextRequest) {
  let response = NextResponse.next({ request });

  if (!supabaseUrl || !supabaseAnonKey) {
    // Not configured yet — behave like a no-op so local/mock-data
    // development still works without a live Supabase project.
    return { response, user: null };
  }

  const supabase = createServerClient(supabaseUrl, supabaseAnonKey, {
    cookies: {
      getAll() {
        return request.cookies.getAll();
      },
      setAll(cookiesToSet) {
        cookiesToSet.forEach(({ name, value }) => request.cookies.set(name, value));
        response = NextResponse.next({ request });
        cookiesToSet.forEach(({ name, value, options }) =>
          response.cookies.set(name, value, options)
        );
      },
    },
  });

  // IMPORTANT: always use getUser() here, never getSession(). getUser()
  // revalidates the JWT against Supabase Auth; getSession() only reads
  // the (spoofable) cookie value.
  const {
    data: { user },
  } = await supabase.auth.getUser();

  return { response, user };
}
