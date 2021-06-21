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

###  PARCC SQLite database access function
source("../fetchPARCC.R")

source("../SGP_CONFIG/2016_2017.2/ELA.R")
source("../SGP_CONFIG/2016_2017.2/ELA_SS.R")
source("../SGP_CONFIG/2016_2017.2/MATHEMATICS.R")
source("../SGP_CONFIG/2016_2017.2/MATHEMATICS_SS.R")

ELA.2016_2017.2.config[[1]]$sgp.grade.sequences <- list(c("3", "4"), c("3", "4", "5"), c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8"), c("7", "8", "9"))
ELA_SS.2016_2017.2.config[[1]]$sgp.grade.sequences <- list(c("3", "4"), c("3", "4", "5"), c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8"), c("7", "8", "9"))

PARCC_2016_2017.2.config <- c(
	ELA.2016_2017.2.config,
	ELA_SS.2016_2017.2.config,

	MATHEMATICS.2016_2017.2.config,
	MATHEMATICS_SS.2016_2017.2.config,

	ALGEBRA_I.2016_2017.2.config,
	ALGEBRA_I_SS.2016_2017.2.config,
	GEOMETRY.2016_2017.2.config,
	GEOMETRY_SS.2016_2017.2.config,
	ALGEBRA_II.2016_2017.2.config,
	ALGEBRA_II_SS.2016_2017.2.config
)

PARCC_2016_2017.2.config <- PARCC_2016_2017.2.config[!sapply(PARCC_2016_2017.2.config, function(f) any(grepl("INTEGRATED_MATH_", f)))]

SGPstateData[["MD"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ELA"]] <- c("3", "4", "5", "6", "7", "8")  #  Only a 2 thousand 9th graders.  Projections don't make sense
SGPstateData[["MD"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ELA"]] <- rep("ELA", 6)
SGPstateData[["MD"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ELA"]] <- rep(1L, 5)
SGPstateData[["MD"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ELA_SS"]] <- c("3", "4", "5", "6", "7", "8")
SGPstateData[["MD"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ELA_SS"]] <- rep("ELA_SS", 6)
SGPstateData[["MD"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ELA_SS"]] <- rep(1L, 5)


### abcSGP

Maryland_SGP <- abcSGP(
		state="MD",
		sgp_object=fetchPARCC(state="MD", parcc.db = "../PARCC/Data/PARCC_Data_LONG.sqlite", prior.years=c("2015_2", "2016_1", "2016_2", "2017_1"), current.year="2017_2", fields="*"),
		sgp.config = PARCC_2016_2017.2.config,
		steps=c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
		prepareSGP.create.additional.variables=FALSE,
		sgp.percentiles=TRUE,
		sgp.projections=TRUE,
		sgp.projections.lagged=TRUE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline=FALSE,
		sgp.projections.lagged.baseline=FALSE,
		calculate.simex = if (sgp.test) list(lambda=seq(0,2,0.5), simulation.iterations=10, csem.data.vnames="SCALE_SCORE_CSEM", extrapolation="linear", save.matrices=TRUE) else TRUE,
		sgp.test.cohort.size= if (sgp.test) 1500 else NULL,     ####
		return.sgp.test.results= if (sgp.test) TRUE else FALSE, ## -- Turn OFF these 3 for real analyses
		goodness.of.fit.print= if (sgp.test) FALSE else TRUE,   ####
		save.intermediate.results=FALSE,
		sgp.target.scale.scores=TRUE, # to combineSGP
		outputSGP.output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data"),
		outputSGP.directory="Data/Archive/2016_2017.2",
    parallel.config=list(
			BACKEND = "FOREACH", TYPE = "doParallel", SNOW_TEST = TRUE,
			WORKERS = list(TAUS = workers, SIMEX = workers))) # , SGP_SCALE_SCORE_TARGETS=workers/2
COMBINE

### Save results
if (sgp.test) {
	save(Maryland_SGP, file="./Data/SIM/Maryland_SGP-Test_PARCC_2016_2017.2.Rdata")
} else save(Maryland_SGP, file="./Data/Archive/2016_2017.2/Maryland_SGP.Rdata")

### visualizeSGP

###  Need to modify the GRADE, CONTENT_AREA and Year Lag projection sequences to
###  Accurately reflect the course taking patterns in the state (the
###  original meta-data are based on the entire PARCC Consortium).

table(Maryland_SGP@Data[YEAR=="2016_2017.2" & !is.na(SGP), GRADE, CONTENT_AREA])
table(Maryland_SGP@Data[YEAR=="2016_2017.2" & !is.na(SGP) & CONTENT_AREA=="ELA", GRADE])

SGPstateData[["MD"]][["Student_Report_Information"]][["Content_Areas_Domains"]] <- list(
			ELA="ELA", MATHEMATICS="MATHEMATICS", ALGEBRA_I="MATHEMATICS", GEOMETRY="MATHEMATICS", ALGEBRA_II="MATHEMATICS",
			ELA_SS="ELA_SS", MATHEMATICS_SS="MATHEMATICS_SS", ALGEBRA_I_SS="MATHEMATICS_SS", GEOMETRY_SS="MATHEMATICS_SS", ALGEBRA_II_SS="MATHEMATICS_SS")

visualizeSGP(
	Maryland_SGP,
	plot.types=c("growthAchievementPlot"),
	parallel.config=list(BACKEND="PARALLEL", WORKERS=list(GA_PLOTS=workers)))


###  Fix projections

Maryland_SGP@SGP$SGProjections <- NULL

Maryland_SGP <- analyzeSGP(
		Maryland_SGP,
		sgp.config=PARCC_2016_2017.2.config,
		sgp.percentiles=FALSE,
		sgp.projections=TRUE,
		sgp.projections.lagged=TRUE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline=FALSE,
		sgp.projections.lagged.baseline=FALSE,
		goodness.of.fit.print=FALSE,
		parallel.config = list(BACKEND="PARALLEL", WORKERS=list(PROJECTIONS = workers-2, LAGGED_PROJECTIONS = workers/2)))

### combineSGP

Maryland_SGP <- combineSGP(
		Maryland_SGP,
		sgp.target.scale.scores=TRUE,
		sgp.config=PARCC_2016_2017.2.config,
		parallel.config = list(BACKEND="PARALLEL", WORKERS=list(SGP_SCALE_SCORE_TARGETS = workers)))

### Save results
save(Maryland_SGP, file="Data/Archive/2016_2017.2/Maryland_SGP.Rdata")

### outputSGP
outputSGP(Maryland_SGP, output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data"), outputSGP.directory="Data/Archive/2016_2017.2")
