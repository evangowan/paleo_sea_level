#! /bin/bash

region=$1
location=$2
reference_ice_model=$3
reference_earth_model=$4
subregion=$5

# this limits the "finely resolved" index points versus ones with larger vertical uncertainties
index_limit=10


minimum_colour=deepskyblue
maximum_colour=red
large_index_colour=limegreen@50
small_index_colour=darkgreen@30

echo ${location}
# only do the plot if it is the data are available

if [ -d "../sea_level_data/${region}/${location}/" ]
then
	plot=plots/${region}_${location}.ps




	sea_level_file="../sea_level_data/${region}/${location}/calibrated.txt"

	statistics_file="statistics/${subregion}_${location}.txt"

	#################
	# plot the map
	#################


	xshift=f1
	yshift=f18
	width=9 # map width in cm
	insert_width=$(echo $width | awk '{print $1/4}')

	source ../sea_level_data/${region}/${location}/plot_parameters.sh 

	echo ${location} $(gmt mapproject -W ${R_main} ${J_main}) >> temp/map_plot_dimensions.txt # try to ensure the map is close to being square

	height=$(gmt mapproject -Wh ${R_main} ${J_main})

	gmt convert ../GIS/region_bounds.gmt -Slocation=${location} > temp/region_bound.txt
	gmt pscoast -X${xshift} -Y${yshift} ${R_main} ${J_main}   -Df -A10  -P  -Wthinner -Slightgrey -K > ${plot}




	# text options for the region name
	size="12p"
	fontname="Helvetica-Bold"
	color="black"
	justification="+cTL" # the +c option plots relative to the corners of the map
	#justification="+jBR" # alternatively, plots relative to the location given in the text file
	text_angle="+a0"
	text_options="-F+f${size},${fontname},${color}${text_angle}${justification} "




	gmt psbasemap  ${R_main} ${J_main} -Bafg -BWSne --MAP_TICK_LENGTH_PRIMARY=-.0c -P -K -O -Lg${scale_bar_long}/${scale_bar_lat}+c${scale_bar_reference_lat}+w${scale_bar_width}k+l"km"+jr+f+ar -Fl+gwhite --FONT_ANNOT_PRIMARY=6p --FONT_ANNOT_SECONDARY=6p --FONT_LABEL=10p >> ${plot}


	gmt psxy temp/region_bound.txt    -P -K -O -J -R  -W2p,black -L   >> ${plot}
	gmt psxy temp/region_bound.txt    -P -K -O -J -R  -Wyellow -L   >> ${plot}

symbol_size=0.30
	awk -F'\t'  '{if ( $6 == "-1" ) {print $3, $2}}' ${sea_level_file} >  temp/marine_limiting.txt

	gmt psxy temp/marine_limiting.txt  -G${minimum_colour}  -P -K -O -J -R -St${symbol_size} -Wblack >> ${plot}


	awk -F'\t'   '{if ( $6 == "1" ) {print $3, $2} }' ${sea_level_file} >  temp/terrestrial_limiting.txt

	gmt psxy temp/terrestrial_limiting.txt  -G${maximum_colour}  -P -K -O -J -R -Si${symbol_size} -Wblack >> ${plot}

symbol_size=0.25

	awk -F'\t' -v index_limit=${index_limit}  '{if ( $6 == "0" && $8 + $9 > index_limit  ) {print $3, $2} }' ${sea_level_file} >  temp/index_point.txt

	gmt psxy temp/index_point.txt    -P -K -O -J -R -Ss${symbol_size} -W0.5p,black -Glimegreen >> ${plot}

	awk -F'\t' -v index_limit=${index_limit}  '{if ( $6 == "0" && $8 + $9 <= index_limit  ) {print $3, $2} }' ${sea_level_file} >  temp/index_point.txt

	gmt psxy temp/index_point.txt   -P -K -O -J -R -Ss${symbol_size} -W0.5p,black -Gdarkgreen >> ${plot}

	gmt pstext << END_TEXT -K -O -J -R ${text_options} -P -Gwhite -D0.1/-0.25 -N >> ${plot}
$(echo ${location} | sed -e 's/_/ /g')
END_TEXT

# This is the small insert map

	insert_width=$(gmt mapproject -Ww ${R_insert} ${J_insert})
	insert_height=$(gmt mapproject -Wh ${R_insert} ${J_insert})

	if [ ${insert_position} = "br" ]
	then
		x_corner=$( echo ${width} ${insert_width} | awk '{print $1 - $2}')
		y_corner=0
	elif [ ${insert_position} = "tr" ]
	then
		x_corner=$( echo ${width} ${insert_width} | awk '{print $1 - $2}')
		y_corner=$( echo ${height} ${insert_height} | awk '{print $1 - $2}')
	elif [ ${insert_position} = "bl" ]
	then
		x_corner=0
		y_corner=0
	fi


	gmt pscoast -X${x_corner} -Y${y_corner}  ${R_insert} ${J_insert}  -K -O -Di -Na -Slightgrey -P -A100 -Wfaint -N1 --MAP_FRAME_PEN=1p,red --MAP_TICK_LENGTH_PRIMARY=-.0c -Bwens+gwhite  -B20p >> $plot #  -B20p is needed or else no map outline is drawn 


	gmt psxy temp/region_bound.txt -Gyellow   -P -K -O -J -R  -Wblack -L   >> ${plot}



	###########################
	# plot the sea level data
	###########################

	echo $(wc -l < ${sea_level_file})  | bc >  ${statistics_file}

	awk -F'\t' '{if  ( $6 == "-1" ) {print $4, $7-$8, $5, $5, 0, $8+$9, $1}}' ${sea_level_file} >  temp/minimum.txt

	wc -l < temp/minimum.txt >> ${statistics_file}

	awk -F'\t'  '{if  ( $6 == "1" )  {print $4, $7+$9, $5, $5, $8+$9, 0, $1}}' ${sea_level_file} >  temp/maximum.txt

	wc -l < temp/maximum.txt >> ${statistics_file}

	awk -F'\t'  '{if  ( $6 == "0" ){print $4, $7, $5, $5, $8, $9, $1}}' ${sea_level_file} >  temp/bounded.txt

	wc -l < temp/bounded.txt >> ${statistics_file}

	# find time extremes

	min_time=$(awk -F'\t' 'BEGIN {extreme=100000} {if ( $4 - $5 < extreme) {extreme=$4-$5}} END {if (extreme < 8000) {print 0} else{print int((extreme-2000)/2000)*2000}}' ${sea_level_file})
	max_time=$(awk -F'\t' 'BEGIN {extreme=-100000} {if ( $4 + $5 > extreme) {extreme=$4+$5}} END {print int((extreme+2000)/2000)*2000}' ${sea_level_file})


	min_elevation=$(awk -F'\t' 'BEGIN {extreme=100000} {if ( $7 - ($8+$9) < extreme) {extreme=$7 - ($8+$9)}} END {if(extreme > -1) {print -20} else {print int((extreme-25)/20)*20}}' ${sea_level_file})

	max_elevation=$(awk -F'\t' 'BEGIN {extreme=-100000} {if ($7 + ($8+$9) > extreme) {extreme=$7 + ($8+$9)}} END {if (extreme < 0) {print 20} else {print int((extreme+25)/20)*20}}' ${sea_level_file})

	# scale the axis


	# x-axis width parameters - it will be ${plot_width} cm if the axis is set to ${relative_time}
	plot_max_width=10



	xtext="Age (cal yr BP)"

	time_diff=$(echo "${max_time} - ${min_time}" | bc)
	# prevent really small time axis
	if [ ${time_diff} -lt 4000 ]
	then
		max_time=$(echo "${max_time} + 2000" | bc)
		time_diff=$(echo "${time_diff} + 2000" | bc)
	fi

	if [ ${time_diff} -lt 16000 ]
	then 
		xtickint=2000
		xsubtickint=1000
		relative_time=16000
		x_width=$( echo "scale=3; ${time_diff} / ${relative_time} * ${plot_max_width}" | bc )
	elif [ ${time_diff} -lt 26000 ]
	then
		xtickint=4000
		xsubtickint=2000
		relative_time=30000
		x_width=$( echo "scale=3; ${time_diff} / ${relative_time} * ${plot_max_width}" | bc )
	elif [ ${time_diff} -lt 45000 ]
	then

	min_time=$(awk -F'\t' 'BEGIN {extreme=100000} {if ( $4 - $5 < extreme) {extreme=$4-$5}} END {if (extreme < 8000) {print 0} else{print int((extreme-5000)/5000)*5000}}' ${sea_level_file})
	max_time=$(awk -F'\t' 'BEGIN {extreme=-100000} {if ( $4 + $5 > extreme) {extreme=$4+$5}} END {print int((extreme+5000)/5000)*5000}' ${sea_level_file})
		xtickint=10000
		xsubtickint=5000
		relative_time=50000
		x_width=$( echo "scale=3; ${time_diff} / ${relative_time} * ${plot_max_width}" | bc )
	elif [ ${time_diff} -lt 68000 ]
	then

	min_time=$(awk -F'\t' 'BEGIN {extreme=100000} {if ( $4 - $5 < extreme) {extreme=$4-$5}} END {if (extreme < 8000) {print 0} else{print int((extreme-10000)/10000)*10000}}' ${sea_level_file})
	max_time=$(awk -F'\t' 'BEGIN {extreme=-100000} {if ( $4 + $5 > extreme) {extreme=$4+$5}} END {print int((extreme+10000)/10000)*10000}' ${sea_level_file})
		xtickint=20000
		xsubtickint=5000
		relative_time=90000
		x_width=$( echo "scale=3; ${time_diff} / ${relative_time} * ${plot_max_width}" | bc )
	else

	min_time=$(awk -F'\t' 'BEGIN {extreme=100000} {if ( $4 - $5 < extreme) {extreme=$4-$5}} END {if (extreme < 8000) {print 0} else{print int((extreme-10000)/10000)*10000}}' ${sea_level_file})
	max_time=$(awk -F'\t' 'BEGIN {extreme=-100000} {if ( $4 + $5 > extreme) {extreme=$4+$5}} END {print int((extreme+10000)/10000)*10000}' ${sea_level_file})
		xtickint=20000
		xsubtickint=10000
		relative_time=120000
		x_width=$( echo "scale=3; ${max_time} / ${relative_time} * ${plot_max_width}" | bc )
	fi

	# y-axis height parameters - it will be ${plot_height} cm if the axis is set to ${relative_elevation}
	plot_max_height=9



	ytext="Elevation (m)"

	elevation_diff=$(echo "${max_elevation} - ${min_elevation}" | bc)
	if [ ${elevation_diff} -lt 100 ]
	then
		ytickint=20
		ysubtickint=10
		relative_elevation=100
		y_width=$( echo "scale=3; (${max_elevation}-(${min_elevation})) / ${relative_elevation} * ${plot_max_height}" | bc )
	elif [ ${elevation_diff} -lt 200 ]
	then
		ytickint=40
		ysubtickint=20
		relative_elevation=200
		y_width=$( echo "scale=3; (${max_elevation}-(${min_elevation})) / ${relative_elevation} * ${plot_max_height}" | bc )
	else
		ytickint=50
		ysubtickint=25
		relative_elevation=300
		y_width=$( echo "scale=3; (${max_elevation}-(${min_elevation})) / ${relative_elevation} * ${plot_max_height}" | bc )
	fi


	# ensure the width and height of the index points are above a minimum threshold

	threshold_dim=0.15

	x_threshold=$( echo ${x_width} ${threshold_dim} ${time_diff} | awk '{print $2 / $1 * $3}')
	y_threshold=$( echo ${y_width} ${threshold_dim} ${elevation_diff} | awk '{print $2 / $1 * $3}')

	echo ${x_threshold}  ${y_threshold} 

	xshift=f12
	yshift=f18

	gmt psbasemap -X${xshift} -Y${yshift} -R${min_time}/${max_time}/${min_elevation}/${max_elevation} -JX-${x_width}/${y_width} -Bxa"${xtickint}"f"${xsubtickint}"+l"${xtext}" -Bya"${ytickint}"f"${ysubtickint}"+l"${ytext}"  -BWSne  -P -O -K --FONT_ANNOT_PRIMARY=10p --FONT_ANNOT_SECONDARY=8p --FONT_LABEL=10p --FONT_TITLE=10p >> ${plot}




	symbol_size=0.20
	if [ -e "temp/maximum.txt" ]
	then
		symbol_size=0.30
		gmt psxy temp/maximum.txt  -Exy+p0.1p,darkgrey+a -G${maximum_colour}  -P -K -O -JX -R -Si${symbol_size} -Wblack >> ${plot}
		gmt psxy temp/maximum.txt  -G${maximum_colour}  -P -K -O -JX -R -Si${symbol_size} -Wblack >> ${plot}
	fi

	if [ -e "temp/minimum.txt" ]
	then
		symbol_size=0.3
		gmt psxy temp/minimum.txt  -Exy+p0.1p,darkgrey+a -G${minimum_colour}  -P -K -O -JX -R -St${symbol_size} -Wblack >> ${plot}
		gmt psxy temp/minimum.txt   -G${minimum_colour}  -P -K -O -JX -R -St${symbol_size} -Wblack >> ${plot}
	fi

	if [ -e "temp/bounded.txt" ]
	then

		awk -v plotwidth=${x_width} -v plotheight=${y_width} -v elevdiff=${elevation_diff} -v timediff=${time_diff} -v x_threshold=${threshold_dim} -v y_threshold=${threshold_dim} -v index_limit=${index_limit} '{x_error =2*$3/timediff*plotwidth; if(x_error < x_threshold){x_error=x_threshold}; y_error = 2*$5/elevdiff*plotheight; if(y_error < y_threshold){y_error=y_threshold}; if($5+$6 > index_limit) print $1, $2, x_error,y_error}' temp/bounded.txt > temp/bounded2.txt

	

		gmt psxy temp/bounded2.txt    -P -K -O -J -R -Sr -W0.25p,black -G${large_index_colour} >> ${plot}

		awk -v plotwidth=${x_width} -v plotheight=${y_width} -v elevdiff=${elevation_diff} -v timediff=${time_diff}  -v x_threshold=${threshold_dim} -v y_threshold=${threshold_dim}  -v index_limit=${index_limit} '{x_error =2*$3/timediff*plotwidth; if(x_error < x_threshold){x_error=x_threshold}; y_error = 2*$5/elevdiff*plotheight; if(y_error < y_threshold){y_error=y_threshold}; if($5+$6 <= index_limit) print $1, $2, x_error,y_error}' temp/bounded.txt > temp/bounded2.txt

		gmt psxy temp/bounded2.txt    -P -K -O -J -R -Sr -W0.25p,black -G${small_index_colour} >> ${plot}

#		gmt psxy temp/bounded2.txt    -P -K -O -J -R -Sr  -G${large_index_colour} >> ${plot}


		symbol_size=0.20
#		gmt psxy temp/bounded.txt -Exy+p0.1p,darkgrey+a -Ggreen  -P -K  -O -JX -R -Sc${symbol_size} -Wblack >> ${plot}
#		gmt psxy temp/bounded.txt -Ggreen  -P -K  -O -JX -R -Sc${symbol_size} -Wblack >> ${plot}


	fi

	# now plot the reference calculated sea level

	awk -F'\t'  '{print $1, $3, $2}' ${sea_level_file} >  temp/locations.txt

	./../Fortran/extract_calc_sea_level ${reference_ice_model} ${reference_earth_model}


	if [ -e "temp/region_sl.txt" ]
	then


		gmt psxy temp/region_sl.txt -Wthinnest,black  -P  -O -JX -R -K >> ${plot}


	fi

	samples=$(awk '{print $2}' temp/region_sl_header.txt)
	gmt pstext << END -R -JX -O -K -P -F+f10p,Helvetica,black,+cBR -D-0.2/0.2 -Gwhite >> ${plot}
\# samples: ${samples}
END

	#################
	# plot the legend
	#################

	xshift_now=f-1
	yshift_now=f9.3


symbol_size=0.25

	gmt psxy << END -X${xshift_now} -Y${yshift_now} -R0/10/0/1 -JX14c -P -K -O -G${minimum_colour} -St${symbol_size} -Wblack  >> ${plot}
2.2 0.56
END

	gmt psxy << END  -R -JX -P -K -O -G${maximum_colour} -Si${symbol_size} -Wblack  >> ${plot}
5.2 0.56
END


	gmt psxy << END  -R -JX -P -K -O  -Ss${symbol_size} -W0.5p,black -Gdarkgreen  >> ${plot}
2.2 0.51
END


	gmt psxy << END  -R -JX -P -K -O  -Ss${symbol_size} -W0.5p,black -Glimegreen  >> ${plot}
5.2 0.51
END

	gmt pstext << END -R -JX -P -K -O -F+f10p,Helvetica+jLM+a0  >> ${plot}
2.5 0.56 Marine Limiting
5.5 0.56 Terrestrial Limiting
2.5 0.51 Index point (@%12%\243@%%${index_limit}m)
5.5 0.51 Index point (>${index_limit}m)
END

	xshift_now=f11
	yshift_now=f15.4

	gmt pstext << END -X${xshift_now} -Y${yshift_now} -R0/10/0/2 -JX10c/2c -P -K -O -F+f10p,Helvetica+jLM+a0  >> ${plot}
1 0.95 @_Reference ice model@_: ${reference_ice_model}
1 0.45 @_Reference Earth Model@_: ${reference_earth_model}

END

	#################
	# plot 6 models
	#################


	# scale the axis


	# x-axis width parameters - it will be ${plot_width} cm if the axis is set to ${relative_time}
	plot_max_width=6



	xtext="Age (cal yr BP)"

	time_diff=$(echo "${max_time} - ${min_time}" | bc)

	if [ ${time_diff} -lt 16000 ]
	then 
		xtickint=2000
		xsubtickint=1000
		relative_time=16000
		x_width=$( echo "scale=3; ${time_diff} / ${relative_time} * ${plot_max_width}" | bc )
	elif [ ${time_diff} -lt 30000 ]
	then
		xtickint=4000
		xsubtickint=2000
		relative_time=30000
		x_width=$( echo "scale=3; ${time_diff} / ${relative_time} * ${plot_max_width}" | bc )
	elif [ ${time_diff} -lt 45000 ]
	then
		xtickint=10000
		xsubtickint=5000
		relative_time=50000
		x_width=$( echo "scale=3; ${time_diff} / ${relative_time} * ${plot_max_width}" | bc )
	elif [ ${time_diff} -lt 68000 ]
	then
		xtickint=20000
		xsubtickint=5000
		relative_time=90000
		x_width=$( echo "scale=3; ${time_diff} / ${relative_time} * ${plot_max_width}" | bc )
	else
		xtickint=20000
		xsubtickint=10000
		relative_time=120000
		x_width=$( echo "scale=3; ${max_time} / ${relative_time} * ${plot_max_width}" | bc )
	fi

	# y-axis height parameters - it will be ${plot_height} cm if the axis is set to ${relative_elevation}
	plot_max_height=5



	ytext="Elevation (m)"

	elevation_diff=$(echo "${max_elevation} - ${min_elevation}" | bc)
	if [ ${elevation_diff} -lt 100 ]
	then
		ytickint=20
		ysubtickint=10
		relative_elevation=100
		y_width=$( echo "scale=3; (${max_elevation}-(${min_elevation})) / ${relative_elevation} * ${plot_max_height}" | bc )
	elif [ ${elevation_diff} -lt 200 ]
	then
		ytickint=20
		ysubtickint=10
		relative_elevation=200
		y_width=$( echo "scale=3; (${max_elevation}-(${min_elevation})) / ${relative_elevation} * ${plot_max_height}" | bc )
	else
		ytickint=50
		ysubtickint=25
		relative_elevation=300
		y_width=$( echo "scale=3; (${max_elevation}-(${min_elevation})) / ${relative_elevation} * ${plot_max_height}" | bc )
	fi



	for model_number in $(seq 1 6)
	do
		ice_model=$(awk -v line=${model_number} '{if (NR == line) {print $1}}' temp/compare_models.txt )
		earth_model=$(awk -v line=${model_number} '{if (NR == line) {print $2}}' temp/compare_models.txt )

		./../Fortran/extract_calc_sea_level ${ice_model} ${earth_model}

		./../Fortran/sl_diff_params2

		large_font="7p"
		small_font="5p"

		y_shift1=$( echo "15 - ${y_width} / 2 - 3" | bc)
		y_shift2=$( echo "15 - ${y_width} / 2 -  ${y_width} - 4.5" | bc)
		title_offset=2p

		if [ "${model_number}" = "1" ]
		then

			xshift=f2
			yshift=f${y_shift1}

			gmt psbasemap -X${xshift} -Y${yshift} -R${min_time}/${max_time}/${min_elevation}/${max_elevation} -JX-${x_width}/${y_width} -Bxa"${xtickint}"f"${xsubtickint}" -Bya"${ytickint}"f"${ysubtickint}"+l"${ytext}"  -BWSne+t"@_IM:@_ ${ice_model}   @_EM:@_ ${earth_model}"  -P -O -K --FONT_ANNOT_PRIMARY=${large_font} --FONT_ANNOT_SECONDARY=${small_font} --FONT_LABEL=${large_font} --FONT_TITLE=${large_font} --MAP_TITLE_OFFSET=${title_offset} >> ${plot}

		elif [ "${model_number}" = "2" ]
		then

			xshift=f8.5
			yshift=f${y_shift1}

			gmt psbasemap -X${xshift} -Y${yshift} -R${min_time}/${max_time}/${min_elevation}/${max_elevation} -JX-${x_width}/${y_width} -Bxa"${xtickint}"f"${xsubtickint}" -Bya"${ytickint}"f"${ysubtickint}"  -BWSne+t"@_IM:@_ ${ice_model}   @_EM:@_ ${earth_model}"  -P -O -K --FONT_ANNOT_PRIMARY=${large_font} --FONT_ANNOT_SECONDARY=${small_font} --FONT_LABEL=${large_font} --FONT_TITLE=${large_font} --MAP_TITLE_OFFSET=${title_offset} >> ${plot}

		elif [ "${model_number}" = "3" ]
		then

			xshift=f15
			yshift=f${y_shift1}

			gmt psbasemap -X${xshift} -Y${yshift} -R${min_time}/${max_time}/${min_elevation}/${max_elevation} -JX-${x_width}/${y_width} -Bxa"${xtickint}"f"${xsubtickint}" -Bya"${ytickint}"f"${ysubtickint}"  -BWSne+t"@_IM:@_ ${ice_model}   @_EM:@_ ${earth_model}"  -P -O -K --FONT_ANNOT_PRIMARY=${large_font} --FONT_ANNOT_SECONDARY=${small_font} --FONT_LABEL=${large_font} --FONT_TITLE=${large_font} --MAP_TITLE_OFFSET=${title_offset} >> ${plot}

		elif [ "${model_number}" = "4" ]
		then

			xshift=f2
			yshift=f${y_shift2}

			gmt psbasemap -X${xshift} -Y${yshift} -R${min_time}/${max_time}/${min_elevation}/${max_elevation} -JX-${x_width}/${y_width} -Bxa"${xtickint}"f"${xsubtickint}"+l"${xtext}" -Bya"${ytickint}"f"${ysubtickint}"+l"${ytext}"  -BWSne+t"@_IM:@_ ${ice_model}   @_EM:@_ ${earth_model}"  -P -O -K --FONT_ANNOT_PRIMARY=${large_font} --FONT_ANNOT_SECONDARY=${small_font} --FONT_LABEL=${large_font} --FONT_TITLE=${large_font} --MAP_TITLE_OFFSET=${title_offset} >> ${plot}

		elif [ "${model_number}" = "5" ]
		then

			xshift=f8.5
			yshift=f${y_shift2}

			gmt psbasemap -X${xshift} -Y${yshift} -R${min_time}/${max_time}/${min_elevation}/${max_elevation} -JX-${x_width}/${y_width} -Bxa"${xtickint}"f"${xsubtickint}"+l"${xtext}" -Bya"${ytickint}"f"${ysubtickint}"  -BWSne+t"@_IM:@_ ${ice_model}   @_EM:@_ ${earth_model}"  -P -O -K --FONT_ANNOT_PRIMARY=${large_font} --FONT_ANNOT_SECONDARY=${small_font} --FONT_LABEL=${large_font} --FONT_TITLE=${large_font} --MAP_TITLE_OFFSET=${title_offset} >> ${plot}

		elif [ "${model_number}" = "6" ]
		then

			xshift=f15
			yshift=f${y_shift2}

			gmt psbasemap -X${xshift} -Y${yshift} -R${min_time}/${max_time}/${min_elevation}/${max_elevation} -JX-${x_width}/${y_width} -Bxa"${xtickint}"f"${xsubtickint}"+l"${xtext}" -Bya"${ytickint}"f"${ysubtickint}"  -BWSne+t"@_IM:@_ ${ice_model}   @_EM:@_ ${earth_model}"  -P -O -K --FONT_ANNOT_PRIMARY=${large_font} --FONT_ANNOT_SECONDARY=${small_font} --FONT_LABEL=${large_font} --FONT_TITLE=${large_font} --MAP_TITLE_OFFSET=${title_offset} >> ${plot}

		fi



		symbol_size=0.20
		if [ -e "temp/maximum.txt" ]
		then
			symbol_size=0.15
			gmt psxy temp/maximum.txt  -Exy+p0.1p,darkgrey+a -G${maximum_colour}  -P -K -O -JX -R -Si${symbol_size} -Wblack >> ${plot}
			gmt psxy temp/maximum.txt  -G${maximum_colour}  -P -K -O -JX -R -Si${symbol_size} -Wblack >> ${plot}
		fi

		if [ -e "temp/minimum.txt" ]
		then
			symbol_size=0.22
			gmt psxy temp/minimum.txt  -Exy+p0.1p,darkgrey+a -G${minimum_colour}  -P -K -O -JX -R -St${symbol_size} -Wblack >> ${plot}
			gmt psxy temp/minimum.txt   -G${minimum_colour}  -P -K -O -JX -R -St${symbol_size} -Wblack >> ${plot}
		fi

		if [ -e "temp/bounded.txt" ]
		then
#			symbol_size=0.15
#			gmt psxy temp/bounded.txt -Exy+p0.1p,darkgrey+a -Ggreen  -P -K  -O -JX -R -Sc${symbol_size} -Wblack >> ${plot}
#			gmt psxy temp/bounded.txt -Ggreen  -P -K  -O -JX -R -Sc${symbol_size} -Wblack >> ${plot}

			awk -v plotwidth=${x_width} -v plotheight=${y_width} -v elevdiff=${elevation_diff} -v timediff=${time_diff} -v x_threshold=${threshold_dim} -v y_threshold=${threshold_dim} -v index_limit=${index_limit} '{x_error =2*$3/timediff*plotwidth; if(x_error < x_threshold){x_error=x_threshold}; y_error = 2*$5/elevdiff*plotheight; if(y_error < y_threshold){y_error=y_threshold}; if($5+$6 > index_limit) print $1, $2, x_error,y_error}' temp/bounded.txt > temp/bounded2.txt

	

			gmt psxy temp/bounded2.txt    -P -K -O -J -R -Sr -W0.25p,black -G${large_index_colour} >> ${plot}

			awk -v plotwidth=${x_width} -v plotheight=${y_width} -v elevdiff=${elevation_diff} -v timediff=${time_diff}  -v x_threshold=${threshold_dim} -v y_threshold=${threshold_dim}  -v index_limit=${index_limit} '{x_error =2*$3/timediff*plotwidth; if(x_error < x_threshold){x_error=x_threshold}; y_error = 2*$5/elevdiff*plotheight; if(y_error < y_threshold){y_error=y_threshold}; if($5+$6 <= index_limit) print $1, $2, x_error,y_error}' temp/bounded.txt > temp/bounded2.txt

			gmt psxy temp/bounded2.txt    -P -K -O -J -R -Sr -W0.25p,black -G${small_index_colour} >> ${plot}
		fi


		if [ -e "temp/region_sl.txt" ]
		then

			gmt psxy temp/region_sl.txt -Wthinnest,black  -P  -O -JX -R -K >> ${plot}


		fi

		score=$(awk '{print $1}' temp/score.txt)

		echo ${score} >> ${statistics_file}

		if [ "${model_number}" = "6" ]
		then

			gmt pstext << END -R -JX -O -P -F+f${large_font},Helvetica,black,+cTR -D-0.2/-0.2 -Gwhite >> ${plot}
Score: ${score}
END

		else

			gmt pstext << END -R -JX -O  -K -P -F+f${large_font},Helvetica,black,+cTR -D-0.2/-0.2 -Gwhite >> ${plot}
Score: ${score}
END

		fi

	done

	gmt psconvert -A -Tf ${plot}

else

	echo could not find ${region}/${location}

fi
