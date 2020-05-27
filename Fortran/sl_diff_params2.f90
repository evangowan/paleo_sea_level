program sl_diff_params

	implicit none

	character(len=80), parameter :: sl_file = "region_sl.txt"
	character(len=80), parameter :: sl_header_file = "region_sl_header.txt"
	integer, parameter :: sl_unit = 30, sl_header_unit=40, in_unit = 10, out_unit = 20

	integer :: region_number_locations, number_times, number_lines, counter, id_counter, time_counter
	integer :: istat, id_index

	character(len=80) :: lab_id
	character(len=80), dimension(:), allocatable :: lab_id_array

	double precision, dimension(:), allocatable :: time_array
	double precision, dimension(:,:), allocatable :: calc_sl_array

	double precision :: age, elevation, age_range, elevation_range, model_elevation, model_range, diff_elevation, diff_range
	double precision :: score, maximum_elevation, minimum_elevation, age_mean, age_range_lower,  age_range_upper
	double precision :: elevation_range_lower, elevation_range_upper, elevation_mean
	double precision, parameter :: elevation_round = 20. ! this will be the interval used for plotting
	integer :: maximum_elevation_rounded, minimum_elevation_rounded

	character(len=80) :: dummy_string, in_file, out_file
	integer :: dummy_integer, dummy_integer2

	logical :: file_exists

	maximum_elevation = -99999.
	minimum_elevation = 99999.


	open(unit=sl_unit, file=sl_file, form="formatted", access="sequential", status="old")
	open(unit=sl_header_unit, file=sl_header_file, form="formatted", access="sequential", status="old")


	read(sl_header_unit,'(A1,1X,I6,1X,I4)') dummy_string, region_number_locations, number_times 

	allocate(lab_id_array(region_number_locations), time_array(number_times), &
	  calc_sl_array(region_number_locations, number_times))

	close(unit=sl_header_unit)


	number_lines = region_number_locations * (number_times + 1)

	id_counter = 0
	do counter = 1, number_lines

		if(mod(counter-1,number_times+1) == 0) THEN
			id_counter = id_counter + 1
			read(sl_unit,*) dummy_string, dummy_integer,dummy_integer2, lab_id_array(id_counter)
			time_counter = 0
		else

			time_counter = time_counter + 1
			read(sl_unit,*) time_array(time_counter), calc_sl_array(id_counter,time_counter)

!			write(6,*) trim(lab_id_array(id_counter)), time_array(time_counter), calc_sl_array(id_counter,time_counter)

		endif


	end do

	close(unit=sl_unit)

	score = 0.

	! minimum: calculated sea level should be above the fossil
	in_file = "minimum.txt"
	out_file = "minimum_plot_diff.txt"

	INQUIRE(FILE=in_file, EXIST=file_exists) 

	if(file_exists) THEN

		open(unit=in_unit, file=in_file, form="formatted", access="sequential", status="old")
		open(unit=out_unit, file=out_file, form="formatted", access="sequential", status="replace")


		read_minimum: do

			read(in_unit,*, iostat=istat) age_mean, elevation_mean, age_range_lower,  age_range_upper, elevation_range_lower,&
			  elevation_range_upper, lab_id
			if(istat /=0) THEN
				exit read_minimum
			endif
			age_range = (age_range_upper + age_range_lower)  / 2.0
			age = age_mean -elevation_range_lower + age_range


			elevation_range = (elevation_range_lower + elevation_range_upper) / 2.0
			elevation = elevation_mean-elevation_range_lower + elevation_range
 
			id_index = find_id_index(lab_id_array, id_counter, lab_id)



			if(id_index > 0) THEn
		!		write(6,*) lab_id
				call get_model_range(time_array, calc_sl_array, id_counter, time_counter, id_index, age, age_range,&
				  model_elevation, model_range)

				diff_elevation = elevation - model_elevation
				diff_range = sqrt(elevation_range**2 + model_range**2)

				if (diff_elevation-diff_range > 0.) THEN
					score = score + diff_elevation-diff_range
				endif

				if(diff_elevation+diff_range > maximum_elevation) THEN
					maximum_elevation = diff_elevation + diff_range
				endif

				if(diff_elevation-diff_range < minimum_elevation) THEN
					minimum_elevation = diff_elevation - diff_range
				endif

				write(out_unit,*) age_mean, diff_elevation - diff_range, age_range_lower,  age_range_upper, &
				 0.0, diff_range * 2.0

			endif

		end do read_minimum

		close(in_unit)
		close(out_unit)
	else

		write(6,*) "could not find: ", in_file

	end if



	! maximum: calculated sea level should be below the fossil
	in_file = "maximum.txt"
	out_file = "maximum_plot_diff.txt"

	INQUIRE(FILE=in_file, EXIST=file_exists) 

	if(file_exists) THEN

		open(unit=in_unit, file=in_file, form="formatted", access="sequential", status="old")
		open(unit=out_unit, file=out_file, form="formatted", access="sequential", status="replace")

!		score = 0.
		read_maximum: do

			read(in_unit,*, iostat=istat) age_mean, elevation_mean, age_range_lower,  age_range_upper, elevation_range_lower,&
			  elevation_range_upper, lab_id
			if(istat /=0) THEN
				exit read_maximum
			endif

			age_range = (age_range_upper + age_range_lower)  / 2.0
			age = age_mean -elevation_range_lower + age_range


			elevation_range = (elevation_range_lower + elevation_range_upper) / 2.0
			elevation = elevation_mean-elevation_range_lower + elevation_range


			id_index = find_id_index(lab_id_array, id_counter, lab_id)

			if(id_index > 0) THEn
		!		write(6,*) lab_id
				call get_model_range(time_array, calc_sl_array, id_counter, time_counter, id_index, age, age_range,&
				  model_elevation, model_range)

				diff_elevation = elevation - model_elevation
				diff_range = sqrt(elevation_range**2 + model_range**2)

				if (diff_elevation+diff_range < 0.) THEN
					score = score  - (diff_elevation+diff_range)
				endif

				if(diff_elevation+diff_range > maximum_elevation) THEN
					maximum_elevation = diff_elevation + diff_range
				endif

				if(diff_elevation-diff_range < minimum_elevation) THEN
					minimum_elevation = diff_elevation - diff_range
				endif

				write(out_unit,*) age_mean, diff_elevation + diff_range, age_range_lower,  age_range_upper, &
				 diff_range * 2.0, 0.0


			endif

		end do read_maximum

		close(in_unit)
		close(out_unit)
	else

		write(6,*) "could not find: ", in_file
	endif


	! bounded: the differenced range should stradle zero
	in_file = "bounded.txt"
	out_file = "bounded_plot_diff.txt"

	INQUIRE(FILE=in_file, EXIST=file_exists) 

	if(file_exists) THEN
		open(unit=in_unit, file=in_file, form="formatted", access="sequential", status="old")
		open(unit=out_unit, file=out_file, form="formatted", access="sequential", status="replace")

!		score = 0.
		read_bounded: do

			read(in_unit,*, iostat=istat) age_mean, elevation_mean, age_range_lower,  age_range_upper, elevation_range_lower,&
			  elevation_range_upper, lab_id
			if(istat /=0) THEN
				exit read_bounded
			endif

			age_range = (age_range_upper + age_range_lower)  / 2.0
			age = age_mean -elevation_range_lower + age_range

			elevation_range = (elevation_range_lower + elevation_range_upper) / 2.0
			elevation = elevation_mean-elevation_range_lower + elevation_range



			id_index = find_id_index(lab_id_array, id_counter, lab_id)

			if(id_index > 0) THEn
		!		write(6,*) lab_id
				call get_model_range(time_array, calc_sl_array, id_counter, time_counter, id_index, age, age_range,&
				  model_elevation, model_range)

				diff_elevation = elevation - model_elevation
				diff_range = sqrt(elevation_range**2 + model_range**2)

				if (diff_elevation+diff_range < 0.) THEN
					score = score  - (diff_elevation+diff_range)
				endif

				if (diff_elevation-diff_range > 0.) THEN
					score = score + diff_elevation-diff_range
				endif

				if(diff_elevation+diff_range > maximum_elevation) THEN
					maximum_elevation = diff_elevation + diff_range
				endif

				if(diff_elevation-diff_range < minimum_elevation) THEN
					minimum_elevation = diff_elevation - diff_range
				endif

				write(out_unit,*) age_mean, diff_elevation, age_range_lower,  age_range_upper, &
				 diff_range, diff_range


			endif

		end do read_bounded

		close(in_unit)
		close(out_unit)
	else

		write(6,*) "could not find: ", in_file

	endif

	deallocate(lab_id_array, time_array, calc_sl_array)


	! write out the score value

	out_file = "score.txt"

	open(unit=out_unit, file=out_file, form="formatted", access="sequential", status="replace")

	write(out_unit,'(I6)') nint(score)
	close(out_unit)

	! write out plot parameters

	out_file = "min_max_range.txt"
	open(unit=out_unit, file=out_file, form="formatted", access="sequential", status="replace")

	maximum_elevation_rounded = nint(dble(ceiling(maximum_elevation / elevation_round)) * elevation_round)
	minimum_elevation_rounded = nint(dble(floor(minimum_elevation / elevation_round)) * elevation_round)

	if(maximum_elevation_rounded == minimum_elevation_rounded) THEN ! shouldn't happen, but I will add 20 to maximum
		maximum_elevation_rounded = maximum_elevation_rounded + nint(elevation_round)
	endif

	write(out_unit,*) maximum_elevation_rounded, minimum_elevation_rounded

	close(out_unit)

contains


integer function find_id_index(lab_id_array, id_counter, lab_id)

	integer, intent(in) :: id_counter
	character(len=80) :: lab_id

	character(len=80), dimension(id_counter), intent(in) :: lab_id_array

	integer :: counter


	find_id_index = 0

	find_id: do counter = 1, id_counter

		if(lab_id_array(counter) == lab_id) THEn
			find_id_index = counter
			exit find_id
		endif

	end do find_id

	if(find_id_index == 0) THEN
		write(6,*) "warning, did not find lab id: ", trim(lab_id)

	endif

end function find_id_index

subroutine get_model_range(time_array, calc_sl_array, id_counter, time_counter, id_index, age, age_range,&
			  model_elevation, model_range)

	integer, intent(in) :: id_counter, time_counter, id_index
	double precision, dimension(time_counter), intent(in) :: time_array
	double precision, dimension(id_counter,time_counter), intent(in) :: calc_sl_array
	double precision, intent(in) :: age, age_range
	double precision, intent(out) :: model_elevation, model_range

	integer :: do_low, do_high, do_increment, counter, next_counter

	double precision :: high_value, low_value, age_check, elevation_check

	! first find if the times are ascending or descending

	if(time_array(1) < time_array(2)) THEN ! ascending
		do_low = 1
		do_high = time_counter-1
		do_increment = 1
	else ! descending
		do_low = time_counter
		do_high = 2
		do_increment = -1
	end if

	high_value = -99999
	low_value = 99999

!	write(6,*) ">", do_low, do_high, do_increment
	if(time_array(do_low) > age - age_range .and. time_array(do_low) < age + age_range) THEN

		high_value = max(high_value,calc_sl_array(id_index,next_counter))
		low_value = min(low_value,calc_sl_array(id_index,next_counter))

!		write(6,*) "1: ", low_value, high_value, calc_sl_array(id_index,next_counter)
	endif

	do counter = do_low, do_high, do_increment

		next_counter = counter + do_increment

		age_check = age - age_range

!		write(6,*) age_check, age, age_range, time_array(counter)

		if(age_check > time_array(counter) .and. age_check < time_array(next_counter)) THEN

			elevation_check = find_interpolated_value(time_array(counter),calc_sl_array(id_index,counter), &
			  time_array(next_counter), calc_sl_array(id_index,next_counter), age_check)

!			write(6,*) "2: ", low_value, high_value, elevation_check

			high_value = max(high_value,elevation_check)
			low_value = min(low_value,elevation_check)
		endif

		age_check = age + age_range

		if(age_check > time_array(counter) .and. age_check < time_array(next_counter)) THEN

			elevation_check = find_interpolated_value(time_array(counter),calc_sl_array(id_index,counter), &
			  time_array(next_counter), calc_sl_array(id_index,next_counter), age_check)

!			write(6,*) "3: ", low_value, high_value, elevation_check

			high_value = max(high_value,elevation_check)
			low_value = min(low_value,elevation_check)
		endif

		if(time_array(next_counter) > age - age_range .and. time_array(next_counter) < age + age_range) THEN

			high_value = max(high_value,calc_sl_array(id_index,next_counter))
			low_value = min(low_value,calc_sl_array(id_index,next_counter))

!			write(6,*) "4: ", low_value, high_value, calc_sl_array(id_index,next_counter)
		endif

	end do

	model_elevation = (high_value + low_value) / 2.
	model_range = model_elevation - low_value

!	write(6,*) age - age_range, age + age_range, model_elevation - model_range, model_elevation + model_range
	! should be done

end subroutine get_model_range

double precision function find_interpolated_value(x1, y1, x2, y2,x_in)

	double precision, intent(in) :: x1, y1, x2, y2,x_in

	double precision :: slope, intercept

	slope = (y2 - y1) / (x2 - x1)
	intercept = y1 - slope * x1

	find_interpolated_value = x_in * slope + intercept
	
end function find_interpolated_value



end program sl_diff_params
