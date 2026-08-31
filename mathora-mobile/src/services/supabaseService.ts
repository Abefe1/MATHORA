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
//
// Reads from study_groups_with_stats (mathora_schema_study_groups_patch.sql),
// not the raw study_groups table -- member_count/weekly_progress_questions/
// rank_position/top_members are computed aggregates, not stored columns, so
// only the view's shape matches StudySquad.
export async function getMobileStudySquads(): Promise<StudySquad[]> {
  if (!supabase) return STUDY_SQUADS_DATA;
  try {
    const { data, error } = await supabase.from('study_groups_with_stats').select('*');
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

// ==========================================
// Multi-tenant schools / classes / roster
// Mirrors mathora-web/src/lib/supabase.ts's equivalent functions —
// same RPCs (mathora_schema_schools_patch.sql), same shapes. See that
// file's comments for the reasoning behind each RPC vs. direct-table
// choice; not repeated here to avoid drift between two copies of the
// same explanation.
// ==========================================

export type ClassLevel = 'JSS1' | 'JSS2' | 'JSS3' | 'SS1' | 'SS2' | 'SS3';
export type SchoolStatus = 'active' | 'pending' | 'rejected';

export interface School {
  id: string;
  name: string;
  state: string;
  address?: string | null;
  status: SchoolStatus;
  verified: boolean;
  created_by_teacher_id?: string | null;
  created_at: string;
  updated_at: string;
}

export interface ClassDirectoryEntry {
  id: string;
  name: string;
  class_level: ClassLevel;
  teacher_id: string;
  school_id: string;
  created_at: string;
}

export interface ClassRosterEntry {
  id: string;
  class_id: string;
  full_name: string;
  verification_value?: string | null;
  claimed_by_student_id?: string | null;
  claimed_at?: string | null;
  created_at: string;
}

export interface ClassJoinRequest {
  id: string;
  class_id: string;
  student_id: string;
  verification_value?: string | null;
  status: 'pending' | 'approved' | 'rejected';
  decided_at?: string | null;
  created_at: string;
}

export type TeacherDirectoryEntry = { id: string; full_name: string; verified: boolean };

export async function searchSchools(query: string): Promise<School[]> {
  if (!supabase) return [];
  try {
    const { data, error } = await supabase.from('schools').select('*').ilike('name', `%${query}%`).limit(20);
    if (error || !data) return [];
    return data as School[];
  } catch {
    return [];
  }
}

export async function createOrSuggestSchool(name: string, state: string, address?: string): Promise<School> {
  if (!supabase) throw new Error('Not connected');
  const { data, error } = await supabase.rpc('create_or_suggest_school', {
    p_name: name,
    p_state: state,
    p_address: address ?? null,
  });
  if (error) throw new Error(error.message);
  return data as School;
}

export async function joinSchool(schoolId: string): Promise<boolean> {
  if (!supabase) return false;
  const { error } = await supabase.rpc('join_school', { p_school_id: schoolId });
  return !error;
}

export async function fetchMyTeacherSchoolId(authUserId: string): Promise<string | null> {
  if (!supabase) return null;
  try {
    const { data, error } = await supabase.from('teachers').select('school_id').eq('user_id', authUserId).single();
    if (error || !data) return null;
    return data.school_id ?? null;
  } catch {
    return null;
  }
}

export async function createTeacherClass(
  name: string,
  classLevel: ClassLevel
): Promise<{ id: string; name: string; code: string } | null> {
  if (!supabase) return null;
  const { data, error } = await supabase.rpc('create_class', { p_name: name, p_class_level: classLevel });
  if (error || !data) return null;
  return { id: data.id, name: data.name, code: data.join_code };
}

export async function fetchTeachersAtSchool(schoolId: string): Promise<TeacherDirectoryEntry[]> {
  if (!supabase) return [];
  try {
    const { data: teacherRows, error: teacherError } = await supabase
      .from('teachers')
      .select('id, user_id, verified')
      .eq('school_id', schoolId);
    if (teacherError || !teacherRows || teacherRows.length === 0) return [];

    const { data: userRows, error: userError } = await supabase
      .from('users')
      .select('id, full_name')
      .in('id', teacherRows.map((t) => t.user_id));
    if (userError || !userRows) return [];

    const nameById = new Map(userRows.map((u) => [u.id, u.full_name as string]));
    return teacherRows.map((t) => ({
      id: t.id,
      full_name: nameById.get(t.user_id) ?? 'Unnamed Teacher',
      verified: t.verified,
    }));
  } catch {
    return [];
  }
}

export async function fetchClassDirectory(teacherId: string): Promise<ClassDirectoryEntry[]> {
  if (!supabase) return [];
  try {
    const { data, error } = await supabase.from('class_directory').select('*').eq('teacher_id', teacherId);
    if (error || !data) return [];
    return data as ClassDirectoryEntry[];
  } catch {
    return [];
  }
}

export async function bulkAddRosterEntries(
  classId: string,
  entries: { full_name: string; verification_value?: string }[]
): Promise<ClassRosterEntry[]> {
  if (!supabase) return [];
  const { data, error } = await supabase.rpc('bulk_add_roster_entries', { p_class_id: classId, p_entries: entries });
  if (error || !data) return [];
  return data as ClassRosterEntry[];
}

export async function fetchClassRoster(classId: string): Promise<ClassRosterEntry[]> {
  if (!supabase) return [];
  try {
    const { data, error } = await supabase.from('class_roster_entries').select('*').eq('class_id', classId).order('created_at');
    if (error || !data) return [];
    return data as ClassRosterEntry[];
  } catch {
    return [];
  }
}

export async function fetchPendingJoinRequests(classId: string): Promise<ClassJoinRequest[]> {
  if (!supabase) return [];
  try {
    const { data, error } = await supabase
      .from('class_join_requests')
      .select('*')
      .eq('class_id', classId)
      .eq('status', 'pending')
      .order('created_at');
    if (error || !data) return [];
    return data as ClassJoinRequest[];
  } catch {
    return [];
  }
}

export async function decideJoinRequest(requestId: string, approve: boolean): Promise<boolean> {
  if (!supabase) return false;
  const { error } = await supabase.rpc('decide_join_request', { p_request_id: requestId, p_approve: approve });
  return !error;
}

export async function findOrRequestClassJoin(
  classId: string,
  verificationValue?: string
): Promise<{ status: 'joined' | 'already_member' | 'pending' } | null> {
  if (!supabase) return null;
  const { data, error } = await supabase.rpc('find_or_request_class_join', {
    p_class_id: classId,
    p_verification_value: verificationValue ?? null,
  });
  if (error || !data) return null;
  return data as { status: 'joined' | 'already_member' | 'pending' };
}

// Existing invite-link RPC (join_class_with_code, mathora_schema_auth_patch.sql)
// wired here for the deep-link handler in app/join/[code].tsx.
export async function joinClassWithCode(code: string): Promise<{ id: string; name: string } | null> {
  if (!supabase) return null;
  const { data, error } = await supabase.rpc('join_class_with_code', { code });
  if (error || !data) return null;
  return { id: data.id, name: data.name };
}

// --- Analysis screen stats — mirrors mathora-web/src/lib/supabase.ts's
// fetchAnalysisStats/fetchMyStudentProfileId exactly (same RLS, no new
// SQL — attempts_select_own_or_related/topic_mastery_select_own_or_related
// from mathora_schema_auth_patch.sql already cover both the student's own
// view and a parent's view of a linked child).
export interface AnalysisStats {
  totalAttempted: number;
  totalCorrect: number;
  currentStreakDays: number;
  weeklyPracticedDays: number;
  practicedWeekdayFlags: boolean[];
  overallMasteryPercentage: number;
}

const EMPTY_ANALYSIS_STATS: AnalysisStats = {
  totalAttempted: 0,
  totalCorrect: 0,
  currentStreakDays: 0,
  weeklyPracticedDays: 0,
  practicedWeekdayFlags: [false, false, false, false, false, false, false],
  overallMasteryPercentage: 0,
};

export async function fetchMyStudentProfileId(authUserId: string): Promise<string | null> {
  if (!supabase) return null;
  try {
    const { data, error } = await supabase.from('students').select('id').eq('user_id', authUserId).single();
    if (error || !data) return null;
    return data.id;
  } catch {
    return null;
  }
}

export async function fetchAnalysisStats(studentProfileId: string): Promise<AnalysisStats> {
  if (!supabase) return EMPTY_ANALYSIS_STATS;
  try {
    const [{ data: attempts }, { data: masteryRows }] = await Promise.all([
      supabase
        .from('attempts')
        .select('is_correct, attempted_at')
        .eq('student_id', studentProfileId)
        .order('attempted_at', { ascending: false })
        .limit(500),
      supabase.from('topic_mastery').select('mastery_percentage').eq('student_id', studentProfileId),
    ]);

    const totalAttempted = attempts?.length ?? 0;
    const totalCorrect = attempts?.filter((a) => a.is_correct).length ?? 0;

    const now = new Date();
    const dayOfWeek = (now.getDay() + 6) % 7;
    const startOfWeek = new Date(now);
    startOfWeek.setDate(now.getDate() - dayOfWeek);
    startOfWeek.setHours(0, 0, 0, 0);

    const weeklyDaySet = new Set<string>();
    const allDaySet = new Set<string>();
    const practicedWeekdayFlags = [false, false, false, false, false, false, false];
    (attempts ?? []).forEach((a) => {
      const d = new Date(a.attempted_at);
      const key = d.toDateString();
      allDaySet.add(key);
      if (d >= startOfWeek) {
        weeklyDaySet.add(key);
        practicedWeekdayFlags[(d.getDay() + 6) % 7] = true;
      }
    });

    let currentStreakDays = 0;
    const cursor = new Date();
    cursor.setHours(0, 0, 0, 0);
    while (allDaySet.has(cursor.toDateString())) {
      currentStreakDays += 1;
      cursor.setDate(cursor.getDate() - 1);
    }

    const overallMasteryPercentage =
      masteryRows && masteryRows.length > 0
        ? Math.round(masteryRows.reduce((sum, m) => sum + (m.mastery_percentage ?? 0), 0) / masteryRows.length)
        : 0;

    return {
      totalAttempted,
      totalCorrect,
      currentStreakDays,
      weeklyPracticedDays: weeklyDaySet.size,
      practicedWeekdayFlags,
      overallMasteryPercentage,
    };
  } catch {
    return EMPTY_ANALYSIS_STATS;
  }
}
