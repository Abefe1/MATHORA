// MATHORA mobile offline sync queue — direct port of
// mathora-web/src/lib/offlineSync.ts's pattern (AsyncStorage instead of
// localStorage, otherwise identical shape). Queues an attempt/answer
// locally when the network is down or an insert fails, and gets
// flushed by useOfflineFlush.ts on reconnect/sign-in.
//
// AsyncStorage, not SecureStore, is the right choice here — this data
// is a student's own practice/assignment answers, not a session
// credential; nothing here needs Keychain/Keystore-grade protection,
// and AsyncStorage has no per-value size ceiling to worry about for a
// queue that can grow to many entries while offline.

import AsyncStorage from '@react-native-async-storage/async-storage';

export interface OfflineAttempt {
  id: string;
  student_id: string;
  question_id: string;
  topic_id: string;
  selected_option: string;
  is_correct: boolean;
  time_taken_seconds: number;
  rescue_mode_triggered: boolean;
  attempted_at: string;
}

export interface OfflineAssignmentAnswer {
  id: string;
  assignment_id: string;
  student_id: string;
  question_id: string;
  selected_option: string;
  is_correct: boolean;
  answered_at: string;
}

const ATTEMPT_STORAGE_KEY = 'mathora_offline_attempts';
const ASSIGNMENT_ANSWER_STORAGE_KEY = 'mathora_offline_assignment_answers';

function newId(): string {
  return `offline-${Date.now()}-${Math.random().toString(36).slice(2, 7)}`;
}

async function readQueue<T>(key: string): Promise<T[]> {
  try {
    const raw = await AsyncStorage.getItem(key);
    return raw ? (JSON.parse(raw) as T[]) : [];
  } catch {
    return [];
  }
}

async function writeQueue<T>(key: string, queue: T[]): Promise<void> {
  try {
    if (queue.length > 0) {
      await AsyncStorage.setItem(key, JSON.stringify(queue));
    } else {
      await AsyncStorage.removeItem(key);
    }
  } catch {
    // best-effort persistence — a failed write here just means the
    // entry only lives in memory for this session, not a crash
  }
}

export async function enqueueAttempt(attempt: Omit<OfflineAttempt, 'id' | 'attempted_at'>): Promise<OfflineAttempt> {
  const queue = await readQueue<OfflineAttempt>(ATTEMPT_STORAGE_KEY);
  const entry: OfflineAttempt = { ...attempt, id: newId(), attempted_at: new Date().toISOString() };
  queue.push(entry);
  await writeQueue(ATTEMPT_STORAGE_KEY, queue);
  return entry;
}

export async function getOfflineAttemptQueue(): Promise<OfflineAttempt[]> {
  return readQueue<OfflineAttempt>(ATTEMPT_STORAGE_KEY);
}

export async function removeFromOfflineAttemptQueue(ids: string[]): Promise<void> {
  if (ids.length === 0) return;
  const remaining = (await readQueue<OfflineAttempt>(ATTEMPT_STORAGE_KEY)).filter((a) => !ids.includes(a.id));
  await writeQueue(ATTEMPT_STORAGE_KEY, remaining);
}

export async function enqueueAssignmentAnswer(
  answer: Omit<OfflineAssignmentAnswer, 'id' | 'answered_at'>
): Promise<OfflineAssignmentAnswer> {
  const queue = await readQueue<OfflineAssignmentAnswer>(ASSIGNMENT_ANSWER_STORAGE_KEY);
  const entry: OfflineAssignmentAnswer = { ...answer, id: newId(), answered_at: new Date().toISOString() };
  queue.push(entry);
  await writeQueue(ASSIGNMENT_ANSWER_STORAGE_KEY, queue);
  return entry;
}

export async function getOfflineAssignmentAnswerQueue(): Promise<OfflineAssignmentAnswer[]> {
  return readQueue<OfflineAssignmentAnswer>(ASSIGNMENT_ANSWER_STORAGE_KEY);
}

export async function removeFromOfflineAssignmentAnswerQueue(ids: string[]): Promise<void> {
  if (ids.length === 0) return;
  const remaining = (await readQueue<OfflineAssignmentAnswer>(ASSIGNMENT_ANSWER_STORAGE_KEY)).filter(
    (a) => !ids.includes(a.id)
  );
  await writeQueue(ASSIGNMENT_ANSWER_STORAGE_KEY, remaining);
}
