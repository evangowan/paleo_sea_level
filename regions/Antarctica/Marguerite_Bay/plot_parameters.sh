#! /bin/bash


###############################################################
# parameters for the regional map plots
###############################################################

# Antarctica polar projection

center_longitude=0
center_latitude=-90

J_main="-JS${center_longitude}/${center_latitude}/${width}c"


# corners of the main plot with the locations of the data
bottom_long=-68.4834
bottom_lat=-67.5322
top_long=-66.2794
top_lat=-67.8948

R_main="-R${bottom_long}/${bottom_lat}/${top_long}/${top_lat}r"


# corners for the inset map
small_west_latitude=-67.477
small_west_longitude=-72.376
small_east_latitude=-69.223
small_east_longitude=-64.111

R_insert="-R${small_west_longitude}/${small_west_latitude}/${small_east_longitude}/${small_east_latitude}r"
J_insert="-JS${center_longitude}/${center_latitude}/${insert_width}c"

# location of where the scale bar is plotted. Takes some trial and error to get it in the right spot.
scale_bar_lat=-67.8
scale_bar_long=-68
# this is the latitude where it measures the width of the scale bar. Remember, the width will change depending on latitude!
scale_bar_reference_lat=-67.7320
# width is in km
scale_bar_width=20


# shift where the insert map should go. 
insert_position="tr" # can be tr or br
