-- ==========================================
-- MATHORA — Study Squads (Groups) Schema
-- Run after mathora_schema.sql + mathora_schema_auth_patch.sql (needs
-- current_student_id() and the users_select_own_or_related policy
-- this patch adds an OR-clause alongside).
--
-- Backs mathora-mobile/src/services/supabaseService.ts's
-- getMobileStudySquads(), which today silently falls back to
-- STUDY_SQUADS_DATA mock data because no `study_groups` table exists
-- (the query 500s/errors and the function's own catch swallows it).
-- mathora-mobile/src/app/squads.tsx doesn't call that function yet —
-- it renders STUDY_SQUADS_DATA directly — so this patch has no user-
-- facing effect until the screen is wired to live data; it exists so
-- that wiring-up is a client-only change from here.
--
-- Mirrors the classes/class_students/join_class_with_code pattern in
-- mathora_schema_auth_patch.sql: a squad is created by one student
-- (the leader) via a SECURITY DEFINER RPC, other students join with a
-- short code through a second RPC rather than inserting membership
-- rows directly — same anti-spoofing reasoning as join_class_with_code
-- (a client could otherwise insert itself into any group, or insert
-- some OTHER student_id into a group).
--
-- member_count / weekly_progress_questions / rank_position /
-- top_members are display aggregates, not stored columns — they're
-- computed on read by the study_groups_with_stats view below so they
-- can never drift from the real membership/attempts data.
-- ==========================================

-- ------------------------------------------
-- 1. TABLES
-- ------------------------------------------

create table public.study_groups (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  join_code text not null unique, -- same column name/shape as classes.join_code
  exam_focus text,
  leader_id uuid references public.students(id) on delete set null,
  weekly_goal_questions integer not null default 100 check (weekly_goal_questions > 0),
  recent_announcement text,
  created_at timestamptz not null default now()
);

create table public.study_group_members (
  group_id uuid references public.study_groups(id) on delete cascade not null,
  student_id uuid references public.students(id) on delete cascade not null,
  joined_at timestamptz not null default now(),
  primary key (group_id, student_id)
);

alter table public.study_groups enable row level security;
alter table public.study_group_members enable row level security;

-- ------------------------------------------
-- 2. READ POLICIES — members only, no public squad directory (matches
-- classes_select_owner_or_enrolled's "only if you're in it" scoping).
-- ------------------------------------------

create policy "study_groups_select_member" on public.study_groups for select
  using (
    id in (
      select group_id from public.study_group_members
      where student_id = public.current_student_id()
    )
  );

create policy "study_group_members_select_own_group" on public.study_group_members for select
  using (
    group_id in (
      select group_id from public.study_group_members
      where student_id = public.current_student_id()
    )
  );

-- A squad's roster only means something if members can see each
-- other's names — this is a second, additive (OR-combined) policy
-- alongside users_select_own_or_related from the auth patch, not a
-- replacement for it. Scoped narrowly to "fellow member of a squad
-- you're also in", same shape as that policy's existing
-- teacher-can-see-their-students clause.
create policy "users_select_squadmate" on public.users for select
  using (
    id in (
      select s.user_id from public.students s
      join public.study_group_members m on m.student_id = s.id
      where m.group_id in (
        select group_id from public.study_group_members
        where student_id = public.current_student_id()
      )
    )
  );

-- ------------------------------------------
-- 3. CREATE / JOIN — SECURITY DEFINER RPCs, same reasoning as
-- join_class_with_code: only ever act on the CALLER's own
-- current_student_id(), never a client-supplied one.
-- ------------------------------------------

create or replace function public.create_study_group(
  p_name text,
  p_exam_focus text default null,
  p_weekly_goal_questions integer default 100
)
returns public.study_groups
language plpgsql
security definer
set search_path = public
as $$
declare
  sid uuid := public.current_student_id();
  new_group public.study_groups;
  candidate_code text;
begin
  if sid is null then
    raise exception 'Only a student profile can create a study squad';
  end if;

  loop
    candidate_code := 'SQUAD-' || lpad(floor(random() * 9000 + 1000)::text, 4, '0');
    exit when not exists (select 1 from public.study_groups where join_code = candidate_code);
  end loop;

  insert into public.study_groups (name, join_code, exam_focus, leader_id, weekly_goal_questions)
  values (p_name, candidate_code, p_exam_focus, sid, p_weekly_goal_questions)
  returning * into new_group;

  insert into public.study_group_members (group_id, student_id)
  values (new_group.id, sid);

  return new_group;
end;
$$;

grant execute on function public.create_study_group(text, text, integer) to authenticated;

create or replace function public.join_study_group_with_code(code text)
returns public.study_groups
language plpgsql
security definer
set search_path = public
as $$
declare
  target public.study_groups;
  sid uuid := public.current_student_id();
begin
  if sid is null then
    raise exception 'Only a student profile can join a study squad';
  end if;

  select * into target from public.study_groups where join_code = code;
  if target.id is null then
    raise exception 'Invalid squad code';
  end if;

  insert into public.study_group_members (group_id, student_id)
  values (target.id, sid)
  on conflict (group_id, student_id) do nothing;

  return target;
end;
$$;

grant execute on function public.join_study_group_with_code(text) to authenticated;

-- Leader can edit the squad's own display fields; no client-facing
-- delete policy on study_groups (disbanding is a follow-up if ever
-- needed). A member can remove themselves; the leader can remove
-- anyone.
create policy "study_groups_update_leader" on public.study_groups for update
  using (leader_id = public.current_student_id());

create policy "study_group_members_delete_self_or_leader" on public.study_group_members for delete
  using (
    student_id = public.current_student_id()
    or group_id in (select id from public.study_groups where leader_id = public.current_student_id())
  );

-- ------------------------------------------
-- 4. READ MODEL — matches mathora-mobile's StudySquad shape exactly
-- (dataService.ts), so getMobileStudySquads() can select('*') from
-- this view straight into that type. security_invoker so the view is
-- scoped by the SAME RLS as its underlying tables — a caller only
-- ever sees rows for squads they're a member of.
-- ------------------------------------------

create or replace view public.study_groups_with_stats
with (security_invoker = true)
as
select
  g.id,
  g.name,
  g.join_code as code,
  coalesce(g.exam_focus, '') as exam_focus,
  (select count(*) from public.study_group_members m where m.group_id = g.id)::integer as member_count,
  g.weekly_goal_questions,
  coalesce((
    select count(*) from public.attempts a
    join public.study_group_members m on m.student_id = a.student_id
    where m.group_id = g.id and a.attempted_at >= date_trunc('week', now())
  ), 0)::integer as weekly_progress_questions,
  rank() over (order by (
    select count(*) from public.attempts a
    join public.study_group_members m on m.student_id = a.student_id
    where m.group_id = g.id and a.attempted_at >= date_trunc('week', now())
  ) desc)::integer as rank_position,
  coalesce((
    select u.full_name from public.students s
    join public.users u on u.id = s.user_id
    where s.id = g.leader_id
  ), 'Squad Leader') as leader_name,
  coalesce((
    select jsonb_agg(jsonb_build_object('name', u.full_name, 'score', t.correct_count) order by t.correct_count desc)
    from (
      select m.student_id, count(*) filter (where a.is_correct) as correct_count
      from public.study_group_members m
      join public.attempts a on a.student_id = m.student_id and a.attempted_at >= date_trunc('week', now())
      where m.group_id = g.id
      group by m.student_id
      order by correct_count desc
      limit 3
    ) t
    join public.students s on s.id = t.student_id
    join public.users u on u.id = s.user_id
  ), '[]'::jsonb) as top_members,
  coalesce(g.recent_announcement, '') as recent_announcement
from public.study_groups g;

grant select on public.study_groups_with_stats to authenticated;
