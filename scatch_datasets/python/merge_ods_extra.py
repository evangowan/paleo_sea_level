#!/usr/bin/env python3

import sys
import numpy as np
import pandas as pd
from pandas_ods_reader import read_ods

# this program expects that there is a file called file_list.txt that contains all of the files that will be merged

file_list = open("file_list_extra.txt", "r")
files = file_list.readlines()
file_list.close()



# it is expected that the ods file contains a sheet called sea_level that will contain the desired data
sheet_name = "sea_level"

# create a pandas dataframe



counter=1

for file_line in files:
	split_line = file_line.split('\t')
	file_name = split_line[0]
	folder_extension = split_line[1]
	latex_extension = split_line[2]
	gmt_extension = split_line[3].strip()
	
	sl_data = read_ods(file_name, sheet_name, headers=True)
	output_dataframe = pd.DataFrame(columns=['Region','Dating_Method','LAB_ID','Latitude','Longitude','age','error','Material','Curve','Reservoir_age','Reservoir_error','type','RSL','RSL_2sigma_upper','RSL_2sigma_lower','Reference'])
	output_dataframe= pd.DataFrame(pd.concat([output_dataframe,sl_data]), columns=output_dataframe.columns)

	output_dataframe = output_dataframe.fillna("")

	file_out_prefix = "merge_extra_" + str(counter)

	file_out_ods = file_out_prefix + ".ods"

	with pd.ExcelWriter(file_out_ods, engine="odf") as doc:
		output_dataframe.to_excel(doc, sheet_name=sheet_name, index=False)

	file_out_csv = file_out_prefix + ".csv"

	output_dataframe.to_csv(file_out_csv, index=False, sep = '\t')

	file_out_csv = file_out_prefix + "_points.txt"

	output_dataframe.to_csv(file_out_csv, index=False, sep=" ", columns=['Longitude','Latitude'], header=False)

	counter = counter + 1
