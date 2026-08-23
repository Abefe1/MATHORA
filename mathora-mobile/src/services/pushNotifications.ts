import * as Notifications from 'expo-notifications';
import * as Device from 'expo-device';
import Constants from 'expo-constants';
import { Platform } from 'react-native';
import { supabase } from './supabaseService';

// Foreground behavior: show an in-app banner + play sound even while
// the app is open, rather than only appearing in the OS tray.
Notifications.setNotificationHandler({
  handleNotification: async () => ({
    shouldShowBanner: true,
    shouldShowList: true,
    shouldPlaySound: true,
    shouldSetBadge: false,
  }),
});

export type RegisterPushResult =
  | { status: 'registered'; token: string }
  | { status: 'denied' }
  | { status: 'unsupported' } // simulator/emulator — push tokens require a physical device
  | { status: 'no_project_id' } // EAS project not linked yet, see comment below
  | { status: 'no_session' }
  | { status: 'error'; message: string };

/**
 * Requests notification permission, obtains this device's Expo push
 * token, and upserts it against the signed-in user in push_tokens
 * (see mathora_schema_notifications_patch.sql). Safe to call
 * repeatedly (e.g. every app foreground) — upsert is keyed on
 * (user_id, token).
 *
 * NOTE: there is currently no sign-in screen in mathora-mobile (see
 * PROMPT history) — this resolves the caller's identity via
 * supabase.auth.getSession(), so until mobile has its own auth flow
 * (or a session handed off from web), this returns { status:
 * 'no_session' } on every real device. The registration path itself
 * is complete and ready for when that lands.
 */
export async function registerForPushNotifications(): Promise<RegisterPushResult> {
  if (!Device.isDevice) {
    return { status: 'unsupported' };
  }

  const { status: existingStatus } = await Notifications.getPermissionsAsync();
  let finalStatus = existingStatus;
  if (existingStatus !== 'granted') {
    const { status } = await Notifications.requestPermissionsAsync();
    finalStatus = status;
  }
  if (finalStatus !== 'granted') {
    return { status: 'denied' };
  }

  if (Platform.OS === 'android') {
    await Notifications.setNotificationChannelAsync('default', {
      name: 'Mathora',
      importance: Notifications.AndroidImportance.DEFAULT,
      vibrationPattern: [0, 200, 100, 200],
      lightColor: '#2563EB',
    });
  }

  // getExpoPushTokenAsync needs the EAS project id (set once `eas
  // init` / `eas build:configure` links this app to a project — it
  // then appears at Constants.expoConfig.extra.eas.projectId).
  const projectId = Constants.expoConfig?.extra?.eas?.projectId;
  if (!projectId) {
    return { status: 'no_project_id' };
  }

  if (!supabase) {
    return { status: 'error', message: 'Supabase is not configured (missing env vars)' };
  }

  const { data: sessionData } = await supabase.auth.getSession();
  const userId = sessionData.session?.user.id;
  if (!userId) {
    return { status: 'no_session' };
  }

  try {
    const tokenResponse = await Notifications.getExpoPushTokenAsync({ projectId });
    const token = tokenResponse.data;

    const { error } = await supabase.from('push_tokens').upsert(
      {
        user_id: userId,
        platform: Platform.OS === 'ios' ? 'ios' : 'android',
        token,
        updated_at: new Date().toISOString(),
      },
      { onConflict: 'user_id,token' }
    );

    if (error) {
      return { status: 'error', message: error.message };
    }

    lastRegisteredToken = token;
    return { status: 'registered', token };
  } catch (err) {
    return { status: 'error', message: err instanceof Error ? err.message : String(err) };
  }
}

// Tracked so sign-out can clean up without re-requesting a token.
let lastRegisteredToken: string | null = null;

/** Removes this device's most recently registered token — call on sign-out. */
export async function unregisterCurrentPushToken() {
  if (!lastRegisteredToken) return;
  await unregisterPushToken(lastRegisteredToken);
  lastRegisteredToken = null;
}

/**
 * Removes this device's token from push_tokens — call on sign-out so
 * a shared/reset device doesn't keep receiving another user's
 * notifications.
 */
export async function unregisterPushToken(token: string) {
  if (!supabase) return;
  await supabase.from('push_tokens').delete().eq('token', token);
}
