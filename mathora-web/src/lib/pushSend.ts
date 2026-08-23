import 'server-only';
import webpush from 'web-push';

// Configure web-push once per process. VAPID keys are server-only env
// vars (the public half is also exposed as NEXT_PUBLIC_VAPID_PUBLIC_KEY
// for the browser's pushManager.subscribe() call — see
// lib/pushNotifications.ts). Generate a pair with `npx web-push
// generate-vapid-keys` and set both.
const vapidPublicKey = process.env.NEXT_PUBLIC_VAPID_PUBLIC_KEY || '';
const vapidPrivateKey = process.env.VAPID_PRIVATE_KEY || '';
const vapidConfigured = Boolean(vapidPublicKey && vapidPrivateKey);

if (vapidConfigured) {
  webpush.setVapidDetails('mailto:support@mathora.app', vapidPublicKey, vapidPrivateKey);
}

export type PushMessage = { title: string; body: string; data?: Record<string, unknown> };

/**
 * Sends via Expo's push service — a single HTTP endpoint that fans
 * out to APNs/FCM on Expo's side, so no platform-specific credentials
 * are needed here beyond the Expo access token (optional, raises the
 * default rate limit). See https://docs.expo.dev/push-notifications/sending-notifications/
 */
export async function sendExpoPush(tokens: string[], message: PushMessage): Promise<{ ok: string[]; failed: string[] }> {
  if (tokens.length === 0) return { ok: [], failed: [] };

  const accessToken = process.env.EXPO_ACCESS_TOKEN;
  const res = await fetch('https://exp.host/--/api/v2/push/send', {
    method: 'POST',
    headers: {
      'content-type': 'application/json',
      accept: 'application/json',
      ...(accessToken ? { authorization: `Bearer ${accessToken}` } : {}),
    },
    body: JSON.stringify(
      tokens.map((to) => ({ to, title: message.title, body: message.body, data: message.data ?? {} }))
    ),
  });

  if (!res.ok) {
    return { ok: [], failed: tokens };
  }

  const json = await res.json();
  const tickets: { status: 'ok' | 'error' }[] = json.data ?? [];
  const ok: string[] = [];
  const failed: string[] = [];
  tickets.forEach((ticket, i) => (ticket.status === 'ok' ? ok : failed).push(tokens[i]));
  return { ok, failed };
}

/**
 * Sends a single Web Push message. `subscriptionJson` is the
 * JSON-stringified PushSubscription saved by lib/pushNotifications.ts
 * (browser) into push_tokens.token.
 */
export async function sendWebPush(subscriptionJson: string, message: PushMessage): Promise<boolean> {
  if (!vapidConfigured) return false;

  try {
    const subscription = JSON.parse(subscriptionJson);
    await webpush.sendNotification(subscription, JSON.stringify(message));
    return true;
  } catch {
    return false;
  }
}
