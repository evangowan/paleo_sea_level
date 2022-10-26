#!/usr/bin/env python3

import sys
import numpy as np
import pandas as pd


filename = sys.argv[1]

col_names = ["longitude", "latitude"]

polygon = pd.read_csv (filename, sep=' ', header=None, names=col_names)

latitude = polygon['latitude'].to_numpy()
longitude = polygon['longitude'].to_numpy()





number_points = longitude.size


#need to check if the longitude values cross over the 180th meridian

crossover = False

for counter in range(0,number_points-1):
	longcheck1 = longitude[counter]
	longcheck2 = longitude[counter+1]
	latcheck1 = latitude[counter]
	latcheck2 = latitude[counter+1]

	if longcheck1 < 0.0:
		longcheck3 = 360.0 + longcheck1
	else:
		longcheck3 = longcheck1

	if longcheck2 < 0.0:
		longcheck4 = 360.0 + longcheck2
	else:
		longcheck4 = longcheck2

	if np.max([longcheck3,longcheck4]) - np.min([longcheck3,longcheck4])  < np.max([longcheck1,longcheck2]) - np.min([longcheck1,longcheck2]):
		crossover = True


if crossover:
	for counter in range(0,number_points):
		if longitude[counter] < 0.0:
			longitude[counter] = 360.0 + longitude[counter]



area = 0
Cx = 0
Cy = 0

extreme_west=longitude[0]
extreme_east=longitude[0]
extreme_north=latitude[0]
extreme_south=latitude[0]

# Find centroid
# https://en.wikipedia.org/wiki/Centroid

for counter in range(0,number_points-1):


	common_part = longitude[counter] * latitude[counter+1] - longitude[counter+1] * latitude[counter]
	area = area + common_part

	Cx = Cx + (longitude[counter] + longitude[counter+1]) * common_part
	Cy = Cy + (latitude[counter] + latitude[counter+1]) * common_part

	if longitude[counter] < extreme_west:
		extreme_west = longitude[counter]

	if longitude[counter] > extreme_east:
		extreme_east = longitude[counter]

	if latitude[counter] < extreme_south:
		extreme_south = latitude[counter]

	if latitude[counter] > extreme_north:
		extreme_north = latitude[counter]

area = area / 2.0

Cx = np.round(Cx / (6.0 * area),2)
Cy = np.round(Cy / (6.0 * area),2)

if Cx > 180.0:
	Cx = Cx - 360.0

#if extreme_west > 180:
#	extreme_west = extreme_west - 360

#if extreme_east > 180:
#	extreme_east = extreme_east - 360

print(f"center_longitude={Cx}")
print(f"center_latitude={Cy}")

print(f"extreme_west={extreme_west}")
print(f"extreme_east={extreme_east}")
print(f"extreme_south={extreme_south}")
print(f"extreme_north={extreme_north}")
