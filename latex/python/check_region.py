import sys
import csv
import numpy as np
import pandas as pd

location = sys.argv[1]
location_list_file = sys.argv[2]

col_names = ["location", "subregion", "map_location", "location_latex", "location_gmt"]

location_list = pd.read_csv (location_list_file, sep='\t', header=None, names=col_names)

map_location = ""
for index, row in location_list.iterrows():
	if location == row['location']:
		if not pd.isna(row['map_location']):
			map_location = row['map_location']
		else:
			map_location = location


print(map_location)
