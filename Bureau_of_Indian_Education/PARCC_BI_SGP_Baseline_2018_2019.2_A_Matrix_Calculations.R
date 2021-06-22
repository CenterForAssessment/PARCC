################################################################################
###                                                                          ###
###  Bureau of Indian Education Learning Loss Analyses -- Baseline Matrices  ###
###                                                                          ###
################################################################################

### Load necessary packages
require(SGP)
require(data.table)

###   Load Original Bureau of Indian EDUCATION data from 2019 BIE SGP Analyses

load("Data/Archive/2018_2019.2/Bureau_Indian_Affairs_SGP_LONG_Data.Rdata")

###   Create a smaller subset of the LONG data to work with.
parcc.years <- c("2016_2017.2", "2017_2018.2", "2018_2019.2")
parcc.subjects <- c("ELA", "MATHEMATICS", "ALGEBRA_I", "GEOMETRY", "ALGEBRA_II")

Bureau_of_Indian_Education_Baseline_Data <- Bureau_Indian_Affairs_SGP_LONG_Data[CONTENT_AREA %in% parcc.subjects & YEAR %in% parcc.years,
			list(VALID_CASE, ID, YEAR, CONTENT_AREA, GRADE, SCALE_SCORE, SCALE_SCORE_CSEM, ACHIEVEMENT_LEVEL)]

###  Enough to do grade level ELA/Math
table(Bureau_of_Indian_Education_Baseline_Data[, YEAR, CONTENT_AREA])

###   Read in Baseline SGP Configuration Scripts and Combine
source("../SGP_CONFIG/2018_2019.2/BASELINE/Matrices/ELA.R")
source("../SGP_CONFIG/2018_2019.2/BASELINE/Matrices/MATHEMATICS.R")

BIE_BASELINE_CONFIG <- c(
		ELA_BASELINE.config,
		MATHEMATICS_BASELINE.config
)


###
###    baselineSGP - To produce uncorrected and SIMEX baseline matrices
###

###   First create shell SGP object
Bureau_of_Indian_Education_SGP <- prepareSGP(Bureau_of_Indian_Education_Baseline_Data, create.additional.variables=FALSE)

Bureau_of_Indian_Education_Baseline_Matrices <- baselineSGP(
	Bureau_of_Indian_Education_SGP,
	sgp.baseline.config=BIE_BASELINE_CONFIG,
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
		WORKERS=list(TAUS=13, SIMEX=15))
)

###   Save results
if (!dir.exists("Data")) dir.create("Data")
save(Bureau_of_Indian_Education_Baseline_Matrices, file="Data/Bureau_of_Indian_Education_Baseline_Matrices.Rdata")
