#! /bin/bash

# this script creates the latex file for figures generated by the plot_script.sh

if [ ! -d figure_tex ]
then
  mkdir figure_tex
fi

if [ ! -d statistics_tex ]
then
  mkdir statistics_tex
fi

if [ ! -d temp/subregion_temp ]
then
  mkdir temp/subregion_temp
fi


rm figure_tex/*
rm statistics_tex/*
rm temp/subregion_temp/*

rm temp/subregions.txt

for region in $(cat ../regions/region_list.txt)
do

	region_space=$(echo ${region} | sed 's/_/ /g')

	number_locations=$(wc -l < ../regions/${region}/location_list.txt)
	

	for counter in $(seq 1 ${number_locations} )
	do
		location=$(awk -v line=${counter} --field-separator '\t' '{if (NR==line) {print $1}}' ../regions/${region}/location_list.txt)
		subregion=$(awk -v line=${counter} --field-separator '\t' '{if (NR==line) {print $2}}' ../regions/${region}/location_list.txt)

		if [ -d ../regions/${region}/${location} ]
		then

			stats=$(cat statistics/${subregion}_${location}.txt | tr '\n' ' ')

			echo ${location} ${stats} >> temp/subregion_temp/${subregion}.txt

			echo -e "${region}\t${subregion}" >> temp/subregions.txt

			subregion_space=$(echo ${subregion} | sed 's/_/ /g')
			location_space=$(echo ${location} | sed 's/_/ /g')

			if [ ! -f figure_tex/${subregion}.tex ]
			then
				cat << END_CAT > figure_tex/${subregion}.tex 
\subsection{${subregion_space}}

References for the data used in each location.

END_CAT


			fi

			plot=plots/${region}_${location}.pdf

			data_file="../regions/${region}/${location}/${location}.txt"

			# extract references


			awk --field-separator '\t'  '{if(NR > 1 && $16 != "tocome") print $16}' ${data_file} | sed 's/,/\n/g' > temp/references.txt

			sort temp/references.txt > temp/references2.txt

			awk 'BEGIN {last="FFF"; collect=""} {if ($1 != last) {if(collect == "") {collect=$1} else {collect=collect","$1}}; last = $1} END {print collect}' temp/references2.txt > temp/references3.txt



			cat << END_CAT >> figure_tex/${subregion}.tex 

\textbf{${location_space}}: \citet{$(cat temp/references3.txt)}

END_CAT


			# now make the file for the figures


			cat << END_CAT >> figure_tex/${subregion}_figures.tex 
\clearpage

\begin{figure}[t]
\includegraphics[width=\textwidth]{${plot}}
\caption{Paleo-sea level and comparison of six models for subregion ${subregion_space}, location ${location_space}.}
\label{fig:${location}}
\end{figure}

END_CAT
							#do # dummy to fix highlighting
		fi

	done

done

###################
# make summary file
###################

rm figure_tex/summary.tex

sort temp/subregions.txt > temp/subregions2.txt

awk 'BEGIN {region = ""; subregion = ""} {if ($2 != subregion) {print $1, $2}; region = $1; subregion = $2}' temp/subregions2.txt > temp/subregions3.txt

number_subregions=$(wc -l < temp/subregions3.txt)

current_region="dummy"

for counter in $(seq 1 ${number_subregions} )
do
	region=$(awk -v line=${counter} '{if (NR==line) {print $1}}' temp/subregions3.txt)
	region_space=$(echo ${region} | sed 's/_/ /g')
	subregion=$(awk -v line=${counter} '{if (NR==line) {print $2}}' temp/subregions3.txt)
	subregion_space=$(echo ${subregion} | sed 's/_/ /g')

	if [ "${region}" != "${current_region}" ]
	then

		cat << END_CAT >> figure_tex/summary.tex

\clearpage

\section{${region_space}}

END_CAT



		cat << END_CAT >> statistics_tex/summary.tex

\clearpage

\subsection{${region_space}}

END_CAT

	current_region=${region}

	fi

	if [ $counter -gt 1 ]
	then
		cat << END_CAT >> figure_tex/summary.tex

\clearpage

END_CAT

	fi

	cat figure_tex/${subregion}.tex >> figure_tex/summary.tex
	cat figure_tex/${subregion}_figures.tex >> figure_tex/summary.tex


	# create statistics table

	line1="& \tiny $(awk '{if (NR == 1) print $1}' temp/compare_models.txt)  & \tiny $(awk '{if (NR == 2) print $1}' temp/compare_models.txt)  & \tiny $(awk '{if (NR == 3) print $1}' temp/compare_models.txt)  & \tiny $(awk '{if (NR == 4) print $1}' temp/compare_models.txt)   & \tiny $(awk '{if (NR == 5) print $1}' temp/compare_models.txt)   & \tiny $(awk '{if (NR == 6) print $1}' temp/compare_models.txt)"

	line1a=$( echo ${line1} | sed 's/_/\\textunderscore{}/g')

	line2="& $(awk '{if (NR == 1) print $2}' temp/compare_models.txt)  & $(awk '{if (NR == 2) print $2}' temp/compare_models.txt)  & $(awk '{if (NR == 3) print $2}' temp/compare_models.txt)  & $(awk '{if (NR == 4) print $2}' temp/compare_models.txt)   & $(awk '{if (NR == 5) print $2}' temp/compare_models.txt)   & $(awk '{if (NR == 6) print $2}' temp/compare_models.txt)"

#
	cat << END_CAT > temp/table.tex

\begin{table}[h]
\caption{Number of data points and model scores for ${subregion_space} }

\begin{scriptsize}

\begin{tabularx}{\textwidth}{ p{2cm} r r r r r r r r r r }
\hline
Location & number & marine & terrestrial & index ${line1a} \\\\
 & data & limiting & limiting & point ${line2} \\\\
\hline

END_CAT

			# do 
			# done

	awk '{sum2 += $2; sum3 += $3; sum4 += $4; sum5 += $5; sum6 += $6; sum7 += $7; sum8 += $8; sum9 += $9; sum10 += $10; sum11 += $11; } END {print "Total & ", sum2, "& ", sum3, "& ", sum4, "& ", sum5, "& ", sum6, "& ", sum7, "& ", sum8, "& ", sum9, "& ", sum10, "& ", sum11, "\\\\" }' temp/subregion_temp/${subregion}.txt | sed 's/_/ /g' >> temp/table.tex

	awk '{print $1, "& ", $2, "& ", $3, "& ", $4, "& ", $5, "& ", $6, "& ", $7, "& ", $8, "& ", $9, "& ", $10, "& ", $11, "\\\\"}'  temp/subregion_temp/${subregion}.txt | sed 's/_/ /g' >> temp/table.tex

	cat << END_CAT >> temp/table.tex

\hline

\end{tabularx}
\end{scriptsize}
\end{table}

END_CAT

	cat temp/table.tex >> statistics_tex/summary.tex

done

# create tex file with Ice and Earth model parameters
awk '{print $1}' temp/compare_models.txt > temp/ice_models.txt

sort temp/ice_models.txt > temp/ice_models2.txt

awk 'BEGIN {last="FFF"; collect=""} {if ($1 != last) {print $1}; last = $1}' temp/ice_models2.txt > temp/ice_models3.txt

cat << END_CAT > temp/ice_models.tex

END_CAT

for model in $(cat temp/ice_models3.txt)
do

	cat ice_models/${model} >> temp/ice_models.tex
	echo " " >> temp/ice_models.tex


done


awk '{print $2}' temp/compare_models.txt > temp/earth_models.txt

sort temp/earth_models.txt > temp/earth_models2.txt

awk 'BEGIN {last="FFF"; collect=""} {if ($1 != last) {print $1}; last = $1}' temp/earth_models2.txt > temp/earth_models3.txt

cat << END_CAT > temp/earth_models.tex

END_CAT


for model in $(cat temp/earth_models3.txt)
do

	cat earth_models/${model} >> temp/earth_models.tex
	echo " " >> temp/earth_models.tex


done

