#! /bin/bash

# This uses GMT, so make sure it is installed first!

# This is where you modify the script to change the calculated sea level, using six different ice sheet/Earth model 
# combinations. These are placed in the "calculated_sea_level" folder. Look at the readme in that folder.

reference_ice_model="PaleoMIST_1_A_h_E2022"
reference_earth_model="ehgr"


mkdir -p temp

six_models=""




for mis in 'MIS_1-2' 'MIS_3-4' #'MIS_5_a_d' 'MIS_5e' # for now, no MIS 5
do
	for region in $(cat ../sea_level_data/region_list.txt)
	do

		number_locations=$(wc -l < ../sea_level_data/${region}/location_list.txt)
		

		for counter in $(seq 1 ${number_locations} )
		do
			location=$(awk -v line=${counter} --field-separator '\t' '{if (NR==line) {print $1}}' ../sea_level_data/${region}/location_list.txt)


			cat << END_CAT > temp/plot_parameters.sh 
region=${region}
location=${location}
mis_stage=${mis}
reference_ice_model=${reference_ice_model}
reference_earth_model=${reference_earth_model}
six_models=${six_models}
END_CAT



bash plot_script.sh  temp/plot_parameters.sh


		done



	done
done
