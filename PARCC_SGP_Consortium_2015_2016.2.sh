#! /bin/bash

cd PARCC

if [ "$sgp_test" = "sgp.test <- TRUE" ]; then
	echo Running PARCC with TEST cohort subset
	echo Beggining Part 1 - Spring 15 to Fall 15, SGP object creation
	echo $sgp_test > PARCC1.R
	cat "./PARCC_SGP_2015_2016.1.R" >> PARCC1.R

	R CMD BATCH --vanilla PARCC1.R; mv ./PARCC1.Rout ./Logs/PARCC1.Rout
fi

if [ "$sgp_test" = "sgp.test <- TRUE" ]; then
	pid=$!
	wait $pid
	echo Running PARCC with TEST cohort subset
	echo Beggining Part 2 - Spring 15 to Spring 16
	echo $sgp_test > PARCC2.R
	cat "./PARCC_SGP_2015_2016.2.R" >> PARCC2.R

	R CMD BATCH --vanilla PARCC2.R; mv ./PARCC2.Rout ./Logs/PARCC2.Rout; rm PARCC2.R	
else
	echo Running PARCC with FULL cohort
	echo Beggining Spring 15 to Spring 16 Analyses
	
	R CMD BATCH --vanilla PARCC_SGP_2015_2016.2.R; mv ./PARCC_SGP_2015_2016.2.Rout ./Logs/PARCC_SGP_2015_2016.2.Rout
fi

cd ../
