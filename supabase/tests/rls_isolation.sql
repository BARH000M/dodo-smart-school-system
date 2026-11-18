-- DISPOSABLE DODO test project only; execute as postgres/project owner. Creates temporary fixtures inside rollback.
begin;
insert into auth.users(id,aud,role,email) values
 ('10000000-0000-4000-8000-000000000001','authenticated','authenticated','dodo-test-parent@example.invalid'),
 ('10000000-0000-4000-8000-000000000002','authenticated','authenticated','dodo-test-admin@example.invalid');
insert into public.schools(id,name) values ('20000000-0000-4000-8000-000000000001','Test school A'),('20000000-0000-4000-8000-000000000002','Test school B');
insert into public.school_memberships(school_id,user_id,role) values
 ('20000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000001','parent'),
 ('20000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000002','admin');
insert into public.branches(id,school_id,name) values
 ('30000000-0000-4000-8000-000000000001','20000000-0000-4000-8000-000000000001','Test branch A'),
 ('30000000-0000-4000-8000-000000000002','20000000-0000-4000-8000-000000000002','Test branch B');
insert into public.students(id,school_id,branch_id,full_name,student_no) values
 ('40000000-0000-4000-8000-000000000001','20000000-0000-4000-8000-000000000001','30000000-0000-4000-8000-000000000001','Linked student','A1'),
 ('40000000-0000-4000-8000-000000000002','20000000-0000-4000-8000-000000000001','30000000-0000-4000-8000-000000000001','Unlinked student','A2'),
 ('40000000-0000-4000-8000-000000000003','20000000-0000-4000-8000-000000000002','30000000-0000-4000-8000-000000000002','Other school student','B1');
insert into public.student_user_links(school_id,student_id,user_id,link_kind) values ('20000000-0000-4000-8000-000000000001','40000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000001','parent');
insert into public.invoices(id,school_id,student_id,description,amount,currency,due_date) values
 ('50000000-0000-4000-8000-000000000001','20000000-0000-4000-8000-000000000001','40000000-0000-4000-8000-000000000001','Test invoice',100,'YER',current_date),
 ('50000000-0000-4000-8000-000000000002','20000000-0000-4000-8000-000000000001','40000000-0000-4000-8000-000000000002','Hidden invoice',100,'YER',current_date);
set local role authenticated;
select set_config('request.jwt.claim.sub','10000000-0000-4000-8000-000000000001',true);
do $$ begin
 if (select count(*) from public.students where school_id='20000000-0000-4000-8000-000000000001')<>1 then raise exception 'Parent scope failed';end if;
 if (select count(*) from public.fee_balances where school_id='20000000-0000-4000-8000-000000000001')<>1 then raise exception 'Balance scope failed';end if;
 if exists(select 1 from public.students where school_id='20000000-0000-4000-8000-000000000002') then raise exception 'Cross-tenant read';end if;
 begin perform public.create_invoice('20000000-0000-4000-8000-000000000001','40000000-0000-4000-8000-000000000001','Forbidden',100,current_date);raise exception 'Parent invoice write allowed';exception when insufficient_privilege then null;end;
end $$;
select set_config('request.jwt.claim.sub','10000000-0000-4000-8000-000000000002',true);
do $$ declare a uuid;b uuid;begin
 if (select count(*) from public.students where school_id='20000000-0000-4000-8000-000000000001')<>2 then raise exception 'Admin read failed';end if;
 if exists(select 1 from public.students where school_id='20000000-0000-4000-8000-000000000002') then raise exception 'Admin tenant scope failed';end if;
 a:=public.record_payment('20000000-0000-4000-8000-000000000001','50000000-0000-4000-8000-000000000001',30,'60000000-0000-4000-8000-000000000001');
 b:=public.record_payment('20000000-0000-4000-8000-000000000001','50000000-0000-4000-8000-000000000001',30,'60000000-0000-4000-8000-000000000001');
 if a<>b or (select balance from public.fee_balances where id='50000000-0000-4000-8000-000000000001')<>70 then raise exception 'Payment idempotency/balance failed';end if;
end $$;
reset role;
rollback;
