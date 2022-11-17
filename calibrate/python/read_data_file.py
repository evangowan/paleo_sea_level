#!/usr/bin/env python3

import sys
import numpy as np
import pandas as pd
from pandas_ods_reader import read_ods

filename = sys.argv[1]

sl_data = read_ods(filename, 1, headers=True)

#sl_data.to_csv("temp_folder/data.txt", sep='\t', index=False)



# for "Curve", it will use the following (change if you want to use different calibration curves)

curve_terrestrial="IntCal13"
terrestrial="intcal13.14c"

curve_terrestrial_sh="SHCal13"
terrestrial_sh="shcal13.14c"

curve_marine="Marine13"
marine="marine13.14c"

curve_terrestrial="IntCal20"
terrestrial="intcal20.14c"

curve_terrestrial_sh="SHCal20"
terrestrial_sh="shcal20.14c"

curve_marine="Marine20"
marine="marine20.14c"

curve_types = ["marine", "terrestrial", "terrestrial_sh", "corr_terrestrial", "corr_terrestrial_sh", "mixed"]
# the data spreadsheet should have the following headers
# Region	Dating_Method	LAB_ID	Latitude	Longitude	age	error	Material	Curve	Reservoir_age	Reservoir_error	type	RSL	RSL_2sigma_upper	RSL_2sigma_lower	Reference



for row_number, row in sl_data.iterrows():
	valid = True

	file_out = "temp_folder/data_line_" + str(row_number) + ".sh"
	data_out = open(file_out, 'wt')
	data_out.write(f"sample_code=\"{row['LAB_ID']}\"\n")
	data_out.write(f"latitude=\"{row['Latitude']}\"\n")
	data_out.write(f"longitude=\"{row['Longitude']}\"\n")
	data_out.write(f"indicator_type=\"{row['type']}\"\n")
	data_out.write(f"rsl=\"{row['RSL']}\"\n")
	data_out.write(f"rsl_upper=\"{row['RSL_2sigma_upper']}\"\n")
	data_out.write(f"rsl_lower=\"{row['RSL_2sigma_lower']}\"\n")
	data_out.write(f"references=\"{row['Reference']}\"\n")

	if row['Dating_Method'] == "radiocarbon":

		curve = row['Curve'].split(",")
		if curve[0] in curve_types:
			#create a calibration file
			calibration_file = "temp_folder/run_" + str(row_number) + ".oxcal"
			calibration_out = open(calibration_file, 'wt')

			calibration_out.write(" Plot()\n")
			calibration_out.write(" {\n")


			try:
				median_age=float(row['age'])
				age_uncertainty=float(row['error'])
			except ValueError:
				
				print(f"LAB_ID: {row['LAB_ID']} has an invalid age: {row['age']}")
				print("check input file and rerun")
				valid = False
			
			if curve[0] == "marine":

				cal_line="\tCurve(\"" + str(curve_marine) + "\",\"../bin/" + str(marine) + "\");\n"
				delta_r="\tDelta_R(\"correction\"," +  str(row['Reservoir_age']) + "," + str(row['Reservoir_error'])  + ");\n"
				age_line ="\tR_Date(\"" + str(row['LAB_ID']) +"\"," + str(row['age']) + "," +  str(row['error'])  + ");\n"
				
				calibration_out.write(cal_line)
				calibration_out.write(delta_r)
				calibration_out.write(age_line)

			elif curve[0] == "terrestrial":

				cal_line="\tCurve(\"" + str(curve_terrestrial) + "\",\"../bin/" + str(terrestrial) + "\");\n"
				age_line ="\tR_Date(\"" + str(row['LAB_ID']) +"\"," + str(row['age']) + "," +  str(row['error'])  + ");\n"

				calibration_out.write(cal_line)
				calibration_out.write(age_line)

			elif curve[0] == "terrestrial_sh":

				cal_line="\tCurve(\"" + str(curve_terrestrial_sh) + "\",\"../bin/" + str(terrestrial_sh) + "\");\n"
				age_line ="\tR_Date(\"" + str(row['LAB_ID']) +"\"," + str(row['age']) + "," +  str(row['error'])  + ");\n"

				calibration_out.write(cal_line)
				calibration_out.write(age_line)

			elif curve[0] == "corr_terrestrial":

				cal_line="\tCurve(\"" + str(curve_terrestrial) + "\",\"../bin/" + str(terrestrial) + "\");\n"
				delta_r="\tDelta_R(\"correction\"," +  str(row['Reservoir_age']) + "," + str(row['Reservoir_error'])  + ");\n"
				age_line ="\tR_Date(\"" + str(row['LAB_ID']) +"\"," + str(row['age']) + "," +  str(row['error'])  + ");\n"
				
				calibration_out.write(cal_line)
				calibration_out.write(delta_r)
				calibration_out.write(age_line)


			elif curve[0] == "corr_terrestrial_sh":

				cal_line="\tCurve(\"" + str(curve_terrestrial_sh) + "\",\"../bin/" + str(terrestrial_sh) + "\");\n"
				delta_r="\tDelta_R(\"correction\"," +  str(row['Reservoir_age']) + "," + str(row['Reservoir_error'])  + ");\n"
				age_line ="\tR_Date(\"" + str(row['LAB_ID']) +"\"," + str(row['age']) + "," +  str(row['error'])  + ");\n"
				
				calibration_out.write(cal_line)
				calibration_out.write(delta_r)
				calibration_out.write(age_line)

			elif curve[0] == "mixed":


				cal_curve_terrestrial=curve[1]
				fraction_terrestrial=curve[2]

				if len(curve) > 3:
					fraction_uncertainty=curve[3]
				else:
					fraction_uncertainty=0		

				# first calculate the marine portion

				cal_line="\tCurve(\"" + str(curve_marine) + "\",\"../bin/" + str(marine) + "\");\n"
				delta_r="\tDelta_R(\"correction\"," +  str(row['Reservoir_age']) + "," + str(row['Reservoir_error'])  + ");\n"
				age_line ="\tR_Date(\"" + "marine_part" +"\"," + str(row['age']) + "," +  str(row['error'])  + ");\n"
				
				calibration_out.write(cal_line)
				calibration_out.write(delta_r)
				calibration_out.write(age_line)

				# now set up the terrestrial part

				if cal_curve_terrestrial == "terrestrial":

					cal_line="\tCurve(\"" + str(curve_terrestrial) + "\",\"../bin/" + str(terrestrial) + "\");\n"
					terrestrial_name= curve_terrestrial


				elif cal_curve_terrestrial == "terrestrial_sh":

					cal_line="\tCurve(\"" + str(curve_terrestrial_sh) + "\",\"../bin/" + str(terrestrial_sh) + "\");\n"
					terrestrial_name= curve_terrestrial_sh
				else:
					print(f"LAB_ID: {row['LAB_ID']} has an invalid curve: {cal_curve_terrestrial}")
					print("check input file and rerun")

				mix_curve="\tMix_Curves(\"Mixed1\",\"correction\",\"" +  str(terrestrial_name) +  "\"," +   str(fraction_terrestrial) + "," +   str(fraction_uncertainty)  + ");\n"

				age_line ="\tR_Date(\"" + "terrestrial_part" +"\"," + str(row['age']) + "," +  str(row['error'])  + ");\n"

				calibration_out.write(cal_line)
				calibration_out.write(age_line)
				calibration_out.write(mix_curve)


				age_line ="\tR_Date(\"" + str(row['LAB_ID']) +"\"," + str(row['age']) + "," +  str(row['error'])  + ");\n"

				calibration_out.write(age_line)
			else:
				print("there is some kind of an error in read_data_file.py")
				valid = False
			calibration_out.write(" };")
			calibration_out.close()



		else:

			print(f"LAB_ID: {row['LAB_ID']} has an invalid curve: {curve[0]}")
			print("check input file and rerun")
			valid = False

	else:
		try:
			median_age=float(row['age'])
			age_uncertainty=float(row['error']) * 2.0 # age will be in 1-sigma, change to two sigma to be the same as radiocarbon

			data_out.write(f"median_age=\"{median_age}\"\n")
			data_out.write(f"age_uncertainty=\"{age_uncertainty}\"\n")

		except ValueError:
			
			print(f"LAB_ID: {row['LAB_ID']} has an invalid age: {row['age']}")
			print("check input file and rerun")
			valid = False

	if valid:
		data_out.write(f"valid_data=true\n")

	else:
		data_out.write(f"valid_data=false\n")
	data_out.close()


number_rows = len(sl_data.index)

data_count_out = open('temp_folder/number_data.sh', 'wt')

data_count_out.write(f"number_lines={number_rows-1}")
data_count_out.close()
