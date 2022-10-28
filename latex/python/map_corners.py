#!/usr/bin/env python3

import sys
import numpy as np
import pandas as pd


filename = sys.argv[1]
map_plot_width = float(sys.argv[2])
map_plot_height = float(sys.argv[3])
sub_map_plot_width = float(sys.argv[4])


col_names = ["x", "y"]

polygon = pd.read_csv (filename, sep='\t', header=None, names=col_names)


x = polygon['x'].to_numpy()
y = polygon['y'].to_numpy()


# calculate the bottom and top corners of the map

x_max = np.amax(x)
x_min = np.amin(x)
y_max = np.amax(y)
y_min = np.amin(y)



x_reference = np.amax([np.fabs(x_max), np.fabs(x_min)])
y_reference = np.amax([np.fabs(y_max), np.fabs(y_min)])

x_scale = x_reference / (map_plot_width/2.0 - sub_map_plot_width/2.0)  
y_scale = y_reference / (map_plot_height/2.0 - sub_map_plot_width)  

scale = np.amax([x_scale,y_scale])

x_top = scale * map_plot_width / 2.0
y_top = scale * map_plot_height / 2.0
x_bottom = -x_top
y_bottom = -y_top


print(f'{x_top} {y_top}')
print(f'{x_bottom} {y_bottom}')
