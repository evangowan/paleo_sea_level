#! /bin/bash

sl_sector=$1

# This script assumes merge_ods.py has already been exectuted and a file called merge.csv exists

if [ -f ${sl_sector}/file_list.txt ]
then

ogr2ogr -s_srs EPSG:4326 -t_srs EPSG:4326 -oo X_POSSIBLE_NAMES=Lon* -oo Y_POSSIBLE_NAMES=Lat*  -f "ESRI Shapefile" ${sl_sector}/temp/merge.shp ${sl_sector}/temp/merge.csv

qgis_process run native:joinattributesbylocation --distance_units=meters --area_units=m2 --ellipsoid=EPSG:7030 --INPUT=${sl_sector}/temp/merge.shp --PREDICATE=5 --JOIN=../GIS/region_bounds.shp --METHOD=0 --DISCARD_NONMATCHING=false --PREFIX= --OUTPUT=${sl_sector}/temp/temp.shp

ogr2ogr -f CSV ${sl_sector}/temp/joined.csv ${sl_sector}/temp/temp.shp -lco GEOMETRY=AS_XYZ



qgis_process run native:joinattributesbylocation --distance_units=meters --area_units=m2 --ellipsoid=EPSG:7030 --INPUT=${sl_sector}/temp/merge.shp --PREDICATE=5 --JOIN=../GIS/delta_r.shp --METHOD=0 --DISCARD_NONMATCHING=false --PREFIX= --OUTPUT=${sl_sector}/temp/temp2.shp


ogr2ogr -f CSV ${sl_sector}/temp/joined2.csv ${sl_sector}/temp/temp2.shp -lco GEOMETRY=AS_XYZ

python3 scripts/location_ods.py  ${sl_sector}/temp/merge.ods ${sl_sector}/temp/joined.csv ${sl_sector}/temp/joined2.csv ${sl_sector}/temp/merge2.ods

fi

if [ -f ${sl_sector}/file_list_extra.txt ]
then

number_extra=$(wc -l < ${sl_sector}/file_list_extra.txt)

for filenumber in $(seq 1 ${number_extra})
do

	file_prefix="merge_extra_${filenumber}"

	file_in_ods="${sl_sector}/temp/${file_prefix}.ods"
	file_in_csv="${sl_sector}/temp/${file_prefix}.csv"
	ogr2ogr -s_srs EPSG:4326 -t_srs EPSG:4326 -oo X_POSSIBLE_NAMES=Lon* -oo Y_POSSIBLE_NAMES=Lat*  -f "ESRI Shapefile" ${sl_sector}/temp/merge.shp ${file_in_csv}

	qgis_process run native:joinattributesbylocation --distance_units=meters --area_units=m2 --ellipsoid=EPSG:7030 --INPUT=${sl_sector}/temp/merge.shp --PREDICATE=5 --JOIN=../GIS/region_bounds.shp --METHOD=0 --DISCARD_NONMATCHING=false --PREFIX= --OUTPUT=${sl_sector}/temp/temp.shp

	file_region_csv="${sl_sector}/temp/${file_prefix}_joined.csv"
	ogr2ogr -f CSV ${file_region_csv} ${sl_sector}/temp/temp.shp -lco GEOMETRY=AS_XYZ



	qgis_process run native:joinattributesbylocation --distance_units=meters --area_units=m2 --ellipsoid=EPSG:7030 --INPUT=${sl_sector}/temp/merge.shp --PREDICATE=5 --JOIN=../GIS/delta_r.shp --METHOD=0 --DISCARD_NONMATCHING=false --PREFIX= --OUTPUT=${sl_sector}/temp/temp2.shp

	file_reservoir_csv="${sl_sector}/temp/${file_prefix}_joined2.csv"
	ogr2ogr -f CSV ${file_reservoir_csv} ${sl_sector}/temp/temp2.shp -lco GEOMETRY=AS_XYZ

	file_out_ods="${sl_sector}/temp/${file_prefix}_2.ods"
	python3 scripts/location_ods.py  ${file_in_ods} ${file_region_csv} ${file_reservoir_csv} ${file_out_ods}
done
fi



