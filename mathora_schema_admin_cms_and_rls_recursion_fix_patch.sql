-- ==========================================
-- MATHORA — Admin CMS insert policy + RLS recursion fix
-- Run after mathora_schema_content_pipeline_patch.sql and
-- mathora_schema_study_groups_patch.sql.
--
-- Two independent fixes, applied together because the first one is
-- what surfaced the second:
--
-- 1. questions had SELECT (published-or-own-draft) and UPDATE
--    (admin review) policies but no INSERT policy at all, so the
--    Admin CMS's "Add WAEC Question" form could never have written a
--    row — RLS default-denies with no matching policy. Added
--    questions_insert_by_admin, mirroring questions_review_by_admin's
--    existing admin-role check.
--
-- 2. Testing that policy against the real admin account hit
--    "42P17: infinite recursion detected in policy for relation
--    ...". Two pre-existing policies each queried their own table (or
--    a table that queries back into them) directly inside their own
--    USING clause instead of through a SECURITY DEFINER function —
--    the same trap current_student_id()/current_teacher_id() already
--    exist to avoid elsewhere:
--      - study_group_members_select_own_group queried
--        study_group_members from inside a policy ON
--        study_group_members.
--      - classes_select_owner_or_enrolled (on classes) queried
--        class_students, whose own policy queried classes right
--        back.
--    Any query touching public.users' RLS (e.g. this new insert
--    policy's admin-role lookup, via users_select_squadmate) walked
--    into both cycles. Fixed with two new STABLE SECURITY DEFINER
--    helper functions, same shape as current_student_id(), so the
--    membership lookup bypasses RLS via the definer-owner exemption
--    instead of re-triggering the policy that's mid-evaluation.
-- ==========================================

-- ------------------------------------------
-- 1. questions: allow content/academic/super admins to insert
-- ------------------------------------------

create policy "questions_insert_by_admin" on public.questions for insert
  with check (
    exists (
      select 1 from public.users u
      where u.id = auth.uid() and u.role in ('content_admin', 'academic_admin', 'super_admin')
    )
  );

-- ------------------------------------------
-- 2. Break the study_group_members <-> study_group_members recursion
-- ------------------------------------------

create or replace function public.my_study_group_ids()
returns setof uuid
language sql stable security definer
set search_path = public
as $$
  select group_id from public.study_group_members
  where student_id = public.current_student_id();
$$;

drop policy if exists "study_group_members_select_own_group" on public.study_group_members;
create policy "study_group_members_select_own_group" on public.study_group_members for select
  using (
    group_id in (select public.my_study_group_ids())
  );

-- ------------------------------------------
-- 3. Break the classes <-> class_students recursion
-- ------------------------------------------

create or replace function public.my_class_ids_as_student()
returns setof uuid
language sql stable security definer
set search_path = public
as $$
  select class_id from public.class_students
  where student_id = public.current_student_id();
$$;

drop policy if exists "classes_select_owner_or_enrolled" on public.classes;
create policy "classes_select_owner_or_enrolled" on public.classes for select
  using (
    teacher_id = current_teacher_id()
    or id in (select public.my_class_ids_as_student())
  );
