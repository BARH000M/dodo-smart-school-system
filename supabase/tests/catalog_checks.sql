-- Run against a disposable DODO test database AFTER applying migration. No writes.
do $$ declare t text; begin
 foreach t in array array['schools','school_memberships','student_user_links','branches','classes','students','admissions','staff','courses','lessons','enrollments','attendance','invoices','payments','visit_purposes','visitors','phone_calls','postal_records','complaints','student_categories','student_houses','disable_reasons','academic_years','subjects','teaching_assignments','timetable_entries','lesson_plans','exam_groups','exams','exam_schedules','fee_types','fee_groups','income_categories','expense_categories','banks','income_drafts','expense_drafts','staff_attendance','leave_requests','salary_drafts','teacher_evaluations','homework','live_sessions','books','vehicles','transport_routes','pickup_points','dorm_rooms','inventory_items','announcements','calendar_events'] loop
  if not exists(select 1 from pg_class c join pg_namespace n on n.oid=c.relnamespace where n.nspname='public' and c.relname=t and c.relrowsecurity) then raise exception 'RLS missing: %',t; end if;
  if has_table_privilege('anon',format('public.%I',t),'SELECT') then raise exception 'Anonymous read: %',t; end if;
  if has_table_privilege('authenticated',format('public.%I',t),'DELETE') then raise exception 'Client delete: %',t; end if;
 end loop;
 if has_table_privilege('authenticated','public.payments','INSERT,UPDATE') then raise exception 'Direct payment write'; end if;
 if has_table_privilege('authenticated','public.school_memberships','INSERT,UPDATE') then raise exception 'Direct role assignment'; end if;
 if has_function_privilege('anon','public.record_payment(uuid,uuid,numeric,uuid)','EXECUTE') then raise exception 'Anonymous payments RPC'; end if;
 if has_table_privilege('authenticated','public.student_user_links','INSERT,UPDATE') then raise exception 'Direct student links'; end if;
 if has_table_privilege('anon','public.fee_balances','SELECT') then raise exception 'Anonymous fee balances'; end if;
end $$;
