#################################################################################
###                                                                           ###
###       SGP analysis script for PARCC consortium - Fall 2017 Analyses       ###
###                                                                           ###
#################################################################################


if (!exists("sgp.test")) sgp.test <- FALSE
workers <- parallel::detectCores()/2

### Load Packages

require(SGP)
require(RSQLite)
require(data.table)


###  Load SGP LONG Data from Spring 2017 Analyses
load("./Data/Archive/2016_2017.2/PARCC_SGP_LONG_Data.Rdata")

###  Location of PARCC SQLite Database (Fall 2017 added in Data Prep step)
parcc.db <- "/media/Data/Dropbox (SGP)/SGP/PARCC/PARCC/Data/PARCC_Data_LONG.sqlite"

###  Read in the Spring 2016 configuration code and combine into a single list.

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


### abcSGP

PARCC_SGP <- abcSGP(
		state="PARCC", # sgp_object=PARCC_Data_LONG_2017_2018.1,
		# sgp_object=rbindlist(list(PARCC_SGP_LONG_Data, PARCC_Data_LONG_2017_2018.1), fill=TRUE),
		sgp_object=rbindlist(list(
			PARCC_SGP_LONG_Data,
			dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select * from PARCC_Data_LONG_2018_1")), fill=TRUE),
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
		outputSGP.output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data"),
		outputSGP.directory="Data/Archive/2017_2018.1",
    parallel.config=list(
			BACKEND = "FOREACH", TYPE = "doParallel", SNOW_TEST = TRUE,
			WORKERS = list(TAUS = workers, SIMEX = workers)))


### Save results

if (sgp.test) {
	save(PARCC_SGP, file="./Data/SIM/PARCC_SGP-Test_PARCC_2017_2018.1.Rdata")
} else save(PARCC_SGP, file="./Data/Archive/2017_2018.1/PARCC_SGP.Rdata")


q("no")
