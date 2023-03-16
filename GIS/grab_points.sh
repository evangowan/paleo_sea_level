#! /bin/bash

echo -e "latitude\tlongitude\tregion\tgia_region\tlocation\tlab_id\tindicator_type" > sl_points.txt

for region in $(cat ../sea_level_data/region_list.txt)
do

	number_locations=$(wc -l < ../sea_level_data/${region}/location_list.txt)
	

	for counter in $(seq 1 ${number_locations} )
	do
		location=$(awk -v line=${counter} --field-separator '\t' '{if (NR==line) {print $1}}' ../sea_level_data/${region}/location_list.txt)
		gia_region=$(awk -v line=${counter} --field-separator '\t' '{if (NR==line) {print $2}}' ../sea_level_data/${region}/location_list.txt)
		input_file="../sea_level_data/${region}/${location}/calibrated.txt"

		number_points=$(wc -l < ${input_file})

		for counter2 in $(seq 1 ${number_points} )
		do

			awk -v line=${counter2} '{if (NR == line) {print $0}}' ${input_file} > temp.txt

			sample_code=$(awk --field-separator '\t' '{print $1}' temp.txt)

			latitude=$(awk --field-separator '\t' '{print $2}' temp.txt)

			longitude=$(awk --field-separator '\t' '{print $3}' temp.txt)
			indicator_type=$(awk --field-separator '\t' '{print int($6)}' temp.txt)

			if [ "${indicator_type}" = "-1" ]
			then
				indicator="marine_limiting"
			elif [ "${indicator_type}" = "0" ]
			then
				indicator="index_point"
			elif [ "${indicator_type}" = "1" ]
			then
				indicator="terrestrial_limiting"
			fi

			echo -e "${latitude}\t${longitude}\t${region}\t${gia_region}\t${location}\t${sample_code}\t${indicator}" >> sl_points.txt
		done

	done



done

# for SELEN input
awk  --field-separator '\t'  '{if(NR>1) {print $2, $1}}' sl_points.txt > temp2.txt

sort -k1,1 -k2,2n -u  temp2.txt > test_sl.txt


rm temp.txt  temp2.txt 
