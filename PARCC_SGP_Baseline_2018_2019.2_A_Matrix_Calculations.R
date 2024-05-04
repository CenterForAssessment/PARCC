################################################################################
###                                                                          ###
###     NM Consortium Learning Loss Analyses -- Create Baseline Matrices     ###
###                                                                          ###
################################################################################

### Load necessary packages
require(SGP)
require(data.table)

###   Load Original Consortium data from 2019 PARCC SGP Analyses
load("Data/Archive/2018_2019.2/PARCC_SGP_LONG_Data.Rdata")
load("Data/Archive/2015_2016.2/PARCC_SGP_LONG_Data_2015_2016.2.Rdata")

###   Create a smaller subset of the LONG data to work with.
##  Consortium members as of 2019 - make comparible to results provided
parcc.members <- c("BI", "DC", "DD", "IL", "MD", "NJ", "NM")
parcc.years <- c("2016_2017.2", "2017_2018.2", "2018_2019.2")
parcc.subjects <- c("ELA", "MATHEMATICS", "ALGEBRA_I", "GEOMETRY", "ALGEBRA_II")

PARCC_Baseline_Data <- rbindlist(
  list(
    PARCC_SGP_LONG_Data_2015_2016.2[
      StateAbbreviation %in% parcc.members &
      CONTENT_AREA %in% parcc.subjects,
      list(VALID_CASE, ID, YEAR, CONTENT_AREA, GRADE,
           SCALE_SCORE, SCALE_SCORE_CSEM, ACHIEVEMENT_LEVEL)
    ],
    PARCC_SGP_LONG_Data[
      StateAbbreviation %in% parcc.members &
      CONTENT_AREA %in% parcc.subjects &
      YEAR %in% parcc.years,
      list(VALID_CASE, ID, YEAR, CONTENT_AREA, GRADE,
           SCALE_SCORE, SCALE_SCORE_CSEM, ACHIEVEMENT_LEVEL)
    ]
  )
)

ids <- unique(PARCC_Baseline_Data[YEAR == "2018_2019.2", ID])
PARCC_Baseline_Data <- PARCC_Baseline_Data[ID %in% ids, ]

rm(list = c("PARCC_SGP_LONG_Data_2015_2016.2", "PARCC_SGP_LONG_Data"))
gc()

###   Read in Baseline SGP Configuration Scripts and Combine
source("../SGP_CONFIG/2018_2019.2/BASELINE/Matrices/ELA.R")
source("../SGP_CONFIG/2018_2019.2/BASELINE/Matrices/MATHEMATICS.R")
# source("../SGP_CONFIG/2018_2019.2/BASELINE/Matrices/ELA_3Year.R")
# source("../SGP_CONFIG/2018_2019.2/BASELINE/Matrices/MATHEMATICS_3Year.R")

PARCC_BASELINE_CONFIG <- c(
    ELA_BASELINE.config,
    MATHEMATICS_BASELINE.config,

    ALGEBRA_I_BASELINE.config,
    GEOMETRY_BASELINE.config,
    ALGEBRA_II_BASELINE.config
)


###
###    baselineSGP - To produce uncorrected and SIMEX baseline matrices
###

###   First create shell SGP object
PARCC_SGP <-
    prepareSGP(PARCC_Baseline_Data, create.additional.variables = FALSE)

PARCC_Baseline_Matrices <-
# PARCC_3yr_Baseline_Matrices <-
    baselineSGP(
        sgp_object = PARCC_SGP,
        sgp.baseline.config = PARCC_BASELINE_CONFIG,
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
            WORKERS = list(TAUS = 12, SIMEX = 12))
    )

###   Save results
save(PARCC_Baseline_Matrices, file = "Data/Archive/PARCC_Baseline_Matrices.Rdata")
# save(PARCC_3yr_Baseline_Matrices, file = "Data/Archive/PARCC_3yr_Baseline_Matrices.Rdata")
