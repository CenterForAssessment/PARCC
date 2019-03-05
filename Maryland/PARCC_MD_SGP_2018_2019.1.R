################################################################################
###                                                                          ###
###       SGP analysis script for PARCC Maryland - Fall 2018 Analyses        ###
###                                                                          ###
################################################################################

if (!exists("sgp.test")) sgp.test <- FALSE
workers <- parallel::detectCores()

###   Load Packages

require(SGP)
require(RSQLite)
require(data.table)

source("~/Dropbox (SGP)/Github_Repos/Projects/PARCC/fetchPARCC.R")


###   Create Fall 2018 Archive for MD

dir.create("./Data/Archive/2018_2019.1", recursive=TRUE)

###   Read in the Spring 2018 configuration code and combine into a single list.

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


###   abcSGP

Maryland_SGP <- abcSGP(
		state="MD",
		sgp_object=fetchPARCC(
			state="MD", fields="*",
			parcc.db = "../PARCC/Data/PARCC_Data_LONG.sqlite",
			prior.years=c("2017_2","2018_1", "2018_2"),
			current.year="2019_1"),
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
		outputSGP.output.type="LONG_FINAL_YEAR_Data",
		outputSGP.directory="./Data/Archive/2018_2019.1",
    parallel.config=list(
			BACKEND = "FOREACH", TYPE = "doParallel",
			WORKERS = list(TAUS = workers, SIMEX = workers)))

# table(Maryland_SGP@Data[, is.na(SGP), as.character(SGP_NORM_GROUP)])
# table(Maryland_SGP@Data[, is.na(SGP_NOTE), as.character(SGP_NORM_GROUP)])


###   Save results

if (sgp.test) {
	save(Maryland_SGP, file="./Data/SIM/Maryland_SGP-Test_PARCC_2018_2019.1.Rdata")
} else save(Maryland_SGP, file="./Data/Archive/2018_2019.1/Maryland_SGP.Rdata")


sessionInfo(); q("no")
