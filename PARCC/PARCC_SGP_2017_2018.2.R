#################################################################################
###                                                                           ###
###      SGP analysis script for PARCC consortium - Spring 2018 Analyses      ###
###                                                                           ###
#################################################################################

if (!exists("sgp.test")) sgp.test <- FALSE
workers <- parallel::detectCores()/2

### Load Packages

require(SGP)
require(data.table)


###  Load SGP LONG Data from FALL 2017 Analyses
load("./Data/Archive/2017_2018.1/PARCC_SGP_LONG_Data.Rdata")
load("./Data/Archive/2017_2018.2/PARCC_Data_LONG_2017_2018.2.Rdata")

PARCC_SGP_LONG_Data <- PARCC_SGP_LONG_Data[YEAR %in% c("2015_2016.2", "2016_2017.2", "2017_2018.1")]

###  These changes should have been made but weren't.
###  This problem required manual reconciling in the script below (after abcSGP function).
###  As a result ~3,000 DC kids were included in the PARCC ELA 10 norm group who otherwise would not have.  (However, these cases are VALID otherwise for inclusion).
# PARCC_SGP_LONG_Data[StateAbbreviation == "DC" & TestCode == "ELA09", VALID_CASE := "INVALID_CASE"] # 14,122 cases
# PARCC_SGP_LONG_Data[StateAbbreviation == "DC" & TestCode == "ALG01" & GradeLevelWhenAssessed %in% c("09", "10", "11", "12", "99"), VALID_CASE := "INVALID_CASE"] # 11,120 cases

###   INVALIDate duplicate prior test scores  --  49 cases in Spring 2018

setkey(PARCC_SGP_LONG_Data, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID, SCALE_SCORE, SCALE_SCORE_ACTUAL)
setkey(PARCC_SGP_LONG_Data, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID)
# dups <- PARCC_SGP_LONG_Data[c(which(duplicated(PARCC_SGP_LONG_Data, by=key(PARCC_SGP_LONG_Data)))-1, which(duplicated(PARCC_SGP_LONG_Data, by=key(PARCC_SGP_LONG_Data)))),]
# setkeyv(dups, key(PARCC_SGP_LONG_Data))
PARCC_SGP_LONG_Data[which(duplicated(PARCC_SGP_LONG_Data, by=key(PARCC_SGP_LONG_Data)))-1, VALID_CASE := "INVALID_CASE"]
table(PARCC_SGP_LONG_Data$VALID_CASE)


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

PARCC_SGP <- abcSGP(
		state="PARCC",
		sgp_object=rbindlist(list(
			PARCC_SGP_LONG_Data,
			PARCC_Data_LONG_2017_2018.2), fill=TRUE), # dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select * from PARCC_Data_LONG_2018_2")), fill=TRUE),
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
		outputSGP.directory= if (sgp.test) "./Data/SIM" else "Data/Archive/2017_2018.2",
    parallel.config=list(
			BACKEND = "FOREACH", TYPE = "doParallel", SNOW_TEST = TRUE,
			WORKERS = list(TAUS = workers, SIMEX = workers, SGP_SCALE_SCORE_TARGETS=10)))

### Save results

if (sgp.test) {
	save(PARCC_SGP, file="./Data/SIM/2017_2018.2/PARCC_SGP-Test_PARCC_2017_2018.2.Rdata")
} else save(PARCC_SGP, file="./Data/Archive/2017_2018.2/PARCC_SGP.Rdata")

###   Fix SGP_TARGET_3_YEAR_CONTENT_AREA in combineSGP and also remove DC ELA Grade 10 results with Grade 9 Prior.
PARCC_SGP@Data[which(YEAR=="2017_2018.2"), grep("SGP", names(PARCC_SGP@Data), value=TRUE) := NA]

dc.ids <- PARCC_SGP@Data[TestCode == "ELA10" & StateAbbreviation=="DC" & YEAR=="2017_2018.2", ID]
PARCC_SGP@SGP$SGPercentiles$ELA.2017_2018.2 <- PARCC_SGP@SGP$SGPercentiles$ELA.2017_2018.2[-which(ID %in% dc.ids & grepl("2016_2017.2/ELA_9; 2017_2018.2/ELA_10", SGP_NORM_GROUP)),]
PARCC_SGP@SGP$SGPercentiles$ELA_SS.2017_2018.2 <- PARCC_SGP@SGP$SGPercentiles$ELA_SS.2017_2018.2[-which(ID %in% dc.ids & grepl("2016_2017.2/ELA_SS_9; 2017_2018.2/ELA_SS_10", SGP_NORM_GROUP)),]

PARCC_SGP <- combineSGP(PARCC_SGP, sgp.target.content_areas = TRUE)
table(PARCC_SGP@Data[YEAR=="2017_2018.2", CONTENT_AREA, SGP_TARGET_3_YEAR_CONTENT_AREA])
table(PARCC_SGP@Data[YEAR=="2017_2018.2" & TestCode=="ELA10", as.character(SGP_NORM_GROUP)])
table(PARCC_SGP@Data[YEAR=="2017_2018.2" & TestCode=="ELA10" & StateAbbreviation=="DC", as.character(SGP_NORM_GROUP)])

outputSGP(PARCC_SGP, output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data"), outputSGP.directory="Data/Archive/2017_2018.2")
save(PARCC_SGP, file="./Data/Archive/2017_2018.2/PARCC_SGP.Rdata")


### visualizeSGP - faster without SNOW/SNOW_TEST

visualizeSGP(
	PARCC_SGP,
	plot.types=c("growthAchievementPlot"),
	parallel.config=list(BACKEND="PARALLEL", WORKERS=workers))
