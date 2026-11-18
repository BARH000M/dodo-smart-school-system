-- Run only after approved migration on NEW DODO project. Create Auth user first.
-- Replace AUTH_USER_UUID and school name deliberately; never run unedited.
begin;
with new_school as (insert into public.schools(name,currency) values ('REPLACE SCHOOL NAME','YER') returning id)
insert into public.school_memberships(school_id,user_id,role) select id,'AUTH_USER_UUID'::uuid,'super_admin'::public.dodo_role from new_school;
commit;
