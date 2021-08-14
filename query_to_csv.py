
# import required libraries
import sys
import os
import time
#import pandas as pd
import psycopg2
import psycopg2.extras as extras
from psycopg2 import OperationalError, errorcodes, errors


# User variables
target_year         = str(sys.argv[1])

#exported_file_name  = f"hmda_transmittal_{target_year}.csv"
#sql = f'''
#COPY (
#    select * from hmda_transmittal_{target_year} order by activity_year, lender_name
#) TO STDOUT WITH CSV DELIMITER ','
#'''

#this was for the full range of years
#exported_file_name  = f"hmda_transmittal_2010_{target_year}.csv"
#sql = f'''
#COPY (
#   select * from hmda_transmittal_2010_{target_year} order by activity_year, lender_name
#) TO STDOUT WITH CSV DELIMITER ','
#'''

#this is for the events table
exported_file_name  = f"ricks_lender_id_lookup.csv"
sql = f'''
COPY (
   select * from hmda_transmittal_2010_2020 
) TO STDOUT WITH CSV DELIMITER ','
'''


target_directory = '/Users/aki/dev/big_data_files/exported/'
exported_file_full_path = f"{target_directory}{exported_file_name}"



def main():
    export_query_to_csv()
    print('\nDONE')


def export_query_to_csv():
    global exported_file_full_path, sql
    conn = get_pg_connection()
    cur = conn.cursor()
    with open(exported_file_full_path, "w") as file:
        cur.copy_expert(sql, file)


# ================================================================
# DATBASE HELPER FUNCTIONS
# ================================================================

def show_psycopg2_exception(err):
    # get details about the exception
    err_type, err_obj, traceback = sys.exc_info()
    # get the line number when exception occured
    line_n = traceback.tb_lineno
    # print the connect() error
    print ("\npsycopg2 ERROR:", err, "on line number:", line_n)
    print ("psycopg2 traceback:", traceback, "-- type:", err_type)
    # psycopg2 extensions.Diagnostics object attribute
    #print ("\nextensions.Diagnostics:", err.diag)
    # print the pgcode and pgerror exceptions
    #print ("pgerror:", err.pgerror)
    #print ("pgcode:", err.pgcode, "\n")


def get_pg_connection():
    conn = None
    conn_params_dic = {
        "host"      : "localhost",
        "user"      : "aki",
        "password"  : ""
    }    

    try:
        #print('Connecting to the PostgreSQL...........')
        conn = psycopg2.connect(**conn_params_dic)
        #print("Connection successful..................")
        
    except OperationalError as err:
        # passing exception to function
        show_psycopg2_exception(err)
        # set the connection to 'None' in case of error
        conn = None
    
    return conn


# ================================================================
if __name__ == "__main__":
    main()