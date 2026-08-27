// Must be the first import: RN's JS engine (Hermes) has no built-in
// URL/URLSearchParams implementation, which @supabase/supabase-js
// depends on. Importing this before anything else patches it in
// globally before any Supabase code runs.
import 'react-native-url-polyfill/auto';

import { DarkTheme, DefaultTheme, ThemeProvider, useRouter, useSegments } from 'expo-router';
import * as SplashScreen from 'expo-splash-screen';
import { useEffect } from 'react';
import { useColorScheme } from 'react-native';

import { AnimatedSplashOverlay } from '@/components/animated-icon';
import AppTabs from '@/components/app-tabs';
import { AuthProvider, useAuth } from '@/lib/authContext';
import { registerForPushNotifications } from '@/services/pushNotifications';

SplashScreen.preventAutoHideAsync();

const PUBLIC_ROUTES = ['login', 'register'];

function AuthGate({ children }: { children: React.ReactNode }) {
  const { user, loading } = useAuth();
  const router = useRouter();
  const segments = useSegments();

  useEffect(() => {
    if (loading) return;

    const onPublicRoute = PUBLIC_ROUTES.includes(segments[0] ?? '');
    if (!user && !onPublicRoute) {
      router.replace('/login');
    } else if (user && onPublicRoute) {
      router.replace('/');
    }
  }, [user, loading, segments, router]);

  useEffect(() => {
    // Registering only reacts to becoming signed in, rather than
    // running unconditionally on every launch — registerForPushNotifications()
    // resolves the current session itself, so this just avoids a
    // pointless call while signed out.
    if (user) registerForPushNotifications();
  }, [user]);

  return <>{children}</>;
}

export default function TabLayout() {
  const colorScheme = useColorScheme();

  return (
    <AuthProvider>
      <ThemeProvider value={colorScheme === 'dark' ? DarkTheme : DefaultTheme}>
        <AnimatedSplashOverlay />
        <AuthGate>
          <AppTabs />
        </AuthGate>
      </ThemeProvider>
    </AuthProvider>
  );
}
