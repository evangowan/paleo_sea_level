#!/bin/bash

# do a run of all the files

region=$1


awk --field-separator '\t' '{print $1}' ../sea_level_data/${region}/location_list.txt > location_temp.txt

for location in $(cat location_temp.txt)
do
	if [ -d ../sea_level_data/${region}/${location} ]
	then
		bash calibrate.sh ${region} ${location}
	fi

done


rm location_temp.txt


