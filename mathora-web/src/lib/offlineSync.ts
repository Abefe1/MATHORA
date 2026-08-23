'use client';

/**
 * MATHORA NIGERIAN LOW-DATA & OFFLINE SYNC QUEUE
 * Matches Cross-Cutting Constraint §7: Allows students to answer questions offline
 * and automatically sync attempts to Supabase when network connectivity restores.
 */

export interface OfflineAttempt {
  id: string;
  student_id: string;
  question_id: string;
  topic_id: string;
  selected_option: 'A' | 'B' | 'C' | 'D';
  is_correct: boolean;
  time_taken_seconds: number;
  rescue_mode_triggered: boolean;
  attempted_at: string;
}

const STORAGE_KEY = 'mathora_offline_attempts';

export function enqueueAttempt(attempt: Omit<OfflineAttempt, 'id' | 'attempted_at'>) {
  const queue = getOfflineQueue();
  const newEntry: OfflineAttempt = {
    ...attempt,
    id: `offline-${Date.now()}-${Math.random().toString(36).substring(2, 7)}`,
    attempted_at: new Date().toISOString(),
  };

  queue.push(newEntry);
  if (typeof window !== 'undefined') {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(queue));
  }
  return newEntry;
}

export function getOfflineQueue(): OfflineAttempt[] {
  if (typeof window === 'undefined') return [];
  try {
    const data = localStorage.getItem(STORAGE_KEY);
    return data ? JSON.parse(data) : [];
  } catch {
    return [];
  }
}

export function clearOfflineQueue() {
  if (typeof window !== 'undefined') {
    localStorage.removeItem(STORAGE_KEY);
  }
}

// Removes only the given entries (by id) from the queue — used after a
// partially-successful flush, where some attempts synced and others
// need to stay queued for the next retry.
export function removeFromOfflineQueue(ids: string[]) {
  if (typeof window === 'undefined' || ids.length === 0) return;
  const remaining = getOfflineQueue().filter((a) => !ids.includes(a.id));
  if (remaining.length > 0) {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(remaining));
  } else {
    localStorage.removeItem(STORAGE_KEY);
  }
}

export const offlineSync = {
  saveAttemptOffline: enqueueAttempt,
  getQueue: getOfflineQueue,
  clearQueue: clearOfflineQueue,
  isOnline(): boolean {
    return typeof navigator !== 'undefined' ? navigator.onLine : true;
  },
};
