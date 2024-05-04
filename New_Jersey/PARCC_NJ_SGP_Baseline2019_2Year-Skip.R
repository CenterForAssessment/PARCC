################################################################################
###                                                                          ###
###               New Jersey -- 2019 2-year skip Baseline SGPs               ###
###                                                                          ###
################################################################################

###   Load packages
require(SGP)
require(data.table)

###   Load data and remove some old vars.
load("Data/Archive/2015_2016.2/New_Jersey_SGP_LONG_Data_2015_2016.2.Rdata")
load("Data/Archive/2018_2019.2/New_Jersey_SGP_LONG_Data_2018_2019.2.Rdata")

setnames(New_Jersey_SGP_LONG_Data_2015_2016.2,
        c("CATCH_UP_KEEP_UP_STATUS", "MOVE_UP_STAY_UP_STATUS"),
        c("CATCH_UP_KEEP_UP_STATUS_3_YEAR", "MOVE_UP_STAY_UP_STATUS_3_YEAR")
)

###   Create a smaller subset of the LONG data to work with.
###   Only states in consortium 2021 and (?) beyond.
nj.subjects <- c("ELA", "MATHEMATICS", "ALGEBRA_I", "GEOMETRY", "ALGEBRA_II")

New_Jersey_Baseline_Data <- rbindlist(
    list(New_Jersey_SGP_LONG_Data_2015_2016.2[CONTENT_AREA %in% nj.subjects, ],
         New_Jersey_SGP_LONG_Data_2018_2019.2[CONTENT_AREA %in% nj.subjects, ]
    ),
    fill = TRUE
)

#####
###   PART A  --  Baseline Matrix Calculation
#####

source("../SGP_CONFIG/2018_2019.2/BASELINE/Matrices/ELA_3Year.R")
source("../SGP_CONFIG/2018_2019.2/BASELINE/Matrices/MATHEMATICS_3Year.R")

NJ_BASELINE_MATRIX_CONFIG <-
    c(ELA_BASELINE.config,
      MATHEMATICS_BASELINE.config,

      ALGEBRA_I_BASELINE.config,
      GEOMETRY_BASELINE.config,
      ALGEBRA_II_BASELINE.config
    )

###    baselineSGP - To produce uncorrected and SIMEX baseline matrices

##    First create shell SGP object
New_Jersey_SGP <-
    prepareSGP(New_Jersey_Baseline_Data, create.additional.variables = FALSE)

NJ_3yr_Baseline_Matrices <-
    baselineSGP(
        sgp_object = New_Jersey_SGP,
        sgp.baseline.config = NJ_BASELINE_MATRIX_CONFIG,
        return.matrices.only = TRUE,
        calculate.baseline.sgps = FALSE,
        calculate.simex.baseline = list(
            csem.data.vnames = "SCALE_SCORE_CSEM",
            extrapolation = "linear", lambda = seq(0, 2, 0.5),
            simulation.iterations = 75, simex.sample.size = 10000, # 2000
            simex.use.my.coefficient.matrices = FALSE,
            save.matrices = TRUE, use.cohort.for.ranking = TRUE),
        ###
        # sgp.test.cohort.size = 10000,
        # comment out and change calculate.simex.baseline$simex.sample.size to 10000 for full run
        ###
        sgp.cohort.size = 1000,
        goodness.of.fit.print = FALSE,
        parallel.config = list(
            BACKEND = "PARALLEL",
            WORKERS = list(TAUS = 6, SIMEX = 6))
    )

###   Save results
save(NJ_3yr_Baseline_Matrices, file = "Data/Archive/NJ_3yr_Baseline_Matrices.Rdata")




#####
###   Run BASELINE SGP analysis - create new New_Jersey_SGP object with historical data
#####

# New_Jersey_SGP <-
#     abcSGP(
#         sgp_object = New_Jersey_Baseline_Data,
#         steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
#         sgp.config = NJ_2019_3y_BASELINE_CONFIG,
#         sgp.percentiles = FALSE,
#         sgp.projections = FALSE,
#         sgp.projections.lagged = FALSE,
#         sgp.percentiles.baseline = TRUE,
#         sgp.projections.baseline = FALSE,
#         sgp.projections.lagged.baseline = FALSE,
#         calculate.simex.baseline = TRUE,
#         save.intermediate.results = FALSE,
#         outputSGP.output.type = "LONG_FINAL_YEAR_Data",
#         outputSGP.directory = "Data/Archive/2018_2019.2/BASELINE/2_YEAR_SKIP",
#         parallel.config = list(
#             BACKEND = "PARALLEL",
#             WORKERS = list(BASELINE_PERCENTILES = 6))
#     )

# ###   Quick checks
# table(New_Jersey_SGP@Data[YEAR == "2018_2019.2" & is.na(SGP) & !is.na(SGP_BASELINE), SGP_NOTE], exclude = NULL)
# tmp.tbl <- table(New_Jersey_SGP@Data[YEAR=="2018_2019.2" & is.na(SGP) & !is.na(SGP_BASELINE), as.character(SGP_NORM_GROUP_BASELINE)]) # Kids with skip year, but no seq
# tmp.tbl[tmp.tbl > 1000] # check larger groups

# table(New_Jersey_SGP@Data[YEAR=="2018_2019.2" & !is.na(SGP) & is.na(SGP_BASELINE), as.character(SGP_NORM_GROUP)]) #  single (2018.2 OR 2019.1) prior only

# ###   Save results
# # save(New_Jersey_SGP, file = "Data/Archive/2018_2019.2/BASELINE/New_Jersey_SGP.Rdata")
