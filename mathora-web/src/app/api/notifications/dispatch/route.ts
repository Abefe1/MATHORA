import { NextResponse } from 'next/server';
import { createAdminClient } from '@/lib/supabase/admin';
import { sendExpoPush, sendWebPush } from '@/lib/pushSend';

export const dynamic = 'force-dynamic';

const BATCH_SIZE = 100;

/**
 * Polls notification_queue for pending rows and actually sends them
 * (Expo push for mobile, Web Push for browser subscriptions), then
 * writes the outcome to notification_log and marks the queue row
 * sent/failed. Meant to be hit by a scheduled job (pg_cron + pg_net,
 * or any external cron) every few minutes — see the deployment notes
 * at the top of mathora_schema_notifications_patch.sql.
 *
 * Authorization is a shared secret, not a user session: nothing about
 * this request comes from a browser, and it needs to read across every
 * user's push tokens, which is exactly what the service-role client
 * (lib/supabase/admin.ts) is for.
 */
export async function POST(request: Request) {
  const secret = process.env.NOTIFICATIONS_DISPATCH_SECRET;
  if (!secret) {
    return NextResponse.json({ error: 'NOTIFICATIONS_DISPATCH_SECRET is not configured' }, { status: 500 });
  }
  if (request.headers.get('x-notification-secret') !== secret) {
    return NextResponse.json({ error: 'unauthorized' }, { status: 401 });
  }

  const admin = createAdminClient();
  if (!admin) {
    return NextResponse.json({ error: 'Supabase admin client is not configured' }, { status: 500 });
  }

  const { data: pending, error: fetchError } = await admin
    .from('notification_queue')
    .select('id, user_id, type, title, body, data')
    .eq('status', 'pending')
    .order('created_at', { ascending: true })
    .limit(BATCH_SIZE);

  if (fetchError) {
    return NextResponse.json({ error: fetchError.message }, { status: 500 });
  }
  if (!pending || pending.length === 0) {
    return NextResponse.json({ processed: 0 });
  }

  let sent = 0;
  let failed = 0;

  for (const item of pending) {
    const { data: tokens } = await admin
      .from('push_tokens')
      .select('platform, token')
      .eq('user_id', item.user_id);

    const message = { title: item.title, body: item.body, data: item.data ?? {} };
    const mobileTokens = (tokens ?? []).filter((t) => t.platform !== 'web').map((t) => t.token);
    const webTokens = (tokens ?? []).filter((t) => t.platform === 'web').map((t) => t.token);

    let anyDelivered = mobileTokens.length === 0 && webTokens.length === 0 ? null : false;

    if (mobileTokens.length > 0) {
      const { ok } = await sendExpoPush(mobileTokens, message);
      if (ok.length > 0) anyDelivered = true;
    }

    for (const webToken of webTokens) {
      const ok = await sendWebPush(webToken, message);
      if (ok) anyDelivered = true;
    }

    // anyDelivered === null means the user has no registered devices
    // at all — not a delivery failure, just nothing to deliver to.
    // Still logged and marked sent so the queue doesn't retry forever
    // waiting for a device that may never arrive.
    const status = anyDelivered === false ? 'failed' : 'sent';
    if (status === 'sent') sent++;
    else failed++;

    await admin
      .from('notification_queue')
      .update({ status, sent_at: new Date().toISOString() })
      .eq('id', item.id);

    await admin.from('notification_log').insert({
      user_id: item.user_id,
      type: item.type,
      title: item.title,
      body: item.body,
      data: item.data ?? {},
    });
  }

  return NextResponse.json({ processed: pending.length, sent, failed });
}
