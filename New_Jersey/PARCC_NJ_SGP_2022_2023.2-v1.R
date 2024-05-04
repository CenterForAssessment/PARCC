###############################################################################
###                                                                         ###
###            New_Jersey 2023 (Cohort and Baseline) SGP Analyses           ###
###                                                                         ###
###############################################################################

###   Load packages
require(SGP)
require(data.table)

###   Load required LONG data
# load("./Data/Archive/2021_2022.1/NJSS_Data_LONG_2021_2022.1.Rdata")
load("./Data/Archive/2021_2022.2/New_Jersey_SGP_LONG_Data_2021_2022.2.Rdata")
load("./Data/Archive/2022_2023.2/New_Jersey_Data_LONG_2022_2023.2.Rdata")

New_Jersey_Data_LONG <-
    rbindlist(
        list(
            # NJSS_Data_LONG_2021_2022.1[ # Priors only
            #     !CONTENT_AREA %in% "ALG_II_NJSS" &
            #     !GRADE %in% c("9", "10")
            # ],
            New_Jersey_SGP_LONG_Data_2021_2022.2[
                !CONTENT_AREA %in% c("ELA_GPA", "MATH_GPA") #&
                # !GRADE %in% c("9") # Priors only
            ],
            New_Jersey_Data_LONG_2022_2023.2
        ),
        fill = TRUE
    )

New_Jersey_Data_LONG[,
    SGP_TARGET_BASELINE_3_YEAR := as.integer(NA)
]

###   Knots and Boundaries for NJ Start Strong Data
# njss.kbs <-
#     createKnotsBoundaries(
#         NJSS_Data_LONG_2021_2022.1
#     )

rm(list =
  c(# "NJSS_Data_LONG_2021_2022.1",
    # "New_Jersey_Data_LONG_2021_2022.2",
    "New_Jersey_SGP_LONG_Data_2021_2022.2",
    "New_Jersey_Data_LONG_2022_2023.2")
)

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


# SGPstateData[["NJ"]][["Achievement"]][["Knots_Boundaries"]] <-
#     c(SGPstateData[["NJ"]][["Achievement"]][["Knots_Boundaries"]], njss.kbs)

# SGPstateData[["NJ"]][["Student_Report_Information"]][["Content_Areas_Domains"]] <-
#     list(ELA = "ELA", MATHEMATICS = "MATHEMATICS",
#         ELA_NJSS = "ELA", MATH_NJSS = "MATHEMATICS",
#         ALG_I_NJSS = "MATHEMATICS", GEOM_NJSS = "MATHEMATICS",
#         GEOMETRY = "MATHEMATICS", ALGEBRA_I = "MATHEMATICS",
#         ALGEBRA_II = "MATHEMATICS"
#     )

#####
###   Cohort-referenced SGP Analyses
#####

###   Create analysis configurations

###   Read in configuration scripts and combine
# source("../SGP_CONFIG/2022_2023.2/ELA_NJ.R")
# source("../SGP_CONFIG/2022_2023.2/MATHEMATICS_NJ.R")

# NJ_Config_2023 <-
#     c(ELA.2022_2023.2.config,
#       MATHEMATICS.2022_2023.2.config,
#       ALGEBRA_I.2022_2023.2.config,
#       GEOMETRY.2022_2023.2.config,
#       ALGEBRA_II.2022_2023.2.config
#     )


NJ_Baseline_Config_2023 <-
    c(ELA_Baseline.2022_2023.2.config,
      MATHEMATICS_Baseline.2022_2023.2.config,
      ALGEBRA_I_Baseline.2022_2023.2.config,
      GEOMETRY_Baseline.2022_2023.2.config,
      ALGEBRA_II_Baseline.2022_2023.2.config
    )


# ###   Run Cohort Referenced Student Growth PERCENTILES (ONLY)
# SGPstateData[["NJ"]][["SGP_Configuration"]][["grade.projection.sequence"]] ->
#     nj.proj.gps
# SGPstateData[["NJ"]][["SGP_Configuration"]][["content_area.projection.sequence"]] ->
#     nj.proj.caps
# SGPstateData[["NJ"]][["SGP_Configuration"]][["year_lags.projection.sequence"]] ->
#     nj.proj.ylps

# SGPstateData[["NJ"]][["SGP_Configuration"]][["grade.projection.sequence"]] <-
# SGPstateData[["NJ"]][["SGP_Configuration"]][["content_area.projection.sequence"]] <-
# SGPstateData[["NJ"]][["SGP_Configuration"]][["year_lags.projection.sequence"]] <-
#     NULL

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
        save.intermediate.results = FALSE,
        parallel.config = list(
            BACKEND = "PARALLEL",
            WORKERS = list(
                TAUS = 12, SIMEX = 15
            )
        )
    )


###   XXX   ###  Make Single order the "BEST" Manually (???)
###              These will be ones referenced in any targets

###   Run Cohort Referenced Student Growth PROJECTIONS (ONLY)

# SGPstateData[["NJ"]][["SGP_Configuration"]][["grade.projection.sequence"]] <-
#     nj.proj.gps
# SGPstateData[["NJ"]][["SGP_Configuration"]][["content_area.projection.sequence"]] <-
#     nj.proj.caps
# SGPstateData[["NJ"]][["SGP_Configuration"]][["year_lags.projection.sequence"]] <-
#     nj.proj.ylps


# New_Jersey_SGP <-
#     abcSGP(
#         sgp_object = New_Jersey_Data_LONG,
#         steps = c("prepareSGP", "analyzeSGP", "combineSGP"), # no output
#         sgp.config = NJ_Config_2023,
#         sgp.percentiles = FALSE,
#         sgp.projections = TRUE,
#         sgp.projections.lagged = TRUE,
#         sgp.percentiles.baseline = FALSE,
#         sgp.projections.baseline = FALSE,
#         sgp.projections.lagged.baseline = FALSE,
#         save.intermediate.results = FALSE,
#         parallel.config = list(
#             BACKEND = "PARALLEL",
#             WORKERS = list(
#                 PROJECTIONS =  8, LAGGED_PROJECTIONS = 4
#             )
#         )
#     )

#####
###   Baseline-referenced SGP Analyses
#####

###   Create analysis configurations

# NJ_Baseline_Config_2023 <-
#     c(ELA_Baseline.2022_2023.2.config,
#       MATHEMATICS_Baseline.2022_2023.2.config,
#       ALGEBRA_I_Baseline.2022_2023.2.config,
#       GEOMETRY_Baseline.2022_2023.2.config,
#       ALGEBRA_II_Baseline.2022_2023.2.config
#     )

# SGPstateData[["NJ"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ELA"]] <-
#     c("3", "4", "5", "6", "7", "8", "9")
# SGPstateData[["NJ"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ELA"]] <-
#     rep("ELA", 7)
# SGPstateData[["NJ"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ELA"]] <-
#     rep(1L, 6)

###   Run Baseline Referenced Student Growth Percentiles & Projections

# New_Jersey_SGP <-
#     abcSGP(
#         sgp_object = New_Jersey_SGP,
#         steps = c("analyzeSGP", "combineSGP", "outputSGP"), # no prepare
#         sgp.config = NJ_Baseline_Config_2023,
#         sgp.percentiles = FALSE,
#         sgp.projections = FALSE,
#         sgp.projections.lagged = FALSE,
#         sgp.percentiles.baseline = TRUE,
#         sgp.projections.baseline = TRUE,
#         sgp.projections.lagged.baseline = TRUE,
#         calculate.simex.baseline = list(
#             lambda = seq(0, 2, 0.5), simulation.iterations = 75,
#             simex.sample.size = 10000, csem.data.vnames = "SCALE_SCORE_CSEM",
#             extrapolation = "linear", simex.use.my.coefficient.matrices = TRUE,
#             save.matrices = FALSE, use.cohort.for.ranking = FALSE),
#         save.intermediate.results = FALSE,
#         outputSGP.directory = "Data/Archive/2022_2023.2",
#         outputSGP.output.type = c("LONG_Data", "LONG_FINAL_YEAR_Data"),
#         parallel.config = list(
#             BACKEND = "PARALLEL",
#             WORKERS = list(
#                 TAUS = 12, SIMEX = 15
#             )
#         )
#     )

###   Save results

save(New_Jersey_SGP, file = "./Data/Archive/2022_2023.2/New_Jersey_SGP.Rdata")

# outputSGP(New_Jersey_SGP,
#           outputSGP.directory = "Data/Archive/2022_2023.2",
#           output.type = "LONG_FINAL_YEAR_Data"
# )
