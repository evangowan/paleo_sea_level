#! /bin/bash


###############################################################
# parameters for the regional map plots
###############################################################



# center point for Canada based Lambert azimuthal projection
center_longitude=-94
center_latitude=60


# corners of the main plot with the locations of the data
bottom_long=-101
bottom_lat=54
top_long=-87.5
top_lat=61.7


R_main="-R${bottom_long}/${bottom_lat}/${top_long}/${top_lat}r"
J_main="-JA${center_longitude}/${center_latitude}/${width}c"


# corners for the inset map
small_west_latitude=50
small_west_longitude=-110
small_east_latitude=68
small_east_longitude=-50

R_insert="-R${small_west_longitude}/${small_west_latitude}/${small_east_longitude}/${small_east_latitude}r"
J_insert="-JA${center_longitude}/${center_latitude}/${insert_width}c"

# location of the square used to show the region on the inset map. Should be in the middle of the above coordinates.
center_long=-94.7
center_lat=57.8

# actually polygon defining the region, see GIS folder if you change this
cat << END_CAT > temp/region_bound.txt
-93.918044442095947 60.636989272558381
-91.31784654831435 57.540535656596219
-93.077486629923172 54.797528400770425
-95.364154523929813 54.889703886587135
-98.78190358636715 57.353242284337909
-97.264230394020288 61.594410272183964
-93.918044442095947 60.636989272558381
END_CAT


# location of where the scale bar is plotted. Takes some trial and error to get it in the right spot.
scale_bar_lat=55
scale_bar_long=-99
# this is the latitude where it measures the width of the scale bar. Remember, the width will change depending on latitude!
scale_bar_reference_lat=63
# width is in km
scale_bar_width=100


# shift in cm where the insert map should go. 
insert_position="tr" # can be tr or br

###############################################################
# parameters for the relative sea level plot
###############################################################

# x-axis range
# for best results, use a multiple of 1000 years
max_time=10000
min_time=0

# y-axis range
# for best results, use a multiple of 20 m
max_elevation=120
min_elevation=-20
