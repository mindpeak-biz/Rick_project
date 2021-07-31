CREATE MATERIALIZED VIEW hmda_transmittal_2020
AS
select ts.activity_year, ts.cleasnsed_lender_id lender_id, ts.respondent_name lender_name, 
       ts.respondent_city, ts.respondent_state, ts.respondent_zip_code, 
	   count(*) number_of_loans, sum(h.loan_amount_in_000s) sum_of_mtgs   
from transmittal_sheet ts 
join hmda h on h.cleasnsed_lender_id = ts.cleasnsed_lender_id and h.year = ts.activity_year 
where ts.activity_year = '2020' 
group by ts.activity_year, ts.cleasnsed_lender_id, ts.respondent_name, 
         ts.respondent_city, ts.respondent_state, ts.respondent_zip_code 
order by ts.activity_year asc, ts.respondent_name asc 
WITH  DATA;


select count(*) from public.transmittal_sheet where activity_year = '2010';
select count(*) from public.hmda where year = '2010';

update public.hmda set loan_amount_in_000s = (loan_amount_in_000s/1000)  where year = '2020';
select loan_amount_in_000s from public.hmda where year = '2020' limit 100;


select max(effyear) from public.events limit 1; 
select count(*) from public.events; 
select count(*) from public.transmittal_sheet where activity_year = '2020'; 

-- Run these for 2012 - 2019 (2014 was already done)
CREATE INDEX idx_hmda_transmittal_2019_lender_name ON hmda_transmittal_2019(lender_name);
CREATE INDEX idx_hmda_transmittal_2019_activity_year ON hmda_transmittal_2019(activity_year);
CREATE INDEX idx_hmda_transmittal_2019_city ON hmda_transmittal_2019(respondent_city);
CREATE INDEX idx_hmda_transmittal_2019_state ON hmda_transmittal_2019(respondent_state);
CREATE INDEX idx_hmda_transmittal_2019_zip ON hmda_transmittal_2019(respondent_zip_code);

select count(*) from public.hmda where year = '2020';