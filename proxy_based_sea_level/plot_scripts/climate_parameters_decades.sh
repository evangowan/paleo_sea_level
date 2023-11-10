#! /bin/bash

fortran_compiler=gfortran

#${fortran_compiler} -o misbox misbox.f90

# text options for the region name
size="12p"
fontname="Helvetica-Bold"
color="black"
justification="+cBL" # the +c option plots relative to the corners of the map
#justification="+jBR" # alternatively, plots relative to the location given in the text file
text_angle="+a0"
text_options="-F+f${size},${fontname},${color}${justification}${text_angle} "





# tc plot

xmin=-200
xmax=2000

width="24c"
height="5.5c"



axis_options=" --MAP_LABEL_MODE=axis/axis --MAP_LABEL_OFFSET=0.8c/1.2c "



#./misbox ${ymin} ${ymax}

gmt begin climate_parameters_decades pdf,png

	# LR04
	ymin=3
	ymax=5.5

	J_options="-JX-${width}/-${height}"

	R_options="-R${xmin}/${xmax}/${ymin}/${ymax}"

    awk -v ymin=${ymin} -v ymax=${ymax} 'BEGIN{counter=1}{if (counter==NR) {printf "%s\n%i %4.1f\n%i %4.1f\n%i %4.1f\n%i %4.1f\n", ">",$1, ymax, $2, ymax, $2, ymin, $1, ymin; counter = counter + 2 } }' ../age_boundaries/lr04_MIS.txt > temp/warm_mis.txt

    awk -v ymin=${ymin} -v ymax=${ymax} 'BEGIN{counter=2}{if (counter==NR) {printf "%s\n%i %4.1f\n%i %4.1f\n%i %4.1f\n%i %4.1f\n", ">",$1, ymax, $2, ymax, $2, ymin, $1, ymin; counter = counter + 2 } }' ../age_boundaries/lr04_MIS.txt > temp/cold_mis.txt



	gmt psxy  temp/warm_mis.txt   -L -Glightred ${J_options} ${R_options}
	gmt psxy  temp/cold_mis.txt   -L -Glightskyblue ${J_options} ${R_options} 

	awk -F'\t' '{print $1, $2}' ../18O/lr04.txt > temp/lr04.txt
	gmt plot temp/lr04.txt  -BWSen -Bxa100f20+l"Age (kyr BP)" -Bya1f0.5+l"benthic @%12%\144@%%@+18@+O"  ${J_options} ${R_options}  -Wthick,black  ${axis_options}



	gmt text << END_TEXT  ${text_options}  -Gwhite -D0.1/0.25 -N 
LR04 benthic stack (Lisiecki and Raymo, 2005)
END_TEXT

# CO2
	ymin=150
	ymax=300

	J_options="-JX-${width}/${height}"

	R_options="-R${xmin}/${xmax}/${ymin}/${ymax}"


	awk -v ymin=${ymin} -v ymax=${ymax} 'BEGIN{counter=1}{if (counter==NR) {printf "%s\n%i %4.1f\n%i %4.1f\n%i %4.1f\n%i %4.1f\n", ">",$1, ymax, $2, ymax, $2, ymin, $1, ymin; counter = counter + 2 } }' ../age_boundaries/lr04_MIS.txt > temp/warm_mis.txt

    awk -v ymin=${ymin} -v ymax=${ymax} 'BEGIN{counter=2}{if (counter==NR) {printf "%s\n%i %4.1f\n%i %4.1f\n%i %4.1f\n%i %4.1f\n", ">",$1, ymax, $2, ymax, $2, ymin, $1, ymin; counter = counter + 2 } }' ../age_boundaries/lr04_MIS.txt > temp/cold_mis.txt



	gmt psxy  temp/warm_mis.txt  -Y${height}  -L -Glightred ${J_options} ${R_options}
	gmt psxy  temp/cold_mis.txt   -L -Glightskyblue ${J_options} ${R_options} 
	awk -F'\t' '{print $1, $2}' ../CO2/Bereiter_etal_2015_Antarctica_Composite.txt > temp/antarctica_CO2.txt
	gmt plot temp/antarctica_CO2.txt  -BWsen  -Bya40f20+l"CO@-2@- (PPM)"    ${J_options} ${R_options} -Wthick,black  ${axis_options}

	gmt text << END_TEXT  ${text_options} -Gwhite -D0.1/0.25 -N 
Antarctica CO@-2@- (Bereiter et al., 2015)
END_TEXT



	# Sea level
	ymin=-150
	ymax=30

	J_options="-JX-${width}/${height}"

	R_options="-R${xmin}/${xmax}/${ymin}/${ymax}"

	awk -v ymin=${ymin} -v ymax=${ymax} 'BEGIN{counter=1}{if (counter==NR) {printf "%s\n%i %4.1f\n%i %4.1f\n%i %4.1f\n%i %4.1f\n", ">",$1, ymax, $2, ymax, $2, ymin, $1, ymin; counter = counter + 2 } }' ../age_boundaries/lr04_MIS.txt > temp/warm_mis.txt

    awk -v ymin=${ymin} -v ymax=${ymax} 'BEGIN{counter=2}{if (counter==NR) {printf "%s\n%i %4.1f\n%i %4.1f\n%i %4.1f\n%i %4.1f\n", ">",$1, ymax, $2, ymax, $2, ymin, $1, ymin; counter = counter + 2 } }' ../age_boundaries/lr04_MIS.txt > temp/cold_mis.txt



	gmt psxy  temp/warm_mis.txt  -Y${height}  -L -Glightred ${J_options} ${R_options}
	gmt psxy  temp/cold_mis.txt   -L -Glightskyblue ${J_options} ${R_options} 

	awk -F'\t' '{print $1, $2}' ../sea_level/Rohling_etal_2022_LR04_process_original.txt > temp/sea_level.txt
	gmt plot temp/sea_level.txt -BWsen  -Bya20f10+l"Relative Sea Level (m)"    ${J_options} ${R_options}   -Wthick,black ${axis_options}
	gmt text << END_TEXT  ${text_options}  -Gwhite -D0.1/0.25 -N
LR04 Process Model Original Chronology (Rohling et al., 2022)
END_TEXT

	# Insolation
	ymin=410
	ymax=560

	J_options="-JX-${width}/${height}"

	R_options="-R${xmin}/${xmax}/${ymin}/${ymax}"

	awk -v ymin=${ymin} -v ymax=${ymax} 'BEGIN{counter=1}{if (counter==NR) {printf "%s\n%i %4.1f\n%i %4.1f\n%i %4.1f\n%i %4.1f\n", ">",$1, ymax, $2, ymax, $2, ymin, $1, ymin; counter = counter + 2 } }' ../age_boundaries/lr04_MIS.txt > temp/warm_mis.txt

    awk -v ymin=${ymin} -v ymax=${ymax} 'BEGIN{counter=2}{if (counter==NR) {printf "%s\n%i %4.1f\n%i %4.1f\n%i %4.1f\n%i %4.1f\n", ">",$1, ymax, $2, ymax, $2, ymin, $1, ymin; counter = counter + 2 } }' ../age_boundaries/lr04_MIS.txt > temp/cold_mis.txt



	gmt psxy  temp/warm_mis.txt  -Y${height}  -L -Glightred ${J_options} ${R_options}
	gmt psxy  temp/cold_mis.txt   -L -Glightskyblue ${J_options} ${R_options} 

	awk -F'\t' '{print $1, $2}' ../insolation/65N_June_21.txt > temp/Daily_insolation65.txt
	gmt plot temp/Daily_insolation65.txt -BWsen  -Bya20f10+l"Insolation 60\260N (W/m@+2@+)"    ${J_options} ${R_options}   -Wthick,black ${axis_options}
	gmt text << END_TEXT  ${text_options}  -Gwhite -D0.1/0.25 -N
Summer Insolation 65\260N
END_TEXT


	awk -v ymin=${ymin} -v ymax=${ymax} 'BEGIN{counter=2} {if (NR==counter){print ($1+$2)/2000, (ymax-ymin)/20+ymin, $3; counter=counter+2} else{print ($1+$2)/2000, 2.5*(ymax-ymin)/20+ymin, $3}}' ../age_boundaries/lr04_MIS.txt > temp/mis_text.txt
	gmt text temp/mis_text.txt  ${J_options} ${R_options} -Y${height}  -Gwhite  -F+f10p,Helvetica,black+jcm

	echo ${xmin} ${xmax} ${ymin} ${ymax} > temp/extremes.txt
	awk '{print ($1+$2)/2, 5*($4-$3)/20+$3, "Marine Isotope Stages (LR04)" }' temp/extremes.txt > temp/mis.txt
	gmt text temp/mis.txt  ${J_options} ${R_options}   -Gwhite  -F+f14p,Helvetica-Bold,black+jcm

gmt end


