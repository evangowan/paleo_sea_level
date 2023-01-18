#!/bin/bash

# do a run of all the files

region=$1


awk --field-separator '\t' '{print $1}' ../regions/${region}/location_list.txt > location_temp.txt

for location in $(cat location_temp.txt)
do
	if [ -d ../regions/${region}/${location} ]
	then
		bash calibrate.sh ${region} ${location}
	fi

done

rm location_temp.txt


