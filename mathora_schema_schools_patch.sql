-- ==========================================
-- MATHORA — Multi-Tenant Schools Patch
-- Run after mathora_schema.sql + mathora_schema_auth_patch.sql (needs
-- current_teacher_id()/current_student_id(), and the join_class_with_code
-- RPC + class_students' no-client-insert convention this patch extends
-- rather than replaces).
--
-- Adds: schools as a real entity (teachers.school_id, classes.school_id),
-- a site-wide kill switch for self-serve school creation, a teacher
-- roster (manually or CSV/XLSX added placeholder students), and three
-- ways a student ends up in a class:
--   a) invite link  -> existing join_class_with_code, unchanged, instant.
--   b) search & join -> find_or_request_class_join(): auto-claims an
--      unclaimed roster row if the caller's name (+ verification value,
--      when the teacher set one) matches exactly one; otherwise files a
--      pending class_join_requests row for the teacher to decide.
--   c) teacher decides a pending request -> decide_join_request().
--
-- SECURITY NOTE this patch is deliberately careful about: Postgres RLS
-- is row-level only, so a policy that lets a browsing (not-yet-member)
-- student SELECT a class row would hand them classes.join_code too --
-- the literal bypass credential for path (a). That's why "browse
-- classes at a school" is a view (class_directory) that simply never
-- selects join_code, rather than a permissive RLS policy on the raw
-- classes table.
-- ==========================================

-- ------------------------------------------
-- 1. SCHOOLS
-- ------------------------------------------

create table public.schools (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  state text not null default 'Lagos',
  address text,
  status text not null default 'active'
    check (status in ('active', 'pending', 'rejected')),
  verified boolean not null default false,
  created_by_teacher_id uuid references public.teachers(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Case-insensitive duplicate guard -- the hard backstop behind
-- create_or_suggest_school()'s friendlier pre-check.
create unique index schools_name_state_ci_key
  on public.schools (lower(name), lower(state));

alter table public.schools enable row level security;

-- ------------------------------------------
-- 2. PLATFORM SETTINGS -- singleton row, site-wide kill switch
-- ------------------------------------------

create table public.platform_settings (
  id smallint primary key default 1 check (id = 1),
  self_serve_school_creation_enabled boolean not null default true,
  updated_at timestamptz not null default now()
);

insert into public.platform_settings (id) values (1);

alter table public.platform_settings enable row level security;

-- ------------------------------------------
-- 3. CLASS ROSTER ENTRIES -- teacher-added placeholder students,
-- claimed by a real student account via find_or_request_class_join().
-- ------------------------------------------

create table public.class_roster_entries (
  id uuid primary key default gen_random_uuid(),
  class_id uuid references public.classes(id) on delete cascade not null,
  full_name text not null,
  verification_value text, -- teacher's choice: phone, admission no, etc.
  claimed_by_student_id uuid references public.students(id) on delete set null,
  claimed_at timestamptz,
  created_at timestamptz not null default now()
);

alter table public.class_roster_entries enable row level security;

create index class_roster_entries_class_unclaimed_idx
  on public.class_roster_entries (class_id, lower(full_name))
  where claimed_by_student_id is null;

-- ------------------------------------------
-- 4. CLASS JOIN REQUESTS -- search-and-join pending-approval path
-- ------------------------------------------

create table public.class_join_requests (
  id uuid primary key default gen_random_uuid(),
  class_id uuid references public.classes(id) on delete cascade not null,
  student_id uuid references public.students(id) on delete cascade not null,
  verification_value text,
  status text not null default 'pending'
    check (status in ('pending', 'approved', 'rejected')),
  decided_at timestamptz,
  created_at timestamptz not null default now()
);

alter table public.class_join_requests enable row level security;

-- Only one PENDING request per (class, student) at a time -- a partial
-- index so a prior rejection doesn't permanently block re-requesting.
create unique index class_join_requests_one_pending_idx
  on public.class_join_requests (class_id, student_id)
  where status = 'pending';

-- ------------------------------------------
-- 5. MULTI-TENANT SCOPING ON EXISTING TABLES
-- teachers.school_name stays as-is (unmigrated) for backward-compat
-- display when school_id is null. classes.school_id is nullable so
-- pre-existing classes stay unscoped and un-browsable (opt-in, not a
-- silent visibility change for old data).
-- ------------------------------------------

alter table public.teachers add column school_id uuid references public.schools(id) on delete set null;
alter table public.classes add column school_id uuid references public.schools(id) on delete set null;

create index teachers_school_id_idx on public.teachers (school_id);
create index classes_school_id_idx on public.classes (school_id);

-- ------------------------------------------
-- 6. SCHOOLS -- read policies
-- ------------------------------------------

create policy "schools_select_active" on public.schools for select
  using (status = 'active');

-- A teacher can see their own pending/rejected suggestion so their UI
-- can show "awaiting review" instead of it just vanishing.
create policy "schools_select_own_pending" on public.schools for select
  using (created_by_teacher_id = public.current_teacher_id());

create policy "schools_select_admin" on public.schools for select
  using (
    exists (
      select 1 from public.users u
      where u.id = auth.uid() and u.role in ('content_admin', 'academic_admin', 'super_admin')
    )
  );

-- No INSERT policy -- creation only via create_or_suggest_school(),
-- which is the only place that may branch on the kill switch.

-- Admin moderation: verify/approve/reject via a single-field-scoped
-- UPDATE policy (no branching logic needed, unlike creation).
create policy "schools_update_admin" on public.schools for update
  using (
    exists (
      select 1 from public.users u
      where u.id = auth.uid() and u.role in ('content_admin', 'academic_admin', 'super_admin')
    )
  );

revoke update on public.schools from authenticated;
grant update (status, verified, updated_at) on public.schools to authenticated;

create policy "schools_delete_admin" on public.schools for delete
  using (
    exists (
      select 1 from public.users u
      where u.id = auth.uid() and u.role in ('content_admin', 'academic_admin', 'super_admin')
    )
  );

-- ------------------------------------------
-- 7. PLATFORM_SETTINGS
-- ------------------------------------------

create policy "platform_settings_select_all" on public.platform_settings for select
  using (true);

create policy "platform_settings_update_super_admin" on public.platform_settings for update
  using (
    exists (select 1 from public.users u where u.id = auth.uid() and u.role = 'super_admin')
  );

revoke update on public.platform_settings from authenticated;
grant update (self_serve_school_creation_enabled, updated_at) on public.platform_settings to authenticated;

-- ------------------------------------------
-- 8. TEACHER DIRECTORY VISIBILITY
-- teachers_read_public (auth patch, `using (true)`) already covers the
-- teachers table itself, but it has no full_name column -- that's on
-- public.users, whose existing RLS doesn't cover an arbitrary browsing
-- student. This is what actually lets "find teacher" show a name.
-- Narrowly scoped to role = 'teacher' only, not every user row.
-- ------------------------------------------

create policy "users_select_teacher_directory" on public.users for select
  using (role = 'teacher');

-- ------------------------------------------
-- 9. CLASS DIRECTORY -- browsable-before-joining read model.
-- Deliberately a VIEW, not an RLS policy on the raw classes table:
-- the column list below never includes join_code, so a browsing
-- student can discover a class exists without ever seeing its literal
-- join credential. A direct SELECT on public.classes by a non-member
-- still returns nothing -- governed solely by the pre-existing
-- classes_select_owner_or_enrolled policy from the auth patch.
-- ------------------------------------------

create view public.class_directory as
select id, name, class_level, teacher_id, school_id, created_at
from public.classes
where school_id is not null;

grant select on public.class_directory to authenticated;

-- ------------------------------------------
-- 10. CLASS_ROSTER_ENTRIES -- teacher-only read; no client write policy
-- at all. Writes go through bulk_add_roster_entries() (insert) and the
-- claim side-effect inside find_or_request_class_join() (update),
-- both security definer. This also means a browsing student can never
-- query another student's name/verification_value directly.
-- ------------------------------------------

create policy "class_roster_entries_select_owner" on public.class_roster_entries for select
  using (class_id in (select id from public.classes where teacher_id = public.current_teacher_id()));

-- ------------------------------------------
-- 11. CLASS_JOIN_REQUESTS -- student sees their own, teacher sees
-- their class's queue. No client write policy -- created by
-- find_or_request_class_join(), decided by decide_join_request().
-- ------------------------------------------

create policy "class_join_requests_select_owner_or_self" on public.class_join_requests for select
  using (
    student_id = public.current_student_id()
    or class_id in (select id from public.classes where teacher_id = public.current_teacher_id())
  );

-- ------------------------------------------
-- 12. RPC: create_or_suggest_school
-- ------------------------------------------

create or replace function public.create_or_suggest_school(
  p_name text,
  p_state text default 'Lagos',
  p_address text default null
)
returns public.schools
language plpgsql
security definer
set search_path = public
as $$
declare
  tid uuid := public.current_teacher_id();
  self_serve_enabled boolean;
  new_school public.schools;
begin
  if tid is null then
    raise exception 'Only a teacher profile can create or suggest a school';
  end if;

  if exists (
    select 1 from public.schools
    where lower(name) = lower(p_name) and lower(state) = lower(p_state)
  ) then
    raise exception 'A school with this name already exists in this state';
  end if;

  select self_serve_school_creation_enabled into self_serve_enabled
  from public.platform_settings where id = 1;

  insert into public.schools (name, state, address, status, created_by_teacher_id)
  values (
    p_name, p_state, p_address,
    case when self_serve_enabled then 'active' else 'pending' end,
    tid
  )
  returning * into new_school;

  return new_school;
end;
$$;

grant execute on function public.create_or_suggest_school(text, text, text) to authenticated;

-- ------------------------------------------
-- 13. RPC: join_school -- sets the CALLER teacher's school_id. Only an
-- active school can be joined (not a pending suggestion).
-- ------------------------------------------

create or replace function public.join_school(p_school_id uuid)
returns public.teachers
language plpgsql
security definer
set search_path = public
as $$
declare
  tid uuid := public.current_teacher_id();
  updated_teacher public.teachers;
begin
  if tid is null then
    raise exception 'Only a teacher profile can join a school';
  end if;

  if not exists (select 1 from public.schools where id = p_school_id and status = 'active') then
    raise exception 'School not found or not active';
  end if;

  update public.teachers set school_id = p_school_id where id = tid
  returning * into updated_teacher;

  return updated_teacher;
end;
$$;

grant execute on function public.join_school(uuid) to authenticated;

-- ------------------------------------------
-- 14. RPC: create_class -- server-side join_code generation (collision-
-- checked, unlike the old client-side `MATH-####`), auto-stamps
-- school_id from the caller's current school.
-- ------------------------------------------

create or replace function public.create_class(
  p_name text,
  p_class_level class_level
)
returns public.classes
language plpgsql
security definer
set search_path = public
as $$
declare
  tid uuid := public.current_teacher_id();
  candidate_code text;
  new_class public.classes;
begin
  if tid is null then
    raise exception 'Only a teacher profile can create a class';
  end if;

  loop
    candidate_code := 'MATH-' || lpad(floor(random() * 9000 + 1000)::text, 4, '0');
    exit when not exists (select 1 from public.classes where join_code = candidate_code);
  end loop;

  insert into public.classes (teacher_id, name, class_level, join_code, school_id)
  values (tid, p_name, p_class_level, candidate_code, (select school_id from public.teachers where id = tid))
  returning * into new_class;

  return new_class;
end;
$$;

grant execute on function public.create_class(text, class_level) to authenticated;

-- ------------------------------------------
-- 15. RPC: bulk_add_roster_entries -- one call for both manual add
-- (array of length 1) and CSV/XLSX bulk add.
-- ------------------------------------------

create or replace function public.bulk_add_roster_entries(
  p_class_id uuid,
  p_entries jsonb -- array of {"full_name": "...", "verification_value": "..." | null}
)
returns setof public.class_roster_entries
language plpgsql
security definer
set search_path = public
as $$
declare
  tid uuid := public.current_teacher_id();
begin
  if tid is null or not exists (
    select 1 from public.classes where id = p_class_id and teacher_id = tid
  ) then
    raise exception 'Not authorized to add roster entries to this class';
  end if;

  return query
  insert into public.class_roster_entries (class_id, full_name, verification_value)
  select
    p_class_id,
    entry ->> 'full_name',
    entry ->> 'verification_value'
  from jsonb_array_elements(p_entries) as entry
  where trim(entry ->> 'full_name') <> ''
  returning *;
end;
$$;

grant execute on function public.bulk_add_roster_entries(uuid, jsonb) to authenticated;

-- ------------------------------------------
-- 16. RPC: find_or_request_class_join -- the one entry point for the
-- "search & join" path (b). Path (a), the invite link, still calls the
-- existing join_class_with_code unchanged.
--
-- Match rule: a roster row with a non-null verification_value REQUIRES
-- the caller's supplied value to match (case-insensitive) -- it does
-- NOT fall back to name-only just because the caller left the field
-- blank. Only a row where the teacher never set a verification_value
-- falls back to name-only. Getting this backwards would let anyone
-- claim a verified roster row by simply submitting nothing.
-- ------------------------------------------

create or replace function public.find_or_request_class_join(
  p_class_id uuid,
  p_verification_value text default null
)
returns jsonb -- {"status": "joined" | "already_member" | "pending"}
language plpgsql
security definer
set search_path = public
as $$
declare
  sid uuid := public.current_student_id();
  caller_name text;
  match_row public.class_roster_entries;
  match_count integer;
begin
  if sid is null then
    raise exception 'Only a student profile can request to join a class';
  end if;

  if exists (select 1 from public.class_students where class_id = p_class_id and student_id = sid) then
    return jsonb_build_object('status', 'already_member');
  end if;

  select full_name into caller_name from public.users where id = auth.uid();

  select count(*) into match_count
  from public.class_roster_entries
  where class_id = p_class_id
    and claimed_by_student_id is null
    and lower(full_name) = lower(caller_name)
    and (verification_value is null or lower(verification_value) = lower(p_verification_value));

  if match_count = 1 then
    select * into match_row
    from public.class_roster_entries
    where class_id = p_class_id
      and claimed_by_student_id is null
      and lower(full_name) = lower(caller_name)
      and (verification_value is null or lower(verification_value) = lower(p_verification_value))
    limit 1;

    update public.class_roster_entries
    set claimed_by_student_id = sid, claimed_at = now()
    where id = match_row.id;

    insert into public.class_students (class_id, student_id)
    values (p_class_id, sid)
    on conflict (class_id, student_id) do nothing;

    return jsonb_build_object('status', 'joined');
  end if;

  -- 0 matches, or ambiguous (>1 tie) -- fall through to a pending
  -- request rather than guessing which roster row is really them.
  insert into public.class_join_requests (class_id, student_id, verification_value)
  values (p_class_id, sid, p_verification_value)
  on conflict (class_id, student_id) where status = 'pending' do nothing;

  return jsonb_build_object('status', 'pending');
end;
$$;

grant execute on function public.find_or_request_class_join(uuid, text) to authenticated;

-- ------------------------------------------
-- 17. RPC: decide_join_request -- teacher approves/rejects (path c).
-- Ownership is checked via an explicit join in the query, not just
-- implied by security definer -- belt-and-suspenders against ever
-- letting a teacher decide a request on a class they don't own.
-- ------------------------------------------

create or replace function public.decide_join_request(
  p_request_id uuid,
  p_approve boolean
)
returns public.class_join_requests
language plpgsql
security definer
set search_path = public
as $$
declare
  tid uuid := public.current_teacher_id();
  req public.class_join_requests;
begin
  select r.* into req
  from public.class_join_requests r
  join public.classes c on c.id = r.class_id
  where r.id = p_request_id and c.teacher_id = tid and r.status = 'pending';

  if req.id is null then
    raise exception 'Join request not found or not pending';
  end if;

  if p_approve then
    insert into public.class_students (class_id, student_id)
    values (req.class_id, req.student_id)
    on conflict (class_id, student_id) do nothing;
  end if;

  update public.class_join_requests
  set status = case when p_approve then 'approved' else 'rejected' end, decided_at = now()
  where id = p_request_id
  returning * into req;

  return req;
end;
$$;

grant execute on function public.decide_join_request(uuid, boolean) to authenticated;
