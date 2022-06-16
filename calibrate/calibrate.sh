#! /bin/bash



if [ "$1" == "test" ]
then

mkdir temp_folder

input_file="test/test.txt"
output_file="test/calibrated.txt"

else
region=$1
location=$2

input_file="../regions/${region}/${location}/${location}.txt"
output_file="../regions/${region}/${location}/calibrated.txt"

fi

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

curve_terrestrial="IntCal20"
terrestrial="intcal20.14c"

curve_terrestrial_sh="SHCal20"
terrestrial_sh="shcal20.14c"

curve_marine="Marine20"
marine="marine20.14c"


# find number of lines in the file

number_lines=$(wc -l < ${input_file})

echo ${number_lines}

for counter in $( seq 2 ${number_lines})
do


	counter_m1=$(echo $counter - 1 | bc)
	echo "Analysis: " $counter_m1
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

		cal_curve_temp=$(awk --field-separator '\t' '{print $9}' temp)

		cal_curve=$(echo ${cal_curve_temp} | awk --field-separator ',' '{print $1}' )


		# next, generate the file to be read into OxCal
		cat << END_CAT > run.oxcal
 Plot()
 {
END_CAT

		if [ "${cal_curve}" = "marine" ] 
		then
			cal_line="Curve(\"${curve_marine}\",\"../bin/${marine}\");"
			delta_r="Delta_R(\"correction\", ${correction_amount}, ${correction_error});"

			cat << END_CAT >> run.oxcal
	$cal_line
  	${delta_r}
  	R_Date("${sample_code}", ${age}, ${error_val});
END_CAT

		elif [ "${cal_curve}" = "terrestrial" ] 
		then
			cal_line="Curve(\"${curve_terrestrial}\",\"../bin/${terrestrial}\");"

			cat << END_CAT >> run.oxcal
	$cal_line
  	R_Date("${sample_code}", ${age}, ${error_val});
END_CAT
		elif [ "${cal_curve}" = "terrestrial_sh" ] 
		then
			cal_line="Curve(\"${curve_terrestrial_sh}\",\"../bin/${terrestrial_sh}\");"

			cat << END_CAT >> run.oxcal
	$cal_line
  	R_Date("${sample_code}", ${age}, ${error_val});
END_CAT

		elif [ "${cal_curve}" = "mixed" ] 
		then



			# go back to the original entry. It is expected that it has the terrestrial curve and the percentage that is terrestrial

			cal_curve_terrestrial=$(echo ${cal_curve_temp} | awk --field-separator ',' '{print $2}' )
			fraction_terrestrial=$(echo ${cal_curve_temp} | awk --field-separator ',' '{print $3}' )
			fraction_uncertainty=$(echo ${cal_curve_temp} | awk --field-separator ',' '{if ($4 > 0) {print $4} else {print 0}}' )

			# first calculate the marine portion
			cal_line="Curve(\"${curve_marine}\",\"../bin/${marine}\");"
			delta_r="Delta_R(\"correction\", ${correction_amount}, ${correction_error});"

			cat << END_CAT >> run.oxcal
	$cal_line
  	${delta_r}
  	R_Date("marine_part", ${age}, ${error_val});
END_CAT


			if [ "${cal_curve_terrestrial}" = "terrestrial" ] 
			then

				
				cal_line="Curve(\"${curve_terrestrial}\",\"../bin/${terrestrial}\");"
				terrestrial_name=${curve_terrestrial}

			elif [ "${cal_curve_terrestrial}" = "terrestrial_sh" ] 
			then
				cal_line="Curve(\"${curve_terrestrial_sh}\",\"../bin/${terrestrial_sh}\");"
				terrestrial_name=${curve_terrestrial_sh}
			else
				echo "invalid curve for mixed options: " ${cal_curve_terrestrial}
				echo "check input file and rerun"
				exit 0
			fi

				mix_curve="Mix_Curves(\"Mixed1\",\"correction\",\"${terrestrial_name}\",${fraction_terrestrial},${fraction_uncertainty});"



			cat << END_CAT >> run.oxcal
	${cal_line}
  	R_Date("terrestrial_part", ${age}, ${error_val});
	${mix_curve}
  	R_Date("${sample_code}", ${age}, ${error_val});
END_CAT



		else


			echo "invalid curve: " ${cal_curve}
			echo "check input file and rerun"
			exit 0
		fi






		cat << END_CAT >> run.oxcal
 };
END_CAT


		# run oxcal and extract the information from the resulting javascript file
		echo ${cal_curve}
		OxCal/bin/OxCalLinux run.oxcal
	
		perl parse_javascript.pl run.js

		if [ -e ${sample_code}.prior ] 
		then
			echo "${sample_code}: Oxcal successful run"

		else
			echo "${sample_code}: Oxcal did not work"
			exit 0
		fi

		if  [  "${cal_curve}" = "marine" ] 
		then
			age_output="$(./../Fortran/radiocarbon_statistics ${sample_code}.posterior.prior)"
		else
			age_output="$(./../Fortran/radiocarbon_statistics ${sample_code}.prior)"
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


		if  [  "${cal_curve}" = "marine" ] 
		then
			rm run.oxcal ${sample_code}.prior run.js run.log correction.prior run.txt ${sample_code}.posterior.prior correction.posterior.prior
		elif  [  "${cal_curve}" = "mixed" ] 
		then
			rm run.oxcal ${sample_code}.prior run.js run.log correction.prior run.txt ${sample_code}.posterior.prior correction.posterior.prior terrestrial_part.prior terrestrial_part.posterior.prior Mixed1.prior Mixed1.posterior.prior marine_part.prior marine_part.posterior.prior
		else
			rm run.oxcal ${sample_code}.prior run.js run.log run.txt
		fi

	else

		median_age=$(awk --field-separator '\t' '{print $6}' temp)
		age_uncertainty=$(awk --field-separator '\t' '{print $7*2}' temp) # age will be in 1-sigma, change to two sigma to be the same as radiocarbon

	fi

	echo -e "${sample_code}\t${latitude}\t${longitude}\t${median_age}\t${age_uncertainty}\t${indicator_type}\t${rsl}\t${rsl_upper}\t${rsl_lower}" >> ${output_file}



done
rm temp
