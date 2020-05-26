#! /bin/bash

region=$1
location=$2

echo ${location}
# only do the plot if it is the data are available

if [ -d "../regions/${region}/${location}/" ]
then
	plot=plots/${region}_${location}.ps




	sea_level_file="../regions/${region}/${location}/calibrated.txt"

	# plot the map

	xshift=f1
	yshift=f18
	width=9 # map width in cm
	insert_width=$(echo $width | awk '{print $1/4}')

	source ../regions/${region}/${location}/plot_parameters.sh 

	echo ${location} $( mapproject -W ${R_main} ${J_main}) > temp/map_plot_dimensions.txt # try to ensure the map is close to being square

	height=$(mapproject -Wh ${R_main} ${J_main})

	gmt convert ../GIS/region_bounds.gmt -Slocation=${location} > temp/region_bound.txt
	gmt pscoast -X${xshift} -Y${yshift} ${R_main} ${J_main}   -Df   -P  -Wthinner -Slightgrey -K > ${plot}
	gmt psxy temp/region_bound.txt    -P -K -O -J -R  -W2p,black -L   >> ${plot}
	gmt psxy temp/region_bound.txt    -P -K -O -J -R  -Wyellow -L   >> ${plot}

symbol_size=0.30
	awk -F'\t'  '{if ( $6 == "-1" ) {print $3, $2}}' ${sea_level_file} >  temp/marine_limiting.txt

	psxy temp/marine_limiting.txt  -Gblue  -P -K -O -J -R -St${symbol_size} -Wblack >> ${plot}


	awk -F'\t'   '{if ( $6 == "1" ) {print $3, $2} }' ${sea_level_file} >  temp/terrestrial_limiting.txt

	psxy temp/terrestrial_limiting.txt  -Gred  -P -K -O -J -R -Si${symbol_size} -Wblack >> ${plot}

symbol_size=0.25
	awk -F'\t'  '{if ( $6 == "0" ) {print $3, $2} }' ${sea_level_file} >  temp/index_point.txt

	psxy temp/index_point.txt  -Ggreen  -P -K -O -J -R -Sc${symbol_size} -Wblack >> ${plot}


	# text options for the region name
	size="12p"
	fontname="Helvetica-Bold"
	color="black"
	justification="+cTL" # the +c option plots relative to the corners of the map
	#justification="+jBR" # alternatively, plots relative to the location given in the text file
	text_angle="+a0"
	text_options="-F+f${size},${fontname},${color} -F${justification} -F${text_angle} "




	psbasemap  ${R_main} ${J_main} -Bafg -BWSne --MAP_TICK_LENGTH_PRIMARY=-.0c -P -K -O  -Lf${scale_bar_long}/${scale_bar_lat}/${scale_bar_reference_lat}/${scale_bar_width}k+l"km"+jr -F+gwhite --FONT_ANNOT_PRIMARY=10p --FONT_ANNOT_SECONDARY=10p --FONT_LABEL=10p >> ${plot}

	pstext << END_TEXT -K -O -J -R ${text_options} -P -Gwhite -D0.1/-0.25 -N >> ${plot}
$(echo ${location} | sed -e 's/_/ /g')
END_TEXT

# This is the small insert map

	insert_width=$(mapproject -Ww ${R_insert} ${J_insert})
	insert_height=$(mapproject -Wh ${R_insert} ${J_insert})

	if [ ${insert_position} = "br" ]
	then
		x_corner=$( echo ${width} ${insert_width} | awk '{print $1 - $2}')
		y_corner=0
	elif [ ${insert_position} = "tr" ]
	then
		x_corner=$( echo ${width} ${insert_width} | awk '{print $1 - $2}')
		y_corner=$( echo ${height} ${insert_height} | awk '{print $1 - $2}')

	fi


	pscoast -X${x_corner} -Y${y_corner}  ${R_insert} ${J_insert}  -K -O -Di -Na -Slightgrey -P -A300 -Wfaint -N1 --MAP_FRAME_PEN=1p,red --MAP_TICK_LENGTH_PRIMARY=-.0c -Bwens+gwhite  -B20p >> $plot #  -B20p is needed or else no map outline is drawn 


	psxy temp/region_bound.txt -Gyellow   -P -K -O -J -R  -Wblack -L   >> ${plot}

	xshift_now=f3
	yshift_now=f9.5


symbol_size=0.20

	psxy << END -X${xshift_now} -Y${yshift_now} -R0/10/0/1 -JX14c -P -K -O -Gblue -St${symbol_size} -Wblack  >> ${plot}
1 0.5
END

	psxy << END  -R -JX -P -K -O -Gred -Si${symbol_size} -Wblack  >> ${plot}
4 0.5
END

	psxy << END  -R -JX -P -K -O -Ggreen -Sc${symbol_size} -Wblack  >> ${plot}
7 0.5
END


	pstext << END -R -JX -P  -O -F+f10p,Helvetica -F+jLM -F+a0  >> ${plot}
1.5 0.5 Marine Limiting
4.5 0.5 Terrestrial Limiting
7.5 0.5 Index Point
END
fi
