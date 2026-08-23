// Must be the first import: RN's JS engine (Hermes) has no built-in
// URL/URLSearchParams implementation, which @supabase/supabase-js
// depends on. Importing this before anything else patches it in
// globally before any Supabase code runs.
import 'react-native-url-polyfill/auto';

import { DarkTheme, DefaultTheme, ThemeProvider } from 'expo-router';
import * as SplashScreen from 'expo-splash-screen';
import { useEffect } from 'react';
import { useColorScheme } from 'react-native';

import { AnimatedSplashOverlay } from '@/components/animated-icon';
import AppTabs from '@/components/app-tabs';
import { registerForPushNotifications } from '@/services/pushNotifications';

SplashScreen.preventAutoHideAsync();

export default function TabLayout() {
  const colorScheme = useColorScheme();

  useEffect(() => {
    // Silent no-op today: registerForPushNotifications() resolves to
    // { status: 'no_session' } until mathora-mobile has its own
    // sign-in flow (see that function's doc comment). Registering
    // eagerly on launch — rather than gating on a settings toggle —
    // matches how the rest of the app already treats push as an
    // implicit part of being signed in, not an opt-in feature.
    registerForPushNotifications();
  }, []);

  return (
    <ThemeProvider value={colorScheme === 'dark' ? DarkTheme : DefaultTheme}>
      <AnimatedSplashOverlay />
      <AppTabs />
    </ThemeProvider>
  );
}
