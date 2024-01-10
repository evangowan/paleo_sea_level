import sys
import numpy as np
import pandas as pd

# This should calculate the delta_r the same as in the Calib website (http://calib.org/marine/AverageDeltaR.html)

# this file is a tab delimited list of the delta_r and uncertainty values
delta_r_file = "delta_r_combine.txt"

try:
	delta_r_data = pd.read_csv(delta_r_file, sep="\t", header=None)
	delta_r_data.columns = ["delta_r", "uncertainty"]
except FileNotFoundError:
	print("delta_r_combine.txt is not detected")
	sys.exit()

delta_r = delta_r_data["delta_r"].to_numpy()
uncertainty = delta_r_data["uncertainty"].to_numpy()
uncertainty_squared=np.power(uncertainty,2)
invert_uncertainty_squared = np.divide(1.0,uncertainty_squared)
delta_r_div_uncertainty_squared = np.divide(delta_r,uncertainty_squared)

weighted_mean = np.divide(np.sum(delta_r_div_uncertainty_squared), np.sum(invert_uncertainty_squared))

print(weighted_mean)

weighted_mean_uncertainty =  np.divide(1.0, np.sqrt(np.sum(invert_uncertainty_squared)))

print("weighted mean: ", weighted_mean)
print("weighted mean uncertainty: ", weighted_mean_uncertainty)

n=len(delta_r)

variance_part = np.power(np.divide(np.subtract(delta_r,weighted_mean),uncertainty),2)

variance = np.divide(np.multiply(np.divide(1.0,(n-1)),np.sum(variance_part)),np.multiply(np.divide(1.0,n),sum(invert_uncertainty_squared)))

standard_deviation = np.sqrt(variance)

print("standard deviation: ", standard_deviation)

weighted_mean_round = np.rint(weighted_mean)
weighted_mean_uncertainty_round = np.rint(weighted_mean_uncertainty)
standard_deviation_round = np.rint(standard_deviation)

final_uncertainty = np.max([weighted_mean_uncertainty_round,standard_deviation_round])
print("delta_r and uncertainty:")
print(int(weighted_mean_round), int(final_uncertainty))
