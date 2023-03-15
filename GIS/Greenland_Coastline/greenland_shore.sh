#! /bin/bash

# You have to download BedMachine, which you can do from https://nsidc.org/data/idbmg4/versions/5

bedmachine=BedMachineGreenland-v5.nc

xmin=-652925
xmax=879625
ymin=-3384425
ymax=-632675

R_options="-R${xmin}/${xmax}/${ymin}/${ymax}"
J_options="-JX10c/17.95537c"

#BedMachine is at 150 m resolution, you can change the resolution of the output coastlines
output_resolution=500
actual_resolution=$( echo ${xmin} ${xmax} ${output_resolution} | awk '{printf "%.5f", ($1-$2) / int(($1-$2)/$3) }')

echo "resolution ${output_resolution} changed to ${actual_resolution}"

gmt grdmath ${bedmachine}?mask 1 GE  = floating_edge.nc


gmt grdsample floating_edge.nc -Gfloating_edge_sampled.nc -I${output_resolution} -nn ${R_options}

gmt grdcontour floating_edge_sampled.nc ${J_options}  -C0.5,  -Dfloating_countours_%c.gmt

gmt grdmath ${bedmachine}?mask 3 NEQ floating_edge.nc MUL = grounded_edge.nc

gmt grdsample grounded_edge.nc -Ggrounded_edge_sampled.nc -I${output_resolution} -nn ${R_options}

gmt grdcontour grounded_edge_sampled.nc ${J_options}  -C0.5,  -Dgrounded_countours_%c.gmt

gmt begin test_floating pdf
	gmt grdimage floating_edge.nc ${R_options} ${J_options} -BneWS -Bxa500000 -Bya500000 
	gmt plot floating_countours_C.gmt  ${R_options} ${J_options} -W0.1p,white
	gmt plot floating_countours_O.gmt  ${R_options} ${J_options} -W0.1p,white

gmt end

gmt begin test_grounded pdf
	gmt grdimage grounded_edge.nc ${R_options} ${J_options} -BneWS -Bxa500000 -Bya500000 
	gmt plot grounded_countours_C.gmt  ${R_options} ${J_options} -W0.1p,white
	gmt plot grounded_countours_O.gmt  ${R_options} ${J_options} -W0.1p,white
gmt end

ogr2ogr   -f "GMT" floating_countours_C_geo.gmt floating_countours_C.gmt  -t_srs "EPSG:4326" -s_srs "EPSG:3413" 
ogr2ogr   -f "GMT" floating_countours_O_geo.gmt floating_countours_O.gmt  -t_srs "EPSG:4326" -s_srs "EPSG:3413" 

ogr2ogr   -f "GMT" grounded_countours_C_geo.gmt grounded_countours_C.gmt  -t_srs "EPSG:4326" -s_srs "EPSG:3413" 
ogr2ogr   -f "GMT" grounded_countours_O_geo.gmt grounded_countours_O.gmt  -t_srs "EPSG:4326" -s_srs "EPSG:3413" 
