################################################################################
###                                                                          ###
###        PART B 2021: Straight SGP projections for PARCC Consortium        ###
###                                                                          ###
################################################################################

###   Set working directory to PARCC level (./PARCC/PARCC) directory

###   Load packages
require(SGP)

###   Load data
load("./Data/Archive/2020_2021.2/PARCC_SGP.Rdata")

###   Load analysis configurations
# rm(list=grep("config", ls(), value=TRUE))
source("../SGP_CONFIG/2020_2021.2/PART_B/ELA.R")
source("../SGP_CONFIG/2020_2021.2/PART_B/MATHEMATICS.R")

PARCC_2021_CONFIG_PART_B <- c(
  ELA_2020_2021.2.config,
  MATHEMATICS_2020_2021.2.config,

  ALGEBRA_I_2020_2021.2.config,
  GEOMETRY_2020_2021.2.config
)

###   Setup SGPstateData with baseline coefficient matrices grade specific projection sequences
##    Add Baseline matrices calculated in STEP 2A to SGPstateData
load("./Data/PARCC_Baseline_Matrices.Rdata")
SGPstateData[["PARCC"]][["Baseline_splineMatrix"]][["Coefficient_Matrices"]] <- PARCC_Baseline_Matrices

##    Establish required meta-data for Straight projection sequences
source("../SGP_CONFIG/2020_2021.2/PART_B/PARCC_Straight_Projections_MetaData.R")

#####
###   Run analysis - abcSGP on PARCC_SGP object from Part A
#####

##    Need to add BASELINE straight target variables first:
PARCC_SGP@Data$SGP_TARGET_BASELINE_3_YEAR <- as.integer(NA)
PARCC_SGP@Data$SGP_TARGET_BASELINE_3_YEAR_CURRENT <- as.integer(NA)

PARCC_SGP <- abcSGP(
        PARCC_SGP,
        years = "2020_2021.2", # STILL need to add years now (after adding 2019 baseline projections). Why?
        steps=c("prepareSGP", "analyzeSGP", "combineSGP"),
        sgp.config=PARCC_2021_CONFIG_PART_B,
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
# table(PARCC_SGP@SGP$SGProjections$ELA.2020_2021.2.BASELINE[, GRADE, nchar(SGP_PROJECTION_GROUP_SCALE_SCORES)])
# table(PARCC_SGP@SGP$SGProjections$ELA.2020_2021.2.BASELINE[grepl("[;]", SGP_PROJECTION_GROUP_SCALE_SCORES), nchar(SGP_PROJECTION_GROUP_SCALE_SCORES)])
# head(PARCC_SGP@SGP$SGProjections$ELA.2020_2021.2.BASELINE[nchar(SGP_PROJECTION_GROUP_SCALE_SCORES)>13, SGP_PROJECTION_GROUP_SCALE_SCORES], 50)

###  Save results
save(PARCC_SGP, file="Data/Archive/2020_2021.2/PARCC_SGP.Rdata")
