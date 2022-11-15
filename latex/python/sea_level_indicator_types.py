#!/usr/bin/env python3

import sys
import csv
import numpy as np
import pandas as pd

filename = sys.argv[1]
index_limit = float(sys.argv[2])
mis = sys.argv[3]
plot_height=float(sys.argv[4])


# this list contains the possible MIS stages that can be plotted right now
mis_options = ['MIS_1-2', 'MIS_3-4', 'MIS_5_a_d', 'MIS_5e' ]

col_names = ["sample_code", "latitude", "longitude", "median_age", "age_uncertainty", "indicator_type", "rsl", "rsl_upper", "rsl_lower"]

data_list = pd.read_csv (filename, sep='\t', header=None, names=col_names)

# find if there are points within the minimum and maximum times, which will depend on the MIS

holocene = False
deglacial=False
stage_2 = False
stage_3_4 = False
stage_5_a_d = False
stage_5e = False

stage_1_2_data = []
stage_3_4_data = []
stage_5_a_d_data = []
stage_5e_data = []



# note this is not specifically the MIS boundaries, but is for nicer plotting
for index, row in data_list.iterrows():
	if row['median_age'] <=10000.0: 
		holocene = True
		stage_1_2_data.append(row)
	elif row['median_age'] <= 19000.0 and row['median_age'] > 10000.0:
		deglacial = True
		stage_1_2_data.append(row)

	elif row['median_age'] <= 27000.0 and row['median_age'] > 19000.0:
		stage_2 = True

		stage_1_2_data.append(row)
	elif row['median_age'] <= 70000.0 and row['median_age'] > 27000.0:
		stage_3_4 = True
		stage_3_4_data.append(row)
	elif row['median_age'] <= 115000.0 and row['median_age'] > 70000.0:
		stage_5_a_d = True
		stage_5_a_d_data.append(row)
	elif row['median_age'] <= 135000.0 and row['median_age'] > 115000.0:
		stage_5e = True
		stage_5e_data.append(row)



data_found = False

selected_data = []
if mis == "MIS_1-2":
	if holocene and stage_2:

		min_time=-1
		max_time=29
		age_tick=4
		age_subtick=1

		selected_data = stage_1_2_data.copy()
		data_found = True

	if holocene and not deglacial and not stage_2:

		min_time=-0.5
		max_time=11.5
		age_tick=1
		age_subtick=0.5

		selected_data = stage_1_2_data.copy()
		data_found = True

	if stage_2 and deglacial and not holocene:

		min_time=9
		max_time=29
		age_tick=2
		age_subtick=1

		selected_data = stage_1_2_data.copy()
		data_found = True

	if not stage_2 and deglacial and holocene:

		min_time=-0.5
		max_time=19.5
		age_tick=2
		age_subtick=1

		selected_data = stage_1_2_data.copy()
		data_found = True

elif mis == "MIS_3-4":

	if stage_3_4:

		min_time=25
		max_time=75
		age_tick=10
		age_subtick=5

		selected_data = stage_3_4_data.copy()
		data_found = True

elif mis == "MIS_5_a_d":

	if stage_5_a_d:

		min_time=70
		max_time=120
		age_tick=10
		age_subtick=5

		selected_data = stage_5_a_d_data.copy()
		data_found = True

elif mis == "MIS_5e":

	if stage_5e:

		min_time=110
		max_time=140
		age_tick=5
		age_subtick=2.5

		selected_data = stage_5e_data.copy()			
		data_found = True

else:
	print(f"Invalid MIS stage option: {mis}, see below list for possibilities")
	print(mis_options)
print(f'data_found={data_found}')

if data_found:
	
	for row in selected_data:
		row['median_age'] =  row['median_age']  / 1000.0
		row['age_uncertainty'] =  row['age_uncertainty']  / 1000.0



	print(f'min_time={min_time}')
	print(f'max_time={max_time}')
	print(f'age_tick={age_tick}')
	print(f'age_subtick={age_subtick}')

	interval_basis = 20.0
	min_elevation=-interval_basis
	max_elevation=interval_basis

	for row in selected_data:
		if row['rsl']-row['rsl_lower'] < min_elevation:
			min_elevation = row['rsl']-row['rsl_lower']

		if row['rsl']+row['rsl_upper'] > max_elevation:
			max_elevation = row['rsl']+row['rsl_upper']

	# let's round it

	max_elevation = np.ceil(max_elevation/interval_basis) * interval_basis

	min_elevation = np.floor(min_elevation/interval_basis) * interval_basis

	elevation_range = max_elevation - min_elevation

	elevation_midpoint = elevation_range - min_elevation

	# expand the range so it is at least 80
	if elevation_range == 40:
		max_elevation = max_elevation + interval_basis
		min_elevation = min_elevation + interval_basis

		elevation_range = 80

	elif elevation_range == 60:
		if elevation_midpoint <= 0.:
			min_elevation = min_elevation + interval_basis
		else:
			max_elevation = max_elevation + interval_basis

		elevation_range = 80

	# start with 3/4 of the range, then go from there

	if elevation_range <= 100:
		relative_elevation=100
		ytickint=10
		ysubtickint=5
	elif elevation_range > 100 and elevation_range <= 160:
		relative_elevation=160
		ytickint=20
		ysubtickint=10
	elif elevation_range > 160 and elevation_range <= 200:
		relative_elevation=200
		ytickint=20
		ysubtickint=10
	elif elevation_range > 200 and elevation_range <= 260:
		relative_elevation=260
		ytickint=40
		ysubtickint=20
	elif elevation_range > 260 and elevation_range <= 300:
		relative_elevation=300
		ytickint=40
		ysubtickint=20
	elif elevation_range > 300 and elevation_range <= 360:
		relative_elevation=360
		ytickint=50
		ysubtickint=25
	elif elevation_range > 360 and elevation_range <= 400:
		relative_elevation=400
		ytickint=50
		ysubtickint=25
	else:
		relative_elevation=elevation_range
		ytickint=100
		ysubtickint=25

	elevation_plot_height = (200.0 + (elevation_range - relative_elevation)) / 200.0 * plot_height

	print(f'min_elevation={int(np.rint(min_elevation))}')
	print(f'max_elevation={int(np.rint(max_elevation))}')
	print(f'ytickint={ytickint}')
	print(f'ysubtickint={ysubtickint}')
	print(f'elevation_plot_height={elevation_plot_height}')


	marine_limiting_locations = []
	terrestrial_limiting_locations = []
	index_point_small_locations = []
	index_point_large_locations = []

	marine_limiting_datapoints = []
	terrestrial_limiting_datapoints = []
	index_point_small_datapoints = []
	index_point_large_datapoints = []
	
	number_data_points = len(selected_data)
	print(f"number_data_points={number_data_points}")
	marine_limiting = False
	for row in selected_data:

		if row['indicator_type'] == -1:
			marine_limiting = True
			marine_limiting_locations.append([row['longitude'], row['latitude']])

			marine_limiting_datapoints.append([row['median_age'],row['rsl']-row['rsl_lower'],row['age_uncertainty'],row['age_uncertainty'],0,row['rsl_upper']+row['rsl_upper']])



	terrestrial_limiting = False
	for row in selected_data:

		if row['indicator_type'] == 1:
			terrestrial_limiting = True
			terrestrial_limiting_locations.append([row['longitude'], row['latitude']])

			terrestrial_limiting_datapoints.append([row['median_age'],row['rsl']+row['rsl_upper'],row['age_uncertainty'],row['age_uncertainty'],row['rsl_upper']+row['rsl_upper'],0])

	index_point_small = False
	for row in selected_data:

		if row['indicator_type'] == 0 and row['rsl_upper'] + row['rsl_lower'] <= index_limit:
			index_point_small = True
			index_point_small_locations.append([row['longitude'], row['latitude']])

			y = ((row['rsl'] + row['rsl_upper']) + (row['rsl'] - row['rsl_lower'])) / 2.0
			y_uncertainty = (row['rsl'] + row['rsl_upper']) - y

			index_point_small_datapoints.append([row['median_age'],y,row['age_uncertainty'],y_uncertainty])

	index_point_large = False
	for row in selected_data:

		if row['indicator_type'] == 0 and row['rsl_upper'] + row['rsl_lower'] > index_limit:
			index_point_large = True
			index_point_large_locations.append([row['longitude'], row['latitude']])

			y = ((row['rsl'] + row['rsl_upper']) + (row['rsl'] - row['rsl_lower'])) / 2.0
			y_uncertainty = (row['rsl'] + row['rsl_upper']) - y

			index_point_large_datapoints.append([row['median_age'],y,row['age_uncertainty'],y_uncertainty])


	marine_limiting_map="temp/marine_limiting_map.txt"
	terrestrial_limiting_map="temp/terrestrial_limiting_map.txt"
	index_point_small_map="temp/index_point_small_map.txt"
	index_point_large_map="temp/index_point_large_map.txt"


	marine_limiting_data="temp/marine_limiting_data.txt"
	terrestrial_limiting_data="temp/terrestrial_limiting_data.txt"
	index_point_small_data="temp/index_point_small_data.txt"
	index_point_large_data="temp/index_point_large_data.txt"

	number_marine_limiting = len(marine_limiting_datapoints)
	print(f"number_marine_limiting={number_marine_limiting}")
	number_terrestrial_limiting = len(terrestrial_limiting_datapoints)
	print(f"number_terrestrial_limiting={number_terrestrial_limiting}")
	number_index_points = len(index_point_small_datapoints) + len(index_point_large_datapoints)
	print(f"number_index_points={number_index_points}")

	if marine_limiting:

		fout = open(marine_limiting_map, 'w')
		csvout = csv.writer(fout,delimiter =' ')
		csvout.writerows(marine_limiting_locations)
		fout.close


		fout = open(marine_limiting_data, 'w')
		csvout = csv.writer(fout,delimiter =' ')
		csvout.writerows(marine_limiting_datapoints)
		fout.close


	if terrestrial_limiting:

		fout = open(terrestrial_limiting_map, 'w')
		csvout = csv.writer(fout,delimiter =' ')
		csvout.writerows(terrestrial_limiting_locations)
		fout.close

		fout = open(terrestrial_limiting_data, 'w')
		csvout = csv.writer(fout,delimiter =' ')
		csvout.writerows(terrestrial_limiting_datapoints)
		fout.close


	if index_point_small:

		fout = open(index_point_small_map, 'w')
		csvout = csv.writer(fout,delimiter =' ')
		csvout.writerows(index_point_small_locations)
		fout.close


		fout = open(index_point_small_data, 'w')
		csvout = csv.writer(fout,delimiter =' ')
		csvout.writerows(index_point_small_datapoints)
		fout.close


	if index_point_large:

		fout = open(index_point_large_map, 'w')
		csvout = csv.writer(fout,delimiter =' ')
		csvout.writerows(index_point_large_locations)
		fout.close

		fout = open(index_point_large_data, 'w')
		csvout = csv.writer(fout,delimiter =' ')
		csvout.writerows(index_point_large_datapoints)
		fout.close


else:

	print(f'min_time=0')
	print(f'max_time=0')
	print(f'age_tick=0')
	print(f'age_subtick=0')
	print(f'min_elevation=0')
	print(f'max_elevation=0')
	print(f'ytickint=0')
	print(f'ysubtickint=0')
	print(f'elevation_plot_height=0')
	print(f"number_data_points={0}")
	print(f"number_marine_limiting={0}")
	print(f"number_terrestrial_limiting={0}")
	print(f"number_index_points={0}")


