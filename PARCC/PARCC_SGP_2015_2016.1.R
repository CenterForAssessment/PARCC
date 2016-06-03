#################################################################################
###                                                                           ###
###       SGP analysis script for PARCC consortium - Fall 2015 Analyses       ###
###                                                                           ###
#################################################################################

### Load Packages

require(SGP)

setwd("/media/Data/Dropbox (SGP)/SGP/PARCC/PARCC")

### Load Data & configurations

load("Data/PARCC_Data_LONG.Rdata")

source("/media/Data/Dropbox (SGP)/Github_Repos/Projects/PARCC/PARCC/SGP_CONFIG/2015_2016.1/ELA.R")
source("/media/Data/Dropbox (SGP)/Github_Repos/Projects/PARCC/PARCC/SGP_CONFIG/2015_2016.1/ELA_SS.R")
source("/media/Data/Dropbox (SGP)/Github_Repos/Projects/PARCC/PARCC/SGP_CONFIG/2015_2016.1/MATHEMATICS.R")
source("/media/Data/Dropbox (SGP)/Github_Repos/Projects/PARCC/PARCC/SGP_CONFIG/2015_2016.1/MATHEMATICS_SS.R")

PARCC_2015_2016.1.config <- c(
	ELA_2015_2016.1.config,
	ELA_SS_2015_2016.1.config,

	ALGEBRA_I.2015_2016.1.config,
	ALGEBRA_I_SS.2015_2016.1.config,
	ALGEBRA_II.2015_2016.1.config,
	ALGEBRA_II_SS.2015_2016.1.config,
	GEOMETRY.2015_2016.1.config,
	GEOMETRY_SS.2015_2016.1.config
)


### abcSGP

PARCC_SGP <- abcSGP(
		PARCC_Data_LONG,
		sgp.config = PARCC_2015_2016.1.config,
		steps=c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
		sgp.percentiles=TRUE,
		sgp.projections=FALSE,
		sgp.projections.lagged=FALSE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline=FALSE,
		sgp.projections.lagged.baseline=FALSE,
		calculate.simex=TRUE,
		save.intermediate.results=FALSE,
		outputSGP.output.type=c("LONG_FINAL_YEAR_Data"),
        parallel.config=list(BACKEND="FOREACH", TYPE="doParallel", SNOW_TEST=TRUE, WORKERS=list(TAUS = 5, SIMEX=5)))

###  Save object

save(PARCC_SGP, file="Data/PARCC_SGP.Rdata")
