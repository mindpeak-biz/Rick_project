                                              

-- Final HMDA schema 
CREATE TABLE hmda (
	id serial,
    record_number integer NULL,
    year char(4) NULL,
    lender_id varchar(32) NULL,
    loan_type int2 NULL,
    property_type varchar(256) NULL,
    loan_amount_in_000s numeric(10,2) NOT NULL,
    agency_code varchar(10) NULL,
	CONSTRAINT hmda_pkey1 PRIMARY KEY (id)
);     

CREATE INDEX idx_hmda_year ON hmda (year);
CREATE INDEX idx_hmda_load_type ON hmda (loan_type);
CREATE INDEX idx_hmda_prop_type ON hmda (property_type);
CREATE INDEX idx_hmda_lender_id ON hmda (lender_id);
CREATE INDEX idx_hmda_loan_amt ON hmda (loan_amount_in_000s);


-- Final transmittal_sheet schema 
CREATE TABLE transmittal_sheet (
	id serial,
    activity_year char(4) NULL,
    calendar_quarter int2 NULL,
    lei varchar(32) NULL,
    tax_id varchar(15) NULL,
    agency_code varchar(10) NULL,
    respondent_name varchar(200) NULL,
    respondent_state char(4) NULL,
    respondent_city varchar(50) NULL,
    respondent_zip_code varchar(15) NULL,
    lar_count integer NULL,
    respondent_mailing_address varchar(200) NULL,
    parent_name varchar(200) NULL,
    parent_address varchar(200) NULL,
    parent_city varchar(50) NULL,
    parent_state char(4) NULL,
    parent_zip_code varchar(15) NULL,
	CONSTRAINT transmittal_sheet_pkey1 PRIMARY KEY (id)
);     


CREATE INDEX idx_transmittal_asdf ON transmittal_sheet (asdf);
CREATE INDEX idx_transmittal_asdf ON transmittal_sheet (asdf);
CREATE INDEX idx_transmittal_asdf ON transmittal_sheet (asdf);
CREATE INDEX idx_transmittal_asdf ON transmittal_sheet (asdf);
CREATE INDEX idx_transmittal_asdf ON transmittal_sheet (asdf);


-- Enumerations
CREATE TABLE hmda_loan_types (
	id int2 NULL,
    loan_type varchar(150),
	CONSTRAINT hmda_loan_types_pkey1 PRIMARY KEY (id)
);  


CREATE TABLE hmda_property_types (
	id int2 NULL,
    property_type varchar(150),
	CONSTRAINT hmda_property_types_pkey1 PRIMARY KEY (id)
);  