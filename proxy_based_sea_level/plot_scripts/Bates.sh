#!/bin/bash


#This script is made to compare various reconstructions during Termination 5 and MIS 11 for the 2023 QUIGS meeting

mkdir -p temp

large_font="11p"
small_font="5p"

sl_plot_width=20c
sl_plot_height=8c


min_elevation=-175
max_elevation=50

age_tick=20
age_subtick=10
ytickint=25
ysubtickint=12.5

xtext="Age (kyr BP)"
ytext="Relative Sea Level (m)"

J_sl_plot="-JX-${sl_plot_width}/${sl_plot_height}"


# text options for the region name
size="11p"
fontname="Helvetica-Bold"
color="black"
#justification="+cTL" # the +c option plots relative to the corners of the map
justification="+jML" # alternatively, plots relative to the location given in the text file
text_angle="+a0"
text_options="-F+f${size},${fontname},${color}${text_angle}${justification} "






for termination in 1 5
do


if [ "${termination}" == "1" ]
then
min_time=0
max_time=160
elif  [ "${termination}" == "5" ]
then

min_time=340
max_time=500
fi


R_sl_plot="-R${min_time}/${max_time}/${min_elevation}/${max_elevation}"

gmt begin Bates_termination_${termination} pdf

	# 

	awk -F'\t' '{print $1/1000, $2}' ../sea_level/Bates_et_al_2014_benthic_d18O_94-607.txt > temp/sl.txt

	gmt plot temp/sl.txt ${R_sl_plot} ${J_sl_plot} -BWSne   -Bxa"${age_tick}"f"${age_subtick}"+l"${xtext}" -Bya"${ytickint}"f"${ysubtickint}"+l"${ytext}"  --FONT_ANNOT_PRIMARY=${large_font} --FONT_ANNOT_SECONDARY=${small_font} --FONT_LABEL=${large_font} --FONT_TITLE=${large_font} -W2p,blue

	# 

	awk -F'\t' '{print $1/1000, $2}' ../sea_level/Bates_et_al_2014_benthic_d18O_108-659.txt > temp/sl.txt

	gmt plot temp/sl.txt  -W2p,orange

	# 

	awk -F'\t' '{print $1/1000, $2}' ../sea_level/Bates_et_al_2014_benthic_d18O_121-758.txt > temp/sl.txt

	gmt plot temp/sl.txt  -W2p,green

	# 

	awk -F'\t'  '{print $1/1000, $2}' ../sea_level/Bates_et_al_2014_benthic_d18O_138-849.txt > temp/sl.txt

	gmt plot temp/sl.txt  -W2p,purple

	# 


	# 

	awk -F'\t'  '{print $1/1000, $2}' ../sea_level/Bates_et_al_2014_benthic_d18O_177-1090.txt > temp/sl.txt

	gmt plot temp/sl.txt  -W2p,black

	awk -F'\t'  '{print $1/1000, $2}' ../sea_level/Bates_et_al_2014_benthic_d18O_181-1123.txt > temp/sl.txt

	gmt plot temp/sl.txt  -W2p,grey


	awk -F'\t'  '{print $1/1000, $2}' ../sea_level/Bates_et_al_2014_benthic_d18O_184-1143.txt > temp/sl.txt

	gmt plot temp/sl.txt  -W2p,gold



	awk -F'\t'  '{print $1/1000, $2}' ../sea_level/Bates_et_al_2014_benthic_d18O_184-1148.txt > temp/sl.txt

	gmt plot temp/sl.txt  -W2p,darkgreen


	awk -F'\t'  '{print $1/1000, $2}' ../sea_level/Bates_et_al_2014_benthic_d18O_composite.txt > temp/sl.txt

	gmt plot temp/sl.txt  -W2p,darkred


	awk -F'\t'  '{print $1/1000, $2}' ../sea_level/Bates_et_al_2014_benthic_d18O_162-980.txt > temp/sl.txt

	gmt plot temp/sl.txt  -W2p,red


	# legend

	x_min=0
	x_max=22
	y_min=0
	y_max=8

	R_legend="-R${x_min}/${x_max}/${y_min}/${y_max}/"
	J_legend="-JX${sl_plot_width}/${sl_plot_height}"

	gmt plot << END_TEXT -W2p,black ${R_legend} ${J_legend} -Y-9c -X-2
1 7 
2 7
END_TEXT

	gmt plot << END_TEXT -W2p,blue ${R_legend} ${J_legend} 
12 7 
13 7
END_TEXT

	gmt plot << END_TEXT -W2p,orange ${R_legend} ${J_legend} 
1 6.5 
2 6.5
END_TEXT

	gmt plot << END_TEXT -W2p,green ${R_legend} ${J_legend} 
12 6.5 
13 6.5
END_TEXT

	gmt plot << END_TEXT -W2p,purple ${R_legend} ${J_legend} 
1 6
2 6
END_TEXT

	gmt plot << END_TEXT -W2p,red ${R_legend} ${J_legend} 
12 6
13 6
END_TEXT


	gmt plot << END_TEXT -W2p,grey ${R_legend} ${J_legend} 
1 5.5
2 5.5
END_TEXT

	gmt plot << END_TEXT -W2p,gold ${R_legend} ${J_legend} 
12 5.5
13 5.5
END_TEXT

	gmt plot << END_TEXT -W2p,darkgreen ${R_legend} ${J_legend} 
1 5
2 5
END_TEXT

	gmt plot << END_TEXT -W2p,darkred ${R_legend} ${J_legend} 
12 5
13 5
END_TEXT


	gmt text << END_TEXT  ${text_options} 
2.5 7 ODP site 177-1090 South Atlantic
13.5 7 DSDP site 94-607 Mid-North Atlantic
2.5 6.5 ODP site 108-659 West Sahara
13.5 6.5 ODP site 121-758 Northeast Indian
2.5 6 ODP site 138-849 Equitorial Pacific
13.5 6  ODP composite site 162-980/981 Ireland
2.5 5.5 ODP site 181-1123 East New Zealand
13.5 5.5 ODP site 184-1143 South South China Sea
2.5 5 ODP site 184-1148 North South China Sea
13.5 5 East Equitorial Pacific Composite
END_TEXT

gmt end

done



