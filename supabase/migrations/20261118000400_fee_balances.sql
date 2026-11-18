begin;
create view public.fee_balances with (security_invoker=true) as
select i.id,i.school_id,i.student_id,i.description,i.currency,i.due_date,i.amount,
 coalesce(sum(p.amount),0)::numeric(14,2) as paid,
 (i.amount-coalesce(sum(p.amount),0))::numeric(14,2) as balance
from public.invoices i left join public.payments p on p.school_id=i.school_id and p.invoice_id=i.id
group by i.id,i.school_id,i.student_id,i.description,i.currency,i.due_date,i.amount;
revoke all on public.fee_balances from public,anon,authenticated;
grant select on public.fee_balances to authenticated;
commit;
