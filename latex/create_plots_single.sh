#! /bin/bash

# This uses GMT, so make sure it is installed first!

region=$1

location=$2

mis=$3

reference_ice_model="PM_1"
reference_earth_model="ehgr"

mkdir -p temp

six_models="temp/compare_models.txt"

cat << END_CAT > ${six_models}
PM_1 ehgA
PM_1 ehgC
PM_1 ehgG
PM_1 ehgk
PM_1 ehgr
PM_1 ehgK
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









