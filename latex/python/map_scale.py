#!/usr/bin/env python3

import sys
import numpy as np
import pandas as pd

filename = sys.argv[1]
map_plot_width = float(sys.argv[2])

col_names = ["x", "y"]

polygon = pd.read_csv (filename, sep=' ', header=None, names=col_names)

x = polygon['x'].to_numpy()
y = polygon['y'].to_numpy()

x_max = np.amax(x)
x_min = np.amin(x)

x_width = x_max - x_min

scale_width_estimate = x_width / 3000.0


if scale_width_estimate <= 10:
	scale_width = 10
elif scale_width_estimate <= 20:
	scale_width = 20
elif scale_width_estimate <= 40:
	scale_width = 40
elif scale_width_estimate <= 50:
	scale_width = 50
elif scale_width_estimate <= 80:
	scale_width = 80
elif scale_width_estimate <= 100:
	scale_width = 100
elif scale_width_estimate <= 200:
	scale_width = 200
elif scale_width_estimate <= 400:
	scale_width = 400
else:
	scale_width = 500


print(f'{scale_width}')
