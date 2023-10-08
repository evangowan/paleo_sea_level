#! /bin/bash

# This uses GMT, so make sure it is installed first!

region=$1

location=$2

mis=$3

reference_ice_model="PM_1_A_h_Ant_A"
reference_earth_model="ehgr"

mkdir -p temp

six_models=""




cat << END_CAT > temp/plot_parameters.sh 
region=${region}
location=${location}
mis_stage=${mis}
reference_ice_model=${reference_ice_model}
reference_earth_model=${reference_earth_model}
six_models=${six_models}
END_CAT



bash plot_script.sh  temp/plot_parameters.sh









