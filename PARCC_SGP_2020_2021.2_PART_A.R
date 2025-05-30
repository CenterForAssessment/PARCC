################################################################################
###                                                                          ###
###         PARCC Consortium 2021 (Cohort and Baseline) SGP Analyses         ###
###                                                                          ###
################################################################################

###   Load packages
require(SGP)
require(data.table)

###   Load data from 2020 SGP analyses (with student demographics and new Refid added in 2021)
load("./Data/Archive/2019_2020.2/PARCC_SGP_LONG_Data.Rdata")

###   Load cleaned 2021 LONG data
load("../Illinois/Data/Archive/2020_2021.2/Illinois_Data_LONG_2020_2021.2.Rdata")
load("../Department_Of_Defense/Data/Archive/2020_2021.2/Department_of_Defense_Data_LONG_2020_2021.2.Rdata")
load("../Bureau_of_Indian_Education/Data/Archive/2020_2021.2/Bureau_of_Indian_Education_Data_LONG_2020_2021.2.Rdata")

###   Combine 2021 and prior data
PARCC_LONG_Data <- rbindlist(list(
	PARCC_SGP_LONG_Data,
	Illinois_Data_LONG_2020_2021.2,
	Department_of_Defense_Data_LONG_2020_2021.2,
	Bureau_of_Indian_Education_Data_LONG_2020_2021.2), fill=TRUE)

###   Create SGP object for use with original coefficient matrices
PARCC_SGP <- prepareSGP(PARCC_LONG_Data, state="PARCC", create.additional.variables = FALSE)

##    Load Cohort Referenced Matrices from 2021 (June 2021)
load("./Data/PARCC_Cohort_2021_Matrices.Rdata")
PARCC_SGP@SGP$Coefficient_Matrices <- PARCC_Baseline_2021_Matrices

###   Add single-cohort baseline matrices to SGPstateData
load("./Data/PARCC_Baseline_Matrices.Rdata")
SGPstateData[["PARCC"]][["Baseline_splineMatrix"]][["Coefficient_Matrices"]] <- PARCC_Baseline_Matrices

###   Read in BASELINE projections configuration scripts and combine
source("../SGP_CONFIG/2020_2021.2/PART_A/ELA.R")
source("../SGP_CONFIG/2020_2021.2/PART_A/MATHEMATICS.R")

#####
###   Run Baseline Student Growth Percentiles (2021 Part A)
#####

PARCC_2021_BASELINE_PART_A <- c(
	ELA_2020_2021.2.config,

	MATHEMATICS_2020_2021.2.config,
	ALGEBRA_I_2020_2021.2.config,
	GEOMETRY_2020_2021.2.config,
	ALGEBRA_II_2020_2021.2.config
)

PARCC_SGP <- analyzeSGP(
        sgp_object = PARCC_SGP,
        sgp.config = PARCC_2021_BASELINE_PART_A,
        sgp.percentiles = FALSE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = TRUE,
        sgp.projections.baseline = FALSE,
        sgp.projections.lagged.baseline = FALSE,
				calculate.simex = TRUE,
				calculate.simex.baseline = list(
					lambda=seq(0,2,0.5), simulation.iterations=75, simex.sample.size=10000,
					csem.data.vnames="SCALE_SCORE_CSEM", extrapolation="linear", save.matrices=FALSE,
					simex.use.my.coefficient.matrices=TRUE, use.cohort.for.ranking=FALSE), # use baseline cohort for RANKING!
        parallel.config = list(
					BACKEND = "PARALLEL", WORKERS=list(SIMEX = 25))
)

###  Cohort Referenced

PARCC_2021_COHORT_PART_A <- c(
	ELA_2020_2021.2.config,
	MATHEMATICS_2020_2021.2.config,
	ALGEBRA_II_2020_2021.2.config
)

PARCC_SGP <- analyzeSGP(
        sgp_object = PARCC_SGP,
        sgp.config = PARCC_2021_COHORT_PART_A,
        sgp.percentiles = TRUE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = FALSE,
        sgp.projections.baseline = FALSE,
        sgp.projections.lagged.baseline = FALSE,
				sgp.use.my.coefficient.matrices = TRUE,  ##  Added Nov 2021 with added IL Fall testers and updated/matched IDs from Spring
				calculate.simex = TRUE,
        parallel.config = list(
					BACKEND = "PARALLEL", WORKERS=list(SIMEX = 25))
)


###   Save results
if (!dir.exists("./Data/Archive/2020_2021.2")) dir.create("./Data/Archive/2020_2021.2")
save(PARCC_SGP, file="./Data/Archive/2020_2021.2/PARCC_SGP.Rdata")


###   Original Call to abcSGP

# PARCC_2021_CONFIG_PART_A <- c(
# 	ELA_2020_2021.2.config,
#
# 	MATHEMATICS_2020_2021.2.config,
# 	ALGEBRA_I_2020_2021.2.config,
# 	GEOMETRY_2020_2021.2.config,
# 	ALGEBRA_II_2020_2021.2.config
# )

# PARCC_SGP <- abcSGP(
#         sgp_object = PARCC_LONG_Data,
# 				steps = c("prepareSGP", "analyzeSGP"),
#         sgp.config = PARCC_2021_CONFIG_PART_A,
#         sgp.percentiles = TRUE,
#         sgp.projections = FALSE,
#         sgp.projections.lagged = FALSE,
#         sgp.percentiles.baseline = TRUE,
#         sgp.projections.baseline = FALSE,
#         sgp.projections.lagged.baseline = FALSE,
# 				calculate.simex = TRUE,
# 				calculate.simex.baseline = list(
# 					lambda=seq(0,2,0.5), simulation.iterations=75, simex.sample.size=10000,
# 					csem.data.vnames="SCALE_SCORE_CSEM", extrapolation="linear", save.matrices=FALSE,
# 					simex.use.my.coefficient.matrices=TRUE, use.cohort.for.ranking=FALSE), # use baseline cohort for RANKING!
# 				save.intermediate.results = FALSE,
#         parallel.config = list(
# 					BACKEND = "PARALLEL",
#           WORKERS=list(TAUS = 27, SIMEX = 25))
# )
