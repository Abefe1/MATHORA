import { createClient } from '@supabase/supabase-js';
import * as SecureStore from 'expo-secure-store';
import { AppState } from 'react-native';
import { TOPICS_DATA, Topic, STUDY_SQUADS_DATA, StudySquad } from './dataService';
import {
  enqueueAttempt,
  getOfflineAttemptQueue,
  removeFromOfflineAttemptQueue,
  enqueueAssignmentAnswer,
  getOfflineAssignmentAnswerQueue,
  removeFromOfflineAssignmentAnswerQueue,
  type OfflineAttempt,
  type OfflineAssignmentAnswer,
} from './offlineSync';

// Supabase environment keys (can be configured via EXPO_PUBLIC_SUPABASE_URL)
const supabaseUrl = process.env.EXPO_PUBLIC_SUPABASE_URL || '';
const supabaseAnonKey = process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY || '';

// React Native has no browser localStorage, so the session has to be
// told explicitly where to persist. AsyncStorage (the previous choice
// here, and still the option Supabase's own guide leads with) is
// unencrypted on both platforms — a plain SQLite DB on Android, a
// plist on iOS — readable by anything with filesystem access to a
// rooted/jailbroken device. expo-secure-store backs onto the iOS
// Keychain / Android Keystore instead, so the session (access +
// refresh token) is actually encrypted at rest. Its API isn't
// AsyncStorage-shaped (no `multiGet`/`multiSet`, everything's a plain
// string), so this small adapter bridges the two.
//
// Known trade-off, not fixed here: Keychain/Keystore-backed storage
// has historically had a ~2048-byte per-value limit on some Android
// versions, and a Supabase session (JWT + refresh token + metadata)
// can occasionally brush against that. This is the same limitation
// every Supabase + Expo SecureStore setup accepts (it's the pattern in
// Supabase's own docs) — a chunking storage adapter would close it
// fully but is out of scope for this pass.
const SecureStoreAdapter = {
  getItem: (key: string) => SecureStore.getItemAsync(key),
  setItem: (key: string, value: string) => SecureStore.setItemAsync(key, value),
  removeItem: (key: string) => SecureStore.deleteItemAsync(key),
};

export const supabase = (supabaseUrl && supabaseAnonKey)
  ? createClient(supabaseUrl, supabaseAnonKey, {
      auth: {
        storage: SecureStoreAdapter,
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

type MobileAttemptInput = {
  student_id: string; // auth uid, resolved to students.id below
  question_id: string;
  topic_id: string;
  selected_option: string;
  is_correct: boolean;
  time_taken_seconds: number;
  rescue_mode_triggered?: boolean;
};

// Shared by recordMobileAttempt (live path) and flushOfflineAttempts
// (retry path). Returns false (never throws) on any failure so callers
// decide whether to queue/re-queue — same contract as
// mathora-web/src/lib/supabase.ts's insertAttemptRow.
async function insertAttemptRow(attempt: MobileAttemptInput): Promise<boolean> {
  if (!supabase) return false;
  try {
    const { data: studentRow, error: studentError } = await supabase
      .from('students')
      .select('id')
      .eq('user_id', attempt.student_id)
      .single();
    if (studentError || !studentRow) return false;

    const { error } = await supabase.from('attempts').insert({
      student_id: studentRow.id,
      question_id: attempt.question_id,
      topic_id: attempt.topic_id,
      selected_option: attempt.selected_option,
      is_correct: attempt.is_correct,
      time_taken_seconds: attempt.time_taken_seconds,
      rescue_mode_triggered: attempt.rescue_mode_triggered ?? false,
    });
    return !error;
  } catch {
    return false;
  }
}

// Submit Question Attempt from Mobile to Supabase.
//
// Previously this returned { success: true, offlineQueued: true } on
// every failure path with no actual queue behind it — a silently
// dropped attempt, not a deferred one. It now really queues (AsyncStorage,
// via services/offlineSync.ts) and useOfflineFlush.ts retries it on
// reconnect/sign-in, same contract as mathora-web's submitQuestionAttempt.
export async function recordMobileAttempt(
  rawAttempt: MobileAttemptInput
): Promise<{ success: boolean; offlineQueued?: boolean }> {
  // OfflineAttempt (offlineSync.ts) requires rescue_mode_triggered as a
  // plain boolean — MobileAttemptInput leaves it optional at the call
  // site (most callers don't set it), so normalize once here rather
  // than at every enqueueAttempt call below.
  const attempt = { ...rawAttempt, rescue_mode_triggered: rawAttempt.rescue_mode_triggered ?? false };

  if (!supabase) {
    await enqueueAttempt(attempt);
    return { success: true, offlineQueued: true };
  }

  // No connectivity API without adding @react-native-netinfo — just
  // attempt the insert and let insertAttemptRow's try/catch decide
  // (a network failure surfaces as `!ok` the same as an RLS rejection
  // would, both fall back to the offline queue either way).
  const ok = await insertAttemptRow(attempt);
  if (!ok) {
    await enqueueAttempt(attempt);
    return { success: true, offlineQueued: true };
  }
  return { success: true };
}

// Retries every locally-queued attempt — call this on app-foreground
// and sign-in (see hooks/useOfflineFlush.ts).
export async function flushOfflineAttempts(): Promise<{ synced: number; remaining: number }> {
  const queue: OfflineAttempt[] = await getOfflineAttemptQueue();
  if (!supabase || queue.length === 0) return { synced: 0, remaining: queue.length };

  const syncedIds: string[] = [];
  for (const entry of queue) {
    const ok = await insertAttemptRow(entry);
    if (ok) syncedIds.push(entry.id);
  }
  if (syncedIds.length > 0) await removeFromOfflineAttemptQueue(syncedIds);
  return { synced: syncedIds.length, remaining: queue.length - syncedIds.length };
}

// ==========================================
// Multi-tenant schools / classes / roster
// Mirrors mathora-web/src/lib/supabase.ts's equivalent functions —
// same RPCs (mathora_schema_schools_patch.sql), same shapes. See that
// file's comments for the reasoning behind each RPC vs. direct-table
// choice; not repeated here to avoid drift between two copies of the
// same explanation.
// ==========================================

// PRI1-PRI6 (primary/"basic" levels) are schema-ready ahead of any
// actual primary-level content — see
// mathora_schema_subjects_and_primary_levels_patch.sql. The platform
// only serves JSS1-SS3 today. Kept in sync with mathora-web's
// lib/types.ts ClassLevel by hand (two copies, same DB enum).
export type ClassLevel =
  | 'PRI1' | 'PRI2' | 'PRI3' | 'PRI4' | 'PRI5' | 'PRI6'
  | 'JSS1' | 'JSS2' | 'JSS3'
  | 'SS1' | 'SS2' | 'SS3';
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

// --- Per-topic mastery breakdown for one student — mirrors
// mathora-web/src/lib/supabase.ts's fetchTopicScores exactly. Needed
// because dataService.Topic's mastery_percentage/status fields are
// mock-only: the live `topics` table has no such columns, so
// getMobileTopics()'s real rows come back with those fields undefined.
// This is the real source for a topic's mastery.
export interface TopicScore {
  topic_id: string;
  topic_title: string;
  class_level: string;
  term: number | null;
  order_index: number;
  total_attempted: number;
  total_correct: number;
  mastery_percentage: number;
}

export async function fetchTopicScores(studentProfileId: string): Promise<TopicScore[]> {
  if (!supabase) return [];
  try {
    const { data, error } = await supabase
      .from('topic_mastery')
      .select('topic_id, total_attempted, total_correct, mastery_percentage, topics!inner(title, class_level, term, order_index)')
      .eq('student_id', studentProfileId);
    if (error || !data) return [];
    return (data as unknown as {
      topic_id: string; total_attempted: number; total_correct: number; mastery_percentage: number;
      topics: { title: string; class_level: string; term: number | null; order_index: number };
    }[])
      .map((row) => ({
        topic_id: row.topic_id,
        topic_title: row.topics.title,
        class_level: row.topics.class_level,
        term: row.topics.term,
        order_index: row.topics.order_index,
        total_attempted: row.total_attempted,
        total_correct: row.total_correct,
        mastery_percentage: row.mastery_percentage,
      }))
      .sort((a, b) => a.order_index - b.order_index);
  } catch {
    return [];
  }
}

// --- Class score summary (roster export "with scores") — mirrors
// mathora-web/src/lib/supabase.ts's fetchClassScoreSummary exactly:
// same tables, same term-scoped topic_mastery join, same aggregation.
export interface ClassStudentScore {
  student_id: string;
  full_name: string;
  total_attempted: number;
  total_correct: number;
  average_mastery_percentage: number;
}

export interface ClassScoreSummary {
  students: ClassStudentScore[];
  class_average_mastery_percentage: number;
  class_total_attempted: number;
  class_total_correct: number;
}

export async function fetchClassScoreSummary(classId: string, term?: 1 | 2 | 3): Promise<ClassScoreSummary> {
  const empty: ClassScoreSummary = { students: [], class_average_mastery_percentage: 0, class_total_attempted: 0, class_total_correct: 0 };
  if (!supabase) return empty;
  try {
    const { data: members, error: membersError } = await supabase
      .from('class_students')
      .select('student_id, students!inner(id, users!inner(full_name))')
      .eq('class_id', classId);
    if (membersError || !members || members.length === 0) return empty;

    const rows = members as unknown as { student_id: string; students: { id: string; users: { full_name: string } } }[];
    const studentIds = rows.map((r) => r.student_id);

    const masteryQuery = term
      ? supabase
          .from('topic_mastery')
          .select('student_id, total_attempted, total_correct, mastery_percentage, topics!inner(term)')
          .in('student_id', studentIds)
          .eq('topics.term', term)
      : supabase
          .from('topic_mastery')
          .select('student_id, total_attempted, total_correct, mastery_percentage')
          .in('student_id', studentIds);

    const { data: masteryRows } = await masteryQuery;

    const byStudent = new Map<string, { attempted: number; correct: number; masterySum: number; masteryCount: number }>();
    for (const m of masteryRows ?? []) {
      const bucket = byStudent.get(m.student_id) ?? { attempted: 0, correct: 0, masterySum: 0, masteryCount: 0 };
      bucket.attempted += m.total_attempted;
      bucket.correct += m.total_correct;
      bucket.masterySum += m.mastery_percentage;
      bucket.masteryCount += 1;
      byStudent.set(m.student_id, bucket);
    }

    const students: ClassStudentScore[] = rows.map((r) => {
      const bucket = byStudent.get(r.student_id) ?? { attempted: 0, correct: 0, masterySum: 0, masteryCount: 0 };
      return {
        student_id: r.student_id,
        full_name: r.students.users.full_name,
        total_attempted: bucket.attempted,
        total_correct: bucket.correct,
        average_mastery_percentage: bucket.masteryCount ? Math.round(bucket.masterySum / bucket.masteryCount) : 0,
      };
    });

    const class_total_attempted = students.reduce((sum, s) => sum + s.total_attempted, 0);
    const class_total_correct = students.reduce((sum, s) => sum + s.total_correct, 0);
    const withMastery = students.filter((s) => s.total_attempted > 0);
    const class_average_mastery_percentage = withMastery.length
      ? Math.round(withMastery.reduce((sum, s) => sum + s.average_mastery_percentage, 0) / withMastery.length)
      : 0;

    return { students, class_average_mastery_percentage, class_total_attempted, class_total_correct };
  } catch {
    return empty;
  }
}

// --- Interactive activities (Educaplay-style ordering/matching practice)
// Mirrors mathora-web/src/lib/types.ts's Activity/ActivityData shapes and
// mathora-web/src/lib/supabase.ts's fetchActivities/createActivity/
// submitActivityAttempt — same tables (mathora_schema_activities_patch.sql),
// same RLS. Subject-agnostic (scoped by topic_id), fill_blank/classify
// aren't rendered yet on either platform.
export type ActivityType = 'ordering' | 'matching' | 'fill_blank' | 'classify';

export interface OrderingActivityData {
  activity_type: 'ordering';
  items: string[];
  correct_order: number[];
}

export interface MatchingActivityData {
  activity_type: 'matching';
  pairs: { left: string; right: string }[];
}

export interface FillBlankActivityData {
  activity_type: 'fill_blank';
  text: string;
  blanks: { token: string; answer: string }[];
}

export interface ClassifyActivityData {
  activity_type: 'classify';
  groups: string[];
  items: { text: string; group: string }[];
}

export type ActivityData = OrderingActivityData | MatchingActivityData | FillBlankActivityData | ClassifyActivityData;

export type ActivityStatus = 'draft' | 'published' | 'rejected';

export interface Activity {
  id: string;
  topic_id: string;
  activity_type: ActivityType;
  title: string;
  instructions?: string | null;
  activity_data: ActivityData;
  status: ActivityStatus;
  created_by?: string | null;
  created_at: string;
}

export async function fetchActivities(topicId?: string): Promise<Activity[]> {
  if (!supabase) return [];
  try {
    let query = supabase.from('activities').select('*').eq('status', 'published');
    if (topicId) query = query.eq('topic_id', topicId);
    const { data, error } = await query;
    if (error || !data) return [];
    return data as Activity[];
  } catch {
    return [];
  }
}

// activity_attempts.student_id is a students.id (profile PK), same
// resolve-from-auth-uid pattern as recordMobileAttempt above.
export async function submitActivityAttempt(input: {
  studentAuthUserId: string;
  activity_id: string;
  score: number; // 0-100
  time_taken_seconds: number;
}): Promise<boolean> {
  if (!supabase) return false;
  try {
    const { data: studentRow, error: studentError } = await supabase
      .from('students')
      .select('id')
      .eq('user_id', input.studentAuthUserId)
      .single();
    if (studentError || !studentRow) return false;

    const { error } = await supabase.from('activity_attempts').insert({
      student_id: studentRow.id,
      activity_id: input.activity_id,
      score: input.score,
      time_taken_seconds: input.time_taken_seconds,
    });
    return !error;
  } catch {
    return false;
  }
}

// ==========================================
// Teacher dashboard: this teacher's own classes with roster/mastery
// stats attached, and topics scoped to a class's syllabus level/term —
// mirrors mathora-web/src/lib/supabase.ts's fetchMyClassesWithStats/
// fetchClassTopics exactly (same tables, same RLS — classes_select_
// owner_or_enrolled already scopes the plain `classes` select to this
// teacher, no teacherId parameter needed).
// ==========================================

export interface TeacherClassSummary {
  id: string;
  name: string;
  code: string;
  class_level: ClassLevel;
  studentsCount: number;
  avgMastery: number;
}

export async function fetchMyClassesWithStats(): Promise<TeacherClassSummary[]> {
  if (!supabase) return [];
  try {
    const { data, error } = await supabase.from('classes').select('id, name, class_level, join_code').order('created_at');
    if (error || !data) return [];

    return await Promise.all(
      data.map(async (c) => {
        const summary = await fetchClassScoreSummary(c.id);
        return {
          id: c.id,
          name: c.name,
          code: c.join_code,
          class_level: c.class_level,
          studentsCount: summary.students.length,
          avgMastery: summary.class_average_mastery_percentage,
        };
      })
    );
  } catch {
    return [];
  }
}

export interface ClassLessonRow {
  topic_id: string;
  title: string;
  term: number | null;
  week: number | null;
  order_index: number;
}

export async function fetchClassTopics(classLevel: ClassLevel, term?: 1 | 2 | 3): Promise<ClassLessonRow[]> {
  if (!supabase) return [];
  try {
    let query = supabase
      .from('topics')
      .select('id, title, term, week, order_index')
      .eq('class_level', classLevel)
      .order('order_index');
    if (term) query = query.eq('term', term);
    const { data, error } = await query;
    if (error || !data) return [];
    return data.map((t) => ({
      topic_id: t.id,
      title: t.title,
      term: t.term ?? null,
      week: t.week ?? null,
      order_index: t.order_index ?? 1,
    }));
  } catch {
    return [];
  }
}

// ==========================================
// Assignments — teacher authoring + student timed take-flow. Mirrors
// mathora-web/src/lib/supabase.ts's assignments functions exactly: same
// tables/RLS/RPC (mathora_schema_assignments_patch.sql +
// mathora_schema_assignments_security_patch.sql) — grading integrity
// (is_correct recomputed server-side) and score integrity
// (complete_assignment_submission RPC, no client-writable score column)
// apply here automatically, no mobile-side trust decisions to make.
// ==========================================

export interface QuestionBankRow {
  id: string;
  topic_id: string;
  question_text: string;
  difficulty: number;
  exam_type: string;
  created_by_teacher_id: string | null;
}

export async function fetchQuestionBankForClass(classLevel: ClassLevel, topicId?: string): Promise<QuestionBankRow[]> {
  if (!supabase) return [];
  try {
    let query = supabase
      .from('questions')
      .select('id, topic_id, question_text, difficulty, exam_type, created_by_teacher_id, topics!inner(class_level)')
      .eq('topics.class_level', classLevel)
      .eq('status', 'published');
    if (topicId) query = query.eq('topic_id', topicId);
    const { data, error } = await query;
    if (error || !data) return [];
    return data.map((q) => ({
      id: q.id,
      topic_id: q.topic_id,
      question_text: q.question_text,
      difficulty: q.difficulty ?? 2,
      exam_type: q.exam_type ?? 'GENERAL',
      created_by_teacher_id: q.created_by_teacher_id ?? null,
    }));
  } catch {
    return [];
  }
}

async function resolveTeacherId(authUserId: string): Promise<string | null> {
  if (!supabase) return null;
  try {
    const { data, error } = await supabase.from('teachers').select('id').eq('user_id', authUserId).single();
    if (error || !data) return null;
    return data.id;
  } catch {
    return null;
  }
}

export async function createTeacherQuestion(input: {
  authUserId: string;
  topicId: string;
  questionText: string;
  optionA: string;
  optionB: string;
  optionC: string;
  optionD: string;
  correctLetter: 'A' | 'B' | 'C' | 'D';
  explanation: string;
  examShortcut?: string;
}): Promise<{ success: boolean; question?: QuestionBankRow; error?: string }> {
  if (!supabase) return { success: false, error: 'Not connected to Supabase.' };

  const teacherId = await resolveTeacherId(input.authUserId);
  if (!teacherId) return { success: false, error: 'Could not resolve your teacher profile.' };

  try {
    const { data, error } = await supabase
      .from('questions')
      .insert({
        topic_id: input.topicId,
        question_text: input.questionText,
        option_a: input.optionA,
        option_b: input.optionB,
        option_c: input.optionC,
        option_d: input.optionD,
        correct_letter: input.correctLetter,
        explanation: input.explanation,
        exam_shortcut: input.examShortcut || null,
        exam_type: 'GENERAL',
        status: 'published',
        created_by_teacher_id: teacherId,
      })
      .select('id, topic_id, question_text, difficulty, exam_type, created_by_teacher_id')
      .single();

    if (error || !data) return { success: false, error: error?.message ?? 'Failed to save question.' };

    return {
      success: true,
      question: {
        id: data.id,
        topic_id: data.topic_id,
        question_text: data.question_text,
        difficulty: data.difficulty ?? 2,
        exam_type: data.exam_type ?? 'GENERAL',
        created_by_teacher_id: data.created_by_teacher_id ?? null,
      },
    };
  } catch (e) {
    return { success: false, error: e instanceof Error ? e.message : 'Failed to save question.' };
  }
}

export async function createAssignmentWithQuestions(input: {
  classId: string;
  topicId: string;
  title: string;
  dueDate: string; // ISO
  durationMinutes: number | null;
  questionIds: string[];
}): Promise<{ success: boolean; assignmentId?: string; error?: string }> {
  if (!supabase) return { success: false, error: 'Not connected to Supabase.' };

  try {
    const { data: assignment, error: assignmentError } = await supabase
      .from('assignments')
      .insert({
        class_id: input.classId,
        topic_id: input.topicId,
        title: input.title,
        due_date: input.dueDate,
        duration_minutes: input.durationMinutes,
      })
      .select('id')
      .single();

    if (assignmentError || !assignment) {
      return { success: false, error: assignmentError?.message ?? 'Failed to create assignment.' };
    }

    if (input.questionIds.length > 0) {
      const rows = input.questionIds.map((question_id, i) => ({
        assignment_id: assignment.id,
        question_id,
        order_index: i + 1,
      }));
      const { error: questionsError } = await supabase.from('assignment_questions').insert(rows);
      if (questionsError) {
        return { success: false, assignmentId: assignment.id, error: questionsError.message };
      }
    }

    return { success: true, assignmentId: assignment.id };
  } catch (e) {
    return { success: false, error: e instanceof Error ? e.message : 'Failed to create assignment.' };
  }
}

export interface AssignmentSubmissionRow {
  student_id: string;
  full_name: string;
  started_at: string | null;
  completed: boolean;
  score: number | null;
  submitted_at: string | null;
  focus_loss_count: number;
}

export async function fetchAssignmentSubmissions(assignmentId: string, classId: string): Promise<AssignmentSubmissionRow[]> {
  if (!supabase) return [];
  try {
    const { data: members, error: membersError } = await supabase
      .from('class_students')
      .select('student_id, students!inner(id, user_id, users!inner(full_name))')
      .eq('class_id', classId);
    if (membersError || !members) return [];

    const rows = members as unknown as {
      student_id: string;
      students: { id: string; user_id: string; users: { full_name: string } };
    }[];

    const { data: submissions } = await supabase
      .from('assignment_submissions')
      .select('student_id, started_at, completed, score, submitted_at')
      .eq('assignment_id', assignmentId);

    const byStudent = new Map((submissions ?? []).map((s) => [s.student_id, s]));

    const { data: focusEvents } = await supabase
      .from('screenshot_events')
      .select('user_id')
      .eq('assignment_id', assignmentId)
      .eq('event_type', 'focus_loss');

    const focusCountByUserId = new Map<string, number>();
    for (const e of focusEvents ?? []) {
      focusCountByUserId.set(e.user_id, (focusCountByUserId.get(e.user_id) ?? 0) + 1);
    }

    return rows.map((r) => {
      const sub = byStudent.get(r.student_id);
      return {
        student_id: r.student_id,
        full_name: r.students.users.full_name,
        started_at: sub?.started_at ?? null,
        completed: sub?.completed ?? false,
        score: sub?.score ?? null,
        submitted_at: sub?.submitted_at ?? null,
        focus_loss_count: focusCountByUserId.get(r.students.user_id) ?? 0,
      };
    });
  } catch {
    return [];
  }
}

export interface StudentAssignmentRow {
  id: string;
  class_id: string;
  class_name: string;
  topic_title: string;
  title: string;
  due_date: string;
  duration_minutes: number | null;
  question_count: number;
  status: 'not_started' | 'in_progress' | 'completed' | 'missed';
}

export async function fetchMyAssignments(): Promise<StudentAssignmentRow[]> {
  if (!supabase) return [];
  try {
    const { data, error } = await supabase
      .from('assignments')
      .select(
        'id, class_id, title, due_date, duration_minutes, question_count, classes(name), topics(title), assignment_submissions(started_at, completed)'
      )
      .order('due_date');
    if (error || !data) return [];

    const now = Date.now();
    return (data as any[]).map((a) => {
      const sub = Array.isArray(a.assignment_submissions) ? a.assignment_submissions[0] : a.assignment_submissions;
      const dueMs = new Date(a.due_date).getTime();
      let status: StudentAssignmentRow['status'];
      if (sub?.completed) status = 'completed';
      else if (sub?.started_at) status = 'in_progress';
      else if (dueMs < now) status = 'missed';
      else status = 'not_started';

      return {
        id: a.id,
        class_id: a.class_id,
        class_name: a.classes?.name ?? '',
        topic_title: a.topics?.title ?? '',
        title: a.title,
        due_date: a.due_date,
        duration_minutes: a.duration_minutes ?? null,
        question_count: a.question_count ?? 0,
        status,
      };
    });
  } catch {
    return [];
  }
}

export interface MobileQuestion {
  id: string;
  topic_id: string;
  question_text: string;
  options: { letter: string; text: string; is_correct: boolean }[];
  explanation: string;
  difficulty: number;
  exam_type: string;
  exam_shortcut?: string;
}

function mapQuestionRow(q: {
  id: string;
  topic_id: string;
  question_text: string;
  option_a: string;
  option_b: string;
  option_c: string;
  option_d: string;
  option_e?: string | null;
  correct_letter: string;
  explanation: string;
  difficulty: number | null;
  exam_type: string | null;
  exam_shortcut?: string | null;
}): MobileQuestion {
  const correctLetter = q.correct_letter || 'A';
  const options = [
    { letter: 'A', text: q.option_a || 'Option A', is_correct: correctLetter === 'A' },
    { letter: 'B', text: q.option_b || 'Option B', is_correct: correctLetter === 'B' },
    { letter: 'C', text: q.option_c || 'Option C', is_correct: correctLetter === 'C' },
    { letter: 'D', text: q.option_d || 'Option D', is_correct: correctLetter === 'D' },
  ];
  if (q.option_e) options.push({ letter: 'E', text: q.option_e, is_correct: correctLetter === 'E' });
  return {
    id: q.id,
    topic_id: q.topic_id,
    question_text: q.question_text,
    options,
    explanation: q.explanation ?? '',
    difficulty: q.difficulty ?? 2,
    exam_type: q.exam_type ?? 'GENERAL',
    exam_shortcut: q.exam_shortcut ?? undefined,
  };
}

// General-purpose question fetcher for a topic — used by practice.tsx.
// Shares MobileQuestion/mapQuestionRow with fetchAssignmentForTaking
// above rather than a second parallel type+mapper.
export async function fetchMobileQuestions(topicId?: string): Promise<MobileQuestion[]> {
  if (!supabase) return [];
  try {
    let query = supabase.from('questions').select('*');
    if (topicId) query = query.eq('topic_id', topicId);
    const { data, error } = await query;
    if (error || !data) return [];
    return data.map(mapQuestionRow);
  } catch {
    return [];
  }
}

export async function fetchAssignmentForTaking(assignmentId: string): Promise<{
  assignment: { id: string; title: string; due_date: string; duration_minutes: number | null };
  questions: MobileQuestion[];
} | null> {
  if (!supabase) return null;
  try {
    const { data: assignment, error: assignmentError } = await supabase
      .from('assignments')
      .select('id, title, due_date, duration_minutes')
      .eq('id', assignmentId)
      .single();
    if (assignmentError || !assignment) return null;

    const { data: aq, error: aqError } = await supabase
      .from('assignment_questions')
      .select('order_index, questions(*)')
      .eq('assignment_id', assignmentId)
      .order('order_index');
    if (aqError || !aq) return { assignment, questions: [] };

    const questions = aq
      .map((row: any) => row.questions)
      .filter(Boolean)
      .map(mapQuestionRow);

    return { assignment, questions };
  } catch {
    return null;
  }
}

export async function startAssignmentAttempt(assignmentId: string, authUserId: string): Promise<{ started_at: string } | null> {
  if (!supabase) return null;
  try {
    const { data: studentRow, error: studentError } = await supabase
      .from('students')
      .select('id')
      .eq('user_id', authUserId)
      .single();
    if (studentError || !studentRow) return null;

    const startedAt = new Date().toISOString();
    const { data, error } = await supabase
      .from('assignment_submissions')
      .upsert(
        { assignment_id: assignmentId, student_id: studentRow.id, started_at: startedAt, completed: false },
        { onConflict: 'assignment_id,student_id', ignoreDuplicates: true }
      )
      .select('started_at')
      .maybeSingle();
    if (error) return null;
    if (data?.started_at) return { started_at: data.started_at };

    const { data: existing } = await supabase
      .from('assignment_submissions')
      .select('started_at')
      .eq('assignment_id', assignmentId)
      .eq('student_id', studentRow.id)
      .maybeSingle();
    return existing?.started_at ? { started_at: existing.started_at } : null;
  } catch {
    return null;
  }
}

type AssignmentAnswerInput = {
  student_id: string; // auth uid, resolved to students.id below
  assignment_id: string;
  question_id: string;
  selected_option: string;
  is_correct: boolean;
};

async function insertAssignmentAnswerRow(answer: AssignmentAnswerInput): Promise<boolean> {
  if (!supabase) return false;
  try {
    const { data: studentRow, error: studentError } = await supabase
      .from('students')
      .select('id')
      .eq('user_id', answer.student_id)
      .single();
    if (studentError || !studentRow) return false;

    const { error } = await supabase.from('assignment_answers').insert({
      assignment_id: answer.assignment_id,
      student_id: studentRow.id,
      question_id: answer.question_id,
      selected_option: answer.selected_option,
      is_correct: answer.is_correct,
    });
    return !error;
  } catch {
    return false;
  }
}

export async function submitAssignmentAnswer(answer: AssignmentAnswerInput): Promise<{ success: boolean; offlineQueued?: boolean }> {
  if (!supabase) {
    await enqueueAssignmentAnswer(answer);
    return { success: true, offlineQueued: true };
  }
  const ok = await insertAssignmentAnswerRow(answer);
  if (!ok) {
    await enqueueAssignmentAnswer(answer);
    return { success: true, offlineQueued: true };
  }
  return { success: true };
}

// Re-derives the score for any of the given assignments that are
// ALREADY marked completed — never for one still in progress. Safe to
// call repeatedly: complete_assignment_submission is idempotent.
async function recomputeCompletedAssignmentScores(assignmentIds: string[]): Promise<void> {
  if (!supabase || assignmentIds.length === 0) return;
  try {
    const { data } = await supabase
      .from('assignment_submissions')
      .select('assignment_id')
      .in('assignment_id', assignmentIds)
      .eq('completed', true);
    for (const row of data ?? []) {
      await completeAssignmentSubmission({ assignmentId: row.assignment_id });
    }
  } catch {
    // best-effort correction, not critical path
  }
}

export async function flushOfflineAssignmentAnswers(): Promise<{ synced: number; remaining: number }> {
  const queue: OfflineAssignmentAnswer[] = await getOfflineAssignmentAnswerQueue();
  if (!supabase || queue.length === 0) return { synced: 0, remaining: queue.length };

  const syncedIds: string[] = [];
  const syncedAssignmentIds = new Set<string>();
  for (const entry of queue) {
    const ok = await insertAssignmentAnswerRow(entry);
    if (ok) {
      syncedIds.push(entry.id);
      syncedAssignmentIds.add(entry.assignment_id);
    }
  }
  if (syncedIds.length > 0) await removeFromOfflineAssignmentAnswerQueue(syncedIds);
  if (syncedAssignmentIds.size > 0) await recomputeCompletedAssignmentScores(Array.from(syncedAssignmentIds));

  return { synced: syncedIds.length, remaining: queue.length - syncedIds.length };
}

export async function completeAssignmentSubmission(input: {
  assignmentId: string;
}): Promise<{ success: boolean; score?: number; correct?: number; total?: number }> {
  if (!supabase) return { success: false };
  try {
    const { data, error } = await supabase.rpc('complete_assignment_submission', {
      p_assignment_id: input.assignmentId,
    });
    if (error || !data) return { success: false };
    return { success: true, score: data.score, correct: data.correct, total: data.total };
  } catch {
    return { success: false };
  }
}

// Logs a focus-loss (app backgrounded) event during a timed
// assignment — a deterrent and teacher-visibility tool, same as web's
// logFocusLossEvent and mobile's own useBlockScreenCapture reporting.
// The DB trigger (notify_focus_loss, mathora_schema_assignments_patch.sql)
// handles notifying the owning teacher.
export async function logFocusLossEvent(assignmentId: string, screen: string = 'assignment_take'): Promise<void> {
  if (!supabase) return;
  try {
    const { data } = await supabase.auth.getSession();
    const userId = data.session?.user.id;
    if (!userId) return;
    await supabase.from('screenshot_events').insert({
      user_id: userId,
      screen,
      event_type: 'focus_loss',
      assignment_id: assignmentId,
    });
  } catch {
    // best-effort log, not critical path
  }
}
