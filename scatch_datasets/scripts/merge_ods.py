#!/usr/bin/env python3

import sys
import numpy as np
import pandas as pd
from pandas_ods_reader import read_ods

sl_sector = sys.argv[1]

# this program expects that there is a file called file_list.txt that contains all of the files that will be merged

file_list_filename = sl_sector + "/file_list.txt"

try:
	file_list = open(file_list_filename, "r")
	files = file_list.readlines()
	file_list.close()

except FileNotFoundError:
	print("No sea level files detected")
	sys.exit()

# it is expected that the ods file contains a sheet called sea_level that will contain the desired data
sheet_name = "sea_level"

# create a pandas dataframe

output_dataframe = pd.DataFrame(columns=['Region','Dating_Method','LAB_ID','Latitude','Longitude','age','error','Material','Curve','Reservoir_age','Reservoir_error','type','RSL','RSL_2sigma_upper','RSL_2sigma_lower','Reference'])



for file_line in files:
	file_name = sl_sector + "/" + file_line.strip()
	
	sl_data = read_ods(file_name, sheet_name, headers=True)
	output_dataframe= pd.DataFrame(pd.concat([output_dataframe,sl_data]), columns=output_dataframe.columns)

output_dataframe = output_dataframe.fillna("")

output_file = sl_sector + "/temp/merge.ods"

with pd.ExcelWriter(output_file, engine="odf") as doc:
    output_dataframe.to_excel(doc, sheet_name=sheet_name, index=False)

output_file = sl_sector + "/temp/merge.csv"

output_dataframe.to_csv(output_file, index=False, sep = '\t')

output_file = sl_sector + "/temp/points.txt"

output_dataframe.to_csv(output_file, index=False, sep=" ", columns=['Longitude','Latitude'], header=False)
