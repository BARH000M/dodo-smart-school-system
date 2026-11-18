-- DODO only. Apply exclusively to a NEW, authorized DODO Supabase project.
-- Pilot: school-level scope; branch-level staff isolation, teacher assignment and parent linking are next-stage gates.
begin;
create schema if not exists private;
revoke all on schema private from public;
grant usage on schema private to authenticated;
create type public.dodo_role as enum ('super_admin','admin','teacher','accountant','receptionist','librarian','student','parent','content_editor');
create table public.schools (id uuid primary key default gen_random_uuid(), name text not null check (length(trim(name))>0), currency text not null default 'YER' check (currency ~ '^[A-Z]{3}$'), created_at timestamptz not null default now());
create table public.school_memberships (school_id uuid not null references public.schools(id), user_id uuid not null references auth.users(id), role public.dodo_role not null, active boolean not null default true, primary key(school_id,user_id,role));
create index school_memberships_user_idx on public.school_memberships(user_id,school_id) where active;
create function private.has_role(p_school uuid,p_roles public.dodo_role[]) returns boolean language sql stable security definer set search_path='' as $$ select exists(select 1 from public.school_memberships m where m.school_id=p_school and m.user_id=(select auth.uid()) and m.active and m.role=any(p_roles)); $$;
revoke all on function private.has_role(uuid,public.dodo_role[]) from public;
grant execute on function private.has_role(uuid,public.dodo_role[]) to authenticated;
create function private.is_member(p_school uuid) returns boolean language sql stable security definer set search_path='' as $$ select exists(select 1 from public.school_memberships m where m.school_id=p_school and m.user_id=(select auth.uid()) and m.active); $$;
revoke all on function private.is_member(uuid) from public;
grant execute on function private.is_member(uuid) to authenticated;
create table public.branches (id uuid primary key default gen_random_uuid(), school_id uuid not null references public.schools(id), name text not null check(length(trim(name))>0), unique(school_id,id), unique(school_id,name));
create table public.classes (id uuid primary key default gen_random_uuid(), school_id uuid not null references public.schools(id), branch_id uuid not null, name text not null check(length(trim(name))>0), academic_year text not null, unique(school_id,id), foreign key(school_id,branch_id) references public.branches(school_id,id));
create table public.students (id uuid primary key default gen_random_uuid(), school_id uuid not null references public.schools(id), full_name text not null check(length(trim(full_name))>0), student_no text not null, branch_id uuid not null, unique(school_id,id), unique(school_id,student_no), foreign key(school_id,branch_id) references public.branches(school_id,id));
create table public.admissions (id uuid primary key default gen_random_uuid(), school_id uuid not null references public.schools(id), applicant_name text not null check(length(trim(applicant_name))>0), branch_id uuid not null, status text not null default 'new' check(status in ('new','review','accepted','rejected')), unique(school_id,id), foreign key(school_id,branch_id) references public.branches(school_id,id));
create table public.staff (id uuid primary key default gen_random_uuid(), school_id uuid not null references public.schools(id), full_name text not null check(length(trim(full_name))>0), job_title text not null, branch_id uuid not null, unique(school_id,id), foreign key(school_id,branch_id) references public.branches(school_id,id));
create table public.courses (id uuid primary key default gen_random_uuid(), school_id uuid not null references public.schools(id), title text not null check(length(trim(title))>0), description text not null default '', unique(school_id,id));
create table public.lessons (id uuid primary key default gen_random_uuid(), school_id uuid not null references public.schools(id), course_id uuid not null, title text not null check(length(trim(title))>0), body text not null default '', position integer not null check(position>0), unique(school_id,id), unique(school_id,course_id,position), foreign key(school_id,course_id) references public.courses(school_id,id));
create table public.enrollments (id uuid primary key default gen_random_uuid(), school_id uuid not null references public.schools(id), student_id uuid not null, class_id uuid not null, unique(school_id,id), unique(school_id,student_id,class_id), foreign key(school_id,student_id) references public.students(school_id,id), foreign key(school_id,class_id) references public.classes(school_id,id));
create table public.attendance (id uuid primary key default gen_random_uuid(), school_id uuid not null references public.schools(id), enrollment_id uuid not null, attendance_date date not null, status text not null check(status in ('present','absent','late','excused')), unique(school_id,id), unique(school_id,enrollment_id,attendance_date), foreign key(school_id,enrollment_id) references public.enrollments(school_id,id));
create table public.invoices (id uuid primary key default gen_random_uuid(), school_id uuid not null references public.schools(id), student_id uuid not null, description text not null check(length(trim(description))>0), amount numeric(14,2) not null check(amount>0 and amount<>'NaN'::numeric), currency text not null check(currency ~ '^[A-Z]{3}$'), due_date date not null, created_at timestamptz not null default now(), unique(school_id,id), foreign key(school_id,student_id) references public.students(school_id,id));
create table public.payments (id uuid primary key default gen_random_uuid(), school_id uuid not null references public.schools(id), invoice_id uuid not null, amount numeric(14,2) not null check(amount>0 and amount<>'NaN'::numeric), request_id uuid not null, recorded_by uuid not null references auth.users(id), created_at timestamptz not null default now(), unique(school_id,request_id), foreign key(school_id,invoice_id) references public.invoices(school_id,id));
create index payments_invoice_idx on public.payments(school_id,invoice_id);
-- Explicit grants, no anonymous reads or client role assignment. No client deletes.
do $$ declare t text; begin foreach t in array array['schools','school_memberships','branches','classes','students','admissions','staff','courses','lessons','enrollments','attendance','invoices','payments'] loop execute format('alter table public.%I enable row level security',t); execute format('revoke all on public.%I from anon, authenticated, public',t); execute format('grant select on public.%I to authenticated',t); end loop; end $$;
create policy schools_read on public.schools for select to authenticated using (private.is_member(id));
create policy membership_self on public.school_memberships for select to authenticated using (user_id=(select auth.uid()) and active);
-- Same-school administrative operations only; role-specific grants below.
do $$ declare t text; roles text; read_roles text; begin
 for t,roles,read_roles in select * from (values
 ('branches','super_admin,admin','super_admin,admin,receptionist,accountant'),
 ('classes','super_admin,admin','super_admin,admin,receptionist'),
 ('students','super_admin,admin,receptionist','super_admin,admin,receptionist,accountant'),
 ('admissions','super_admin,admin,receptionist','super_admin,admin,receptionist'),
 ('staff','super_admin,admin','super_admin,admin'),
 ('courses','super_admin,admin,content_editor','super_admin,admin,content_editor'),
 ('lessons','super_admin,admin,content_editor','super_admin,admin,content_editor'),
 ('enrollments','super_admin,admin,receptionist','super_admin,admin,receptionist'),
 ('attendance','super_admin,admin','super_admin,admin'),
 ('invoices','super_admin,admin,accountant','super_admin,admin,accountant'),
 ('payments','','super_admin,admin,accountant')) as x(t,w,r) loop
 execute format('create policy role_read on public.%I for select to authenticated using (private.has_role(school_id,%L::public.dodo_role[]))',t,'{'||read_roles||'}');
 if t not in ('payments','invoices') then
 execute format('grant insert,update on public.%I to authenticated',t);
 execute format('create policy role_insert on public.%I for insert to authenticated with check (private.has_role(school_id,%L::public.dodo_role[]))',t,'{'||roles||'}');
 execute format('create policy role_update on public.%I for update to authenticated using (private.has_role(school_id,%L::public.dodo_role[])) with check (private.has_role(school_id,%L::public.dodo_role[]))',t,'{'||roles||'}','{'||roles||'}');
 end if;
 end loop;
end $$;
-- Prevent changing row identity or tenant in updates (even for users belonging to both schools).
create function private.freeze_identity() returns trigger language plpgsql set search_path='' as $$ begin if new.id is distinct from old.id or new.school_id is distinct from old.school_id then raise exception 'Row identity is immutable'; end if; return new; end $$;
do $$ declare t text; begin foreach t in array array['branches','classes','students','admissions','staff','courses','lessons','enrollments','attendance'] loop execute format('create trigger freeze_identity before update on public.%I for each row execute function private.freeze_identity()', t); end loop; end $$;
-- Fee collection pilot. No edits/deletes; full double-entry ledger and reversals are future requirements.
create function public.create_invoice(p_school uuid,p_student uuid,p_description text,p_amount numeric,p_due_date date) returns uuid language plpgsql security definer set search_path='' as $$ declare v_id uuid; v_currency text; begin
 if not private.has_role(p_school,array['super_admin','admin','accountant']::public.dodo_role[]) then raise exception 'Forbidden' using errcode='42501'; end if;
 if p_amount is null or p_amount::text in ('NaN','Infinity','-Infinity') or p_amount<=0 or p_amount<>round(p_amount,2) then raise exception 'Invalid amount'; end if;
 select currency into strict v_currency from public.schools where id=p_school;
 insert into public.invoices(school_id,student_id,description,amount,currency,due_date) values(p_school,p_student,p_description,p_amount,v_currency,p_due_date) returning id into v_id; return v_id; end $$;
create function public.record_payment(p_school uuid,p_invoice uuid,p_amount numeric,p_request uuid) returns uuid language plpgsql security definer set search_path='' as $$ declare v_invoice public.invoices%rowtype; v_existing public.payments%rowtype; v_paid numeric; v_id uuid; begin
 if not private.has_role(p_school,array['super_admin','admin','accountant']::public.dodo_role[]) then raise exception 'Forbidden' using errcode='42501'; end if;
 if p_amount is null or p_amount::text in ('NaN','Infinity','-Infinity') or p_amount<=0 or p_amount<>round(p_amount,2) or p_request is null then raise exception 'Invalid payment'; end if;
 -- Serialize duplicate request IDs across invoices, then serialize all payments on an invoice.
 perform pg_advisory_xact_lock(hashtextextended(p_school::text||':'||p_request::text,0));
 select * into v_existing from public.payments where school_id=p_school and request_id=p_request;
 if found then if v_existing.invoice_id<>p_invoice or v_existing.amount<>p_amount then raise exception 'Request ID payload mismatch'; end if; return v_existing.id; end if;
 select * into v_invoice from public.invoices where school_id=p_school and id=p_invoice for update;
 if not found then raise exception 'Invoice unavailable'; end if;
 select coalesce(sum(amount),0) into v_paid from public.payments where school_id=p_school and invoice_id=p_invoice;
 if v_paid+p_amount>v_invoice.amount then raise exception 'Payment exceeds balance'; end if;
 insert into public.payments(school_id,invoice_id,amount,request_id,recorded_by) values(p_school,p_invoice,p_amount,p_request,auth.uid()) returning id into v_id; return v_id; end $$;
revoke all on function public.create_invoice(uuid,uuid,text,numeric,date) from public,anon,authenticated;
revoke all on function public.record_payment(uuid,uuid,numeric,uuid) from public,anon,authenticated;
grant execute on function public.create_invoice(uuid,uuid,text,numeric,date) to authenticated;
grant execute on function public.record_payment(uuid,uuid,numeric,uuid) to authenticated;
commit;
