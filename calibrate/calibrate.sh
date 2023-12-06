#! /bin/bash

# need to install pandas_ods_reader prior to running this script
# pip install pandas_ods_reader


mkdir -p temp_folder

rm temp_folder/*

if [ "$1" == "test" ]
then



input_file="test/test.ods"
output_file="test/calibrated.txt"

else
region=$1
location=$2

input_file="../sea_level_data/${region}/${location}/data.ods"
output_file="../sea_level_data/${region}/${location}/calibrated.txt"

fi

python3 python/read_data_file.py ${input_file}

rm ${output_file}

output_folder=priors

mkdir -p $output_folder

if [ -f test_file.txt ]
then
	rm test_file.txt
fi

# using this bash script, you take in a text file (this will be tab delimited), and output everything needed to do the calibration using OxCal
# The text file will be in the format:

# Region	Dating_Method	LAB_ID	Latitude	Longitude	age	error	Material	Curve	Reservoir_age	Reservoir_error	type	RSL	RSL_2sigma_upper	RSL_2sigma_lower	Reference

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

curve_normarine="Normarine18"
normarine="normarine18.14c"


#Check if the Normarine curve is there

# To ensure continuity, I appended the Marine20 curve to Normarine for dates younger than 12200

if [ ! -f OxCal/bin/${normarine} ]
then

cp ${normarine} OxCal/bin/${normarine}

fi


# find number of lines in the file

source temp_folder/number_data.sh

echo ${number_lines}

for counter in $( seq 0 ${number_lines})
do

	# check if the analysis file was created

	echo "Analysis: " $counter

	source temp_folder/data_line_${counter}.sh

	if ${valid_data}
	then

		# run oxcal and extract the information from the resulting javascript file

		if [ -f temp_folder/run_${counter}.oxcal ]
		then

			OxCal/bin/OxCalLinux temp_folder/run_${counter}.oxcal
		
			perl parse_javascript.pl temp_folder/run_${counter}.js

			if [ -e ${sample_code}.prior ] 
			then
				echo "${sample_code}: Oxcal successful run"

			else
				echo "${sample_code}: Oxcal did not work"
				exit 0
			fi

			if  [  "${cal_curve}" = "marine" ] ||  [  "${cal_curve}" = "marine_custom" ] || [  "${cal_curve}" = "corr_terrestrial" ] ||  [  "${cal_curve}" = "corr_terrestrial_sh" ]
			then
#				age_output="$(./../Fortran/radiocarbon_statistics ${sample_code}.posterior.prior)"
				age_output="$(python3 python/radiocarbon_statistics.py ${sample_code}.posterior.prior)"
			else
#				age_output="$(./../Fortran/radiocarbon_statistics ${sample_code}.prior)"
				age_output="$(python3 python/radiocarbon_statistics.py ${sample_code}.prior)"
			fi


			median_age=$(echo ${age_output} | awk '{print $1}')
			age_uncertainty=$(echo ${age_output} | awk '{print $2}')

			if [ "$1" == "test" ]
			then
				mv run.oxcal temp_folder/${sample_code}.oxcal
				mv run.log temp_folder/${sample_code}.log

		        mv ${sample_code}.posterior.prior temp_folder/${sample_code}.posterior.prior
		        mv ${sample_code}.prior temp_folder/${sample_code}.prior

				mv marine_part.prior temp_folder/${sample_code}_marine_part.prior
				mv terrestrial_part.prior temp_folder/${sample_code}_terrestrial_part.prior
		    fi


			# clean up files
			rm *.prior

#			if  [  "${cal_curve}" = "marine" ]  ||  [  "${cal_curve}" = "corr_terrestrial" ] ||  [  "${cal_curve}" = "corr_terrestrial_sh" ]
#			then
#				rm run.oxcal ${sample_code}.prior run.js run.log correction.prior run.txt ${sample_code}.posterior.prior correction.posterior.prior
#			elif  [  "${cal_curve}" = "mixed" ] 
#			then
#				rm run.oxcal ${sample_code}.prior run.js run.log correction.prior run.txt ${sample_code}.posterior.prior correction.posterior.prior terrestrial_part.prior terrestrial_part.posterior.prior Mixed1.prior Mixed1.posterior.prior marine_part.prior marine_part.posterior.prior
#			else
#				rm run.oxcal ${sample_code}.prior run.js run.log run.txt
#			fi

			

		fi

		echo -e "${sample_code}\t${latitude}\t${longitude}\t${median_age}\t${age_uncertainty}\t${indicator_type}\t${rsl}\t${rsl_upper}\t${rsl_lower}\t${references}" >> ${output_file}

	fi

done



