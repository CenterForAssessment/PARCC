###############################################################################
###                                                                         ###
###            Illinois 2022 (Cohort and Baseline) SGP Analyses             ###
###              * Includes 2019 consecutive-year baselines *               ###
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
###   PART A -- 2019 Consecutive Year Baseline SGPs (Done in July 2022)
#####

###   Load data from previous SGP analyses
load("./Data/Archive/2016_2017.2/Illinois_SGP_LONG_Data_2016_2017.2.Rdata")
load("./Data/Archive/2020_2021.2/Illinois_SGP_LONG_Data.Rdata")

# grep("MOVE_UP_STAY_UP_STATUS", names(Illinois_SGP_LONG_Data), value = TRUE)
setnames(Illinois_SGP_LONG_Data_2016_2017.2,
         "CATCH_UP_KEEP_UP_STATUS", "CATCH_UP_KEEP_UP_STATUS_3_YEAR")
setnames(Illinois_SGP_LONG_Data_2016_2017.2,
         "MOVE_UP_STAY_UP_STATUS", "MOVE_UP_STAY_UP_STATUS_3_YEAR")

###   Combine data sets and subset what is needed
Illinois_SGP_LONG_Data <- rbindlist(list(Illinois_SGP_LONG_Data_2016_2017.2,
                                         Illinois_SGP_LONG_Data), fill = TRUE)
Illinois_SGP_LONG_Data <-
    Illinois_SGP_LONG_Data[GRADE %in% 3:8 &
                           CONTENT_AREA %in% c("ELA", "MATHEMATICS"), ]

##    Remove "Percentile Cuts" from data - not used or returned to Pearson
percentile.cuts <-
    grep("PERCENTILE_CUT_", names(Illinois_SGP_LONG_Data), value = TRUE)
Illinois_SGP_LONG_Data[, (percentile.cuts) := NULL]

SGPstateData[["IL"]][["Growth"]][["Cutscores"]] <-
    SGPstateData[["IL"]][["Growth"]][["Levels"]] <- NULL

###   Rename the skip-year SGP variables and objects
###   Will need to manually manage/merge/delete 2020 baselines
# table(Illinois_SGP_LONG_Data[!is.na(SGP_BASELINE),
#         .(CONTENT_AREA, YEAR), GRADE], exclude = NULL)
baseline.names <- grep("BASELINE", names(Illinois_SGP_LONG_Data), value = TRUE)
setnames(Illinois_SGP_LONG_Data,
         baseline.names,
         paste0(baseline.names, "_SKIP_YEAR"))

###   Read in SGP Configuration Scripts and Combine
source("SGP_CONFIG/2022/PART_A/ELA.R")
source("SGP_CONFIG/2022/PART_A/MATHEMATICS.R")

IL_Baseline_Config_2019 <- c(
    ELA_2018_2019.2.config,
    MATHEMATICS_2018_2019.2.config
)

###   Parallel Config
parallel.config <- list(BACKEND = "PARALLEL",
                        WORKERS =
                            list(SIMEX = 15))
                            # list(BASELINE_PERCENTILES = 12,
                            #      PROJECTIONS = 12,
                            #      LAGGED_PROJECTIONS = 12))

###   First create shell SGP object
# Illinois_SGP <-
#     prepareSGP(Illinois_SGP_LONG_Data, create.additional.variables = FALSE)

# Illinois_SGP@SGP[["Coefficient_Matrices"]] <- Illinois_Baseline_Matrices
# for (i in seq(Illinois_Baseline_Matrices)) {
#     Illinois_Baseline_Matrices[[i]] <- Illinois_Baseline_Matrices[[i]][
#         !duplicated(names(Illinois_Baseline_Matrices[[i]]))]
# }
###   Run abcSGP analysis
Illinois_SGP <-
    abcSGP(
        sgp_object = Illinois_SGP_LONG_Data,
        # state = "IL",
        # years = "2018_2019.2",
        steps = c("prepareSGP", "analyzeSGP", "combineSGP"),
        sgp.config = IL_Baseline_Config_2019,
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
            save.matrices = FALSE, use.cohort.for.ranking = FALSE),
        simulate.sgps = FALSE,
        parallel.config = parallel.config)

baseline.check <- grep("BASELINE", names(Illinois_SGP@Data), value = TRUE)
Illinois_SGP@Data[YEAR == "2019_2020.2", SGP_BASELINE := SGP_BASELINE_SKIP_YEAR]
Illinois_SGP@Data[YEAR == "2019_2020.2", SGP_BASELINE_SKIP_YEAR := NA]


#####
###   PART B -- 2022 Cohort and Baseline SGP Analyses
#####

###   Load cleaned 2022 LONG data
load("./Data/Archive/2021_2022.2/Illinois_Data_LONG_2021_2022.2.Rdata")

###   Read in configuration scripts and combine
source("../SGP_CONFIG/2021_2022.2/ELA.R")
source("../SGP_CONFIG/2021_2022.2/MATHEMATICS.R")

IL_Config_2022 <- c(
    ELA_2021_2022.2.config,
    MATHEMATICS_2021_2022.2.config
)


###   Run Cohort and Baseline Referenced Student Growth Percentiles

Illinois_SGP <-
    updateSGP(
        what_sgp_object = Illinois_SGP,
        with_sgp_data_LONG = Illinois_Data_LONG_2021_2022.2,
        years = "2022",
        steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
        sgp.config = IL_Config_2022,
        sgp.percentiles = TRUE,
        sgp.projections = TRUE,
        sgp.projections.lagged = TRUE,
        sgp.percentiles.baseline = TRUE,
        sgp.projections.baseline = TRUE,
        sgp.projections.lagged.baseline = TRUE,
        # calculate.simex = list(lambda = seq(0, 2, 0.5),
        #     simulation.iterations = 10, extrapolation = "linear",
        #     csem.data.vnames = "SCALE_SCORE_CSEM", save.matrices = FALSE),
        # sgp.test.cohort.size = 5000,
        calculate.simex = TRUE,
        calculate.simex.baseline = list(
            lambda = seq(0, 2, 0.5), simulation.iterations = 75,
            simex.sample.size = 10000, csem.data.vnames = "SCALE_SCORE_CSEM",
            extrapolation = "linear", simex.use.my.coefficient.matrices = TRUE,
            save.matrices = FALSE, use.cohort.for.ranking = FALSE),
        save.intermediate.results = FALSE,
        outputSGP.directory = "Data/Archive/2021_2022.2",
        outputSGP.output.type = c("LONG_Data", "LONG_FINAL_YEAR_Data"),
        parallel.config = list(
            BACKEND = "PARALLEL",
            WORKERS = list(TAUS = 16, SIMEX = 15)))

# baseline.check <- grep("BASELINE", names(Illinois_SGP@Data), value = TRUE)
# table(Illinois_SGP@Data[, YEAR, is.na(SGP_BASELINE_SKIP_YEAR)], exclude = NULL)
# outputSGP(Illinois_SGP, output.type = c("LONG_Data", "LONG_FINAL_YEAR_Data"))

###   Save results
save(Illinois_SGP, file = "./Data/Archive/2021_2022.2/Illinois_SGP.Rdata")
