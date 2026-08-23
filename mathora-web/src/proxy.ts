import { NextResponse, type NextRequest } from 'next/server';
import { updateSession } from '@/lib/supabase/proxy';

// Public routes that don't enforce authentication
const PUBLIC_ROUTES = ['/', '/login', '/register'];

// Route prefixes restricted to a specific role. A signed-in user whose
// role doesn't match is bounced to their own "/<role>" home instead.
const ROLE_ROUTES: { prefix: string; role: string }[] = [
  { prefix: '/student', role: 'student' },
  { prefix: '/teacher', role: 'teacher' },
  { prefix: '/parent', role: 'parent' },
  { prefix: '/admin', role: 'content_admin' }, // any *_admin role, checked below
];

export async function proxy(request: NextRequest) {
  const { pathname } = request.nextUrl;

  // Allow static assets, next internal paths, and public routes to pass
  // through untouched — no session lookup needed.
  if (
    PUBLIC_ROUTES.some((route) => pathname === route) ||
    pathname.startsWith('/_next') ||
    pathname.startsWith('/api') ||
    pathname.includes('.')
  ) {
    return NextResponse.next();
  }

  const { response, user } = await updateSession(request);

  // Not signed in and hitting a protected route -> send to /login,
  // remembering where they were headed so we can bounce back after.
  if (!user) {
    const loginUrl = new URL('/login', request.url);
    loginUrl.searchParams.set('next', pathname);
    return NextResponse.redirect(loginUrl);
  }

  // Signed in: enforce role-scoped areas using the role stamped into
  // app_metadata by the handle_new_user() trigger at signup. Never read
  // user_metadata for this — it's client-writable at signUp() time and
  // trusting it would let a user grant themselves any role.
  const role = user.app_metadata?.role as string | undefined;
  const match = ROLE_ROUTES.find((r) => pathname.startsWith(r.prefix));
  if (match && role) {
    const isAdmin = match.prefix === '/admin' && role.endsWith('_admin');
    if (!isAdmin && role !== match.role) {
      return NextResponse.redirect(new URL(`/${role === 'student' ? 'student' : role}`, request.url));
    }
  }

  return response;
}

export const config = {
  matcher: [
    '/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)',
  ],
};
