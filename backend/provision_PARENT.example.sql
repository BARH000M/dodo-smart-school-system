-- Trusted operator only. Verify relationship, identity and school before running.
begin;
insert into public.school_memberships(school_id,user_id,role) values ('SCHOOL_UUID'::uuid,'AUTH_USER_UUID'::uuid,'parent') on conflict do nothing;
insert into public.student_user_links(school_id,student_id,user_id,link_kind) values ('SCHOOL_UUID'::uuid,'STUDENT_UUID'::uuid,'AUTH_USER_UUID'::uuid,'parent');
commit;
