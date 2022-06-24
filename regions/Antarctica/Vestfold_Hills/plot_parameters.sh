#! /bin/bash


###############################################################
# parameters for the regional map plots
###############################################################

# Antarctica polar projection

center_longitude=0
center_latitude=-90

J_main="-JS${center_longitude}/${center_latitude}/${width}c"




# corners of the main plot with the locations of the data
bottom_long=78.778
bottom_lat=-68.85
top_long=77.67
top_lat=-68.27

R_main="-R${bottom_long}/${bottom_lat}/${top_long}/${top_lat}r"




# corners for the inset map
small_west_latitude=-70.47
small_west_longitude=78.307
small_east_latitude=-68.00
small_east_longitude=75

R_insert="-R${small_west_longitude}/${small_west_latitude}/${small_east_longitude}/${small_east_latitude}r"
J_insert="-JS${center_longitude}/${center_latitude}/${insert_width}c"

# location of where the scale bar is plotted. Takes some trial and error to get it in the right spot.
scale_bar_lat=-68.55
scale_bar_long=78.85
# this is the latitude where it measures the width of the scale bar. Remember, the width will change depending on latitude!
scale_bar_reference_lat=-68.5
# width is in km
scale_bar_width=20


# shift where the insert map should go. 
insert_position="tr" # can be tr or br
