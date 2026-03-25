#!/bin/bash



J_options="-JR10/15c"
R_options="-Rg"



circle_size=0.12
circle_size_small=0.09
circle_pen=" -W0.3p,black "


number_of_points=$(awk --field-separator='\t' 'BEGIN {points=0}{if($3 != "Proxy_Based_Sea_Level") points=points+1} END{print points-1}' sl_points.txt)



gmt begin data_map pdf,png A,I+s240p
  gmt coast ${R_options} ${J_options} -Bx60 -By30   -Wfaint,black -Dc -A500 -G210 --FONT_TITLE=16p 

	awk --field-separator='\t' '{print $2, $1}' Locations_to_add.txt > temp_yet.txt
    sort -u temp_yet.txt > points_sort_yet.txt


	gmt plot points_sort_yet.txt  ${circle_pen} -Ss${circle_size_small} -Gyellow

    sort -u test_sl.txt > points_sort.txt
	gmt plot points_sort.txt  ${circle_pen} -Sc${circle_size} -Gred 

    sort -u test_sl_2.1.txt > points_sort_old.txt


    grep -vf points_sort_old.txt  points_sort.txt > diff_file.txt
	gmt plot diff_file.txt  ${circle_pen} -Sc${circle_size} -Ggreen 




	gmt plot << END_CAT -Y-3 -X-3.2   -R0/1/0/1 -JX10/10  ${circle_pen} -Sc${circle_size} -Ggreen
0.3 0.34
END_CAT

	gmt plot << END_CAT  -JX10/10  ${circle_pen} -Sc${circle_size} -Gred
0.3 0.30
END_CAT


	gmt plot << END_CAT  -JX10/10  ${circle_pen} -Ss${circle_size_small} -Gyellow
0.3 0.26
END_CAT


	gmt text << END_CAT     -F+f8p+jBL 
0.33 0.33 New data (version 3.0)
0.33 0.29 Previously entered data
0.33 0.25 Yet to be added
END_CAT


	gmt text << END_CAT   -X11.7   -R0/1/0/1 -JX10/10  -F+f8p+jBL 
0.33 0.33 Number of data points
0.33 0.29 in GAPSLIP: ${number_of_points}
END_CAT

gmt end 
#gmt psconvert  ${plot}  -Tf -A
#gmt psconvert  ${plot}  -Tg -A -I+s240p



mv data_map.png ../data_map.png
