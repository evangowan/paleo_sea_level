# The compiler
FC = gfortran

FCFLAGS2 = -g -fbacktrace -fbounds-check 
FCFLAGS = -O2 
OBFLAGS = -c


radiocarbon_statistics: radiocarbon_statistics.f90
	$(FC) -o radiocarbon_statistics $(FCFLAGS) radiocarbon_statistics.f90

shared_subs.o: shared_subs.f90
	 $(FC) -o shared_subs.o $(OBFLAGS) $(FCFLAGS) shared_subs.f90

extract_calc_sea_level: extract_calc_sea_level.f90 shared_subs.o
	$(FC) -o extract_calc_sea_level $(FCFLAGS) extract_calc_sea_level.f90 shared_subs.o
