################################################################################
###                                                                          ###
###      SGP analysis script for PARCC New Jersey - Fall 2019 Analyses       ###
###                                                                          ###
################################################################################

if (!exists("sgp.test")) sgp.test <- FALSE
workers <- parallel::detectCores()/2

###   Load Packages

require(SGP)
require(data.table)

###   Load Data from Spring 2019 analyses and clean/preped Fall 2019 data and combine required years
load("./Data/Archive/2018_2019.2/New_Jersey_SGP_LONG_Data.Rdata")
load("./Data/Archive/2019_2020.1/New_Jersey_Data_LONG_2019_2020.1.Rdata")

New_Jersey_Data_LONG <-
          rbindlist(list(
                         New_Jersey_SGP_LONG_Data[YEAR %in% c("2017_2018.2", "2018_2019.1", "2018_2019.2")],
												 New_Jersey_Data_LONG_2019_2020.1), fill=TRUE)


###   Read in the Fall 2018 configuration code and combine into a single list.
source("../SGP_CONFIG/2019_2020.1/ELA.R")
source("../SGP_CONFIG/2019_2020.1/ELA_SS.R")
source("../SGP_CONFIG/2019_2020.1/MATHEMATICS.R")
source("../SGP_CONFIG/2019_2020.1/MATHEMATICS_SS.R")

PARCC_2019_2020.1.config <- c(
	ELA_2019_2020.1.config,
	ELA_SS_2019_2020.1.config,

	ALGEBRA_I.2019_2020.1.config,
	ALGEBRA_I_SS.2019_2020.1.config,
	ALGEBRA_II.2019_2020.1.config,
	ALGEBRA_II_SS.2019_2020.1.config,
	GEOMETRY.2019_2020.1.config,
	GEOMETRY_SS.2019_2020.1.config
)


###   abcSGP

SGPstateData[["NJ"]][["SGP_Configuration"]][["sgp.cohort.size"]] <- 900

New_Jersey_SGP <- abcSGP(
		state="NJ",
		sgp_object=New_Jersey_Data_LONG,
		steps=c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
		prepareSGP.create.additional.variables=FALSE,
		sgp.config = PARCC_2019_2020.1.config,
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
		outputSGP.output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data"),
		outputSGP.directory="./Data/Archive/2019_2020.1",
    parallel.config=list(
			BACKEND = "FOREACH", TYPE = "doParallel",
			WORKERS = list(TAUS = workers, SIMEX = workers)))

# table(New_Jersey_SGP@Data[, is.na(SGP), as.character(SGP_NORM_GROUP)])
# table(New_Jersey_SGP@Data[YEAR == '2019_2020.1', is.na(SGP_NOTE), as.character(SGP_NORM_GROUP)])

###   Save results

if (sgp.test) {
	save(New_Jersey_SGP, file="./Data/SIM/New_Jersey_SGP-Test_PARCC_2019_2020.1.Rdata")
} else save(New_Jersey_SGP, file="./Data/Archive/2019_2020.1/New_Jersey_SGP.Rdata")
