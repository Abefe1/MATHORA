export type UserRole =
  | 'student'
  | 'teacher'
  | 'parent'
  | 'content_admin'
  | 'academic_admin'
  | 'support_admin'
  | 'finance_admin'
  | 'super_admin';

export type ClassLevel = 'JSS1' | 'JSS2' | 'JSS3' | 'SS1' | 'SS2' | 'SS3';
export type ExamType = 'WAEC' | 'BECE' | 'JAMB' | 'NECO' | 'GENERAL';

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
  letter: 'A' | 'B' | 'C' | 'D';
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
}

export interface Topic {
  id: string;
  title: string;
  class_level: ClassLevel;
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
