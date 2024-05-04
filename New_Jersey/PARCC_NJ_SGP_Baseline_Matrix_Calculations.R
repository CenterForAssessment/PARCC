################################################################################
###                                                                          ###
###     New_Jersey Learning Loss Analyses -- Create Baseline Matrices     ###
###                                                                          ###
################################################################################

### Load necessary packages
require(SGP)
require(data.table)

###   Load Original New_Jersey data from 2019 NJ SGP Analyses

load("Data/Archive/2018_2019.2/New_Jersey_SGP_LONG_Data.Rdata")

###   Create a smaller subset of the LONG data to work with.
bline.years <- c("2016_2017.2", "2017_2018.2", "2018_2019.2")
bline.subjects <-
    c("ELA", "MATHEMATICS", "ALGEBRA_I", "GEOMETRY", "ALGEBRA_II")

New_Jersey_Baseline_Data <-
    New_Jersey_SGP_LONG_Data[
        CONTENT_AREA %in% bline.subjects & YEAR %in% bline.years,
        list(
            VALID_CASE, ID, YEAR, CONTENT_AREA, GRADE,
            SCALE_SCORE, SCALE_SCORE_CSEM, ACHIEVEMENT_LEVEL)
    ]

ids <- unique(New_Jersey_Baseline_Data[YEAR == "2018_2019.2", ID])
New_Jersey_Baseline_Data <- New_Jersey_Baseline_Data[ID %in% ids, ]

New_Jersey_Baseline_Data[, VALID_CASE := "VALID_CASE"]

rm(list = "New_Jersey_SGP_LONG_Data");gc()

##    Remove duplicate cases from 2017
setkey(New_Jersey_Baseline_Data,
    VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID, SCALE_SCORE)
setkey(New_Jersey_Baseline_Data,
    VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID)
dupl <-
    duplicated(New_Jersey_Baseline_Data, by = key(New_Jersey_Baseline_Data))
New_Jersey_Baseline_Data <-
    New_Jersey_Baseline_Data[-which(dupl)]

###   Read in Baseline SGP Configuration Scripts and Combine
source("../SGP_CONFIG/2018_2019.2/BASELINE/Matrices/ELA_seq_only.R")
source("../SGP_CONFIG/2018_2019.2/BASELINE/Matrices/MATHEMATICS_seq_only.R")

New_Jersey_BASELINE_CONFIG <- c(
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
New_Jersey_SGP <-
    prepareSGP(
        New_Jersey_Baseline_Data,
        create.additional.variables = FALSE
    )

New_Jersey_Baseline_Matrices <-
    baselineSGP(
        New_Jersey_SGP,
        sgp.baseline.config = New_Jersey_BASELINE_CONFIG,
        return.matrices.only = TRUE,
        calculate.baseline.sgps = FALSE,
        calculate.simex.baseline = list(
            csem.data.vnames = "SCALE_SCORE_CSEM", lambda = seq(0, 2, 0.5),
            simulation.iterations = 75, extrapolation = "linear",
            simex.sample.size = 10000,
            save.matrices = TRUE, use.cohort.for.ranking = TRUE),
        sgp.cohort.size = 1000,
        goodness.of.fit.print = FALSE,
        parallel.config = list(
            BACKEND = "PARALLEL",
            WORKERS = list(TAUS = 12, SIMEX = 15)
        )
    )

###   Save results
save(New_Jersey_Baseline_Matrices,
     file = "Data/Archive/New_Jersey_Baseline_Matrices.Rdata"
)
