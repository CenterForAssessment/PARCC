################################################################################
###                                                                          ###
###  Bureau of Indian Education Learning Loss Analyses - 2019 Baseline Pctls ###
###                                                                          ###
################################################################################

###   Load packages
require(SGP)
require(data.table)

###   Load data and remove some old vars.
load("Data/Archive/2018_2019.2/Bureau_Indian_Affairs_SGP_LONG_Data.Rdata")

Bureau_Indian_Affairs_SGP_LONG_Data <- Bureau_Indian_Affairs_SGP_LONG_Data[is.na(EXACT_DUPLICATE) | EXACT_DUPLICATE == 1]
Bureau_Indian_Affairs_SGP_LONG_Data[, EXACT_DUPLICATE := NULL]

###   Create a smaller subset of the LONG data to work with.
###   Only states in consortium 2021 and (?) beyond.
parcc.years <- c("2016_2017.2", "2017_2018.2", "2018_2019.2")
parcc.subjects <- c("ELA", "MATHEMATICS", "ALGEBRA_I", "GEOMETRY", "ALGEBRA_II")

Bureau_of_Indian_Education_SGP_LONG_Data <- Bureau_Indian_Affairs_SGP_LONG_Data[
			CONTENT_AREA %in% parcc.subjects & YEAR %in% parcc.years,]

###   Add single-cohort baseline matrices to SGPstateData
load("Data/Bureau_of_Indian_Education_Baseline_Matrices.Rdata")
SGPstateData[["BI"]][["Baseline_splineMatrix"]][["Coefficient_Matrices"]] <- Bureau_of_Indian_Education_Baseline_Matrices
SGPstateData[["BI"]][["SGP_Configuration"]][["sgp.cohort.size"]] <- NULL

###   Read in Baseline SGP Configuration Scripts and Combine
source("../SGP_CONFIG/2018_2019.2/BASELINE/Percentiles/ELA.R")
source("../SGP_CONFIG/2018_2019.2/BASELINE/Percentiles/MATHEMATICS.R")

BIE_2018_2019_BASELINE_CONFIG <- c(
		ELA_2018_2019.2.config,
		MATHEMATICS_2018_2019.2.config
)

#####
###   Run BASELINE SGP analysis - create new Bureau_of_Indian_Education_SGP object with historical data
#####

###   Temporarily set names of prior scores from sequential/cohort analyses
setnames(Bureau_of_Indian_Education_SGP_LONG_Data,
	c("SCALE_SCORE_PRIOR", "SCALE_SCORE_PRIOR_STANDARDIZED"),
	c("SS_PRIOR_COHORT", "SS_PRIOR_STD_COHORT"))

Bureau_of_Indian_Education_SGP <- abcSGP(
      sgp_object = Bureau_of_Indian_Education_SGP_LONG_Data,
      steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
      sgp.config = BIE_2018_2019_BASELINE_CONFIG,
      sgp.percentiles = FALSE,
      sgp.projections = FALSE,
      sgp.projections.lagged = FALSE,
      sgp.percentiles.baseline = TRUE,  #  Skip year SGPs for 2021 comparisons
      sgp.projections.baseline = FALSE, #  Calculated in next step
      sgp.projections.lagged.baseline = FALSE,
	    calculate.simex.baseline = TRUE,
      save.intermediate.results = FALSE,
			outputSGP.output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data"),
			parallel.config = list(
				BACKEND = "PARALLEL",
				WORKERS=list(SIMEX=15)) # BASELINE_PERCENTILES requires MUCH more memory...
)

###   Re-set and rename prior scores (one set for sequential/cohort, another for skip-year/baseline)
setnames(Bureau_of_Indian_Education_SGP@Data,
  c("SCALE_SCORE_PRIOR", "SCALE_SCORE_PRIOR_STANDARDIZED", "SS_PRIOR_COHORT", "SS_PRIOR_STD_COHORT"),
  c("SCALE_SCORE_PRIOR_BASELINE", "SCALE_SCORE_PRIOR_STANDARDIZED_BASELINE", "SCALE_SCORE_PRIOR", "SCALE_SCORE_PRIOR_STANDARDIZED"))

###   Quick checks
table(Bureau_of_Indian_Education_SGP@Data[YEAR=="2018_2019.2" & is.na(SGP) & !is.na(SGP_BASELINE), SGP_NOTE], exclude=NULL)
tmp.tbl <- table(Bureau_of_Indian_Education_SGP@Data[YEAR=="2018_2019.2" & is.na(SGP) & !is.na(SGP_BASELINE), as.character(SGP_NORM_GROUP_BASELINE)])  #  small cohort N (<1000)
tmp.tbl[tmp.tbl > 100] # check larger groups
summary(Bureau_of_Indian_Education_SGP@Data[YEAR=="2018_2019.2" & is.na(SGP) & !is.na(SGP_BASELINE), SCALE_SCORE_PRIOR]) # all students with no 2018 score

table(Bureau_of_Indian_Education_SGP@Data[YEAR=="2018_2019.2" & !is.na(SGP) & is.na(SGP_BASELINE), as.character(SGP_NORM_GROUP)]) #  single (2018.2 OR 2019.1) prior only

###   Save results
save(Bureau_of_Indian_Education_SGP, file="Data/Bureau_of_Indian_Education_SGP.Rdata")
