#!/usr/bin/env python3

import sys
import numpy as np
import pandas as pd
from pandas_ods_reader import read_ods

# this program expects that there is a file called file_list.txt that contains all of the files that will be merged

file_list = open("file_list.txt", "r")
files = file_list.readlines()
file_list.close()

# it is expected that the ods file contains a sheet called sea_level that will contain the desired data
sheet_name = "sea_level"

# create a pandas dataframe

output_dataframe = pd.DataFrame(columns=['Region','Dating_Method','LAB_ID','Latitude','Longitude','age','error','Material','Curve','Reservoir_age','Reservoir_error','type','RSL','RSL_2sigma_upper','RSL_2sigma_lower','Reference'])



for file_line in files:
	file_name = file_line.strip()
	
	sl_data = read_ods(file_name, sheet_name, headers=True)
	output_dataframe= pd.DataFrame(pd.concat([output_dataframe,sl_data]), columns=output_dataframe.columns)

output_dataframe = output_dataframe.fillna("")


with pd.ExcelWriter('merged.ods', engine="odf") as doc:
    output_dataframe.to_excel(doc, sheet_name=sheet_name, index=False)

output_dataframe.to_csv('merge.csv', index=False, sep = '\t')
