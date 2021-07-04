-- This file contains miscellaneous queries

delete from public.hmda;


select count(*) from public.hmda;


select * from public.hmda;


select count(*), respondent_id from hmda 
    group by respondent_id;


select respondent_id from
(select count(*) as amt_of_mtgs, sum(loan_amount_000s), respondent_id from hmda 
group by respondent_id) foo 
where foo.amt_of_mtgs > 1;


select amt_of_mtgs, 
       respondent_id, 
       total_dollars_lent, 
       (total_dollars_lent / amt_of_mtgs) as average_mortgage_amount 
from
(select count(*) as amt_of_mtgs, sum(loan_amount_000s) as total_dollars_lent, respondent_id 
from hmda 
group by respondent_id) foo 
order by foo.amt_of_mtgs desc; 



-- July 4th


select ts.activity_year, ts.agency_code, ac.description, 
ts.respondent_id, ts.respondent_name, sum(h.loan_amount_in_000s)  
from public.transmittal_sheet ts 

join hmda h on h.lender_id = ts.respondent_id  
join agency_code ac on ts.agency_code::int = ac.code  
join events e on e.acq_instname = ts.respondent_name 

--where ts.respondent_name like '%PNC%' 
and ts.activity_year = '2019'

group by ts.activity_year, ts.respondent_name, ts.agency_code, 
      ac.description, ts.respondent_id     
order by ts.activity_year, ts.respondent_name;
