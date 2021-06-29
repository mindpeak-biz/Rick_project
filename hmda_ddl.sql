-- here are the columns that we want to store:
-- 0 activity_year
-- 1 lei
-- 8 derived_dwelling_category
-- 15 loan_type
-- 21 loan_amount
-- 40 occupancy_type


CREATE TABLE old_hmda (
	id serial,
    as_of_year char(4) NULL,
    respondent_id varchar(20) NULL,
    agency_code int2 NULL,
    loan_type int2 NULL,
    property_type int2 NULL,
    loan_amount_000s numeric(8,2) NOT NULL,
	CONSTRAINT hmda_pkey1 PRIMARY KEY (id)
);


CREATE TABLE new_hmda (
	id serial,
    record_number integer NULL,
    activity_year char(4) NULL,
    lei varchar(32) NULL,
    derived_dwelling_category varchar(256) NULL,
    loan_type int2 NULL,
    loan_amount numeric(10,2) NOT NULL,
    occupancy_type int2 NULL,
	CONSTRAINT new_hmda_pkey1 PRIMARY KEY (id)
);                                                      