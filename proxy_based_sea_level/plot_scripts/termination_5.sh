#!/bin/bash


#This script is made to compare various reconstructions during Termination 5 and MIS 11 for the 2023 QUIGS meeting

mkdir -p temp

large_font="11p"
small_font="5p"

sl_plot_width=20c
sl_plot_height=8c

min_time=350
max_time=500
min_elevation=-150
max_elevation=50

age_tick=20
age_subtick=10
ytickint=25
ysubtickint=12.5

xtext="Age (kyr BP)"
ytext="Relative Sea Level (m)"

J_sl_plot="-JX-${sl_plot_width}/${sl_plot_height}"
R_sl_plot="-R${min_time}/${max_time}/${min_elevation}/${max_elevation}"


# text options for the region name
size="11p"
fontname="Helvetica-Bold"
color="black"
#justification="+cTL" # the +c option plots relative to the corners of the map
justification="+jML" # alternatively, plots relative to the location given in the text file
text_angle="+a0"
text_options="-F+f${size},${fontname},${color}${text_angle}${justification} "


gmt begin termination_5 pdf

	# Bintanja

	awk -F'\t' '{print $1/1000, $2}' ../sea_level/Bintanja_etal_2005_model.txt > temp/sl.txt

	gmt plot temp/sl.txt ${R_sl_plot} ${J_sl_plot} -BWSne   -Bxa"${age_tick}"f"${age_subtick}"+l"${xtext}" -Bya"${ytickint}"f"${ysubtickint}"+l"${ytext}"  --FONT_ANNOT_PRIMARY=${large_font} --FONT_ANNOT_SECONDARY=${small_font} --FONT_LABEL=${large_font} --FONT_TITLE=${large_font} -Wthick,blue

	# Elderfield

	awk -F'\t' '{print $1/1000, $2}' ../sea_level/Elderfield_etal_2012_ODP1123_Pacific_benthic.txt > temp/sl.txt

	gmt plot temp/sl.txt  -Wthick,orange

	# Shakun

	awk -F'\t' '{print $1/1000, $2}' ../sea_level/Shakum_etal_2015_planktic_d18O.txt > temp/sl.txt

	gmt plot temp/sl.txt  -Wthick,green

	# Rohling Med

	awk -F'\t' '{if($1 == ">") {print ">"} else {print $1/1000, $2}}' ../sea_level/Rohling_etal_2014_Mediterranean.txt > temp/sl.txt

	gmt plot temp/sl.txt  -Wthick,purple

	# Sosdian

	awk -F'\t' '{if($1 == ">") {print ">"} else {print $1/1000, $2}}' ../sea_level/Sosdian_Rosenthal_2009_North_Atlantic_benthic_3pt.txt > temp/sl.txt

	gmt plot temp/sl.txt  -Wthick,red

	# SP PCA

	awk -F'\t' '{if($1 == ">") {print ">"} else {print $1/1000, $2}}' ../sea_level/Spratt_Lisiecki_2016_PCA1_long.txt > temp/sl.txt

	gmt plot temp/sl.txt  -W2p,black

	# legend

	x_min=0
	x_max=20
	y_min=0
	y_max=8

	R_legend="-R${x_min}/${x_max}/${y_min}/${y_max}/"
	J_legend="-JX${sl_plot_width}/${sl_plot_height}"

	gmt plot << END_TEXT -Wthick,black ${R_legend} ${J_legend} -Y-9c
1 7 
2 7
END_TEXT

	gmt plot << END_TEXT -Wthick,blue ${R_legend} ${J_legend} 
10 7 
11 7
END_TEXT

	gmt plot << END_TEXT -Wthick,orange ${R_legend} ${J_legend} 
1 6.5 
2 6.5
END_TEXT

	gmt plot << END_TEXT -Wthick,green ${R_legend} ${J_legend} 
10 6.5 
11 6.5
END_TEXT

	gmt plot << END_TEXT -Wthick,purple ${R_legend} ${J_legend} 
1 6
2 6
END_TEXT

	gmt plot << END_TEXT -Wthick,red ${R_legend} ${J_legend} 
10 6
11 6
END_TEXT


	gmt text << END_TEXT  ${text_options} 
2.5 7 Spratt and Lisiecki - PCA
11.5 7 Bintanja et al - Inverse Model
2.5 6.5 Elderfield et al - Pacific benthic d18O
11.5 6.5 Shakun et al - Planktic d18O
2.5 6 Rohling et al - Mediterranean
11.5 6 Sosdian and Rosenthal - Atlantic d18O
END_TEXT

gmt end


min_time=350
max_time=450

age_tick=10
age_subtick=5
ytickint=25
ysubtickint=12.5

xtext="Age (kyr BP)"
ytext="Relative Sea Level (m)"

J_sl_plot="-JX-${sl_plot_width}/${sl_plot_height}"
R_sl_plot="-R${min_time}/${max_time}/${min_elevation}/${max_elevation}"


gmt begin termination_5_short pdf

	# Bintanja

	awk -F'\t' '{if($1 < 431000) print $1/1000, $2}' ../sea_level/Bintanja_etal_2005_model.txt > temp/sl.txt

	gmt plot temp/sl.txt ${R_sl_plot} ${J_sl_plot} -BWSne   -Bxa"${age_tick}"f"${age_subtick}"+l"${xtext}" -Bya"${ytickint}"f"${ysubtickint}"+l"${ytext}"  --FONT_ANNOT_PRIMARY=${large_font} --FONT_ANNOT_SECONDARY=${small_font} --FONT_LABEL=${large_font} --FONT_TITLE=${large_font} -Wthick,blue

	# Elderfield

	awk -F'\t' '{if($1 < 431000) print $1/1000, $2}' ../sea_level/Elderfield_etal_2012_ODP1123_Pacific_benthic.txt > temp/sl.txt

	gmt plot temp/sl.txt  -Wthick,orange

	# Shakun

	awk -F'\t' '{if($1 < 431000) print $1/1000, $2}' ../sea_level/Shakum_etal_2015_planktic_d18O.txt > temp/sl.txt

	gmt plot temp/sl.txt  -Wthick,green

	# Rohling Med

	awk -F'\t' '{if($1 == ">") {print ">"} else {if($1 < 431000)print $1/1000, $2}}' ../sea_level/Rohling_etal_2014_Mediterranean.txt > temp/sl.txt

	gmt plot temp/sl.txt  -Wthick,purple

	# Sosdian

	awk -F'\t' '{if($1 < 431000) print $1/1000, $2}' ../sea_level/Sosdian_Rosenthal_2009_North_Atlantic_benthic_3pt.txt > temp/sl.txt

	gmt plot temp/sl.txt  -Wthick,red

	# Waelbroeck

	awk -F'\t' '{if($1 < 431000) print $1/1000, $2}' ../sea_level/Waelbroeck_etal_2002_d18O.txt > temp/sl.txt

	gmt plot temp/sl.txt  -Wthick,lightblue

	# Red Sea

	awk -F'\t' '{if($1 < 431000) print $1/1000, $2}' ../sea_level/Grant_etal_2014_Red_Sea_composite_data.txt > temp/sl.txt

	gmt plot temp/sl.txt  -Wthick,lightred

	# SP PCA

	awk -F'\t' '{if($1 < 431000) print $1/1000, $2}' ../sea_level/Spratt_Lisiecki_2016_PCA1_short.txt  > temp/sl.txt

	gmt plot temp/sl.txt  -W2p,black

	# legend

	x_min=0
	x_max=20
	y_min=0
	y_max=8

	R_legend="-R${x_min}/${x_max}/${y_min}/${y_max}/"
	J_legend="-JX${sl_plot_width}/${sl_plot_height}"

	gmt plot << END_TEXT -Wthick,black ${R_legend} ${J_legend} -Y-9c
1 7 
2 7
END_TEXT

	gmt plot << END_TEXT -Wthick,blue ${R_legend} ${J_legend} 
10 7 
11 7
END_TEXT

	gmt plot << END_TEXT -Wthick,orange ${R_legend} ${J_legend} 
1 6.5 
2 6.5
END_TEXT

	gmt plot << END_TEXT -Wthick,green ${R_legend} ${J_legend} 
10 6.5 
11 6.5
END_TEXT

	gmt plot << END_TEXT -Wthick,purple ${R_legend} ${J_legend} 
1 6
2 6
END_TEXT

	gmt plot << END_TEXT -Wthick,red ${R_legend} ${J_legend} 
10 6
11 6
END_TEXT

	gmt plot << END_TEXT -Wthick,lightblue ${R_legend} ${J_legend} 
1 5.5
2 5.5
END_TEXT

	gmt plot << END_TEXT -Wthick,lightred ${R_legend} ${J_legend} 
10 5.5
11 5.5
END_TEXT


	gmt text << END_TEXT  ${text_options} 
2.5 7 Spratt and Lisiecki - PCA
11.5 7 Bintanja et al - Inverse Model
2.5 6.5 Elderfield et al - Pacific benthic d18O
11.5 6.5 Shakun et al - Planktic d18O
2.5 6 Rohling et al - Mediterranean
11.5 6 Sosdian and Rosenthal - Atlantic d18O
2.5 5.5 Waelbroeck et al - regression
11.5 5.5 Grant et al - Red Sea
END_TEXT

gmt end




gmt begin termination_5_Rohling_2022 pdf

	# Red Sea

	awk -F'\t' '{ print $1/1000, $2}' ../sea_level/Grant_etal_2014_Red_Sea_composite_data.txt > temp/sl.txt

	gmt plot temp/sl.txt  ${R_sl_plot} ${J_sl_plot} -BWSne   -Bxa"${age_tick}"f"${age_subtick}"+l"${xtext}" -Bya"${ytickint}"f"${ysubtickint}"+l"${ytext}"  --FONT_ANNOT_PRIMARY=${large_font} --FONT_ANNOT_SECONDARY=${small_font} --FONT_LABEL=${large_font} --FONT_TITLE=${large_font} -Wthicker,lightred

	# LR04 original

	awk -F'\t' '{ print $1/1000, $2}' ../sea_level/Rohling_etal_2022_LR04_process_original.txt > temp/sl.txt

	gmt plot temp/sl.txt -Wthick,blue

	# Westerhold original

	awk -F'\t' '{print $1/1000, $2}' ../sea_level/Rohling_etal_2022_Westerhold_process_original.txt > temp/sl.txt

	gmt plot temp/sl.txt  -Wthick,orange

	# LR04 tuned

	awk -F'\t' '{print $1/1000, $2}' ../sea_level/Rohling_etal_2022_LR04_process_tuned.txt > temp/sl.txt

	gmt plot temp/sl.txt  -Wthick,green

	# Westerhold tuned

	awk -F'\t' '{print $1/1000, $2}' ../sea_level/Rohling_etal_2022_Westerhold_process_tuned.txt > temp/sl.txt

	gmt plot temp/sl.txt  -Wthick,purple





	# Sythesis tuned

	awk -F'\t' '{print $1/1000, $2}' ../sea_level/Rohling_etal_2022_synthesis_process_tuned.txt  > temp/sl.txt

	gmt plot temp/sl.txt  -W2p,black

	# legend

	x_min=0
	x_max=20
	y_min=0
	y_max=8

	R_legend="-R${x_min}/${x_max}/${y_min}/${y_max}/"
	J_legend="-JX${sl_plot_width}/${sl_plot_height}"

	gmt plot << END_TEXT -Wthick,black ${R_legend} ${J_legend} -Y-9c
1 7 
2 7
END_TEXT

	gmt plot << END_TEXT -Wthick,blue ${R_legend} ${J_legend} 
12 7 
13 7
END_TEXT

	gmt plot << END_TEXT -Wthick,orange ${R_legend} ${J_legend} 
1 6.5 
2 6.5
END_TEXT

	gmt plot << END_TEXT -Wthick,green ${R_legend} ${J_legend} 
12 6.5 
13 6.5
END_TEXT

	gmt plot << END_TEXT -Wthick,purple ${R_legend} ${J_legend} 
1 6
2 6
END_TEXT

	gmt plot << END_TEXT -Wthick,lightred ${R_legend} ${J_legend} 
12 6
13 6
END_TEXT



	gmt text << END_TEXT  ${text_options} 
2.5 7 Plio-Pleistocene synthesis tuned to Red Sea
13.5 7 LR04 original chronology
2.5 6.5 Westerhold 2020 original chronology
13.5 6.5 LR04 tuned to Red Sea
2.5 6 Westerhold 2020 tuned to Red Sea
13.5 6 Grant et al - Red Sea
END_TEXT

gmt end
