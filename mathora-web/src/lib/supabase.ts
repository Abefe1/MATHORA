import { createClient } from '@supabase/supabase-js';
import { INITIAL_TOPICS } from './mockData';
import { Topic, Question, WorkedExample } from './types';
import { enqueueAttempt } from './offlineSync';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || '';
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || '';

export const supabase = (supabaseUrl && supabaseAnonKey)
  ? createClient(supabaseUrl, supabaseAnonKey)
  : null;

// Fallback questions and worked examples extracted from INITIAL_TOPICS
const FALLBACK_QUESTIONS: Question[] = INITIAL_TOPICS.flatMap((t) => t.questions);
const FALLBACK_WORKED_EXAMPLES: WorkedExample[] = INITIAL_TOPICS.flatMap((t) => t.lessons.flatMap((l) => l.worked_examples));

// --- Student Topic Browsing ---
export async function fetchTopics(): Promise<Topic[]> {
  if (!supabase) return INITIAL_TOPICS;
  try {
    const { data, error } = await supabase.from('topics').select('*');
    if (error || !data || data.length === 0) return INITIAL_TOPICS;
    return data as Topic[];
  } catch {
    return INITIAL_TOPICS;
  }
}

// --- Practice Question Fetcher ---
export async function fetchQuestions(topicId?: string): Promise<Question[]> {
  if (!supabase) {
    return topicId ? FALLBACK_QUESTIONS.filter((q) => q.topic_id === topicId) : FALLBACK_QUESTIONS;
  }

  try {
    let query = supabase.from('questions').select('*');
    if (topicId) {
      query = query.eq('topic_id', topicId);
    }
    const { data, error } = await query;
    if (error || !data || data.length === 0) {
      return topicId ? FALLBACK_QUESTIONS.filter((q) => q.topic_id === topicId) : FALLBACK_QUESTIONS;
    }

    return data.map((q) => {
      const correctLetter = q.correct_letter || 'A';
      return {
        id: q.id,
        topic_id: q.topic_id,
        question_text: q.question_text,
        question_latex: q.question_latex || '',
        options: [
          { letter: 'A', text: q.option_a || 'Option A', is_correct: correctLetter === 'A' },
          { letter: 'B', text: q.option_b || 'Option B', is_correct: correctLetter === 'B' },
          { letter: 'C', text: q.option_c || 'Option C', is_correct: correctLetter === 'C' },
          { letter: 'D', text: q.option_d || 'Option D', is_correct: correctLetter === 'D' },
        ],
        correct_letter: correctLetter,
        explanation: q.explanation || '',
        difficulty: q.difficulty || 2,
        exam_type: q.exam_type || 'WAEC',
        exam_shortcut: q.exam_shortcut || '',
      };
    }) as Question[];
  } catch {
    return topicId ? FALLBACK_QUESTIONS.filter((q) => q.topic_id === topicId) : FALLBACK_QUESTIONS;
  }
}

// --- Worked Examples Fetcher ---
export async function fetchWorkedExamples(topicId?: string): Promise<WorkedExample[]> {
  if (!supabase) return FALLBACK_WORKED_EXAMPLES;
  try {
    const { data, error } = await supabase.from('worked_examples').select('*');
    if (error || !data || data.length === 0) return FALLBACK_WORKED_EXAMPLES;
    return data as WorkedExample[];
  } catch {
    return FALLBACK_WORKED_EXAMPLES;
  }
}

// --- Submit Attempt & Topic Mastery ---
//
// mathora_schema.sql's `attempts` table (student_id, question_id,
// topic_id, selected_option letter, is_correct, time_taken_seconds,
// rescue_mode_triggered) matches this insert's column shape directly —
// reconciled from an earlier normalized draft (selected_option_id /
// question_options / time_spent_seconds) to the flattened shape this
// app and mathora-mobile already use everywhere. topic_mastery is
// derived server-side by the on_attempt_recorded trigger, not written
// from here.
export async function submitQuestionAttempt(attempt: {
  student_id: string; // auth.uid() of the signed-in student — resolved to students.id below
  question_id: string;
  topic_id: string;
  selected_option: 'A' | 'B' | 'C' | 'D';
  is_correct: boolean;
  time_taken_seconds: number;
  rescue_mode_triggered: boolean;
}): Promise<{ success: boolean; offlineQueued?: boolean }> {
  if (!supabase || (typeof navigator !== 'undefined' && !navigator.onLine)) {
    enqueueAttempt(attempt);
    return { success: true, offlineQueued: true };
  }

  try {
    // attempts.student_id is a students.id (profile PK), not auth.uid() —
    // look up the caller's own profile row rather than trusting a
    // client-passed value for it.
    const { data: studentRow, error: studentError } = await supabase
      .from('students')
      .select('id')
      .eq('user_id', attempt.student_id)
      .single();

    if (studentError || !studentRow) {
      enqueueAttempt(attempt);
      return { success: true, offlineQueued: true };
    }

    const { error } = await supabase.from('attempts').insert({
      student_id: studentRow.id,
      question_id: attempt.question_id,
      topic_id: attempt.topic_id,
      selected_option: attempt.selected_option,
      is_correct: attempt.is_correct,
      time_taken_seconds: attempt.time_taken_seconds,
      rescue_mode_triggered: attempt.rescue_mode_triggered,
    });

    if (error) {
      enqueueAttempt(attempt);
      return { success: true, offlineQueued: true };
    }

    return { success: true };
  } catch {
    enqueueAttempt(attempt);
    return { success: true, offlineQueued: true };
  }
}

// --- Teacher Class Management ---
// `authUserId` is the signed-in teacher's auth.uid(), not classes.teacher_id
// (a teachers.id profile PK) — resolved below. There is no hardcoded
// fallback id here on purpose: without a real signed-in teacher this
// returns the local-only optimistic class rather than silently
// attributing a class to a placeholder account.
export async function createTeacherClassInSupabase(name: string, authUserId?: string): Promise<{ id: string; name: string; code: string; studentsCount: number; avgMastery: number }> {
  const generatedCode = `MATH-${Math.floor(1000 + Math.random() * 9000)}`;

  if (!supabase || !authUserId) {
    return {
      id: `c-${Date.now()}`,
      name,
      code: generatedCode,
      studentsCount: 0,
      avgMastery: 0,
    };
  }

  try {
    const { data: teacherRow, error: teacherError } = await supabase
      .from('teachers')
      .select('id')
      .eq('user_id', authUserId)
      .single();

    if (teacherError || !teacherRow) {
      return {
        id: `c-${Date.now()}`,
        name,
        code: generatedCode,
        studentsCount: 0,
        avgMastery: 0,
      };
    }

    const { data, error } = await supabase.from('classes').insert({
      teacher_id: teacherRow.id,
      name,
      join_code: generatedCode,
    }).select().single();

    if (error || !data) {
      return {
        id: `c-${Date.now()}`,
        name,
        code: generatedCode,
        studentsCount: 0,
        avgMastery: 0,
      };
    }

    return {
      id: data.id,
      name: data.name,
      code: data.join_code,
      studentsCount: 0,
      avgMastery: 0,
    };
  } catch {
    return {
      id: `c-${Date.now()}`,
      name,
      code: generatedCode,
      studentsCount: 0,
      avgMastery: 0,
    };
  }
}
