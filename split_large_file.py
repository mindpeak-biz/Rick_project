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


# User variables
large_csv_file_name  = 'FullDataFor2019.csv'
year_for_data        = 2019
output_directory     = f'HMDA_{year_for_data}_Files'
max_lines_per_file   = 200000.0
desired_cols         = [0, 1, 3, 21, 45, 46, 23]


# Program variables
header_line         = None
header_cols_list    = []
current_line_number = 1
current_file_number = 1



def main():
    global large_file_name, output_directory, current_file_name, current_file_handle, year_for_data, header_line, header_cols_list, max_lines_per_file
    print("\nIn the app::main function\n")
    get_header_and_columns()
    print_header_cols_with_index()
    chop_it_up()
    print("\nEND")


def get_header_and_columns():
    global large_file_name, output_directory, current_file_name, current_file_handle, year_for_data, header_line, header_cols_list, max_lines_per_file
    with open(large_file_name) as f:
        header_line = f.readline().replace('\n', '')
    header_cols_list = header_line.split(",")


def print_header_cols_with_index():
    global large_file_name, output_directory, current_file_name, current_file_handle, year_for_data, header_line, header_cols_list, max_lines_per_file
    for x in range(len(header_cols_list)):
        print(x, header_cols_list[x])


def create_hmda_directory():
    # create the directory if is does not already exist
    global large_file_name, output_directory, current_file_name, current_file_handle, year_for_data, header_line, header_cols_list, max_lines_per_file
    dir_name = f'HMDA_{year_for_data}_Files'
    if not os.path.exists(dir_name):
        os.makedirs(dir_name)    


def chop_it_up():
    global large_file_name, output_directory, current_file_name, current_file_handle, year_for_data, header_line, header_cols_list, max_lines_per_file
    create_hmda_directory()
    start_new_file()
    for line in open(large_file_name):
        if current_line_number % max_lines_per_file == 0.0:
            start_new_file()
        process_line(current_line_number, line)
        current_line_number += 1
    print("\nExiting chop_it_up")


def process_line(current_line_number, line):
    global large_file_name, output_directory, current_file_name, current_file_handle, year_for_data, header_line, header_cols_list, max_lines_per_file
    current_line_list = line.split(",")
    print(current_line_number, current_line_list[0], current_line_list[1], current_line_list[3], current_line_list[21], current_line_list[45], current_line_list[46], current_line_list[23]) 


def start_new_file():
    global large_file_name, output_directory, current_file_name, current_file_handle, year_for_data, header_line, header_cols_list, max_lines_per_file
    # create the new file 
    # write out the header row
    current_file_number += 1


# ================================================================
if __name__ == "__main__":
    main()


