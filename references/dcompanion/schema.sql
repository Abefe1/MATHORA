-- D Companion — Complete Supabase Schema (v2 - final)
-- Run in: Supabase Dashboard → SQL Editor

create table public.users (
  id uuid references auth.users(id) on delete cascade primary key,
  name text not null, email text not null, phone text,
  role text not null check (role in ('student','teacher','parent','admin')),
  avatar_url text, created_at timestamptz default now()
);

create table public.students (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.users(id) on delete cascade unique,
  class text not null, parent_id uuid references public.users(id), age int
);

create table public.teachers (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.users(id) on delete cascade unique,
  subject text not null, experience_years int default 0,
  hourly_rate numeric(10,2) not null default 0,
  bio text, verified boolean default false, rating numeric(3,1)
);

create table public.parents (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.users(id) on delete cascade unique,
  phone text not null
);

create table public.parent_child (
  parent_id uuid references public.parents(id) on delete cascade,
  student_id uuid references public.students(id) on delete cascade,
  primary key (parent_id, student_id)
);

create table public.rooms (
  id uuid primary key default gen_random_uuid(),
  teacher_id uuid references public.teachers(id) on delete cascade,
  name text not null, created_at timestamptz default now()
);

create table public.room_students (
  room_id uuid references public.rooms(id) on delete cascade,
  student_id uuid references public.students(id) on delete cascade,
  primary key (room_id, student_id)
);

create table public.sessions (
  id uuid primary key default gen_random_uuid(),
  teacher_id uuid references public.teachers(id) on delete cascade,
  room_id uuid references public.rooms(id),
  title text not null, date timestamptz not null default now(),
  duration_minutes int default 60, live_link text,
  type text default 'live' check (type in ('live','recorded')),
  created_at timestamptz default now()
);

create table public.attendance (
  id uuid primary key default gen_random_uuid(),
  student_id uuid references public.students(id) on delete cascade,
  session_id uuid references public.sessions(id) on delete cascade,
  present boolean default false, date date not null default current_date
);

create table public.progress (
  id uuid primary key default gen_random_uuid(),
  student_id uuid references public.students(id) on delete cascade unique,
  lessons_done int default 0, chapters_done int default 0,
  assessments_done int default 0, total_lessons int default 100,
  total_chapters int default 22, updated_at timestamptz default now()
);

create table public.assessments (
  id uuid primary key default gen_random_uuid(),
  student_id uuid references public.students(id) on delete cascade,
  topic text not null, score numeric(5,2) default 0,
  max_score numeric(5,2) default 100, date date default current_date
);

create table public.teacher_assessments (
  id uuid primary key default gen_random_uuid(),
  teacher_id uuid references public.teachers(id) on delete cascade,
  title text not null, topic text not null,
  questions jsonb not null default '[]', created_at timestamptz default now()
);

create table public.assessment_submissions (
  id uuid primary key default gen_random_uuid(),
  assessment_id uuid references public.teacher_assessments(id) on delete cascade,
  student_id uuid references public.students(id) on delete cascade,
  answers jsonb not null default '[]', score numeric(5,2),
  submitted_at timestamptz default now()
);

create table public.payments (
  id uuid primary key default gen_random_uuid(),
  parent_id uuid references public.parents(id) on delete cascade,
  teacher_id uuid references public.teachers(id) on delete cascade,
  amount numeric(10,2) not null,
  status text default 'pending' check (status in ('paid','pending','debt')),
  description text, date timestamptz default now()
);

create table public.uploads (
  id uuid primary key default gen_random_uuid(),
  teacher_id uuid references public.teachers(id) on delete cascade,
  name text not null, size bigint not null, type text not null,
  url text not null, topic text not null default 'Other',
  uploaded_at timestamptz default now()
);

-- Enable RLS
do $$ declare t text; begin
  for t in select unnest(array['users','students','teachers','parents','parent_child','rooms','room_students','sessions','attendance','progress','assessments','teacher_assessments','assessment_submissions','payments','uploads']) loop
    execute format('alter table public.%I enable row level security', t);
  end loop;
end $$;

-- Basic policies (open for development — tighten in production)
create policy "auth_select" on public.users for select using (auth.role() = 'authenticated');
create policy "auth_update" on public.users for update using (auth.uid() = id);
create policy "auth_all_students" on public.students for all using (auth.role() = 'authenticated');
create policy "auth_all_teachers" on public.teachers for all using (auth.role() = 'authenticated');
create policy "auth_all_parents" on public.parents for all using (auth.role() = 'authenticated');
create policy "auth_all_pc" on public.parent_child for all using (auth.role() = 'authenticated');
create policy "auth_all_rooms" on public.rooms for all using (auth.role() = 'authenticated');
create policy "auth_all_rs" on public.room_students for all using (auth.role() = 'authenticated');
create policy "auth_all_sessions" on public.sessions for all using (auth.role() = 'authenticated');
create policy "auth_all_attend" on public.attendance for all using (auth.role() = 'authenticated');
create policy "auth_all_progress" on public.progress for all using (auth.role() = 'authenticated');
create policy "auth_all_assess" on public.assessments for all using (auth.role() = 'authenticated');
create policy "auth_all_ta" on public.teacher_assessments for all using (auth.role() = 'authenticated');
create policy "auth_all_as" on public.assessment_submissions for all using (auth.role() = 'authenticated');
create policy "auth_all_payments" on public.payments for all using (auth.role() = 'authenticated');
create policy "auth_all_uploads" on public.uploads for all using (auth.role() = 'authenticated');

-- Make admin: after signup, run:
-- update public.users set role = 'admin' where email = 'your@email.com';

-- Storage buckets (create in Supabase Dashboard → Storage):
-- 1. "lesson-materials" (public)
-- 2. "avatars" (public)
