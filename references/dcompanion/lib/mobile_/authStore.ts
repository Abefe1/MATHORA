import { create } from 'zustand'
import { supabase } from '@/lib/supabase'
import type { Profile } from '@/lib/types'

interface AuthState {
  profile:    Profile | null
  loading:    boolean
  setProfile: (p: Profile | null) => void
  fetchProfile: (userId: string) => Promise<void>
  signIn:     (email: string, password: string) => Promise<{ error?: string }>
  signUp:     (data: SignUpData) => Promise<{ error?: string }>
  signOut:    () => Promise<void>
}

interface SignUpData {
  email: string; password: string; name: string
  role: 'student' | 'teacher' | 'parent'
  phone?: string; class?: string
  subject?: string; experience?: number; hourly_rate?: number
}

export const useAuthStore = create<AuthState>((set, get) => ({
  profile: null,
  loading: true,

  setProfile: (profile) => set({ profile, loading: false }),

  fetchProfile: async (userId) => {
    const { data } = await supabase.from('users').select('*').eq('id', userId).single()
    set({ profile: data, loading: false })
  },

  signIn: async (email, password) => {
    const { data, error } = await supabase.auth.signInWithPassword({ email, password })
    if (error) return { error: error.message }
    if (data.user) await get().fetchProfile(data.user.id)
    return {}
  },

  signUp: async (formData) => {
    const { data, error } = await supabase.auth.signUp({
      email: formData.email,
      password: formData.password,
      options: { data: { name: formData.name, role: formData.role } },
    })
    if (error) return { error: error.message }
    if (!data.user) return { error: 'Sign up failed' }

    // Insert public profile
    await supabase.from('users').insert({
      id: data.user.id, name: formData.name,
      email: formData.email, phone: formData.phone, role: formData.role,
    })

    // Role-specific tables
    if (formData.role === 'student') {
      const { data: student } = await supabase.from('students').insert({
        user_id: data.user.id, class: formData.class || 'JSS1'
      }).select().single()
      if (student) await supabase.from('progress').insert({ student_id: student.id })
    }
    if (formData.role === 'parent') {
      await supabase.from('parents').insert({
        user_id: data.user.id, phone: formData.phone || ''
      })
    }

    await get().fetchProfile(data.user.id)
    return {}
  },

  signOut: async () => {
    await supabase.auth.signOut()
    set({ profile: null })
  },
}))
