################################################################################
###                                                                          ###
###        New Meridian Consortium -- 2019 2-year skip Baseline SGPs         ###
###                                                                          ###
################################################################################

###   Load packages
require(SGP)
require(data.table)

###   Load data and remove some old vars.
load("Data/Archive/2015_2016.2/PARCC_SGP_LONG_Data_2015_2016.2.Rdata")
load("Data/Archive/2018_2019.2/PARCC_SGP_LONG_Data_2018_2019.2.Rdata")

setnames(PARCC_SGP_LONG_Data_2015_2016.2,
        c("CATCH_UP_KEEP_UP_STATUS", "MOVE_UP_STAY_UP_STATUS"),
        c("CATCH_UP_KEEP_UP_STATUS_3_YEAR", "MOVE_UP_STAY_UP_STATUS_3_YEAR"))

###   Create a smaller subset of the LONG data to work with.
###   Only states in consortium 2021 and (?) beyond.
parcc.members <- c("IL", "NJ")
parcc.subjects <- c("ELA", "MATHEMATICS", "ALGEBRA_I", "GEOMETRY", "ALGEBRA_II")

PARCC_Baseline_Data <- rbindlist(
    list(PARCC_SGP_LONG_Data_2015_2016.2[
            StateAbbreviation %in% parcc.members &
            CONTENT_AREA %in% parcc.subjects,
         ],
         PARCC_SGP_LONG_Data_2018_2019.2[
            StateAbbreviation %in% parcc.members &
            CONTENT_AREA %in% parcc.subjects,
         ]
    ),
    fill = TRUE
)

###   Add single-cohort baseline matrices to SGPstateData
load("Data/Archive/PARCC_3yr_Baseline_Matrices.Rdata")
SGPstateData[["PARCC"]][["Baseline_splineMatrix"]][["Coefficient_Matrices"]] <- PARCC_3yr_Baseline_Matrices
SGPstateData[["PARCC"]][["SGP_Configuration"]][["sgp.cohort.size"]] <- NULL

###   Read in Baseline SGP Configuration Scripts and Combine
source("../SGP_CONFIG/2018_2019.2/BASELINE/Percentiles/ELA_3Year.R")
source("../SGP_CONFIG/2018_2019.2/BASELINE/Percentiles/MATHEMATICS_3Year.R")

PARCC_2019_3y_BASELINE_CONFIG <-
  c(ELA_2018_2019.2.config,
    MATHEMATICS_2018_2019.2.config,

    ALGEBRA_I_2018_2019.2.config,
    GEOMETRY_2018_2019.2.config,
    ALGEBRA_II_2018_2019.2.config
)

#####
###   Run BASELINE SGP analysis - create new PARCC_SGP object with historical data
#####

PARCC_SGP <-
    abcSGP(
        sgp_object = PARCC_Baseline_Data,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
        sgp.config = PARCC_2019_3y_BASELINE_CONFIG,
        sgp.percentiles = FALSE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = TRUE,
        sgp.projections.baseline = FALSE,
        sgp.projections.lagged.baseline = FALSE,
        calculate.simex.baseline = TRUE,
        save.intermediate.results = FALSE,
        outputSGP.output.type = "LONG_Data",
        outputSGP.directory = "Data/Archive/2018_2019.2/BASELINE/2_YEAR_SKIP",
        parallel.config = list(
            BACKEND = "PARALLEL",
            WORKERS = list(BASELINE_PERCENTILES = 14))
    )

###   Quick checks
table(PARCC_SGP@Data[YEAR == "2018_2019.2" & is.na(SGP) & !is.na(SGP_BASELINE), SGP_NOTE], exclude = NULL)
tmp.tbl <- table(PARCC_SGP@Data[YEAR=="2018_2019.2" & is.na(SGP) & !is.na(SGP_BASELINE), as.character(SGP_NORM_GROUP_BASELINE)]) # Kids with skip year, but no seq
tmp.tbl[tmp.tbl > 1000] # check larger groups

table(PARCC_SGP@Data[YEAR=="2018_2019.2" & !is.na(SGP) & is.na(SGP_BASELINE), as.character(SGP_NORM_GROUP)]) #  single (2018.2 OR 2019.1) prior only

###   Save results
# save(PARCC_SGP, file = "Data/Archive/2018_2019.2/BASELINE/PARCC_SGP.Rdata")
