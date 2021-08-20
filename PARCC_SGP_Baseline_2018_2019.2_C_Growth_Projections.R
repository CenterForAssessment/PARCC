################################################################################
###                                                                          ###
###     PARCC Learning Loss Analyses -- 2019 Baseline Growth Projections     ###
###                                                                          ###
################################################################################

###   Load packages
require(SGP)

###   Load data from baseline SGP analyses
load("Data/PARCC_SGP.Rdata")

###   Add single-cohort baseline matrices to SGPstateData
load("Data/PARCC_Baseline_Matrices.Rdata")
SGPstateData[["PARCC"]][["Baseline_splineMatrix"]][["Coefficient_Matrices"]] <- PARCC_Baseline_Matrices

###   Read in BASELINE projections configuration scripts and combine
source("../SGP_CONFIG/2018_2019.2/BASELINE/Projections/ELA.R")
source("../SGP_CONFIG/2018_2019.2/BASELINE/Projections/MATHEMATICS.R")

PARCC_2018_2019_BASELINE_PROJECTIONS_CONFIG <- c(
	ELA_2018_2019.2.config,
	MATHEMATICS_2018_2019.2.config,
	ALGEBRA_I_2018_2019.2.config
)

#####
###   Run projections analysis - run abcSGP on object from BASELINE SGP analysis
#####

###   Update SGPstateData with grade/course/lag progression information
source("../SGP_CONFIG/2018_2019.2/BASELINE/Projections/Skip_Year_Projections_MetaData.R")

PARCC_SGP <- abcSGP(
        sgp_object = PARCC_SGP,
        steps = c("prepareSGP", "analyzeSGP"), # no changes to @Data - don't combine or output
        sgp.config = PARCC_2018_2019_BASELINE_PROJECTIONS_CONFIG,
        sgp.percentiles = FALSE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = FALSE,
        sgp.projections.baseline = TRUE, # Need P50_PROJ_YEAR_1_CURRENT for Ho's Fair Trend/Equity Check metrics
        sgp.projections.lagged.baseline = FALSE,
        save.intermediate.results = FALSE,
        parallel.config = list(
					BACKEND = "PARALLEL",
          WORKERS=list(PROJECTIONS=15))
)

###   Save results
save(PARCC_SGP, file="Data/Archive/2018_2019.2/BASELINE/PARCC_SGP.Rdata")
