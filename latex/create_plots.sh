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


rm temp/map_plot_dimensions.txt

for region in $(cat ../regions/region_list.txt)
do

	number_locations=$(wc -l < ../regions/${region}/location_list.txt)
	

	for counter in $(seq 1 ${number_locations} )
	do
		location=$(awk -v line=${counter} --field-separator '\t' '{if (NR==line) {print $1}}' ../regions/${region}/location_list.txt)

		source plot_script.sh ${region} ${location}

	done



done
