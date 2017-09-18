#################################################################################
###                                                                           ###
###      SGP analysis script for PARCC Washington_DC - Spring 2016 Analyses      ###
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
source("../SGP_CONFIG/2016_2017.2/ELA.R")
source("../SGP_CONFIG/2016_2017.2/ELA_SS.R")
source("../SGP_CONFIG/2016_2017.2/MATHEMATICS.R")
source("../SGP_CONFIG/2016_2017.2/MATHEMATICS_SS.R")

ELA.2016_2017.2.config[[1]]$sgp.grade.sequences <- list(c("3", "4"), c("3", "4", "5"), c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8"), c("7", "8", "9"), c("8", "9", "10"))
ELA_SS.2016_2017.2.config[[1]]$sgp.grade.sequences <- list(c("3", "4"), c("3", "4", "5"), c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8"), c("7", "8", "9"), c("8", "9", "10"))
ELA.2016_2017.2.config[[2]] <- ELA_SS.2016_2017.2.config[[2]] <- NULL

PARCC_2016_2017.2.config <- c(
	ELA.2016_2017.2.config,
	ELA_SS.2016_2017.2.config,

	MATHEMATICS.2016_2017.2.config,
	MATHEMATICS_SS.2016_2017.2.config,

	ALGEBRA_I.2016_2017.2.config,
	ALGEBRA_I_SS.2016_2017.2.config,
	GEOMETRY.2016_2017.2.config,
	GEOMETRY_SS.2016_2017.2.config
)

# SGPstateData[["DC"]][["SGP_Configuration"]][["sgp.projections.use.only.complete.matrices"]] <- TRUE
PARCC_2016_2017.2.config <- PARCC_2016_2017.2.config[!sapply(PARCC_2016_2017.2.config, function(f) any(grepl("INTEGRATED_MATH_", f)))]
PARCC_2016_2017.2.config <- PARCC_2016_2017.2.config[!sapply(PARCC_2016_2017.2.config, function(f) any(grepl("ALGEBRA_II", f)))]
PARCC_2016_2017.2.config <- PARCC_2016_2017.2.config[!sapply(PARCC_2016_2017.2.config, function(f) any(grepl("2016_2017.1", f)))]

DC.CA <- c("ELA", "MATHEMATICS", "ALGEBRA_I", "GEOMETRY", "ELA_SS", "MATHEMATICS_SS", "ALGEBRA_I_SS", "GEOMETRY_SS")

### abcSGP

Washington_DC_SGP <- abcSGP(
		state="DC",
		sgp_object=fetchPARCC(state="DC", parcc.db = "../PARCC/Data/PARCC_Data_LONG.sqlite", prior.years=c("2015_2", "2016_1", "2016_2", "2017_1"), current.year="2017_2", fields="*")[GRADE %in% c(3:10, "EOCT") & CONTENT_AREA %in% DC.CA],
		sgp.config = PARCC_2016_2017.2.config,
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
		outputSGP.directory="Data/Archive/2016_2017.2",
    parallel.config=list(
			BACKEND = "FOREACH", TYPE = "doParallel", SNOW_TEST = TRUE,
			WORKERS = list(TAUS = workers, SIMEX = workers)))

### Save results
if (sgp.test) {
	save(Washington_DC_SGP, file="./Data/SIM/Washington_DC_SGP-Test_PARCC_2016_2017.2.Rdata")
} else save(Washington_DC_SGP, file="./Data/Archive/2016_2017.2/Washington_DC_SGP.Rdata")

### visualizeSGP

###  Need to modify the GRADE, CONTENT_AREA and Year Lag projection sequences to
###  Accurately reflect the course taking patterns in the state (the
###  original meta-data are based on the entire PARCC Consortium).

table(Washington_DC_SGP@Data[YEAR=="2016_2017.2" & !is.na(SGP), CONTENT_AREA])
table(Washington_DC_SGP@Data[YEAR=="2016_2017.2" & !is.na(SGP) & CONTENT_AREA=="ELA", GRADE])

SGPstateData[["DC"]][["Student_Report_Information"]][["Content_Areas_Domains"]] <- list(ELA="ELA", MATHEMATICS="MATHEMATICS", ALGEBRA_I="MATHEMATICS", GEOMETRY="MATHEMATICS")
SGPstateData[["DC"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ELA"]] <- c("3", "4", "5", "6", "7", "8", "9", "10")
SGPstateData[["DC"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ELA"]] <- rep("ELA", 8)
SGPstateData[["DC"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ELA"]] <- rep(1L, 7)

SGPstateData[["DC"]][["SGP_Configuration"]][["grade.projection.sequence"]][["MATHEMATICS"]] <- c("3", "4", "5", "6", "7", "8", "EOCT", "EOCT")
SGPstateData[["DC"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["MATHEMATICS"]] <- c("MATHEMATICS", "MATHEMATICS", "MATHEMATICS", "MATHEMATICS", "MATHEMATICS", "MATHEMATICS", "ALGEBRA_I", "GEOMETRY")
SGPstateData[["DC"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["MATHEMATICS"]] <- rep(1L, 7)

visualizeSGP(
	Washington_DC_SGP,
	plot.types=c("growthAchievementPlot"),
	parallel.config=list(BACKEND="PARALLEL", WORKERS=list(GA_PLOTS=workers)))

q("no")
