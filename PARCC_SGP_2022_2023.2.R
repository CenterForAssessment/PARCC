#+ include = FALSE, purl = FALSE, eval = FALSE
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


#' ### Conduct SGP analyses
#'
#' All data analysis is conducted using the [`R` Software Environment](http://www.r-project.org/)
#' in conjunction with the [`SGP` package](http://sgp.io/). Cohort- and
#' baseline-referenced SGPs were calculated concurrently for the 2023 New Meridian
#' Consortium growth model analyses. Broadly, the analysis takes place using
#' these four steps:
#'
#' 1. `prepareSGP`
#' 2. `analyzeSGP`
#' 3. `combineSGP`
#' 4. `outputSGP`
#'
#' Because these steps are almost always conducted simultaneously, the `SGP`
#' package has "wrapper" functions, `abcSGP` and `updateSGP`, that combine
#' the above steps into a single function call and simplify the source code
#' associated with the data analysis. Documentation for all SGP functions are
#' [available online.](https://cran.r-project.org/web/packages/SGP/SGP.pdf)
#'
#' #### 2023 Growth Analyses
#'
#' SGP analyses were conducted at both the consortium and member/state level. In the
#' 2023 analyses, we calculated "consecutive-year" cohort- and baseline-referenced
#' SGPs for grades 4 through 10 ELA, grades 4 through 8 mathematics, as well as
#' the Algebra 1, Algebra 2 and Geometry EOC assessments. All SGP analysis
#' versions use up to two prior years' scores (i.e. 2021 and 2022) where available.
#'
#' In the calculation workflow, we first add pre-calculated baseline matrices
#' to the New Meridian (i.e. "`PARCC`") entry in the `SGPstateData` object.
#' The 2023 configuration scripts were loaded and combined
#' into a single list object that serves to specify the exact analyses to be run.
#' 
#' For all analyses we use the [`abcSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.1-0.0/topics/abcSGP)
#' function to ***a)*** format and combine the cleaned spring 2023 data to prior
#' years data ([`prepareSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.1-0.0/topics/prepareSGP)
#' step), ***b)*** calculate 2023 consecutive-year cohort- and baseline-referenced
#' SGP estimates and growth projections ([`analyzeSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.1-0.0/topics/analyzeSGP)
#' step), ***c)*** merge the results into the master
#' longitudinal data set ([`combineSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.1-0.0/topics/combineSGP)
#' step). and ***d)*** save the results in both `.Rdata` and pipe delimited versions
#' ([`outputSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.1-0.0/topics/outputSGP)
#'
#' The results were submitted after additional formatting, customization
#' and data validation were completed.