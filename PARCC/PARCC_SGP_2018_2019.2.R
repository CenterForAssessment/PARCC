#################################################################################
###                                                                           ###
###      SGP analysis script for PARCC consortium - Spring 2019 Analyses      ###
###                                                                           ###
#################################################################################

if (!exists("sgp.test")) sgp.test <- FALSE
workers <- parallel::detectCores()/2

options(error=recover)

### Load Packages

require(SGP)
require(data.table)


###  Load SGP LONG Data from FALL 2018 Analyses
load("./Data/Archive/2018_2019.1/PARCC_SGP_LONG_Data.Rdata")
load("../Bureau_Indian_Affairs/Data/Archive/2018_2019.2/Bureau_Indian_Affairs_Data_LONG_2018_2019.2.Rdata")
load("../Illinois/Data/Archive/2018_2019.2/Illinois_Data_LONG_2018_2019.2.Rdata")
load("../New_Jersey/Data/Archive/2018_2019.2/New_Jersey_Data_LONG_2018_2019.2.Rdata")
load("../New_Mexico/Data/Archive/2018_2019.2/New_Mexico_Data_LONG_2018_2019.2.Rdata")
load("../Department_Of_Defense/Data/Archive/2018_2019.2/Department_of_Defense_Data_LONG_2018_2019.2.Rdata")
load("../Washington_DC/Data/Archive/2018_2019.2/Washington_DC_Data_LONG_2018_2019.2.Rdata")
load("../Maryland/Data/Archive/2018_2019.2/Maryland_Data_LONG_2018_2019.2.Rdata")

PARCC_SGP_LONG_Data <- PARCC_SGP_LONG_Data[StateAbbreviation %in% c("DD", "MD", "DC")] # c("IL", "NJ", "NM", "BI")
PARCC_SGP_LONG_Data <- PARCC_SGP_LONG_Data[YEAR %in% c("2016_2017.2", "2017_2018.2", "2018_2019.1")]


###   INVALIDate duplicate prior test scores  --  49 cases in Spring 2019

setkey(PARCC_SGP_LONG_Data, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID, SCALE_SCORE, SCALE_SCORE_ACTUAL)
setkey(PARCC_SGP_LONG_Data, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID)
# dups <- PARCC_SGP_LONG_Data[c(which(duplicated(PARCC_SGP_LONG_Data, by=key(PARCC_SGP_LONG_Data)))-1, which(duplicated(PARCC_SGP_LONG_Data, by=key(PARCC_SGP_LONG_Data)))),]
# setkeyv(dups, key(PARCC_SGP_LONG_Data))
PARCC_SGP_LONG_Data[which(duplicated(PARCC_SGP_LONG_Data, by=key(PARCC_SGP_LONG_Data)))-1, VALID_CASE := "INVALID_CASE"]
table(PARCC_SGP_LONG_Data$VALID_CASE)


###  Read in the Spring 2019 configuration code and combine into a single list.

source("../SGP_CONFIG/2018_2019.2/ELA.R")
source("../SGP_CONFIG/2018_2019.2/ELA_SS.R")
source("../SGP_CONFIG/2018_2019.2/MATHEMATICS.R")
source("../SGP_CONFIG/2018_2019.2/MATHEMATICS_SS.R")

###   Modifications for Flagship SGP projections
# ELA.2018_2019.2.config[[1]]$sgp.grade.sequences <- list(c("3", "4"), c("3", "4", "5"), c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8"))
# ELA_SS.2018_2019.2.config[[1]]$sgp.grade.sequences <- list(c("3", "4"), c("3", "4", "5"), c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8"))
# ELA.2018_2019.2.config[[3]] <- ELA_SS.2018_2019.2.config[[3]] <- NULL
# ELA.2018_2019.2.config[[2]]$sgp.projection.grade.sequences <- NULL # Create projections for 8 to 10 / 2 Year skip progression.
#
# SGPstateData[["PARCC"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ELA"]] <- c("3", "4", "5", "6", "7", "8", "10")
# SGPstateData[["PARCC"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ELA"]] <- rep("ELA", 7)
# SGPstateData[["PARCC"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ELA"]] <- c(rep(1L, 5), 2)
# SGPstateData[["PARCC"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ELA_SS"]] <- c("3", "4", "5", "6", "7", "8", "10")
# SGPstateData[["PARCC"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ELA_SS"]] <- rep("ELA_SS", 7)
# SGPstateData[["PARCC"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ELA_SS"]] <- c(rep(1L, 5), 2)
###

PARCC_2018_2019.2.config <- c(
	ELA.2018_2019.2.config,
	ELA_SS.2018_2019.2.config,

	MATHEMATICS.2018_2019.2.config,
	MATHEMATICS_SS.2018_2019.2.config,

	ALGEBRA_I.2018_2019.2.config,
	ALGEBRA_I_SS.2018_2019.2.config,
	GEOMETRY.2018_2019.2.config,
	GEOMETRY_SS.2018_2019.2.config,
	ALGEBRA_II.2018_2019.2.config,
	ALGEBRA_II_SS.2018_2019.2.config,

	INTEGRATED_MATH_1.2018_2019.2.config,
	INTEGRATED_MATH_1_SS.2018_2019.2.config,
	INTEGRATED_MATH_2.2018_2019.2.config,
	INTEGRATED_MATH_2_SS.2018_2019.2.config,
	INTEGRATED_MATH_3.2018_2019.2.config,
	INTEGRATED_MATH_3_SS.2018_2019.2.config
)


###   abcSGP

PARCC_SGP <- abcSGP(
		state="PARCC",
		sgp_object=rbindlist(list(
			PARCC_SGP_LONG_Data,
			Department_of_Defense_Data_LONG_2018_2019.2,
			Maryland_Data_LONG_2018_2019.2,
			Washington_DC_Data_LONG_2018_2019.2, #), fill=TRUE),
			Bureau_Indian_Affairs_Data_LONG_2018_2019.2,
			Illinois_Data_LONG_2018_2019.2,
			New_Jersey_Data_LONG_2018_2019.2,
			New_Mexico_Data_LONG_2018_2019.2), fill=TRUE),
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
		outputSGP.directory= if (sgp.test) "./Data/SIM" else "Data/Archive/2018_2019.2",
    parallel.config=list(
			BACKEND = "FOREACH", TYPE = "doParallel",
			WORKERS = list(TAUS = workers, SIMEX = workers, SGP_SCALE_SCORE_TARGETS=10)))

### Save results

if (sgp.test) {
	save(PARCC_SGP, file="./Data/SIM/2018_2019.2/PARCC_SGP-Test_PARCC_2018_2019.2.Rdata")
} else save(PARCC_SGP, file="./Data/Archive/2018_2019.2/PARCC_SGP.Rdata")



### visualizeSGP - faster without SNOW/SNOW_TEST

visualizeSGP(
	PARCC_SGP,
	plot.types=c("growthAchievementPlot"),
	parallel.config=list(BACKEND="PARALLEL", WORKERS=list(GA_PLOTS=workers)))
