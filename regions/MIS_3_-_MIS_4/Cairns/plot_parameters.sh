#! /bin/bash


###############################################################
# parameters for the regional map plots
###############################################################

# Lambert Conformal Conic
center_longitude=147
center_latitude=-18
south_parallel=-21
north_parallel=-14

# corners of the main plot with the locations of the data
bottom_long=143.7
bottom_lat=-20.5
top_long=150
top_lat=-14.5

R_main="-R${bottom_long}/${bottom_lat}/${top_long}/${top_lat}r"
J_main="-JL${center_longitude}/${center_latitude}/${north_parallel}/${south_parallel}/${width}c"


# corners for the inset map
small_west_latitude=-24
small_west_longitude=141
small_east_latitude=-9
small_east_longitude=155

R_insert="-R${small_west_longitude}/${small_west_latitude}/${small_east_longitude}/${small_east_latitude}r"
J_insert="-JL${center_longitude}/${center_latitude}/${north_parallel}/${south_parallel}/${insert_width}c"

# location of where the scale bar is plotted. Takes some trial and error to get it in the right spot.
scale_bar_lat=-20
scale_bar_long=145
# this is the latitude where it measures the width of the scale bar. Remember, the width will change depending on latitude!
scale_bar_reference_lat=-17
# width is in km
scale_bar_width=100


# shift where the insert map should go. 
insert_position="tr" # can be tr or br
