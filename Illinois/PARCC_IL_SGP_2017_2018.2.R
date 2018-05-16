#################################################################################
###                                                                           ###
###       SGP analysis script for PARCC Illinois - Spring 2018 Analyses       ###
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

###  Read in the Spring 2017 configuration code and combine into a single list.
source("../SGP_CONFIG/2017_2018.2/ELA.R")
source("../SGP_CONFIG/2017_2018.2/ELA_SS.R")
source("../SGP_CONFIG/2017_2018.2/MATHEMATICS.R")
source("../SGP_CONFIG/2017_2018.2/MATHEMATICS_SS.R")

ELA.2017_2018.2.config[[1]]$sgp.grade.sequences <- list(c("3", "4"), c("3", "4", "5"), c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8"))
ELA_SS.2017_2018.2.config[[1]]$sgp.grade.sequences <- list(c("3", "4"), c("3", "4", "5"), c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8"))
ELA.2017_2018.2.config[[2]] <- ELA_SS.2017_2018.2.config[[2]] <- NULL

PARCC_2017_2018.2.config <- c(
	ELA.2017_2018.2.config,
	ELA_SS.2017_2018.2.config,

	MATHEMATICS.2017_2018.2.config,
	MATHEMATICS_SS.2017_2018.2.config,

	ALGEBRA_I.2017_2018.2.config,
	ALGEBRA_I_SS.2017_2018.2.config)#, # Only 7th grade math to Algebra I

PARCC_2017_2018.2.config <- PARCC_2017_2018.2.config[sapply(PARCC_2017_2018.2.config, function(f) any(grepl(paste("ELA", "MATHEMATICS", sep="|"), f)))]


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
		sgp_object=fetchPARCC(state="IL", parcc.db = "../PARCC/Data/PARCC_Data_LONG.sqlite", prior.years=c("2016_2", "2017_1", "2017_2", "2018_1"), current.year="2018_2", fields="*")[CONTENT_AREA %in% c("ELA", "MATHEMATICS", "ALGEBRA_I", "ELA_SS", "MATHEMATICS_SS", "ALGEBRA_I_SS")],
		sgp.config = PARCC_2017_2018.2.config,
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
		outputSGP.directory="Data/Archive/2017_2018.2",
    parallel.config=list(
			BACKEND = "FOREACH", TYPE = "doParallel", SNOW_TEST = TRUE,
			WORKERS = list(TAUS = workers, SIMEX = workers)))

### Save results
if (sgp.test) {
	save(Illinois_SGP, file="./Data/SIM/Illinois_SGP-Test_PARCC_2017_2018.2.Rdata")
} else save(Illinois_SGP, file="./Data/Archive/2017_2018.2/Illinois_SGP.Rdata")

### visualizeSGP

visualizeSGP(
	Illinois_SGP,
	plot.types=c("growthAchievementPlot"),
	parallel.config=list(BACKEND="PARALLEL", WORKERS=list(GA_PLOTS=workers)))

q("no")
