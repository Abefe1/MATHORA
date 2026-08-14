import { NextResponse, type NextRequest } from 'next/server';

// Public routes that don't enforce authentication
const PUBLIC_ROUTES = ['/', '/login', '/register'];

export async function proxy(request: NextRequest) {
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

  return NextResponse.next();
}

export const config = {
  matcher: [
    '/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)',
  ],
};
