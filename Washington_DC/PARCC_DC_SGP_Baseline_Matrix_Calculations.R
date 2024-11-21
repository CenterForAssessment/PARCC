################################################################################
###                                                                          ###
###     Washington_DC Learning Loss Analyses -- Create Baseline Matrices     ###
###                                                                          ###
################################################################################

### Load necessary packages
require(SGP)
require(data.table)

###   Load Original Washington_DC data from 2019 DC SGP Analyses

load("Data/Archive/2022_2023.2/Washington_DC_SGP_LONG_Data.Rdata")
# load("Data/Archive/2018_2019.2/Washington_DC_SGP_LONG_Data.Rdata")

###   Create a smaller subset of the LONG data to work with.
# bline.years <- c("2016_2017.2", "2017_2018.2", "2018_2019.2")
bline.years <- c("2021_2022.2", "2022_2023.2")
bline.subjects <- c("ELA", "MATHEMATICS", "ALGEBRA_I", "GEOMETRY")

Washington_DC_Baseline_Data <-
    Washington_DC_SGP_LONG_Data[
        CONTENT_AREA %in% bline.subjects &
        YEAR %in% bline.years,
        list(
            VALID_CASE, ID, YEAR, CONTENT_AREA, GRADE,
            SCALE_SCORE, SCALE_SCORE_CSEM, ACHIEVEMENT_LEVEL)
    ]

ids <- unique(Washington_DC_Baseline_Data[YEAR=="2022_2023.2", ID])
Washington_DC_Baseline_Data <- Washington_DC_Baseline_Data[ID %in% ids, ]

Washington_DC_Baseline_Data[, VALID_CASE := "VALID_CASE"]

rm(list = "Washington_DC_SGP_LONG_Data");gc()

###   Read in Baseline SGP Configuration Scripts and Combine
source("../SGP_CONFIG/2023_2024.2/BASELINE/Matrices/ELA_DC_23.R")
source("../SGP_CONFIG/2023_2024.2/BASELINE/Matrices/MATHEMATICS_DC_23.R")
##    Pre-COVID matrices used in 2023
# source("../SGP_CONFIG/2018_2019.2/BASELINE/Matrices/ELA_seq_only.R")
# source("../SGP_CONFIG/2018_2019.2/BASELINE/Matrices/MATHEMATICS_seq_only.R")

Washington_DC_BASELINE_CONFIG <-
    c(
        ELA_BASELINE.config,
        MATHEMATICS_BASELINE.config,
        ALGEBRA_I_BASELINE.config,
        GEOMETRY_BASELINE.config
    )


###
###    baselineSGP - To produce uncorrected and SIMEX baseline matrices
###

###   First create shell SGP object
Washington_DC_SGP <-
    prepareSGP(
        Washington_DC_Baseline_Data,
        create.additional.variables = FALSE
    )

Washington_DC_Baseline_Matrices <-
    baselineSGP(
        Washington_DC_SGP,
        sgp.baseline.config = Washington_DC_BASELINE_CONFIG,
        return.matrices.only = TRUE,
        calculate.baseline.sgps = FALSE,
        calculate.simex.baseline = list(
            csem.data.vnames = "SCALE_SCORE_CSEM", lambda = seq(0, 2, 0.5),
            simulation.iterations = 75, extrapolation = "linear",
            # simex.use.my.coefficient.matrices = FALSE,
            save.matrices = TRUE, use.cohort.for.ranking = TRUE),
        sgp.cohort.size = 1000,
        goodness.of.fit.print = FALSE,
        parallel.config = list(
            BACKEND = "PARALLEL",
            WORKERS = list(TAUS = 11, SIMEX = 8)
        )
    )

###   Save results
save(Washington_DC_Baseline_Matrices, file = "Data/Archive/Washington_DC_Baseline_Matrices-2023.Rdata")
# save(Washington_DC_Baseline_Matrices, file = "Data/Archive/Washington_DC_Baseline_Matrices.Rdata")
