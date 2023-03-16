#!/usr/bin/env python3

import sys
import numpy as np
import pandas as pd
from pandas_ods_reader import read_ods

merged_file = sys.argv[1] # merged ods file
region_file = sys.argv[2] # csv file with Region field filled out
reservoir_file = sys.argv[3] # csv file with reservoir corrections field filled out
output_file = sys.argv[4] # output ods file

sl_data = read_ods(merged_file, headers=True)
sl_data['LAB_ID'] = sl_data['LAB_ID'].astype(str)

sl_data = sl_data.sort_values(by='LAB_ID',ignore_index=True)



sl_data2 = pd.read_csv(region_file)

sl_data2['LAB_ID'] = sl_data2['LAB_ID'].astype(str)

sl_data2 = sl_data2.sort_values(by='LAB_ID',ignore_index=True)



sl_data3 = pd.read_csv(reservoir_file)

sl_data3['LAB_ID'] = sl_data3['LAB_ID'].astype(str)

sl_data3 = sl_data3.sort_values(by='LAB_ID',ignore_index=True)



sl_data['Region'] = sl_data2['location']



sl_data3.loc[sl_data3['Curve'] == "marine", 'Reservoir_'] = sl_data3['delta_r']
sl_data3.loc[sl_data3['Curve'] == "marine", 'Reservoi_1'] = sl_data3['uncertaint']



sl_data['Reservoir_age'] = sl_data3['Reservoir_']
sl_data['Reservoir_error'] = sl_data3['Reservoi_1']

sl_data = sl_data.sort_values(by='Region',ignore_index=True)

with pd.ExcelWriter(output_file, engine="odf") as doc:
    sl_data.to_excel(doc,  index=False)
