#################################################################################
###                                                                           ###
###      SGP analysis script for PARCC consortium - Spring 2016 Analyses      ###
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

source("../SGP_CONFIG/2015_2016.2/ELA.R")
source("../SGP_CONFIG/2015_2016.2/ELA_SS.R")
source("../SGP_CONFIG/2015_2016.2/MATHEMATICS.R")
source("../SGP_CONFIG/2015_2016.2/MATHEMATICS_SS.R")


PARCC_2015_2016.2.config <- c(
	ELA_2015_2016.2.config,
	ELA_SS_2015_2016.2.config,

	MATHEMATICS_2015_2016.config,
	MATHEMATICS_SS_2015_2016.config,

	ALGEBRA_I.2015_2016.config,
	ALGEBRA_I_SS.2015_2016.config,
	ALGEBRA_II.2015_2016.config,
	ALGEBRA_II_SS.2015_2016.config,
	GEOMETRY.2015_2016.config,
	GEOMETRY_SS.2015_2016.config,

	INTEGRATED_MATH_1.2015_2016.config,
	INTEGRATED_MATH_1_SS.2015_2016.config,
	INTEGRATED_MATH_2.2015_2016.config,
	INTEGRATED_MATH_2_SS.2015_2016.config,
	INTEGRATED_MATH_3.2015_2016.config,
	INTEGRATED_MATH_3_SS.2015_2016.config
)


### updateSGP

PARCC_SGP <- updateSGP(
		what_sgp_object=PARCC_SGP,
		# with_sgp_data_LONG=PARCC_Data_LONG_2016,
		with_sgp_data_LONG = dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select * from PARCC_Data_LONG_2016_2"),
		sgp.config = PARCC_2015_2016.2.config,
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


### Fix ACHIEVEMENT_LEVEL
# require(data.table)
# table(PARCC_SGP@Data[YEAR=='2015_2016.2', CONTENT_AREA, ACHIEVEMENT_LEVEL])
# PARCC_SGP@Data[, ACHIEVEMENT_LEVEL := NULL]
# PARCC_SGP <- prepareSGP(PARCC_SGP, create.additional.variables=FALSE)

### analyzeSGP (for student growth projections)
PARCC_SGP <- analyzeSGP(
		PARCC_SGP,
		sgp.config=PARCC_2015_2016.2.config,
		sgp.percentiles=FALSE,
		sgp.projections=TRUE,
		sgp.projections.lagged=TRUE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline=FALSE,
		sgp.projections.lagged.baseline=FALSE,
		goodness.of.fit.print=FALSE,
		parallel.config = if (sgp.test) NULL else list(BACKEND="FOREACH", TYPE="doParallel", SNOW_TEST=TRUE, WORKERS=list(PROJECTIONS = workers, LAGGED_PROJECTIONS = (workers/2))))


### combineSGP

PARCC_SGP <- combineSGP(
		PARCC_SGP,
		sgp.target.scale.scores=TRUE,
		sgp.config=PARCC_2015_2016.2.config,
		parallel.config = if (sgp.test) NULL else list(BACKEND="FOREACH", TYPE="doParallel", SNOW_TEST=TRUE, WORKERS=list(SGP_SCALE_SCORE_TARGETS = (workers/2))))


### Save results

if (sgp.test) {
	save(PARCC_SGP, file="./Data/SIM/PARCC_SGP-Test.Rdata")
} else save(PARCC_SGP, file="./Data/PARCC_SGP.Rdata")


### visualizeSGP

SGPstateData[["PARCC"]][["Student_Report_Information"]][["Content_Areas_Domains"]] <- list(MATHEMATICS="MATHEMATICS", ELA="ELA", GEOMETRY="MATHEMATICS", ALGEBRA_I="MATHEMATICS", ALGEBRA_II="MATHEMATICS")
if(!identical(data.table::key(PARCC_SGP@Data), SGP:::getKey(PARCC_SGP@Data))) data.table::setkeyv(PARCC_SGP@Data, SGP:::getKey(PARCC_SGP@Data))

visualizeSGP(
	PARCC_SGP,
	plot.types=c("growthAchievementPlot"),
	parallel.config=list(BACKEND="PARALLEL", WORKERS=list(GA_PLOTS=workers)))


### outputSGP

outputSGP(PARCC_SGP, outputSGP.directory=if (sgp.test) "Data/SIM" else "Data")

q("no")
