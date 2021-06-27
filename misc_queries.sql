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