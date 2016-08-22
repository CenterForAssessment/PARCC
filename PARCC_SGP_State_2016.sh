#! /bin/bash

if [ "$sgp_test" = "sgp.test <- TRUE" ]; then
	echo Beginning 2016 STATE Analyses with TEST cohort subset

	cd ./Colorado
	echo $sgp_test > CO.R
	cat "./PARCC_CO_SGP_2015_2016.2.R" >> CO.R
	R CMD BATCH --vanilla CO.R; mv ./CO.Rout ./Logs/CO.Rout; rm CO.R &
	
	pid=$!
	wait $pid
	cd ../Illinois
	echo $sgp_test > IL.R
	cat "./PARCC_IL_SGP_2015_2016.2.R" >> IL.R
	R CMD BATCH --vanilla IL.R; mv ./IL.Rout ./Logs/IL.Rout; rm IL.R &

	pid=$!
	wait $pid
	cd ../Maryland
	echo $sgp_test > MD.R
	cat "./PARCC_MD_SGP_2015_2016.2.R" >> MD.R
	R CMD BATCH --vanilla MD.R; mv ./MD.Rout ./Logs/MD.Rout; rm MD.R &
	
	pid=$!
	wait $pid
	cd ../Massachusetts
	echo $sgp_test > MA.R
	cat "./PARCC_MA_SGP_2015_2016.2.R" >> MA.R
	R CMD BATCH --vanilla MA.R; mv ./MA.Rout ./Logs/MA.Rout; rm MA.R &
	
	pid=$!
	wait $pid
	cd ../New_Jersey; echo $sgp_test > NJ.R
	cat "./PARCC_NJ_SGP_2015_2016.2.R" >> NJ.R
	R CMD BATCH --vanilla NJ.R; mv ./NJ.Rout ./Logs/NJ.Rout; rm NJ.R &

	pid=$!
	wait $pid
	cd ../New_Mexico
	echo $sgp_test > NM.R
	cat "./PARCC_NM_SGP_2015_2016.2.R" >> NM.R
	R CMD BATCH --vanilla NM.R; mv ./NM.Rout ./Logs/NM.Rout; rm NM.R &

	pid=$!
	wait $pid
	cd ../Rhode_Island
	echo $sgp_test > RI.R
	cat "./PARCC_RI_SGP_2015_2016.2.R" >> RI.R
	R CMD BATCH --vanilla RI.R; mv ./RI.Rout ./Logs/RI.Rout; rm RI.R &
	
	pid=$!
	wait $pid
	cd ../Washington_DC
	echo $sgp_test > DC.R
	cat "./PARCC_DC_SGP_2015_2016.2.R" >> DC.R
	R CMD BATCH --vanilla DC.R; mv ./DC.Rout ./Logs/DC.Rout; rm DC.R &
	
else
	echo Running STATES with FULL cohort
	echo Beggining 2016 STATE Analyses

	cd ./Colorado
	R CMD BATCH --vanilla PARCC_CO_SGP_2015_2016.2.R; mv ./PARCC_CO_SGP_2015_2016.2.Rout ./Logs/PARCC_CO_SGP_2015_2016.2.Rout &
	
	pid=$!
	wait $pid
	cd ../Illinois
	R CMD BATCH --vanilla PARCC_IL_SGP_2015_2016.2.R; mv ./PARCC_IL_SGP_2015_2016.2.Rout ./Logs/PARCC_IL_SGP_2015_2016.2.Rout &

	pid=$!
	wait $pid
	cd ../Maryland
	R CMD BATCH --vanilla PARCC_MD_SGP_2015_2016.2.R; mv ./PARCC_MD_SGP_2015_2016.2.Rout ./Logs/PARCC_MD_SGP_2015_2016.2.Rout &
	
	pid=$!
	wait $pid
	cd ../Massachusetts
	R CMD BATCH --vanilla PARCC_MA_SGP_2015_2016.2.R; mv ./PARCC_MA_SGP_2015_2016.2.Rout ./Logs/PARCC_MA_SGP_2015_2016.2.Rout &
	
	pid=$!
	wait $pid
	cd ../New_Jersey
	R CMD BATCH --vanilla PARCC_NJ_SGP_2015_2016.2.R; mv ./PARCC_NJ_SGP_2015_2016.2.Rout ./Logs/PARCC_NJ_SGP_2015_2016.2.Rout &

	pid=$!
	wait $pid
	cd ../New_Mexico
	R CMD BATCH --vanilla PARCC_NM_SGP_2015_2016.2.R; mv ./PARCC_NM_SGP_2015_2016.2.Rout ./Logs/PARCC_NM_SGP_2015_2016.2.Rout &

	pid=$!
	wait $pid
	cd ../Rhode_Island
	R CMD BATCH --vanilla PARCC_RI_SGP_2015_2016.2.R; mv ./PARCC_RI_SGP_2015_2016.2.Rout ./Logs/PARCC_RI_SGP_2015_2016.2.Rout &
	
	pid=$!
	wait $pid
	cd ../Washington_DC
	R CMD BATCH --vanilla PARCC_DC_SGP_2015_2016.2.R; mv ./PARCC_DC_SGP_2015_2016.2.Rout ./Logs/PARCC_DC_SGP_2015_2016.2.Rout

	pid=$!
	wait $pid

fi

cd ../
