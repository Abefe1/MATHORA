import { createServerClient } from '@supabase/ssr'
import { NextResponse, type NextRequest } from 'next/server'

// Routes that don't need auth
const PUBLIC_ROUTES = ['/login', '/register', '/']

// Role → allowed path prefix
const ROLE_PATHS: Record<string, string> = {
  student: '/student',
  teacher: '/teacher',
  parent:  '/parent',
  admin:   '/admin',
}

export async function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl

  // Allow public routes
  if (PUBLIC_ROUTES.some(r => pathname.startsWith(r))) {
    return NextResponse.next()
  }

  // Build Supabase client with cookie access
  let response = NextResponse.next({ request })

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        get(name)              { return request.cookies.get(name)?.value },
        set(name, value, opts) { response.cookies.set({ name, value, ...opts }) },
        remove(name, opts)     { response.cookies.set({ name, value: '', ...opts }) },
      },
    }
  )

  // Get session
  const { data: { user } } = await supabase.auth.getUser()

  // Not logged in → redirect to login
  if (!user) {
    return NextResponse.redirect(new URL('/login', request.url))
  }

  // Get profile to check role
  const { data: profile } = await supabase
    .from('users')
    .select('role')
    .eq('id', user.id)
    .single()

  if (!profile) {
    return NextResponse.redirect(new URL('/login', request.url))
  }

  const allowedPath = ROLE_PATHS[profile.role]

  // Wrong dashboard for role → redirect to correct one
  if (allowedPath && !pathname.startsWith(allowedPath)) {
    // Allow admin to access all paths
    if (profile.role === 'admin') return response
    return NextResponse.redirect(new URL(allowedPath, request.url))
  }

  return response
}

export const config = {
  matcher: [
    '/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)',
  ],
}
