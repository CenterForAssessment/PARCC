################################################################################
###                                                                          ###
###     PART B 2021: Straight SGP projections for Illinois SGP analyses      ###
###                                                                          ###
################################################################################

###   Set working directory to Illinois level (./PARCC/Illinois) directory

###   Load packages
require(SGP)

###   Load data
load("./Data/Archive/2020_2021.2/Illinois_SGP.Rdata")

###   Load analysis configurations
source("../SGP_CONFIG/2020_2021.2/PART_B/ELA_IL.R")
source("../SGP_CONFIG/2020_2021.2/PART_B/MATHEMATICS_IL.R")

IL_2021_CONFIG_PART_B <- c(
  ELA_2020_2021.2.config,
  MATHEMATICS_2020_2021.2.config

  # ALGEBRA_I_2020_2021.2.config,
  # GEOMETRY_2020_2021.2.config
)

###   Setup SGPstateData with baseline coefficient matrices grade specific projection sequences
##    Add Baseline matrices calculated in STEP 2A to SGPstateData
load("./Data/Illinois_Baseline_Matrices.Rdata")
SGPstateData[["IL"]][["Baseline_splineMatrix"]][["Coefficient_Matrices"]] <- Illinois_Baseline_Matrices

##    Establish required meta-data for Straight projection sequences
source("../SGP_CONFIG/2020_2021.2/PART_B/PARCC_Straight_Projections_MetaData.R")

#####
###   Run analysis - abcSGP on Illinois_SGP object from Part A
#####

##    Need to add BASELINE straight target variables first:
Illinois_SGP@Data$SGP_TARGET_BASELINE_3_YEAR <- as.integer(NA)
Illinois_SGP@Data$SGP_TARGET_BASELINE_3_YEAR_CURRENT <- as.integer(NA)

Illinois_SGP <- abcSGP(
        Illinois_SGP,
        years = "2020_2021.2", # STILL need to add years now (after adding 2019 baseline projections). Why?
        steps=c("prepareSGP", "analyzeSGP", "combineSGP"),
        sgp.config=IL_2021_CONFIG_PART_B,
        sgp.percentiles=FALSE,
        sgp.projections=FALSE,
        sgp.projections.lagged=FALSE,
        sgp.percentiles.baseline=FALSE,
        sgp.projections.baseline=TRUE,
        sgp.projections.lagged.baseline=FALSE,
        sgp.target.scale.scores=TRUE,
        parallel.config = list(
					BACKEND = "PARALLEL",
          WORKERS=10) # list(PROJECTIONS = 10, SGP_SCALE_SCORE_TARGETS = 10))
)

###   Students (87k) with 2020 priors DON'T use those priors in projection calcs
# table(Illinois_SGP@SGP$SGProjections$ELA.2020_2021.2.BASELINE[, GRADE, nchar(SGP_PROJECTION_GROUP_SCALE_SCORES)])
# table(Illinois_SGP@SGP$SGProjections$ELA.2020_2021.2.BASELINE[grepl("[;]", SGP_PROJECTION_GROUP_SCALE_SCORES), nchar(SGP_PROJECTION_GROUP_SCALE_SCORES)])
# head(Illinois_SGP@SGP$SGProjections$ELA.2020_2021.2.BASELINE[nchar(SGP_PROJECTION_GROUP_SCALE_SCORES)>13, SGP_PROJECTION_GROUP_SCALE_SCORES], 50)

###  Save results
save(Illinois_SGP, file="Data/Archive/2020_2021.2/Illinois_SGP.Rdata")
