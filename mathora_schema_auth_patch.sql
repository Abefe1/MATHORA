-- ==========================================
-- MATHORA — Auth & RLS Hardening Patch
-- Run this AFTER mathora_schema.sql against the same Supabase project.
--
-- Fixes, relative to the original RLS section of mathora_schema.sql:
--
-- 1. Ownership scoping: the original policies only checked
--    `auth.role() = 'authenticated'`, i.e. "is anyone logged in" —
--    not "is this the caller's own row". Any signed-in user could
--    read/write every other student's attempts, mastery, classes,
--    and submissions. Note also that students.id / teachers.id are
--    NOT the same uuid as auth.uid() — they're separate profile-table
--    primary keys linked via user_id — so ownership checks below go
--    through that indirection.
--
-- 2. Privilege escalation: users_update_own allowed a user to update
--    every column on their own public.users row, including `role`,
--    letting any student promote themselves to e.g. super_admin.
--    Fixed with column-level GRANTs (role is never client-writable).
--
-- 3. Signup no longer trusts client-supplied role. auth.signUp()
--    metadata (raw_user_meta_data) is attacker-controlled — a client
--    can pass { data: { role: 'super_admin' } }. The trigger below
--    whitelists self-serve roles to student/teacher/parent only and
--    stamps the sanitized role into raw_app_meta_data (server-only,
--    included in the JWT), which is what proxy.ts / RLS should trust
--    instead of user_metadata.
--
-- Idempotent-ish: policies are dropped and recreated so this can be
-- re-run safely; the trigger/function use CREATE OR REPLACE.
-- ==========================================

-- ------------------------------------------
-- 1. USER PROVISIONING TRIGGER
-- Creates the public.users (+ students/teachers profile) row when
-- someone signs up, and sanitizes the role before it ever reaches
-- the JWT. This replaces any client-side "insert into public.users"
-- call — the client should never need INSERT on public.users.
-- ------------------------------------------

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  requested_role text := new.raw_user_meta_data ->> 'role';
  safe_role user_role;
begin
  -- Only these roles may be self-assigned at signup. Anything else
  -- (content_admin, academic_admin, support_admin, finance_admin,
  -- super_admin) must be granted out-of-band by an existing admin.
  safe_role := case
    when requested_role in ('student', 'teacher', 'parent') then requested_role::user_role
    else 'student'::user_role
  end;

  -- Stamp the sanitized role into app_metadata so it rides along in
  -- the JWT and is not further editable by the client.
  new.raw_app_meta_data := coalesce(new.raw_app_meta_data, '{}'::jsonb)
    || jsonb_build_object('role', safe_role);

  insert into public.users (id, full_name, email, phone, role)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'full_name', ''),
    new.email,
    new.raw_user_meta_data ->> 'phone',
    safe_role
  );

  if safe_role = 'student' then
    insert into public.students (user_id, current_level)
    values (
      new.id,
      coalesce((new.raw_user_meta_data ->> 'current_level')::class_level, 'SS2'::class_level)
    );
  elsif safe_role = 'teacher' then
    insert into public.teachers (user_id, school_name, state)
    values (
      new.id,
      new.raw_user_meta_data ->> 'school_name',
      coalesce(new.raw_user_meta_data ->> 'state', 'Lagos')
    );
  end if;

  return new;
end;
$$;

-- BEFORE INSERT so we can mutate raw_app_meta_data on the row itself.
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  before insert on auth.users
  for each row execute function public.handle_new_user();

-- ------------------------------------------
-- 2. LOCK DOWN public.users COLUMN-LEVEL WRITES
-- RLS controls which rows a user can touch; column privileges control
-- which columns they can touch. A user may update their own profile
-- fields but never their own role.
-- ------------------------------------------

revoke update on public.users from authenticated;
grant update (full_name, phone, avatar_url, updated_at) on public.users to authenticated;

-- ------------------------------------------
-- 3. HELPER: current caller's students.id / teachers.id
-- Wrapping the user_id -> profile-id lookup in a STABLE function keeps
-- policies readable and lets Postgres cache the result per statement.
-- ------------------------------------------

create or replace function public.current_student_id()
returns uuid
language sql
stable
security definer
set search_path = public
as $$
  select id from public.students where user_id = auth.uid();
$$;

create or replace function public.current_teacher_id()
returns uuid
language sql
stable
security definer
set search_path = public
as $$
  select id from public.teachers where user_id = auth.uid();
$$;

-- ------------------------------------------
-- 4. DROP THE OLD "ANY AUTHENTICATED USER" POLICIES
-- ------------------------------------------

drop policy if exists "users_select_all" on public.users;
drop policy if exists "users_update_own" on public.users;
drop policy if exists "students_read" on public.students;
drop policy if exists "teachers_read" on public.teachers;
drop policy if exists "attempts_insert_student" on public.attempts;
drop policy if exists "attempts_select_own" on public.attempts;
drop policy if exists "topic_mastery_all" on public.topic_mastery;
drop policy if exists "classes_all" on public.classes;
drop policy if exists "class_students_all" on public.class_students;
drop policy if exists "assignments_all" on public.assignments;
drop policy if exists "assignment_submissions_all" on public.assignment_submissions;

-- ------------------------------------------
-- 5. USERS
-- ------------------------------------------

create policy "users_select_own_or_related" on public.users for select
  using (
    auth.uid() = id
    -- a student's parent can see the student's user row
    or id in (select user_id from public.students where parent_id = auth.uid())
    -- a teacher can see users who are students in one of their classes
    or id in (
      select s.user_id from public.students s
      join public.class_students cs on cs.student_id = s.id
      join public.classes c on c.id = cs.class_id
      where c.teacher_id = public.current_teacher_id()
    )
  );

create policy "users_update_own" on public.users for update
  using (auth.uid() = id);
-- (column-level grant above already prevents role changes)

-- ------------------------------------------
-- 6. STUDENTS / TEACHERS PROFILES
-- ------------------------------------------

create policy "students_read_self" on public.students for select
  using (
    user_id = auth.uid()
    or parent_id = auth.uid()
    or id in (
      select cs.student_id from public.class_students cs
      join public.classes c on c.id = cs.class_id
      where c.teacher_id = public.current_teacher_id()
    )
  );

create policy "teachers_read_public" on public.teachers for select
  using (true); -- low-sensitivity directory info (school, verified flag)

-- ------------------------------------------
-- 7. ATTEMPTS — a student's own quiz attempts
-- ------------------------------------------

create policy "attempts_insert_own" on public.attempts for insert
  with check (student_id = public.current_student_id());

create policy "attempts_select_own_or_related" on public.attempts for select
  using (
    student_id = public.current_student_id()
    or student_id in (select id from public.students where parent_id = auth.uid())
    or student_id in (
      select cs.student_id from public.class_students cs
      join public.classes c on c.id = cs.class_id
      where c.teacher_id = public.current_teacher_id()
    )
  );

-- ------------------------------------------
-- 8. TOPIC MASTERY — read-only for clients; writes happen via a
-- SECURITY DEFINER function/trigger after grading an attempt, not
-- directly from the browser.
-- ------------------------------------------

create policy "topic_mastery_select_own_or_related" on public.topic_mastery for select
  using (
    student_id = public.current_student_id()
    or student_id in (select id from public.students where parent_id = auth.uid())
    or student_id in (
      select cs.student_id from public.class_students cs
      join public.classes c on c.id = cs.class_id
      where c.teacher_id = public.current_teacher_id()
    )
  );

-- ------------------------------------------
-- 9. CLASSES — owned by a teacher; visible to enrolled students too
-- ------------------------------------------

create policy "classes_select_owner_or_enrolled" on public.classes for select
  using (
    teacher_id = public.current_teacher_id()
    or id in (select class_id from public.class_students where student_id = public.current_student_id())
  );

create policy "classes_write_owner" on public.classes for insert
  with check (teacher_id = public.current_teacher_id());

create policy "classes_update_owner" on public.classes for update
  using (teacher_id = public.current_teacher_id());

create policy "classes_delete_owner" on public.classes for delete
  using (teacher_id = public.current_teacher_id());

-- ------------------------------------------
-- 10. CLASS_STUDENTS
-- Deliberately no client-side INSERT policy: joining a class by code
-- should go through a SECURITY DEFINER RPC (see patch note below)
-- that validates the join_code server-side, rather than trusting the
-- client to submit an honest (class_id, student_id) pair.
-- ------------------------------------------

create policy "class_students_select_owner_or_self" on public.class_students for select
  using (
    student_id = public.current_student_id()
    or class_id in (select id from public.classes where teacher_id = public.current_teacher_id())
  );

create policy "class_students_delete_owner_or_self" on public.class_students for delete
  using (
    student_id = public.current_student_id()
    or class_id in (select id from public.classes where teacher_id = public.current_teacher_id())
  );

-- RPC: join a class with its join_code as the currently-authenticated
-- student. Runs as the function owner so it can bypass the (deliberately
-- absent) insert policy above, but only ever inserts the CALLER's own
-- student_id — never an arbitrary one.
create or replace function public.join_class_with_code(code text)
returns public.classes
language plpgsql
security definer
set search_path = public
as $$
declare
  target public.classes;
  sid uuid := public.current_student_id();
begin
  if sid is null then
    raise exception 'Only a student profile can join a class';
  end if;

  select * into target from public.classes where join_code = code;
  if target.id is null then
    raise exception 'Invalid class code';
  end if;

  insert into public.class_students (class_id, student_id)
  values (target.id, sid)
  on conflict (class_id, student_id) do nothing;

  return target;
end;
$$;

grant execute on function public.join_class_with_code(text) to authenticated;

-- ------------------------------------------
-- 11. ASSIGNMENTS — visible to the owning teacher and enrolled students
-- ------------------------------------------

create policy "assignments_select_owner_or_enrolled" on public.assignments for select
  using (
    class_id in (select id from public.classes where teacher_id = public.current_teacher_id())
    or class_id in (select class_id from public.class_students where student_id = public.current_student_id())
  );

create policy "assignments_write_owner" on public.assignments for insert
  with check (class_id in (select id from public.classes where teacher_id = public.current_teacher_id()));

create policy "assignments_update_owner" on public.assignments for update
  using (class_id in (select id from public.classes where teacher_id = public.current_teacher_id()));

create policy "assignments_delete_owner" on public.assignments for delete
  using (class_id in (select id from public.classes where teacher_id = public.current_teacher_id()));

-- ------------------------------------------
-- 12. ASSIGNMENT SUBMISSIONS
-- ------------------------------------------

create policy "assignment_submissions_select_owner_or_related" on public.assignment_submissions for select
  using (
    student_id = public.current_student_id()
    or assignment_id in (
      select a.id from public.assignments a
      join public.classes c on c.id = a.class_id
      where c.teacher_id = public.current_teacher_id()
    )
  );

create policy "assignment_submissions_insert_own" on public.assignment_submissions for insert
  with check (
    student_id = public.current_student_id()
    and assignment_id in (
      select a.id from public.assignments a
      where a.class_id in (select class_id from public.class_students where student_id = public.current_student_id())
    )
  );

create policy "assignment_submissions_update_own" on public.assignment_submissions for update
  using (student_id = public.current_student_id());
