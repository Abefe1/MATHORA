export type Role = 'student' | 'teacher' | 'parent' | 'admin'

export interface Profile {
  id: string
  name: string
  email: string
  phone?: string
  role: Role
  avatar_url?: string
}

export interface Student {
  id: string
  user_id: string
  class: string
  parent_id?: string
}

export interface Teacher {
  id: string
  user_id: string
  name: string
  subject: string
  experience_years: number
  hourly_rate: number
  bio?: string
  verified: boolean
  rating?: number
}

export interface Session {
  id: string
  teacher_id: string
  title: string
  date: string
  live_link?: string
  type: 'live' | 'recorded'
  teacher_name?: string
}

export interface Attendance {
  id: string
  student_id: string
  session_id: string
  present: boolean
  date: string
  session_title?: string
  teacher_name?: string
}

export interface Progress {
  id: string
  student_id: string
  lessons_done: number
  chapters_done: number
  assessments_done: number
  total_lessons: number
  total_chapters: number
}

export interface Assessment {
  id: string
  student_id: string
  topic: string
  score: number
  max_score: number
  date: string
}

export interface Upload {
  id: string
  teacher_id: string
  name: string
  type: string
  url: string
  topic: string
  uploaded_at: string
  teacher_name?: string
}

export interface Payment {
  id: string
  parent_id: string
  teacher_id: string
  amount: number
  status: 'paid' | 'pending' | 'debt'
  description?: string
  date: string
  teacher_name?: string
}
