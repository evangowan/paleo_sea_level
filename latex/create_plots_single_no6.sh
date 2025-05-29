#! /bin/bash

# This uses GMT, so make sure it is installed first!

region=$1

location=$2

mis=$3

reference_ice_model="DATED-2-007"
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
override_height_low=""
override_height_high=""
override_age=""
override_age_young=""
END_CAT



bash plot_script.sh  temp/plot_parameters.sh









