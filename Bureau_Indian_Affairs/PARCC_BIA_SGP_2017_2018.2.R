####################################################################################
###                                                                              ###
###  SGP analysis script for PARCC Bureau_Indian_Affairs - Spring 2018 Analyses  ###
###                                                                              ###
####################################################################################

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
	ALGEBRA_II_SS.2017_2018.2.config,

	INTEGRATED_MATH_1.2017_2018.2.config,
	INTEGRATED_MATH_1_SS.2017_2018.2.config,
	INTEGRATED_MATH_2.2017_2018.2.config,
	INTEGRATED_MATH_2_SS.2017_2018.2.config,
	INTEGRATED_MATH_3.2017_2018.2.config,
	INTEGRATED_MATH_3_SS.2017_2018.2.config
)

### abcSGP

Bureau_Indian_Affairs_SGP <- abcSGP(
		state="BI",
		sgp_object=fetchPARCC(state="BI", parcc.db = "../PARCC/Data/PARCC_Data_LONG.sqlite", prior.years=c("2016_2", "2017_1", "2017_2", "2018_1"), current.year="2018_2", fields="*"),
		# content_areas = c("ELA", "ELA_SS", "MATHEMATICS", "MATHEMATICS_SS"),
		sgp.config = PARCC_2017_2018.2.config,
		steps=c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
		prepareSGP.create.additional.variables=FALSE,
		sgp.percentiles=TRUE,
		sgp.projections=FALSE,
		sgp.projections.lagged=FALSE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline=FALSE,
		sgp.projections.lagged.baseline=FALSE,
		calculate.simex= if (sgp.test) list(lambda=seq(0,2,0.5), simulation.iterations=10, csem.data.vnames="SCALE_SCORE_CSEM", extrapolation="linear", save.matrices=TRUE) else TRUE,
		sgp.test.cohort.size= if (sgp.test) 1500 else NULL,     ####
		return.sgp.test.results= if (sgp.test) TRUE else FALSE, ## -- Turn OFF these 3 for real analyses
		goodness.of.fit.print= if (sgp.test) FALSE else TRUE,   ####
		save.intermediate.results=FALSE,
		sgp.target.scale.scores=FALSE, # to combineSGP
		outputSGP.output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data"),
		outputSGP.directory="Data/Archive/2017_2018.2",
    parallel.config=list(
			BACKEND = "FOREACH", TYPE = "doParallel", SNOW_TEST = TRUE,
			WORKERS = list(TAUS = workers, SIMEX = workers)))

### Save results
if (sgp.test) {
	save(Bureau_Indian_Affairs_SGP, file="./Data/SIM/Bureau_Indian_Affairs_SGP-Test_PARCC_2017_2018.2.Rdata")
} else save(Bureau_Indian_Affairs_SGP, file="./Data/Archive/2017_2018.2/Bureau_Indian_Affairs_SGP.Rdata")

### visualizeSGP

###  Need to modify the GRADE, CONTENT_AREA and Year Lag projection sequences to
###  Accurately reflect the course taking patterns in the state (the
###  original meta-data are based on the entire PARCC Consortium).

table(Bureau_Indian_Affairs_SGP@Data[YEAR=="2017_2018.2" & !is.na(SGP), CONTENT_AREA])
table(Bureau_Indian_Affairs_SGP@Data[YEAR=="2017_2018.2" & !is.na(SGP) & CONTENT_AREA=="ELA", GRADE])

SGPstateData[["BI"]][["Student_Report_Information"]][["Content_Areas_Domains"]] <- list(ELA="ELA", MATHEMATICS="MATHEMATICS", ALGEBRA_I="MATHEMATICS", GEOMETRY="MATHEMATICS", ALGEBRA_II="MATHEMATICS")

visualizeSGP(
	state="BI",
	Bureau_Indian_Affairs_SGP,
	plot.types=c("growthAchievementPlot"),
	parallel.config=list(BACKEND="PARALLEL", WORKERS=list(GA_PLOTS=workers)))

q("no")
