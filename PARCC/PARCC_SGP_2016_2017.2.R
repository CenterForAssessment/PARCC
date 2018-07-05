#################################################################################
###                                                                           ###
###      SGP analysis script for PARCC consortium - Spring 2017 Analyses      ###
###                                                                           ###
#################################################################################


if (!exists("sgp.test")) sgp.test <- FALSE
workers <- parallel::detectCores()/2

### Load Packages

require(SGP)
require(RSQLite)
require(data.table)


###  Load SGP LONG Data from FALL 2016 Analyses
load("./Data/Archive/2016_2017.1/PARCC_SGP_LONG_Data.Rdata")
PARCC_SGP_LONG_Data <- PARCC_SGP_LONG_Data[, ID:=gsub("_DUPS_[0-9]*", "", ID)] # Keep ALL data - only single longitudinal database :: [StateAbbreviation != "MA" & YEAR %in% c("2014_2015.2", "2015_2016.2", "2016_2017.1")]

PARCC_SGP_LONG_Data <- SGP:::getAchievementLevel(PARCC_SGP_LONG_Data, state="PARCC")

###   INVALIDate duplicate prior test scores

setkey(PARCC_SGP_LONG_Data, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID, SCALE_SCORE, SCALE_SCORE_ACTUAL)
setkey(PARCC_SGP_LONG_Data, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID)
# dups <- PARCC_SGP_LONG_Data[c(which(duplicated(PARCC_SGP_LONG_Data, by=key(PARCC_SGP_LONG_Data)))-1, which(duplicated(PARCC_SGP_LONG_Data, by=key(PARCC_SGP_LONG_Data)))),]
# setkeyv(dups, key(PARCC_SGP_LONG_Data))
PARCC_SGP_LONG_Data[which(duplicated(PARCC_SGP_LONG_Data, by=key(PARCC_SGP_LONG_Data)))-1, VALID_CASE := "INVALID_CASE"]

# save(PARCC_SGP_LONG_Data, file="/home/ec2-user/PARCC_Prior_Data.Rdata")

###  Location of PARCC SQLite Database (Spring 2017 added in Data Prep step)
parcc.db <- "./Data/PARCC_Data_LONG.sqlite"

###  Read in the Spring 2017 configuration code and combine into a single list.

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
	ALGEBRA_II_SS.2016_2017.2.config,

	INTEGRATED_MATH_1.2016_2017.2.config,
	INTEGRATED_MATH_1_SS.2016_2017.2.config,
	INTEGRATED_MATH_2.2016_2017.2.config,
	INTEGRATED_MATH_2_SS.2016_2017.2.config,
	INTEGRATED_MATH_3.2016_2017.2.config,
	INTEGRATED_MATH_3_SS.2016_2017.2.config
)

### abcSGP

PARCC_SGP <- abcSGP(
		state="PARCC",
		sgp_object=rbindlist(list(
			PARCC_SGP_LONG_Data,
			dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select * from PARCC_Data_LONG_2017_2")), fill=TRUE),
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
		outputSGP.directory= if (sgp.test) "./Data/SIM" else "Data/Archive/2016_2017.2",
    parallel.config=list(
			BACKEND = "FOREACH", TYPE = "doParallel", SNOW_TEST = TRUE,
			WORKERS = list(TAUS = workers, SIMEX = workers)))

sum(grepl("_DUPS_[0-9]*", PARCC_SGP@SGP$SGPercentiles$MATHEMATICS.2016_2017.2$ID))

### Save results

if (sgp.test) {
	save(PARCC_SGP, file="./Data/SIM/2016_2017.2/PARCC_SGP-Test_PARCC_2016_2017.2.Rdata")
} else save(PARCC_SGP, file="./Data/Archive/2016_2017.2/PARCC_SGP.Rdata")


### visualizeSGP

visualizeSGP(
	PARCC_SGP,
	plot.types=c("growthAchievementPlot"),
	parallel.config=list(BACKEND="PARALLEL", WORKERS=list(GA_PLOTS=workers)))


	###  Fix duplicates

	#  Fix @Data slot:
	con <- dbConnect(SQLite(), dbname = parcc.db)
	PARCC_Data_LONG <- rbindlist(list(
		PARCC_SGP_LONG_Data,
		dbGetQuery(con, "select * from PARCC_Data_LONG_2017_2")), fill=TRUE)
	dbDisconnect(con)

	PARCC_Data <- prepareSGP(data=PARCC_Data_LONG, state="PARCC", create.additional.variables=FALSE)
	PARCC_SGP@Data <- PARCC_Data@Data

	#  Fix @SGP slot:
	# names(PARCC_SGP@SGP$Goodness_of_Fit)
	PARCC_SGP@SGP$SGProjections <- NULL

	PARCC_SGP@SGP$SGPercentiles$ALGEBRA_I.2016_2017.2 <- NULL
	PARCC_SGP@SGP$SGPercentiles$ALGEBRA_I_SS.2016_2017.2 <- NULL
	PARCC_SGP@SGP$SGPercentiles$GEOMETRY.2016_2017.2 <- NULL
	PARCC_SGP@SGP$SGPercentiles$GEOMETRY_SS.2016_2017.2 <- NULL

	PARCC_SGP@SGP$SGPercentiles$ELA.2016_2017.2 <- PARCC_SGP@SGP$SGPercentiles$ELA.2016_2017.2[GRADE != '8']
	PARCC_SGP@SGP$SGPercentiles$ELA_SS.2016_2017.2 <- PARCC_SGP@SGP$SGPercentiles$ELA_SS.2016_2017.2[GRADE != '8']
	PARCC_SGP@SGP$SGPercentiles$MATHEMATICS.2016_2017.2 <- PARCC_SGP@SGP$SGPercentiles$MATHEMATICS.2016_2017.2[!GRADE %in% c('6', '8')]
	PARCC_SGP@SGP$SGPercentiles$MATHEMATICS_SS.2016_2017.2 <- PARCC_SGP@SGP$SGPercentiles$MATHEMATICS_SS.2016_2017.2[!GRADE %in% c('6', '8')]

	PARCC_SGP@SGP$Coefficient_Matrices <- PARCC_SGP@SGP$Coefficient_Matrices[c(1:8, 13:16, 21:28)]

	PARCC_SGP@SGP[["Coefficient_Matrices"]][["ELA.2016_2017.2"]] <- PARCC_SGP@SGP[["Coefficient_Matrices"]][["ELA.2016_2017.2"]][c(1:6,9:15)]
	PARCC_SGP@SGP[["Coefficient_Matrices"]][["ELA_SS.2016_2017.2"]] <- PARCC_SGP@SGP[["Coefficient_Matrices"]][["ELA_SS.2016_2017.2"]][c(1:6,9:15)]
	PARCC_SGP@SGP[["Coefficient_Matrices"]][["ELA.2016_2017.2.SIMEX"]] <- PARCC_SGP@SGP[["Coefficient_Matrices"]][["ELA.2016_2017.2.SIMEX"]][c(1:6,9:15)]
	PARCC_SGP@SGP[["Coefficient_Matrices"]][["ELA_SS.2016_2017.2.SIMEX"]] <- PARCC_SGP@SGP[["Coefficient_Matrices"]][["ELA_SS.2016_2017.2.SIMEX"]][c(1:6,9:15)]

	PARCC_SGP@SGP[["Coefficient_Matrices"]][["MATHEMATICS.2016_2017.2"]] <- PARCC_SGP@SGP[["Coefficient_Matrices"]][["MATHEMATICS.2016_2017.2"]][c(3:4, 7:9)]
	PARCC_SGP@SGP[["Coefficient_Matrices"]][["MATHEMATICS_SS.2016_2017.2"]] <- PARCC_SGP@SGP[["Coefficient_Matrices"]][["MATHEMATICS_SS.2016_2017.2"]][c(3:4, 7:9)]
	PARCC_SGP@SGP[["Coefficient_Matrices"]][["MATHEMATICS.2016_2017.2.SIMEX"]] <- PARCC_SGP@SGP[["Coefficient_Matrices"]][["MATHEMATICS.2016_2017.2.SIMEX"]][c(3:4, 7:9)]
	PARCC_SGP@SGP[["Coefficient_Matrices"]][["MATHEMATICS_SS.2016_2017.2.SIMEX"]] <- PARCC_SGP@SGP[["Coefficient_Matrices"]][["MATHEMATICS_SS.2016_2017.2.SIMEX"]][c(3:4, 7:9)]

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


PARCC_SGP <- analyzeSGP(
		PARCC_SGP,
		sgp.config=PARCC_2016_2017.2.config_FIX,
		sgp.percentiles=TRUE,
		sgp.projections=FALSE,
		sgp.projections.lagged=FALSE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline=FALSE,
		sgp.projections.lagged.baseline=FALSE,
		calculate.simex = TRUE,
		parallel.config=list(BACKEND="FOREACH", TYPE="doParallel", SNOW_TEST = TRUE, WORKERS=list(TAUS = workers, SIMEX = workers)))


PARCC_SGP <- analyzeSGP(
		PARCC_SGP,
		sgp.config=PARCC_2016_2017.2.config,
		sgp.percentiles=FALSE,
		sgp.projections=TRUE,
		sgp.projections.lagged=TRUE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline=FALSE,
		sgp.projections.lagged.baseline=FALSE,
		goodness.of.fit.print=FALSE,
		parallel.config = list(BACKEND="PARALLEL", WORKERS=list(PROJECTIONS = 3, LAGGED_PROJECTIONS = 2)))

### combineSGP

PARCC_SGP <- combineSGP(
		PARCC_SGP,
		sgp.target.scale.scores=F)#TRUE,
		sgp.config=PARCC_2016_2017.2.config,
		parallel.config = list(BACKEND="PARALLEL", WORKERS=list(SGP_SCALE_SCORE_TARGETS = workers)))


### Save results
save(PARCC_SGP, file="Data/Archive/2016_2017.2/PARCC_SGP.Rdata")


### outputSGP
outputSGP(PARCC_SGP, output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data"), outputSGP.directory="Data/Archive/2016_2017.2")
