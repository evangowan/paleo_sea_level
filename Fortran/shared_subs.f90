module shared_subs

contains

integer function number_entries(file_unit)

	implicit none
	integer, intent(in) :: file_unit

	integer :: istat
	character(len=80) :: dummy

	number_entries = 0

	read_file: do

		read(file_unit,*, iostat=istat) dummy
		if(istat /= 0 ) THEN
			exit read_file
		endif

		number_entries = number_entries + 1

	end do read_file

	rewind(unit=file_unit)

end function number_entries


subroutine search_date(lab_id_array, two_sigma_lower_array, two_sigma_higher_array, number_age_parameters, lab_id, average_age, &
 age_error, success)

	implicit none
	integer, intent(in) :: number_age_parameters
	character(len=80), dimension(number_age_parameters), intent(in) :: lab_id_array
	double precision, dimension(number_age_parameters), intent(in) :: two_sigma_higher_array, two_sigma_lower_array
	character(len=80), intent(in) :: lab_id

	double precision, intent(out) :: average_age, age_error
	logical, intent(out) :: success

	integer :: counter

	success = .false.

	searching: do counter = 1, number_age_parameters

		if(lab_id_array(counter) == lab_id) THEN 

			average_age = (two_sigma_higher_array(counter) + two_sigma_lower_array(counter)) / 2.
			age_error = average_age - two_sigma_lower_array(counter)

			success = .true.
			exit searching
		end if


	end do searching



end subroutine search_date

end module shared_subs
