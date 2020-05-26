#! /bin/bash


# temporary for testing

region=$1
location=$2

input_file="../regions/${region}/${location}/${location}.txt"
output_file="../regions/${region}/${location}/calibrated.txt"
rm ${output_file}

output_folder=priors

mkdir $output_folder

rm test_file.txt

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


# find number of lines in the file

number_lines=$(wc -l < ${input_file})

for counter in $( seq 2 ${number_lines})
do


	counter=$(echo $counter - 1 | bc)
	echo "Analysis: " $counter
	awk -v line=${counter} '{if (NR == line) {print $0}}' ${input_file} > temp


	sample_code=$(awk --field-separator '\t' '{print $3}' temp)

	latitude=$(awk --field-separator '\t' '{print $4}' temp)

	longitude=$(awk --field-separator '\t' '{print $5}' temp)
	indicator_type=$(awk --field-separator '\t' '{print $12}' temp)
	rsl=$(awk --field-separator '\t' '{print $13}' temp)
	rsl_upper=$(awk --field-separator '\t' '{print $14}' temp)
	rsl_lower=$(awk --field-separator '\t' '{print $14}' temp)
	echo ${sample_code}

	if [ "$(awk --field-separator '\t' '{print $2}' temp)" = "radiocarbon" ]  # calibrate
	then



		age=$(awk --field-separator '\t' '{print $6}' temp)

		error_val=$(awk --field-separator '\t' '{print $7}' temp)

		correction_type=$(awk --field-separator '\t' '{print $6}' temp)


		correction_amount=$(awk --field-separator '\t' '{print $10}' temp)


		correction_error=$(awk --field-separator '\t' '{print $11}' temp)

		cal_curve=$(awk --field-separator '\t' '{print $9}' temp)



		# next, generate the file to be read into OxCal

		if [ "${cal_curve}" = "marine" ] 
		then
			cal_line="Curve(\"${curve_marine}\",\"../bin/${marine}\");"
		elif [ "${cal_curve}" = "terrestrial" ] 
		then
			cal_line="Curve(\"${curve_terrestrial}\",\"../bin/${terrestrial}\");"
		elif [ "${cal_curve}" = "terrestrial_sh" ] 
		then
			cal_line="Curve(\"${curve_terrestrial_sh}\",\"../bin/${terrestrial_sh}\");"
		else

			echo "invalid curve: " ${cal_curve}
			echo "check input file and rerun"
			exit 0
		fi

		if  [  "${cal_curve}" = "marine" ] 
		then
			delta_r="Delta_R(\"correction\", ${correction_amount}, ${correction_error});"
		else
			delta_r=""
		fi


		cat << END_CAT > run.oxcal
 Plot()
 {
	$cal_line
  	${delta_r}
  	R_Date("${sample_code}", ${age}, ${error_val});

 };
END_CAT


		# run oxcal and extract the information from the resulting javascript file

		OxCal/bin/OxCalLinux run.oxcal
	
		perl parse_javascript.pl run.js

		if [ -e ${sample_code}.prior ] 
		then
			echo "${sample_code}: Oxcal successful run"
		else
			echo "${sample_code}: Oxcal did not work"
		fi

		age_output="$(./../Fortran/radiocarbon_statistics ${sample_code})"


		median_age=$(echo ${age_output} | awk '{print $1}')
		age_uncertainty=$(echo ${age_output} | awk '{print $2}')

		# clean up files
		rm run.oxcal ${sample_code}.prior run.js run.log correction.prior run.txt

	else

		median_age=$(awk --field-separator '\t' '{print $6}' temp)
		age_uncertainty=$(awk --field-separator '\t' '{print $7}' temp)

	fi

	echo -e "${sample_code}\t${latitude}\t${longitude}\t${median_age}\t${age_uncertainty}\t${indicator_type}\t${rsl}\t${rsl_upper}\t${rsl_lower}" >> ${output_file}



done
rm temp
