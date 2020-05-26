#!/bin/bash

# do a run of all the files

for region in $(cat ../regions/region_list.txt)
do

	awk --field-separator '\t' '{print $1}' ../regions/${region}/location_list.txt > location_temp.txt

	for location in $(cat location_temp.txt)
	do
		if [ -d ../regions/${region}/${location} ]
		then
			bash calibrate.sh ${region} ${location}
		fi

	done

rm location_temp.txt

done
