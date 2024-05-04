###############################################################################
###                                                                         ###
###          Washington_DC 2023 (Cohort and Baseline) SGP Analyses          ###
###                                                                         ###
###############################################################################

###   Load packages
require(SGP)
require(data.table)

###   Setup `SGPstateData` with baseline coefficient matrices
###   Add directly rather than using `SGPmatrices` due to SIMEX matrices size.
load("./Data/Archive/Washington_DC_Baseline_Matrices.Rdata")
SGPstateData[["DC"]][["Baseline_splineMatrix"]][["Coefficient_Matrices"]] <-
    Washington_DC_Baseline_Matrices
# SGPstateData[["DC"]][["SGP_Configuration"]][["max.order.for.percentile"]] <- 1L
# SGPstateData[["DC"]][["SGP_Configuration"]][["grade.projection.sequence"]][[
#     "ELA"
# ]] <-

SGPstateData[["DC"]][["SGP_Configuration"]][["grade.projection.sequence"]] <-
    list(
        ELA = c("3", "4", "5", "6", "7", "8", "9", "10"),
        MATHEMATICS = c("3", "4", "5", "6", "7", "8", "EOCT", "EOCT"),
        ALGEBRA_I   = c("3", "4", "5", "6", "7", "8", "EOCT", "EOCT"),
        GEOMETRY    = c("3", "4", "5", "6", "7", "8", "EOCT", "EOCT")
    )
SGPstateData[["DC"]][["SGP_Configuration"]][["content_area.projection.sequence"]] <-
    list(
        ELA = rep("ELA", 8),
        MATHEMATICS = c(rep("MATHEMATICS", 6), "ALGEBRA_I", "GEOMETRY"),
        ALGEBRA_I   = c(rep("MATHEMATICS", 6), "ALGEBRA_I", "GEOMETRY"),
        GEOMETRY    = c(rep("MATHEMATICS", 6), "ALGEBRA_I", "GEOMETRY")
    )
SGPstateData[["DC"]][["SGP_Configuration"]][["year_lags.projection.sequence"]] <-
    list(
        ELA = rep(1L, 7),
        MATHEMATICS = rep(1L, 7),
        ALGEBRA_I   = rep(1L, 7),
        GEOMETRY    = rep(1L, 7)
    )


#####
###   Cohort and Baseline SGP Analyses
#####

###   Load required LONG data
load("./Data/Archive/2021_2022.2/Washington_DC_Data_LONG_2021_2022.2.Rdata")
load("./Data/Archive/2022_2023.2/Washington_DC_Data_LONG_2022_2023.2.Rdata")

Washington_DC_Data_LONG <-
    rbindlist(
        list(
            Washington_DC_Data_LONG_2021_2022.2,
            Washington_DC_Data_LONG_2022_2023.2
        ),
        fill = TRUE
    )

Washington_DC_Data_LONG[,
    SGP_TARGET_BASELINE_3_YEAR := as.integer(NA)
]
##  Only invalidated pre-COVID (only relevant for baseline matrix construction)
# Washington_DC_Data_LONG[
#     YEAR == "2021_2022.2" & CONTENT_AREA == "ELA" & GRADE == "9",
#         VALID_CASE := "VALID_CASE"]
# TMP_Data_2022[StateAbbreviation == "DC" &
#                             TestCode == "ALG01" &
#                             GradeLevelWhenAssessed %in%
#                                 c("09", "10", "11", "12", "99"),
#                             VALID_CASE := "INVALID_CASE"] # X cases

rm(list = c("Washington_DC_Data_LONG_2021_2022.2",
            "Washington_DC_Data_LONG_2022_2023.2"))

###   Create analysis configurations

###   Read in configuration scripts and combine
source("../SGP_CONFIG/2022_2023.2/ELA_DC.R")
source("../SGP_CONFIG/2022_2023.2/MATHEMATICS_DC.R")

DC_Config_2023 <-
    c(ELA_2022_2023.2.config,
      MATHEMATICS_2022_2023.2.config,
      ALGEBRA_I.2022_2023.2.config,
      GEOMETRY.2022_2023.2.config
    )

DC_Baseline_Config_2023 <-
    c(ELA_Baseline_2022_2023.2.config, # Requires subset
      MATHEMATICS_2022_2023.2.config,
      ALGEBRA_I_Baseline.2022_2023.2.config, # Requires subset
      GEOMETRY.2022_2023.2.config
    )


###   Run Cohort Referenced Student Growth Percentiles
Washington_DC_SGP <-
    abcSGP(
        sgp_object = Washington_DC_Data_LONG,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP"), # no output
        sgp.config = DC_Config_2023,
        sgp.percentiles = TRUE,
        sgp.projections = TRUE,
        sgp.projections.lagged = TRUE,
        sgp.percentiles.baseline = FALSE,
        sgp.projections.baseline = FALSE,
        sgp.projections.lagged.baseline = FALSE,
        calculate.simex = TRUE,
        save.intermediate.results = FALSE,
        parallel.config = list(
            BACKEND = "PARALLEL",
            WORKERS = list(TAUS = 10, SIMEX = 12)
        )
    )

###   Run Baseline Referenced Student Growth Percentiles

# Washington_DC_SGP@SGP[["Coefficient_Matrices"]] <-
#     c(Washington_DC_SGP@SGP[["Coefficient_Matrices"]],
#       Washington_DC_Baseline_Matrices)

##    Modify `SGPstateData` for Baseline projections
SGPstateData[["DC"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ELA"]] <-
    c("3", "4", "5", "6", "7", "8", "9")
SGPstateData[["DC"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ELA"]] <-
    rep("ELA", 7)
SGPstateData[["DC"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ELA"]] <-
    rep(1L, 6)

##    Re-run `abcSGP` for baseline SGPs
Washington_DC_SGP <-
    abcSGP(
        sgp_object = Washington_DC_SGP,
        steps = c("analyzeSGP", "combineSGP", "outputSGP"), # no prepare
        sgp.config = DC_Baseline_Config_2023,
        sgp.percentiles = FALSE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = TRUE,
        sgp.projections.baseline = TRUE,
        sgp.projections.lagged.baseline = TRUE,
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
                TAUS = 12, SIMEX = 15,
                PROJECTIONS =  8, LAGGED_PROJECTIONS = 4
            )
        )
    )

###   Save results

save(Washington_DC_SGP, file = "./Data/Archive/2022_2023.2/Washington_DC_SGP.Rdata")
