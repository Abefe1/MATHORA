import React, { createContext, useContext, useEffect, useState, useCallback } from 'react';
import type { User } from '@supabase/supabase-js';
import { supabase } from '@/services/supabaseService';
import { unregisterCurrentPushToken } from '@/services/pushNotifications';

interface AuthState {
  user: User | null;
  role: string | null;
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
 * Mirrors mathora-web/src/lib/authContext.tsx. Wraps the whole app
 * (see app/_layout.tsx) so any screen can read the signed-in user via
 * useAuth() instead of a hardcoded placeholder id.
 */
export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(() => !!supabase);

  useEffect(() => {
    if (!supabase) return;

    supabase.auth.getSession().then(({ data }) => {
      setUser(data.session?.user ?? null);
      setLoading(false);
    });

    const { data: listener } = supabase.auth.onAuthStateChange((_event, session) => {
      setUser(session?.user ?? null);
    });

    return () => listener.subscription.unsubscribe();
  }, []);

  const signOut = useCallback(async () => {
    if (!supabase) return;
    await unregisterCurrentPushToken();
    await supabase.auth.signOut();
    setUser(null);
  }, []);

  // Same trust rule as web: app_metadata is stamped server-side by the
  // handle_new_user() DB trigger and can't be forged by the client at
  // signup — user_metadata can, so it's never read for role gating.
  const role = (user?.app_metadata?.role ?? null) as string | null;

  return <AuthContext.Provider value={{ user, role, loading, signOut }}>{children}</AuthContext.Provider>;
}

export function useAuth() {
  return useContext(AuthContext);
}
