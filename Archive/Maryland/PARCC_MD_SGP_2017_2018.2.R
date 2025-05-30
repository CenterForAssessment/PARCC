#################################################################################
###                                                                           ###
###       SGP analysis script for PARCC Maryland - Spring 2018 Analyses       ###
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

###  Read in the Spring 2018 configuration code and combine into a single list.
source("../SGP_CONFIG/2017_2018.2/ELA.R")
source("../SGP_CONFIG/2017_2018.2/ELA_SS.R")
source("../SGP_CONFIG/2017_2018.2/MATHEMATICS.R")
source("../SGP_CONFIG/2017_2018.2/MATHEMATICS_SS.R")

ELA.2017_2018.2.config[[1]]$sgp.grade.sequences <- list(c("3", "4"), c("3", "4", "5"), c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8"), c("10", "11"))
ELA_SS.2017_2018.2.config[[1]]$sgp.grade.sequences <- list(c("3", "4"), c("3", "4", "5"), c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8"), c("10", "11"))
ELA.2017_2018.2.config[[3]] <- ELA_SS.2017_2018.2.config[[3]] <- NULL

SGPstateData[["MD"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ELA"]] <- c("3", "4", "5", "6", "7", "8", "10", "11") # Only 2249 8th to 9th.  Enough to calculate SGPs, but not good for projections.
SGPstateData[["MD"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ELA"]] <- rep("ELA", 8)
SGPstateData[["MD"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ELA"]] <- c(rep(1L, 5), 2, 1)
SGPstateData[["MD"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ELA_SS"]] <- c("3", "4", "5", "6", "7", "8", "10", "11")
SGPstateData[["MD"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ELA_SS"]] <- rep("ELA_SS", 8)
SGPstateData[["MD"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ELA_SS"]] <- c(rep(1L, 5), 2, 1)

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
	ALGEBRA_II_SS.2017_2018.2.config
)

PARCC_2017_2018.2.config <- PARCC_2017_2018.2.config[!sapply(PARCC_2017_2018.2.config, function(f) any(grepl("INTEGRATED_MATH_", f)))]

### abcSGP

Maryland_SGP <- abcSGP(
		state="MD",
		sgp_object=fetchPARCC(state="MD", parcc.db = "../PARCC/Data/PARCC_Data_LONG.sqlite", prior.years=c("2016_2", "2017_1", "2017_2", "2018_1"), current.year="2018_2", fields="*"), # MD_2018, #
		sgp.config = PARCC_2017_2018.2.config,
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
		outputSGP.directory="Data/Archive/2017_2018.2",
    parallel.config=list(
			BACKEND = "FOREACH", TYPE = "doParallel", SNOW_TEST = TRUE,
			WORKERS = list(TAUS = workers, SIMEX = workers))) # , SGP_SCALE_SCORE_TARGETS=workers/2

### Save results
if (sgp.test) {
	save(Maryland_SGP, file="./Data/SIM/Maryland_SGP-Test_PARCC_2017_2018.2.Rdata")
} else save(Maryland_SGP, file="./Data/Archive/2017_2018.2/Maryland_SGP.Rdata")

###   Fix SGP_TARGET_3_YEAR_CONTENT_AREA in combineSGP
Maryland_SGP <- combineSGP(Maryland_SGP, sgp.target.content_areas = TRUE)
"SGP_TARGET_3_YEAR_CONTENT_AREA" %in% names(Maryland_SGP@Data)
table(Maryland_SGP@Data[, CONTENT_AREA, SGP_TARGET_3_YEAR_CONTENT_AREA])

outputSGP(Maryland_SGP, output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data"), outputSGP.directory="Data/Archive/2017_2018.2")
save(Maryland_SGP, file="./Data/Archive/2017_2018.2/Maryland_SGP.Rdata")


### visualizeSGP

###  Need to modify the GRADE, CONTENT_AREA and Year Lag projection sequences to
###  Accurately reflect the course taking patterns in the state (the
###  original meta-data are based on the entire PARCC Consortium).

table(Maryland_SGP@Data[YEAR=="2017_2018.2" & !is.na(SGP), GRADE, CONTENT_AREA])
table(Maryland_SGP@Data[YEAR=="2017_2018.2" & !is.na(SGP) & CONTENT_AREA=="ELA", GRADE])

SGPstateData[["MD"]][["Student_Report_Information"]][["Content_Areas_Domains"]] <- list(
			ELA="ELA", MATHEMATICS="MATHEMATICS", ALGEBRA_I="MATHEMATICS", GEOMETRY="MATHEMATICS", ALGEBRA_II="MATHEMATICS",
			ELA_SS="ELA_SS", MATHEMATICS_SS="MATHEMATICS_SS", ALGEBRA_I_SS="MATHEMATICS_SS", GEOMETRY_SS="MATHEMATICS_SS", ALGEBRA_II_SS="MATHEMATICS_SS")

SGPstateData[["MD"]][["SGP_Configuration"]][["gaPlot.back.extrapolated.cuts"]][["ELA"]] <- NULL # Necessary for grade 8 to 10 skip year...

visualizeSGP(
	Maryland_SGP,
	plot.types=c("growthAchievementPlot"),
	parallel.config=list(BACKEND="PARALLEL", WORKERS=list(GA_PLOTS=workers)))
