'use client';

/**
 * MATHORA NIGERIAN LOW-DATA & OFFLINE SYNC QUEUE
 * Matches Cross-Cutting Constraint §7: Allows students to answer questions offline
 * and automatically sync attempts to Supabase when network connectivity restores.
 */

export interface OfflineAttempt {
  id: string;
  question_id: string;
  selected_letter: string;
  is_correct: boolean;
  attempted_at: string;
}

const STORAGE_KEY = 'mathora_offline_attempts';

export const offlineSync = {
  // Save attempt to local sync queue
  saveAttemptOffline(attempt: Omit<OfflineAttempt, 'id' | 'attempted_at'>) {
    const queue = this.getQueue();
    const newEntry: OfflineAttempt = {
      ...attempt,
      id: `offline-${Date.now()}-${Math.random().toString(36).substring(2, 7)}`,
      attempted_at: new Date().toISOString()
    };

    queue.push(newEntry);
    if (typeof window !== 'undefined') {
      localStorage.setItem(STORAGE_KEY, JSON.stringify(queue));
    }
    return newEntry;
  },

  // Retrieve current offline sync queue
  getQueue(): OfflineAttempt[] {
    if (typeof window === 'undefined') return [];
    try {
      const data = localStorage.getItem(STORAGE_KEY);
      return data ? JSON.parse(data) : [];
    } catch (e) {
      return [];
    }
  },

  // Clear queue after successful server sync
  clearQueue() {
    if (typeof window !== 'undefined') {
      localStorage.removeItem(STORAGE_KEY);
    }
  },

  // Check if network is online
  isOnline(): boolean {
    return typeof navigator !== 'undefined' ? navigator.onLine : true;
  }
};
