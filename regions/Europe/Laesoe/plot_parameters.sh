#! /bin/bash


###############################################################
# parameters for the regional map plots
###############################################################

# center point for Lambert azimuthal projection used for DATED in Europe
center_longitude=0
center_latitude=90

# corners of the main plot with the locations of the data
bottom_long=9.7
bottom_lat=56.7
top_long=12.5
top_lat=57.8

R_main="-R${bottom_long}/${bottom_lat}/${top_long}/${top_lat}r"
J_main="-JA${center_longitude}/${center_latitude}/${width}c"


# corners for the inset map
small_west_latitude=54
small_west_longitude=6
small_east_latitude=57
small_east_longitude=20

R_insert="-R${small_west_longitude}/${small_west_latitude}/${small_east_longitude}/${small_east_latitude}r"
J_insert="-JA${center_longitude}/${center_latitude}/${insert_width}c"

# location of where the scale bar is plotted. Takes some trial and error to get it in the right spot.
scale_bar_lat=56.7
scale_bar_long=11.5
# this is the latitude where it measures the width of the scale bar. Remember, the width will change depending on latitude!
scale_bar_reference_lat=57.5
# width is in km
scale_bar_width=50


# shift where the insert map should go. 
insert_position="tr" # can be tr or br
