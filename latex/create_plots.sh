#! /bin/bash

# This uses GMT, so make sure it is installed first!

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


rm temp/map_plot_dimensions.txt

# This is where you modify the script to change the calculated sea level, using six different ice sheet/Earth model 
# combinations. These are placed in the "calculated_sea_level" folder. Look at the readme in that folder.


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

rm temp/map_plot_dimensions.txt

for region in $(cat ../regions/region_list.txt)
do

	number_locations=$(wc -l < ../regions/${region}/location_list.txt)
	

	for counter in $(seq 1 ${number_locations} )
	do
		location=$(awk -v line=${counter} --field-separator '\t' '{if (NR==line) {print $1}}' ../regions/${region}/location_list.txt)
		subregion=$(awk -v line=${counter} --field-separator '\t' '{if (NR==line) {print $2}}' ../regions/${region}/location_list.txt)
		source plot_script.sh ${region} ${location} ${reference_ice_model} ${reference_earth_model} ${subregion}

	done



done
