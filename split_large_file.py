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
desired_cols         = [0, 1, 8, 15, 21, 40]


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

        # close off the previous file and start a new file every x many records
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
    list_line_to_write = [current_line_number, desired_column_row_list[0], desired_column_row_list[1], desired_column_row_list[2], desired_column_row_list[3], desired_column_row_list[4], desired_column_row_list[5]] 
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
    desired_header_line = ",".join(['record_number', desired_column_headers_list[0], desired_column_headers_list[1], desired_column_headers_list[2], desired_column_headers_list[3], desired_column_headers_list[4], desired_column_headers_list[5]]) 
    f.write(desired_header_line)
    f.write('\n')
    print(current_file_name)
    

def close_current_file():
    global f
    f.close()


# ================================================================
if __name__ == "__main__":
    main()


'''
These are the available columns in the 2019 HMDA csv file:
* 0 activity_year
* 1 lei
2 derived_msa-md
3 state_code
4 county_code
5 census_tract
6 conforming_loan_limit
7 derived_loan_product_type
* 8 derived_dwelling_category
9 derived_ethnicity
10 derived_race
11 derived_sex
12 action_taken
13 purchaser_type
14 preapproval
* 15 loan_type
16 loan_purpose
17 lien_status
18 reverse_mortgage
19 open-end_line_of_credit
20 business_or_commercial_purpose
* 21 loan_amount
22 loan_to_value_ratio
23 interest_rate
24 rate_spread
25 hoepa_status
26 total_loan_costs
27 total_points_and_fees
28 origination_charges
29 discount_points
30 lender_credits
31 loan_term
32 prepayment_penalty_term
33 intro_rate_period
34 negative_amortization
35 interest_only_payment
36 balloon_payment
37 other_nonamortizing_features
38 property_value
39 construction_method
* 40 occupancy_type
41 manufactured_home_secured_property_type
42 manufactured_home_land_property_interest
43 total_units
44 multifamily_affordable_units
45 income
46 debt_to_income_ratio
47 applicant_credit_score_type
48 co-applicant_credit_score_type
49 applicant_ethnicity-1
50 applicant_ethnicity-2
51 applicant_ethnicity-3
52 applicant_ethnicity-4
53 applicant_ethnicity-5
54 co-applicant_ethnicity-1
55 co-applicant_ethnicity-2
56 co-applicant_ethnicity-3
57 co-applicant_ethnicity-4
58 co-applicant_ethnicity-5
59 applicant_ethnicity_observed
60 co-applicant_ethnicity_observed
61 applicant_race-1
62 applicant_race-2
63 applicant_race-3
64 applicant_race-4
65 applicant_race-5
66 co-applicant_race-1
67 co-applicant_race-2
68 co-applicant_race-3
69 co-applicant_race-4
70 co-applicant_race-5
71 applicant_race_observed
72 co-applicant_race_observed
73 applicant_sex
74 co-applicant_sex
75 applicant_sex_observed
76 co-applicant_sex_observed
77 applicant_age
78 co-applicant_age
79 applicant_age_above_62
80 co-applicant_age_above_62
81 submission_of_application
82 initially_payable_to_institution
83 aus-1
84 aus-2
85 aus-3
86 aus-4
87 aus-5
88 denial_reason-1
89 denial_reason-2
90 denial_reason-3
91 denial_reason-4
92 tract_population
93 tract_minority_population_percent
94 ffiec_msa_md_median_family_income
95 tract_to_msa_income_percentage
96 tract_owner_occupied_units
97 tract_one_to_four_family_homes
98 tract_median_age_of_housing_units
'''