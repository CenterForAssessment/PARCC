#################################################################################
###                                                                           ###
###          SGP analysis script for PARCC BIA - Spring 2016 Analyses         ###
###                                                                           ###
#################################################################################


if (!exists("sgp.test")) sgp.test <- FALSE
workers <- parallel::detectCores()/2

### Load Packages

require(SGP)
require(RSQLite)
require(data.table)


### Load configurations & combine

source("./SGP_CONFIG/2015_2016.2/ELA.R")
source("./SGP_CONFIG/2015_2016.2/ELA_SS.R")
source("./SGP_CONFIG/2015_2016.2/MATHEMATICS.R")
source("./SGP_CONFIG/2015_2016.2/MATHEMATICS_SS.R")


PARCC_2015_2016.2.config <- c(
	ELA_2015_2016.2.config,
	ELA_SS_2015_2016.2.config,

	MATHEMATICS_2015_2016.config,
	MATHEMATICS_SS_2015_2016.config,

	ALGEBRA_I.2015_2016.config,
	ALGEBRA_I_SS.2015_2016.config,
	ALGEBRA_II.2015_2016.config,
	ALGEBRA_II_SS.2015_2016.config,
	GEOMETRY.2015_2016.config,
	GEOMETRY_SS.2015_2016.config,

	INTEGRATED_MATH_1.2015_2016.config,
	INTEGRATED_MATH_1_SS.2015_2016.config,
	INTEGRATED_MATH_2.2015_2016.config,
	INTEGRATED_MATH_2_SS.2015_2016.config,
	INTEGRATED_MATH_3.2015_2016.config,
	INTEGRATED_MATH_3_SS.2015_2016.config
)


###  Figure out which states are needed for BIA priors
###  NO PRIOR DATA AVAILABLE

# priors <- rbindlist(list(
# 			dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select * from PARCC_Data_LONG_2015_2"),
# 			dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select * from PARCC_Data_LONG_2016_1")))

# bia.ids <- unique(dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select ID from PARCC_Data_LONG_2016_2 where StateAbbreviation in ('DC')"))

# bia.prior <- priors[which(priors$ID %in% bia.ids$ID)]
# table(bia.prior$StateAbbreviation)

### prepareSGP with Data read in directly from SQLite database

parcc.db <- "../PARCC/Data/PARCC_Data_LONG.sqlite"

BIA_SGP <- prepareSGP(
	state = "BIA",
	data = rbindlist(list(
		dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select * from PARCC_Data_LONG_2015_2 where StateAbbreviation in ('BI')"),
		dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select * from PARCC_Data_LONG_2016_1 where StateAbbreviation in ('BI')"),
		dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select * from PARCC_Data_LONG_2016_2 where StateAbbreviation in ('BI')")), fill=TRUE), 
	create.additional.variables=FALSE)


### analyzeSGP (for student growth percentiles)

BIA_SGP <- analyzeSGP(
		state = "BIA",
		BIA_SGP,
		sgp.config=PARCC_2015_2016.2.config,
		sgp.percentiles=TRUE,
		sgp.projections=FALSE,
		sgp.projections.lagged=FALSE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline=FALSE,
		sgp.projections.lagged.baseline=FALSE,
		calculate.simex= if (sgp.test) list(lambda=seq(0,2,0.5), simulation.iterations=10, csem.data.vnames="SCALE_SCORE_CSEM", extrapolation="linear", save.matrices=TRUE) else TRUE,
		sgp.test.cohort.size= if (sgp.test) 1500 else NULL,     #### )
		return.sgp.test.results= if (sgp.test) TRUE else FALSE, ##   > -- Turn OFF these 3 for real analyses
		goodness.of.fit.print= if (sgp.test) FALSE else TRUE,   #### )
		get.cohort.data.info=TRUE,
		parallel.config=list(BACKEND="FOREACH", TYPE="doParallel", SNOW_TEST=TRUE, WORKERS=list(TAUS = workers, SIMEX = workers)))


### analyzeSGP (for student growth projections)

# BIA_SGP <- analyzeSGP(
# 		state = "BIA",
# 		BIA_SGP,
# 		sgp.config=PARCC_2015_2016.2.config,
# 		sgp.percentiles=FALSE,
# 		sgp.projections=TRUE,
# 		sgp.projections.lagged=TRUE,
# 		sgp.percentiles.baseline=FALSE,
# 		sgp.projections.baseline=FALSE,
# 		sgp.projections.lagged.baseline=FALSE,
# 		parallel.config = if (sgp.test) NULL else list(BACKEND="FOREACH", TYPE="doParallel", SNOW_TEST=TRUE, WORKERS=list(PROJECTIONS = (workers-2), LAGGED_PROJECTIONS = (workers-4))))


### combineSGP

BIA_SGP <- combineSGP(
		BIA_SGP,
		sgp.target.scale.scores=TRUE,
		sgp.config=PARCC_2015_2016.2.config,
		parallel.config = if (sgp.test) NULL else list(BACKEND="FOREACH", TYPE="doParallel", SNOW_TEST=TRUE, WORKERS=list(SGP_SCALE_SCORE_TARGETS = (workers-4))))


### Save results

if (sgp.test) {
	save(BIA_SGP, file="Data/SIM/BIA_SGP-Test.Rdata")
} else save(BIA_SGP, file="Data/BIA_SGP.Rdata")


### visualizeSGP

# visualizeSGP(
# 	BIA_SGP,
# 	plot.types=c("growthAchievementPlot", "studentGrowthPlot"),
# 	sgPlot.demo.report=TRUE)


### outputSGP

outputSGP(BIA_SGP, outputSGP.directory=if (sgp.test) "Data/SIM" else "Data")

q("no")
