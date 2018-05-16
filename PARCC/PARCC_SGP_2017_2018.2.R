#################################################################################
###                                                                           ###
###      SGP analysis script for PARCC consortium - Spring 2018 Analyses      ###
###                                                                           ###
#################################################################################


if (!exists("sgp.test")) sgp.test <- FALSE
workers <- parallel::detectCores()/2

### Load Packages

require(SGP)
require(RSQLite)
require(data.table)


###  Load SGP LONG Data from FALL 2017 Analyses
load("./Data/Archive/2017_2018.1/PARCC_SGP_LONG_Data.Rdata")

PARCC_SGP_LONG_Data <- SGP:::getAchievementLevel(PARCC_SGP_LONG_Data, state="PARCC")

###   INVALIDate duplicate prior test scores  (STILL NEEDED???)

setkey(PARCC_SGP_LONG_Data, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID, SCALE_SCORE, SCALE_SCORE_ACTUAL)
setkey(PARCC_SGP_LONG_Data, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID)
# dups <- PARCC_SGP_LONG_Data[c(which(duplicated(PARCC_SGP_LONG_Data, by=key(PARCC_SGP_LONG_Data)))-1, which(duplicated(PARCC_SGP_LONG_Data, by=key(PARCC_SGP_LONG_Data)))),]
# setkeyv(dups, key(PARCC_SGP_LONG_Data))
PARCC_SGP_LONG_Data[which(duplicated(PARCC_SGP_LONG_Data, by=key(PARCC_SGP_LONG_Data)))-1, VALID_CASE := "INVALID_CASE"]

# save(PARCC_SGP_LONG_Data, file="/home/ec2-user/PARCC_Prior_Data.Rdata")

###  Location of PARCC SQLite Database (Spring 2017 added in Data Prep step)
parcc.db <- "./Data/PARCC_Data_LONG.sqlite"

###  Read in the Spring 2017 configuration code and combine into a single list.

source("../SGP_CONFIG/2017_2018.2/ELA.R")
source("../SGP_CONFIG/2017_2018.2/ELA_SS.R")
source("../SGP_CONFIG/2017_2018.2/MATHEMATICS.R")
source("../SGP_CONFIG/2017_2018.2/MATHEMATICS_SS.R")

PARCC_2017_2018.2.config <- c(
	ELA.2017_2018.2.config,
	ELA_SS.2017_2018.2.config,

	MATHEMATICS.2017_2018.2.config,
	MATHEMATICS_SS.2017_2018.2.config,

	ALGEBRA_I.2017_2018.2.config,
	ALGEBRA_I_SS.2017_2018.2.config,
	GEOMETRY.2017_2018.2.config,
	GEOMETRY_SS.2017_2018.2.config,
	ALGEBRA_II.2017_2018.2.config,
	ALGEBRA_II_SS.2017_2018.2.config,

	INTEGRATED_MATH_1.2017_2018.2.config,
	INTEGRATED_MATH_1_SS.2017_2018.2.config,
	INTEGRATED_MATH_2.2017_2018.2.config,
	INTEGRATED_MATH_2_SS.2017_2018.2.config,
	INTEGRATED_MATH_3.2017_2018.2.config,
	INTEGRATED_MATH_3_SS.2017_2018.2.config
)

### abcSGP

PARCC_SGP <- abcSGP(
		state="PARCC",
		sgp_object=PARCC_SGP, rbindlist(list(
			PARCC_SGP_LONG_Data,
			dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select * from PARCC_Data_LONG_2018_2")), fill=TRUE),
		sgp.config = PARCC_2017_2018.2.config,
		steps=c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP", "visualizeSGP"),
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
		outputSGP.directory= if (sgp.test) "./Data/SIM" else "Data/Archive/2017_2018.2",
		plot.types=c("growthAchievementPlot"),
    parallel.config=list(
			BACKEND = "FOREACH", TYPE = "doParallel", SNOW_TEST = TRUE,
			WORKERS = list(TAUS = workers, SIMEX = workers, GA_PLOTS=workers)))

### Save results

if (sgp.test) {
	save(PARCC_SGP, file="./Data/SIM/2017_2018.2/PARCC_SGP-Test_PARCC_2017_2018.2.Rdata")
} else save(PARCC_SGP, file="./Data/Archive/2017_2018.2/PARCC_SGP.Rdata")
