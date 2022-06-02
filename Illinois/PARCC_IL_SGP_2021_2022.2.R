###############################################################################
###                                                                         ###
###            Illinois 2022 (Cohort and Baseline) SGP Analyses             ###
###                                                                         ###
###############################################################################

###   Load packages
require(SGP)
require(data.table)

###   Load data from 2021 SGP analyses
load("./Data/Archive/2020_2021.2/Illinois_SGP_LONG_Data.Rdata")
Illinois_SGP_LONG_Data <- Illinois_SGP_LONG_Data[YEAR != "2017_2018.2",]

###   Load cleaned 2022 LONG data
load("./Data/Archive/2021_2022.2/Illinois_Data_LONG_2021_2022.2.Rdata")

###   Add single-cohort baseline matrices to SGPstateData
load("./Data/Archive/Illinois_Baseline_Matrices.Rdata")
SGPstateData[["IL"]][["Baseline_splineMatrix"]][["Coefficient_Matrices"]] <-
    Illinois_Baseline_Matrices

###   Read in configuration scripts and combine
source("../SGP_CONFIG/2021_2022.2/ELA.R")
source("../SGP_CONFIG/2021_2022.2/MATHEMATICS.R")

IL_2022_CONFIG <- c(
    ELA_2021_2022.2.config,
    MATHEMATICS_2021_2022.2.config
)

#####
###   Run Cohort and Baseline Referenced Student Growth Percentiles
#####

Illinois_SGP <- abcSGP(
    state = "IL",
    sgp_object = rbindlist(list(
        Illinois_SGP_LONG_Data,
        Illinois_Data_LONG_2021_2022.2), fill = TRUE),
    steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
    sgp.config = IL_2022_CONFIG,
    sgp.percentiles = TRUE,
    sgp.projections = TRUE,
    sgp.projections.lagged = TRUE,
    sgp.percentiles.baseline = TRUE,
    sgp.projections.baseline = TRUE,
    sgp.projections.lagged.baseline = TRUE,
    # calculate.simex = list(lambda = seq(0, 2, 0.5),
    #     simulation.iterations = 10, extrapolation = "linear",
    #     csem.data.vnames = "SCALE_SCORE_CSEM", save.matrices = FALSE),
    calculate.simex = TRUE,
    calculate.simex.baseline = list(
        lambda = seq(0, 2, 0.5), simulation.iterations = 75,
        simex.sample.size = 10000, csem.data.vnames = "SCALE_SCORE_CSEM",
        extrapolation = "linear", simex.use.my.coefficient.matrices = TRUE,
        save.matrices = FALSE, use.cohort.for.ranking = FALSE),
    # sgp.test.cohort.size = 5000,
    save.intermediate.results = FALSE,
    outputSGP.directory="Data/Archive/2021_2022.2",
    outputSGP.output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data"),
    parallel.config = list(
        BACKEND = "PARALLEL",
        WORKERS = list(TAUS = 16, SIMEX = 15))
)

###   Save results
save(Illinois_SGP, file = "./Data/Archive/2021_2022.2/Illinois_SGP.Rdata")
