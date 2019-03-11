################################################################################
###                                                                          ###
###      SGP analysis script for PARCC consortium - Fall 2018 Analyses       ###
###                                                                          ###
################################################################################


if (!exists("sgp.test")) sgp.test <- FALSE
workers <- parallel::detectCores()/2

later:::ensureInitialized()

### Load Packages

require(SGP)
require(RSQLite)
require(data.table)


###  Load SGP LONG Data from last 3 Analyses
# load("./Data/Archive/2016_2017.2/PARCC_SGP_LONG_Data_2016_2017.2.Rdata")
# load("./Data/Archive/2017_2018.1/PARCC_SGP_LONG_Data_2017_2018.1.Rdata")
# load("./Data/Archive/2017_2018.2/PARCC_SGP_LONG_Data_2017_2018.2.Rdata")
# PARCC_SGP_LONG_Data <- rbindlist(list(PARCC_SGP_LONG_Data_2016_2017.2, PARCC_SGP_LONG_Data_2017_2018.1, PARCC_SGP_LONG_Data_2017_2018.2, PARCC_Data_LONG_2018_2019.1))
load("./PARCC/Data/Archive/2017_2018.2/PARCC_SGP_LONG_Data.Rdata")
PARCC_SGP_LONG_Data <- PARCC_SGP_LONG_Data[YEAR %in% c("2016_2017.2", "2017_2018.1", "2017_2018.2")]
###  Location of PARCC SQLite Database (Fall 2018 added in Data Prep step)
parcc.db <- "./PARCC/PARCC/Data/PARCC_Data_LONG.sqlite"

###  Read in the Fall 2018 configuration code and combine into a single list.

source("../SGP_CONFIG/2018_2019.1/ELA.R")
source("../SGP_CONFIG/2018_2019.1/ELA_SS.R")
source("../SGP_CONFIG/2018_2019.1/MATHEMATICS.R")
source("../SGP_CONFIG/2018_2019.1/MATHEMATICS_SS.R")

PARCC_2018_2019.1.config <- c(
	ELA_2018_2019.1.config,
	ELA_SS_2018_2019.1.config,

	ALGEBRA_I.2018_2019.1.config,
	ALGEBRA_I_SS.2018_2019.1.config,
	ALGEBRA_II.2018_2019.1.config,
	ALGEBRA_II_SS.2018_2019.1.config,
	GEOMETRY.2018_2019.1.config,
	GEOMETRY_SS.2018_2019.1.config
)


### abcSGP

PARCC_SGP <- abcSGP(
		state="PARCC",
		sgp_object=rbindlist(list(
			PARCC_SGP_LONG_Data,
			dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select * from PARCC_Data_LONG_2019_1")), fill=TRUE),
		sgp.config = PARCC_2018_2019.1.config,
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
		outputSGP.output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data"),
		outputSGP.directory="./Data/Archive/2018_2019.1",
    parallel.config=list(
			BACKEND = "FOREACH", TYPE = "doParallel",
			WORKERS = list(TAUS = workers, SIMEX = workers)))


### Save results

if (sgp.test) {
	save(PARCC_SGP, file="./Data/SIM/PARCC_SGP-Test_PARCC_2018_2019.1.Rdata")
} else save(PARCC_SGP, file="./Data/Archive/2018_2019.1/PARCC_SGP.Rdata")


q("no")

# table(PARCC_SGP@Data[, is.na(SGP), as.character(SGP_NORM_GROUP)])
# table(PARCC_SGP@Data[, is.na(SGP_NOTE), as.character(SGP_NORM_GROUP)])
table(PARCC_SGP@SGP$SGPercentiles$ELA.2018_2019.1[, is.na(SGP), as.character(SGP_NORM_GROUP)])
table(PARCC_SGP@SGP$SGPercentiles$ALGEBRA_I.2018_2019.1[, is.na(SGP_NOTE), as.character(SGP_NORM_GROUP)])


####

load("./Data/Archive/2018_2019.1/PARCC_SGP.Rdata")
load("../Maryland/Data/Archive/2018_2019.1/Additional_Maryland_Data_LONG_2018_2019.1.Rdata")

PARCC_SGP <- updateSGP(
		what_sgp_object = PARCC_SGP,
		with_sgp_data_LONG = Additional_Maryland_Data_LONG_2018_2019.1[,1:18],
		steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
		sgp.config = PARCC_2018_2019.1.config,
		sgp.percentiles = TRUE,
		sgp.projections = FALSE,
		sgp.projections.lagged = FALSE,
		sgp.percentiles.baseline = FALSE,
		sgp.projections.baseline = FALSE,
		sgp.projections.lagged.baseline = FALSE,
		# simulate.sgps=FALSE,

		sgp.use.my.coefficient.matrices = TRUE,
		calculate.simex = list(csem.data.vnames="SCALE_SCORE_CSEM", lambda=seq(0,2,0.5),
                        	 simulation.iterations=75, extrapolation="linear",
													 simex.use.my.coefficient.matrices=TRUE),
		overwrite.existing.data=FALSE,
		update.old.data.with.new=TRUE,

		save.intermediate.results = FALSE,
		outputSGP.output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data"),
		outputSGP.directory="./Data/Archive/2018_2019.1",
    parallel.config=list(
			BACKEND = "FOREACH", TYPE = "doParallel",
			WORKERS = list(TAUS = workers, SIMEX = workers)))

### Save results
save(PARCC_SGP, file="./Data/Archive/2018_2019.1/PARCC_SGP.Rdata")
