#! /bin/bash


###############################################################
# parameters for the regional map plots
###############################################################

# Lambert Conformal Conic
center_longitude=117
center_latitude=-4
south_parallel=-9
north_parallel=0

# corners of the main plot with the locations of the data
bottom_long=118
bottom_lat=-6.4
top_long=121.6
top_lat=-2.8

R_main="-R${bottom_long}/${bottom_lat}/${top_long}/${top_lat}r"
J_main="-JL${center_longitude}/${center_latitude}/${north_parallel}/${south_parallel}/${width}c"


# corners for the inset map
small_west_latitude=-13
small_west_longitude=103
small_east_latitude=4
small_east_longitude=128

R_insert="-R${small_west_longitude}/${small_west_latitude}/${small_east_longitude}/${small_east_latitude}r"
J_insert="-JL${center_longitude}/${center_latitude}/${north_parallel}/${south_parallel}/${insert_width}c"

# location of where the scale bar is plotted. Takes some trial and error to get it in the right spot.
scale_bar_lat=-6.1
scale_bar_long=119
# this is the latitude where it measures the width of the scale bar. Remember, the width will change depending on latitude!
scale_bar_reference_lat=-4.4
# width is in km
scale_bar_width=100


# shift where the insert map should go. 
insert_position="br" # can be tr or br
