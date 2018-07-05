################################################################################
###                                                                          ###
###    SGP analysis script for PARCC Washington_DC - Spring 2018 Analyses    ###
###                                                                          ###
################################################################################

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

ELA.2017_2018.2.config[[1]]$sgp.grade.sequences <- list(c("3", "4"), c("3", "4", "5"), c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8"))
ELA_SS.2017_2018.2.config[[1]]$sgp.grade.sequences <- list(c("3", "4"), c("3", "4", "5"), c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8"))
ELA.2017_2018.2.config[[3]] <- ELA_SS.2017_2018.2.config[[3]] <- NULL
ELA.2017_2018.2.config[[2]]$sgp.projection.grade.sequences <- NULL # Create projections for 8 to 10 / 2 Year skip progression.

SGPstateData[["DC"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ELA"]] <- c("3", "4", "5", "6", "7", "8", "10")
SGPstateData[["DC"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ELA"]] <- rep("ELA", 7)
SGPstateData[["DC"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ELA"]] <- c(rep(1L, 5), 2)
SGPstateData[["DC"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ELA_SS"]] <- c("3", "4", "5", "6", "7", "8", "10")
SGPstateData[["DC"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ELA_SS"]] <- rep("ELA_SS", 7)
SGPstateData[["DC"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ELA_SS"]] <- c(rep(1L, 5), 2)

SGPstateData[["DC"]][["SGP_Configuration"]][["grade.projection.sequence"]][["MATHEMATICS"]] <- c("3", "4", "5", "6", "7", "8")
SGPstateData[["DC"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["MATHEMATICS"]] <- rep("MATHEMATICS", 6)
SGPstateData[["DC"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["MATHEMATICS"]] <- rep(1L, 5)
SGPstateData[["DC"]][["SGP_Configuration"]][["grade.projection.sequence"]][["MATHEMATICS_SS"]] <- c("3", "4", "5", "6", "7", "8")
SGPstateData[["DC"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["MATHEMATICS_SS"]] <- rep("MATHEMATICS_SS", 6)
SGPstateData[["DC"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["MATHEMATICS_SS"]] <- rep(1L, 5)

SGPstateData[["DC"]][["SGP_Configuration"]][["gaPlot.back.extrapolated.cuts"]][["ELA"]] <- NULL # Necessary for grade 8 to 10 skip year...


PARCC_2017_2018.2.config <- c(
	ELA.2017_2018.2.config,
	ELA_SS.2017_2018.2.config,

	MATHEMATICS.2017_2018.2.config,
	MATHEMATICS_SS.2017_2018.2.config,

	ALGEBRA_I.2017_2018.2.config,
	ALGEBRA_I_SS.2017_2018.2.config,
	GEOMETRY.2017_2018.2.config,
	GEOMETRY_SS.2017_2018.2.config
)

# SGPstateData[["DC"]][["SGP_Configuration"]][["sgp.projections.use.only.complete.matrices"]] <- TRUE
PARCC_2017_2018.2.config <- PARCC_2017_2018.2.config[!sapply(PARCC_2017_2018.2.config, function(f) any(grepl("INTEGRATED_MATH_", f)))]
PARCC_2017_2018.2.config <- PARCC_2017_2018.2.config[!sapply(PARCC_2017_2018.2.config, function(f) any(grepl("ALGEBRA_II", f)))]


### abcSGP

DC.CA <- c("ELA", "MATHEMATICS", "ALGEBRA_I", "GEOMETRY", "ELA_SS", "MATHEMATICS_SS", "ALGEBRA_I_SS", "GEOMETRY_SS")

Washington_DC_SGP <- abcSGP(
		state="DC",
		sgp_object=fetchPARCC(state="DC", parcc.db = "../PARCC/Data/PARCC_Data_LONG.sqlite", prior.years=c("2016_2", "2017_1", "2017_2", "2018_1"), current.year="2018_2", fields="*")[GRADE %in% c(3:8, 10, "EOCT") & CONTENT_AREA %in% DC.CA], # DC_2018, #
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
	save(Washington_DC_SGP, file="./Data/SIM/Washington_DC_SGP-Test_PARCC_2017_2018.2.Rdata")
} else save(Washington_DC_SGP, file="./Data/Archive/2017_2018.2/Washington_DC_SGP.Rdata")

###   Fix SGP_TARGET_3_YEAR_CONTENT_AREA in combineSGP  --  CHANGE ALL `SGPstateData` "SGP_Configuration" elements from above before running combineSGP!!!
Washington_DC_SGP <- combineSGP(Washington_DC_SGP, sgp.target.content_areas = TRUE)
"SGP_TARGET_3_YEAR_CONTENT_AREA" %in% names(Washington_DC_SGP@Data)
table(Washington_DC_SGP@Data[, CONTENT_AREA, SGP_TARGET_3_YEAR_CONTENT_AREA])

outputSGP(Washington_DC_SGP, output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data"), outputSGP.directory="Data/Archive/2017_2018.2")
save(Washington_DC_SGP, file="./Data/Archive/2017_2018.2/Washington_DC_SGP.Rdata")


### visualizeSGP

###  Need to modify the GRADE, CONTENT_AREA and Year Lag projection sequences to
###  Accurately reflect the course taking patterns in the state (the
###  original meta-data are based on the entire PARCC Consortium).

table(Washington_DC_SGP@Data[YEAR=="2017_2018.2" & !is.na(SGP), CONTENT_AREA])
table(Washington_DC_SGP@Data[YEAR=="2017_2018.2" & !is.na(SGP) & CONTENT_AREA=="ELA", GRADE])

SGPstateData[["DC"]][["Student_Report_Information"]][["Grades_Reported"]][["ELA"]] <- c("3", "4", "5", "6", "7", "8", "10")
SGPstateData[["DC"]][["Student_Report_Information"]][["Grades_Reported"]][["ELA_SS"]] <- c("3", "4", "5", "6", "7", "8", "10")
SGPstateData[["DC"]][["Student_Report_Information"]][["Grades_Reported_Domains"]][["ELA"]] <- c("3", "4", "5", "6", "7", "8", "10")
SGPstateData[["DC"]][["Student_Report_Information"]][["Grades_Reported_Domains"]][["ELA_SS"]] <- c("3", "4", "5", "6", "7", "8", "10")
SGPstateData[["DC"]][["Student_Report_Information"]][["Content_Areas_Domains"]] <- list(ELA="ELA", MATHEMATICS="MATHEMATICS")#, ALGEBRA_I="MATHEMATICS", GEOMETRY="MATHEMATICS")

visualizeSGP(
	Washington_DC_SGP,
	plot.types=c("growthAchievementPlot"),
	parallel.config=list(BACKEND="PARALLEL", WORKERS=list(GA_PLOTS=workers)))

q("no")
