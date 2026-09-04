import { useCallback, useEffect, useRef, useState } from 'react';
import { AppState, AppStateStatus } from 'react-native';
import { flushOfflineAttempts, flushOfflineAssignmentAnswers } from '@/services/supabaseService';
import { getOfflineAttemptQueue, getOfflineAssignmentAnswerQueue } from '@/services/offlineSync';
import { useAuth } from '@/lib/authContext';

/**
 * Drives the offline queues (services/offlineSync.ts) that
 * recordMobileAttempt/submitAssignmentAnswer fall back to when a
 * request fails. Mirrors mathora-web/src/lib/useOfflineFlush.ts's
 * reasoning exactly, adapted for RN: there's no browser 'online' event
 * here, so returning to the foreground (AppState -> 'active') is the
 * retry trigger instead, same as supabaseService.ts already does for
 * Supabase's own token auto-refresh.
 */
export function useOfflineFlush() {
  const { user } = useAuth();
  const [pendingCount, setPendingCount] = useState(0);
  const [syncing, setSyncing] = useState(false);
  const mounted = useRef(true);

  const refreshCount = useCallback(async () => {
    const [attempts, answers] = await Promise.all([getOfflineAttemptQueue(), getOfflineAssignmentAnswerQueue()]);
    if (mounted.current) setPendingCount(attempts.length + answers.length);
  }, []);

  const flush = useCallback(async () => {
    const [attempts, answers] = await Promise.all([getOfflineAttemptQueue(), getOfflineAssignmentAnswerQueue()]);
    if (attempts.length === 0 && answers.length === 0) return;

    setSyncing(true);
    try {
      await Promise.all([flushOfflineAttempts(), flushOfflineAssignmentAnswers()]);
    } finally {
      setSyncing(false);
      refreshCount();
    }
  }, [refreshCount]);

  useEffect(() => {
    mounted.current = true;
    refreshCount();
    return () => {
      mounted.current = false;
    };
  }, [refreshCount]);

  useEffect(() => {
    const handler = (state: AppStateStatus) => {
      if (state === 'active') void flush();
    };
    const subscription = AppState.addEventListener('change', handler);
    return () => subscription.remove();
  }, [flush]);

  // A queued entry needs a signed-in user to resolve students.id —
  // retry right after sign-in too, same as web's equivalent effect.
  useEffect(() => {
    // eslint-disable-next-line react-hooks/set-state-in-effect
    if (user) void flush();
  }, [user, flush]);

  return { pendingCount, syncing };
}
