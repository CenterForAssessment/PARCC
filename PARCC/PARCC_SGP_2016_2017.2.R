#################################################################################
###                                                                           ###
###      SGP analysis script for PARCC consortium - Spring 2017 Analyses      ###
###                                                                           ###
#################################################################################


if (!exists("sgp.test")) sgp.test <- FALSE
workers <- parallel::detectCores()/2

### Load Packages

require(SGP)
require(RSQLite)
require(data.table)


###  Load SGP LONG Data from FALL 2016 Analyses
load("./Data/Archive/2016_2017.1/PARCC_SGP_LONG_Data.Rdata")
PARCC_Prior_Data <- copy(PARCC_SGP_LONG_Data[StateAbbreviation != "MA"])[, ID:=gsub("_DUPS_[0-9]*", "", ID)]

###   INVALIDate duplicate prior test scores

setkey(PARCC_Prior_Data, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID, SCALE_SCORE, SCALE_SCORE_ACTUAL)
setkey(PARCC_Prior_Data, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID)
# dups <- PARCC_Prior_Data[c(which(duplicated(PARCC_Prior_Data, by=key(PARCC_Prior_Data)))-1, which(duplicated(PARCC_Prior_Data, by=key(PARCC_Prior_Data)))),]
# setkeyv(dups, key(PARCC_Prior_Data))
PARCC_Prior_Data[which(duplicated(PARCC_Prior_Data, by=key(PARCC_Prior_Data)))-1, VALID_CASE := "INVALID_CASE"]

###  Location of PARCC SQLite Database (Spring 2017 added in Data Prep step)
parcc.db <- "./Data/PARCC_Data_LONG.sqlite"

###  Read in the Spring 2017 configuration code and combine into a single list.

source("./SGP_CONFIG/2016_2017.2/ELA.R")
source("./SGP_CONFIG/2016_2017.2/ELA_SS.R")
source("./SGP_CONFIG/2016_2017.2/MATHEMATICS.R")
source("./SGP_CONFIG/2016_2017.2/MATHEMATICS_SS.R")


PARCC_2016_2017.2.config <- c(
	ELA.2016_2017.2.config,
	ELA_SS.2016_2017.2.config,

	MATHEMATICS.2016_2017.2.config,
	MATHEMATICS_SS.2016_2017.2.config,

	ALGEBRA_I.2016_2017.2.config,
	ALGEBRA_I_SS.2016_2017.2.config,
	ALGEBRA_II.2016_2017.2.config,
	ALGEBRA_II_SS.2016_2017.2.config,
	GEOMETRY.2016_2017.2.config,
	GEOMETRY_SS.2016_2017.2.config,

	INTEGRATED_MATH_1.2016_2017.2.config,
	INTEGRATED_MATH_1_SS.2016_2017.2.config,
	INTEGRATED_MATH_2.2016_2017.2.config,
	INTEGRATED_MATH_2_SS.2016_2017.2.config,
	INTEGRATED_MATH_3.2016_2017.2.config,
	INTEGRATED_MATH_3_SS.2016_2017.2.config
)


### abcSGP

PARCC_SGP <- abcSGP(
		state="PARCC",
		sgp_object=rbindlist(list(
			PARCC_Prior_Data, PARCC_Data_LONG_2016_2017.2), fill=TRUE),
			# dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select * from PARCC_Data_LONG_2017_2")), fill=TRUE),
		sgp.config = PARCC_2016_2017.2.config,
		steps=c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
		prepareSGP.create.additional.variables=FALSE,
		sgp.percentiles=TRUE,
		sgp.projections=TRUE,
		sgp.projections.lagged=TRUE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline=FALSE,
		sgp.projections.lagged.baseline=FALSE,
		calculate.simex= if (sgp.test) list(lambda=seq(0,2,0.5), simulation.iterations=10, csem.data.vnames="SCALE_SCORE_CSEM", extrapolation="linear", save.matrices=TRUE) else TRUE,
		sgp.test.cohort.size= if (sgp.test) 1500 else NULL,     ####
		return.sgp.test.results= if (sgp.test) TRUE else FALSE, ## -- Turn OFF these 3 for real analyses
		goodness.of.fit.print= if (sgp.test) FALSE else TRUE,   ####
		save.intermediate.results=FALSE,
		sgp.target.scale.scores=TRUE, # to combineSGP
		outputSGP.output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data"),
		outputSGP.directory="Data/Archive/2016_2017.2",
    parallel.config=list(
			BACKEND = "FOREACH", TYPE = "doParallel", SNOW_TEST = TRUE,
			WORKERS = list(TAUS = workers, SIMEX = workers)))


### Save results

if (sgp.test) {
	save(PARCC_SGP, file="./Data/SIM/PARCC_SGP-Test_PARCC_2016_2017.2.Rdata")
} else save(PARCC_SGP, file="./Data/Archive/2016_2017.2/PARCC_SGP.Rdata")


q("no")
