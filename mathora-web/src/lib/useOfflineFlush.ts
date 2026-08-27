'use client';

import { useEffect, useState, useCallback } from 'react';
import { flushOfflineQueue } from '@/lib/supabase';
import { getOfflineQueue } from '@/lib/offlineSync';
import { useAuth } from '@/lib/authContext';

/**
 * Drives the offline attempt queue (lib/offlineSync.ts) that
 * submitQuestionAttempt falls back to when the network is down or an
 * insert fails. Without this hook the queue was write-only: attempts
 * enqueued while offline, or when the request itself failed, sat in
 * localStorage forever with nothing ever reading them back out.
 *
 * Retries automatically when the browser regains connectivity or a
 * user signs in (queued attempts always need a resolvable student
 * profile), and exposes the current pending count for a UI indicator.
 */
export function useOfflineFlush() {
  const { user } = useAuth();
  // getOfflineQueue() is a synchronous localStorage read guarded for
  // typeof window === 'undefined', so the initial count can be derived
  // directly rather than set from an effect after mount.
  const [pendingCount, setPendingCount] = useState(() => getOfflineQueue().length);
  const [syncing, setSyncing] = useState(false);

  const refreshCount = useCallback(() => {
    setPendingCount(getOfflineQueue().length);
  }, []);

  const flush = useCallback(async () => {
    if (typeof navigator !== 'undefined' && !navigator.onLine) return;
    if (getOfflineQueue().length === 0) return;

    setSyncing(true);
    try {
      await flushOfflineQueue();
    } finally {
      setSyncing(false);
      refreshCount();
    }
  }, [refreshCount]);

  // Subscribing to the browser's connectivity event is exactly the
  // "synchronize with an external system" case React's docs carve out
  // for effects — there's no render-derivable value standing in for
  // "the network just came back", so the resync has to be triggered
  // from here.
  useEffect(() => {
    const handleOnline = () => {
      void flush();
    };
    window.addEventListener('online', handleOnline);
    return () => window.removeEventListener('online', handleOnline);
  }, [flush]);

  // A queued attempt needs a signed-in user to resolve students.id —
  // retry right after sign-in too, not just on reconnect. This is the
  // standard "re-fetch/re-sync when a dependency changes" effect
  // pattern; the lint rule's heuristic has no structural escape hatch
  // for it because flush() (eventually, post-await) calls setState —
  // suppressed deliberately rather than restructured.
  useEffect(() => {
    // eslint-disable-next-line react-hooks/set-state-in-effect
    if (user) void flush();
  }, [user, flush]);

  return { pendingCount, syncing };
}
