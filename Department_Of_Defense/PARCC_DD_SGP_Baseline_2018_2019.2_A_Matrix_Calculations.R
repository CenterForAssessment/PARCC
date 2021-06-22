################################################################################
###                                                                          ###
###    Department of Defense Learning Loss Analyses -- Baseline Matrices     ###
###                                                                          ###
################################################################################

### Load necessary packages
require(SGP)
require(data.table)

###   Load Original Department of Defense data from 2019 DD SGP Analyses

load("Data/Archive/2018_2019.2/Department_of_Defense_SGP_LONG_Data.Rdata")

###   Create a smaller subset of the LONG data to work with.
parcc.subjects <- c("ELA", "MATHEMATICS", "ALGEBRA_I", "GEOMETRY", "ALGEBRA_II")

Department_of_Defense_Baseline_Data <- Department_of_Defense_SGP_LONG_Data[CONTENT_AREA %in% parcc.subjects,
			list(VALID_CASE, ID, YEAR, CONTENT_AREA, GRADE, SCALE_SCORE, SCALE_SCORE_CSEM, ACHIEVEMENT_LEVEL)]

###  Enough to do grade level ELA/Math
table(Department_of_Defense_Baseline_Data[, YEAR, CONTENT_AREA])

###   Read in Baseline SGP Configuration Scripts and Combine
source("../SGP_CONFIG/2018_2019.2/BASELINE/Matrices/ELA.R")
source("../SGP_CONFIG/2018_2019.2/BASELINE/Matrices/MATHEMATICS.R")

DD_BASELINE_CONFIG <- c(
		ELA_BASELINE.config,
		MATHEMATICS_BASELINE.config,

		# ALGEBRA_I_BASELINE.config, # only a handful of kids with 2018 priors...
		GEOMETRY_BASELINE.config,
		ALGEBRA_II_BASELINE.config
)


###
###    baselineSGP - To produce uncorrected and SIMEX baseline matrices
###

###   First create shell SGP object
Department_of_Defense_SGP <- prepareSGP(Department_of_Defense_Baseline_Data, create.additional.variables=FALSE)

Department_of_Defense_Baseline_Matrices <- baselineSGP(
	Department_of_Defense_SGP,
	sgp.baseline.config=DD_BASELINE_CONFIG,
	return.matrices.only=TRUE,
	calculate.baseline.sgps=FALSE,
	calculate.simex.baseline=list(
		csem.data.vnames="SCALE_SCORE_CSEM", lambda=seq(0,2,0.5), extrapolation="linear",
		simulation.iterations=75, simex.use.my.coefficient.matrices = FALSE,
		save.matrices=TRUE, use.cohort.for.ranking=TRUE),
	sgp.cohort.size=500,
	goodness.of.fit.print=FALSE,
	parallel.config=list(
		BACKEND="PARALLEL",
		WORKERS=list(TAUS=13, SIMEX=15)))

###   Save results
save(Department_of_Defense_Baseline_Matrices, file="Data/Department_of_Defense_Baseline_Matrices.Rdata")
