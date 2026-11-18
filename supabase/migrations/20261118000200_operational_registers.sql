-- DODO additive operational registers; drafts are NOT accounting postings.
begin;
create table public.visit_purposes (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  name text not null check (length(trim(name)) between 1 and 4000),
  unique(school_id,name)
);
create index visit_purposes_school_idx on public.visit_purposes(school_id);
alter table public.visit_purposes enable row level security;
revoke all on public.visit_purposes from public, anon, authenticated;
grant select,insert,update on public.visit_purposes to authenticated;
create policy role_select on public.visit_purposes for select to authenticated using (private.has_role(school_id,'{super_admin,admin,receptionist}'::public.dodo_role[]));
create policy role_insert on public.visit_purposes for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin,receptionist}'::public.dodo_role[]));
create policy role_update on public.visit_purposes for update to authenticated using (private.has_role(school_id,'{super_admin,admin,receptionist}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin,receptionist}'::public.dodo_role[]));
create trigger freeze_identity before update on public.visit_purposes for each row execute function private.freeze_identity();
create table public.visitors (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  visitor_name text not null check (length(trim(visitor_name)) between 1 and 4000),
  purpose_id uuid not null,
  record_date date not null,
  description text not null check (length(trim(description)) between 1 and 4000),
  foreign key(school_id,purpose_id) references public.visit_purposes(school_id,id)
);
create index visitors_school_idx on public.visitors(school_id);
create index visitors_purpose_id_idx on public.visitors(school_id,purpose_id);
alter table public.visitors enable row level security;
revoke all on public.visitors from public, anon, authenticated;
grant select,insert,update on public.visitors to authenticated;
create policy role_select on public.visitors for select to authenticated using (private.has_role(school_id,'{super_admin,admin,receptionist}'::public.dodo_role[]));
create policy role_insert on public.visitors for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin,receptionist}'::public.dodo_role[]));
create policy role_update on public.visitors for update to authenticated using (private.has_role(school_id,'{super_admin,admin,receptionist}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin,receptionist}'::public.dodo_role[]));
create trigger freeze_identity before update on public.visitors for each row execute function private.freeze_identity();
create table public.phone_calls (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  caller text not null check (length(trim(caller)) between 1 and 4000),
  phone text not null check (length(trim(phone)) between 1 and 4000),
  direction text not null check (direction in ('incoming','outgoing')),
  record_date date not null,
  description text not null check (length(trim(description)) between 1 and 4000)
);
create index phone_calls_school_idx on public.phone_calls(school_id);
alter table public.phone_calls enable row level security;
revoke all on public.phone_calls from public, anon, authenticated;
grant select,insert,update on public.phone_calls to authenticated;
create policy role_select on public.phone_calls for select to authenticated using (private.has_role(school_id,'{super_admin,admin,receptionist}'::public.dodo_role[]));
create policy role_insert on public.phone_calls for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin,receptionist}'::public.dodo_role[]));
create policy role_update on public.phone_calls for update to authenticated using (private.has_role(school_id,'{super_admin,admin,receptionist}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin,receptionist}'::public.dodo_role[]));
create trigger freeze_identity before update on public.phone_calls for each row execute function private.freeze_identity();
create table public.postal_records (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  reference_no text not null check (length(trim(reference_no)) between 1 and 4000),
  direction text not null check (direction in ('incoming','outgoing')),
  party text not null check (length(trim(party)) between 1 and 4000),
  record_date date not null,
  description text not null check (length(trim(description)) between 1 and 4000)
);
create index postal_records_school_idx on public.postal_records(school_id);
alter table public.postal_records enable row level security;
revoke all on public.postal_records from public, anon, authenticated;
grant select,insert,update on public.postal_records to authenticated;
create policy role_select on public.postal_records for select to authenticated using (private.has_role(school_id,'{super_admin,admin,receptionist}'::public.dodo_role[]));
create policy role_insert on public.postal_records for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin,receptionist}'::public.dodo_role[]));
create policy role_update on public.postal_records for update to authenticated using (private.has_role(school_id,'{super_admin,admin,receptionist}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin,receptionist}'::public.dodo_role[]));
create trigger freeze_identity before update on public.postal_records for each row execute function private.freeze_identity();
create table public.complaints (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  title text not null check (length(trim(title)) between 1 and 4000),
  description text not null check (length(trim(description)) between 1 and 4000),
  record_date date not null,
  status text not null check (status in ('open','closed'))
);
create index complaints_school_idx on public.complaints(school_id);
alter table public.complaints enable row level security;
revoke all on public.complaints from public, anon, authenticated;
grant select,insert,update on public.complaints to authenticated;
create policy role_select on public.complaints for select to authenticated using (private.has_role(school_id,'{super_admin,admin,receptionist}'::public.dodo_role[]));
create policy role_insert on public.complaints for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin,receptionist}'::public.dodo_role[]));
create policy role_update on public.complaints for update to authenticated using (private.has_role(school_id,'{super_admin,admin,receptionist}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin,receptionist}'::public.dodo_role[]));
create trigger freeze_identity before update on public.complaints for each row execute function private.freeze_identity();
create table public.student_categories (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  name text not null check (length(trim(name)) between 1 and 4000),
  unique(school_id,name)
);
create index student_categories_school_idx on public.student_categories(school_id);
alter table public.student_categories enable row level security;
revoke all on public.student_categories from public, anon, authenticated;
grant select,insert,update on public.student_categories to authenticated;
create policy role_select on public.student_categories for select to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_insert on public.student_categories for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_update on public.student_categories for update to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create trigger freeze_identity before update on public.student_categories for each row execute function private.freeze_identity();
create table public.student_houses (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  name text not null check (length(trim(name)) between 1 and 4000),
  unique(school_id,name)
);
create index student_houses_school_idx on public.student_houses(school_id);
alter table public.student_houses enable row level security;
revoke all on public.student_houses from public, anon, authenticated;
grant select,insert,update on public.student_houses to authenticated;
create policy role_select on public.student_houses for select to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_insert on public.student_houses for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_update on public.student_houses for update to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create trigger freeze_identity before update on public.student_houses for each row execute function private.freeze_identity();
create table public.disable_reasons (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  name text not null check (length(trim(name)) between 1 and 4000),
  unique(school_id,name)
);
create index disable_reasons_school_idx on public.disable_reasons(school_id);
alter table public.disable_reasons enable row level security;
revoke all on public.disable_reasons from public, anon, authenticated;
grant select,insert,update on public.disable_reasons to authenticated;
create policy role_select on public.disable_reasons for select to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_insert on public.disable_reasons for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_update on public.disable_reasons for update to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create trigger freeze_identity before update on public.disable_reasons for each row execute function private.freeze_identity();
create table public.academic_years (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  name text not null check (length(trim(name)) between 1 and 4000),
  starts_on date not null,
  ends_on date not null,
  check(ends_on>=starts_on),
  unique(school_id,name)
);
create index academic_years_school_idx on public.academic_years(school_id);
alter table public.academic_years enable row level security;
revoke all on public.academic_years from public, anon, authenticated;
grant select,insert,update on public.academic_years to authenticated;
create policy role_select on public.academic_years for select to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_insert on public.academic_years for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_update on public.academic_years for update to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create trigger freeze_identity before update on public.academic_years for each row execute function private.freeze_identity();
create table public.subjects (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  name text not null check (length(trim(name)) between 1 and 4000),
  code text not null check (length(trim(code)) between 1 and 4000),
  unique(school_id,code)
);
create index subjects_school_idx on public.subjects(school_id);
alter table public.subjects enable row level security;
revoke all on public.subjects from public, anon, authenticated;
grant select,insert,update on public.subjects to authenticated;
create policy role_select on public.subjects for select to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_insert on public.subjects for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_update on public.subjects for update to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create trigger freeze_identity before update on public.subjects for each row execute function private.freeze_identity();
create table public.teaching_assignments (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  class_id uuid not null,
  subject_id uuid not null,
  staff_id uuid not null,
  foreign key(school_id,class_id) references public.classes(school_id,id),
  foreign key(school_id,subject_id) references public.subjects(school_id,id),
  foreign key(school_id,staff_id) references public.staff(school_id,id),
  unique(school_id,class_id,subject_id,staff_id)
);
create index teaching_assignments_school_idx on public.teaching_assignments(school_id);
create index teaching_assignments_class_id_idx on public.teaching_assignments(school_id,class_id);
create index teaching_assignments_subject_id_idx on public.teaching_assignments(school_id,subject_id);
create index teaching_assignments_staff_id_idx on public.teaching_assignments(school_id,staff_id);
alter table public.teaching_assignments enable row level security;
revoke all on public.teaching_assignments from public, anon, authenticated;
grant select,insert,update on public.teaching_assignments to authenticated;
create policy role_select on public.teaching_assignments for select to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_insert on public.teaching_assignments for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_update on public.teaching_assignments for update to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create trigger freeze_identity before update on public.teaching_assignments for each row execute function private.freeze_identity();
create table public.timetable_entries (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  assignment_id uuid not null,
  weekday text not null check (weekday in ('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday')),
  period_no integer not null check (period_no>0),
  room text not null check (length(trim(room)) between 1 and 4000),
  foreign key(school_id,assignment_id) references public.teaching_assignments(school_id,id),
  unique(school_id,assignment_id,weekday,period_no)
);
create index timetable_entries_school_idx on public.timetable_entries(school_id);
create index timetable_entries_assignment_id_idx on public.timetable_entries(school_id,assignment_id);
alter table public.timetable_entries enable row level security;
revoke all on public.timetable_entries from public, anon, authenticated;
grant select,insert,update on public.timetable_entries to authenticated;
create policy role_select on public.timetable_entries for select to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_insert on public.timetable_entries for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_update on public.timetable_entries for update to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create trigger freeze_identity before update on public.timetable_entries for each row execute function private.freeze_identity();
create table public.lesson_plans (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  assignment_id uuid not null,
  title text not null check (length(trim(title)) between 1 and 4000),
  record_date date not null,
  description text not null check (length(trim(description)) between 1 and 4000),
  foreign key(school_id,assignment_id) references public.teaching_assignments(school_id,id)
);
create index lesson_plans_school_idx on public.lesson_plans(school_id);
create index lesson_plans_assignment_id_idx on public.lesson_plans(school_id,assignment_id);
alter table public.lesson_plans enable row level security;
revoke all on public.lesson_plans from public, anon, authenticated;
grant select,insert,update on public.lesson_plans to authenticated;
create policy role_select on public.lesson_plans for select to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_insert on public.lesson_plans for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_update on public.lesson_plans for update to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create trigger freeze_identity before update on public.lesson_plans for each row execute function private.freeze_identity();
create table public.exam_groups (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  name text not null check (length(trim(name)) between 1 and 4000),
  curriculum text not null check (curriculum in ('general','CBSE'))
);
create index exam_groups_school_idx on public.exam_groups(school_id);
alter table public.exam_groups enable row level security;
revoke all on public.exam_groups from public, anon, authenticated;
grant select,insert,update on public.exam_groups to authenticated;
create policy role_select on public.exam_groups for select to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_insert on public.exam_groups for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_update on public.exam_groups for update to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create trigger freeze_identity before update on public.exam_groups for each row execute function private.freeze_identity();
create table public.exams (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  group_id uuid not null,
  class_id uuid not null,
  title text not null check (length(trim(title)) between 1 and 4000),
  starts_on date not null,
  ends_on date not null,
  foreign key(school_id,group_id) references public.exam_groups(school_id,id),
  foreign key(school_id,class_id) references public.classes(school_id,id),
  check(ends_on>=starts_on)
);
create index exams_school_idx on public.exams(school_id);
create index exams_group_id_idx on public.exams(school_id,group_id);
create index exams_class_id_idx on public.exams(school_id,class_id);
alter table public.exams enable row level security;
revoke all on public.exams from public, anon, authenticated;
grant select,insert,update on public.exams to authenticated;
create policy role_select on public.exams for select to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_insert on public.exams for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_update on public.exams for update to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create trigger freeze_identity before update on public.exams for each row execute function private.freeze_identity();
create table public.exam_schedules (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  exam_id uuid not null,
  subject_id uuid not null,
  exam_date date not null,
  start_time text not null check (length(trim(start_time)) between 1 and 4000),
  max_marks integer not null check (max_marks>0),
  foreign key(school_id,exam_id) references public.exams(school_id,id),
  foreign key(school_id,subject_id) references public.subjects(school_id,id),
  check(start_time ~ '^([01][0-9]|2[0-3]):[0-5][0-9]$'),
  unique(school_id,exam_id,subject_id)
);
create index exam_schedules_school_idx on public.exam_schedules(school_id);
create index exam_schedules_exam_id_idx on public.exam_schedules(school_id,exam_id);
create index exam_schedules_subject_id_idx on public.exam_schedules(school_id,subject_id);
alter table public.exam_schedules enable row level security;
revoke all on public.exam_schedules from public, anon, authenticated;
grant select,insert,update on public.exam_schedules to authenticated;
create policy role_select on public.exam_schedules for select to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_insert on public.exam_schedules for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_update on public.exam_schedules for update to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create trigger freeze_identity before update on public.exam_schedules for each row execute function private.freeze_identity();
create table public.fee_types (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  name text not null check (length(trim(name)) between 1 and 4000),
  unique(school_id,name)
);
create index fee_types_school_idx on public.fee_types(school_id);
alter table public.fee_types enable row level security;
revoke all on public.fee_types from public, anon, authenticated;
grant select,insert,update on public.fee_types to authenticated;
create policy role_select on public.fee_types for select to authenticated using (private.has_role(school_id,'{super_admin,admin,accountant}'::public.dodo_role[]));
create policy role_insert on public.fee_types for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin,accountant}'::public.dodo_role[]));
create policy role_update on public.fee_types for update to authenticated using (private.has_role(school_id,'{super_admin,admin,accountant}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin,accountant}'::public.dodo_role[]));
create trigger freeze_identity before update on public.fee_types for each row execute function private.freeze_identity();
create table public.fee_groups (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  name text not null check (length(trim(name)) between 1 and 4000),
  unique(school_id,name)
);
create index fee_groups_school_idx on public.fee_groups(school_id);
alter table public.fee_groups enable row level security;
revoke all on public.fee_groups from public, anon, authenticated;
grant select,insert,update on public.fee_groups to authenticated;
create policy role_select on public.fee_groups for select to authenticated using (private.has_role(school_id,'{super_admin,admin,accountant}'::public.dodo_role[]));
create policy role_insert on public.fee_groups for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin,accountant}'::public.dodo_role[]));
create policy role_update on public.fee_groups for update to authenticated using (private.has_role(school_id,'{super_admin,admin,accountant}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin,accountant}'::public.dodo_role[]));
create trigger freeze_identity before update on public.fee_groups for each row execute function private.freeze_identity();
create table public.income_categories (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  name text not null check (length(trim(name)) between 1 and 4000),
  unique(school_id,name)
);
create index income_categories_school_idx on public.income_categories(school_id);
alter table public.income_categories enable row level security;
revoke all on public.income_categories from public, anon, authenticated;
grant select,insert,update on public.income_categories to authenticated;
create policy role_select on public.income_categories for select to authenticated using (private.has_role(school_id,'{super_admin,admin,accountant}'::public.dodo_role[]));
create policy role_insert on public.income_categories for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin,accountant}'::public.dodo_role[]));
create policy role_update on public.income_categories for update to authenticated using (private.has_role(school_id,'{super_admin,admin,accountant}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin,accountant}'::public.dodo_role[]));
create trigger freeze_identity before update on public.income_categories for each row execute function private.freeze_identity();
create table public.expense_categories (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  name text not null check (length(trim(name)) between 1 and 4000),
  unique(school_id,name)
);
create index expense_categories_school_idx on public.expense_categories(school_id);
alter table public.expense_categories enable row level security;
revoke all on public.expense_categories from public, anon, authenticated;
grant select,insert,update on public.expense_categories to authenticated;
create policy role_select on public.expense_categories for select to authenticated using (private.has_role(school_id,'{super_admin,admin,accountant}'::public.dodo_role[]));
create policy role_insert on public.expense_categories for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin,accountant}'::public.dodo_role[]));
create policy role_update on public.expense_categories for update to authenticated using (private.has_role(school_id,'{super_admin,admin,accountant}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin,accountant}'::public.dodo_role[]));
create trigger freeze_identity before update on public.expense_categories for each row execute function private.freeze_identity();
create table public.banks (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  name text not null check (length(trim(name)) between 1 and 4000),
  unique(school_id,name)
);
create index banks_school_idx on public.banks(school_id);
alter table public.banks enable row level security;
revoke all on public.banks from public, anon, authenticated;
grant select,insert,update on public.banks to authenticated;
create policy role_select on public.banks for select to authenticated using (private.has_role(school_id,'{super_admin,admin,accountant}'::public.dodo_role[]));
create policy role_insert on public.banks for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin,accountant}'::public.dodo_role[]));
create policy role_update on public.banks for update to authenticated using (private.has_role(school_id,'{super_admin,admin,accountant}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin,accountant}'::public.dodo_role[]));
create trigger freeze_identity before update on public.banks for each row execute function private.freeze_identity();
create table public.income_drafts (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  category_id uuid not null,
  description text not null check (length(trim(description)) between 1 and 4000),
  amount numeric(14,2) not null check (amount>0 and amount::text not in ('NaN','Infinity','-Infinity')),
  record_date date not null,
  foreign key(school_id,category_id) references public.income_categories(school_id,id)
);
create index income_drafts_school_idx on public.income_drafts(school_id);
create index income_drafts_category_id_idx on public.income_drafts(school_id,category_id);
alter table public.income_drafts enable row level security;
revoke all on public.income_drafts from public, anon, authenticated;
grant select,insert,update on public.income_drafts to authenticated;
create policy role_select on public.income_drafts for select to authenticated using (private.has_role(school_id,'{super_admin,admin,accountant}'::public.dodo_role[]));
create policy role_insert on public.income_drafts for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin,accountant}'::public.dodo_role[]));
create policy role_update on public.income_drafts for update to authenticated using (private.has_role(school_id,'{super_admin,admin,accountant}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin,accountant}'::public.dodo_role[]));
create trigger freeze_identity before update on public.income_drafts for each row execute function private.freeze_identity();
create table public.expense_drafts (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  category_id uuid not null,
  description text not null check (length(trim(description)) between 1 and 4000),
  amount numeric(14,2) not null check (amount>0 and amount::text not in ('NaN','Infinity','-Infinity')),
  record_date date not null,
  foreign key(school_id,category_id) references public.expense_categories(school_id,id)
);
create index expense_drafts_school_idx on public.expense_drafts(school_id);
create index expense_drafts_category_id_idx on public.expense_drafts(school_id,category_id);
alter table public.expense_drafts enable row level security;
revoke all on public.expense_drafts from public, anon, authenticated;
grant select,insert,update on public.expense_drafts to authenticated;
create policy role_select on public.expense_drafts for select to authenticated using (private.has_role(school_id,'{super_admin,admin,accountant}'::public.dodo_role[]));
create policy role_insert on public.expense_drafts for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin,accountant}'::public.dodo_role[]));
create policy role_update on public.expense_drafts for update to authenticated using (private.has_role(school_id,'{super_admin,admin,accountant}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin,accountant}'::public.dodo_role[]));
create trigger freeze_identity before update on public.expense_drafts for each row execute function private.freeze_identity();
create table public.staff_attendance (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  staff_id uuid not null,
  record_date date not null,
  status text not null check (status in ('present','absent','late','excused')),
  foreign key(school_id,staff_id) references public.staff(school_id,id),
  unique(school_id,staff_id,record_date)
);
create index staff_attendance_school_idx on public.staff_attendance(school_id);
create index staff_attendance_staff_id_idx on public.staff_attendance(school_id,staff_id);
alter table public.staff_attendance enable row level security;
revoke all on public.staff_attendance from public, anon, authenticated;
grant select,insert,update on public.staff_attendance to authenticated;
create policy role_select on public.staff_attendance for select to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_insert on public.staff_attendance for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_update on public.staff_attendance for update to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create trigger freeze_identity before update on public.staff_attendance for each row execute function private.freeze_identity();
create table public.leave_requests (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  staff_id uuid not null,
  starts_on date not null,
  ends_on date not null,
  description text not null check (length(trim(description)) between 1 and 4000),
  status text not null check (status in ('requested','approved','rejected')),
  foreign key(school_id,staff_id) references public.staff(school_id,id),
  check(ends_on>=starts_on)
);
create index leave_requests_school_idx on public.leave_requests(school_id);
create index leave_requests_staff_id_idx on public.leave_requests(school_id,staff_id);
alter table public.leave_requests enable row level security;
revoke all on public.leave_requests from public, anon, authenticated;
grant select,insert,update on public.leave_requests to authenticated;
create policy role_select on public.leave_requests for select to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_insert on public.leave_requests for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_update on public.leave_requests for update to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create trigger freeze_identity before update on public.leave_requests for each row execute function private.freeze_identity();
create table public.salary_drafts (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  staff_id uuid not null,
  period_start date not null,
  base_amount numeric(14,2) not null check (base_amount>0 and base_amount::text not in ('NaN','Infinity','-Infinity')),
  description text not null check (length(trim(description)) between 1 and 4000),
  foreign key(school_id,staff_id) references public.staff(school_id,id),
  unique(school_id,staff_id,period_start)
);
create index salary_drafts_school_idx on public.salary_drafts(school_id);
create index salary_drafts_staff_id_idx on public.salary_drafts(school_id,staff_id);
alter table public.salary_drafts enable row level security;
revoke all on public.salary_drafts from public, anon, authenticated;
grant select,insert,update on public.salary_drafts to authenticated;
create policy role_select on public.salary_drafts for select to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_insert on public.salary_drafts for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_update on public.salary_drafts for update to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create trigger freeze_identity before update on public.salary_drafts for each row execute function private.freeze_identity();
create table public.teacher_evaluations (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  staff_id uuid not null,
  record_date date not null,
  score integer not null check (score>0),
  description text not null check (length(trim(description)) between 1 and 4000),
  foreign key(school_id,staff_id) references public.staff(school_id,id),
  check(score<=100)
);
create index teacher_evaluations_school_idx on public.teacher_evaluations(school_id);
create index teacher_evaluations_staff_id_idx on public.teacher_evaluations(school_id,staff_id);
alter table public.teacher_evaluations enable row level security;
revoke all on public.teacher_evaluations from public, anon, authenticated;
grant select,insert,update on public.teacher_evaluations to authenticated;
create policy role_select on public.teacher_evaluations for select to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_insert on public.teacher_evaluations for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_update on public.teacher_evaluations for update to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create trigger freeze_identity before update on public.teacher_evaluations for each row execute function private.freeze_identity();
create table public.homework (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  class_id uuid not null,
  title text not null check (length(trim(title)) between 1 and 4000),
  description text not null check (length(trim(description)) between 1 and 4000),
  due_date date not null,
  foreign key(school_id,class_id) references public.classes(school_id,id)
);
create index homework_school_idx on public.homework(school_id);
create index homework_class_id_idx on public.homework(school_id,class_id);
alter table public.homework enable row level security;
revoke all on public.homework from public, anon, authenticated;
grant select,insert,update on public.homework to authenticated;
create policy role_select on public.homework for select to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_insert on public.homework for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_update on public.homework for update to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create trigger freeze_identity before update on public.homework for each row execute function private.freeze_identity();
create table public.live_sessions (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  class_id uuid not null,
  title text not null check (length(trim(title)) between 1 and 4000),
  session_date date not null,
  meeting_url text not null check (length(trim(meeting_url)) between 1 and 4000),
  foreign key(school_id,class_id) references public.classes(school_id,id),
  check(meeting_url ~ '^https://(meet\.google\.com|([a-zA-Z0-9-]+\.)?zoom\.us)/')
);
create index live_sessions_school_idx on public.live_sessions(school_id);
create index live_sessions_class_id_idx on public.live_sessions(school_id,class_id);
alter table public.live_sessions enable row level security;
revoke all on public.live_sessions from public, anon, authenticated;
grant select,insert,update on public.live_sessions to authenticated;
create policy role_select on public.live_sessions for select to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_insert on public.live_sessions for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_update on public.live_sessions for update to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create trigger freeze_identity before update on public.live_sessions for each row execute function private.freeze_identity();
create table public.books (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  title text not null check (length(trim(title)) between 1 and 4000),
  author text not null check (length(trim(author)) between 1 and 4000),
  catalog_no text not null check (length(trim(catalog_no)) between 1 and 4000),
  unique(school_id,catalog_no)
);
create index books_school_idx on public.books(school_id);
alter table public.books enable row level security;
revoke all on public.books from public, anon, authenticated;
grant select,insert,update on public.books to authenticated;
create policy role_select on public.books for select to authenticated using (private.has_role(school_id,'{super_admin,admin,librarian}'::public.dodo_role[]));
create policy role_insert on public.books for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin,librarian}'::public.dodo_role[]));
create policy role_update on public.books for update to authenticated using (private.has_role(school_id,'{super_admin,admin,librarian}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin,librarian}'::public.dodo_role[]));
create trigger freeze_identity before update on public.books for each row execute function private.freeze_identity();
create table public.vehicles (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  plate_no text not null check (length(trim(plate_no)) between 1 and 4000),
  name text not null check (length(trim(name)) between 1 and 4000),
  capacity integer not null check (capacity>0),
  unique(school_id,plate_no)
);
create index vehicles_school_idx on public.vehicles(school_id);
alter table public.vehicles enable row level security;
revoke all on public.vehicles from public, anon, authenticated;
grant select,insert,update on public.vehicles to authenticated;
create policy role_select on public.vehicles for select to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_insert on public.vehicles for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_update on public.vehicles for update to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create trigger freeze_identity before update on public.vehicles for each row execute function private.freeze_identity();
create table public.transport_routes (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  name text not null check (length(trim(name)) between 1 and 4000),
  vehicle_id uuid not null,
  foreign key(school_id,vehicle_id) references public.vehicles(school_id,id)
);
create index transport_routes_school_idx on public.transport_routes(school_id);
create index transport_routes_vehicle_id_idx on public.transport_routes(school_id,vehicle_id);
alter table public.transport_routes enable row level security;
revoke all on public.transport_routes from public, anon, authenticated;
grant select,insert,update on public.transport_routes to authenticated;
create policy role_select on public.transport_routes for select to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_insert on public.transport_routes for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_update on public.transport_routes for update to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create trigger freeze_identity before update on public.transport_routes for each row execute function private.freeze_identity();
create table public.pickup_points (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  route_id uuid not null,
  name text not null check (length(trim(name)) between 1 and 4000),
  position integer not null check (position>0),
  foreign key(school_id,route_id) references public.transport_routes(school_id,id),
  unique(school_id,route_id,position)
);
create index pickup_points_school_idx on public.pickup_points(school_id);
create index pickup_points_route_id_idx on public.pickup_points(school_id,route_id);
alter table public.pickup_points enable row level security;
revoke all on public.pickup_points from public, anon, authenticated;
grant select,insert,update on public.pickup_points to authenticated;
create policy role_select on public.pickup_points for select to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_insert on public.pickup_points for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_update on public.pickup_points for update to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create trigger freeze_identity before update on public.pickup_points for each row execute function private.freeze_identity();
create table public.dorm_rooms (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  name text not null check (length(trim(name)) between 1 and 4000),
  capacity integer not null check (capacity>0),
  unique(school_id,name)
);
create index dorm_rooms_school_idx on public.dorm_rooms(school_id);
alter table public.dorm_rooms enable row level security;
revoke all on public.dorm_rooms from public, anon, authenticated;
grant select,insert,update on public.dorm_rooms to authenticated;
create policy role_select on public.dorm_rooms for select to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_insert on public.dorm_rooms for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_update on public.dorm_rooms for update to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create trigger freeze_identity before update on public.dorm_rooms for each row execute function private.freeze_identity();
create table public.inventory_items (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  name text not null check (length(trim(name)) between 1 and 4000),
  sku text not null check (length(trim(sku)) between 1 and 4000),
  unit text not null check (length(trim(unit)) between 1 and 4000),
  unique(school_id,sku)
);
create index inventory_items_school_idx on public.inventory_items(school_id);
alter table public.inventory_items enable row level security;
revoke all on public.inventory_items from public, anon, authenticated;
grant select,insert,update on public.inventory_items to authenticated;
create policy role_select on public.inventory_items for select to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_insert on public.inventory_items for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_update on public.inventory_items for update to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create trigger freeze_identity before update on public.inventory_items for each row execute function private.freeze_identity();
create table public.announcements (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  title text not null check (length(trim(title)) between 1 and 4000),
  description text not null check (length(trim(description)) between 1 and 4000),
  record_date date not null,
  status text not null check (status in ('draft','published'))
);
create index announcements_school_idx on public.announcements(school_id);
alter table public.announcements enable row level security;
revoke all on public.announcements from public, anon, authenticated;
grant select,insert,update on public.announcements to authenticated;
create policy role_select on public.announcements for select to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_insert on public.announcements for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_update on public.announcements for update to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create trigger freeze_identity before update on public.announcements for each row execute function private.freeze_identity();
create table public.calendar_events (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id),
  created_at timestamptz not null default now(),
  unique(school_id,id),
  title text not null check (length(trim(title)) between 1 and 4000),
  description text not null check (length(trim(description)) between 1 and 4000),
  record_date date not null
);
create index calendar_events_school_idx on public.calendar_events(school_id);
alter table public.calendar_events enable row level security;
revoke all on public.calendar_events from public, anon, authenticated;
grant select,insert,update on public.calendar_events to authenticated;
create policy role_select on public.calendar_events for select to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_insert on public.calendar_events for insert to authenticated with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create policy role_update on public.calendar_events for update to authenticated using (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[])) with check (private.has_role(school_id,'{super_admin,admin}'::public.dodo_role[]));
create trigger freeze_identity before update on public.calendar_events for each row execute function private.freeze_identity();
commit;
