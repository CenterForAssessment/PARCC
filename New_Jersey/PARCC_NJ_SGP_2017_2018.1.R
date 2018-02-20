#################################################################################
###                                                                           ###
###       SGP analysis script for PARCC consortium - Fall 2017 Analyses       ###
###                                                                           ###
#################################################################################

if (!exists("sgp.test")) sgp.test <- FALSE
workers <- parallel::detectCores()/2

###   Load Packages

require(SGP)
require(RSQLite)
require(data.table)

source("~/Dropbox (SGP)/Github_Repos/Projects/PARCC/fetchPARCC.R")


###   Create Fall 2017 Archive for NJ

dir.create("./Data/Archive/2017_2018.1", recursive=TRUE)

###   Read in the Spring 2017 configuration code and combine into a single list.

source("../SGP_CONFIG/2017_2018.1/ELA.R")
source("../SGP_CONFIG/2017_2018.1/ELA_SS.R")
source("../SGP_CONFIG/2017_2018.1/MATHEMATICS.R")
source("../SGP_CONFIG/2017_2018.1/MATHEMATICS_SS.R")

PARCC_2017_2018.1.config <- c(
	ELA_2017_2018.1.config,
	ELA_SS_2017_2018.1.config,

	ALGEBRA_I.2017_2018.1.config,
	ALGEBRA_I_SS.2017_2018.1.config,
	ALGEBRA_II.2017_2018.1.config,
	ALGEBRA_II_SS.2017_2018.1.config,
	GEOMETRY.2017_2018.1.config,
	GEOMETRY_SS.2017_2018.1.config
)


###   abcSGP

New_Jersey_SGP <- abcSGP(
		state="NJ",
		sgp_object=fetchPARCC(
			state="NJ", fields="*",
			parcc.db = "~/Dropbox (SGP)/SGP/PARCC/PARCC/Data/PARCC_Data_LONG.sqlite",
			prior.years=c("2015_2", "2016_1", "2016_2", "2017_1", "2017_2"),
			current.year="2018_1"),
		sgp.config = PARCC_2017_2018.1.config,
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
		outputSGP.output.type="LONG_FINAL_YEAR_Data",
		outputSGP.directory="../New_Jersey/Data/Archive/2017_2018.1",
    parallel.config=list(
			BACKEND = "FOREACH", TYPE = "doParallel", SNOW_TEST = TRUE,
			WORKERS = list(TAUS = workers, SIMEX = workers)))

# table(New_Jersey_SGP@Data[, is.na(SGP), as.character(SGP_NORM_GROUP)])
# table(New_Jersey_SGP@Data[, is.na(SGP_NOTE), as.character(SGP_NORM_GROUP)])


###   Save results

if (sgp.test) {
	save(New_Jersey_SGP, file="./Data/SIM/New_Jersey_SGP-Test_PARCC_2017_2018.1.Rdata")
} else save(New_Jersey_SGP, file="./Data/Archive/2017_2018.1/New_Jersey_SGP.Rdata")


sessionInfo(); q("no")
