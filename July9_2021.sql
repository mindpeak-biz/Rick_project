
select foo.lender as ts_lender, bar.lender as acquirer, foo.zip 
from 
(select respondent_name as lender, --, tax_id, 
       respondent_zip_code as zip 
from public.hmda_ts_2011 
group by respondent_zip_code, respondent_name 
order by respondent_zip_code, respondent_name) as foo 

join 

(select acq_instname as lender, acq_pzip5 as zip from 
public.events
where effyear = '2011'  
group by acq_pzip5, acq_instname 
order by acq_pzip5, acq_instname) as bar 

on foo.zip = bar.zip; 


select distinct respondent_name from public.hmda_ts_2011 where respondent_zip_code = '29201';
select distinct acq_instname from public.events where acq_pzip5 = '29201';


select acq_instname from public.events where acq_instname like '%Farg%'; 

select respondent_name, lender_id 
from hmda_ts_2017 
where respondent_name like 'WELLS%'  
group by respondent_name, lender_id 
order by respondent_name desc; 
--where upper(respondent_name) like '%Wells%'; 


-- -----------------------
Wells Fargo lender ids:
KB1H1DSPRFMYMCUFXT09
451965
-- -----------------------

select count(*), year 
from public.hmda 
where lender_id = '0000451965'  
group by year 
order by year desc;


select count(*), activity_year 
from public.transmittal_sheet
where respondent_id = '451965'  
group by activity_year 
order by activity_year desc;



select count(*) as mtg_originations, sum(h.loan_amount_in_000s), h.lender_id, ts.respondent_name, h.year 
from public.hmda h
join public.transmittal_sheet ts on replace(h.lender_id, '0', '') = ts.respondent_id 
group by year, lender_id, respondent_name, year 
where year not in ('2018','2019') 
and ts.respondent_id = '451965' 
order by year desc, respondent_name desc; 


select count(*), activity_year from transmittal_sheet where respondent_id = '451965' 
group by activity_year; 


select count(*), year from public.hmda where lender_id = '0000451965' 
group by year; 



select * from public.transmittal_sheet limit 1000;


select lender_id 
from hmda  
where upper(respondent_name) like '%Wells Fargo Bank%'; 


select activity_year, respondent_name, respondent_id  
from public.transmittal_sheet
where upper(respondent_name) like 'WELLS%' 
group by activity_year, respondent_name, respondent_id 
order by activity_year desc, respondent_name desc; 



CREATE MATERIALIZED VIEW public.hmda_ts_2012 AS 

 SELECT h.year,
    h.lender_id,
    h.loan_type,
    h.property_type,
    h.loan_amount_in_000s,
    h.agency_code,
    ts.tax_id,
    ts.respondent_name,
    ts.respondent_mailing_address,
    ts.respondent_city,
    ts.respondent_state,
    ts.respondent_zip_code,
    ts.parent_name,
    ts.parent_address,
    ts.parent_city,
    ts.parent_state,
    ts.parent_zip_code,
    ts.respondent_name_panel,
    ts.respondent_city_panel,
    ts.respondent_state_panel,
    ts.lar_count
   FROM transmittal_sheet ts
     JOIN hmda h ON ts.activity_year::bpchar = h.year AND ts.respondent_id::text = h.lender_id::text 
  WHERE h.year = '2012'::bpchar;














