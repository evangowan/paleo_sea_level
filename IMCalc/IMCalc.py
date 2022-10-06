#!/usr/bin/env python3

# This is a python conversion of IMCalc, which was originally written in Java by Thomas Lorscheid. If you use this, please reference:

#     Lorscheid, T. and Rovere, A., 2019. The indicative meaning calculator–quantification of paleo sea-level 
#     relationships by using global wave and tide datasets. Open Geospatial Data, Software and Standards, 4(1), pp.1-8.
#     https://doi.org/10.1186/s40965-019-0069-8




###############################################################################################
#    you must download the CPD.cpd file from the IMCalc repository and put it in this folder
#    https://sourceforge.net/projects/imcalc/
###############################################################################################

import sys
import os

import csv

import numpy as np
import pandas as pd


#import time

class IMCalc:

	def __init__(self):
		CPD_names = ["HsMEAN", "TpMEAN", "HsSTD", "TpSTD", "MLLW", "MHHW", "LonCPD", "LatCPD", "HsMAX", "HsMIN", "TpMAX", "TpMIN", "MTL", "MLW", "MHW", "LAT", "HAT"]

		self.CPD = pd.read_csv (r'CPD.cpd', sep=';', header=None, names=CPD_names)

		# default beach slope, from Lorcheid and Rovere (2019):
		#     "For this study, the slope of beaches s was calculated averaging the slope of beaches 
		#     reported in a global compilation by Liu et al. [10], resulting in an average slope of 0.08." 
		self.default_slope = 0.084896875

		# gravity at the surface of the Earth
		self.g = 9.81

		# default lagoonal depth
		#     This value is derived by averaging 40 maximum depths of modern lagoons distributed around 
		#     the world reported in Rovere et al. [15]

		self.default_ld = -2.0

		# dictionary template for sea level data ranges
		self.indicator = {'indicator_type': '', 'LL': '', 'UL': '', 'Indicative_Range': '', 'Reference_Water_Level': '', 'RSL': '', 'RSL_uncertainty': ''}

	def distance(self, latitude1, longitude1, latitude2, longitude2):

		# Haversine Formula for calculating distance between two points on a sphere

		# checked against this site: https://www.movable-type.co.uk/scripts/latlong.html

		radius_earth = 6371000.0
		
		phi1 = np.radians(latitude1)
		phi2 = np.radians(latitude2)
		lamda1 = np.radians(longitude1)
		lamda2 = np.radians(longitude2)


		a = np.power(np.sin((phi2-phi1)/2.0),2)+np.cos(phi1) * np.cos(phi2) * np.power(np.sin((lamda2-lamda1)/2.0),2)
		c = 2.0 * np.arctan2(np.sqrt(a), np.sqrt(1.0-a))

		distance = radius_earth * c
 
		return distance

	def closest_point(self, latitude1, longitude1):

		closest_distance = 999999999.0
		closest_index = 0

#		start = time.time()

		for index, row in self.CPD.iterrows():
		

			if np.absolute(latitude1 - row['LatCPD']) < 2.0: # to reduce the amount of computations

				distance = self.distance(latitude1, longitude1, row['LatCPD'], row['LonCPD'])

				if distance < closest_distance:
					closest_distance=distance
					closest_index=index


#		end = time.time()

#		print("Execution time:",  (end-start) , "s")	

		return closest_distance, self.CPD.loc[closest_index]

	def calc_elevation_uncertainty(self,elevation):

		# this basically determines the elevation as 20% of the elevation if between 5 and 50 m, 
		# with 1 m applied if below  5 m, and an upper limit of 10 m. As done in Gowan et al (2021)
	  	# and Dalton et al (2022)

		abs_elev = np.absolute(elevation)

		if( abs_elev < 5.0):
			uncertainty = 1.0
		elif( abs_elev < 50.0):

			uncertainty = abs_elev * 0.2

		else:
			uncertainty = 10.0

		return uncertainty

	def calculate_parameters(self, tide_wave_data, slope='', Hs='', Hs_std='', Tp='', Tp_std='', MHHW='', ld='', elevation='', elevation_uncertainty=''):

		#tide_wave_data is a numpy array taken from the CPD file

		# check if there is elevation and elevation uncertainty

		if elevation and not elevation_uncertainty:
			elevation_uncertainty = calc_elevation_uncertainty(elevation)
		elif not elevation:
			elevation = 0

		if not elevation_uncertainty:
			elevation_uncertainty = 0


		# if the beach slope is not entered, it will use the default value
		if not slope:
			slope = self.default_slope

		# Hs is the mean deepwater significant wave height, which could potentially be entered by the user
		if not Hs:
			Hs = tide_wave_data['HsMEAN']

		# Tp is the mean deepwater wave period, which could potentially be entered by the user

		if not Tp:
			Tp = tide_wave_data['TpMEAN']

		# MHHW is the Mean Higher High Water, which could potentially be entered by the user

		if not MHHW:
			MHHW = tide_wave_data['MHHW']

		# ld is the lagoonal depth. If it is not entered, it uses the default value.
		if not ld:
			ld = self.default_ld

		# HSMAX an elevated wave height to calculate SWSH, using an estimate of twice the wave height standard deviation

		if Hs:
			if Hs_std:
				HSMAX = Hs + (Hs_std * 2.0);
			else:
				HSMAX = Hs + (tide_wave_data['HsSTD'] * 2.0)
		else:
			if Hs_std:
				HSMAX = tide_wave_data['HsMEAN'] + (Hs_std * 2.0);
			else:
				HSMAX = tide_wave_data['HsMEAN'] + (tide_wave_data['HsSTD'] * 2.0)

		# TPMAX an elevated deepwater wave period to calculate SWSH, using an estimate of twice the deepwater wave period standard deviation

		if Tp:
			if Tp_std:
				TPMAX = Tp + (Tp_std * 2.0);
			else:
				TPMAX = Tp + (tide_wave_data['TpSTD'] * 2.0)
		else:
			if Tp_std:
				TPMAX = tide_wave_data['TpMEAN'] + (Tp_std * 2.0);
			else:
				TPMAX = tide_wave_data['TpMEAN'] + (tide_wave_data['TpSTD'] * 2.0)



		# Lo: deepwater wave length

		Lo = (self.g * np.power(Tp, 2)) / (2.0 * np.pi)

		# db: breaking depth of waves, negative because this is below sea level
		db = -(3.86 * np.power(slope, 2) - 1.98 * slope + 0.88) * np.power(Hs / Lo, 0.84) * Lo

		# Ob: ordinary berm
		Ob = 1.1 * (0.35 * slope * np.sqrt(Hs * Lo) + np.sqrt(Hs * Lo * (0.563 * np.power(slope, 2) + 0.004)) / 2.0) + MHHW

		# Sz: Spray zone
		Sz = Ob * 2.0;



		Lo_Max = (self.g * np.power(TPMAX, 2)) / (2.0 * np.pi)

		# SWSH: Storm Waves Swash Height


		SWSH =1.1 * (0.35 * slope * np.sqrt(HSMAX * Lo_Max) + np.sqrt(HSMAX * Lo_Max * (0.563 * np.power(slope, 2) + 0.004)) / 2.0) + MHHW

		# it is now possible to calculate the UL and LL of each indicator type

		indicator_array = []

		# Beach Deposit (Beachrock) Ob db

		temp_indicator = self.indicator.copy()

		temp_indicator['indicator_type'] = "Beach Deposit (Beachrock)"
		temp_indicator['UL'] = Ob
		temp_indicator['LL'] = db

		indicator_array.append(temp_indicator)

		# Beach-Ridge SWSH Ob

		temp_indicator = self.indicator.copy()

		temp_indicator['indicator_type'] = "Beach-Ridge"
		temp_indicator['UL'] = SWSH
		temp_indicator['LL'] = Ob

		indicator_array.append(temp_indicator)


		# Coral Reef Terrace MLLW db

		temp_indicator = self.indicator.copy()

		temp_indicator['indicator_type'] = "Coral Reef Terrace"

		temp_indicator['UL'] = tide_wave_data['MLLW']
		temp_indicator['LL'] = db


		indicator_array.append(temp_indicator)


		# Lagoonal Deposit MLLW ld

		temp_indicator = self.indicator.copy()

		temp_indicator['indicator_type'] = "Lagoonal Deposit"

		if tide_wave_data['MLLW'] > ld:
			temp_indicator['UL'] = tide_wave_data['MLLW']
			temp_indicator['LL'] = ld
		else:
			temp_indicator['UL'] = np.nan
			temp_indicator['LL'] = np.nan

		indicator_array.append(temp_indicator)


		# Marine Terrace SWSH db

		temp_indicator = self.indicator.copy()

		temp_indicator['indicator_type'] = "Marine Terrace"
		temp_indicator['UL'] = SWSH
		temp_indicator['LL'] = db

		indicator_array.append(temp_indicator)

		# Shore Platform MHHW (db + MLLW)/2

		temp_indicator = self.indicator.copy()

		temp_indicator['indicator_type'] = "Shore Platform"
		temp_indicator['UL'] = tide_wave_data['MHHW']
		temp_indicator['LL'] = (db + tide_wave_data['MLLW']) / 2.0;

		indicator_array.append(temp_indicator)


		# Tidal Notch MHHW MLLW

		temp_indicator = self.indicator.copy()

		temp_indicator['indicator_type'] = "Tidal Notch"
		temp_indicator['UL'] = tide_wave_data['MHHW']
		temp_indicator['LL'] = tide_wave_data['MLLW']

		indicator_array.append(temp_indicator)




		for indicator in indicator_array:
			indicator['Indicative_Range'] = indicator['UL'] - indicator['LL']
			indicator['Reference_Water_Level'] = (indicator['UL'] + indicator['LL']) / 2.0

			indicator['RSL'] = elevation - indicator['Reference_Water_Level']
			indicator['RSL_uncertainty'] = np.sqrt(np.power(elevation_uncertainty,2)+np.power(indicator['Indicative_Range'],2))



		print(indicator_array)


if __name__ == "__main__":

	IMCalc_object = IMCalc()
	#print(IMCalc_object.data.head())
	distance, closest_point = IMCalc_object.closest_point(37.74344,-75.4424)

	IMCalc_object.calculate_parameters(closest_point, elevation=10.0, elevation_uncertainty=3.0)

	#print(IMCalc_object.distance(-45.0, 45, -45.1, 45.1)/1000)
