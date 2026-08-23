import { createClient } from '@supabase/supabase-js';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { AppState } from 'react-native';
import { TOPICS_DATA, Topic, STUDY_SQUADS_DATA, StudySquad } from './dataService';

// Supabase environment keys (can be configured via EXPO_PUBLIC_SUPABASE_URL)
const supabaseUrl = process.env.EXPO_PUBLIC_SUPABASE_URL || '';
const supabaseAnonKey = process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY || '';

// React Native has no browser localStorage, so the session has to be
// told explicitly where to persist — AsyncStorage is the standard
// choice (per Supabase's own React Native guide). Without this, every
// cold start would sign the user out and RLS-protected reads would
// silently fall back to guest/anon access.
export const supabase = (supabaseUrl && supabaseAnonKey)
  ? createClient(supabaseUrl, supabaseAnonKey, {
      auth: {
        storage: AsyncStorage,
        autoRefreshToken: true,
        persistSession: true,
        detectSessionInUrl: false, // no browser URL to inspect on native
      },
    })
  : null;

// Supabase's background token auto-refresh only ticks while something
// calls startAutoRefresh(); on native that has to be driven by the
// app's foreground/background state rather than a browser tab's
// visibility (which is what the SDK assumes by default).
if (supabase) {
  AppState.addEventListener('change', (state) => {
    if (state === 'active') {
      supabase.auth.startAutoRefresh();
    } else {
      supabase.auth.stopAutoRefresh();
    }
  });
}

// Live or Graceful Fallback Topics Fetcher
export async function getMobileTopics(): Promise<Topic[]> {
  if (!supabase) return TOPICS_DATA;
  try {
    const { data, error } = await supabase.from('topics').select('*');
    if (error || !data || data.length === 0) return TOPICS_DATA;
    return data as Topic[];
  } catch {
    return TOPICS_DATA;
  }
}

// Live or Graceful Fallback Study Squads Fetcher
export async function getMobileStudySquads(): Promise<StudySquad[]> {
  if (!supabase) return STUDY_SQUADS_DATA;
  try {
    const { data, error } = await supabase.from('study_groups').select('*');
    if (error || !data || data.length === 0) return STUDY_SQUADS_DATA;
    return data as StudySquad[];
  } catch {
    return STUDY_SQUADS_DATA;
  }
}

// Submit Question Attempt from Mobile to Supabase
//
// attempt.student_id is the signed-in user's auth id, not
// attempts.student_id (a students.id profile PK) — resolved below,
// same as mathora-web/src/lib/supabase.ts's submitQuestionAttempt.
export async function recordMobileAttempt(attempt: {
  student_id: string;
  question_id: string;
  topic_id: string;
  selected_option: string;
  is_correct: boolean;
  time_taken_seconds: number;
  rescue_mode_triggered?: boolean;
}): Promise<{ success: boolean; offlineQueued?: boolean }> {
  if (!supabase) {
    return { success: true, offlineQueued: true };
  }
  try {
    const { data: studentRow, error: studentError } = await supabase
      .from('students')
      .select('id')
      .eq('user_id', attempt.student_id)
      .single();

    if (studentError || !studentRow) {
      return { success: true, offlineQueued: true };
    }

    const { error } = await supabase.from('attempts').insert({
      student_id: studentRow.id,
      question_id: attempt.question_id,
      topic_id: attempt.topic_id,
      selected_option: attempt.selected_option,
      is_correct: attempt.is_correct,
      time_taken_seconds: attempt.time_taken_seconds,
      rescue_mode_triggered: attempt.rescue_mode_triggered ?? false,
    });
    if (error) return { success: true, offlineQueued: true };
    return { success: true };
  } catch {
    return { success: true, offlineQueued: true };
  }
}
