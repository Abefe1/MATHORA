'use client';

import React, { createContext, useContext, useEffect, useState, useCallback } from 'react';
import type { User } from '@supabase/supabase-js';
import { useRouter } from 'next/navigation';
import { createClient } from '@/lib/supabase/client';
import type { UserRole } from '@/lib/types';

interface AuthState {
  user: User | null;
  role: UserRole | null;
  loading: boolean;
  signOut: () => Promise<void>;
}

const AuthContext = createContext<AuthState>({
  user: null,
  role: null,
  loading: true,
  signOut: async () => {},
});

/**
 * Exposes the signed-in Supabase user (and their role, read from
 * user_metadata) to Client Components. Pages/components should read
 * the current user's id from here instead of hardcoding placeholder
 * ids like 'student-1' / 'teacher-1'.
 */
export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const supabase = createClient();
  const [loading, setLoading] = useState(() => !!supabase);
  const router = useRouter();

  useEffect(() => {
    if (!supabase) return;

    supabase.auth.getUser().then(({ data }) => {
      setUser(data.user ?? null);
      setLoading(false);
    });

    const { data: listener } = supabase.auth.onAuthStateChange((_event, session) => {
      setUser(session?.user ?? null);
    });

    return () => listener.subscription.unsubscribe();
  }, [supabase]);

  const signOut = useCallback(async () => {
    if (!supabase) return;
    await supabase.auth.signOut();
    setUser(null);
    router.push('/login');
    router.refresh();
  }, [supabase, router]);

  // app_metadata is server-controlled (stamped by the handle_new_user()
  // DB trigger at signup) — unlike user_metadata it can't be forged by
  // the client, so it's the only source trusted for role-gated UI.
  const role = (user?.app_metadata?.role ?? null) as UserRole | null;

  return (
    <AuthContext.Provider value={{ user, role, loading, signOut }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  return useContext(AuthContext);
}
