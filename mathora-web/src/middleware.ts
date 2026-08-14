import { NextResponse, type NextRequest } from 'next/server';

// Public routes that don't enforce authentication
const PUBLIC_ROUTES = ['/', '/login', '/register'];

// Role to path mapping
const ROLE_PATHS: Record<string, string> = {
  student: '/student',
  teacher: '/teacher',
  parent: '/parent',
  super_admin: '/admin',
  content_admin: '/admin',
};

export async function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl;

  // Allow static assets, next internal paths, and public routes
  if (
    PUBLIC_ROUTES.some((route) => pathname === route) ||
    pathname.startsWith('/_next') ||
    pathname.startsWith('/api') ||
    pathname.includes('.')
  ) {
    return NextResponse.next();
  }

  // Next response
  return NextResponse.next();
}

export const config = {
  matcher: [
    '/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)',
  ],
};
