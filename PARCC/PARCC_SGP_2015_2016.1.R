#################################################################################
###                                                                           ###
###       SGP analysis script for PARCC consortium - Fall 2015 Analyses       ###
###                                                                           ###
#################################################################################

if (!exists("sgp.test")) sgp.test <- FALSE
workers <- parallel::detectCores()/2

### Load Packages

require(SGP)
require(RSQLite)
require(data.table)

###  Set working directory to PARCC/PARCC

### Load Data & configurations

# parcc.db <- "./Data/PARCC_Data_LONG_Simulated.sqlite"
parcc.db <- "./Data/PARCC_Data_LONG.sqlite"

source("../PARCC/SGP_CONFIG/2015_2016.1/ELA.R")
source("../PARCC/SGP_CONFIG/2015_2016.1/ELA_SS.R")
source("../PARCC/SGP_CONFIG/2015_2016.1/MATHEMATICS.R")
source("../PARCC/SGP_CONFIG/2015_2016.1/MATHEMATICS_SS.R")

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
		state="PARCC",
		sgp_object=rbindlist(list(
			dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select * from PARCC_Data_LONG_2015_2"),
			dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select * from PARCC_Data_LONG_2016_1"))),
		sgp.config = PARCC_2015_2016.1.config,
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
		outputSGP.output.type=c("LONG_FINAL_YEAR_Data"),
        parallel.config=list(BACKEND="FOREACH", TYPE="doParallel", SNOW_TEST=TRUE, WORKERS=list(TAUS = workers, SIMEX=workers)))

###  Save object

save(PARCC_SGP, file="Data/PARCC_SGP.Rdata")

q("no")
