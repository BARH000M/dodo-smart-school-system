-- Trusted school owner provisions student and parent links; no public self-linking.
begin;
create table public.student_user_links (
 school_id uuid not null, student_id uuid not null, user_id uuid not null references auth.users(id),
 link_kind text not null check(link_kind in ('student','parent')),
 primary key(school_id,student_id,user_id,link_kind),
 foreign key(school_id,student_id) references public.students(school_id,id));
create unique index one_student_identity on public.student_user_links(school_id,user_id) where link_kind='student';
create index student_user_links_actor on public.student_user_links(user_id,school_id);
alter table public.student_user_links enable row level security;
revoke all on public.student_user_links from public,anon,authenticated;
create function private.can_view_student(p_school uuid,p_student uuid) returns boolean
language sql stable security definer set search_path='' as $$
 select exists(select 1 from public.student_user_links l join public.school_memberships m
 on m.school_id=l.school_id and m.user_id=l.user_id and m.role::text=l.link_kind and m.active
 where l.school_id=p_school and l.student_id=p_student and l.user_id=(select auth.uid()));
$$;
create function private.can_view_enrollment(p_school uuid,p_enrollment uuid) returns boolean
language sql stable security definer set search_path='' as $$
 select exists(select 1 from public.enrollments e where e.school_id=p_school and e.id=p_enrollment and private.can_view_student(p_school,e.student_id));
$$;
create function private.can_view_class(p_school uuid,p_class uuid) returns boolean
language sql stable security definer set search_path='' as $$
 select exists(select 1 from public.enrollments e where e.school_id=p_school and e.class_id=p_class and private.can_view_student(p_school,e.student_id));
$$;
create function private.can_view_invoice(p_school uuid,p_invoice uuid) returns boolean
language sql stable security definer set search_path='' as $$
 select exists(select 1 from public.invoices i where i.school_id=p_school and i.id=p_invoice and private.can_view_student(p_school,i.student_id));
$$;
revoke all on function private.can_view_student(uuid,uuid),private.can_view_enrollment(uuid,uuid),private.can_view_class(uuid,uuid),private.can_view_invoice(uuid,uuid) from public;
grant execute on function private.can_view_student(uuid,uuid),private.can_view_enrollment(uuid,uuid),private.can_view_class(uuid,uuid),private.can_view_invoice(uuid,uuid) to authenticated;
create policy linked_student_read on public.students for select to authenticated using(private.can_view_student(school_id,id));
create policy linked_enrollment_read on public.enrollments for select to authenticated using(private.can_view_student(school_id,student_id));
create policy linked_class_read on public.classes for select to authenticated using(private.can_view_class(school_id,id));
create policy linked_attendance_read on public.attendance for select to authenticated using(private.can_view_enrollment(school_id,enrollment_id));
create policy linked_homework_read on public.homework for select to authenticated using(private.can_view_class(school_id,class_id));
create policy linked_invoice_read on public.invoices for select to authenticated using(private.can_view_student(school_id,student_id));
create policy linked_payment_read on public.payments for select to authenticated using(private.can_view_invoice(school_id,invoice_id));
-- A member can see published school-wide announcements only.
create policy published_announcements on public.announcements for select to authenticated using(status='published' and private.is_member(school_id));
commit;
