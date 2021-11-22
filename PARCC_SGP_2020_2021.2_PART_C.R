################################################################################
###                                                                          ###
###   PART C 2021: Lagged (skip-year) SGP projections for PARCC Consortium   ###
###                                                                          ###
################################################################################

###   Set working directory to PARCC level (./PARCC/PARCC) directory

###   Load packages
require(SGP)

###   Load data
load("./Data/Archive/2020_2021.2/PARCC_SGP.Rdata")

###   Load analysis configurations
source("../SGP_CONFIG/2020_2021.2/PART_C/ELA.R")
source("../SGP_CONFIG/2020_2021.2/PART_C/MATHEMATICS.R")

PARCC_2021_CONFIG_PART_C <- c(
  ELA_2020_2021.2.config,
  MATHEMATICS_2020_2021.2.config,
  ALGEBRA_I_2020_2021.2.config,
  GEOMETRY_2020_2021.2.config,
  ALGEBRA_II_2020_2021.2.config
)

###   Setup SGPstateData with baseline coefficient matrices grade specific projection sequences
##    Add Baseline matrices calculated in STEP 2A to SGPstateData
load("./Data/PARCC_Baseline_Matrices.Rdata")
SGPstateData[["PARCC"]][["Baseline_splineMatrix"]][["Coefficient_Matrices"]] <- PARCC_Baseline_Matrices

##    Establish required meta-data for LAGGED projection sequences
source("../SGP_CONFIG/2020_2021.2/PART_C/PARCC_Lagged_Projections_MetaData.R")

#####
###   Run analysis - abcSGP on PARCC_SGP object from Parts A & B
#####

PARCC_SGP <- abcSGP(
        PARCC_SGP,
        steps=c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
        sgp.config=PARCC_2021_CONFIG_PART_C,
        sgp.percentiles=FALSE,
        sgp.projections=FALSE,
        sgp.projections.lagged=FALSE,
        sgp.percentiles.baseline=FALSE,
        sgp.projections.baseline=FALSE,
        sgp.projections.lagged.baseline=TRUE,
        sgp.target.scale.scores=TRUE,
        outputSGP.directory="Data/Archive/2020_2021.2",
        outputSGP.output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data"),
        parallel.config = list(
					BACKEND = "PARALLEL",
          WORKERS=list(LAGGED_PROJECTIONS = 12, SGP_SCALE_SCORE_TARGETS = 12))
)

# table(PARCC_SGP@Data[YEAR=='2020_2021.2', is.na(SGP_BASELINE), TestCode])

###   Re-run combineSGP (and output) for everything.  Not sure why everything didn't merge...
PARCC_SGP <- combineSGP(PARCC_SGP)
table(PARCC_SGP@Data[YEAR=='2020_2021.2', is.na(SGP_BASELINE), TestCode])

outputSGP(PARCC_SGP,
  outputSGP.directory="Data/Archive/2020_2021.2",
  output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data"))

###  Save results
save(PARCC_SGP, file="Data/Archive/2020_2021.2/PARCC_SGP.Rdata")
