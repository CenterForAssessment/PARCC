###############################################################################
###                                                                         ###
###          New Meridian 2022 (Cohort and Baseline) SGP Analyses           ###
###              * Includes 2019 consecutive-year baselines *               ###
###                                                                         ###
###############################################################################

###   Load packages
require(SGP)
require(data.table)

###   Setup `SGPstateData` with baseline coefficient matrices
###   Add directly rather than using `SGPmatrices` due to SIMEX matrices size.
load("./Data/Archive/PARCC_Baseline_Matrices.Rdata")
SGPstateData[["PARCC"]][["Baseline_splineMatrix"]][["Coefficient_Matrices"]] <-
    PARCC_Baseline_Matrices


#####
###   PART A -- 2019 Consecutive Year Baseline SGPs (Done in July 2022)
#####

###   Load data from previous SGP analyses
load("./Data/Archive/2016_2017.2/PARCC_SGP_LONG_Data_2016_2017.2.Rdata")
load("./Data/Archive/2020_2021.2/PARCC_SGP_LONG_Data.Rdata")

# grep("MOVE_UP_STAY_UP_STATUS", names(PARCC_SGP_LONG_Data), value = TRUE)
setnames(PARCC_SGP_LONG_Data_2016_2017.2,
         "CATCH_UP_KEEP_UP_STATUS", "CATCH_UP_KEEP_UP_STATUS_3_YEAR")
setnames(PARCC_SGP_LONG_Data_2016_2017.2,
         "MOVE_UP_STAY_UP_STATUS", "MOVE_UP_STAY_UP_STATUS_3_YEAR")

###   Create a smaller subset of the LONG data to work with.
###   Only states in consortium 2021 and (?) beyond.
parcc.members <- c("BI", "DC", "DD", "IL", "NJ") # , "NM", "MD",
parcc.years <- c("2016_2017.2", "2017_2018.2", "2018_2019.2", "2020_2021.2")
parcc.subjects <- c("ELA", "MATHEMATICS", "ALGEBRA_I", "GEOMETRY", "ALGEBRA_II")

PARCC_SGP_LONG_Data <- rbindlist(
    list(
        PARCC_SGP_LONG_Data_2016_2017.2[
            StateAbbreviation %in% parcc.members &
            CONTENT_AREA %in% parcc.subjects,
        ],
        PARCC_SGP_LONG_Data[
            StateAbbreviation %in% parcc.members &
            CONTENT_AREA %in% parcc.subjects &
            YEAR %in% parcc.years,
        ]),
        fill = TRUE
    )

##    Remove "Percentile Cuts" from data - not used or returned to Pearson
percentile.cuts <-
    grep("PERCENTILE_CUT_", names(PARCC_SGP_LONG_Data), value = TRUE)
PARCC_SGP_LONG_Data[, (percentile.cuts) := NULL]

SGPstateData[["PARCC"]][["Growth"]][["Cutscores"]] <-
    SGPstateData[["PARCC"]][["Growth"]][["Levels"]] <- NULL

###   Rename the skip-year SGP variables and objects
###   Will need to manually manage/merge/delete 2020 baselines
# table(PARCC_SGP_LONG_Data[!is.na(SGP_BASELINE),
#         .(CONTENT_AREA, YEAR), GRADE], exclude = NULL)
baseline.names <- grep("BASELINE", names(PARCC_SGP_LONG_Data), value = TRUE)
setnames(PARCC_SGP_LONG_Data,
         baseline.names,
         paste0(baseline.names, "_SKIP_YEAR")
)

###   Read in SGP Configuration Scripts and Combine
source("../SGP_CONFIG/2021_2022.2/PART_A/ELA.R")
source("../SGP_CONFIG/2021_2022.2/PART_A/MATHEMATICS.R")

All_Baseline_Config_2019 <-
    c(ELA_2018_2019.2.config,
      MATHEMATICS_2018_2019.2.config,
      ALGEBRA_I_2018_2019.2.config,
      GEOMETRY_2018_2019.2.config,
      ALGEBRA_II_2018_2019.2.config
    )

###   Run abcSGP analysis
PARCC_SGP <-
    abcSGP(
        sgp_object = PARCC_SGP_LONG_Data,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP"),
        sgp.config = All_Baseline_Config_2019,
        sgp.percentiles = FALSE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = TRUE,
        sgp.projections.baseline = FALSE,
        sgp.projections.lagged.baseline = FALSE,
        calculate.simex.baseline = list(
            lambda = seq(0, 2, 0.5), simulation.iterations = 75,
            simex.sample.size = 10000, csem.data.vnames = "SCALE_SCORE_CSEM",
            extrapolation = "linear", simex.use.my.coefficient.matrices = TRUE,
            save.matrices = FALSE, use.cohort.for.ranking = FALSE
        ),
        simulate.sgps = FALSE,
        parallel.config = list(
            BACKEND = "PARALLEL",
            WORKERS = list(SIMEX = 25)
        )
    )


#####
###   PART B -- 2022 Cohort and Baseline SGP Analyses
#####


#####
###   PART B -- 2022 Cohort SGP Analyses
#####

###   Load cleaned 2022 LONG data
load("../Illinois/Data/Archive/2021_2022.2/Illinois_Data_LONG_2021_2022.2.Rdata")
load("../New_Jersey/Data/Archive/2021_2022.2/New_Jersey_Data_LONG_2021_2022.2.Rdata")
load("../Department_Of_Defense/Data/Archive/2021_2022.2/Department_of_Defense_Data_LONG_2021_2022.2.Rdata")
load("../Bureau_of_Indian_Education/Data/Archive/2021_2022.2/Bureau_of_Indian_Education_Data_LONG_2021_2022.2.Rdata")

PARCC_Data_LONG_2022 <-
    rbindlist(
        list(Illinois_Data_LONG_2021_2022.2,
             New_Jersey_Data_LONG_2021_2022.2,
             Department_of_Defense_Data_LONG_2021_2022.2,
             Bureau_of_Indian_Education_Data_LONG_2021_2022.2
        ),
        fill = TRUE
    )

###   Create Knots and Bounds for NJ *_GPA tests (not used, but throws an error)

gpa.kbs <-
    createKnotsBoundaries(
        New_Jersey_Data_LONG_2021_2022.2[
            CONTENT_AREA %in% c("ELA_GPA", "MATH_GPA"),
        ]
    )

SGPstateData[["PARCC"]][["Achievement"]][["Knots_Boundaries"]] <-
    c(SGPstateData[["PARCC"]][["Achievement"]][["Knots_Boundaries"]],
      gpa.kbs
    )

###   Read in configuration scripts and combine
source("../SGP_CONFIG/2021_2022.2/PART_B/ELA.R")
source("../SGP_CONFIG/2021_2022.2/PART_B/MATHEMATICS.R")

All_Config_2022 <-
    c(ELA_2021_2022.2.config,
      MATHEMATICS_2021_2022.2.config,
      ALGEBRA_I.2021_2022.2.config,
      GEOMETRY.2021_2022.2.config,
      ALGEBRA_II.2021_2022.2.config
    )


###   Run Cohort and Baseline Referenced Student Growth Percentiles

PARCC_SGP <-
    updateSGP(
        what_sgp_object = PARCC_SGP,
        with_sgp_data_LONG = PARCC_Data_LONG_2022,
        years = "2021_2022.2",
        steps = c("prepareSGP", "analyzeSGP"),
        sgp.config = All_Config_2022,
        sgp.percentiles = TRUE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = TRUE,
        sgp.projections.baseline = TRUE,
        sgp.projections.lagged.baseline = TRUE,
        calculate.simex = TRUE,
        calculate.simex.baseline = list(
            lambda = seq(0, 2, 0.5), simulation.iterations = 75,
            simex.sample.size = 10000, csem.data.vnames = "SCALE_SCORE_CSEM",
            extrapolation = "linear", simex.use.my.coefficient.matrices = TRUE,
            save.matrices = FALSE, use.cohort.for.ranking = FALSE
        ),
        save.intermediate.results = FALSE,
        parallel.config = list(
            BACKEND = "PARALLEL",
            WORKERS = list(TAUS = 26, SIMEX = 25)
        )
    )


#####
###   PART C -- 2022 Cohort SGP Analyses
#####

SGPstateData[["PARCC"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ELA"]] <-
SGPstateData[["PARCC"]][["SGP_Configuration"]][["grade.projection.sequence"]][["MATHEMATICS"]] <-
    c("3", "4", "5", "6", "7", "8")
SGPstateData[["PARCC"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ELA"]] <-
    rep("ELA", 6)
SGPstateData[["PARCC"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["MATHEMATICS"]] <-
    rep("MATHEMATICS", 6)
SGPstateData[["PARCC"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ELA"]] <-
SGPstateData[["PARCC"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["MATHEMATICS"]] <-
    rep(1L, 5)

SGPstateData[["PARCC"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ALGEBRA_I"]] <-
SGPstateData[["PARCC"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ALGEBRA_I"]] <-
SGPstateData[["PARCC"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ALGEBRA_I"]] <-
SGPstateData[["PARCC"]][["SGP_Configuration"]][["grade.projection.sequence"]][["GEOMETRY"]] <-
SGPstateData[["PARCC"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["GEOMETRY"]] <-
SGPstateData[["PARCC"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["GEOMETRY"]] <-
SGPstateData[["PARCC"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ALGEBRA_II"]] <-
SGPstateData[["PARCC"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ALGEBRA_II"]] <-
SGPstateData[["PARCC"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ALGEBRA_II"]] <-
    NULL

All_Config_2022[["ELA.2021_2022.2"]][["sgp.grade.sequences"]] <-
    All_Config_2022[["ELA.2021_2022.2"]][["sgp.grade.sequences"]][1:5]
All_Config_2022[[3]][["sgp.projection.grade.sequences"]] <- # Alg1 "Canonical"
All_Config_2022[[6]][["sgp.projection.grade.sequences"]] <- # Geom
All_Config_2022[[9]][["sgp.projection.grade.sequences"]] <- # Alg2
    list("NO_PROJECTIONS")

# PARCC_SGP@SGP[["Coefficient_Matrices"]] <- NULL

PARCC_SGP <-
    analyzeSGP(
        sgp_object = PARCC_SGP,
        # steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
        sgp.config = All_Config_2022,
        sgp.percentiles = FALSE,
        sgp.projections = TRUE,
        sgp.projections.lagged = TRUE,
        sgp.percentiles.baseline = FALSE,
        sgp.projections.baseline = FALSE,
        sgp.projections.lagged.baseline = FALSE,
        parallel.config = NUL
    )


###   Combine results from 2022 analyses and output

PARCC_SGP <-
    combineSGP(
        sgp_object = PARCC_SGP,
        years = "2021_2022.2",
    )

outputSGP(
    sgp_object = PARCC_SGP,
    outputSGP.directory = "Data/Archive/2021_2022.2",
    output.type = c("LONG_Data", "LONG_FINAL_YEAR_Data")
)

###   Save results
save(PARCC_SGP, file = "./Data/Archive/2021_2022.2/PARCC_SGP.Rdata")
