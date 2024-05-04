###############################################################################
###                                                                         ###
###      Department of Defense 2023 (Cohort and Baseline) SGP Analyses      ###
###                                                                         ###
###############################################################################

###   Load packages
require(SGP)
require(data.table)

###   Load data from previous SGP analyses
load("./Data/Archive/2020_2021.2/Department_of_Defense_SGP_LONG_Data_2020_2021.2.Rdata")
load("./Data/Archive/2021_2022.2/Department_of_Defense_SGP_LONG_Data_2021_2022.2.Rdata")
load("./Data/Archive/2022_2023.2/Department_of_Defense_Data_LONG_2022_2023.2.Rdata")

Department_of_Defense_Data_LONG <-
    rbindlist(
        list(
            Department_of_Defense_SGP_LONG_Data_2020_2021.2,
            Department_of_Defense_SGP_LONG_Data_2021_2022.2,
            Department_of_Defense_Data_LONG_2022_2023.2
        ),
        fill = TRUE
    )

Department_of_Defense_Data_LONG[,
    SGP_TARGET_BASELINE_3_YEAR := as.integer(NA)
]

###   Modify `SGPstateData`
##    Add baseline coefficient matrices directly rather than using `SGPmatrices`
##    due to SIMEX matrices size.
load("./Data/Archive/Department_of_Defense_Baseline_Matrices.Rdata")
SGPstateData[["DD"]][["Baseline_splineMatrix"]][["Coefficient_Matrices"]] <-
    Department_of_Defense_Baseline_Matrices

##    Remove "Percentile Cuts" from data - not used or returned to Pearson
percentile.cuts <-
    grep("PERCENTILE_CUT_", names(Department_of_Defense_Data_LONG), value = TRUE)
Department_of_Defense_Data_LONG[, (percentile.cuts) := NULL]

SGPstateData[["DD"]][["Growth"]][["Cutscores"]] <-
    SGPstateData[["DD"]][["Growth"]][["Levels"]] <- NULL

##    Add knots and boundaries for previously untested grade/subjects
ela.kbs <-
    SGPstateData[["PARCC"]][["Achievement"]][["Knots_Boundaries"]][["ELA"]]
math.kbs <-
    SGPstateData[["PARCC"]][["Achievement"]][["Knots_Boundaries"]][["MATHEMATICS"]]

SGPstateData[["DD"]][["Achievement"]][["Knots_Boundaries"]][["ELA"]] <-
    c(SGPstateData[["DD"]][["Achievement"]][["Knots_Boundaries"]][["ELA"]],
      ela.kbs[
        names(ela.kbs)[!names(ela.kbs) %in%
        names(SGPstateData[["DD"]][["Achievement"]][["Knots_Boundaries"]][["ELA"]])]
      ]
    )

SGPstateData[["DD"]][["Achievement"]][["Knots_Boundaries"]][["MATHEMATICS"]] <-
    c(SGPstateData[["DD"]][["Achievement"]][["Knots_Boundaries"]][["MATHEMATICS"]],
      math.kbs[
        names(math.kbs)[!names(math.kbs) %in%
        names(SGPstateData[["DD"]][["Achievement"]][["Knots_Boundaries"]][["MATHEMATICS"]])]
      ]
    )

##    Modify projections sequences (for cohort-referenced analyses only)
#     No 9th Grade ELA (2021 - 2023)
SGPstateData[["DD"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ELA"]] <-
    c("3", "4", "5", "6", "7", "8", "10")
SGPstateData[["DD"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ELA"]] <-
    rep("ELA", 7)
SGPstateData[["DD"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ELA"]] <-
    c(rep(1L, 5), 2L)

#     7th Grade math only in 2023 (so no 7 -> 8 progression)
SGPstateData[["DD"]][["SGP_Configuration"]][["grade.projection.sequence"]][["MATHEMATICS"]] <-
    c("3", "4", "5", "6", "7")
SGPstateData[["DD"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["MATHEMATICS"]] <-
    rep("MATHEMATICS", 5)
SGPstateData[["DD"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["MATHEMATICS"]] <-
    rep(1L, 4)

SGPstateData[["DD"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ALGEBRA_I"]] <-
SGPstateData[["DD"]][["SGP_Configuration"]][["grade.projection.sequence"]][["GEOMETRY"]] <-
SGPstateData[["DD"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ALGEBRA_II"]] <-
    c("6", "8", "EOCT", "EOCT", "EOCT") # Try to catch SKIP year (6 -> 8) for 2023 ONLY

SGPstateData[["DD"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ALGEBRA_I"]] <-
SGPstateData[["DD"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["GEOMETRY"]] <-
SGPstateData[["DD"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ALGEBRA_II"]] <-
    c("MATHEMATICS", "MATHEMATICS", "ALGEBRA_I", "GEOMETRY", "ALGEBRA_II")

SGPstateData[["DD"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ALGEBRA_I"]] <-
SGPstateData[["DD"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["GEOMETRY"]] <-
SGPstateData[["DD"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ALGEBRA_II"]] <-
    c(2L, rep(1L, 3))


###   Read in SGP configuration scripts and combine
source("../SGP_CONFIG/2022_2023.2/MATHEMATICS.R") # for EOCT Maths only

ELA.2023.config <- list(
    ELA.2023 = list(
        sgp.content.areas = rep("ELA", 3),
        sgp.panel.years = c("2020_2021.2", "2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(
            c("3", "4"), c("3", "4", "5"),
            c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8")
        ),
        sgp.norm.group.preference = 0L
    ),
    ELA_SKIP.2023 = list(
        sgp.content.areas = rep("ELA", 2),
        sgp.panel.years = c("2020_2021.2", "2022_2023.2"),
        sgp.grade.sequences = list(c("8", "10")),
        sgp.norm.group.preference = 1L
    )
)

MATHEMATICS.2023.config <- list(
    MATHEMATICS.2023 = list(
        sgp.content.areas = rep("MATHEMATICS", 3),
        sgp.panel.years = c("2020_2021.2", "2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(
            c("3", "4"), c("3", "4", "5"),
            c("4", "5", "6"), c("5", "6", "7")
         ),
        sgp.norm.group.preference = 0L
    ),
    MATHEMATICS_SKIP.2023 = list(
        sgp.content.areas = rep("MATHEMATICS", 2),
        sgp.panel.years = c("2020_2021.2", "2022_2023.2"),
        sgp.grade.sequences = list(c("6", "8")), # 2023 is first year with Math Grade 7
        sgp.projection.grade.sequences = list("NO_PROJECTIONS"),
        sgp.norm.group.preference = 1L
    )
)

DD_Config_2023 <-
    c(ELA.2023.config,
      MATHEMATICS.2023.config,
      ALGEBRA_I.2023.config,
      GEOMETRY.2023.config,
      ALGEBRA_II.2023.config
    )

###   Run Cohort Referenced Student Growth Percentiles

Department_of_Defense_SGP <-
    abcSGP(
        sgp_object = Department_of_Defense_Data_LONG,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP"),
        sgp.config = DD_Config_2023,
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

##    Modify projections sequences (for Baseline-referenced analyses only)
SGPstateData[["DD"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ELA"]] <-
    c("6", "7", "8")
SGPstateData[["DD"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ELA"]] <-
    rep("ELA", 3)
SGPstateData[["DD"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ELA"]] <-
    c(1L, 1L)

SGPstateData[["DD"]][["SGP_Configuration"]][["grade.projection.sequence"]][["MATHEMATICS"]] <-
    c("3", "4", "5", "6")
SGPstateData[["DD"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["MATHEMATICS"]] <-
    rep("MATHEMATICS", 4)
SGPstateData[["DD"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["MATHEMATICS"]] <-
    rep(1L, 3)

##    Baseline specific configuration
ELA_BLine.2023.config <- list(
    ELA.2023 = list(
        sgp.content.areas = rep("ELA", 2),
        sgp.panel.years = c("2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(
            c("6", "7"), c("7", "8")
        ),
        sgp.norm.group.preference = 0L
    )
)
MATHEMATICS_BLine.2023.config <- list(
    MATHEMATICS.2023 = list(
        sgp.content.areas = rep("MATHEMATICS", 2),
        sgp.panel.years = c("2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(
            c("3", "4"), c("4", "5"), c("5", "6")
        ),
        sgp.norm.group.preference = 0L
    )
)
#  Not enough data for Algebra I baselines (no 7th/8th grade math prior to 2021)
GEOMETRY_BLine.2023.config <- list(
    GEOMETRY.2023 = list(
        sgp.content.areas = c("ALGEBRA_I", "GEOMETRY"),
        sgp.panel.years = c("2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(c("EOCT", "EOCT")),
        sgp.norm.group.preference = 0L
    )
)
ALGEBRA_II_BLine.2023.config <- list(
    ALGEBRA_II.2023 = list(
        sgp.content.areas = c("GEOMETRY", "ALGEBRA_II"),
        sgp.panel.years = c("2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(c("EOCT", "EOCT")),
        sgp.norm.group.preference = 0L
    )
)

DD_Baseline_Config_2023 <-
    c(ELA_BLine.2023.config,
      MATHEMATICS_BLine.2023.config,
      GEOMETRY_BLine.2023.config,
      ALGEBRA_II_BLine.2023.config
    )

##    Re-run `abcSGP` for baseline SGPs
Department_of_Defense_SGP <-
    abcSGP(
        sgp_object = Department_of_Defense_SGP,
        steps = c("analyzeSGP", "combineSGP", "outputSGP"),
        sgp.config = DD_Baseline_Config_2023,
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
            WORKERS = list(TAUS = 10, SIMEX = 12)
        )
    )

###   Save results
save(Department_of_Defense_SGP,
     file = "./Data/Archive/2022_2023.2/Department_of_Defense_SGP.Rdata"
)
