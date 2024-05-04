###############################################################################
###                                                                         ###
###           New Jersey 2022 (Cohort and Baseline) SGP Analyses            ###
###              * Includes 2019 consecutive-year baselines *               ###
###                                                                         ###
###############################################################################

###   Load packages
require(SGP)
require(data.table)

###   Setup `SGPstateData` with baseline coefficient matrices
###   Add directly rather than using `SGPmatrices` due to SIMEX matrices size.
load("./Data/Archive/NJ_3yr_Baseline_Matrices.Rdata")
SGPstateData[["NJ"]][["Baseline_splineMatrix"]][["Coefficient_Matrices"]] <-
    NJ_3yr_Baseline_Matrices
SGPstateData[["NJ"]][["SGP_Configuration"]][["sgp.cohort.size"]] <- NULL


#####
###   PART A -- 2019 Consecutive Year Baseline SGPs (Done in July 2022)
#####

###   Load data from previous SGP analyses
load("./Data/Archive/2015_2016.2/New_Jersey_SGP_LONG_Data_2015_2016.2.Rdata")
load("./Data/Archive/2018_2019.2/New_Jersey_SGP_LONG_Data.Rdata")

# grep("MOVE_UP_STAY_UP_STATUS", names(New_Jersey_SGP_LONG_Data), value = TRUE)
setnames(New_Jersey_SGP_LONG_Data_2015_2016.2,
         "CATCH_UP_KEEP_UP_STATUS", "CATCH_UP_KEEP_UP_STATUS_3_YEAR")
setnames(New_Jersey_SGP_LONG_Data_2015_2016.2,
         "MOVE_UP_STAY_UP_STATUS", "MOVE_UP_STAY_UP_STATUS_3_YEAR")

###   Combine data sets and subset what is needed
nj.subjects <- c("ELA", "MATHEMATICS", "ALGEBRA_I", "GEOMETRY", "ALGEBRA_II")

New_Jersey_SGP_LONG_Data <-
    rbindlist(
        list(
            New_Jersey_SGP_LONG_Data_2015_2016.2,
            New_Jersey_SGP_LONG_Data
        ),
        fill = TRUE
)
New_Jersey_SGP_LONG_Data <-
    New_Jersey_SGP_LONG_Data[
        YEAR != "2018_2019.1" &
        CONTENT_AREA %in% nj.subjects,
    ]

##    Remove "Percentile Cuts" from data - not used or returned to Pearson
percentile.cuts <-
    grep("PERCENTILE_CUT_", names(New_Jersey_SGP_LONG_Data), value = TRUE)
New_Jersey_SGP_LONG_Data[, (percentile.cuts) := NULL]

SGPstateData[["NJ"]][["Growth"]][["Cutscores"]] <-
    SGPstateData[["NJ"]][["Growth"]][["Levels"]] <- NULL


###   Read in Baseline SGP Configuration Scripts and Combine
source("../SGP_CONFIG/2018_2019.2/BASELINE/Percentiles/ELA_3Year.R")
source("../SGP_CONFIG/2018_2019.2/BASELINE/Percentiles/MATHEMATICS_3Year.R")

NJ_2019_3y_BASELINE_CONFIG <-
    c(ELA_2018_2019.2.config,
      MATHEMATICS_2018_2019.2.config,

      ALGEBRA_I_2018_2019.2.config,
      GEOMETRY_2018_2019.2.config,
      ALGEBRA_II_2018_2019.2.config
    )


###   Run abcSGP analysis
New_Jersey_SGP <-
    abcSGP(
        sgp_object = New_Jersey_SGP_LONG_Data,
        steps = c("prepareSGP", "analyzeSGP"),
        sgp.config = NJ_2019_3y_BASELINE_CONFIG,
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
        save.intermediate.results = FALSE,
        parallel.config = list(
            BACKEND = "PARALLEL",
            WORKERS = list(SIMEX = 15)
        )
    )

# save(New_Jersey_SGP, file = "/home/ubuntu/SGP/NJ_19b.rda")

#####
###   PART B -- 2022 Cohort and Baseline SGP Analyses
#####

###   Load cleaned 2022 LONG data
load("./Data/Archive/2021_2022.1/NJSS_Data_LONG_2021_2022.1.Rdata")
load("./Data/Archive/2021_2022.2/New_Jersey_Data_LONG_2021_2022.2.Rdata")

##    Remove 'experimental' scales scores and use RAW scores.
scaled.raw.scores <-
    c("SCALE_SCORE", "ACHIEVEMENT_LEVEL",
      "SCALE_SCORE_RANKED", "ACHIEVEMENT_LEVEL_RANKED"
    )
NJSS_Data_LONG_2021_2022.1[, (scaled.raw.scores) := NULL]
setnames(NJSS_Data_LONG_2021_2022.1,
         c("SCALE_SCORE_ACTUAL", "ACHIEVEMENT_LEVEL_ACTUAL"),
         c("SCALE_SCORE", "ACHIEVEMENT_LEVEL")
)

New_Jersey_Data_2022 <-
    rbindlist(
        list(NJSS_Data_LONG_2021_2022.1,
             New_Jersey_Data_LONG_2021_2022.2
        ),
        fill = TRUE
    )


###   SGPstateData modifications

SGPstateData[["NJ"]][["SGP_Configuration"]][["grade.projection.sequence"]] <-
SGPstateData[["NJ"]][["SGP_Configuration"]][["content_area.projection.sequence"]] <-
SGPstateData[["NJ"]][["SGP_Configuration"]][["year_lags.projection.sequence"]] <-
    NULL

njss.kbs <-
    createKnotsBoundaries(
        NJSS_Data_LONG_2021_2022.1
    )

gpa.kbs <-
    createKnotsBoundaries(
        New_Jersey_Data_LONG_2021_2022.2[
            CONTENT_AREA %in% c("ELA_GPA", "MATH_GPA"),
        ]
    )

SGPstateData[["NJ"]][["Achievement"]][["Knots_Boundaries"]] <-
    c(SGPstateData[["NJ"]][["Achievement"]][["Knots_Boundaries"]],
      njss.kbs, gpa.kbs
    )


###   Read in configuration scripts and combine
source("../SGP_CONFIG/2021_2022.2/PART_B/ELA_NJ.R")
source("../SGP_CONFIG/2021_2022.2/PART_B/MATHEMATICS_NJ.R")

NJ_Config_2022 <-
    c(ELA_2021_2022.2.config,
      ELA_GPA_2021_2022.2.config,

      MATHEMATICS_2021_2022.2.config,
      ALGEBRA_I.2021_2022.2.config,
      GEOMETRY.2021_2022.2.config,
      ALGEBRA_II.2021_2022.2.config,
      MATH_GPA.2021_2022.2.config
    )

###   Run Cohort Referenced Student Growth Percentiles

New_Jersey_SGP <-
    updateSGP(
        what_sgp_object = New_Jersey_SGP,
        with_sgp_data_LONG = New_Jersey_Data_2022,
        steps = c("prepareSGP", "analyzeSGP"),
        sgp.config = NJ_Config_2022,
        sgp.percentiles = TRUE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = FALSE,
        sgp.projections.baseline = FALSE,
        sgp.projections.lagged.baseline = FALSE,
        # calculate.simex = TRUE, # No CSEM for NJ Start Strong
        save.intermediate.results = FALSE,
        parallel.config = list(
            BACKEND = "PARALLEL",
            WORKERS = list(PERCENTILES = 6)
        )
    )


#####
###   PART C -- 2022 Baseline SGP Analyses
#####

###   Read in configuration scripts and combine
source("../SGP_CONFIG/2021_2022.2/PART_C/ELA.R")
source("../SGP_CONFIG/2021_2022.2/PART_C/MATHEMATICS.R")

NJ_Baseline_Config_2022 <-
    c(ELA_2022_NJ.config,
      MATHEMATICS_2022_NJ.config,
      ALGEBRA_I_2022_NJ.config,
      GEOMETRY_2022_NJ.config,
      ALGEBRA_II_2022_NJ.config
    )

###   Run Baseline Referenced Student Growth Percentiles

New_Jersey_SGP <-
    abcSGP(
        sgp_object = New_Jersey_SGP,
        steps = c("prepareSGP", "analyzeSGP"),
        sgp.config = NJ_Baseline_Config_2022,
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
        simulate.sgps=FALSE, # Not originally included - no Error/Bounds
        save.intermediate.results = FALSE,
        parallel.config = list(
            BACKEND = "PARALLEL",
            WORKERS = list(SIMEX = 15)
        )
    )

###   Combine results from all analyses and output

New_Jersey_SGP <-
    combineSGP(New_Jersey_SGP)

outputSGP(
    sgp_object = New_Jersey_SGP,
    outputSGP.directory = "Data/Archive/2021_2022.2",
    output.type = c("LONG_Data", "LONG_FINAL_YEAR_Data")
)

###   Save results
save(New_Jersey_SGP, file = "./Data/Archive/2021_2022.2/New_Jersey_SGP.Rdata")
