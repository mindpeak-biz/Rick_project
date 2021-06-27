# Author:         Aki Iskandar 
# Date Created:   06/23/2021
# Last Modified:  06/25/2021

# Script name:    app.py

# Description:    This script serves as a guide for Rick to demonstrate how to use  
#                 Python and the Pandas library to ingest the HMDA csv file  
#                 and to do various things with them (i.e. create a smaller csv file 
#                 and do some simple number crunching ... sum, average, etc.)

# Usage:          Comment / uncomment lines in the main function as desired 
#                 and run this script (i.e. python3 app.py) 
# ---------------------------------------------------------------------------------------


# import required libraries
import sys
import pandas as pd
import psycopg2
import psycopg2.extras as extras
from psycopg2 import OperationalError, errorcodes, errors



def main():
    print("\nIn the app::main function\n")
    #read_all_columns_csv()
    #read_ricks_columns_csv()
    #create_smaller_csv()
    #do_math()
    #group_by()
    #get_pg_connection()

    #database functions
    insert_hmda_data(get_pg_connection(), get_csv_for_ingestion_into_db(), 'hmda')
    #

    print("\nEND")



# -----------------------------------------------------------------
# helper functions
def read_all_columns_csv():
    df = pd.read_csv('hmda_2017_short.csv')
    print(df.to_string()) 


def read_ricks_columns_csv():
    df = pd.read_csv("hmda_2017_short.csv", usecols = ['as_of_year',
                                                       'respondent_id', 
                                                       'agency_code',
                                                       'loan_type',
                                                       'property_type',
                                                       'loan_amount_000s'])
    print(df.to_string()) 


def iterate_through_df():
    df = pd.read_csv('hmda_2017_short.csv')
    for index, row in df.iterrows():
        print(row['respondent_id'], row['loan_amount_000s'])


def create_smaller_csv():
    df = pd.read_csv('hmda_2014.csv')
    header = ['as_of_year',
              'respondent_id',
              'agency_code',
              'loan_type',
              'property_type',
              'loan_amount_000s']
    df.to_csv('smaller_hmda_2014.csv', index = False, columns = header)


def get_csv_for_ingestion_into_db():
    csvDataForIngestion = pd.read_csv('smaller_hmda_2014.csv',index_col=False)
    return csvDataForIngestion


def do_math():
    df = pd.read_csv('hmda_2017_short.csv')
    print(f"The record count is: {len(df)}")
    print(f"The sum of the 'loan_amount_000s' column is: {df['loan_amount_000s'].sum()}")
    print(f"The average of the 'loan_amount_000s' column is: {df['loan_amount_000s'].mean()}")


def group_by(): # this should probably be done in the database
    df = pd.read_csv('hmda_2017_short.csv')
    df = df.groupby('respondent_id')
    print(df)



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
