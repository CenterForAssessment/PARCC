################################################################################
###                                                                          ###
###          Department of Defense 2021 (Cohort ONLY!) SGP Analyses          ###
###                                                                          ###
################################################################################

###   Load packages
require(SGP)
require(data.table)

###   Load data from 2019 SGP analyses (with student demographics and new Refid added in 2021)
load("./Data/Archive/2018_2019.2/BASELINE/Department_of_Defense_SGP_LONG_Data.Rdata")

###   Load cleaned 2021 LONG data
load("./Data/Archive/2020_2021.2/Department_of_Defense_Data_LONG_2020_2021.2.Rdata")

###   Combine 2021 and prior data
Department_of_Defense_LONG_Data <- rbindlist(list(
	Department_of_Defense_SGP_LONG_Data,
	Department_of_Defense_Data_LONG_2020_2021.2), fill=TRUE)

###   Read in BASELINE projections configuration scripts and combine
source("../SGP_CONFIG/2020_2021.2/PART_A/ELA.R")
source("../SGP_CONFIG/2020_2021.2/PART_A/MATHEMATICS.R")

DD_2021_CONFIG_PART_A <- c(
	ELA_2020_2021.2.config,

	MATHEMATICS_2020_2021.2.config,
	ALGEBRA_I_2020_2021.2.config,
	GEOMETRY_2020_2021.2.config,
	ALGEBRA_II_2020_2021.2.config
)

#####
###   Run Baseline Student Growth Percentiles (2021 Part A)
#####

Department_of_Defense_SGP <- abcSGP(
        sgp_object = Department_of_Defense_LONG_Data,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),  ##  Only PART A for DoDEA state-level 2021 analyses
        sgp.config = DD_2021_CONFIG_PART_A,
        sgp.percentiles = TRUE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = FALSE, # No state-level baselines for DoDEA
        sgp.projections.baseline = FALSE,
        sgp.projections.lagged.baseline = FALSE,
				calculate.simex = TRUE,
				save.intermediate.results = FALSE,
				outputSGP.directory="Data/Archive/2020_2021.2",
        outputSGP.output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data"),
        parallel.config = list(
					BACKEND = "PARALLEL",
          WORKERS=list(TAUS = 11, SIMEX = 11))
)

###   Save results
save(Department_of_Defense_SGP, file="./Data/Archive/2020_2021.2/Department_of_Defense_SGP.Rdata")
