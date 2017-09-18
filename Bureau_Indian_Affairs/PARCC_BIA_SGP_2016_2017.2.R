####################################################################################
###                                                                              ###
###  SGP analysis script for PARCC Bureau_Indian_Affairs - Spring 2016 Analyses  ###
###                                                                              ###
####################################################################################

if (!exists("sgp.test")) sgp.test <- FALSE
workers <- parallel::detectCores()/2

### Load Packages
require(SGP)
require(RSQLite)
require(data.table)

###  PARCC SQLite database access function
source("../fetchPARCC.R")

### abcSGP

Bureau_Indian_Affairs_SGP <- abcSGP(
		state="BI",
		sgp_object=fetchPARCC(state="BI", parcc.db = "../PARCC/Data/PARCC_Data_LONG.sqlite", prior.years="2016_2", current.year="2017_2", fields="*")[GRADE %in% 3:6 & CONTENT_AREA %in% c("ELA", "MATHEMATICS", "ELA_SS", "MATHEMATICS_SS")],
		content_areas = c("ELA", "ELA_SS", "MATHEMATICS", "MATHEMATICS_SS"),
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
		outputSGP.directory="Data/Archive/2016_2017.2",
    parallel.config=list(
			BACKEND = "FOREACH", TYPE = "doParallel", SNOW_TEST = TRUE,
			WORKERS = list(TAUS = workers, SIMEX = workers)))

### Save results
if (sgp.test) {
	save(Bureau_Indian_Affairs_SGP, file="./Data/SIM/Bureau_Indian_Affairs_SGP-Test_PARCC_2016_2017.2.Rdata")
} else save(Bureau_Indian_Affairs_SGP, file="./Data/Archive/2016_2017.2/Bureau_Indian_Affairs_SGP.Rdata")

q("no")
