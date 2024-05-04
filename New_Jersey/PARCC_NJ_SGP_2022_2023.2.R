###############################################################################
###                                                                         ###
###            New_Jersey 2023 (Cohort and Baseline) SGP Analyses           ###
###                                                                         ###
###############################################################################

###   Load packages
require(SGP)
require(data.table)

###   Load required LONG data
load("./Data/Archive/2021_2022.2/New_Jersey_SGP_LONG_Data_2021_2022.2.Rdata")
load("./Data/Archive/2022_2023.2/New_Jersey_Data_LONG_2022_2023.2.Rdata")

New_Jersey_Data_LONG <-
    rbindlist(
        list(
            New_Jersey_SGP_LONG_Data_2021_2022.2[
                !CONTENT_AREA %in% c("ELA_GPA", "MATH_GPA")
            ],
            New_Jersey_Data_LONG_2022_2023.2
        ),
        fill = TRUE
    )

New_Jersey_Data_LONG[,
    SGP_TARGET_BASELINE_3_YEAR := as.integer(NA)
]

###   Setup `SGPstateData` with baseline coefficient matrices
###   Add directly rather than using `SGPmatrices` due to SIMEX matrices size.
load("./Data/Archive/New_Jersey_Baseline_Matrices.Rdata")
SGPstateData[["NJ"]][["Baseline_splineMatrix"]][["Coefficient_Matrices"]] <-
    New_Jersey_Baseline_Matrices

SGPstateData[["NJ"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ELA"]] <-
    c("3", "4", "5", "6", "7", "8", "9")
SGPstateData[["NJ"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ELA"]] <-
    rep("ELA", 7)
SGPstateData[["NJ"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ELA"]] <-
    rep(1L, 6)


rm(list =
  c("New_Jersey_Baseline_Matrices",
    "New_Jersey_SGP_LONG_Data_2021_2022.2",
    "New_Jersey_Data_LONG_2022_2023.2")
); gc()

#####
###   Cohort- and Baseline-referenced SGP Analyses
#####

###   Create analysis configurations
NJ_Baseline_Config_2023 <-
    c(ELA_Baseline.2022_2023.2.config,
      MATHEMATICS_Baseline.2022_2023.2.config,
      ALGEBRA_I_Baseline.2022_2023.2.config,
      GEOMETRY_Baseline.2022_2023.2.config,
      ALGEBRA_II_Baseline.2022_2023.2.config
    )

###   Calculate All Student Growth Percentiles and Projections
New_Jersey_SGP <-
    abcSGP(
        sgp_object = New_Jersey_Data_LONG,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
        sgp.config = NJ_Baseline_Config_2023, # - single prior only in 2023
        sgp.percentiles = TRUE,
        sgp.projections = TRUE,
        sgp.projections.lagged = TRUE,
        sgp.percentiles.baseline = TRUE,
        sgp.projections.baseline = TRUE,
        sgp.projections.lagged.baseline = TRUE,
        calculate.simex = TRUE, # No CSEM for NJ Start Strong, so single prior
        calculate.simex.baseline = list(
            lambda = seq(0, 2, 0.5), simulation.iterations = 75,
            simex.sample.size = 10000, csem.data.vnames = "SCALE_SCORE_CSEM",
            extrapolation = "linear", simex.use.my.coefficient.matrices = TRUE,
            save.matrices = FALSE, use.cohort.for.ranking = FALSE
        ),
        outputSGP.directory = "Data/Archive/2022_2023.2",
        outputSGP.output.type = c("LONG_Data", "LONG_FINAL_YEAR_Data"),
        save.intermediate.results = FALSE,
        parallel.config = list(
            BACKEND = "PARALLEL",
            WORKERS = list(
                TAUS = 12, SIMEX = 15
            )
        )
    )

###   Save results

save(New_Jersey_SGP, file = "./Data/Archive/2022_2023.2/New_Jersey_SGP.Rdata")
