import type { DiagramType, DiagramData } from './diagramTypes';
export type { DiagramType, DiagramData } from './diagramTypes';

export type UserRole =
  | 'student'
  | 'teacher'
  | 'parent'
  | 'content_admin'
  | 'academic_admin'
  | 'support_admin'
  | 'finance_admin'
  | 'super_admin';

// PRI1-PRI6 (primary/"basic" levels) are schema-ready ahead of any
// actual primary-level content — see
// mathora_schema_subjects_and_primary_levels_patch.sql. The platform
// only serves JSS1-SS3 today.
export type ClassLevel =
  | 'PRI1' | 'PRI2' | 'PRI3' | 'PRI4' | 'PRI5' | 'PRI6'
  | 'JSS1' | 'JSS2' | 'JSS3'
  | 'SS1' | 'SS2' | 'SS3';
export type ExamType = 'WAEC' | 'BECE' | 'JAMB' | 'NECO' | 'GENERAL';

// Mirrors public.class_level_stage() in
// mathora_schema_subjects_and_primary_levels_patch.sql — keep in sync.
export type ClassStage = 'primary' | 'jss' | 'sss';

export const CLASS_LEVEL_ORDER: readonly ClassLevel[] = [
  'PRI1', 'PRI2', 'PRI3', 'PRI4', 'PRI5', 'PRI6',
  'JSS1', 'JSS2', 'JSS3',
  'SS1', 'SS2', 'SS3',
];

export function classLevelStage(level: ClassLevel): ClassStage {
  if (level.startsWith('PRI')) return 'primary';
  if (level.startsWith('JSS')) return 'jss';
  return 'sss';
}

// A subject the platform teaches (public.subjects). MATHORA serves
// only 'Mathematics' today; this exists so content, UI, and queries
// can start being subject-scoped without a later rework.
export interface Subject {
  id: string;
  name: string;
  code: string;
  icon: string;
  color?: string | null;
}

export interface UserProfile {
  id: string;
  email: string;
  full_name: string;
  role: UserRole;
  phone?: string;
  avatar_url?: string;
  created_at: string;
}

export interface StudentProfile {
  id: string;
  user_id: string;
  current_level: ClassLevel;
  parent_id?: string;
}

export interface TeacherProfile {
  id: string;
  user_id: string;
  school_name?: string;
  state: string;
  verified: boolean;
}

export interface WorkedExample {
  title: string;
  problem_statement: string;
  solution_steps: string[];
  exam_shortcut?: string;
  common_trap_warning?: string;
  // A grounded real-world framing of the same problem (e.g. splitting
  // a market stall's daily sales for a Sets/Venn Diagram lesson) —
  // populated "whenever the topic realistically supports one", not
  // forced onto every example. null/undefined means none was generated.
  real_life_context?: string | null;
  diagram_type?: DiagramType;
  diagram_data?: DiagramData;
}

export interface Lesson {
  id: string;
  topic_id: string;
  title: string;
  summary: string;
  content_body: string;
  video_url?: string;
  audio_url?: string;
  order_index: number;
  worked_examples: WorkedExample[];
}

export interface QuestionOption {
  // 'E' is optional at the DB level (mathora_schema_five_option_patch.sql).
  // most questions are still 4-option; a 5th only appears for curated
  // WAEC/NECO past questions that genuinely came with 5 choices.
  letter: 'A' | 'B' | 'C' | 'D' | 'E';
  text: string;
  is_correct: boolean;
}

export interface Question {
  id: string;
  topic_id: string;
  question_text: string;
  difficulty: number; // 1-5
  exam_type: ExamType;
  explanation: string;
  exam_shortcut?: string;
  options: QuestionOption[];
  diagram_type?: DiagramType;
  diagram_data?: DiagramData;
}

export interface Topic {
  id: string;
  title: string;
  class_level: ClassLevel;
  term: number | null;
  week: number | null;
  description: string;
  order_index: number;
  icon: string;
  lessons: Lesson[];
  questions: Question[];
}

export interface TopicMastery {
  topic_id: string;
  mastery_percentage: number;
  total_attempted: number;
  total_correct: number;
}

export interface Attempt {
  id: string;
  question_id: string;
  selected_letter: string;
  is_correct: boolean;
  attempted_at: string;
}

export interface Assignment {
  id: string;
  class_id: string;
  topic_id: string;
  title: string;
  question_count: number;
  due_date: string;
  completed?: boolean;
  score?: number;
}

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

export type ClassJoinRequestStatus = 'pending' | 'approved' | 'rejected';

export interface ClassJoinRequest {
  id: string;
  class_id: string;
  student_id: string;
  verification_value?: string | null;
  status: ClassJoinRequestStatus;
  decided_at?: string | null;
  created_at: string;
}

// --- Interactive activities (mathora_schema_activities_patch.sql) ---
// A second, non-MCQ practice mode scoped to a topic — step ordering,
// matching pairs, fill-blank, classification. Subject-agnostic by
// design: everything hangs off topic_id (see [[activities patch]] for
// why). Each activity_type's activity_data shape is a distinct
// interface below; ActivityData is the discriminated union the
// player/builder components switch on.
export type ActivityType = 'ordering' | 'matching' | 'fill_blank' | 'classify';

export interface OrderingActivityData {
  activity_type: 'ordering';
  items: string[]; // shuffled for display; this array's own order is not the answer
  correct_order: number[]; // indices into `items`, in correct sequence
}

export interface MatchingActivityData {
  activity_type: 'matching';
  pairs: { left: string; right: string }[];
}

export interface FillBlankActivityData {
  activity_type: 'fill_blank';
  text: string; // contains one or more `{{token}}` placeholders
  blanks: { token: string; answer: string }[];
}

export interface ClassifyActivityData {
  activity_type: 'classify';
  groups: string[];
  items: { text: string; group: string }[]; // `group` must be one of `groups`
}

export type ActivityData =
  | OrderingActivityData
  | MatchingActivityData
  | FillBlankActivityData
  | ClassifyActivityData;

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

export interface ActivityAttempt {
  id: string;
  student_id: string;
  activity_id: string;
  score: number; // 0-100
  time_taken_seconds: number;
  attempted_at: string;
}
