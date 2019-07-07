####################################################################################
###                                                                              ###
###  SGP analysis script for PARCC Department_of_Defense - Spring 2019 Analyses  ###
###                                                                              ###
####################################################################################

if (!exists("sgp.test")) sgp.test <- FALSE
workers <- parallel::detectCores()/2

### Load Packages
require(SGP)
require(data.table)

###  Load Data
load("./Data/Archive/2017_2018.2/PARCC_Data_LONG_2017_2018.2.Rdata")
load("./Data/Archive/2018_2019.2/Department_of_Defense_Data_LONG_Data_LONG_2018_2019.2.Rdata")

Department_of_Defense_Data_LONG <- rbindlist(list(PARCC_Data_LONG_2017_2018.2, Department_of_Defense_Data_LONG_Data_LONG_2018_2019.2), fill=TRUE)

rm(list = c("PARCC_Data_LONG_2017_2018.2", "PARCC_Data_LONG_2018_2019.2"))

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
	ALGEBRA_II_SS.2018_2019.2.config
)

### abcSGP

Department_of_Defense_SGP <- abcSGP(
		state="DD",
		sgp_object=Department_of_Defense_Data_LONG,
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
			BACKEND = "FOREACH", TYPE = "doParallel",
			WORKERS = list(TAUS = workers, SIMEX = workers)))

### Save results
if (sgp.test) {
	save(Department_of_Defense_SGP, file="./Data/SIM/Department_of_Defense_SGP-Test_PARCC_2018_2019.2.Rdata")
} else save(Department_of_Defense_SGP, file="./Data/Archive/2018_2019.2/Department_of_Defense_SGP.Rdata")

### visualizeSGP

###  Not enough consistent grade progressions to do projections/growthAchievementPlot

q("no")
