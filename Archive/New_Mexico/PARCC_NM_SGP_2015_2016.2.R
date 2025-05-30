#################################################################################
###                                                                           ###
###      SGP analysis script for PARCC New_Mexico - Spring 2016 Analyses      ###
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

New_Mexico_SGP <- prepareSGP(
	state = "NM",
	data = rbindlist(list(
		dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select * from PARCC_Data_LONG_2015_2 where StateAbbreviation in ('NM')"),
		dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select * from PARCC_Data_LONG_2016_1 where StateAbbreviation in ('NM')"),
		dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select * from PARCC_Data_LONG_2016_2 where StateAbbreviation in ('NM')"))),
	create.additional.variables=FALSE)


### analyzeSGP (for student growth percentiles)

New_Mexico_SGP <- analyzeSGP(
		New_Mexico_SGP,
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

New_Mexico_SGP <- analyzeSGP(
		New_Mexico_SGP,
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

New_Mexico_SGP <- combineSGP(
		New_Mexico_SGP,
		sgp.target.scale.scores=TRUE,
		sgp.config=PARCC_2015_2016.2.config,
		parallel.config = if (sgp.test) NULL else list(BACKEND="FOREACH", TYPE="doParallel", WORKERS=list(SGP_SCALE_SCORE_TARGETS = workers)))


### Save results

dir.create("Data")
if (sgp.test) {
	save(New_Mexico_SGP, file="Data/SIM/New_Mexico_SGP-Test.Rdata")
} else save(New_Mexico_SGP, file="Data/New_Mexico_SGP.Rdata")


### outputSGP

outputSGP(New_Mexico_SGP, outputSGP.directory=if (sgp.test) "Data/SIM" else "Data")


### visualizeSGP

###  Need to modify the GRADE, CONTENT_AREA and Year Lag projection sequences to
###  Accurately reflect the course taking patterns in the state (the
###  original meta-data are based on the entire PARCC Consortium).

table(New_Mexico_SGP@Data[YEAR=='2015_2016.2' & !is.na(SGP), CONTENT_AREA])
table(New_Mexico_SGP@Data[YEAR=='2015_2016.2' & !is.na(SGP) & CONTENT_AREA=="ELA", GRADE])

SGPstateData[["NM"]][["Student_Report_Information"]][["Content_Areas_Domains"]] <- list(ELA="ELA", MATHEMATICS="MATHEMATICS", ALGEBRA_I="MATHEMATICS", GEOMETRY="MATHEMATICS", ALGEBRA_II="MATHEMATICS")

if(!identical(data.table::key(New_Mexico_SGP@Data), SGP:::getKey(New_Mexico_SGP@Data))) data.table::setkeyv(New_Mexico_SGP@Data, SGP:::getKey(New_Mexico_SGP@Data))

visualizeSGP(
	New_Mexico_SGP,
	plot.types=c("growthAchievementPlot"),
	# plot.types=c("growthAchievementPlot", "studentGrowthPlot"),
	parallel.config=list(BACKEND="PARALLEL", WORKERS=list(GA_PLOTS=workers)))

q("no")
