#!/bin/bash

# do a run of all the files

specific_region=$1

if [ ${specific_region} ]
then
regionlist=${specific_region}
else
regionlist=$(cat ../sea_level_data/region_list.txt)

fi

echo ${regionlist}




for region in ${regionlist}
do

	awk --field-separator '\t' '{print $1}' ../sea_level_data/${region}/location_list.txt > location_temp.txt

	for location in $(cat location_temp.txt)
	do
		if [ -d ../sea_level_data/${region}/${location} ]
		then
			bash calibrate.sh ${region} ${location}
		fi

	done

rm location_temp.txt

done
