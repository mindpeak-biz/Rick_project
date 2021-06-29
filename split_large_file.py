# Author:         Aki Iskandar 
# Date Created:   06/26/2021
# Last Modified:  06/26/2021

# Script name:    split_large_file.py

# Description:    This script serves to split a very HMDA large csv file that has   
#                 millions of records into several smaller csv files.  
#                 The max number of lines per new file is variable.
#                 It's designed to chop up one large file at a time,
#                 and if it's one large file per year, that is optimal.

# Usage:          Modify the control variables and run the script 
#                 (i.e. python split_large_file.py) 
# ---------------------------------------------------------------------------------------


# import required libraries
import sys
import os
import time


# User variables
large_file_name      = '/Users/aki/dev/big_data_files/FullDataFor2019.csv'
year_for_data        = 2019
output_directory     = f'/Users/aki/dev/big_data_files/HMDA_{year_for_data}'
max_lines_per_file   = 100000.0
desired_cols         = [0, 1, 3, 21, 45, 46, 23]


# Program variables
header_line         = None
header_cols_list    = []
desired_column_headers_list  = []
desired_column_row_list  = []
current_file_number = 1
current_line_number = 0
f                   = None


def main():
    print("\nIn the app::main function\n")
    get_header_and_columns()
    print_header_cols_with_index()
    chop_it_up()
    print("\nEND")


def get_header_and_columns():
    global large_file_name, header_line, header_cols_list
    with open(large_file_name) as f:
        header_line = f.readline().replace('\n', '')
    header_cols_list = header_line.split(",")


def print_header_cols_with_index():
    global header_cols_list, desired_column_headers_list
    for x in range(len(header_cols_list)):
        if x in desired_cols:
            desired_column_headers_list.append(header_cols_list[x])
        print(x, header_cols_list[x])


def create_hmda_directory():
    # create the directory if is does not already exist
    global output_directory
    if not os.path.exists(output_directory):
        os.makedirs(output_directory)    


def chop_it_up():
    global large_file_name, current_line_number, current_file_number, max_lines_per_file
    create_hmda_directory()
    start_new_file()
    for line in open(large_file_name):

        # ignore the first line
        if current_line_number == 0:
            current_line_number += 1
            continue

        # place the desired columns in a new list to pass to process_line
        current_line_columns = line.split(",")
        desired_column_row_list = []
        for x in desired_cols:
            desired_column_row_list.append(current_line_columns[x])

        if current_line_number % max_lines_per_file == 0.0:
            close_current_file()
            time.sleep(2) 
            current_file_number += 1
            start_new_file()

        process_line(current_line_number, desired_column_row_list)
        current_line_number += 1

    print("\nExiting chop_it_up")


def process_line(current_line_number, desired_column_row_list):
    global f 
    list_line_to_write = [current_line_number, desired_column_row_list[0], desired_column_row_list[1], desired_column_row_list[2], desired_column_row_list[3], desired_column_row_list[4], desired_column_row_list[5], desired_column_row_list[6]] 
    list_line_to_write = [str(x) for x in list_line_to_write]
    # write out the current line's desired columns
    line_to_write = ",".join(list_line_to_write)
    f.write(line_to_write)
    f.write('\n')


def start_new_file():
    global f, output_directory, current_file_number, header_line, desired_column_headers_list
    # create the new file 
    current_file_name = f'{output_directory}/hmda_{current_file_number}.csv'
    f = open(current_file_name,"a+")
    # write out the header row
    desired_header_line = ",".join(['record_number', desired_column_headers_list[0], desired_column_headers_list[1], desired_column_headers_list[2], desired_column_headers_list[3], desired_column_headers_list[4], desired_column_headers_list[5], desired_column_headers_list[6]]) 
    f.write(desired_header_line)
    f.write('\n')
    print(current_file_name)
    

def close_current_file():
    global f
    f.close()


# ================================================================
if __name__ == "__main__":
    main()


