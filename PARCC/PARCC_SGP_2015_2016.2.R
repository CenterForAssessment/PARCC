#################################################################################
###                                                                           ###
###      SGP analysis script for PARCC consortium - Spring 2016 Analyses      ###
###                                                                           ###
#################################################################################

### Load Packages

require(SGP)

setwd("/media/Data/Dropbox (SGP)/SGP/PARCC/PARCC")


### Load Data & configurations

load("Data/PARCC_Data_LONG_2016.Rdata")

source("/media/Data/Dropbox (SGP)/Github_Repos/Projects/PARCC/PARCC/SGP_CONFIG/2015_2016.2/ELA.R")
source("/media/Data/Dropbox (SGP)/Github_Repos/Projects/PARCC/PARCC/SGP_CONFIG/2015_2016.2/ELA_SS.R")
source("/media/Data/Dropbox (SGP)/Github_Repos/Projects/PARCC/PARCC/SGP_CONFIG/2015_2016.2/MATHEMATICS.R")
source("/media/Data/Dropbox (SGP)/Github_Repos/Projects/PARCC/PARCC/SGP_CONFIG/2015_2016.2/MATHEMATICS_SS.R")


PARCC_2015_2016.2.config <- c(
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

### updateSGP

PARCC_SGP <- updateSGP(
		what_sgp_object=PARCC_SGP,
		with_sgp_data_LONG=PARCC_Data_LONG_2016,
		sgp.config = PARCC_2015_2016.2.config,
		steps=c("prepareSGP", "analyzeSGP"),
		sgp.percentiles = TRUE,
		sgp.projections = FALSE,
		sgp.projections.lagged = FALSE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline = FALSE,
		sgp.projections.lagged.baseline = FALSE,
		sgp.percentiles.equated = FALSE,
		simulate.sgps = TRUE,
		calculate.simex = TRUE,
		goodness.of.fit.print=TRUE,
		save.intermediate.results=FALSE,
		outputSGP.output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data"),
		parallel.config=list(BACKEND="FOREACH", TYPE="doParallel", SNOW_TEST=TRUE, WORKERS=list(TAUS = 12, SIMEX=12)))

### analyzeSGP (for student growth projections)

PARCC_SGP <- analyzeSGP(
		PARCC_SGP,
		sgp.config=PARCC_2016.config,
		sgp.percentiles=FALSE,
		sgp.projections=TRUE,
		sgp.projections.lagged=TRUE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline=FALSE,
		sgp.projections.lagged.baseline=FALSE,
		parallel.config=list(BACKEND="FOREACH", TYPE="doParallel", SNOW_TEST=TRUE, WORKERS=list(PROJECTIONS=10, LAGGED_PROJECTIONS=10))) # 4:15 (4:50 @ 12)


### combineSGP

PARCC_SGP <- combineSGP(
		PARCC_SGP,
		sgp.target.scale.scores=TRUE,
		sgp.config=PARCC_2016.config,
		parallel.config=list(BACKEND="FOREACH", TYPE="doParallel", SNOW_TEST=TRUE, WORKERS=list(SGP_SCALE_SCORE_TARGETS=10)))

save(PARCC_SGP, file="Data/PARCC_SGP.Rdata")


### visualizeSGP

visualizeSGP(
	PARCC_SGP,
	plot.types=c("growthAchievementPlot", "studentGrowthPlot"),
	sgPlot.demo.report=TRUE)


### outputSGP

outputSGP(PARCC_SGP)


### Save results

save(PARCC_SGP, file="Data/PARCC_SGP.Rdata")
