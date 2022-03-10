#! /bin/bash


###############################################################
# parameters for the regional map plots
###############################################################

# center point for Lambert azimuthal projection used for DATED in Europe
center_longitude=0
center_latitude=90

# corners of the main plot with the locations of the data
bottom_long=4.5
bottom_lat=53.5
top_long=9.6
top_lat=56

R_main="-R${bottom_long}/${bottom_lat}/${top_long}/${top_lat}r"
J_main="-JA${center_longitude}/${center_latitude}/${width}c"


# corners for the inset map
small_west_latitude=50.5
small_west_longitude=-2
small_east_latitude=58
small_east_longitude=12

R_insert="-R${small_west_longitude}/${small_west_latitude}/${small_east_longitude}/${small_east_latitude}r"
J_insert="-JA${center_longitude}/${center_latitude}/${insert_width}c"

# location of where the scale bar is plotted. Takes some trial and error to get it in the right spot.
scale_bar_lat=53.4
scale_bar_long=8.5
# this is the latitude where it measures the width of the scale bar. Remember, the width will change depending on latitude!
scale_bar_reference_lat=54
# width is in km
scale_bar_width=100


# shift where the insert map should go. 
insert_position="tr" # can be tr or br
