#!/usr/bin/env python3

import sys
import numpy as np
import pandas as pd
from pandas_ods_reader import read_ods


sl_data = read_ods("merged.ods", headers=True)

sl_data2 = pd.read_csv("joined.csv")


sl_data['Region'] = sl_data2['location']


with pd.ExcelWriter('merged2.ods', engine="odf") as doc:
    sl_data.to_excel(doc,  index=False)
