####################################################################################
###                                                                              ###
###  SGP analysis script for PARCC Bureau_Indian_Affairs - Spring 2019 Analyses  ###
###                                                                              ###
####################################################################################

if (!exists("sgp.test")) sgp.test <- FALSE
workers <- parallel::detectCores()/2

### Load Packages
require(SGP)
require(data.table)

###  Load Data
load("./Data/Archive/2018_2019.2/Bureau_Indian_Affairs_Data_LONG_2018_2019.2.Rdata")
load("./Data/Archive/2016_2017.2/Bureau_Indian_Affairs_SGP_LONG_Data_2016_2017.2.Rdata")
load("./Data/Archive/2017_2018.2/Bureau_Indian_Affairs_SGP_LONG_Data_2017_2018.2.Rdata")
load("./Data/Archive/2018_2019.1/Bureau_Indian_Affairs_SGP_LONG_Data_2018_2019.1.Rdata")
Bureau_Indian_Affairs_SGP_LONG_Data_2016_2017.2 <- `_SGP_LONG_Data_2016_2017.2`; rm(`_SGP_LONG_Data_2016_2017.2`) # outputSGP naming issue with BIA

Bureau_Indian_Affairs_SGP_LONG_Data <- rbindlist(list(
				Bureau_Indian_Affairs_SGP_LONG_Data_2016_2017.2,
				Bureau_Indian_Affairs_SGP_LONG_Data_2017_2018.2,
				Bureau_Indian_Affairs_SGP_LONG_Data_2018_2019.1,
				PARCC_Data_LONG_2018_2019.2), fill=TRUE)

###  Read in the Spring 2018 configuration code and combine into a single list.
source("../SGP_CONFIG/2018_2019.2/ELA.R")
source("../SGP_CONFIG/2018_2019.2/ELA_SS.R")
source("../SGP_CONFIG/2018_2019.2/MATHEMATICS.R")
source("../SGP_CONFIG/2018_2019.2/MATHEMATICS_SS.R")

PARCC_2018_2019.2.config <- c(
	ELA.2018_2019.2.config,
	ELA_SS.2018_2019.2.config,

	MATHEMATICS.2018_2019.2.config,
	MATHEMATICS_SS.2018_2019.2.config,

	ALGEBRA_I.2018_2019.2.config,
	ALGEBRA_I_SS.2018_2019.2.config,
	GEOMETRY.2018_2019.2.config,
	GEOMETRY_SS.2018_2019.2.config,
	ALGEBRA_II.2018_2019.2.config,
	ALGEBRA_II_SS.2018_2019.2.config,

	INTEGRATED_MATH_1.2018_2019.2.config,
	INTEGRATED_MATH_1_SS.2018_2019.2.config,
	INTEGRATED_MATH_2.2018_2019.2.config,
	INTEGRATED_MATH_2_SS.2018_2019.2.config,
	INTEGRATED_MATH_3.2018_2019.2.config,
	INTEGRATED_MATH_3_SS.2018_2019.2.config
)

### abcSGP

Bureau_Indian_Affairs_SGP <- abcSGP(
		state="BI",
		sgp_object=Bureau_Indian_Affairs_SGP_LONG_Data,
		sgp.config = PARCC_2018_2019.2.config,
		steps=c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
		prepareSGP.create.additional.variables=FALSE,
		sgp.percentiles=TRUE,
		sgp.projections=FALSE,
		sgp.projections.lagged=FALSE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline=FALSE,
		sgp.projections.lagged.baseline=FALSE,
		calculate.simex= if (sgp.test) list(lambda=seq(0,2,0.5), simulation.iterations=10, csem.data.vnames="SCALE_SCORE_CSEM", extrapolation="linear", save.matrices=TRUE) else TRUE,
		sgp.test.cohort.size= if (sgp.test) 1500 else NULL,     ####
		return.sgp.test.results= if (sgp.test) TRUE else FALSE, ## -- Turn OFF these 3 for real analyses
		goodness.of.fit.print= if (sgp.test) FALSE else TRUE,   ####
		save.intermediate.results=FALSE,
		sgp.target.scale.scores=FALSE, # to combineSGP
		outputSGP.output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data"),
		outputSGP.directory="Data/Archive/2018_2019.2",
    parallel.config=list(
			BACKEND = "FOREACH", TYPE = "doParallel", SNOW_TEST = TRUE,
			WORKERS = list(TAUS = workers, SIMEX = workers)))

### Save results
if (sgp.test) {
	save(Bureau_Indian_Affairs_SGP, file="./Data/SIM/Bureau_Indian_Affairs_SGP-Test_PARCC_2018_2019.2.Rdata")
} else save(Bureau_Indian_Affairs_SGP, file="./Data/Archive/2018_2019.2/Bureau_Indian_Affairs_SGP.Rdata")

### visualizeSGP

###  Not enough consistent grade progressions to do projections/growthAchievementPlot
