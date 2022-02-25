#! /bin/bash

# This uses GMT, so make sure it is installed first!

region=$1

location=$2

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



for region in $(cat ../regions/region_list.txt)
do

	number_locations=$(wc -l < ../regions/${region}/location_list.txt)
	

	for counter in $(seq 1 ${number_locations} )
	do
		location_temp=$(awk -v line=${counter} --field-separator '\t' '{if (NR==line) {print $1}}' ../regions/${region}/location_list.txt)

		if [ "${location}" = "${location_temp}" ]
		then

			subregion=$(awk -v line=${counter} --field-separator '\t' '{if (NR==line) {print $2}}' ../regions/${region}/location_list.txt)
			source plot_script.sh ${region} ${location} ${reference_ice_model} ${reference_earth_model} ${subregion}

		fi

	done



done
