################################################################################
###                                                                          ###
###     Washington_DC Learning Loss Analyses -- Create Baseline Matrices     ###
###                                                                          ###
################################################################################

### Load necessary packages
require(SGP)
require(data.table)

###   Load Original Washington_DC data from 2019 IL SGP Analyses

load("Data/Archive/2018_2019.2/Washington_DC_SGP_LONG_Data.Rdata")
load("Data/Archive/2015_2016.2/Washington_DC_SGP_LONG_Data_2015_2016.2.Rdata")

###   Create a smaller subset of the LONG data to work with.
parcc.years <- c("2016_2017.2", "2017_2018.2", "2018_2019.2")
parcc.subjects <- c("ELA", "MATHEMATICS") # , "ALGEBRA_I", "GEOMETRY", "ALGEBRA_II")

Washington_DC_Baseline_Data <- rbindlist(list(
    Washington_DC_SGP_LONG_Data_2015_2016.2[CONTENT_AREA %in% parcc.subjects,
      list(VALID_CASE, ID, YEAR, CONTENT_AREA, GRADE, SCALE_SCORE, SCALE_SCORE_CSEM, ACHIEVEMENT_LEVEL)],
    Washington_DC_SGP_LONG_Data[CONTENT_AREA %in% parcc.subjects & YEAR %in% parcc.years,
      list(VALID_CASE, ID, YEAR, CONTENT_AREA, GRADE, SCALE_SCORE, SCALE_SCORE_CSEM, ACHIEVEMENT_LEVEL)]))

ids <- unique(Washington_DC_Baseline_Data[YEAR=="2018_2019.2", ID])
Washington_DC_Baseline_Data <- Washington_DC_Baseline_Data[ID %in% ids, ]

rm(list=c("Washington_DC_SGP_LONG_Data_2015_2016.2", "Washington_DC_SGP_LONG_Data"));gc()

###   Read in Baseline SGP Configuration Scripts and Combine
source("../SGP_CONFIG/2018_2019.2/BASELINE/Matrices/ELA.R")
source("../SGP_CONFIG/2018_2019.2/BASELINE/Matrices/MATHEMATICS.R")

Washington_DC_BASELINE_CONFIG <- c(
    ELA_BASELINE.config,
    MATHEMATICS_BASELINE.config
)


###
###    baselineSGP - To produce uncorrected and SIMEX baseline matrices
###

###   First create shell SGP object
Washington_DC_SGP <- prepareSGP(Washington_DC_Baseline_Data, create.additional.variables=FALSE)

Washington_DC_Baseline_Matrices <- baselineSGP(
  Washington_DC_SGP,
  sgp.baseline.config=Washington_DC_BASELINE_CONFIG,
  return.matrices.only=TRUE,
  calculate.baseline.sgps=FALSE,
  calculate.simex.baseline=list(
    csem.data.vnames="SCALE_SCORE_CSEM", lambda=seq(0,2,0.5), simulation.iterations=75,
    simex.use.my.coefficient.matrices = FALSE, simex.sample.size=10000, # simex.sample.size=2000, #
    extrapolation="linear", save.matrices=TRUE, use.cohort.for.ranking=TRUE),
  ###
  # sgp.test.cohort.size = 10000, # comment out for full run and change calculate.simex.baseline$simex.sample.size to 10000
  ###
  sgp.cohort.size=1000,
  goodness.of.fit.print=FALSE,
  parallel.config=list(
    BACKEND="PARALLEL",
    WORKERS=list(TAUS=27, SIMEX=25)))

###   Save results
save(Washington_DC_Baseline_Matrices, file="Data/Washington_DC_Baseline_Matrices.Rdata")
