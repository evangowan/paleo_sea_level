#! /bin/bash

# this script creates the latex file for figures generated by the plot_script.sh

if [ -f "temp/figure_parameters.sh" ] 
then

	source temp/figure_parameters.sh

else

	echo "you need to create a temp/figure_parameters.sh with the variable six_models=filename"
	exit 0
fi


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

rm figure_tex/summary.tex

for MIS in 'MIS_1-2' 'MIS_3-4' #'MIS_5_a_d' 'MIS_5e' # for now, no MIS 5
do

if [ -f "temp/subregions.txt" ]
then
rm temp/subregions.txt
fi

if [ "${MIS}" == "MIS_1-2" ]
then
	MIS_header="MIS 1 and 2 (LGM to present)"

	MIS_text="The Holocene (roughly equivalent to MIS 1) spans from 11.65 kyr before present to present. MIS 2 encompasses the Last Glacial Maximum (27-19 kyr BP) and the deglacial period that goes until the end of the Younger Dryas. In general, paleo sea level proxies are abundant in the Holocene, when sea level was within 30 m of present, but are uncommon before that. The lack of proxies older than the Holocene is in a large part due to their inaccessibility (in water to deep for typical coring methods). In most cases, MIS 2 aged sea level proxies are from drowned coral reefs in tropical areas, or in relatively broad continental shelves."
elif [ "${MIS}" == "MIS_3-4" ]
then
	MIS_header="MIS 3 and 4"
	MIS_text="MIS 3 is an interstadial period that stretches between about 55 and 27 kyr before present. MIS 4 is a glacial period when the ice sheets significantly expanded in North America and Europe, between about 70 and 55 kyr. There are few sea level proxies from this time interval for three main reasons. First, such deposits are hard to date, because the material is near or beyond the limits of radiocarbon dating. Second, the geological evidence in many areas was eroded by the subsequent rise in sea level during the MIS 1 and 2 deglaciation. As a result, many of the proxies are only preserved in places where there is a substantial tectonic uplift rate. Third, relative sea level during MIS 3 and 4 likely never exceeded -30 m, so the deposits are likely below the depth limit of most coring survey methods."
elif [ "${MIS}" == "MIS_5_a_d" ]
then
	MIS_header="MIS 5 a-d"
	MIS_text="MIS 5 a-d represents the period between about 115-70 kyr before present. MIS 5d and 5b represent stadial periods, where the northern hemisphere ice sheets expanded, though to what extent is not well constrained. The MIS 5c and 5a periods were interstadial periods where the ice sheets in the Northern Hemisphere, and there was a relative sea level highstand. Exactly how much ice there was in excess of the present amount is not well understood, but it seems unlikely that sea level exceeded present level."
elif [ "${MIS}" == "MIS_5e" ]

then
	MIS_header="MIS 5e (last interglacial)"
	MIS_text="MIS 5e, also known as the last interglacial, was a period of relatively high sea level between 135 and 115 kyr before present. It is very likely that sea level was higher than present during MIS 5e, but how that relates to global sea level is not well constrained. This is in part due to the differences in the MIS 6 glaciation compared to the MIS 5-2 glaciation. It is also probable that the Greenland and Antarctic ice sheet volume was less."
else
	echo "error in MIS stages"
fi

cat << END_CAT >> statistics_tex/summary.tex


\clearpage

\subsection{${MIS_header}}

END_CAT

for region in $(cat ../sea_level_data/region_list.txt)
do

	region_space=$(echo ${region} | sed 's/_/ /g')

	number_locations=$(wc -l < ../sea_level_data/${region}/location_list.txt)
	
	first_region=true

	for counter in $(seq 1 ${number_locations} )
	do
		location=$(awk -v line=${counter} --field-separator '\t' '{if (NR==line) {print $1}}' ../sea_level_data/${region}/location_list.txt)
		subregion=$(awk -v line=${counter} --field-separator '\t' '{if (NR==line) {print $2}}' ../sea_level_data/${region}/location_list.txt)
		latex_location=$(awk -v line=${counter} --field-separator '\t' '{if (NR==line) {print $4}}' ../sea_level_data/${region}/location_list.txt)

		plot=plots/${region}_${location}_${MIS}.pdf


		if [ -f ${plot} ]
		then

			stats=$(cat statistics/${region}_${location}_${MIS}.txt | tr '\n' ' ')

			if [ -z "${latex_location}" ]
			then
				location_space=$(echo ${location} | sed 's/_/ /g')
				location_nospace=${location}

			else
				location_space=$(echo "${latex_location}" | sed 's/_/ /g')
				location_nospace=$(echo "${latex_location}" | sed 's/ /_/g')
			fi

			echo ${location_nospace} ${stats} >> temp/subregion_temp/${subregion}_${MIS}.txt

			echo -e "${region}\t${subregion}" >> temp/subregions.txt

			subregion_space=$(echo ${subregion} | sed 's/_/ /g')


			


			
			if [ ! -f figure_tex/${subregion}_${MIS}.tex ]
			then

				if [ "${first_region}" = false ]
				then

					if [ -z "${six_models}" ]
					then



						cat << END_CAT >> figure_tex/${subregion}_${MIS}.tex 
\FloatBarrier


END_CAT
		

					else

						cat << END_CAT >> figure_tex/${subregion}_${MIS}.tex 

\clearpage

END_CAT
					fi
				fi

				cat << END_CAT >> figure_tex/${subregion}_${MIS}.tex 
\subsubsection{${subregion_space}}

END_CAT
				first_region=false

			fi

			# extract references

			references=$(awk '{print "\\citet{"$1"}"}' references/${region}_${location}_${MIS}.txt)





			# now make the file for the figures

			


			cat << END_CAT >> figure_tex/${subregion}_${MIS}_figures.tex 


\begin{figure}[!ht]
\includegraphics[width=\textwidth]{${plot}}
\caption{Paleo-sea level and comparison with calculated sea level for subregion: ${subregion_space}, location: ${location_space}. References: ${references}. }
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

if [ -f "temp/subregions.txt" ]
then

	cat << END_CAT >> figure_tex/summary.tex

\clearpage

\section{${MIS_header} -- Sea level Indicators and Proxies }


${MIS_text}

\FloatBarrier
END_CAT


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

\subsection{${region_space}}

END_CAT




			cat << END_CAT >> statistics_tex/summary.tex

\FloatBarrier

\subsubsection{${region_space}}

END_CAT



		fi

#		if [ "${region}" = "${current_region}" ]
#		then
#			cat << END_CAT >> figure_tex/summary.tex

#\clearpage

#END_CAT



#		fi

		current_region=${region}

		cat figure_tex/${subregion}_${MIS}.tex >> figure_tex/summary.tex
		cat figure_tex/${subregion}_${MIS}_figures.tex >> figure_tex/summary.tex

#			cat << END_CAT >> figure_tex/summary.tex

#\FloatBarrier

#END_CAT

		# create statistics table

		if [ -z "${six_models}" ]
		then

			r_var=" p{3cm} r r r r r"

			line1="& \tiny $(awk '{if (NR == 1) print $1}' temp/reference_model.txt) "

			line2="& $(awk '{if (NR == 1) print $2}' temp/reference_model.txt) "

		else

			r_var=" p{1.75cm} r r r r r r r r r r r"

			line1="& \tiny $(awk '{if (NR == 1) print $1}' temp/reference_model.txt) & \tiny $(awk '{if (NR == 1) print $1}' ${six_models})  & \tiny $(awk '{if (NR == 2) print $1}' ${six_models})  & \tiny $(awk '{if (NR == 3) print $1}' ${six_models})  & \tiny $(awk '{if (NR == 4) print $1}' ${six_models})   & \tiny $(awk '{if (NR == 5) print $1}' ${six_models})   & \tiny $(awk '{if (NR == 6) print $1}' ${six_models})"

		line2="& $(awk '{if (NR == 1) print $2}' temp/reference_model.txt) & $(awk '{if (NR == 1) print $2}' ${six_models})  & $(awk '{if (NR == 2) print $2}' ${six_models})  & $(awk '{if (NR == 3) print $2}' ${six_models})  & $(awk '{if (NR == 4) print $2}' ${six_models})   & $(awk '{if (NR == 5) print $2}' ${six_models})   & $(awk '{if (NR == 6) print $2}' ${six_models})"
		fi





		line1a=$( echo ${line1} | sed 's/_/\\textunderscore{}/g')

#
		cat << END_CAT > temp/table.tex

\begin{table}[h!]
\caption{Number of data points and model scores for ${subregion_space} }

\begin{scriptsize}

\begin{tabularx}{\textwidth}{ ${r_var} }
\hline
Location & number & marine & terrestrial & index ${line1a} \\\\
 & data & limiting & limiting & point ${line2} \\\\
\hline

END_CAT


			# do               dummy lines to preserve syntax highlighting
			# done             dummy lines to preserve syntax highlighting

		if [ -z "${six_models}" ]
		then

			awk '{sum2 += $2; sum3 += $3; sum4 += $4; sum5 += $5; sum6 += $6;  } END {print "Total & ", sum2, "& ", sum3, "& ", sum4, "& ", sum5, "& ", sum6, "\\\\" }' temp/subregion_temp/${subregion}_${MIS}.txt | sed 's/_/ /g' >> temp/table.tex

			awk '{print $1, "& ", $2, "& ", $3, "& ", $4, "& ", $5, "& ", $6,  "\\\\"}'  temp/subregion_temp/${subregion}_${MIS}.txt | sed 's/_/ /g' >> temp/table.tex

		else

			awk '{sum2 += $2; sum3 += $3; sum4 += $4; sum5 += $5; sum6 += $6; sum7 += $7; sum8 += $8; sum9 += $9; sum10 += $10; sum11 += $11; sum12 += $12; } END {print "Total & ", sum2, "& ", sum3, "& ", sum4, "& ", sum5, "& ", sum6, "& ", sum7, "& ", sum8, "& ", sum9, "& ", sum10, "& ", sum11, "& ", sum12, "\\\\" }' temp/subregion_temp/${subregion}_${MIS}.txt | sed 's/_/ /g' >> temp/table.tex

			awk '{print $1, "& ", $2, "& ", $3, "& ", $4, "& ", $5, "& ", $6, "& ", $7, "& ", $8, "& ", $9, "& ", $10, "& ", $11, "& ", $12, "\\\\"}'  temp/subregion_temp/${subregion}_${MIS}.txt | sed 's/_/ /g' >> temp/table.tex

		fi

		cat << END_CAT >> temp/table.tex

\hline

\end{tabularx}
\end{scriptsize}
\end{table}


END_CAT

		cat temp/table.tex >> statistics_tex/summary.tex



	done





else

	echo "no data yet"  >> statistics_tex/summary.tex

fi

done # cycled through all MIS stages


# create tex file with Ice and Earth model parameters

awk '{print $1}' temp/reference_model.txt > temp/ice_models.txt

if [ ! -z "${six_models}" ]
then
	awk '{print $1}' ${six_models} >> temp/ice_models.txt
fi

sort temp/ice_models.txt > temp/ice_models2.txt

awk 'BEGIN {last="FFF"; collect=""} {if ($1 != last) {print $1}; last = $1}' temp/ice_models2.txt > temp/ice_models3.txt

cat << END_CAT > temp/ice_models.tex

END_CAT

for model in $(cat temp/ice_models3.txt)
do

	cat ice_models/${model} >> temp/ice_models.tex
	echo " " >> temp/ice_models.tex


done


awk '{print $2}' temp/reference_model.txt > temp/earth_models.txt

if [ ! -z "${six_models}" ]
then
	awk '{print $2}' ${six_models} >> temp/earth_models.txt
fi

sort temp/earth_models.txt > temp/earth_models2.txt

awk 'BEGIN {last="FFF"; collect=""} {if ($1 != last) {print $1}; last = $1}' temp/earth_models2.txt > temp/earth_models3.txt

cat << END_CAT > temp/earth_models.tex

END_CAT


for model in $(cat temp/earth_models3.txt)
do

	cat earth_models/${model} >> temp/earth_models.tex
	echo " " >> temp/earth_models.tex


done

