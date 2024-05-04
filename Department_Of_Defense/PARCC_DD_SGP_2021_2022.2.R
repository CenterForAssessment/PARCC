###############################################################################
###                                                                         ###
###      Department of Defense 2022 (Cohort and Baseline) SGP Analyses      ###
###              * Includes 2019 consecutive-year baselines *               ###
###                                                                         ###
###############################################################################

###   Load packages
require(SGP)
require(data.table)

###   Modify `SGPstateData`

##   Add baseline coefficient matrices directly rather than using `SGPmatrices`
##   due to SIMEX matrices size.
load("./Data/Archive/Department_of_Defense_Baseline_Matrices.Rdata")
SGPstateData[["DD"]][["Baseline_splineMatrix"]][["Coefficient_Matrices"]] <-
    Department_of_Defense_Baseline_Matrices


#####
###   PART A -- 2019 Consecutive Year Baseline SGPs (Done in July 2022)
#####

###   Load data from previous SGP analyses
load("./Data/Archive/2020_2021.2/Department_of_Defense_SGP_LONG_Data.Rdata")

##    Remove "Percentile Cuts" from data - not used or returned to Pearson
percentile.cuts <-
    grep("PERCENTILE_CUT_", names(Department_of_Defense_SGP_LONG_Data), value = TRUE)
Department_of_Defense_SGP_LONG_Data[, (percentile.cuts) := NULL]

SGPstateData[["DD"]][["Growth"]][["Cutscores"]] <-
    SGPstateData[["DD"]][["Growth"]][["Levels"]] <- NULL

###   No DoDEA skip-year SGP variables or objects to re-name

###   Read in SGP Configuration Scripts and Combine
source("../SGP_CONFIG/2021_2022.2/PART_A/ELA.R")
source("../SGP_CONFIG/2021_2022.2/PART_A/MATHEMATICS.R")

DD_Baseline_Config_2019 <-
  c(ELA_2018_2019.2.config,
    MATHEMATICS_2018_2019.2.config,
    # ALGEBRA_I_2018_2019.2.config,
    GEOMETRY_2018_2019.2.config,
    ALGEBRA_II_2018_2019.2.config
   )


###   Run abcSGP analysis
Department_of_Defense_SGP <-
    abcSGP(
        sgp_object = Department_of_Defense_SGP_LONG_Data,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP"),
        sgp.config = DD_Baseline_Config_2019,
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
            WORKERS = list(SIMEX = 15)
        )
    )


#####
###   PART B -- 2022 Cohort SGP Analyses
#####

###   Load cleaned 2022 LONG data
load("./Data/Archive/2021_2022.2/Department_of_Defense_Data_LONG_2021_2022.2.Rdata")

###   Modify SGPstateData  --  AFTER Part A!!!
##    Add knots and boundaries for previously untested grade/subjects
ela.kbs <-
    SGPstateData[["PARCC"]][["Achievement"]][["Knots_Boundaries"]][["ELA"]]
math.kbs <-
    SGPstateData[["PARCC"]][["Achievement"]][["Knots_Boundaries"]][["MATHEMATICS"]]

SGPstateData[["DD"]][["Achievement"]][["Knots_Boundaries"]][["ELA"]] <-
    c(SGPstateData[["DD"]][["Achievement"]][["Knots_Boundaries"]][["ELA"]],
      ela.kbs[names(ela.kbs)[!names(ela.kbs) %in%
              names(SGPstateData[["DD"]][["Achievement"]][["Knots_Boundaries"]][["ELA"]])]]
    )

SGPstateData[["DD"]][["Achievement"]][["Knots_Boundaries"]][["MATHEMATICS"]] <-
    c(SGPstateData[["DD"]][["Achievement"]][["Knots_Boundaries"]][["MATHEMATICS"]],
      math.kbs[names(math.kbs)[!names(math.kbs) %in%
               names(SGPstateData[["DD"]][["Achievement"]][["Knots_Boundaries"]][["MATHEMATICS"]])]]
    )

###   Read in configuration scripts and combine
source("../SGP_CONFIG/2021_2022.2/PART_B/ELA.R")
source("../SGP_CONFIG/2021_2022.2/PART_B/MATHEMATICS.R")

DD_Config_2022 <-
  c(ELA_2021_2022.2.config,
    MATHEMATICS_2021_2022.2.config,
    ALGEBRA_I.2021_2022.2.config,
    GEOMETRY.2021_2022.2.config,
    ALGEBRA_II.2021_2022.2.config
   )

###   Run Cohort Referenced Student Growth Percentiles

Department_of_Defense_SGP <-
    updateSGP(
        what_sgp_object = Department_of_Defense_SGP,
        with_sgp_data_LONG = Department_of_Defense_Data_LONG_2021_2022.2,
        steps = c("prepareSGP", "analyzeSGP"),
        sgp.config = DD_Config_2022,
        sgp.percentiles = TRUE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = FALSE,
        sgp.projections.baseline = FALSE,
        sgp.projections.lagged.baseline = FALSE,
        calculate.simex = TRUE,
        save.intermediate.results = FALSE,
        parallel.config = list(
            BACKEND = "PARALLEL",
            WORKERS = list(TAUS = 16, SIMEX = 15)
        )
    )


#####
###   PART C -- 2022 Baseline SGP Analyses
#####

###   Read in configuration scripts and combine
source("../SGP_CONFIG/2021_2022.2/PART_C/ELA.R")
source("../SGP_CONFIG/2021_2022.2/PART_C/MATHEMATICS.R")

DD_Baseline_Config_2022 <-
    c(ELA_2022_DoDEA.config,
      MATHEMATICS_2022_DoDEA.config,

      GEOMETRY_2022_DoDEA.config,
      ALGEBRA_II_2022_DoDEA.config
     )

###   Run Baseline Referenced Student Growth Percentiles

Department_of_Defense_SGP <-
    abcSGP(
        sgp_object = Department_of_Defense_SGP,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
        sgp.config = DD_Baseline_Config_2022,
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
        save.intermediate.results = FALSE,
        outputSGP.directory = "Data/Archive/2021_2022.2",
        outputSGP.output.type = c("LONG_Data", "LONG_FINAL_YEAR_Data"),
        parallel.config = list(
            BACKEND = "PARALLEL",
            WORKERS = list(TAUS = 16, SIMEX = 15)
        )
    )

###   Save results
save(Department_of_Defense_SGP, file = "./Data/Archive/2021_2022.2/Department_of_Defense_SGP.Rdata")
