#! /bin/bash

region=$1
location=$2
reference_ice_model=$3
reference_earth_model=$4
mis_stage=$5


if [ ! -d temp ]
then
  mkdir temp
fi

# this limits the "finely resolved" index points versus ones with larger vertical uncertainties
index_limit=10


minimum_colour=deepskyblue
maximum_colour=red
large_index_colour=limegreen@50
small_index_colour=darkgreen@30

echo ${location}


map_plot_width=9
map_plot_height=11
sub_map_plot_width=2

# in km
sub_map_distance=1000

# extract the region bounds and find the central point
gmt convert ../GIS/region_bounds.gmt -Slocation=${location} > temp/region_bound.txt

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

echo ${R_insert}

# text options for the region name
size="12p"
fontname="Helvetica-Bold"
color="black"
justification="+cTL" # the +c option plots relative to the corners of the map
#justification="+jBR" # alternatively, plots relative to the location given in the text file
text_angle="+a0"
text_options="-F+f${size},${fontname},${color}${text_angle}${justification} "


gmt begin test_figure pdf

	gmt subplot begin 1x2 -Fs${map_plot_width}/${map_plot_height} -B



		gmt subplot set
		gmt pscoast ${R_main} ${J_main}   -Df -A10    -Wthinner -Slightgrey 
		gmt basemap  ${R_main} ${J_main} -Bafg -BWSne --MAP_TICK_LENGTH_PRIMARY=-.0c  -LJBL+w${scale_bar_width}k+l"km"+jBL+f+ar+o0.5c -Fl+gwhite --FONT_ANNOT_PRIMARY=6p --FONT_ANNOT_SECONDARY=6p --FONT_LABEL=10p 
		gmt plot temp/region_bound.txt   ${R_main} ${J_main}  -W3p,black -L 
		gmt plot temp/region_bound.txt    ${R_main} ${J_main}  -W2p,yellow -L  

		gmt text << END_TEXT ${R_main} ${J_main} ${text_options}  -Gwhite -D0.1/-0.25 -N 
$(echo ${location} | sed -e 's/_/ /g')
END_TEXT


		gmt inset begin -DjTR+w${sub_map_plot_width}c/${sub_map_plot_width}c 
			gmt coast  ${R_insert} ${J_insert}  -Di -Na -Slightgrey  -A100 -Wfaint -N1 --MAP_FRAME_PEN=1p,red --MAP_TICK_LENGTH_PRIMARY=-.0c -Bwens+gwhite  -B20
	#		gmt plot temp/region_bound.txt -Gyellow    ${R_insert} ${J_insert}   -Wblack -L 
			gmt plot -Gyellow -Ss0.25 -W1p,black ${R_insert} ${J_insert} << ENDCAT
${center_longitude} ${center_latitude}
ENDCAT
		gmt inset end


		gmt subplot set
		gmt plot -JX5 -R0/1/0/1  -Gyellow -BneSW -Ss0.25 -W1p,black   << ENDCAT
0.5 0.5
ENDCAT




	gmt subplot end

gmt end

exit 0

# center point for US based Lambert azimuthal projection (EPSG 2163)
center_longitude=
center_latitude=

# corners of the main plot with the locations of the data
bottom_long=
bottom_lat=
top_long=
top_lat=


# corners for the inset map
small_west_latitude=
small_west_longitude=
small_east_latitude=
small_east_longitude=

# location of where the scale bar is plotted. 
scale_bar_lat=
scale_bar_long=
# this is the latitude where it measures the width of the scale bar
scale_bar_reference_lat=
# width is in km
scale_bar_width=
