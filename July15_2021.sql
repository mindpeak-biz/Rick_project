select effyear as "year", acq_pstalp as "state", count(*) as number_of_events  
from public.events 
group by effyear, acq_pstalp 
order by effyear, acq_pstalp 

select effyear as "year", acq_pstalp as "state", acq_pcity as city, count(*) as number_of_events  
from public.events 
group by effyear, acq_pstalp, acq_pcity 
order by effyear, acq_pstalp, acq_pcity 

select effyear as "year", acq_pzip5 as zip_code, count(*) as number_of_events  
from public.events 
group by effyear, acq_pzip5 
order by effyear, acq_pzip5  

select effyear as "year", count(*) as number_of_events  
from public.events 
group by effyear 
order by effyear  

select activity_year as "year", sum(number_of_loans) as number_of_loans, sum(sum_of_mtgs) as value_of_loans         
from public.hmda_transmittal_2010_2020 
group by activity_year 
order by activity_year  

-- ------------------------------------------
-- lender_id 24465 in the hmda_transmittal_2017 table creates NaN for sum_of_mtgs 
select * from public.hmda_transmittal_2017 where lender_id = '24465'
select avg(loan_amount_in_000s) 
-- lender_id 24465 in the hmda table creates only has NaN for loan_amount_in_000s for all 113 of it's loans 
select * from hmda where cleasnsed_lender_id = '24465' and year = '2017' 
select count(*) from public.hmda_transmittal_2017 where sum_of_mtgs = 'NaN'

-- here are the lender ids in 2017 that have NaN values for loan_amount_in_000s
select count(*) as "NaN loans", 
cleasnsed_lender_id from public.hmda where year = '2017' and loan_amount_in_000s = 'NaN' 
  group by cleasnsed_lender_id
  
-- Manually see if all the reported loans for a specific lender are NaN  
select count(*) from  public.hmda where cleasnsed_lender_id = '47-3619422' and year = '2016' 
select count(*) as "NaN loans" from public.hmda where cleasnsed_lender_id = '47-3619422' and year = '2018' and loan_amount_in_000s = 'NaN' 


-- ------------------------------------------

select foo.event_year, foo.number_of_events, bar.number_of_loans, bar.value_of_loans   
from 
(select effyear as "event_year", count(*) as number_of_events  
from public.events 
group by effyear 
order by effyear) as foo   
join 
(select activity_year as "hmda_year", sum(number_of_loans) as number_of_loans, sum(sum_of_mtgs) as value_of_loans       
from public.hmda_transmittal_2010_2020 
group by activity_year 
order by activity_year) as bar on foo.event_year = bar.hmda_year
order by foo.event_year

REFRESH MATERIALIZED VIEW public.hmda_transmittal_2010_2020
REFRESH MATERIALIZED VIEW public.hmda_transmittal_2017

select respondent_zip_code, respondent_city, respondent_state 
from public.hmda_transmittal_2010_2020 
where length(respondent_zip_code) < 5 
group by respondent_zip_code, respondent_city, respondent_state
order by respondent_zip_code, respondent_city, respondent_state

update events set SUR_MZIP5 = LPAD(SUR_MZIP5, 5, '0') where length(SUR_MZIP5) < 5; 
update public.transmittal_sheet set respondent_zip_code = LPAD(respondent_zip_code, 5, '0') 
       where length(respondent_zip_code) < 5; 





