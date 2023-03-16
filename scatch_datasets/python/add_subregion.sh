#! /bin/bash

sl_sector=$1

echo $sl_sector

if [ -f temp/${sl_sector}/location_list.txt ]
then
echo temp/${sl_sector}/location_list.txt exists
else
echo temp/${sl_sector}/location_list.txt does not exist
fi
#filename="temp/${sl_sector}/location_list.txt?type=csv&delimiter=%5Ct&useHeader=No&maxFields=10000&detectTypes=yes&geomType=none&subsetIndex=no&watchFile=yes"
filename="temp/${sl_sector}/location_list.txt"
echo ${filename}
qgis_process run native:joinattributestable --distance_units=meters --area_units=m2 --ellipsoid=NONE --INPUT=${filename} --FIELD=field_3 --INPUT_2=../GIS/region_bounds.shp --FIELD_2=location --METHOD=1 --DISCARD_NONMATCHING=false --PREFIX= --OUTPUT=temp/temp.csv
exit 0
awk 
