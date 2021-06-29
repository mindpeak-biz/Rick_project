# Author:         Aki Iskandar 
# Date Created:   06/27/2021
# Last Modified:  06/29/2021

# Script name:    load_files_in_db.py

# Description:    This script serves to load the files that were created by splitting 
#                 up the large csv file into the database.

# Usage:          Run this script (i.e. python3 load_files_in_db.py) 
# ---------------------------------------------------------------------------------------


# import required libraries
import sys
import os
import time
import pandas as pd
import psycopg2
import psycopg2.extras as extras
from psycopg2 import OperationalError, errorcodes, errors


# User variables
target_directory = ''


# Program variables
csv_files        = []
current_csv_file = ''


# Iterate through the target folder and load each csv file into the database
# one at a time. 

def main():
    for csv_file in csv_files:
        print(csv_file)
    #insert_hmda_data(get_pg_connection(), get_csv_for_ingestion_into_db(), 'hmda')
    print('\nDONE')



# ================================================================
# DATBASE HELPER FUNCTIONS
# ================================================================
def insert_hmda_data(conn, datafrm, table):
    
    # Creating a list of tupples from the dataframe values
    tpls = [tuple(x) for x in datafrm.to_numpy()]
    
    # dataframe columns with Comma-separated
    cols = ','.join(list(datafrm.columns))
    
    # SQL query to execute
    sql = "INSERT INTO %s(%s) VALUES(%%s,%%s,%%s,%%s,%%s,%%s)" % (table, cols)
    cursor = conn.cursor()
    try:
        cursor.executemany(sql, tpls)
        conn.commit()
        print("Data inserted successfully...")
    except (Exception, psycopg2.DatabaseError) as err:
        # pass exception to function
        show_psycopg2_exception(err)
        cursor.close()


def show_psycopg2_exception(err):
    # get details about the exception
    err_type, err_obj, traceback = sys.exc_info()
    # get the line number when exception occured
    line_n = traceback.tb_lineno
    # print the connect() error
    print ("\npsycopg2 ERROR:", err, "on line number:", line_n)
    print ("psycopg2 traceback:", traceback, "-- type:", err_type)
    # psycopg2 extensions.Diagnostics object attribute
    print ("\nextensions.Diagnostics:", err.diag)
    # print the pgcode and pgerror exceptions
    print ("pgerror:", err.pgerror)
    print ("pgcode:", err.pgcode, "\n")


def get_pg_connection():
    conn = None
    conn_params_dic = {
        "host"      : "localhost",
        "user"      : "aki",
        "password"  : ""
    }    

    try:
        print('Connecting to the PostgreSQL...........')
        conn = psycopg2.connect(**conn_params_dic)
        print("Connection successful..................")
        
    except OperationalError as err:
        # passing exception to function
        show_psycopg2_exception(err)
        # set the connection to 'None' in case of error
        conn = None
    
    return conn


# ================================================================
if __name__ == "__main__":
    main()