
import sys
import csv
import numpy as np
import pandas as pd

filename = sys.argv[1]
plot_width=float(sys.argv[2])
plot_height=float(sys.argv[3])
min_time=float(sys.argv[4])
max_time=float(sys.argv[5])
min_elevation=float(sys.argv[6])
max_elevation=float(sys.argv[7])


timediff = max_time - min_time
elevdiff = max_elevation - min_elevation

threshold_dim=0.15


col_names = ["age", "elevation", "age_uncertainty", "elevation_uncertainty"]

data_list = pd.read_csv (filename, sep=' ', header=None, names=col_names)


converted_data = []

for index, row in data_list.iterrows():
	x_error = 2.0*row['age_uncertainty']/timediff*plot_width
	y_error = 2.0*row['elevation_uncertainty']/elevdiff*plot_height

	if x_error < threshold_dim:
		x_error = threshold_dim

	if y_error < threshold_dim:
		y_error = threshold_dim

	converted_data.append([row['age'], row['elevation'], x_error, y_error])

fileout="temp/converted_rectangle.txt"

fout = open(fileout, 'w')
csvout = csv.writer(fout,delimiter =' ')
csvout.writerows(converted_data)
fout.close
