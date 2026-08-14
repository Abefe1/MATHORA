export type Role = 'student' | 'teacher' | 'parent' | 'admin'

export interface UserProfile {
  id: string
  name: string
  email: string
  phone?: string
  role: Role
  avatar_url?: string
  created_at?: string
}

export interface Student {
  id: string
  user_id: string
  class: string
  parent_id?: string
  age?: number
}

export interface Teacher {
  id: string
  user_id: string
  subject: string
  experience_years: number
  hourly_rate: number
  bio?: string
  verified: boolean
  rating?: number
}

export interface Parent {
  id: string
  user_id: string
  phone: string
}

export interface Room {
  id: string
  teacher_id: string
  name: string
  created_at: string
}

export interface Session {
  id: string
  teacher_id: string
  room_id?: string
  title: string
  date: string
  duration_minutes: number
  live_link?: string
  type: 'live' | 'recorded'
  created_at: string
}

export interface Attendance {
  id: string
  student_id: string
  session_id: string
  present: boolean
  date: string
}

export interface Progress {
  id: string
  student_id: string
  lessons_done: number
  chapters_done: number
  assessments_done: number
  total_lessons: number
  total_chapters: number
  updated_at: string
}

export interface Assessment {
  id: string
  student_id: string
  topic: string
  score: number
  max_score: number
  date: string
}

export interface MCQQuestion {
  question: string
  options: string[]
  correct: number
}

export interface TeacherAssessment {
  id: string
  teacher_id: string
  title: string
  topic: string
  questions: MCQQuestion[]
  created_at: string
}

export interface AssessmentSubmission {
  id: string
  assessment_id: string
  student_id: string
  answers: number[]
  score?: number
  submitted_at: string
}

export interface Payment {
  id: string
  parent_id: string
  teacher_id: string
  amount: number
  status: 'paid' | 'pending' | 'debt'
  description?: string
  date: string
}

export interface Upload {
  id: string
  teacher_id: string
  name: string
  size: number
  type: string
  url: string
  topic: string
  uploaded_at: string
}
