CREATE TABLE hmda (
	id serial,
    as_of_year char(4) NULL,
    respondent_id varchar(20) NULL,
    agency_code int2 NULL,
    loan_type int2 NULL,
    property_type int2 NULL,
    loan_amount_000s numeric(8,2) NOT NULL,
	CONSTRAINT hmda_pkey1 PRIMARY KEY (id)
);


                                                      