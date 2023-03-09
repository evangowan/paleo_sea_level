#! /bin/bash

# This script assumes merge_ods.py has already been exectuted and a file called merge.csv exists

ogr2ogr -s_srs EPSG:4326 -t_srs EPSG:4326 -oo X_POSSIBLE_NAMES=Lon* -oo Y_POSSIBLE_NAMES=Lat*  -f "ESRI Shapefile" merge.shp merge.csv

qgis_process run native:joinattributesbylocation --distance_units=meters --area_units=m2 --ellipsoid=EPSG:7030 --INPUT=merge.shp --PREDICATE=5 --JOIN=../../GIS/region_bounds.shp --METHOD=0 --DISCARD_NONMATCHING=false --PREFIX= --OUTPUT=temp.shp

ogr2ogr -f CSV joined.csv temp.shp -lco GEOMETRY=AS_XYZ

python3 ../python/location_ods.py
