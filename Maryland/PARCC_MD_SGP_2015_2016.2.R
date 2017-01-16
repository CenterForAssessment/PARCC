#################################################################################
###                                                                           ###
###       SGP analysis script for PARCC Maryland - Spring 2016 Analyses       ###
###                                                                           ###
#################################################################################


if (!exists("sgp.test")) sgp.test <- FALSE
workers <- parallel::detectCores()/2

### Load Packages

require(SGP)
require(RSQLite)
require(data.table)


### Load configurations & combine

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


### prepareSGP with Data read in directly from SQLite database

# parcc.db <- "../PARCC/Data/PARCC_Data_LONG_Simulated.sqlite"
parcc.db <- "../PARCC/Data/PARCC_Data_LONG.sqlite"

Maryland_SGP <- prepareSGP(
	state = "MD",
	data = rbindlist(list(
		dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select * from PARCC_Data_LONG_2015_2 where StateAbbreviation in ('MD')"),
		dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select * from PARCC_Data_LONG_2016_1 where StateAbbreviation in ('MD')"),
		dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select * from PARCC_Data_LONG_2016_2 where StateAbbreviation in ('MD')"))),
	create.additional.variables=FALSE)


### analyzeSGP (for student growth percentiles)

Maryland_SGP <- analyzeSGP(
		Maryland_SGP,
		sgp.config=PARCC_2015_2016.2.config,
		sgp.percentiles=TRUE,
		sgp.projections=FALSE,
		sgp.projections.lagged=FALSE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline=FALSE,
		sgp.projections.lagged.baseline=FALSE,
		calculate.simex= if (sgp.test) list(lambda=seq(0,2,0.5), simulation.iterations=10, csem.data.vnames="SCALE_SCORE_CSEM", extrapolation="linear", save.matrices=TRUE) else TRUE,
		sgp.test.cohort.size= if (sgp.test) 1500 else NULL,     #### )
		return.sgp.test.results= if (sgp.test) TRUE else FALSE, ##   > -- Turn OFF these 3 for real analyses
		goodness.of.fit.print= if (sgp.test) FALSE else TRUE,   #### )
		get.cohort.data.info=TRUE,
		parallel.config=list(BACKEND="FOREACH", TYPE="doParallel", WORKERS=list(TAUS = workers, SIMEX = workers)))


### analyzeSGP (for student growth projections)

###  Maryland is an odd case - they don't have 9th grade ELA, so 9th or 10th Grade SGPs aren't calculated.
###  Because of the gap between 8th and 11th Grade, the SGP_Configuration meta-data must be revised
###  and the sgp.grade.sequences in the sgp.config re-set before running the SG Projections.

table(Maryland_SGP@Data[YEAR=='2015_2016.2' & !is.na(SGP), CONTENT_AREA])
table(Maryland_SGP@Data[YEAR=='2015_2016.2' & CONTENT_AREA=="ELA", GRADE])
table(Maryland_SGP@Data[YEAR=='2015_2016.2' & !is.na(SGP) & CONTENT_AREA=="ELA", GRADE])
table(Maryland_SGP@Data[YEAR=='2015_2016.2' & !is.na(SGP) & CONTENT_AREA=="ALGEBRA_II", as.character(SGP_NORM_GROUP)]) # No Geometry to Alg II, so cut it off

PARCC_2015_2016.2.config[["ELA.2015_2016.2"]][["sgp.grade.sequences"]] <- list(c("3", "4"), c("4", "5"), c("5", "6"), c("6", "7"), c("7", "8"))

SGPstateData[["MD"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ELA"]] <- c("3", "4", "5", "6", "7", "8") #, "9", "10", "11"
SGPstateData[["MD"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ELA"]] <- rep("ELA", 6)
SGPstateData[["MD"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ELA"]] <- rep(1L, 5)

Maryland_SGP <- analyzeSGP(
		Maryland_SGP,
		sgp.config=PARCC_2015_2016.2.config,
		sgp.percentiles=FALSE,
		sgp.projections=TRUE,
		sgp.projections.lagged=TRUE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline=FALSE,
		sgp.projections.lagged.baseline=FALSE,
		goodness.of.fit.print=FALSE,
		parallel.config = if (sgp.test) NULL else list(BACKEND="FOREACH", TYPE="doParallel", WORKERS=list(PROJECTIONS = workers, LAGGED_PROJECTIONS = workers)))


### combineSGP

Maryland_SGP <- combineSGP(
		Maryland_SGP,
		sgp.target.scale.scores=TRUE,
		sgp.config=PARCC_2015_2016.2.config,
		parallel.config = if (sgp.test) NULL else list(BACKEND="FOREACH", TYPE="doParallel", WORKERS=list(SGP_SCALE_SCORE_TARGETS = workers)))


### Save results

dir.create("Data")
if (sgp.test) {
	save(Maryland_SGP, file="Data/SIM/Maryland_SGP-Test.Rdata")
} else save(Maryland_SGP, file="Data/Maryland_SGP.Rdata")


### outputSGP

outputSGP(Maryland_SGP, outputSGP.directory=if (sgp.test) "Data/SIM" else "Data")


### visualizeSGP

###  Need to modify the GRADE, CONTENT_AREA and Year Lag projection sequences to
###  Accurately reflect the course taking patterns in the state (the
###  original meta-data are based on the entire PARCC Consortium).

SGPstateData[["MD"]][["Student_Report_Information"]][["Content_Areas_Domains"]] <- list(ELA="ELA", MATHEMATICS="MATHEMATICS", ALGEBRA_I="MATHEMATICS", GEOMETRY="MATHEMATICS")

SGPstateData[["MD"]][["SGP_Configuration"]][["grade.projection.sequence"]][["MATHEMATICS"]] <- c("3", "4", "5", "6", "7", "8", "EOCT", "EOCT")
SGPstateData[["MD"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["MATHEMATICS"]] <- c("MATHEMATICS", "MATHEMATICS", "MATHEMATICS", "MATHEMATICS", "MATHEMATICS", "MATHEMATICS", "ALGEBRA_I", "GEOMETRY")
SGPstateData[["MD"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["MATHEMATICS"]] <- rep(1L, 7)

if(!identical(data.table::key(Maryland_SGP@Data), SGP:::getKey(Maryland_SGP@Data))) data.table::setkeyv(Maryland_SGP@Data, SGP:::getKey(Maryland_SGP@Data))

visualizeSGP(
	Maryland_SGP,
	plot.types=c("growthAchievementPlot"),
	# plot.types=c("growthAchievementPlot", "studentGrowthPlot"),
	parallel.config=list(BACKEND="PARALLEL", WORKERS=list(GA_PLOTS=workers)))

q("no")
