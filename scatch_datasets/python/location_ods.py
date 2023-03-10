#!/usr/bin/env python3

import sys
import numpy as np
import pandas as pd
from pandas_ods_reader import read_ods


sl_data = read_ods("merged.ods", headers=True)
sl_data['LAB_ID'] = sl_data['LAB_ID'].astype(str)

sl_data = sl_data.sort_values(by='LAB_ID',ignore_index=True)



sl_data2 = pd.read_csv("joined.csv")

sl_data2['LAB_ID'] = sl_data2['LAB_ID'].astype(str)

sl_data2 = sl_data2.sort_values(by='LAB_ID',ignore_index=True)



sl_data3 = pd.read_csv("joined2.csv")

sl_data3['LAB_ID'] = sl_data3['LAB_ID'].astype(str)

sl_data3 = sl_data3.sort_values(by='LAB_ID',ignore_index=True)



sl_data['Region'] = sl_data2['location']



sl_data3.loc[sl_data3['Curve'] == "marine", 'Reservoir_'] = sl_data3['delta_r']
sl_data3.loc[sl_data3['Curve'] == "marine", 'Reservoi_1'] = sl_data3['uncertaint']



sl_data['Reservoir_age'] = sl_data3['Reservoir_']
sl_data['Reservoir_error'] = sl_data3['Reservoi_1']

sl_data = sl_data.sort_values(by='Region',ignore_index=True)

with pd.ExcelWriter('merged2.ods', engine="odf") as doc:
    sl_data.to_excel(doc,  index=False)
