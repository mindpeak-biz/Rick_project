CREATE TABLE public.manual_lender_id_lookup
(
    lender_id_acquirer character varying(30) COLLATE pg_catalog."default",
    lender_id_target character varying(30) COLLATE pg_catalog."default",
    lender_id_survivor character varying(30) COLLATE pg_catalog."default",
    row_id integer,
    year character(4) COLLATE pg_catalog."default" NOT NULL,
    zip character(5) COLLATE pg_catalog."default" NOT NULL,
    lender_id character varying(32) COLLATE pg_catalog."default" NOT NULL,
    lender_name character varying(200) COLLATE pg_catalog."default",
    acquirer_name character varying(200) COLLATE pg_catalog."default",
    target_name character varying(200) COLLATE pg_catalog."default",
    survivor_name character varying(200) COLLATE pg_catalog."default",
    CONSTRAINT manual_lender_id_lookup_pkey PRIMARY KEY (year, zip, lender_id)
)

TABLESPACE pg_default;

ALTER TABLE public.manual_lender_id_lookup
    OWNER to postgres;