#! /bin/bash

# This uses GMT, so make sure it is installed first!

region=$1

location=$2

mis=$3

reference_ice_model="PM_1_A_h"
reference_earth_model="ehgr"

mkdir -p temp

six_models="temp/compare_models.txt"

cat << END_CAT > ${six_models}
PM_1_h ehgr
PM_1_A_h_Ant_A ehgr
PM_1_A_h eb0ggr
PM_1_A_h efhC
PM_1_A_h eegr
ICE-6G vm5a
END_CAT


cat << END_CAT > temp/plot_parameters.sh 
region=${region}
location=${location}
mis_stage=${mis}
reference_ice_model=${reference_ice_model}
reference_earth_model=${reference_earth_model}
six_models=${six_models}
END_CAT



bash plot_script2.sh  temp/plot_parameters.sh









