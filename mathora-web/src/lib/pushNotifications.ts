'use client';

import { createClient } from '@/lib/supabase/client';

export type WebPushStatus =
  | 'subscribed'
  | 'denied'
  | 'unsupported'
  | 'no_vapid_key'
  | 'no_session'
  | 'error';

function urlBase64ToUint8Array(base64String: string): Uint8Array<ArrayBuffer> {
  const padding = '='.repeat((4 - (base64String.length % 4)) % 4);
  const base64 = (base64String + padding).replace(/-/g, '+').replace(/_/g, '/');
  const rawData = atob(base64);
  // Uint8Array.from()'s return type widens .buffer to ArrayBufferLike
  // (which also covers SharedArrayBuffer) — pushManager.subscribe()'s
  // applicationServerKey wants a concrete ArrayBuffer-backed view, so
  // build it explicitly rather than relying on .from()'s inference.
  const bytes = new Uint8Array(new ArrayBuffer(rawData.length));
  for (let i = 0; i < rawData.length; i++) {
    bytes[i] = rawData.charCodeAt(i);
  }
  return bytes;
}

/**
 * Registers public/sw.js, requests browser notification permission,
 * and subscribes via the Push API — then upserts the subscription
 * into push_tokens (platform: 'web') so the dispatcher
 * (/api/notifications/dispatch) can reach this browser. Mirrors
 * mathora-mobile's registerForPushNotifications().
 */
export async function subscribeToWebPush(): Promise<WebPushStatus> {
  if (typeof window === 'undefined' || !('serviceWorker' in navigator) || !('PushManager' in window)) {
    return 'unsupported';
  }

  const vapidPublicKey = process.env.NEXT_PUBLIC_VAPID_PUBLIC_KEY;
  if (!vapidPublicKey) {
    return 'no_vapid_key';
  }

  const permission = await Notification.requestPermission();
  if (permission !== 'granted') {
    return 'denied';
  }

  const supabase = createClient();
  if (!supabase) return 'error';

  const { data: sessionData } = await supabase.auth.getSession();
  const userId = sessionData.session?.user.id;
  if (!userId) return 'no_session';

  try {
    const registration = await navigator.serviceWorker.register('/sw.js');
    await navigator.serviceWorker.ready;

    let subscription = await registration.pushManager.getSubscription();
    if (!subscription) {
      subscription = await registration.pushManager.subscribe({
        userVisibleOnly: true,
        applicationServerKey: urlBase64ToUint8Array(vapidPublicKey),
      });
    }

    const { error } = await supabase.from('push_tokens').upsert(
      {
        user_id: userId,
        platform: 'web',
        token: JSON.stringify(subscription),
        updated_at: new Date().toISOString(),
      },
      { onConflict: 'user_id,token' }
    );

    return error ? 'error' : 'subscribed';
  } catch {
    return 'error';
  }
}

export async function unsubscribeFromWebPush(): Promise<void> {
  if (typeof window === 'undefined' || !('serviceWorker' in navigator)) return;

  const registration = await navigator.serviceWorker.getRegistration('/sw.js');
  const subscription = await registration?.pushManager.getSubscription();
  if (!subscription) return;

  const supabase = createClient();
  if (supabase) {
    await supabase.from('push_tokens').delete().eq('token', JSON.stringify(subscription));
  }
  await subscription.unsubscribe();
}

export async function getWebPushSubscriptionStatus(): Promise<'subscribed' | 'not_subscribed' | 'unsupported'> {
  if (typeof window === 'undefined' || !('serviceWorker' in navigator) || !('PushManager' in window)) {
    return 'unsupported';
  }
  const registration = await navigator.serviceWorker.getRegistration('/sw.js');
  const subscription = await registration?.pushManager.getSubscription();
  return subscription ? 'subscribed' : 'not_subscribed';
}
