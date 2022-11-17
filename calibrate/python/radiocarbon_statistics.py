import sys
import numpy as np
import pandas as pd
import math

# this program reads in a prior file from a given sample name, and outputs
# median age, mode age, 1-sigma limits (low, up), 2-sigma limits (low, up)


def calc_intermediate_value(lower_prob, higher_prob, expected_prob, time_interval):

	# returns an age that should be added to the lower age

	
	slope = (higher_prob - lower_prob) / time_interval

	return (expected_prob - lower_prob) / slope

filename = sys.argv[1]

col_names=["age", "probability"]
prior = pd.read_csv (filename, sep='\t', header=None, names=col_names)


zero_age = 1950.5

one_sigma_low_val = 0.31731 / 2.0
one_sigma_high_val = 1. - one_sigma_low_val

two_sigma_low_val = 0.0455 / 2.0
two_sigma_high_val = 1.0 - two_sigma_low_val

row0 = prior.iloc[0]
age0 = row0['age']
probability0 = np.double(row0['probability'])

row1 = prior.iloc[1]
age1 = row1['age']
probability1 = np.double(row1['probability'])

time_interval = age1 - age0


current_age = zero_age - age0
current_probability = probability0 * time_interval

mode_age = current_age
maximum_probability = current_probability
total_probability = current_probability

last_age = current_age
last_probability = current_probability

one_sigma_lower=0
one_sigma_upper=0
two_sigma_lower=0
two_sigma_upper=0
median_age=0

for row_number, row in prior.iterrows():

	if row_number > 0:

		current_age = zero_age - row['age']
		current_probability  = row['probability'] * time_interval


		total_probability = total_probability + current_probability

		if total_probability >= one_sigma_low_val and last_probability < one_sigma_low_val:
			one_sigma_lower = calc_intermediate_value(last_probability, total_probability, one_sigma_low_val, time_interval) + last_age


		if total_probability >= one_sigma_high_val and last_probability < one_sigma_high_val:
			one_sigma_upper = calc_intermediate_value(last_probability, total_probability, one_sigma_high_val, time_interval) + last_age


		if total_probability >= two_sigma_low_val and last_probability < two_sigma_low_val:
			two_sigma_lower = calc_intermediate_value(last_probability, total_probability, two_sigma_low_val, time_interval) + last_age


		if total_probability >= two_sigma_high_val and last_probability < two_sigma_high_val:
			two_sigma_upper = calc_intermediate_value(last_probability, total_probability, two_sigma_high_val, time_interval) + last_age


		if total_probability >= 0.5 and last_probability < 0.5:
			median_age = calc_intermediate_value(last_probability, total_probability, 0.5, time_interval) + last_age


		if current_probability > maximum_probability:
			maximum_probability = current_probability
			mode_age = current_age


		last_age = current_age
		last_probability = total_probability


middle_age = (two_sigma_upper + two_sigma_lower) / 2.
print(f"{int(np.rint(middle_age))} {int(np.rint(two_sigma_lower-middle_age))}")
