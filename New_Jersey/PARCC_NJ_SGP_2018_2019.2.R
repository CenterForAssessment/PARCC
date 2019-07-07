#################################################################################
###                                                                           ###
###      SGP analysis script for PARCC New_Jersey - Spring 2019 Analyses      ###
###                                                                           ###
#################################################################################

if (!exists("sgp.test")) sgp.test <- FALSE
workers <- parallel::detectCores()/2

### Load Packages
require(SGP)
require(data.table)

###  Load Data
load("./Data/Archive/2016_2017.2/New_Jersey_SGP_LONG_Data_2016_2017.2.Rdata")
load("./Data/Archive/2017_2018.2/New_Jersey_SGP_LONG_Data_2017_2018.2.Rdata")
load("./Data/Archive/2018_2019.1/New_Jersey_SGP_LONG_Data_2018_2019.1.Rdata")
load("./Data/Archive/2018_2019.2/New_Jersey_Data_LONG_2018_2019.2.Rdata")

###  Reset 2017 names to match other years
setnames(New_Jersey_SGP_LONG_Data_2016_2017.2, c("CATCH_UP_KEEP_UP_STATUS", "MOVE_UP_STAY_UP_STATUS"), c("CATCH_UP_KEEP_UP_STATUS_3_YEAR", "MOVE_UP_STAY_UP_STATUS_3_YEAR"))

New_Jersey_SGP_LONG_Data <- rbindlist(list(
				New_Jersey_SGP_LONG_Data_2016_2017.2,
				New_Jersey_SGP_LONG_Data_2017_2018.2,
				New_Jersey_SGP_LONG_Data_2018_2019.1), fill=TRUE)

rm(list = c("New_Jersey_SGP_LONG_Data_2016_2017.2", "New_Jersey_SGP_LONG_Data_2017_2018.2", "New_Jersey_SGP_LONG_Data_2018_2019.1")); gc()

###   INVALIDate duplicate prior test scores  --  4 cases in Spring 2019

setkey(New_Jersey_SGP_LONG_Data, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID, SCALE_SCORE, SCALE_SCORE_ACTUAL)
setkey(New_Jersey_SGP_LONG_Data, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID)
# dups <- New_Jersey_SGP_LONG_Data[c(which(duplicated(New_Jersey_SGP_LONG_Data, by=key(New_Jersey_SGP_LONG_Data)))-1, which(duplicated(New_Jersey_SGP_LONG_Data, by=key(New_Jersey_SGP_LONG_Data)))),]
# setkeyv(dups, key(New_Jersey_SGP_LONG_Data))
New_Jersey_SGP_LONG_Data[which(duplicated(New_Jersey_SGP_LONG_Data, by=key(New_Jersey_SGP_LONG_Data)))-1, VALID_CASE := "INVALID_CASE"]
table(New_Jersey_SGP_LONG_Data$VALID_CASE)

###  Read in the Spring 2018 configuration code and combine into a single list.
source("../SGP_CONFIG/2018_2019.2/ELA.R")
source("../SGP_CONFIG/2018_2019.2/ELA_SS.R")
source("../SGP_CONFIG/2018_2019.2/MATHEMATICS.R")
source("../SGP_CONFIG/2018_2019.2/MATHEMATICS_SS.R")

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
	ALGEBRA_II_SS.2018_2019.2.config
)

PARCC_2018_2019.2.config <- PARCC_2018_2019.2.config[!sapply(PARCC_2018_2019.2.config, function(f) any(grepl("INTEGRATED_MATH_", f)))]


### abcSGP


New_Jersey_SGP <- abcSGP(
		state="NJ",
		sgp_object=rbindlist(list(
				New_Jersey_SGP_LONG_Data, #  Prior Years
				New_Jersey_Data_LONG_2018_2019.2), fill=TRUE),
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
			WORKERS = list(TAUS = workers, SIMEX = workers)))

### Save results
if (sgp.test) {
	save(New_Jersey_SGP, file="./Data/SIM/New_Jersey_SGP-Test_PARCC_2018_2019.2.Rdata")
} else save(New_Jersey_SGP, file="./Data/Archive/2018_2019.2/New_Jersey_SGP.Rdata")

###   Fix SGP_TARGET_3_YEAR_CONTENT_AREA in combineSGP
New_Jersey_SGP <- combineSGP(New_Jersey_SGP, sgp.target.content_areas = TRUE)
"SGP_TARGET_3_YEAR_CONTENT_AREA" %in% names(New_Jersey_SGP@Data)
table(New_Jersey_SGP@Data[, CONTENT_AREA, SGP_TARGET_3_YEAR_CONTENT_AREA])

outputSGP(New_Jersey_SGP, output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data"), outputSGP.directory="Data/Archive/2018_2019.2")
save(New_Jersey_SGP, file="./Data/Archive/2018_2019.2/New_Jersey_SGP.Rdata")


### visualizeSGP

###  Need to modify the GRADE, CONTENT_AREA and Year Lag projection sequences to
###  Accurately reflect the course taking patterns in the state (the
###  original meta-data are based on the entire PARCC Consortium).

table(New_Jersey_SGP@Data[YEAR=="2018_2019.2" & !is.na(SGP), GRADE, CONTENT_AREA])
table(New_Jersey_SGP@Data[YEAR=="2018_2019.2" & !is.na(SGP) & CONTENT_AREA=="ELA", GRADE])

SGPstateData[["NJ"]][["Student_Report_Information"]][["Content_Areas_Domains"]] <- list(ELA="ELA", MATHEMATICS="MATHEMATICS", ALGEBRA_I="MATHEMATICS", GEOMETRY="MATHEMATICS", ALGEBRA_II="MATHEMATICS")

visualizeSGP(
	New_Jersey_SGP,
	plot.types=c("growthAchievementPlot"),
	parallel.config=list(BACKEND="PARALLEL", WORKERS=list(GA_PLOTS=workers)))
