import { createClient } from './supabase/client';
import { INITIAL_TOPICS } from './mockData';
import { Topic, Question, WorkedExample, School, SchoolStatus, ClassDirectoryEntry, ClassRosterEntry, ClassJoinRequest, ClassLevel, ExamType, Activity, ActivityData } from './types';
import {
  enqueueAttempt,
  getOfflineQueue,
  removeFromOfflineQueue,
  type OfflineAttempt,
  enqueueAssignmentAnswer,
  getOfflineAssignmentAnswerQueue,
  removeFromOfflineAssignmentAnswerQueue,
  type OfflineAssignmentAnswer,
} from './offlineSync';

// Every exported function below builds its own client via createClient()
// (from lib/supabase/client.ts, the @supabase/ssr browser client whose
// session lives in cookies) rather than sharing one built here with
// plain @supabase/supabase-js. That used to be a real bug: a client
// built directly with @supabase/supabase-js's createClient() persists
// its session to localStorage by default, a completely different
// storage than the cookies @supabase/ssr uses — so it never saw the
// session actually established at login, and every RLS-gated call
// below silently ran as an anonymous, signed-out user (reads fell
// back to mock/empty data; writes like submitQuestionAttempt or
// createTeacherClassInSupabase silently no-opped into their local
// fallback). createClient() from lib/supabase/client.ts is cheap to
// call repeatedly — @supabase/ssr caches one browser-side singleton
// internally — so each function below just calls it locally, the same
// way every other client component in this app already does.

// Fallback questions and worked examples extracted from INITIAL_TOPICS
const FALLBACK_QUESTIONS: Question[] = INITIAL_TOPICS.flatMap((t) => t.questions);
const FALLBACK_WORKED_EXAMPLES: WorkedExample[] = INITIAL_TOPICS.flatMap((t) => t.lessons.flatMap((l) => l.worked_examples));

// --- Student Topic Browsing ---
export async function fetchTopics(): Promise<Topic[]> {
  const supabase = createClient();
  if (!supabase) return INITIAL_TOPICS;
  try {
    const { data, error } = await supabase.from('topics').select('*');
    if (error || !data || data.length === 0) return INITIAL_TOPICS;
    return data as Topic[];
  } catch {
    return INITIAL_TOPICS;
  }
}

// Flattens a raw `questions` row (option_a..e, correct_letter) into the
// app's Question shape (options: QuestionOption[]). Shared by
// fetchQuestions below and fetchAssignmentForTaking, so the option_a..e
// -> QuestionOption[] mapping exists in exactly one place.
// eslint-disable-next-line @typescript-eslint/no-explicit-any
function mapQuestionRow(q: any): Question {
  const correctLetter = q.correct_letter || 'A';
  const options = [
    { letter: 'A', text: q.option_a || 'Option A', is_correct: correctLetter === 'A' },
    { letter: 'B', text: q.option_b || 'Option B', is_correct: correctLetter === 'B' },
    { letter: 'C', text: q.option_c || 'Option C', is_correct: correctLetter === 'C' },
    { letter: 'D', text: q.option_d || 'Option D', is_correct: correctLetter === 'D' },
  ];
  // A 5th option only exists for curated WAEC/NECO questions that came
  // with 5 choices (mathora_schema_five_option_patch.sql). Most rows
  // leave option_e null, so it's appended only when actually present.
  if (q.option_e) {
    options.push({ letter: 'E', text: q.option_e, is_correct: correctLetter === 'E' });
  }
  return {
    id: q.id,
    topic_id: q.topic_id,
    question_text: q.question_text,
    question_latex: q.question_latex || '',
    options,
    correct_letter: correctLetter,
    explanation: q.explanation || '',
    difficulty: q.difficulty || 2,
    exam_type: q.exam_type || 'WAEC',
    exam_shortcut: q.exam_shortcut || '',
  } as Question;
}

// --- Practice Question Fetcher ---
export async function fetchQuestions(topicId?: string): Promise<Question[]> {
  const supabase = createClient();
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

    return data.map(mapQuestionRow);
  } catch {
    return topicId ? FALLBACK_QUESTIONS.filter((q) => q.topic_id === topicId) : FALLBACK_QUESTIONS;
  }
}

// --- Worked Examples Fetcher ---
export async function fetchWorkedExamples(topicId?: string): Promise<WorkedExample[]> {
  const supabase = createClient();
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
type AttemptInput = {
  student_id: string; // auth.uid() of the signed-in student — resolved to students.id below
  question_id: string;
  topic_id: string;
  selected_option: 'A' | 'B' | 'C' | 'D' | 'E';
  is_correct: boolean;
  time_taken_seconds: number;
  rescue_mode_triggered: boolean;
};

// Shared by submitQuestionAttempt (live path) and flushOfflineQueue
// (retry path) so both resolve identity and insert the same way.
// Returns false (never throws) on any failure so callers can decide
// whether to queue/re-queue the attempt.
async function insertAttemptRow(attempt: AttemptInput): Promise<boolean> {
  const supabase = createClient();
  if (!supabase) return false;

  try {
    // attempts.student_id is a students.id (profile PK), not auth.uid() —
    // look up the caller's own profile row rather than trusting a
    // client-passed value for it.
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
      rescue_mode_triggered: attempt.rescue_mode_triggered,
    });

    return !error;
  } catch {
    return false;
  }
}

export async function submitQuestionAttempt(attempt: AttemptInput): Promise<{ success: boolean; offlineQueued?: boolean }> {
  const supabase = createClient();
  if (!supabase || (typeof navigator !== 'undefined' && !navigator.onLine)) {
    enqueueAttempt(attempt);
    return { success: true, offlineQueued: true };
  }

  const ok = await insertAttemptRow(attempt);
  if (!ok) {
    enqueueAttempt(attempt);
    return { success: true, offlineQueued: true };
  }

  return { success: true };
}

// Retries every locally-queued attempt (from a prior offline session or
// a failed insert) against Supabase. Call this on reconnect — see
// lib/useOfflineFlush.ts, which wires it to the browser's 'online'
// event and to sign-in. Entries that still fail (still offline, RLS
// rejection, etc.) are left in the queue for the next attempt.
export async function flushOfflineQueue(): Promise<{ synced: number; remaining: number }> {
  const supabase = createClient();
  const queue: OfflineAttempt[] = getOfflineQueue();
  if (!supabase || queue.length === 0) {
    return { synced: 0, remaining: queue.length };
  }

  const syncedIds: string[] = [];
  for (const entry of queue) {
    const ok = await insertAttemptRow(entry);
    if (ok) syncedIds.push(entry.id);
  }

  if (syncedIds.length > 0) removeFromOfflineQueue(syncedIds);

  return { synced: syncedIds.length, remaining: queue.length - syncedIds.length };
}

// --- Activities (Educaplay-style interactive practice) ---
// See mathora_schema_activities_patch.sql. A second practice mode
// alongside MCQ `questions`, scoped the same way (topic_id). Only
// 'published' rows are visible to students by default — RLS also lets
// a creator see their own draft, matching the questions/worked_examples
// review convention from mathora_schema_content_pipeline_patch.sql.
export async function fetchActivities(topicId?: string): Promise<Activity[]> {
  const supabase = createClient();
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

// Teacher/admin authoring. `createdByAuthUserId` is auth.uid() of the
// signed-in caller — RLS's activities_insert_teacher_or_admin policy
// requires created_by = auth.uid() and the caller's role to be
// teacher/content_admin/academic_admin/super_admin, so this can't
// silently no-op into someone else's name the way a bad client value
// could otherwise.
export async function createActivity(input: {
  topic_id: string;
  activity_type: Activity['activity_type'];
  title: string;
  instructions?: string;
  activity_data: ActivityData;
  createdByAuthUserId: string;
}): Promise<Activity | null> {
  const supabase = createClient();
  if (!supabase) return null;
  try {
    const { data, error } = await supabase
      .from('activities')
      .insert({
        topic_id: input.topic_id,
        activity_type: input.activity_type,
        title: input.title,
        instructions: input.instructions ?? null,
        activity_data: input.activity_data,
        created_by: input.createdByAuthUserId,
      })
      .select('*')
      .single();
    if (error || !data) return null;
    return data as Activity;
  } catch {
    return null;
  }
}

// activity_attempts.student_id is a students.id (profile PK), same
// resolve-from-auth-uid pattern as insertAttemptRow above.
export async function submitActivityAttempt(input: {
  studentAuthUserId: string;
  activity_id: string;
  score: number; // 0-100
  time_taken_seconds: number;
}): Promise<boolean> {
  const supabase = createClient();
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

// --- Teacher Class Management ---
// Class creation is a server-side RPC (mathora_schema_schools_patch.sql's
// create_class) rather than a raw insert: the join_code has to be
// generated with a collision-retry loop, which only the DB can check
// safely, and the class's school_id is auto-stamped from the caller's
// own teachers.school_id there too — a client-supplied school_id could
// otherwise attribute a class to a school the teacher never joined.
// `authUserId` (auth.uid()) resolves identity server-side inside the
// RPC via current_teacher_id(); no client-supplied teacher/school id
// is ever trusted here. There is no hardcoded fallback id on purpose:
// without a real signed-in teacher this returns a local-only
// optimistic class rather than silently attributing one to a
// placeholder account.
export async function createTeacherClassInSupabase(
  name: string,
  classLevel: ClassLevel,
  authUserId?: string
): Promise<{ id: string; name: string; code: string; studentsCount: number; avgMastery: number }> {
  const optimisticFallback = {
    id: `c-${Date.now()}`,
    name,
    code: `MATH-${Math.floor(1000 + Math.random() * 9000)}`,
    studentsCount: 0,
    avgMastery: 0,
  };

  const supabase = createClient();
  if (!supabase || !authUserId) return optimisticFallback;

  try {
    const { data, error } = await supabase.rpc('create_class', {
      p_name: name,
      p_class_level: classLevel,
    });

    if (error || !data) return optimisticFallback;

    return {
      id: data.id,
      name: data.name,
      code: data.join_code,
      studentsCount: 0,
      avgMastery: 0,
    };
  } catch {
    return optimisticFallback;
  }
}

// --- Schools: search, create/suggest, join ---

export async function searchSchools(query: string, state?: string): Promise<School[]> {
  const supabase = createClient();
  if (!supabase) return [];
  try {
    let q = supabase.from('schools').select('*').ilike('name', `%${query}%`);
    if (state) q = q.eq('state', state);
    const { data, error } = await q.limit(20);
    if (error || !data) return [];
    return data as School[];
  } catch {
    return [];
  }
}

// Returns the created/suggested school row, or throws with the RPC's
// error message (e.g. duplicate name+state) so the caller can show it
// directly — unlike the class-creation helper above, silently falling
// back here would hide "this school already exists" from the teacher.
export async function createOrSuggestSchool(name: string, state: string, address?: string): Promise<School> {
  const supabase = createClient();
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
  const supabase = createClient();
  if (!supabase) return false;
  const { error } = await supabase.rpc('join_school', { p_school_id: schoolId });
  return !error;
}

export async function fetchMyTeacherSchoolId(authUserId: string): Promise<string | null> {
  const supabase = createClient();
  if (!supabase) return null;
  try {
    const { data, error } = await supabase
      .from('teachers')
      .select('school_id')
      .eq('user_id', authUserId)
      .single();
    if (error || !data) return null;
    return data.school_id ?? null;
  } catch {
    return null;
  }
}

// --- Browse teachers at a school (student search-and-join flow) ---
// Two sequential queries rather than a nested PostgREST embed, matching
// this file's existing style (see insertAttemptRow's students-then-
// attempts lookup) — teachers has no full_name column, that's on
// public.users, made readable here by the users_select_teacher_directory
// policy (mathora_schema_schools_patch.sql).
export type TeacherDirectoryEntry = { id: string; full_name: string; verified: boolean };

export async function fetchTeachersAtSchool(schoolId: string): Promise<TeacherDirectoryEntry[]> {
  const supabase = createClient();
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

// --- Schools: admin moderation ---

export async function fetchSchoolsForAdmin(status?: SchoolStatus): Promise<School[]> {
  const supabase = createClient();
  if (!supabase) return [];
  try {
    let q = supabase.from('schools').select('*').order('created_at', { ascending: false });
    if (status) q = q.eq('status', status);
    const { data, error } = await q;
    if (error || !data) return [];
    return data as School[];
  } catch {
    return [];
  }
}

export async function updateSchoolStatus(schoolId: string, status: SchoolStatus): Promise<boolean> {
  const supabase = createClient();
  if (!supabase) return false;
  const { error } = await supabase.from('schools').update({ status, updated_at: new Date().toISOString() }).eq('id', schoolId);
  return !error;
}

export async function toggleSchoolVerified(schoolId: string, verified: boolean): Promise<boolean> {
  const supabase = createClient();
  if (!supabase) return false;
  const { error } = await supabase.from('schools').update({ verified, updated_at: new Date().toISOString() }).eq('id', schoolId);
  return !error;
}

export async function deleteSchool(schoolId: string): Promise<boolean> {
  const supabase = createClient();
  if (!supabase) return false;
  const { error } = await supabase.from('schools').delete().eq('id', schoolId);
  return !error;
}

export async function fetchPlatformSelfServeEnabled(): Promise<boolean> {
  const supabase = createClient();
  if (!supabase) return true;
  try {
    const { data, error } = await supabase.from('platform_settings').select('self_serve_school_creation_enabled').eq('id', 1).single();
    if (error || !data) return true;
    return data.self_serve_school_creation_enabled;
  } catch {
    return true;
  }
}

export async function updatePlatformSelfServeEnabled(enabled: boolean): Promise<boolean> {
  const supabase = createClient();
  if (!supabase) return false;
  const { error } = await supabase
    .from('platform_settings')
    .update({ self_serve_school_creation_enabled: enabled, updated_at: new Date().toISOString() })
    .eq('id', 1);
  return !error;
}

// --- Class directory (browse-before-joining) ---
// Reads from the class_directory VIEW, not the classes table directly —
// that view deliberately omits join_code so a browsing, not-yet-member
// student can never see it (see mathora_schema_schools_patch.sql).

export async function fetchClassDirectory(teacherId: string): Promise<ClassDirectoryEntry[]> {
  const supabase = createClient();
  if (!supabase) return [];
  try {
    const { data, error } = await supabase.from('class_directory').select('*').eq('teacher_id', teacherId);
    if (error || !data) return [];
    return data as ClassDirectoryEntry[];
  } catch {
    return [];
  }
}

// --- Class roster (teacher-managed) ---

export async function bulkAddRosterEntries(
  classId: string,
  entries: { full_name: string; verification_value?: string }[]
): Promise<ClassRosterEntry[]> {
  const supabase = createClient();
  if (!supabase) return [];
  const { data, error } = await supabase.rpc('bulk_add_roster_entries', {
    p_class_id: classId,
    p_entries: entries,
  });
  if (error || !data) return [];
  return data as ClassRosterEntry[];
}

export async function fetchClassRoster(classId: string): Promise<ClassRosterEntry[]> {
  const supabase = createClient();
  if (!supabase) return [];
  try {
    const { data, error } = await supabase.from('class_roster_entries').select('*').eq('class_id', classId).order('created_at');
    if (error || !data) return [];
    return data as ClassRosterEntry[];
  } catch {
    return [];
  }
}

// --- Class join requests (search-and-join approval queue) ---

export async function fetchPendingJoinRequests(classId: string): Promise<ClassJoinRequest[]> {
  const supabase = createClient();
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
  const supabase = createClient();
  if (!supabase) return false;
  const { error } = await supabase.rpc('decide_join_request', {
    p_request_id: requestId,
    p_approve: approve,
  });
  return !error;
}

// --- Student search & join ---

export async function findOrRequestClassJoin(
  classId: string,
  verificationValue?: string
): Promise<{ status: 'joined' | 'already_member' | 'pending' } | null> {
  const supabase = createClient();
  if (!supabase) return null;
  const { data, error } = await supabase.rpc('find_or_request_class_join', {
    p_class_id: classId,
    p_verification_value: verificationValue ?? null,
  });
  if (error || !data) return null;
  return data as { status: 'joined' | 'already_member' | 'pending' };
}

// --- Analysis page stats ---
//
// No new SQL — attempts_select_own_or_related / topic_mastery_select_own_or_related
// (mathora_schema_auth_patch.sql) already cover both "my own data" (student
// viewing themself) and "my child's data" (parent viewing a student they're
// linked to), so the same query shape works for both callers; the RLS
// policy is what actually restricts which rows come back.
export interface AnalysisStats {
  totalAttempted: number;
  totalCorrect: number;
  currentStreakDays: number;
  weeklyPracticedDays: number; // out of 7, this calendar week (Mon-Sun)
  /** Which of the 7 days (index 0=Mon..6=Sun) had at least one attempt —
   * a UI showing "which days" needs this, not just the count, or it'd
   * have to guess/fabricate which specific days were practiced. */
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

// studentProfileId is students.id (the profile PK), not auth.uid() —
// callers that only have the signed-in user's auth id should resolve it
// first the same way insertAttemptRow does.
export async function fetchAnalysisStats(studentProfileId: string): Promise<AnalysisStats> {
  const supabase = createClient();
  if (!supabase) return EMPTY_ANALYSIS_STATS;
  try {
    // 500 most recent attempts is plenty for a streak/weekly-days
    // calculation without pulling a student's entire history.
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
    const dayOfWeek = (now.getDay() + 6) % 7; // 0=Mon..6=Sun
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

export async function fetchMyStudentProfileId(authUserId: string): Promise<string | null> {
  const supabase = createClient();
  if (!supabase) return null;
  try {
    const { data, error } = await supabase.from('students').select('id').eq('user_id', authUserId).single();
    if (error || !data) return null;
    return data.id;
  } catch {
    return null;
  }
}

// --- Score dashboard: per-topic ("per exercise"), per-term cumulative, and
// per-class cumulative. Built entirely on top of the existing attempts /
// topic_mastery tables and the topics.term column, no new tables needed.

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

// Per-exercise (per-topic) breakdown, in syllabus order, for one student.
export async function fetchTopicScores(studentProfileId: string): Promise<TopicScore[]> {
  const supabase = createClient();
  if (!supabase) return [];
  try {
    const { data, error } = await supabase
      .from('topic_mastery')
      .select('topic_id, total_attempted, total_correct, mastery_percentage, topics!inner(title, class_level, term, order_index)')
      .eq('student_id', studentProfileId);
    if (error || !data) return [];
    return (data as unknown as Array<{
      topic_id: string; total_attempted: number; total_correct: number; mastery_percentage: number;
      topics: { title: string; class_level: string; term: number | null; order_index: number };
    }>)
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

export interface TermSummary {
  term: number;
  topics_started: number;
  total_attempted: number;
  total_correct: number;
  average_mastery_percentage: number;
}

// Cumulative score per term (1/2/3), derived by grouping fetchTopicScores
// client-side rather than a separate round trip — the per-topic list is
// small (one row per topic a student has touched) so this stays cheap.
export async function fetchTermSummaries(studentProfileId: string): Promise<TermSummary[]> {
  const scores = await fetchTopicScores(studentProfileId);
  const byTerm = new Map<number, TopicScore[]>();
  for (const s of scores) {
    if (s.term == null) continue;
    if (!byTerm.has(s.term)) byTerm.set(s.term, []);
    byTerm.get(s.term)!.push(s);
  }
  return Array.from(byTerm.entries())
    .map(([term, rows]) => {
      const total_attempted = rows.reduce((sum, r) => sum + r.total_attempted, 0);
      const total_correct = rows.reduce((sum, r) => sum + r.total_correct, 0);
      const average_mastery_percentage = rows.length
        ? Math.round(rows.reduce((sum, r) => sum + r.mastery_percentage, 0) / rows.length)
        : 0;
      return { term, topics_started: rows.length, total_attempted, total_correct, average_mastery_percentage };
    })
    .sort((a, b) => a.term - b.term);
}

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

// Cumulative score per class, for a teacher's dashboard: every student in
// the class, their own cumulative attempted/correct/mastery, plus a class
// average. class_students is the authoritative membership table (not the
// roster-entries view, which tracks pre-claim names rather than joined
// student_id rows).
//
// Pass `term` (1/2/3) to scope the mastery numbers to topics tagged with
// that term only (via topics!inner, same embedded-filter pattern as
// fetchTopicScores above) — omit it for the cumulative, all-terms view
// existing callers already rely on.
export async function fetchClassScoreSummary(classId: string, term?: 1 | 2 | 3): Promise<ClassScoreSummary> {
  const empty: ClassScoreSummary = { students: [], class_average_mastery_percentage: 0, class_total_attempted: 0, class_total_correct: 0 };
  const supabase = createClient();
  if (!supabase) return empty;
  try {
    const { data: members, error: membersError } = await supabase
      .from('class_students')
      .select('student_id, students!inner(id, users!inner(full_name))')
      .eq('class_id', classId);
    if (membersError || !members || members.length === 0) return empty;

    const rows = members as unknown as Array<{ student_id: string; students: { id: string; users: { full_name: string } } }>;
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

export interface ClassLessonRow {
  topic_id: string;
  title: string;
  term: number | null;
  week: number | null;
  order_index: number;
}

// Lessons (topics) for a class's syllabus level, optionally scoped to one
// term — used by the teacher dashboard's "Lessons this term" panel.
// Takes class_level directly (already on TeacherClassSummary) rather than
// a classId, avoiding an extra round trip to look the class up.
export async function fetchClassTopics(classLevel: ClassLevel, term?: 1 | 2 | 3): Promise<ClassLessonRow[]> {
  const supabase = createClient();
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
    return data.map((t) => ({ topic_id: t.id, title: t.title, term: t.term ?? null, week: t.week ?? null, order_index: t.order_index ?? 1 }));
  } catch {
    return [];
  }
}

// --- Teacher dashboard: this teacher's own classes, with roster/mastery
// stats attached. No teacherId parameter needed — classes_select_owner_or_
// enrolled (mathora_schema_auth_patch.sql) already scopes the plain
// `classes` select to `teacher_id = current_teacher_id()`, so whatever
// comes back is already just this teacher's own classes.
export interface TeacherClassSummary {
  id: string;
  name: string;
  code: string;
  class_level: ClassLevel;
  studentsCount: number;
  avgMastery: number;
}

export async function fetchMyClassesWithStats(): Promise<TeacherClassSummary[]> {
  const supabase = createClient();
  if (!supabase) return [];
  try {
    const { data, error } = await supabase
      .from('classes')
      .select('id, name, class_level, join_code')
      .order('created_at');
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

// ============================================================
// Assignments — teacher authoring + student timed take-flow
// ============================================================

// --- Teacher: question bank + assignment builder ---

export interface QuestionBankRow {
  id: string;
  topic_id: string;
  question_text: string;
  difficulty: number;
  exam_type: ExamType;
  created_by_teacher_id: string | null;
}

// Question bank for the assignment builder: every published question
// tagged to topics under this class's class_level, optionally narrowed
// to one topic_id. Deliberately does NOT reuse fetchQuestions() — that
// function's job is "render one question fully" (options mapped into
// QuestionOption[], mock fallback); this one's job is "list rows to
// multi-select from" (lighter columns, no option mapping, no mock
// fallback since an empty bank is a legitimate real state here, not a
// connectivity failure to paper over).
export async function fetchQuestionBankForClass(classLevel: ClassLevel, topicId?: string): Promise<QuestionBankRow[]> {
  const supabase = createClient();
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
      exam_type: (q.exam_type ?? 'GENERAL') as ExamType,
      created_by_teacher_id: q.created_by_teacher_id ?? null,
    }));
  } catch {
    return [];
  }
}

// Resolves the caller's own teachers.id from their auth uid — same
// pattern as insertAttemptRow resolving students.id. questions_insert_
// by_teacher's RLS re-verifies created_by_teacher_id server-side
// regardless, this just supplies a valid value to write.
async function resolveTeacherId(authUserId: string): Promise<string | null> {
  const supabase = createClient();
  if (!supabase) return null;
  try {
    const { data, error } = await supabase.from('teachers').select('id').eq('user_id', authUserId).single();
    if (error || !data) return null;
    return data.id;
  } catch {
    return null;
  }
}

// Mirrors admin/page.tsx's handleAddQuestion insert, but sets
// created_by_teacher_id + status:'published' directly (scope decision:
// teacher-authored questions are immediately usable, no review gate).
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
  const supabase = createClient();
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
        exam_type: (data.exam_type ?? 'GENERAL') as ExamType,
        created_by_teacher_id: data.created_by_teacher_id ?? null,
      },
    };
  } catch (e) {
    return { success: false, error: e instanceof Error ? e.message : 'Failed to save question.' };
  }
}

// Creates the assignment row, then batch-inserts assignment_questions
// (order = selection order). No client-side multi-statement transaction
// is available — if the second insert fails, the assignment row stays
// and the teacher can add questions from the detail page afterward;
// that's a documented limitation, not silently papered over.
export async function createAssignmentWithQuestions(input: {
  classId: string;
  topicId: string;
  title: string;
  dueDate: string; // ISO
  durationMinutes: number | null;
  questionIds: string[];
}): Promise<{ success: boolean; assignmentId?: string; error?: string }> {
  const supabase = createClient();
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

// Teacher-side submission/integrity view for one assignment: roster
// left-joined to assignment_submissions (so students who never started
// still show up as "not started"), plus a focus-loss count per student
// from screenshot_events. classId is passed alongside assignmentId
// (rather than looked up from it) since the caller already has it from
// the [classId]/assignments/[assignmentId] route.
export async function fetchAssignmentSubmissions(assignmentId: string, classId: string): Promise<AssignmentSubmissionRow[]> {
  const supabase = createClient();
  if (!supabase) return [];
  try {
    const { data: members, error: membersError } = await supabase
      .from('class_students')
      .select('student_id, students!inner(id, user_id, users!inner(full_name))')
      .eq('class_id', classId);
    if (membersError || !members) return [];

    const rows = members as unknown as Array<{
      student_id: string;
      students: { id: string; user_id: string; users: { full_name: string } };
    }>;

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

// --- Student: assignment list + timed take-flow ---

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

// assignments is already RLS-scoped to the caller's own enrolled
// classes; the embedded assignment_submissions select is likewise
// scoped to the caller's own row by assignment_submissions' own RLS, so
// no explicit student_id filter is needed on either side of this join.
export async function fetchMyAssignments(): Promise<StudentAssignmentRow[]> {
  const supabase = createClient();
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
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
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

export async function fetchAssignmentForTaking(assignmentId: string): Promise<{
  assignment: { id: string; title: string; due_date: string; duration_minutes: number | null };
  questions: Question[];
} | null> {
  const supabase = createClient();
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
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      .map((row: any) => row.questions)
      .filter(Boolean)
      .map(mapQuestionRow);

    return { assignment, questions };
  } catch {
    return null;
  }
}

// Upserts the submission row with started_at set exactly once — a
// reopen never overwrites it, since the take-flow's countdown depends
// on it staying stable across reloads. ignoreDuplicates means a
// conflicting row is left untouched rather than updated; when that
// happens this re-reads to return the ORIGINAL started_at.
export async function startAssignmentAttempt(assignmentId: string, authUserId: string): Promise<{ started_at: string } | null> {
  const supabase = createClient();
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
  student_id: string; // auth.uid() of the signed-in student — resolved to students.id below
  assignment_id: string;
  question_id: string;
  selected_option: 'A' | 'B' | 'C' | 'D' | 'E';
  is_correct: boolean;
};

// Shared by submitAssignmentAnswer (live path) and
// flushOfflineAssignmentAnswers (retry path), mirroring
// insertAttemptRow/submitQuestionAttempt exactly — server-side identity
// resolution, never throws.
async function insertAssignmentAnswerRow(answer: AssignmentAnswerInput): Promise<boolean> {
  const supabase = createClient();
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
  const supabase = createClient();
  if (!supabase || (typeof navigator !== 'undefined' && !navigator.onLine)) {
    enqueueAssignmentAnswer(answer);
    return { success: true, offlineQueued: true };
  }

  const ok = await insertAssignmentAnswerRow(answer);
  if (!ok) {
    enqueueAssignmentAnswer(answer);
    return { success: true, offlineQueued: true };
  }

  return { success: true };
}

// Retries every locally-queued assignment answer — call this on
// reconnect, same as flushOfflineQueue (see lib/useOfflineFlush.ts).
//
// Edge case this also closes: if a student's LAST answer on a timed
// assignment gets queued offline right as they finish, the take-flow
// still calls complete_assignment_submission immediately afterward —
// so the score gets computed one answer short, before this queued
// entry ever reaches the DB. Once it does sync here, re-run completion
// for any assignment that's already marked completed among the
// synced entries, so the score gets corrected rather than staying
// permanently one answer short.
export async function flushOfflineAssignmentAnswers(): Promise<{ synced: number; remaining: number }> {
  const supabase = createClient();
  const queue: OfflineAssignmentAnswer[] = getOfflineAssignmentAnswerQueue();
  if (!supabase || queue.length === 0) {
    return { synced: 0, remaining: queue.length };
  }

  const syncedIds: string[] = [];
  const syncedAssignmentIds = new Set<string>();
  for (const entry of queue) {
    const ok = await insertAssignmentAnswerRow(entry);
    if (ok) {
      syncedIds.push(entry.id);
      syncedAssignmentIds.add(entry.assignment_id);
    }
  }

  if (syncedIds.length > 0) removeFromOfflineAssignmentAnswerQueue(syncedIds);
  if (syncedAssignmentIds.size > 0) await recomputeCompletedAssignmentScores(Array.from(syncedAssignmentIds));

  return { synced: syncedIds.length, remaining: queue.length - syncedIds.length };
}

// Re-derives the score for any of the given assignments that are
// ALREADY marked completed — never for one still in progress, since
// that would end it prematurely for a student mid-attempt whose
// earlier answer just happened to sync late. Safe to call repeatedly:
// complete_assignment_submission is idempotent, always recomputing
// from whatever assignment_answers rows actually exist.
async function recomputeCompletedAssignmentScores(assignmentIds: string[]): Promise<void> {
  const supabase = createClient();
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

// Score is deliberately NOT a parameter here — mathora_schema_assignments_
// security_patch.sql revoked direct client UPDATE on assignment_submissions
// and moved completion to the complete_assignment_submission RPC, which
// derives the score itself from assignment_answers (each row's is_correct
// is in turn recomputed server-side by a BEFORE INSERT trigger, never
// trusted from the client). A client-supplied score could never be
// honest even if this function still accepted one — the DB would ignore
// it. Returns the RPC's own authoritative score so the UI can display
// what was actually recorded, not what it locally computed.
export async function completeAssignmentSubmission(input: {
  assignmentId: string;
}): Promise<{ success: boolean; score?: number; correct?: number; total?: number }> {
  const supabase = createClient();
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

// Logs a focus-loss (tab hidden/blurred) event during a timed
// assignment — a deterrent and teacher-visibility tool, same spirit as
// mobile's screenSecurity.ts reportScreenshotAttempt: silently no-ops
// if there's no session, since an anonymous report isn't actionable.
// The DB trigger (notify_focus_loss, mathora_schema_assignments_patch.sql)
// handles notifying the owning teacher — this never calls
// queue_notification directly.
export async function logFocusLossEvent(assignmentId: string, screen: string = 'assignment_take'): Promise<void> {
  const supabase = createClient();
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
