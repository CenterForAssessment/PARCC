################################################################################
###                                                                          ###
###             Illinois 2021 (Cohort and Baseline) SGP Analyses             ###
###                                                                          ###
################################################################################

###   Load packages
require(SGP)
require(data.table)

###   Load data from 2020 baseline SGP analyses
load("./Data/Archive/2019_2020.2/Illinois_SGP.Rdata")

###   Load cleaned 2021 LONG data
load("./Data/Archive/2020_2021.2/Illinois_Data_LONG_2020_2021.2.Rdata")

###   Load Cohort Referenced Matrices from 2021 (June 2021)
load("./Data/Illinois_Cohort_2021_Matrices.Rdata")
Illinois_SGP@SGP$Coefficient_Matrices <- Illinois_Baseline_2021_Matrices

###   Add single-cohort baseline matrices to SGPstateData
load("./Data/Illinois_Baseline_Matrices.Rdata")
SGPstateData[["IL"]][["Baseline_splineMatrix"]][["Coefficient_Matrices"]] <- Illinois_Baseline_Matrices

###   Read in BASELINE projections configuration scripts and combine
source("../SGP_CONFIG/2020_2021.2/PART_A/ELA.R")
source("../SGP_CONFIG/2020_2021.2/PART_A/MATHEMATICS.R")

IL_2021_CONFIG_PART_A <- c(
  ELA_2020_2021.2.config,
  MATHEMATICS_2020_2021.2.config
)

#####
###   Run Baseline Student Growth Percentiles (2021 Part A)
#####

Illinois_SGP <- updateSGP(
        what_sgp_object = Illinois_SGP,
        with_sgp_data_LONG = Illinois_Data_LONG_2020_2021.2,
        steps = c("prepareSGP", "analyzeSGP"),
        sgp.config = IL_2021_CONFIG_PART_A,
        sgp.percentiles = TRUE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = TRUE,
        sgp.projections.baseline = FALSE,
        sgp.projections.lagged.baseline = FALSE,
        sgp.use.my.coefficient.matrices = TRUE,  ###  Added Nov 2021 with added Fall testers and updated/matched IDs from Spring
        calculate.simex = TRUE,
        calculate.simex.baseline = list(
          lambda=seq(0,2,0.5), simulation.iterations=75, simex.sample.size=10000,
          csem.data.vnames="SCALE_SCORE_CSEM", extrapolation="linear", save.matrices=FALSE,
          simex.use.my.coefficient.matrices=TRUE, use.cohort.for.ranking=FALSE), # use baseline cohort for RANKING!
        save.intermediate.results = FALSE,
        parallel.config = list(
          BACKEND = "PARALLEL",
          WORKERS=list(SIMEX = 25)) # TAUS = 27,
)

###   Save results
save(Illinois_SGP, file="./Data/Archive/2020_2021.2/Illinois_SGP.Rdata")
