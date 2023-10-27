#!/usr/bin/env python3

import sys
import os
import numpy as np
import pandas as pd
from pandas_ods_reader import read_ods
import csv
import geopandas

sl_sector = sys.argv[1]

# the specific region lets the scripts known what geographical region from the shapefile to use if the region is different
location_dict = {'region_folder': '', 'wider_region': '', 'region': '', 'latex': '', 'gmt': ''}


# first it checks to see if merge2.ods is there

filename = sl_sector + "/temp/merge2.ods"

region_list= []

# this is where the files are stored in the database

main_directory="../sea_level_data/" + sl_sector

write_location = False


location_info_list = []

try:
	sl_data = read_ods(filename, 1, headers=True)
except KeyError:
    print("File merge2.ods is not found (you may need to run merge_ods.py first)")
else:
	write_location = True
	if not os.path.exists(main_directory):
		os.makedirs(main_directory)

	region_list = sl_data.Region.unique()

	for region in region_list:
		sl_data_temp = sl_data.loc[sl_data['Region'] == region]

		location_info = location_dict.copy()
		location_info['region_folder'] = region
		location_info['region'] = region

		location_info_list.append(location_info.copy())

		sl_directory = main_directory + "/" + region

		if not os.path.exists(sl_directory):
			os.makedirs(sl_directory)

		fileout = sl_directory + "/data.ods"

		with pd.ExcelWriter(fileout, engine="odf") as doc:
			sl_data_temp.to_excel(doc, index=False)


# now check if there are any extra files

extra_list_file = sl_sector + "/file_list_extra.txt"

try:
	extra_list = open(extra_list_file, 'r')
except FileNotFoundError:
	print("No extra files are detected")
else:
	write_location = True
	if not os.path.exists(main_directory):
		os.makedirs(main_directory)
	counter = 1
	for file_line in extra_list:
		split_line = file_line.split('\t')
		file_name = "temp/" + split_line[0]
		folder_extension = split_line[1]
		latex_extension = split_line[2]
		gmt_extension = split_line[3].strip()


		file_out_prefix = "merge_extra_" + str(counter)

		filename = sl_sector + "/temp/" + file_out_prefix + "_2.ods"

		region_list= []


		try:
			sl_data = read_ods(filename, 1, headers=True)
		except KeyError:
			print(f"File {filename} is not found (you may need to run merge_ods_extra.py first)")
		else:

			region_list = sl_data.Region.unique()


			for region in region_list:
				sl_data_temp = sl_data.loc[sl_data['Region'] == region]

				location_info = location_dict.copy()
				location_info['region_folder'] = region + "_" + folder_extension
				location_info['region'] = region

				location_info['latex'] =  latex_extension
				location_info['gmt'] =  gmt_extension

				location_info_list.append(location_info.copy())

				sl_directory = main_directory + "/" + region + "_" + folder_extension

				if not os.path.exists(sl_directory):
					os.makedirs(sl_directory)

				fileout = sl_directory + "/data.ods"

				with pd.ExcelWriter(fileout, engine="odf") as doc:
					sl_data_temp.to_excel(doc, index=False)

		counter = counter + 1


# finally, find the subregion

if 	write_location:

	region_bounds_file="../GIS/region_bounds.shp"

	region_bounds= geopandas.read_file(region_bounds_file, encoding='utf-8')


	for line in location_info_list:
		line['wider_region'] = region_bounds.loc[region_bounds['location'] == line['region'], 'subregion'].to_string(index=False)

		temp_latex = region_bounds.loc[region_bounds['location'] == line['region'], 'latex'].to_string(index=False)
		if temp_latex == "NaN":
			temp_latex = ''

		if line['latex']:
			if temp_latex:
				line['latex'] = temp_latex + ' ' + line['latex']
			else:
				line['latex'] = line['region'] + ' ' + temp_latex
		else:
			if temp_latex:
				line['latex'] = temp_latex


		temp_gmt = region_bounds.loc[region_bounds['location'] == line['region'], 'gmt'].to_string(index=False)
		if temp_gmt == "NaN":
			temp_gmt = ''

		if line['gmt']:
			if temp_gmt:
				line['gmt'] = temp_gmt + ' ' + line['gmt']
			else:
				line['gmt'] = line['region'] + ' ' + temp_gmt
		else:
			if temp_gmt:
				line['gmt'] = temp_gmt



	location_info_list = sorted(location_info_list, key=lambda d: d['region_folder'])
	location_info_list = sorted(location_info_list, key=lambda d: d['wider_region']) 



	csv_file = main_directory  + "/location_list.txt"

	location_out = open(csv_file, 'w', encoding='utf-8')
	csv_out = csv.writer(location_out, delimiter='\t')
	for dictionary in location_info_list:
		csv_out.writerow(dictionary.values())

	location_out.close()

