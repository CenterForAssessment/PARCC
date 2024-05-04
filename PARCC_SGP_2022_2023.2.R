###############################################################################
###                                                                         ###
###          New Meridian 2023 (Cohort and Baseline) SGP Analyses           ###
###                                                                         ###
###############################################################################

###   Load packages
require(data.table)
require(SGP)

###   Setup `SGPstateData` with baseline coefficient matrices
###   Add directly rather than using `SGPmatrices` due to SIMEX matrices size.
load("./Data/Archive/PARCC_Baseline_Matrices.Rdata")
PARCC_Baseline_Matrices$ALGEBRA_I.BASELINE.SIMEX[[1]][["ranked_simex_table"]] <-
PARCC_Baseline_Matrices$ALGEBRA_I.BASELINE.SIMEX[[1]][["ranked_simex_table"]][-1]
SGPstateData[["PARCC"]][["Baseline_splineMatrix"]][["Coefficient_Matrices"]] <-
    PARCC_Baseline_Matrices

##    Modify projections sequences for ELA
SGPstateData[["PARCC"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ELA"]] <-
    c("3", "4", "5", "6", "7", "8", "9", "10")
SGPstateData[["PARCC"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ELA"]] <-
    rep("ELA", 8)
SGPstateData[["PARCC"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ELA"]] <-
    rep(1L, 7)


###   Load results data from 2022
load("./Data/Archive/2020_2021.2/PARCC_SGP_LONG_Data_2020_2021.2.Rdata")
load("./Data/Archive/2021_2022.2/PARCC_SGP_LONG_Data_2021_2022.2.Rdata")

###   Load cleaned 2023 LONG data
load("../Illinois/Data/Archive/2022_2023.2/Illinois_Data_LONG_2022_2023.2.Rdata")
load("../New_Jersey/Data/Archive/2022_2023.2/New_Jersey_Data_LONG_2022_2023.2.Rdata")
load("../Department_Of_Defense/Data/Archive/2022_2023.2/Department_of_Defense_Data_LONG_2022_2023.2.Rdata")
load("../Bureau_of_Indian_Education/Data/Archive/2022_2023.2/Bureau_of_Indian_Education_Data_LONG_2022_2023.2.Rdata")
load("../Washington_DC/Data/Archive/2021_2022.2/Washington_DC_Data_LONG_2021_2022.2.Rdata")
load("../Washington_DC/Data/Archive/2022_2023.2/Washington_DC_Data_LONG_2022_2023.2.Rdata")

setnames(
    Bureau_of_Indian_Education_Data_LONG_2022_2023.2,
    c("ID", "growthIdentifier"),
    c("PAN_USID_BIE", "ID")
)

##    See 2023 Growth layout -- Blank if not enrolled in 2022.
##    Invalidate due to duplicate cases and subsequent errors.
#     DoDEA also has growthIdentifier field, but all values == "" (blank)
Bureau_of_Indian_Education_Data_LONG_2022_2023.2[
    ID == "", VALID_CASE := "INVALID_CASE"
]

##    Combine prior data and cleaned 2023 data
PARCC_Data_LONG <-
    rbindlist(
        list(
            PARCC_SGP_LONG_Data_2020_2021.2,
            PARCC_SGP_LONG_Data_2021_2022.2[
                !CONTENT_AREA %in% c("ELA_GPA", "MATH_GPA")
            ],
            Illinois_Data_LONG_2022_2023.2,
            New_Jersey_Data_LONG_2022_2023.2,
            Department_of_Defense_Data_LONG_2022_2023.2,
            Bureau_of_Indian_Education_Data_LONG_2022_2023.2,
            Washington_DC_Data_LONG_2021_2022.2,
            Washington_DC_Data_LONG_2022_2023.2
        ),
        fill = TRUE
    )

rm(list = grep("2021|2022_2023", ls(), value = TRUE)); gc()

###   Read in configuration scripts and combine
source("../SGP_CONFIG/2022_2023.2/ELA.R")
source("../SGP_CONFIG/2022_2023.2/MATHEMATICS.R")

All_Config_2023 <-
    c(ELA.2023.config,
      MATHEMATICS.2023.config,
      ALGEBRA_I.2023.config,
      GEOMETRY.2023.config,
      ALGEBRA_II.2023.config
    )


#####
###   2023 Cohort and Baseline Referenced Student Growth Percentiles Analyses
#####

PARCC_SGP <-
    abcSGP(
        sgp_object = PARCC_Data_LONG,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP"),
        sgp.config = All_Config_2023,
        sgp.percentiles = TRUE,
        sgp.projections = TRUE,
        sgp.projections.lagged = TRUE,
        sgp.percentiles.baseline = TRUE,
        sgp.projections.baseline = TRUE,
        sgp.projections.lagged.baseline = TRUE,
        calculate.simex = TRUE,
        calculate.simex.baseline = list(
            lambda = seq(0, 2, 0.5), simulation.iterations = 75,
            simex.sample.size = 10000, csem.data.vnames = "SCALE_SCORE_CSEM",
            extrapolation = "linear", simex.use.my.coefficient.matrices = TRUE,
            save.matrices = FALSE, use.cohort.for.ranking = FALSE
        ),
        save.intermediate.results = FALSE,
        parallel.config = list(
            BACKEND = "PARALLEL",
            WORKERS = list(TAUS = 8, SIMEX = 8)
        )
    )

##    Re-set BIE PANUnique and "growth" IDs
# table(PARCC_SGP@Data[!is.na(growthIdentifier), growthIdentifier=="", StateAbbreviation])
PARCC_SGP@Data[
  !is.na(PAN_USID_BIE), growthIdentifier := ID
][!is.na(PAN_USID_BIE), ID := PAN_USID_BIE
][, PAN_USID_BIE := NULL
]

outputSGP(
    sgp_object = PARCC_SGP,
    outputSGP.directory = "Data/Archive/2022_2023.2",
    output.type = c("LONG_Data", "LONG_FINAL_YEAR_Data")
)

###   Save results
save(PARCC_SGP, file = "./Data/Archive/2022_2023.2/PARCC_SGP.Rdata")
