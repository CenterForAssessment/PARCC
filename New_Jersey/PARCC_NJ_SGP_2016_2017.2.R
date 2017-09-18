#################################################################################
###                                                                           ###
###      SGP analysis script for PARCC New_Jersey - Spring 2016 Analyses      ###
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

###  Load and Combine Analysis Configurations
source("../SGP_CONFIG/2016_2017.2/ELA.R")
source("../SGP_CONFIG/2016_2017.2/ELA_SS.R")
source("../SGP_CONFIG/2016_2017.2/MATHEMATICS.R")
source("../SGP_CONFIG/2016_2017.2/MATHEMATICS_SS.R")

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

NJ.CA <- c("ELA", "MATHEMATICS", "ALGEBRA_I", "ALGEBRA_II", "GEOMETRY", "ELA_SS", "MATHEMATICS_SS", "ALGEBRA_I_SS", "ALGEBRA_II_SS", "GEOMETRY_SS")


### abcSGP

New_Jersey_SGP <- abcSGP(
		state="NJ",
		sgp_object=fetchPARCC(state="NJ", parcc.db = "../PARCC/Data/PARCC_Data_LONG.sqlite", prior.years=c("2015_2", "2016_1", "2016_2", "2017_1"), current.year="2017_2", fields="*")[CONTENT_AREA %in% NJ.CA],
		sgp.config = PARCC_2016_2017.2.config,
		steps=c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
		prepareSGP.create.additional.variables=FALSE,
		sgp.percentiles=TRUE,
		sgp.projections=F,
		sgp.projections.lagged=F,
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
	save(New_Jersey_SGP, file="./Data/SIM/New_Jersey_SGP-Test_PARCC_2016_2017.2.Rdata")
} else save(New_Jersey_SGP, file="./Data/Archive/2016_2017.2/New_Jersey_SGP.Rdata")

### visualizeSGP

###  Need to modify the GRADE, CONTENT_AREA and Year Lag projection sequences to
###  Accurately reflect the course taking patterns in the state (the
###  original meta-data are based on the entire PARCC Consortium).

table(New_Jersey_SGP@Data[YEAR=="2016_2017.2" & !is.na(SGP), GRADE, CONTENT_AREA])
table(New_Jersey_SGP@Data[YEAR=="2016_2017.2" & !is.na(SGP) & CONTENT_AREA=="ELA", GRADE])

SGPstateData[["NJ"]][["Student_Report_Information"]][["Content_Areas_Domains"]] <- list(ELA="ELA", MATHEMATICS="MATHEMATICS", ALGEBRA_I="MATHEMATICS", GEOMETRY="MATHEMATICS", ALGEBRA_II="MATHEMATICS")

visualizeSGP(
	New_Jersey_SGP,
	plot.types=c("growthAchievementPlot"),
	parallel.config=list(BACKEND="PARALLEL", WORKERS=list(GA_PLOTS=workers)))


###  Fix duplicates

# names(New_Jersey_SGP@SGP$Goodness_of_Fit)
New_Jersey_SGP@SGP$SGProjections <- NULL

New_Jersey_SGP@SGP$SGPercentiles$ALGEBRA_I.2016_2017.2 <- NULL
New_Jersey_SGP@SGP$SGPercentiles$ALGEBRA_I_SS.2016_2017.2 <- NULL
New_Jersey_SGP@SGP$SGPercentiles$GEOMETRY.2016_2017.2 <- NULL
New_Jersey_SGP@SGP$SGPercentiles$GEOMETRY_SS.2016_2017.2 <- NULL

New_Jersey_SGP@SGP$SGPercentiles$ELA.2016_2017.2 <- New_Jersey_SGP@SGP$SGPercentiles$ELA.2016_2017.2[GRADE != '8']
New_Jersey_SGP@SGP$SGPercentiles$ELA_SS.2016_2017.2 <- New_Jersey_SGP@SGP$SGPercentiles$ELA_SS.2016_2017.2[GRADE != '8']
New_Jersey_SGP@SGP$SGPercentiles$MATHEMATICS.2016_2017.2 <- New_Jersey_SGP@SGP$SGPercentiles$MATHEMATICS.2016_2017.2[!GRADE %in% c('6', '8')]
New_Jersey_SGP@SGP$SGPercentiles$MATHEMATICS_SS.2016_2017.2 <- New_Jersey_SGP@SGP$SGPercentiles$MATHEMATICS_SS.2016_2017.2[!GRADE %in% c('6', '8')]


New_Jersey_SGP@SGP$Coefficient_Matrices <- New_Jersey_SGP@SGP$Coefficient_Matrices[13:20]

New_Jersey_SGP@SGP[["Coefficient_Matrices"]][["ELA.2016_2017.2"]] <- New_Jersey_SGP@SGP[["Coefficient_Matrices"]][["ELA.2016_2017.2"]][c(1:6,9:15)]
New_Jersey_SGP@SGP[["Coefficient_Matrices"]][["ELA_SS.2016_2017.2"]] <- New_Jersey_SGP@SGP[["Coefficient_Matrices"]][["ELA_SS.2016_2017.2"]][c(1:6,9:15)]
New_Jersey_SGP@SGP[["Coefficient_Matrices"]][["ELA.2016_2017.2.SIMEX"]] <- New_Jersey_SGP@SGP[["Coefficient_Matrices"]][["ELA.2016_2017.2.SIMEX"]][c(1:6,9:15)]
New_Jersey_SGP@SGP[["Coefficient_Matrices"]][["ELA_SS.2016_2017.2.SIMEX"]] <- New_Jersey_SGP@SGP[["Coefficient_Matrices"]][["ELA_SS.2016_2017.2.SIMEX"]][c(1:6,9:15)]

New_Jersey_SGP@SGP[["Coefficient_Matrices"]][["MATHEMATICS.2016_2017.2"]] <- New_Jersey_SGP@SGP[["Coefficient_Matrices"]][["MATHEMATICS.2016_2017.2"]][c(3:4, 7:9)]
New_Jersey_SGP@SGP[["Coefficient_Matrices"]][["MATHEMATICS_SS.2016_2017.2"]] <- New_Jersey_SGP@SGP[["Coefficient_Matrices"]][["MATHEMATICS_SS.2016_2017.2"]][c(3:4, 7:9)]
New_Jersey_SGP@SGP[["Coefficient_Matrices"]][["MATHEMATICS.2016_2017.2.SIMEX"]] <- New_Jersey_SGP@SGP[["Coefficient_Matrices"]][["MATHEMATICS.2016_2017.2.SIMEX"]][c(3:4, 7:9)]
New_Jersey_SGP@SGP[["Coefficient_Matrices"]][["MATHEMATICS_SS.2016_2017.2.SIMEX"]] <- New_Jersey_SGP@SGP[["Coefficient_Matrices"]][["MATHEMATICS_SS.2016_2017.2.SIMEX"]][c(3:4, 7:9)]

PARCC_2016_2017.2.config_FIX <- c(
	ELA.2016_2017.2.config <- list(
		ELA.2016_2017.2 = list(
			sgp.content.areas=rep("ELA", 3),
			sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
			sgp.grade.sequences=list(c("6", "7", "8")))),

	ELA_SS.2016_2017.2.config <- list(
		ELA_SS.2016_2017.2 = list(
			sgp.content.areas=rep("ELA_SS", 3),
			sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
			sgp.grade.sequences=list(c("6", "7", "8")))),

	MATHEMATICS.2016_2017.2.config <- list(
		MATHEMATICS.2016_2017.2 = list(
			sgp.content.areas=rep("MATHEMATICS", 3),
			sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
			sgp.grade.sequences=list(c("4", "5", "6"), c("6", "7", "8")))),

	MATHEMATICS_SS.2016_2017.2.config <- list(
		MATHEMATICS_SS.2016_2017.2 = list(
			sgp.content.areas=rep("MATHEMATICS_SS", 3),
			sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
			sgp.grade.sequences=list(c("4", "5", "6"), c("6", "7", "8")))),

	ALGEBRA_I.2016_2017.2.config,
	ALGEBRA_I_SS.2016_2017.2.config,
	GEOMETRY.2016_2017.2.config,
	GEOMETRY_SS.2016_2017.2.config)


	New_Jersey_SGP <- analyzeSGP(
			New_Jersey_SGP,
			sgp.config=PARCC_2016_2017.2.config_FIX,
			sgp.percentiles=TRUE,
			sgp.projections=FALSE,
			sgp.projections.lagged=FALSE,
			sgp.percentiles.baseline=FALSE,
			sgp.projections.baseline=FALSE,
			sgp.projections.lagged.baseline=FALSE,
			calculate.simex = TRUE,
			parallel.config=list(BACKEND="FOREACH", TYPE="doParallel", SNOW_TEST = TRUE, WORKERS=list(TAUS = workers, SIMEX = workers)))

	New_Jersey_SGP <- analyzeSGP(
			New_Jersey_SGP,
			sgp.config=PARCC_2016_2017.2.config,
			sgp.percentiles=FALSE,
			sgp.projections=TRUE,
			sgp.projections.lagged=TRUE,
			sgp.percentiles.baseline=FALSE,
			sgp.projections.baseline=FALSE,
			sgp.projections.lagged.baseline=FALSE,
			goodness.of.fit.print=FALSE,
			parallel.config = list(BACKEND="PARALLEL", WORKERS=list(PROJECTIONS = workers-3, LAGGED_PROJECTIONS = 3)))

	### combineSGP

	New_Jersey_SGP <- combineSGP(
			New_Jersey_SGP,
			sgp.target.scale.scores=TRUE,
			sgp.config=PARCC_2016_2017.2.config,
			parallel.config = list(BACKEND="PARALLEL", WORKERS=list(SGP_SCALE_SCORE_TARGETS = 2)))


	### Save results
	save(New_Jersey_SGP, file="Data/Archive/2016_2017.2/New_Jersey_SGP.Rdata")


	### outputSGP
	outputSGP(New_Jersey_SGP, output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data"), outputSGP.directory="Data/Archive/2016_2017.2")


# New_Jersey_SGP@SGP$SGPercentiles$ALGEBRA_I.2016_2017.2<- New_Jersey_SGP@SGP$SGPercentiles$ALGEBRA_I.2016_2017.2[!grepl("2015_2016.2/MATHEMATICS_7; 2016_2017.2/ALGEBRA_I_EOCT", SGP_NORM_GROUP)]
# New_Jersey_SGP@SGP$SGPercentiles$ALGEBRA_I.2016_2017.2<- New_Jersey_SGP@SGP$SGPercentiles$ALGEBRA_I.2016_2017.2[!grepl("2015_2016.2/MATHEMATICS_8; 2016_2017.2/ALGEBRA_I_EOCT", SGP_NORM_GROUP)]
# New_Jersey_SGP@SGP$SGPercentiles$GEOMETRY.2016_2017.2 <- New_Jersey_SGP@SGP$SGPercentiles$GEOMETRY.2016_2017.2[!grepl("2015_2016.2/ALGEBRA_I_EOCT; 2016_2017.2/GEOMETRY_EOCT", SGP_NORM_GROUP)]
