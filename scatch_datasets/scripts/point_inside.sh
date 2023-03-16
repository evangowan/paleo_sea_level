#! /bin/bash

# This script assumes merge_ods.py has already been exectuted and a file called merge.csv exists

ogr2ogr -s_srs EPSG:4326 -t_srs EPSG:4326 -oo X_POSSIBLE_NAMES=Lon* -oo Y_POSSIBLE_NAMES=Lat*  -f "ESRI Shapefile" merge.shp merge.csv

qgis_process run native:joinattributesbylocation --distance_units=meters --area_units=m2 --ellipsoid=EPSG:7030 --INPUT=merge.shp --PREDICATE=5 --JOIN=../../GIS/region_bounds.shp --METHOD=0 --DISCARD_NONMATCHING=false --PREFIX= --OUTPUT=temp.shp

ogr2ogr -f CSV joined.csv temp.shp -lco GEOMETRY=AS_XYZ



qgis_process run native:joinattributesbylocation --distance_units=meters --area_units=m2 --ellipsoid=EPSG:7030 --INPUT=merge.shp --PREDICATE=5 --JOIN=../../GIS/delta_r.shp --METHOD=0 --DISCARD_NONMATCHING=false --PREFIX= --OUTPUT=temp2.shp


ogr2ogr -f CSV joined2.csv temp2.shp -lco GEOMETRY=AS_XYZ

python3 ../scripts/location_ods.py  merge.ods joined.csv joined2.csv merge2.ods

if [ -f file_list_extra.txt ]
then

number_extra=$(wc -l < file_list_extra.txt)

for filenumber in $(seq 1 ${number_extra})
do

	file_prefix="merge_extra_${filenumber}"

	file_in_ods="${file_prefix}.ods"
	file_in_csv="${file_prefix}.csv"
	ogr2ogr -s_srs EPSG:4326 -t_srs EPSG:4326 -oo X_POSSIBLE_NAMES=Lon* -oo Y_POSSIBLE_NAMES=Lat*  -f "ESRI Shapefile" merge.shp ${file_in_csv}

	qgis_process run native:joinattributesbylocation --distance_units=meters --area_units=m2 --ellipsoid=EPSG:7030 --INPUT=merge.shp --PREDICATE=5 --JOIN=../../GIS/region_bounds.shp --METHOD=0 --DISCARD_NONMATCHING=false --PREFIX= --OUTPUT=temp.shp

	file_region_csv="${file_prefix}_joined.csv"
	ogr2ogr -f CSV ${file_region_csv} temp.shp -lco GEOMETRY=AS_XYZ



	qgis_process run native:joinattributesbylocation --distance_units=meters --area_units=m2 --ellipsoid=EPSG:7030 --INPUT=merge.shp --PREDICATE=5 --JOIN=../../GIS/delta_r.shp --METHOD=0 --DISCARD_NONMATCHING=false --PREFIX= --OUTPUT=temp2.shp

	file_reservoir_csv="${file_prefix}_joined2.csv"
	ogr2ogr -f CSV ${file_reservoir_csv} temp2.shp -lco GEOMETRY=AS_XYZ

	file_out_ods="${file_prefix}_2.ods"
	python3 ../scripts/location_ods.py  ${file_in_ods} ${file_region_csv} ${file_reservoir_csv} ${file_out_ods}
done
fi



