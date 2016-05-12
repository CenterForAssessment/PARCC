#########################################################################
###
### SGP analysis script for PARCC consortium
###
#########################################################################

### Load Packages

require(SGP)


### Load Data

load("/media/Data/Dropbox (SGP)/SGP/PARCC/PARCC/Data/PARCC_Data_LONG_Simulated.Rdata")

source("/media/Data/Dropbox (SGP)/Github_Repos/Projects/PARCC/PARCC/SGP_CONFIG/2015_2016.2/ELA.R")
source("/media/Data/Dropbox (SGP)/Github_Repos/Projects/PARCC/PARCC/SGP_CONFIG/2015_2016.2/ELA_SS.R")
source("/media/Data/Dropbox (SGP)/Github_Repos/Projects/PARCC/PARCC/SGP_CONFIG/2015_2016.2/MATHEMATICS.R")
source("/media/Data/Dropbox (SGP)/Github_Repos/Projects/PARCC/PARCC/SGP_CONFIG/2015_2016.2/MATHEMATICS_SS.R")

PARCC_2016.config <- c(
	ELA_2015_2016.2.config,
	ELA_SS_2015_2016.2.config,

	MATHEMATICS_2015_2016.config,
	MATHEMATICS_SS_2015_2016.config,

	ALGEBRA_I.2015_2016.config,
	ALGEBRA_I_SS.2015_2016.config,
	ALGEBRA_II.2015_2016.config,
	ALGEBRA_II_SS.2015_2016.config,
	GEOMETRY.2015_2016.config,
	GEOMETRY_SS.2015_2016.config,

	INTEGRATED_MATH_1.2015_2016.config,
	INTEGRATED_MATH_1_SS.2015_2016.config,
	INTEGRATED_MATH_2.2015_2016.config,
	INTEGRATED_MATH_2_SS.2015_2016.config,
	INTEGRATED_MATH_3.2015_2016.config,
	INTEGRATED_MATH_3_SS.2015_2016.config
)


### abcSGP

PARCC_SGP <- abcSGP(
		PARCC_Data_LONG,
		sgp.config = PARCC_2016.config,
		steps=c("prepareSGP", "analyzeSGP", "combineSGP", "visualizeSGP", "outputSGP"),
		sgp.percentiles=TRUE,
		sgp.projections=TRUE,
		sgp.projections.lagged=TRUE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline=FALSE,
		sgp.projections.lagged.baseline=FALSE,
		calculate.simex=TRUE,
		save.intermediate.results=FALSE,
		get.cohort.data.info=TRUE,
        parallel.config=list(BACKEND="FOREACH", TYPE="doParallel", SNOW_TEST=TRUE, WORKERS=list(TAUS = 25, SIMEX=25)))
		# parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=4, PROJECTIONS=4, LAGGED_PROJECTIONS=4, SGP_SCALE_SCORE_TARGETS=4)))


### Save results

save(PARCC_SGP, file="Data/PARCC_SGP.Rdata")

