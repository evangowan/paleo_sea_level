#! /bin/bash

# This uses GMT, so make sure it is installed first!

region_input=$1

location=$2

mis=$3

if [ ! -d plots ]
then
  mkdir plots
fi

if [ ! -d temp ]
then
  mkdir temp
fi

if [ ! -d statistics ]
then
  mkdir statistics
fi

if [ -f "temp/map_plot_dimensions.txt" ]
then
	rm temp/map_plot_dimensions.txt
fi

reference_ice_model="72_73_74_75"
reference_earth_model="ehgr"

cat << END_CAT > temp/compare_models.txt
72_73_74_75 ehgA
72_73_74_75 ehgC
72_73_74_75 ehgG
72_73_74_75 ehgk
72_73_74_75 ehgr
72_73_74_75 ehgK
END_CAT

found_region=false
found_location=false

for region in $(cat ../regions/region_list.txt)
do

	if [ "${region}" = "${region_input}" ]
	then

		found_region=true

		number_locations=$(wc -l < ../regions/${region}/location_list.txt)
		

		for counter in $(seq 1 ${number_locations} )
		do
			location_temp=$(awk -v line=${counter} --field-separator '\t' '{if (NR==line) {print $1}}' ../regions/${region}/location_list.txt)

			if [ "${location}" = "${location_temp}" ]
			then

				found_location=true
				subregion=$(awk -v line=${counter} --field-separator '\t' '{if (NR==line) {print $2}}' ../regions/${region}/location_list.txt)
				#source plot_script.sh ${region} ${location} ${reference_ice_model} ${reference_earth_model} ${subregion}
				source plot_script2.sh  ${region}  ${location} ${mis} ${reference_ice_model} ${reference_earth_model} 
			fi

		done



	fi


done


if [ "${found_region}" == "false"  ]
then

		echo "invalid region: ${region_input}"

else
	if [ "${found_location}" == "false"  ]
	then

			echo "invalid location: ${location}"

	fi

fi



