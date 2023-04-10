#! /bin/bash

# This uses GMT, so make sure it is installed first!

region=$1

location=$2

mis=$3

reference_ice_model="72_73_74_75"
reference_earth_model="ehgr"

mkdir -p temp

six_models="temp/compare_models.txt"

cat << END_CAT > ${six_models}
72_73_74_75 ehgA
72_73_74_75 ehgC
72_73_74_75 ehgG
72_73_74_75 ehgk
72_73_74_75 ehgr
72_73_74_75 ehgK
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









