#+ include = FALSE, purl = FALSE, eval = FALSE
###############################################################################
###                                                                         ###
###           Consortium 2024 (Cohort and Baseline) SGP Analyses            ###
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


###   Load results data from 2023
load("./Data/Archive/2021_2022.2/PARCC_SGP_LONG_Data_2021_2022.2.Rdata")
load("./Data/Archive/2022_2023.2/PARCC_SGP_LONG_Data_2022_2023.2.Rdata")

###   Load cleaned 2024 LONG data
load("../Illinois/Data/Archive/2023_2024.2/Illinois_Data_LONG_2023_2024.2.Rdata")
load("../New_Jersey/Data/Archive/2023_2024.2/New_Jersey_Data_LONG_2023_2024.2.Rdata")
load("../Department_Of_Defense/Data/Archive/2023_2024.2/Department_of_Defense_Data_LONG_2023_2024.2.Rdata")
load("../Bureau_of_Indian_Education/Data/Archive/2023_2024.2/Bureau_of_Indian_Education_Data_LONG_2023_2024.2.Rdata")
load("../Washington_DC/Data/Archive/2021_2022.2/Washington_DC_Data_LONG_2021_2022.2.Rdata")
load("../Washington_DC/Data/Archive/2023_2024.2/Washington_DC_Data_LONG_2023_2024.2.Rdata")

##    See 2023 Growth layout -- BIE blank if not enrolled in 2022.
##    Now validate as their `StateStudentIdentifier` are non-null
PARCC_SGP_LONG_Data_2022_2023.2[, VALID_CASE := "VALID_CASE"]

##    Combine prior data and cleaned 2024 data
PARCC_Data_LONG <-
    rbindlist(
        list(
            PARCC_SGP_LONG_Data_2021_2022.2[
                !CONTENT_AREA %in% c("ELA_GPA", "MATH_GPA")
            ],
            PARCC_SGP_LONG_Data_2022_2023.2,
            Illinois_Data_LONG_2023_2024.2,
            New_Jersey_Data_LONG_2023_2024.2,
            Department_of_Defense_Data_LONG_2023_2024.2,
            Bureau_of_Indian_Education_Data_LONG_2023_2024.2,
            Washington_DC_Data_LONG_2021_2022.2,
            Washington_DC_Data_LONG_2023_2024.2
        ),
        fill = TRUE
    )

PARCC_Data_LONG[, TEMP_ID := as.character(NA)]
PARCC_Data_LONG[StateAbbreviation %in% c("BI", "DC"), TEMP_ID := ID]
PARCC_Data_LONG[StateAbbreviation %in% c("BI", "DC"), ID := StateStudentIdentifier]

rm(list = grep("2022|2023_2024", ls(), value = TRUE)); gc()

###   Read in configuration scripts and combine
source("../SGP_CONFIG/2023_2024.2/ELA.R")
source("../SGP_CONFIG/2023_2024.2/MATHEMATICS.R")

Consortium_Config_2024 <-
    c(ELA.2024.config,
      ELA_SKIP.2024.config,
      MATHEMATICS.2024.config,
      ALGEBRA_I.2024.config,
      GEOMETRY.2024.config,
      ALGEBRA_II.2024.config
    )


#####
###   2024 Cohort and Baseline Referenced Student Growth Percentiles Analyses
#####

PARCC_SGP <-
    abcSGP(
        sgp_object = PARCC_Data_LONG,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
        sgp.config = Consortium_Config_2024,
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
        outputSGP.directory = "./Data/Archive/2023_2024.2",
        outputSGP.output.type = c("LONG_Data", "LONG_FINAL_YEAR_Data"),
        save.intermediate.results = FALSE,
        parallel.config = list(
            BACKEND = "PARALLEL",
            WORKERS = list(TAUS = 8, SIMEX = 8)
        )
    )

##    Re-set BIE PANUnique and "growth" IDs
# table(PARCC_SGP@Data[!is.na(StateStudentIdentifier), StateStudentIdentifier=="", StateAbbreviation])
# PARCC_SGP@Data[
#   !is.na(TEMP_ID), StateStudentIdentifier := ID
# ][!is.na(TEMP_ID), ID := TEMP_ID
# ][, TEMP_ID := NULL
# ]

###   Add R session info & save results (`cfaDocs` version 0.0-1.12 or later)
source(
    system.file(
        "rmarkdown", "shared_resources", "rmd", "R_Session_Info.R",
        package = "cfaDocs"
    )
)
PARCC_SGP@Version$session_platform <- list("2024" = session_platform)
PARCC_SGP@Version$attached_pkgs <- list("2024" = attached_pkgs)
PARCC_SGP@Version$namespace_pkgs<-  list("2024" = namespace_pkgs)

save(PARCC_SGP, file = "./Data/Archive/2023_2024.2/PARCC_SGP.Rdata")


#' ### Conduct SGP analyses
#'
#' All data analysis is conducted using the [`R` Software Environment](http://www.r-project.org/)
#' in conjunction with the [`SGP` package](http://sgp.io/). Cohort- and
#' baseline-referenced SGPs were calculated concurrently for the 2024
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
#' #### 2024 Growth Analyses
#'
#' SGP analyses were conducted at both the consortium and member/state level. In the
#' 2024 analyses, we calculated "consecutive-year" cohort- and baseline-referenced
#' SGPs for grades 4 through 10 ELA, grades 4 through 8 mathematics, as well as
#' the Algebra 1, Algebra 2 and Geometry EOC assessments. All SGP analysis
#' versions use up to two prior years' scores (2022 and 2023) where available.
#'
#' In the calculation workflow, we first add pre-calculated baseline matrices
#' to the (i.e., "`PARCC`") entry in the `SGPstateData` object.
#' The 2024 configuration scripts were loaded and combined
#' into a single list object that serves to specify the exact analyses to be run.
#'
#' For all analyses we use the [`abcSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.1-0.0/topics/abcSGP)
#' function to ***a)*** format and combine the cleaned spring 2024 data to prior
#' years data ([`prepareSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.1-0.0/topics/prepareSGP)
#' step), ***b)*** calculate 2024 consecutive-year cohort- and baseline-referenced
#' SGP estimates and growth projections ([`analyzeSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.1-0.0/topics/analyzeSGP)
#' step), ***c)*** merge the results into the master
#' longitudinal data set ([`combineSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.1-0.0/topics/combineSGP)
#' step). and ***d)*** save the results in both `.Rdata` and pipe delimited versions
#' ([`outputSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.1-0.0/topics/outputSGP)).
#'
#' The results were submitted after additional formatting, customization and
#' data validation were completed.