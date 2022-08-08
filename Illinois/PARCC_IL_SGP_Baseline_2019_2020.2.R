################################################################################
###                                                                          ###
###    Illinois 2020 Baseline Growth Percentiles and Projections Analyses    ###
###                                                                          ###
################################################################################

###   Load packages
require(SGP)
require(data.table)

###   Load data from 2019 baseline SGP analyses
load("./Data/Archive/2018_2019.2/BASELINE/Illinois_SGP.Rdata")
Illinois_SGP@Data <- Illinois_SGP@Data[YEAR > "2016_2017.2" & GRADE %in% 3:8]

###   Load 2020 Data available from Illinois before schools closed down...
load("./Data/Archive/2019_2020.2/Illinois_Data_LONG_2019_2020.2.Rdata")

###   Add single-cohort baseline matrices to SGPstateData
load("./Data/Illinois_Baseline_Matrices.Rdata")
SGPstateData[["IL"]][["Baseline_splineMatrix"]][["Coefficient_Matrices"]] <- Illinois_Baseline_Matrices

###   Read in BASELINE projections configuration scripts and combine
source("../SGP_CONFIG/2019_2020.2/ELA.R")
source("../SGP_CONFIG/2019_2020.2/MATHEMATICS.R")

Illinois_2019_2020_CONFIG <- c(
  ELA_2019_2020.2.config,
  MATHEMATICS_2019_2020.2.config
)

#####
###   Run projections analysis
#####

###   Baseline Percentiles (Step B)

Illinois_SGP <- updateSGP(
        what_sgp_object = Illinois_SGP,
        with_sgp_data_LONG = Illinois_Data_LONG_2019_2020.2,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
        sgp.config = Illinois_2019_2020_CONFIG,
        sgp.percentiles = FALSE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = TRUE,
        sgp.projections.baseline = FALSE,
        sgp.projections.lagged.baseline = FALSE,
        calculate.simex.baseline = TRUE,
        save.intermediate.results = FALSE,
        outputSGP.output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data"),
        outputSGP.directory="Illinois/Data/Archive/2019_2020.2",
        parallel.config = list(
          BACKEND = "PARALLEL",
          WORKERS=list(BASELINE_PERCENTILES=8))
)


###   Baseline Projections (Step C)
###   (in case need P50_PROJ_YEAR_1_CURRENT for Ho's Fair Trend/Equity Check metrics)

SGPstateData[["IL"]][["SGP_Configuration"]][['sgp.projections.max.forward.progression.years']] <- 1
SGPstateData[["IL"]][['SGP_Configuration']][['max.sgp.target.years.forward']] <- 1

Illinois_SGP <- abcSGP(
        sgp_object = Illinois_SGP,
        steps = c("prepareSGP", "analyzeSGP"),
        sgp.config = Illinois_2019_2020_CONFIG,
        sgp.percentiles = FALSE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = FALSE,
        sgp.projections.baseline = TRUE,
        sgp.projections.lagged.baseline = FALSE,
        save.intermediate.results = FALSE,
        parallel.config = list(
          BACKEND = "PARALLEL",
          WORKERS=list(PROJECTIONS=8))
)

###   Save results
save(Illinois_SGP, file="./Data/Archive/2019_2020.2/Illinois_SGP.Rdata")
