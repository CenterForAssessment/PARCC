################################################################################
###                                                                          ###
###  PART C 2021: Lagged (skip-year) SGP projections for Illinois analyses   ###
###                                                                          ###
################################################################################

###   Set working directory to Illinois level (./PARCC/Illinois) directory

###   Load packages
require(SGP)

###   Load data
load("./Data/Archive/2020_2021.2/Illinois_SGP.Rdata")

###   Load analysis configurations
source("../SGP_CONFIG/2020_2021.2/PART_C/ELA.R")
source("../SGP_CONFIG/2020_2021.2/PART_C/MATHEMATICS.R")

IL_2021_CONFIG_PART_C <- c(
  ELA_2020_2021.2.config,
  MATHEMATICS_2020_2021.2.config
  # ALGEBRA_I_2020_2021.2.config,
  # GEOMETRY_2020_2021.2.config
)

###   Setup SGPstateData with baseline coefficient matrices grade specific projection sequences
##    Add Baseline matrices calculated in STEP 2A to SGPstateData
load("./Data/Illinois_Baseline_Matrices.Rdata")
SGPstateData[["IL"]][["Baseline_splineMatrix"]][["Coefficient_Matrices"]] <- Illinois_Baseline_Matrices

##    Establish required meta-data for LAGGED projection sequences
source("../SGP_CONFIG/2020_2021.2/PART_C/PARCC_Lagged_Projections_MetaData.R")

#####
###   Run analysis - abcSGP on Illinois_SGP object from Parts A & B
#####

Illinois_SGP <- abcSGP(
        Illinois_SGP,
        steps=c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
        sgp.config=IL_2021_CONFIG_PART_C,
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

###   Re-run combineSGP (and output) for everything.  Not sure why everything didn't merge...
Illinois_SGP <- combineSGP(Illinois_SGP)
table(Illinois_SGP@Data[YEAR=='2020_2021.2', is.na(SGP_BASELINE), TestCode])

outputSGP(Illinois_SGP,
  outputSGP.directory="Data/Archive/2020_2021.2",
  output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data"))

###  Save results
save(Illinois_SGP, file="Data/Archive/2020_2021.2/Illinois_SGP.Rdata")
