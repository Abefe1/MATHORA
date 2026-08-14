'use server'
import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'
import type { Role } from '@/lib/types'

const dashboardMap: Record<Role, string> = {
  student: '/student',
  teacher: '/teacher',
  parent:  '/parent',
  admin:   '/admin',
}

// ─── Sign In ────────────────────────────────────────────────────────────────
export async function signIn(formData: FormData) {
  const supabase = createClient()
  const email    = formData.get('email') as string
  const password = formData.get('password') as string

  const { error } = await supabase.auth.signInWithPassword({ email, password })
  if (error) return { error: error.message }

  // Fetch role from users table
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return { error: 'Could not retrieve user.' }

  const { data: profile } = await supabase
    .from('users')
    .select('role')
    .eq('id', user.id)
    .single()

  if (!profile) return { error: 'Profile not found.' }

  redirect(dashboardMap[profile.role as Role])
}

// ─── Sign Up ─────────────────────────────────────────────────────────────────
export async function signUp(formData: FormData) {
  const supabase = createClient()
  const email    = formData.get('email') as string
  const password = formData.get('password') as string
  const name     = formData.get('name') as string
  const role     = formData.get('role') as Role
  const phone    = formData.get('phone') as string | null

  // 1. Create auth user
  const { data: authData, error: authError } = await supabase.auth.signUp({
    email,
    password,
    options: { data: { name, role } },
  })

  if (authError) return { error: authError.message }
  if (!authData.user) return { error: 'Sign up failed.' }

  // 2. Insert into public.users
  const { error: profileError } = await supabase.from('users').insert({
    id:    authData.user.id,
    name,
    email,
    phone,
    role,
  })

  if (profileError) return { error: profileError.message }

  // 3. Insert role-specific table
  if (role === 'student') {
    const studentClass = formData.get('class') as string
    await supabase.from('students').insert({
      user_id: authData.user.id,
      class:   studentClass,
    })
    // Create empty progress record
    await supabase.from('progress').insert({ student_id: authData.user.id })
  }

  if (role === 'teacher') {
    const subject    = formData.get('subject') as string
    const experience = formData.get('experience') as string
    const hourlyRate = formData.get('hourly_rate') as string

    await supabase.from('teachers').insert({
      user_id:          authData.user.id,
      subject,
      experience_years: parseInt(experience) || 0,
      hourly_rate:      parseFloat(hourlyRate) || 0,
      verified:         false,
    })
  }

  if (role === 'parent') {
    await supabase.from('parents').insert({
      user_id: authData.user.id,
      phone:   phone || '',
    })
  }

  redirect(dashboardMap[role])
}

// ─── Sign Out ────────────────────────────────────────────────────────────────
export async function signOut() {
  const supabase = createClient()
  await supabase.auth.signOut()
  redirect('/login')
}
