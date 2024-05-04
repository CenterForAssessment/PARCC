###############################################################################
###                                                                         ###
###            Illinois 2023 (Cohort and Baseline) SGP Analyses             ###
###                                                                         ###
###############################################################################

###   Load packages
require(SGP)
require(data.table)

###   Setup `SGPstateData` with baseline coefficient matrices
###   Add directly rather than using `SGPmatrices` due to SIMEX matrices size.
load("./Data/Archive/Illinois_Baseline_Matrices.Rdata")
SGPstateData[["IL"]][["Baseline_splineMatrix"]][["Coefficient_Matrices"]] <-
    Illinois_Baseline_Matrices

#####
###   Cohort and Baseline SGP Analyses
#####

###   Load required LONG data
load("./Data/Archive/2020_2021.2/Illinois_Data_LONG_2020_2021.2.Rdata")
load("./Data/Archive/2021_2022.2/Illinois_Data_LONG_2021_2022.2.Rdata")
load("./Data/Archive/2022_2023.2/Illinois_Data_LONG_2022_2023.2.Rdata")

Illinois_Data_LONG <-
    rbindlist(
        list(
            Illinois_Data_LONG_2020_2021.2,
            Illinois_Data_LONG_2021_2022.2,
            Illinois_Data_LONG_2022_2023.2
        ),
        fill = TRUE
    )

rm(list = c("Illinois_Data_LONG_2020_2021.2",
            "Illinois_Data_LONG_2021_2022.2",
            "Illinois_Data_LONG_2022_2023.2"))

###   Create analysis configurations

IL_Config_2023 <- c(
    list(
    ELA.2022_2023.2 = list(
        sgp.content.areas = rep("ELA", 3),
        sgp.panel.years = c("2020_2021.2", "2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(
            c("3", "4"), c("3", "4", "5"),
            c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8"))
    )),
    list(
    MATHEMATICS.2022_2023.2 = list(
        sgp.content.areas = rep("MATHEMATICS", 3),
        sgp.panel.years = c("2020_2021.2", "2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(
            c("3", "4"), c("3", "4", "5"),
            c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8")
         )
    ))
)


###   Run Cohort and Baseline Referenced Student Growth Percentiles

Illinois_SGP <-
    abcSGP(
        sgp_object = Illinois_Data_LONG,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
        sgp.config = IL_Config_2023,
        sgp.percentiles = TRUE,
        sgp.projections = TRUE,
        sgp.projections.lagged = TRUE,
        sgp.percentiles.baseline = TRUE,
        sgp.projections.baseline = TRUE,
        sgp.projections.lagged.baseline = TRUE,
        calculate.simex = TRUE,
        calculate.simex.baseline = list(
            lambda = seq(0, 2, 0.5), simulation.iterations = 75,
            simex.sample.size = 10000, csem.data.vnames = "SCALE_SCORE_CSEM",
            extrapolation = "linear", simex.use.my.coefficient.matrices = TRUE,
            save.matrices = FALSE, use.cohort.for.ranking = FALSE),
        save.intermediate.results = FALSE,
        outputSGP.directory = "Data/Archive/2022_2023.2",
        outputSGP.output.type = c("LONG_Data", "LONG_FINAL_YEAR_Data"),
        parallel.config = list(
            BACKEND = "PARALLEL",
            WORKERS = list(
                TAUS = 27, SIMEX = 25,
                PROJECTIONS = 10,
                LAGGED_PROJECTIONS = 10
            )
        )
    )

###   Save results

save(Illinois_SGP, file = "./Data/Archive/2022_2023.2/Illinois_SGP.Rdata")
