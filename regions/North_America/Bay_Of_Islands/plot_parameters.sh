#! /bin/bash


###############################################################
# parameters for the regional map plots
###############################################################

# center point for Canada based Lambert azimuthal projection
center_longitude=-94
center_latitude=60

# corners of the main plot with the locations of the data
bottom_long=-60.2
bottom_lat=49.1
top_long=-56
top_lat=49.8

R_main="-R${bottom_long}/${bottom_lat}/${top_long}/${top_lat}r"
J_main="-JA${center_longitude}/${center_latitude}/${width}c"


# corners for the inset map
small_west_latitude=47.4
small_west_longitude=-64
small_east_latitude=49
small_east_longitude=-46.5

R_insert="-R${small_west_longitude}/${small_west_latitude}/${small_east_longitude}/${small_east_latitude}r"
J_insert="-JA${center_longitude}/${center_latitude}/${insert_width}c"

# location of where the scale bar is plotted. Takes some trial and error to get it in the right spot.
scale_bar_lat=49
scale_bar_long=-59.3
# this is the latitude where it measures the width of the scale bar. Remember, the width will change depending on latitude!
scale_bar_reference_lat=49.1
# width is in km
scale_bar_width=100


# shift where the insert map should go. 
insert_position="tr" # can be tr or br
