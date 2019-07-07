#################################################################################
###                                                                           ###
###       SGP analysis script for PARCC Illinois - Spring 2019 Analyses       ###
###                                                                           ###
#################################################################################

if (!exists("sgp.test")) sgp.test <- FALSE
workers <- parallel::detectCores()/2

### Load Packages
require(SGP)
require(data.table)

###  Load Data
# load("./Illinois/Data/Archive/2015_2016.2/Illinois_SGP_LONG_Data_2015_2016.2.Rdata") # ONLY for test run
load("./Data/Archive/2016_2017.2/Illinois_SGP_LONG_Data_2016_2017.2.Rdata")
load("./Data/Archive/2017_2018.2/Illinois_SGP_LONG_Data_2017_2018.2.Rdata")
load("./Data/Archive/2018_2019.2/Illinois_Data_LONG_2018_2019.2.Rdata")

###  Reset 2017 names to match other years
setnames(Illinois_SGP_LONG_Data_2016_2017.2, c("CATCH_UP_KEEP_UP_STATUS", "MOVE_UP_STAY_UP_STATUS"), c("CATCH_UP_KEEP_UP_STATUS_3_YEAR", "MOVE_UP_STAY_UP_STATUS_3_YEAR"))

Illinois_SGP_LONG_Data <- rbindlist(list( # Illinois_SGP_LONG_Data_2015_2016.2,
				Illinois_SGP_LONG_Data_2016_2017.2,
				Illinois_SGP_LONG_Data_2017_2018.2,
				Illinois_Data_LONG_2018_2019.2), fill=TRUE)#[CONTENT_AREA %in% c("ELA", "MATHEMATICS")]

rm(list = c("Illinois_SGP_LONG_Data_2016_2017.2", "Illinois_SGP_LONG_Data_2017_2018.2", "Illinois_Data_LONG_2018_2019.2"))

###  Read in the Spring 2018 configuration code and combine into a single list.
source("../SGP_CONFIG/2018_2019.2/ELA.R")
source("../SGP_CONFIG/2018_2019.2/ELA_SS.R")
source("../SGP_CONFIG/2018_2019.2/MATHEMATICS.R")
source("../SGP_CONFIG/2018_2019.2/MATHEMATICS_SS.R")

ELA.2018_2019.2.config[[1]]$sgp.grade.sequences <- list(c("3", "4"), c("3", "4", "5"), c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8"))
ELA_SS.2018_2019.2.config[[1]]$sgp.grade.sequences <- list(c("3", "4"), c("3", "4", "5"), c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8"))
ELA.2018_2019.2.config[[3]] <- ELA_SS.2018_2019.2.config[[3]] <- NULL
ELA.2018_2019.2.config[[2]] <- ELA_SS.2018_2019.2.config[[2]] <- NULL

PARCC_2018_2019.2.config <- c(
	ELA.2018_2019.2.config,
	ELA_SS.2018_2019.2.config,

	MATHEMATICS.2018_2019.2.config,
	MATHEMATICS_SS.2018_2019.2.config) # Only Grades 3-8 Math and ELA in 2019

###  Need to modify the GRADE, CONTENT_AREA and Year Lag projection sequences to
###  Accurately reflect the course taking patterns in the state (the
###  original meta-data are based on the entire PARCC Consortium).

SGPstateData[["IL"]][["SGP_Configuration"]][["grade.projection.sequence"]] <- list(
		ELA=c("3", "4", "5", "6", "7", "8"), ELA_SS=c("3", "4", "5", "6", "7", "8"),
		MATHEMATICS=c("3", "4", "5", "6", "7", "8"), MATHEMATICS_SS=c("3", "4", "5", "6", "7", "8"))
SGPstateData[["IL"]][["SGP_Configuration"]][["content_area.projection.sequence"]] <- list(
		ELA=rep("ELA", 6), ELA_SS=rep("ELA_SS", 6),
		MATHEMATICS=c(rep("MATHEMATICS", 6)), MATHEMATICS_SS=c(rep("MATHEMATICS_SS", 6)))
SGPstateData[["IL"]][["SGP_Configuration"]][["year_lags.projection.sequence"]] <- list(
		ELA=rep(1L, 5), ELA_SS=rep(1L, 5),
		MATHEMATICS=rep(1L, 5), MATHEMATICS_SS=rep(1L, 5))

SGPstateData[["IL"]][["Student_Report_Information"]][["Content_Areas_Domains"]] <- list(ELA="ELA", MATHEMATICS="MATHEMATICS", ELA_SS="ELA_SS", MATHEMATICS_SS="MATHEMATICS_SS")


### abcSGP

Illinois_SGP <- abcSGP(
		state="IL",
		sgp_object=Illinois_SGP_LONG_Data,
		sgp.config = PARCC_2018_2019.2.config,
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
		outputSGP.directory="Data/Archive/2018_2019.2",
    parallel.config=list(
			BACKEND = "FOREACH", TYPE = "doParallel",
			WORKERS = list(TAUS = workers, SIMEX = workers, SGP_SCALE_SCORE_TARGETS=10)))

### Save results
if (sgp.test) {
	save(Illinois_SGP, file="./Data/SIM/Illinois_SGP-Test_PARCC_2018_2019.2.Rdata")
} else save(Illinois_SGP, file="./Data/Archive/2018_2019.2/Illinois_SGP.Rdata")

### visualizeSGP

visualizeSGP(
	Illinois_SGP,
	plot.types=c("growthAchievementPlot"),
	parallel.config=list(BACKEND="PARALLEL", WORKERS=list(GA_PLOTS=workers)))

q("no")
