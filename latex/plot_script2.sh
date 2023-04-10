#! /bin/bash

#region=$1
#location=$2
#mis_stage=$3
#reference_ice_model=$4
#reference_earth_model=$5

# this must have the variables region, location
source $1


mkdir -p temp
mkdir -p references
mkdir -p statistics

region_line=$(awk -v region=${region} --field-separator '\t' '{if (region==$1) {print NR}}' ../sea_level_data/region_list.txt)

if [ -z "${region_line}" ]
then
	echo "${region} is not found"
	exit 0
fi



location_line=$(awk -v location=${location} --field-separator '\t' '{if (location==$1) {print NR}}' ../sea_level_data/${region}/location_list.txt)

if [ -z "${location_line}" ]
then
	echo "${location} is not found"
	exit 0
fi



number_locations=$(wc -l < ../sea_level_data/${region}/location_list.txt)

subregion=$(awk -v line=${location_line} --field-separator '\t' '{if (NR==line) {print $2}}' ../sea_level_data/${region}/location_list.txt)
generic_location=$(awk -v line=${location_line} --field-separator '\t' '{if (NR==line) {print $3}}' ../sea_level_data/${region}/location_list.txt)
latex_location=$(awk -v line=${location_line} --field-separator '\t' '{if (NR==line) {print $4}}' ../sea_level_data/${region}/location_list.txt)
gmt_location=$(awk -v line=${location_line} --field-separator '\t' '{if (NR==line) {print $5}}' ../sea_level_data/${region}/location_list.txt )


statistics_file="statistics/${region}_${location}_${mis_stage}.txt"
reference_file="references/${region}_${location}_${mis_stage}.txt"

# this limits the "finely resolved" index points versus ones with larger vertical uncertainties
index_limit=10


minimum_colour=deepskyblue
maximum_colour=red
large_index_colour=limegreen
large_index_transparency="@50"
small_index_colour=darkgreen
small_index_transparency="@30"

echo ${location}


map_plot_width=9
map_plot_height=9
sub_map_plot_width=2

plot_buffer=1

# in km
sub_map_distance=1000

# extract the region bounds and find the central point

# sometimes it is required to substitute the more general location

#awk -v location=${location} '{if($1 == location && $3 != "") {print $3} else {print location}}' ../sea_level_data/${region}/location_list.txt
map_location=$(python3 python/check_region.py ${location} ../sea_level_data/${region}/location_list.txt)



gmt convert ../GIS/region_bounds.gmt -Slocation=${map_location} > temp/region_bound.txt

awk --field-separator='\t' '{if ($1 != ">") print $1, $2}' temp/region_bound.txt > temp/region_bound_nocarrot.txt

python3 python/polygon_center.py temp/region_bound_nocarrot.txt > temp/center_point.sh

source temp/center_point.sh


# I am using a Albers projection with the center defined as above

J_main="-JA${center_longitude}/${center_latitude}/${map_plot_width}c"
J_insert="-JA${center_longitude}/${center_latitude}/${sub_map_plot_width}c"

# Now that the center is defined, the map corners can be determined

gmt mapproject temp/region_bound_nocarrot.txt ${J_main} -C -Fe -R${extreme_west}/${extreme_east}/${extreme_south}/${extreme_north} > temp/region_bound_proj.txt


python3 python/map_corners.py temp/region_bound_proj.txt  ${map_plot_width} ${map_plot_height} ${sub_map_plot_width} > temp/map_corners_proj.txt

gmt mapproject temp/map_corners_proj.txt -I ${J_main} -C -Fe -R${extreme_west}/${extreme_east}/${extreme_south}/${extreme_north} > temp/map_corners.txt

bottom_long=$(awk '{if (NR==2) print $1}' temp/map_corners.txt )
bottom_lat=$(awk '{if (NR==2) print $2}' temp/map_corners.txt )
top_long=$(awk '{if (NR==1) print $1}' temp/map_corners.txt )
top_lat=$(awk '{if (NR==1) print $2}' temp/map_corners.txt )

R_main="-R${bottom_long}/${bottom_lat}/${top_long}/${top_lat}r"

scale_bar_width=$(python3 python/map_scale.py temp/map_corners_proj.txt  ${map_plot_width})

gmt mapproject << ENDCAT -I ${J_main} -C -Fe -R${extreme_west}/${extreme_east}/${extreme_south}/${extreme_north} > temp/sub_map_corners.txt
${sub_map_distance}000 ${sub_map_distance}000
-${sub_map_distance}000 -${sub_map_distance}000
ENDCAT

# corners for the inset map
small_bottom_long=$(awk '{if (NR==2) print $1}' temp/sub_map_corners.txt )
small_bottom_lat=$(awk '{if (NR==2) print $2}' temp/sub_map_corners.txt )
small_top_long=$(awk '{if (NR==1) print $1}' temp/sub_map_corners.txt )
small_top_lat=$(awk '{if (NR==1) print $2}' temp/sub_map_corners.txt )

R_insert="-R${small_bottom_long}/${small_bottom_lat}/${small_top_long}/${small_top_lat}r"


# text options for the region name
size="11p"
fontname="Helvetica-Bold"
color="black"
justification="+cTL" # the +c option plots relative to the corners of the map
#justification="+jBR" # alternatively, plots relative to the location given in the text file
text_angle="+a0"
text_options="-F+f${size},${fontname},${color}${text_angle}${justification} "



# create the indicator point files, and the parameters for the plots


sea_level_file="../sea_level_data/${region}/${location}/calibrated.txt"



marine_limiting_map="temp/marine_limiting_map.txt"
terrestrial_limiting_map="temp/terrestrial_limiting_map.txt"
index_point_small_map="temp/index_point_small_map.txt"
index_point_large_map="temp/index_point_large_map.txt"


marine_limiting_data="temp/marine_limiting_data.txt"
terrestrial_limiting_data="temp/terrestrial_limiting_data.txt"
index_point_small_data="temp/index_point_small_data.txt"
index_point_large_data="temp/index_point_large_data.txt"

if [ -f "${marine_limiting_map}" ]
then
	rm ${marine_limiting_map}
fi

if [ -f "${marine_limiting_map}" ]
then
	rm ${terrestrial_limiting_map}
fi

if [ -f "${index_point_small_map}" ]
then
	rm ${index_point_small_map}
fi

if [ -f "${index_point_large_map}" ]
then
	rm ${index_point_large_map}
fi

if [ -f "${marine_limiting_data}" ]
then
	rm ${marine_limiting_data}
fi


if [ -f "${terrestrial_limiting_data}" ]
then
	rm ${terrestrial_limiting_data}
fi

if [ -f "${index_point_small_data}" ]
then
	rm ${index_point_small_data}
fi

if [ -f "${index_point_large_data}" ]
then
	rm ${index_point_large_data}
fi


sl_plot_width=${map_plot_width}
sl_plot_height=${map_plot_height}


python3 python/sea_level_indicator_types.py ${sea_level_file} ${index_limit} ${mis_stage} ${sl_plot_height} > temp/sl_plot_options.sh



source temp/sl_plot_options.sh


J_sl_plot="-JX-${sl_plot_width}/${elevation_plot_height}"
R_sl_plot="-R${min_time}/${max_time}/${min_elevation}/${max_elevation}"


if [ "${data_found}" = "True" ]
then

	mv temp/references.txt ${reference_file}

gmt begin plots/${region}_${location}_${mis_stage} pdf


	gmt subplot begin 1x2 -Y20c -Fs${map_plot_width}/${map_plot_height} -B -M${plot_buffer}c



		gmt subplot set
		gmt pscoast ${R_main} ${J_main}   -Df -A10    -Wthinner -Slightgrey 
		gmt basemap  ${R_main} ${J_main} -Bafg -BWSne --MAP_TICK_LENGTH_PRIMARY=-.0c  -LJBL+w${scale_bar_width}k+l"km"+jBL+f+ar+o0.5c -Fl+gwhite --FONT_ANNOT_PRIMARY=6p --FONT_ANNOT_SECONDARY=6p --FONT_LABEL=10p 
		gmt plot temp/region_bound.txt   ${R_main} ${J_main}  -W3p,black -L 
		gmt plot temp/region_bound.txt    ${R_main} ${J_main}  -W2p,yellow -L  

		if [ -z "${gmt_location}" ]
		then
			plot_location=$(echo ${location} | sed -e 's/_/ /g')
		else
			plot_location=$(echo ${gmt_location} | sed -e 's/_/ /g')
		fi

		gmt text << END_TEXT ${R_main} ${J_main} ${text_options}  -Gwhite -D0.1/-0.15 -N 
${plot_location}
END_TEXT


		# plot the points

		if [ -f "${terrestrial_limiting_map}" ]
		then
			symbol_size=0.30
			gmt plot ${terrestrial_limiting_map}  -G${maximum_colour}   ${R_main} ${J_main} -Si${symbol_size} -Wblack
		fi

		if [ -f "${marine_limiting_map}" ]
		then
			symbol_size=0.30
			gmt plot ${marine_limiting_map}  -G${minimum_colour}  ${R_main} ${J_main} -St${symbol_size} -Wblack
		fi

		if [ -f "${index_point_large_map}" ]
		then
			symbol_size=0.25
			gmt plot ${index_point_large_map}  -G${large_index_colour}  ${R_main} ${J_main} -Ss${symbol_size} -W0.5p,black
		fi

		if [ -f "${index_point_small_map}" ]
		then
			symbol_size=0.25
			gmt plot ${index_point_small_map}  -G${small_index_colour}  ${R_main} ${J_main} -Ss${symbol_size} -W0.5p,black
		fi


		gmt inset begin -DjTR+w${sub_map_plot_width}c/${sub_map_plot_width}c 
			gmt coast  ${R_insert} ${J_insert}  -Di -Na -Slightgrey  -A500 -Wfaint -N1 --MAP_FRAME_PEN=2p,red --MAP_TICK_LENGTH_PRIMARY=-.0c -Bwens+gwhite  -B20
	#		gmt plot temp/region_bound.txt -Gyellow    ${R_insert} ${J_insert}   -Wblack -L 
			gmt plot -Gyellow -Ss0.25 -W1p,black ${R_insert} ${J_insert} << ENDCAT
${center_longitude} ${center_latitude}
ENDCAT
		gmt inset end


		gmt subplot set 

		xtext="Age (kyr BP)"
		ytext="Elevation (m)"
		gmt basemap ${J_sl_plot} ${R_sl_plot} -BneSW  -Bxa"${age_tick}"f"${age_subtick}"+l"${xtext}" -Bya"${ytickint}"f"${ysubtickint}"+l"${ytext}" --FONT_ANNOT_PRIMARY=10p --FONT_ANNOT_SECONDARY=8p --FONT_LABEL=12p --FONT_TITLE=10p 

		symbol_size=0.20
		if [ -f "${terrestrial_limiting_data}" ]
		then
			symbol_size=0.30
			gmt plot ${terrestrial_limiting_data} ${J_sl_plot} ${R_sl_plot}  -Exy+p0.1p,darkgrey+a -G${maximum_colour} -Si${symbol_size} -Wblack
			gmt plot ${terrestrial_limiting_data} ${J_sl_plot} ${R_sl_plot}  -G${maximum_colour} -Si${symbol_size} -Wblack
		fi

		if [ -f "${marine_limiting_data}" ]
		then
			symbol_size=0.3
			gmt plot ${marine_limiting_data} ${J_sl_plot} ${R_sl_plot}  -Exy+p0.1p,darkgrey+a -G${minimum_colour}  -St${symbol_size} -Wblack
			gmt plot ${marine_limiting_data} ${J_sl_plot} ${R_sl_plot}  -G${minimum_colour}  -St${symbol_size} -Wblack
		fi

		if [ -f "${index_point_large_data}" ]
		then

			python3 python/rectangle_convert.py ${index_point_large_data} ${sl_plot_width} ${elevation_plot_height} ${min_time} ${max_time} ${min_elevation} ${max_elevation}

			gmt plot temp/converted_rectangle.txt ${J_sl_plot} ${R_sl_plot}  -Sr -W0.25p,black -G${large_index_colour}${large_index_transparency}

		fi

		if [ -f "${index_point_small_data}" ]
		then

			python3 python/rectangle_convert.py ${index_point_small_data} ${sl_plot_width} ${elevation_plot_height} ${min_time} ${max_time} ${min_elevation} ${max_elevation}

			gmt plot temp/converted_rectangle.txt ${J_sl_plot} ${R_sl_plot} -Sr -W0.25p,black -G${small_index_colour}${small_index_transparency}

		fi

		# plot calculated curves:

		if [ -n "${reference_ice_model}" ]
		then

			rm temp/calc_sl_curves.txt

			python3 python/extract_calc_sea_level.py calculated_sea_level/${reference_ice_model}/${reference_earth_model}.dat ${sea_level_file} ${mis_stage}

			gmt plot temp/calc_sl_curves.txt -Wthinnest,black  ${J_sl_plot} ${R_sl_plot}

			score=$(awk '{print $1}' temp/score.txt)

			gmt text << END ${J_sl_plot} ${R_sl_plot} -F+f10p,Helvetica,black,+cTR -D-0.2/-0.2 -Gwhite
Score: ${score}
END

		fi

		# number of data points

		gmt text << END -F+f10p,Helvetica,black,+cBL -D0.2/0.2 -Gwhite 
\# samples: ${number_data_points}
END

		echo ${number_data_points} >  ${statistics_file}
		echo ${number_marine_limiting} >>  ${statistics_file}
		echo ${number_terrestrial_limiting} >>  ${statistics_file}
		echo ${number_index_points} >>  ${statistics_file}


	gmt subplot end

	legend_y_shift=-2
	legend_height=2
	legend_width=$(echo "${map_plot_width} * 2 + ${plot_buffer} * 2" | bc)
	reference_x=$(echo "${legend_width} - 0.25" | bc )

	J_legend="-JX${legend_width}c/${legend_height}c"
	R_legend="-R0/${legend_width}/0/${legend_height}"

	symbol_size=0.25

	top_position=1.0
	bottom_position=0.5

	left_position=0.2
	right_position=4

	text_buffer=0.3

	left_text=$(echo "${left_position} + ${text_buffer}" | bc )
	right_text=$(echo "${right_position} + ${text_buffer}" | bc )

	heading_x=1.9
	heading_y=1.5



	gmt plot << END -Y${legend_y_shift}c ${J_legend} ${R_legend}  -G${minimum_colour} -St${symbol_size} -Wblack
${left_position} ${top_position}
END

	gmt plot << END  ${J_legend} ${R_legend} -G${maximum_colour} -Si${symbol_size} -Wblack
${right_position} ${top_position}
END


	gmt plot << END   ${J_legend} ${R_legend} -Ss${symbol_size} -W0.5p,black -Gdarkgreen 
${left_position} ${bottom_position}
END


	gmt plot << END  ${J_legend} ${R_legend}  -Ss${symbol_size} -W0.5p,black -Glimegreen
${right_position} ${bottom_position}
END

	gmt text << END  ${J_legend} ${R_legend}  -F+f10p,Helvetica+jLM+a0 
${left_text} ${top_position} Marine Limiting
${right_text} ${top_position} Terrestrial Limiting
${left_text} ${bottom_position} Index point (@%12%\243@%%${index_limit}m)
${right_text} ${bottom_position} Index point (>${index_limit}m)
END

	gmt text << END  ${J_legend} ${R_legend}  -F+f10p,Helvetica-Bold+jLM+a0 
${heading_x} ${heading_y} Sea level proxy type
END

	if [ -n "${reference_ice_model}" ]
	then

		gmt text << END  ${J_legend} ${R_legend} -F+f10p,Helvetica+jRM+a0
${reference_x} ${bottom_position} @_Reference ice model@_: ${reference_ice_model}      @_Reference Earth Model@_: ${reference_earth_model}

END

	fi

	# plot the 6 smaller plots

	if [ -n "${six_models}" ]
	then

	large_font="9p"
	small_font="5p"
	title_offset=2p

	sl_plot_width_small=$(echo ${sl_plot_width} | awk '{print 2.0*$1/3.0}')
	sl_plot_height_small=$(echo ${elevation_plot_height} | awk '{print 2.0*$1/3.0}')
	J_sl_plot_small="-JX-${sl_plot_width_small}/${sl_plot_height_small}"

	map_plot_width_small=$(echo ${map_plot_width} | awk '{print 2.0*$1/3.0}')



	grid_y_shift=-$(echo ${elevation_plot_height} ${sl_plot_height_small} | awk '{print  $2 * 2 + 1.5 }')

	gmt subplot begin 2x3 -M0.1c/0.3c -Y${grid_y_shift}c -X1c -Fs${map_plot_width_small}c/0 -Scb+l"${xtext}" -Srl+l"${ytext}"  ${R_sl_plot} ${J_sl_plot_small} -BWSne   -Bxa"${age_tick}"f"${age_subtick}" -Bya"${ytickint}"f"${ysubtickint}"  --FONT_ANNOT_PRIMARY=${large_font} --FONT_ANNOT_SECONDARY=${small_font} --FONT_LABEL=${large_font} --FONT_TITLE=${large_font} --MAP_TITLE_OFFSET=${title_offset}

		counter=1
		for row in 0 1
		do
			for column in 0 1 2
			do

				
				ice_model=$(awk -v line=${counter} '{if (NR == line) {print $1}}' ${six_models} )
				earth_model=$(awk -v line=${counter} '{if (NR == line) {print $2}}' ${six_models} )


				gmt basemap -B+t"@_IM:@_ ${ice_model}   @_EM:@_ ${earth_model}" -c${row},${column}
				symbol_size=0.20
				if [ -f "${terrestrial_limiting_data}" ]
				then
					symbol_size=0.30
					gmt plot ${terrestrial_limiting_data}   -Exy+p0.1p,darkgrey+a -G${maximum_colour} -Si${symbol_size} -Wblack -c${row},${column}
					gmt plot ${terrestrial_limiting_data}   -G${maximum_colour} -Si${symbol_size} -Wblack -c${row},${column}
				fi

				if [ -f "${marine_limiting_data}" ]
				then
					symbol_size=0.3
					gmt plot ${marine_limiting_data}   -Exy+p0.1p,darkgrey+a -G${minimum_colour}  -St${symbol_size} -Wblack -c${row},${column}
					gmt plot ${marine_limiting_data}   -G${minimum_colour}  -St${symbol_size} -Wblack -c${row},${column}
				fi

				if [ -f "${index_point_large_data}" ]
				then

					python3 python/rectangle_convert.py ${index_point_large_data} ${sl_plot_width_small} ${sl_plot_height_small} ${min_time} ${max_time} ${min_elevation} ${max_elevation}

					gmt plot temp/converted_rectangle.txt  -Sr -W0.25p,black -G${large_index_colour}${large_index_transparency} -c${row},${column}

				fi

				if [ -f "${index_point_small_data}" ]
				then

					python3 python/rectangle_convert.py ${index_point_small_data} ${sl_plot_width_small} ${sl_plot_height_small} ${min_time} ${max_time} ${min_elevation} ${max_elevation}

					gmt plot temp/converted_rectangle.txt -Sr -W0.25p,black -G${small_index_colour}${small_index_transparency} -c${row},${column}

				fi

				# plot calculated curves:

				if [ -f "calculated_sea_level/${ice_model}/${earth_model}.dat" ]
				then
					rm temp/calc_sl_curves.txt

					python3 python/extract_calc_sea_level.py calculated_sea_level/${ice_model}/${earth_model}.dat ${sea_level_file} ${mis_stage}

					if [ -f "temp/calc_sl_curves.txt" ]
					then
						gmt plot temp/calc_sl_curves.txt -Wthinnest,black
					else
						echo "Could not find valid calculated curves in: calculated_sea_level/${ice_model}/${earth_model}.dat"
					fi

					score=$(awk '{print $1}' temp/score.txt)

					gmt text << END  -F+f${large_font},Helvetica,black,+cTR -D-0.2/-0.2 -Gwhite
Score: ${score}
END
					echo ${score} >> ${statistics_file}
				else
					echo "Could not find: calculated_sea_level/${ice_model}/${earth_model}.dat"
					echo "-" >> ${statistics_file}
				fi

				counter=$(echo "${counter} + 1" | bc)

			done
		done
	gmt subplot end

	fi
gmt end

fi

