

select count(*) from public.transmittal_sheet;
select count(*) from public.hmda;
select count(*) from public.events;

-- indexes for transmittal_sheet
CREATE INDEX ts_activity_year ON transmittal_sheet (activity_year);
CREATE INDEX ts_tax_id ON transmittal_sheet (tax_id);
CREATE INDEX ts_respondent_id ON transmittal_sheet (respondent_id);
CREATE INDEX ts_agency_code ON transmittal_sheet (agency_code);
CREATE INDEX ts_respondent_name ON transmittal_sheet (respondent_name);
CREATE INDEX ts_respondent_city ON transmittal_sheet (respondent_city);
CREATE INDEX ts_respondent_state ON transmittal_sheet (respondent_state);
CREATE INDEX ts_respondent_zip_code ON transmittal_sheet (respondent_zip_code);

-- indexes for hmda
CREATE INDEX idx_hmda_year ON hmda (year);
CREATE INDEX idx_hmda_lender_id ON hmda (lender_id);
CREATE INDEX idx_hmda_loan_type ON hmda (loan_type);
CREATE INDEX idx_hmda_property_type ON hmda (property_type);
CREATE INDEX idx_hmda_loan_amount_in_000s ON hmda (loan_amount_in_000s);
CREATE INDEX idx_hmda_agency_code ON hmda (agency_code);

-- indexes for events
CREATE INDEX idx_events_acq_instname ON events (acq_instname);
CREATE INDEX idx_events_acq_pcity ON events (acq_pcity);
CREATE INDEX idx_events_acq_pstalp ON events (acq_pstalp);
CREATE INDEX idx_events_acq_pzip5 ON events (acq_pzip5);
CREATE INDEX idx_events_acq_org_eff_dte ON events (acq_org_eff_dte);
CREATE INDEX idx_events_out_instname ON events (out_instname);
CREATE INDEX idx_events_out_pcity ON events (out_pcity);
CREATE INDEX idx_events_out_pstalp ON events (out_pstalp);
CREATE INDEX idx_events_out_pzip5 ON events (out_pzip5);
CREATE INDEX idx_events_sur_instname ON events (sur_instname);
CREATE INDEX idx_events_sur_pcity ON events (sur_pcity);
CREATE INDEX idx_events_sur_pstalp ON events (sur_pstalp);
CREATE INDEX idx_events_sur_pzip5 ON events (sur_pzip5);


-- set up a materialized view for each year (where the view joins the 3 main tables:
-- transmittal_sheet, hmda, and events)

select * from hmda where lender_id = '0000000001' limit 1;
select * from public.transmittal_sheet where respondent_id = '0000000001' limit 1;

CREATE MATERIALIZED VIEW hmda_ts_2011 
AS
	select h.year, h.lender_id, h.loan_type, h.property_type, h.loan_amount_in_000s, h.agency_code, 
	ts.tax_id, ts.respondent_name, ts.respondent_mailing_address, ts.respondent_city, 
	ts.respondent_state, ts.respondent_zip_code, ts.parent_name, ts.parent_address, ts.parent_city, 
	ts.parent_state, ts.parent_zip_code, ts.respondent_name_panel, ts.respondent_city_panel,  
	ts.respondent_state_panel, ts.lar_count  
	from transmittal_sheet ts
	right join hmda h on ts.activity_year = h.year 
	            and ts.respondent_id = h.lender_id 
				and ts.agency_code = h.agency_code    
	where h.year = '2011' 
WITH DATA;


select count(*), avg(loan_amount_in_000s), sum(loan_amount_in_000s) --, respondent_name  
from hmda_ts_2010 
group by respondent_name 

select sum(loan_amount_in_000s) -- respondent_name  
from hmda_ts_2010 
--limit 10;

-- -----------------------------------------------------------------------
select count(*) from public.hmda;  -- 84.77 million

select count(*) from public.hmda where year = '2010';  -- 6.76 million
select count(*) from hmda_ts_2010;  -- 2.1 million


select count(*) as mtg_count, lender_id 
from hmda  
where year = '2010' 
group by lender_id 
order by mtg_count desc;


select respondent_name from public.hmda_ts_2012 where lender_id = '0000000001';

select * from public.hmda_ts_2010 where lender_id

select distinct lender_id from hmda where year = '2010'; -- 7,231
select distinct lender_id from hmda_ts_2010 where year = '2010'; -- 1,110

select distinct year from hmda_ts_2010; -- 2010
select distinct year from hmda_ts_2011; -- 2011


select * from hmda_ts_2010 limit 1;

select * from hmda_ts_2010 
where lender_id = '0000000001' limit 1;

-- Acquirer
select v11.lender_id, e.acq_instname, v11.respondent_name, e.acq_pcity, e.acq_pstalp, e.acq_pzip5 
from events e 
join hmda_ts_2011 v11 on e.acq_instname = v11.respondent_name  -- e.acq_pcity = v11.respondent_city -- 
					  -- and e.acq_pcity = v11.respondent_city 
					  --and e.acq_pstalp = v11.respondent_state
					  --and e.acq_pzip5 = v11.respondent_zip_code 
limit 10;	

-- target
select v11.lender_id, e.out_instname, v11.respondent_name, e.acq_pcity, e.acq_pstalp, e.acq_pzip5 
from events e 
join hmda_ts_2011 v11 on e.acq_instname = v11.respondent_name  -- e.acq_pcity = v11.respondent_city -- 
					  -- and e.acq_pcity = v11.respondent_city 
					  --and e.acq_pstalp = v11.respondent_state
					  --and e.acq_pzip5 = v11.respondent_zip_code 
limit 10;

-- survivor
select v11.lender_id, e.acq_instname, v11.respondent_name, e.acq_pcity, e.acq_pstalp, e.acq_pzip5 
from events e 
join hmda_ts_2011 v11 on upper(e.acq_instname) = upper(v11.respondent_name)  -- e.acq_pcity = v11.respondent_city -- 
					  --and upper(e.acq_pcity) = upper(v11.respondent_city) 
					  --and upper(e.acq_pstalp) = upper(v11.respondent_state)
					  and e.acq_pzip5 = v11.respondent_zip_code  
order by e.acq_instname;


select effyear, acq_instname from public.events 
group by effyear, acq_instname 
order by effyear asc, acq_instname asc 

select effyear, out_instname from public.events 
group by effyear, out_instname 
order by effyear asc, out_instname asc 

select effyear, sur_instname from public.events 
group by effyear, sur_instname 
order by effyear asc, sur_instname asc 

select effyear, acq_instname, out_instname, sur_instname   from public.events 
group by effyear, sur_instname, acq_instname, out_instname 
order by effyear asc, sur_instname, acq_instname, out_instname 


-- Events table
select effyear, institution from 
(select effyear, acq_instname as institution from public.events 
group by effyear, acq_instname 
order by effyear asc, acq_instname asc) as set1  
UNION 
select effyear, institution from 
(select effyear, out_instname as institution from public.events 
group by effyear, out_instname 
order by effyear asc, out_instname asc) as set2 
UNION 
select effyear, institution from 
(select effyear, sur_instname as institution from public.events 
group by effyear, sur_instname 
order by effyear asc, sur_instname asc) as set3 



select count(*) from 
(select count(*), respondent_name from hmda_ts_2011  
group by respondent_name 
order by respondent_name asc) as foobar ;  -- 1,039








select count(*) from  
(select distinct lender_id from public.hmda where year = '2011') as foobar -- 7,047



Aliant Bank

where respondent_name = 'Abington Savings Bank'; 


proc smoosh(inst_name) ... pulls out middle part name
					  


select distinct lender_id from hmda_ts_2010 where respondent_name is null; -- 6,121 
select distinct lender_id from hmda_ts_2011 where respondent_name is null; -- 0
select distinct lender_id from hmda_ts_2012 where respondent_name is null; -- 0
select distinct lender_id from hmda_ts_2013 where respondent_name is null; -- 0 
select distinct lender_id from hmda_ts_2014 where respondent_name is null; -- 0
select distinct lender_id from hmda_ts_2015 where respondent_name is null; -- 0
select distinct lender_id from hmda_ts_2016 where respondent_name is null; -- 0
select distinct lender_id from hmda_ts_2017 where respondent_name is null; -- 0
select distinct lender_id from hmda_ts_2018 where respondent_name is null; -- 0
select distinct lender_id from hmda_ts_2019 where respondent_name is null; -- 0


--delete from public.transmittal_sheet where activity_year = '2010';	

select distinct activity_year from transmittal_sheet

select respondent_name, sum(loan_amount_in_000s) 
from public.hmda_ts_2010 
group by respondent_name 
order by respondent_name;



