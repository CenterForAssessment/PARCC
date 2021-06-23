################################################################################
###                                                                          ###
###     PARCC Learning Loss Analyses -- 2019 Baseline Growth Percentiles     ###
###                                                                          ###
################################################################################

###   Load packages
require(SGP)
require(data.table)

###   Load data and remove some old vars.
load("Data/Archive/2018_2019.2/PARCC_SGP_LONG_Data.Rdata")
load("Data/Archive/2015_2016.2/PARCC_SGP_LONG_Data_2015_2016.2.Rdata")

PARCC_SGP_LONG_Data[, Current_Score := NULL]
PARCC_SGP_LONG_Data <- PARCC_SGP_LONG_Data[is.na(EXACT_DUPLICATE) | EXACT_DUPLICATE == 1]
PARCC_SGP_LONG_Data[, EXACT_DUPLICATE := NULL]

# names(PARCC_SGP_LONG_Data_2015_2016.2)[!names(PARCC_SGP_LONG_Data_2015_2016.2) %in%names(PARCC_SGP_LONG_Data)]
# names(PARCC_SGP_LONG_Data)[!names(PARCC_SGP_LONG_Data) %in%names(PARCC_SGP_LONG_Data_2015_2016.2)]
setnames(PARCC_SGP_LONG_Data_2015_2016.2,
		c("CATCH_UP_KEEP_UP_STATUS", "MOVE_UP_STAY_UP_STATUS"),
		c("CATCH_UP_KEEP_UP_STATUS_3_YEAR", "MOVE_UP_STAY_UP_STATUS_3_YEAR"))

###   Create a smaller subset of the LONG data to work with.
###   Only states in consortium 2021 and (?) beyond.
parcc.members <- c("BI", "DC", "DD", "IL", "NJ") # , "NM", "MD",
parcc.years <- c("2016_2017.2", "2017_2018.2", "2018_2019.2")
parcc.subjects <- c("ELA", "MATHEMATICS", "ALGEBRA_I", "GEOMETRY", "ALGEBRA_II")

PARCC_SGP_LONG_Data <- rbindlist(list(
		PARCC_SGP_LONG_Data_2015_2016.2[
			StateAbbreviation %in% parcc.members & CONTENT_AREA %in% parcc.subjects, ],
		PARCC_SGP_LONG_Data[
			StateAbbreviation %in% parcc.members & CONTENT_AREA %in% parcc.subjects & YEAR %in% parcc.years, ]),
		fill=TRUE)

###   Add single-cohort baseline matrices to SGPstateData
load("Data/PARCC_Baseline_Matrices.Rdata")
SGPstateData[["PARCC"]][["Baseline_splineMatrix"]][["Coefficient_Matrices"]] <- PARCC_Baseline_Matrices
SGPstateData[["PARCC"]][["SGP_Configuration"]][["sgp.cohort.size"]] <- NULL

###   Read in Baseline SGP Configuration Scripts and Combine
source("../SGP_CONFIG/2018_2019.2/BASELINE/Percentiles/ELA.R")
source("../SGP_CONFIG/2018_2019.2/BASELINE/Percentiles/MATHEMATICS.R")

PARCC_2018_2019_BASELINE_CONFIG <- c(
		ELA_2018_2019.2.config,
		MATHEMATICS_2018_2019.2.config,

		ALGEBRA_I_2018_2019.2.config,
		GEOMETRY_2018_2019.2.config,
		ALGEBRA_II_2018_2019.2.config
)

#####
###   Run BASELINE SGP analysis - create new PARCC_SGP object with historical data
#####

###   Temporarily set names of prior scores from sequential/cohort analyses
setnames(PARCC_SGP_LONG_Data,
	c("SCALE_SCORE_PRIOR", "SCALE_SCORE_PRIOR_STANDARDIZED"),
	c("SS_PRIOR_COHORT", "SS_PRIOR_STD_COHORT"))

PARCC_SGP <- abcSGP(
      sgp_object = PARCC_SGP_LONG_Data,
      steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
      sgp.config = PARCC_2018_2019_BASELINE_CONFIG,
      sgp.percentiles = FALSE,
      sgp.projections = FALSE,
      sgp.projections.lagged = FALSE,
      sgp.percentiles.baseline = TRUE,  #  Skip year SGPs for 2021 comparisons
      sgp.projections.baseline = FALSE, #  Calculated in next step
      sgp.projections.lagged.baseline = FALSE,
	    calculate.simex.baseline = TRUE,
			###   Use these four arguments for small sample test run.
			###   Delete/comment out and set calculate.simex = TRUE for full EOC run.
	      # calculate.simex.baseline = list(
				# 	lambda=seq(0,2,0.5), simulation.iterations=25, simex.sample.size=2000,
				# 	csem.data.vnames="SCALE_SCORE_CSEM", extrapolation="linear", save.matrices=FALSE,
				# 	simex.use.my.coefficient.matrices=TRUE, use.cohort.for.ranking=TRUE),
				# sgp.test.cohort.size = 2500,
				# return.sgp.test.results = "ALL_DATA",
				# goodness.of.fit.print=FALSE,
			###
			###
      save.intermediate.results = FALSE,
			outputSGP.output.type="LONG_Data",
			parallel.config = list(
				BACKEND = "PARALLEL",
				WORKERS=list(BASELINE_PERCENTILES=14)) # BASELINE_PERCENTILES requires MUCH more memory...
)

###   Re-set and rename prior scores (one set for sequential/cohort, another for skip-year/baseline)
setnames(PARCC_SGP@Data,
  c("SCALE_SCORE_PRIOR", "SCALE_SCORE_PRIOR_STANDARDIZED", "SS_PRIOR_COHORT", "SS_PRIOR_STD_COHORT"),
  c("SCALE_SCORE_PRIOR_BASELINE", "SCALE_SCORE_PRIOR_STANDARDIZED_BASELINE", "SCALE_SCORE_PRIOR", "SCALE_SCORE_PRIOR_STANDARDIZED"))

###   Quick checks
table(PARCC_SGP@Data[YEAR=="2018_2019.2" & is.na(SGP) & !is.na(SGP_BASELINE), SGP_NOTE], exclude=NULL)
tmp.tbl <- table(PARCC_SGP@Data[YEAR=="2018_2019.2" & is.na(SGP) & !is.na(SGP_BASELINE), as.character(SGP_NORM_GROUP_BASELINE)]) # Kids with skip year, but no seq
tmp.tbl[tmp.tbl > 1000] # check larger groups

table(PARCC_SGP@Data[YEAR=="2018_2019.2" & !is.na(SGP) & is.na(SGP_BASELINE), as.character(SGP_NORM_GROUP)]) #  single (2018.2 OR 2019.1) prior only

###   Save results
save(PARCC_SGP, file="Data/PARCC_SGP.Rdata")
