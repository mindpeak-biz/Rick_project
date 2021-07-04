                                              

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



-- New columns for transmittal sheet
CREATE TABLE transmittal_sheet (
	id serial,
    activity_year varchar(32) NULL,
    respondent_id varchar(32) NULL,
    agency_code varchar(10) NULL,
    tax_id varchar(15) NULL,
    respondent_name varchar(200) NULL,
    respondent_mailing_address varchar(200) NULL,
    respondent_city varchar(50) NULL,
    respondent_state varchar(32) NULL,
    respondent_zip_code varchar(15) NULL,
    parent_name varchar(200) NULL,
    parent_address varchar(200) NULL,
    parent_city varchar(50) NULL,
    parent_state varchar(32) NULL,
    parent_zip_code varchar(15) NULL,
    respondent_name_panel varchar(200) NULL,
    respondent_city_panel varchar(50) NULL,
    respondent_state_panel varchar(32) NULL,
    lar_count integer NULL,
   	CONSTRAINT transmittal_sheet_pkey1 PRIMARY KEY (id)
); 





-- New columns for events
CREATE TABLE events (
	id serial,
    acq_branches varchar(200) NULL,
    acq_branches_href varchar(200) NULL,
    acq_cert varchar(200) NULL,
    acq_chartagent varchar(200) NULL,
    acq_charter varchar(200) NULL,
    acq_class varchar(200) NULL,
    acq_class_type varchar(200) NULL,
    acq_class_type_desc varchar(200) NULL,
    acq_clcode varchar(200) NULL,
    acq_cntyname varchar(200) NULL,
    acq_cntynum varchar(200) NULL,
    acq_fdicregion varchar(200) NULL,
    acq_fdicregion_desc varchar(200) NULL,
    acq_insagent1 varchar(200) NULL,
    acq_insagent2 varchar(200) NULL,
    acq_instname varchar(200) NULL,
    acq_latitude varchar(200) NULL,
    acq_longitude varchar(200) NULL,
    acq_orgtype_num varchar(200) NULL,
    acq_org_eff_dte varchar(200) NULL,
    acq_paddr varchar(200) NULL,
    acq_pcity varchar(200) NULL,
    acq_pstalp varchar(200) NULL,
    acq_pstnum varchar(200) NULL,
    acq_pzip5 varchar(200) NULL,
    acq_pziprest varchar(200) NULL,
    acq_regagent varchar(200) NULL,
    acq_trust varchar(200) NULL,
    acq_uninum varchar(200) NULL,
    assisted_payout_flag varchar(200) NULL,
    bank_insured varchar(200) NULL,
    cert varchar(200) NULL,
    changecode varchar(200) NULL,
    changecode_desc varchar(200) NULL,
    changecode_desc_long varchar(200) NULL,
    charter_com_to_other_flag varchar(200) NULL,
    charter_com_to_ots_flag varchar(200) NULL,
    charter_other_to_com_flag varchar(200) NULL,
    charter_ots_to_com_flag varchar(200) NULL,
    class varchar(200) NULL,
    class_change_flag varchar(200) NULL,
    class_type varchar(200) NULL,
    class_type_desc varchar(200) NULL,
    effdate varchar(200) NULL,
    effyear varchar(200) NULL,
    enddate varchar(200) NULL,
    endyear varchar(200) NULL,
    failed_com_to_com_flag varchar(200) NULL,
    failed_other_to_com_flag varchar(200) NULL,
    failed_ots_to_com_flag varchar(200) NULL,
    failed_ots_to_ots_flag varchar(200) NULL,
    failed_rtc_flag varchar(200) NULL,
    frm_class varchar(200) NULL,
    frm_class_type varchar(200) NULL,
    frm_class_type_desc varchar(200) NULL,
    frm_insagent1 varchar(200) NULL,
    frm_latitude varchar(200) NULL,
    frm_longitude varchar(200) NULL,
    frm_orgtype_num varchar(200) NULL,
    frm_pstalp varchar(200) NULL,
    frm_pstnum varchar(200) NULL,
    frm_regagent varchar(200) NULL,
    id varchar(200) NULL,
    insagent1 varchar(200) NULL,
    insagent1_change_flag varchar(200) NULL,
    insured_com_flag varchar(200) NULL,
    insured_ots_flag varchar(200) NULL,
    new_charter_denovo_flag varchar(200) NULL,
    new_charter_flag varchar(200) NULL,
    orgtype_num varchar(200) NULL,
    org_role_cde varchar(200) NULL,
    org_stat_flg varchar(200) NULL,
    out_cert varchar(200) NULL,
    out_chartagent varchar(200) NULL,
    out_charter varchar(200) NULL,
    out_class varchar(200) NULL,
    out_class_type varchar(200) NULL,
    out_class_type_desc varchar(200) NULL,
    out_clcode varchar(200) NULL,
    out_cntyname varchar(200) NULL,
    out_cntynum varchar(200) NULL,
    out_fdicregion varchar(200) NULL,
    out_fdicregion_desc varchar(200) NULL,
    out_insagent1 varchar(200) NULL,
    out_insagent2 varchar(200) NULL,
    out_instname varchar(200) NULL,
    out_latitude varchar(200) NULL,
    out_longitude varchar(200) NULL,
    out_orgtype_num varchar(200) NULL,
    out_paddr varchar(200) NULL,
    out_pcity varchar(200) NULL,
    out_pstalp varchar(200) NULL,
    out_pstnum varchar(200) NULL,
    out_pzip5 varchar(200) NULL,
    out_pziprest varchar(200) NULL,
    out_regagent varchar(200) NULL,
    out_trust varchar(200) NULL,
    out_uninum varchar(200) NULL,
    procdate varchar(200) NULL,
    procyear varchar(200) NULL,
    pstalp varchar(200) NULL,
    regagent varchar(200) NULL,
    regagent_change_flag varchar(200) NULL,
    relocate_flag varchar(200) NULL,
    report_type varchar(200) NULL,
    stnum varchar(200) NULL,
    sur_cert varchar(200) NULL,
    sur_changecode varchar(200) NULL,
    sur_changecode_desc varchar(200) NULL,
    sur_chartagent varchar(200) NULL,
    sur_charter varchar(200) NULL,
    sur_class_type varchar(200) NULL,
    sur_class_type_desc varchar(200) NULL,
    sur_clcode varchar(200) NULL,
    sur_cntyname varchar(200) NULL,
    sur_cntynum varchar(200) NULL,
    sur_fdicregion varchar(200) NULL,
    sur_fdicregion_desc varchar(200) NULL,
    sur_insagent1 varchar(200) NULL,
    sur_insagent2 varchar(200) NULL,
    sur_instname varchar(200) NULL,
    sur_latitude varchar(200) NULL,
    sur_longitude varchar(200) NULL,
    sur_maddr varchar(200) NULL,
    sur_mcity varchar(200) NULL,
    sur_mstalp varchar(200) NULL,
    sur_mstate varchar(200) NULL,
    sur_mzip5 varchar(200) NULL,
    sur_orgtype_num varchar(200) NULL,
    sur_paddr varchar(200) NULL,
    sur_pcity varchar(200) NULL,
    sur_pstalp varchar(200) NULL,
    sur_pstnum varchar(200) NULL,
    sur_pzip5 varchar(200) NULL,
    sur_pziprest varchar(200) NULL,
    sur_regagent varchar(200) NULL,
    sur_trust varchar(200) NULL,
    transnum varchar(200) NULL,
    unassist_com_to_com_flag varchar(200) NULL,
    unassist_com_to_ots_flag varchar(200) NULL,
    unassist_other_to_com_flag varchar(200) NULL,
    unassist_ots_to_com_flag varchar(200) NULL,
    unassist_ots_to_ots_flag varchar(200) NULL,
    uninum varchar(200) NULL,
    voluntary_liquidation_fla varchar(200) NULL,g
    withdraw_insurance_com_flag varchar(200) NULL,
   	CONSTRAINT events_pkey1 PRIMARY KEY (id) 
);  