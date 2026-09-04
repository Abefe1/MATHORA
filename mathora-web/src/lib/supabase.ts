import { createClient } from '@supabase/supabase-js';
import { INITIAL_TOPICS } from './mockData';
import { Topic, Question, WorkedExample, School, SchoolStatus, ClassDirectoryEntry, ClassRosterEntry, ClassJoinRequest, ClassLevel } from './types';
import { enqueueAttempt, getOfflineQueue, removeFromOfflineQueue, type OfflineAttempt } from './offlineSync';

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
  if (!supabase) return false;
  const { error } = await supabase.from('schools').update({ status, updated_at: new Date().toISOString() }).eq('id', schoolId);
  return !error;
}

export async function toggleSchoolVerified(schoolId: string, verified: boolean): Promise<boolean> {
  if (!supabase) return false;
  const { error } = await supabase.from('schools').update({ verified, updated_at: new Date().toISOString() }).eq('id', schoolId);
  return !error;
}

export async function deleteSchool(schoolId: string): Promise<boolean> {
  if (!supabase) return false;
  const { error } = await supabase.from('schools').delete().eq('id', schoolId);
  return !error;
}

export async function fetchPlatformSelfServeEnabled(): Promise<boolean> {
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
  if (!supabase) return [];
  const { data, error } = await supabase.rpc('bulk_add_roster_entries', {
    p_class_id: classId,
    p_entries: entries,
  });
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

// --- Class join requests (search-and-join approval queue) ---

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
export async function fetchClassScoreSummary(classId: string): Promise<ClassScoreSummary> {
  const empty: ClassScoreSummary = { students: [], class_average_mastery_percentage: 0, class_total_attempted: 0, class_total_correct: 0 };
  if (!supabase) return empty;
  try {
    const { data: members, error: membersError } = await supabase
      .from('class_students')
      .select('student_id, students!inner(id, users!inner(full_name))')
      .eq('class_id', classId);
    if (membersError || !members || members.length === 0) return empty;

    const rows = members as unknown as Array<{ student_id: string; students: { id: string; users: { full_name: string } } }>;
    const studentIds = rows.map((r) => r.student_id);

    const { data: masteryRows } = await supabase
      .from('topic_mastery')
      .select('student_id, total_attempted, total_correct, mastery_percentage')
      .in('student_id', studentIds);

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
