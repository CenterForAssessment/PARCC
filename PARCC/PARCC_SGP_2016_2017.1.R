#################################################################################
###                                                                           ###
###       SGP analysis script for PARCC consortium - Fall 2016 Analyses       ###
###                                                                           ###
#################################################################################


if (!exists("sgp.test")) sgp.test <- FALSE
workers <- parallel::detectCores()/2

### Load Packages

require(SGP)
require(RSQLite)


### Load Data
if (sgp.test) {
	load("./Data/SIM/PARCC_SGP-Test.Rdata")
} else load("./Data/PARCC_SGP.Rdata")

# parcc.db <- "./Data/PARCC_Data_LONG_Simulated.sqlite"
parcc.db <- "./Data/PARCC_Data_LONG.sqlite"


###  Read in the Spring 2016 configuration code and combine into a single list.

source("../SGP_CONFIG/2016_2017.1/ELA.R")
source("../SGP_CONFIG/2016_2017.1/ELA_SS.R")
source("../SGP_CONFIG/2016_2017.1/MATHEMATICS.R")
source("../SGP_CONFIG/2016_2017.1/MATHEMATICS_SS.R")


PARCC_2016_2017.1.config <- c(
	ELA_2016_2017.1.config,
	ELA_SS_2016_2017.1.config,

	MATHEMATICS_2016_2017.1.config,
	MATHEMATICS_SS_2016_2017.1.config,

	ALGEBRA_I.2016_2017.1.config,
	ALGEBRA_I_SS.2016_2017.1.config,
	ALGEBRA_II.2016_2017.1.config,
	ALGEBRA_II_SS.2016_2017.1.config,
	GEOMETRY.2016_2017.1.config,
	GEOMETRY_SS.2016_2017.1.config,

	INTEGRATED_MATH_1.2016_2017.1.config,
	INTEGRATED_MATH_1_SS.2016_2017.1.config,
	INTEGRATED_MATH_2.2016_2017.1.config,
	INTEGRATED_MATH_2_SS.2016_2017.1.config,
	INTEGRATED_MATH_3.2016_2017.1.config,
	INTEGRATED_MATH_3_SS.2016_2017.1.config
)


### updateSGP

PARCC_SGP <- updateSGP(
		what_sgp_object=PARCC_SGP,
		with_sgp_data_LONG = dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select * from PARCC_Data_LONG_2017_1"),
		sgp.config = PARCC_2016_2017.1.config,
		steps=c("prepareSGP", "analyzeSGP"),
		sgp.percentiles = TRUE,
		sgp.projections = FALSE,
		sgp.projections.lagged = FALSE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline = FALSE,
		sgp.projections.lagged.baseline = FALSE,
		sgp.percentiles.equated = FALSE,
		simulate.sgps = TRUE,
		calculate.simex= if (sgp.test) list(lambda=seq(0,2,0.5), simulation.iterations=10, csem.data.vnames="SCALE_SCORE_CSEM", extrapolation="linear", save.matrices=TRUE) else TRUE,
		sgp.test.cohort.size= if (sgp.test) 1500 else NULL,     ####
		return.sgp.test.results= if (sgp.test) TRUE else FALSE, ## -- Turn OFF these 3 for real analyses
		goodness.of.fit.print= if (sgp.test) FALSE else TRUE,   ####
		save.intermediate.results=FALSE,
		outputSGP.output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data"),
		parallel.config=list(BACKEND="FOREACH", TYPE="doParallel", WORKERS=list(TAUS = workers, SIMEX = workers)))


### combineSGP

PARCC_SGP <- combineSGP(PARCC_SGP)


### outputSGP

outputSGP(PARCC_SGP, outputSGP.directory=if (sgp.test) "Data/SIM" else "Data")


### Save results

if (sgp.test) {
	save(PARCC_SGP, file="./Data/SIM/PARCC_SGP-Test.Rdata")
} else save(PARCC_SGP, file="./Data/PARCC_SGP.Rdata")


q("no")
