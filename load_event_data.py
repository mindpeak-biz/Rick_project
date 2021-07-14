
# import required libraries
import sys
import os
import time
import pandas as pd
import psycopg2
import psycopg2.extras as extras
from psycopg2 import OperationalError, errorcodes, errors


# User variables
file_name  = 'EventData2011_2020.csv'
table_name = 'events'
target_directory = '/Users/aki/dev/big_data_files/events/'
file_to_load  = file_name


def main():
    insert_hmda_data(get_pg_connection(), get_csv_for_ingestion_into_db(os.path.join(target_directory, file_to_load)), table_name)
    print('\nDONE')


def get_csv_for_ingestion_into_db(file):
    csvDataForIngestion = pd.read_csv(file,index_col=False)
    return csvDataForIngestion


# ================================================================
# DATBASE HELPER FUNCTIONS
# ================================================================
def insert_hmda_data(conn, datafrm, table):
    
    # Creating a list of tupples from the dataframe values
    tpls = [tuple(x) for x in datafrm.to_numpy()]
    
    # dataframe columns with Comma-separated
    cols = ','.join(list(datafrm.columns))
    print(len(datafrm.columns))
    
    # SQL query to execute
    sql = "INSERT INTO %s(%s) VALUES(%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s,%%s)" % (table, cols)
    cursor = conn.cursor()
    try:
        cursor.executemany(sql, tpls)
        conn.commit()
        print(f"Data inserted successfully...")
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