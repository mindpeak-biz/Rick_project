

select max(foo.count) from 
(
select count(*), acq_pzip5 from public.events -- where effyear = '2011' 
group by acq_pzip5 
order by acq_pzip5 asc
) as foo;


select ts.activity_year, count(*) as number_of_loans, h.lender_id, ts.respondent_name as institution_name, sum(h.loan_amount_in_000s),  
       ts.respondent_city, ts.respondent_state, ts.respondent_zip_code 
from transmittal_sheet ts 
join hmda h on h.cleasnsed_lender_id = ts.cleasnsed_lender_id 
group by ts.activity_year, h.lender_id, ts.respondent_name, ts.respondent_city, ts.respondent_state, ts.respondent_zip_code 
order by ts.activity_year asc, ts.respondent_name asc;


select * from public.hmda limit 1000;
select * from public.transmittal_sheet limit 1000;