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
require(data.table)


###  Load SGP LONG Data from Spring 2016 Analyses
load("./Data/Archive/2015_2016.2/PARCC_SGP_LONG_Data.Rdata")

###  Remove old duplicate case tags and invalidate exact duplicates created in Spring 2016 Analyses:
PARCC_SGP_LONG_Data[, ID:=gsub("_DUPS_[0-9]*", "", ID)]
PARCC_SGP_LONG_Data[, VALID_CASE := "VALID_CASE"]
setkey(PARCC_SGP_LONG_Data, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID, SCALE_SCORE, SGP)
setkey(PARCC_SGP_LONG_Data, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID, SCALE_SCORE)
PARCC_SGP_LONG_Data[which(duplicated(PARCC_SGP_LONG_Data, by=key(PARCC_SGP_LONG_Data)))-1, VALID_CASE := "INVALID_CASE"] # 105
table(PARCC_SGP_LONG_Data[, VALID_CASE])

###  Location of PARCC SQLite Database (Fall 2016 added in Data Prep step)
parcc.db <- "./Data/PARCC_Data_LONG.sqlite"

###  Read in the Spring 2016 configuration code and combine into a single list.

source("../SGP_CONFIG/2016_2017.1/ELA.R")
source("../SGP_CONFIG/2016_2017.1/ELA_SS.R")
source("../SGP_CONFIG/2016_2017.1/MATHEMATICS.R")
source("../SGP_CONFIG/2016_2017.1/MATHEMATICS_SS.R")

PARCC_2016_2017.1.config <- c(
	ELA_2016_2017.1.config,
	ELA_SS_2016_2017.1.config,

	ALGEBRA_I.2016_2017.1.config,
	ALGEBRA_I_SS.2016_2017.1.config,
	ALGEBRA_II.2016_2017.1.config,
	ALGEBRA_II_SS.2016_2017.1.config,
	GEOMETRY.2016_2017.1.config,
	GEOMETRY_SS.2016_2017.1.config
)


### abcSGP

PARCC_SGP <- abcSGP(
		state="PARCC",
		sgp_object=rbindlist(list(PARCC_SGP_LONG_Data, PARCC_Data_LONG_2016_2017.1), fill=TRUE),
		# sgp_object=rbindlist(list(
		# 	PARCC_SGP_LONG_Data,
		# 	dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select * from PARCC_Data_LONG_2017_1")), fill=TRUE),
		sgp.config = PARCC_2016_2017.1.config,
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
		outputSGP.directory="Data/Archive/2016_2017.1",
    parallel.config=list(
			BACKEND = "FOREACH", TYPE = "doParallel", SNOW_TEST = TRUE,
			WORKERS = list(TAUS = workers, SIMEX = workers)))


### Save results

if (sgp.test) {
	save(PARCC_SGP, file="./Data/SIM/PARCC_SGP-Test_PARCC_2016_2017.1.Rdata")
} else save(PARCC_SGP, file="./Data/Archive/2016_2017.1/PARCC_SGP.Rdata")


q("no")
