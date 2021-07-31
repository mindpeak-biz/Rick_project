# Author:         Aki Iskandar 
# Date Created:   07/30/2021
# Last Modified:  07/30/2021

# Script name:    update_lender_ids.py

# Description:    This script serves to update the lender ids for the actors in the events table

# Usage:          Run this script (i.e. python3 update_lender_ids.py) 
# ---------------------------------------------------------------------------------------


# import required libraries
import sys
import os
import time
import psycopg2
from psycopg2 import sql, connect
import psycopg2.extras as extras
from psycopg2 import OperationalError, errorcodes, errors


# Read in all the records from the events table and create the list of dictionaries
# that will contain the data we need to create the sql queries.
# Iterate through the list and call the find_lender_id function (once per actor) 
# which will in turn call the remaining functions as needed. 

def main():
    counter = 1
    event_data_for_queries = get_all_event_data_as_list_of_dicts()
    #print(event_data_for_queries[0]["acquirer"])
    for event_dict in event_data_for_queries:
        # Look for the acquirer lender_id and update lender_id
        find_lender_id(event_dict["id"], event_dict["year"], event_dict["zip"], 'acq_instname', event_dict["acquirer"])
        # Look for the acquirer lender_id and update lender_id
        find_lender_id(event_dict["id"], event_dict["year"], event_dict["zip"], 'out_instname', event_dict["target"])
        # Look for the acquirer lender_id and update lender_id
        find_lender_id(event_dict["id"], event_dict["year"], event_dict["zip"], 'sur_instname', event_dict["survivor"])
        counter = counter + 1
        print(counter)
    print('\nDONE')


def find_lender_id(row_id, year, zip, column_name, column_value):
    lender_id = None
    conn = get_pg_connection()
    cursor = conn.cursor()
    sql = f"select lender_id from hmda_transmittal_2010_2020 where activity_year = '{year}' and left(respondent_zip_code, 5) = '{zip[:5]}' and lower(lender_name) = '{column_value.lower()}';"
    cursor.execute(sql)
    row = cursor.fetchone()
    if row:
        lender_id = row[0]
        #print(f"Found lender_id for {column_value}: {lender_id}\n\n")
        # Update the lender id
        update_lender_id(row_id, column_name, lender_id)
    else:
        #print(f"Did not find a lender_id for {column_value}\n\n")
        pass


def update_lender_id(row_id, column_name, lender_id):
    target_column = None
    if column_name == 'acq_instname':
        target_column = 'lender_id_acquirer'
    elif column_name == 'out_instname':   
        target_column = 'lender_id_target'
    else:
        target_column = 'lender_id_survivor' 
    conn = get_pg_connection()
    cursor = conn.cursor()
    sql = f"update events set {target_column} = '{lender_id}' where id = {row_id};"
    print(sql)
    cursor.execute(sql)
    conn.commit()


# ================================================================
# DATBASE HELPER FUNCTIONS
# ================================================================
def get_all_event_data_as_list_of_dicts():
    list_event_data_for_queries = []
    temp_dict = {}
    conn = get_pg_connection()
    cursor = conn.cursor(cursor_factory=psycopg2.extras.NamedTupleCursor)
    try:
        sql = "select * from events;"
        cursor.execute(sql)
        table_data = cursor.fetchall()
        for row in table_data:
            '''
            print(f"{row.id}")
            print(f"{row.effyear}")
            print(f"{row.acq_pzip5}")
            print(f"{row.acq_instname}")
            print(f"{row.out_instname}")
            print(f"{row.sur_instname}")
            print("\n\n")
            '''
            temp_dict = {}
            temp_dict["id"] = row.id
            temp_dict["year"] = row.effyear
            temp_dict["zip"] = row.acq_pzip5
            temp_dict["acquirer"] = row.acq_instname.replace("'","")
            temp_dict["target"] = row.out_instname.replace("'","")
            temp_dict["survivor"] = row.sur_instname.replace("'","")
            list_event_data_for_queries.append(temp_dict)
        print(f"Created the list of dictionaries for the events data")
    except (Exception, psycopg2.DatabaseError) as err:
        # pass exception to function
        show_psycopg2_exception(err)
    finally:    
        cursor.close()
        conn.close()
    return list_event_data_for_queries


def execute_select():
    conn = get_pg_connection()
    cursor = conn.cursor()
    try:
        cursor.execute(sql)

    except (Exception, psycopg2.DatabaseError) as err:
        # pass exception to function
        show_psycopg2_exception(err)
        cursor.close()


def execute_update():
    conn = get_pg_connection()
    cursor = conn.cursor()
    try:
        cursor.execute(sql)
        conn.commit()

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