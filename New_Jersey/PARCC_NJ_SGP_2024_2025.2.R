#+ include = FALSE, purl = FALSE, eval = FALSE
###############################################################################
###                                                                         ###
###            New_Jersey 2025 (Cohort and Baseline) SGP Analyses           ###
###                                                                         ###
###############################################################################

###   Load packages
require(SGP)
require(data.table)

###   Load required LONG data
load("./Data/Archive/2022_2023.2/New_Jersey_SGP_LONG_Data_2022_2023.2.Rdata")
load("./Data/Archive/2023_2024.2/New_Jersey_SGP_LONG_Data_2023_2024.2.Rdata")
load("./Data/Archive/2024_2025.2/New_Jersey_Data_LONG_2024_2025.2.Rdata")

New_Jersey_Data_LONG <-
    rbindlist(
        list(
            New_Jersey_SGP_LONG_Data_2022_2023.2,
            New_Jersey_SGP_LONG_Data_2023_2024.2,
            New_Jersey_Data_LONG_2024_2025.2
        ),
        fill = TRUE
    )

###   Setup `SGPstateData` with baseline coefficient matrices
###   Add directly rather than using `SGPmatrices` due to SIMEX matrices size.
load("./Data/Archive/New_Jersey_Baseline_Matrices.Rdata")
SGPstateData[["NJ"]][["Baseline_splineMatrix"]][["Coefficient_Matrices"]] <-
    New_Jersey_Baseline_Matrices

###   Clean up a bit
rm(list =
    c("New_Jersey_Baseline_Matrices",
      "New_Jersey_SGP_LONG_Data_2022_2023.2",
      "New_Jersey_SGP_LONG_Data_2023_2024.2",
      "New_Jersey_Data_LONG_2024_2025.2"
    )
); gc()

#####
###   Cohort- and Baseline-referenced SGP Analyses
#####

###   Read in configuration scripts and combine
source("../SGP_CONFIG/2024_2025.2/ELA.R")
source("../SGP_CONFIG/2024_2025.2/MATHEMATICS.R")

###   Create analysis configurations
NJ_Config_2025 <-
    c(ELA.2025.config,
      MATHEMATICS.2025.config,
      ALGEBRA_I.2025.config,
      GEOMETRY.2025.config,
      ALGEBRA_II.2025.config
    )

###   Calculate All Student Growth Percentiles and Projections
New_Jersey_SGP <-
    abcSGP(
        sgp_object = New_Jersey_Data_LONG,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
        sgp.config = NJ_Config_2025,
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
        outputSGP.directory = "Data/Archive/2024_2025.2",
        outputSGP.output.type = c("LONG_Data", "LONG_FINAL_YEAR_Data"),
        save.intermediate.results = FALSE,
        parallel.config = list(
            BACKEND = "PARALLEL",
            WORKERS = list(
                TAUS = 11, SIMEX = 11,
                PROJECTIONS = 8, LAGGED_PROJECTIONS = 4
            )
        )
    )
        # NOTE: Baseline coefficient matrices are not available for:
        #         ALGEBRA_I: GEOMETRY --> ALGEBRA_I;
        #         GEOMETRY: MATHEMATICS 5 --> GEOMETRY;
        #         GEOMETRY: MATHEMATICS 6 --> GEOMETRY;
        #         GEOMETRY: MATHEMATICS 7 --> GEOMETRY;
        #         GEOMETRY: MATHEMATICS 8 --> GEOMETRY;
        #         ALGEBRA_II: MATHEMATICS 6 --> ALGEBRA_II;
        #         ALGEBRA_II: MATHEMATICS 7 --> ALGEBRA_II;
        #         ALGEBRA_II: MATHEMATICS 8 --> ALGEBRA_II.

###   Add R session info & save results (`cfaDocs` version 0.0-1.12 or later)
source(
    system.file(
        "rmarkdown", "shared_resources", "rmd", "R_Session_Info.R",
        package = "cfaDocs"
    )
)
New_Jersey_SGP@Version[["session_platform"]][["2025"]] <- session_platform
New_Jersey_SGP@Version[["attached_pkgs"]][["2025"]]    <- attached_pkgs
New_Jersey_SGP@Version[["namespace_pkgs"]][["2025"]]   <- namespace_pkgs

save(New_Jersey_SGP, file = "./Data/Archive/2024_2025.2/New_Jersey_SGP.Rdata")



#' ### Conduct SGP analyses
#'
#' All data analysis is conducted using the [`R` Software Environment](http://www.r-project.org/)
#' in conjunction with the [`SGP` package](http://sgp.io/). Cohort- and
#' baseline-referenced SGPs were calculated concurrently for the 2025 New Jersey
#' growth model analyses. Broadly, the analysis takes place using these four steps:
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
#' #### 2025 Growth Analyses
#'
#' SGP analyses were conducted at both the consortium and member/state level. In the
#' 2025 analyses, we calculated "consecutive-year" cohort- and baseline-referenced
#' SGPs for grades 4 through 9 ELA, grades 4 through 8 mathematics, as well as
#' the Algebra I, Geometry and Algebra II EOC assessments.
#'
#' In the calculation workflow, we first add pre-calculated baseline matrices
#' to the New Jersey (i.e., "`NJ`") entry in the `SGPstateData` object.
#' The 2025 configuration scripts were loaded and combined
#' into a single list object that serves to specify the exact analyses to be run.
#'
#' For all analyses we use the [`abcSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.1-0.0/topics/abcSGP)
#' function to ***a)*** format and combine the cleaned spring 2025 data to prior
#' years data ([`prepareSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.1-0.0/topics/prepareSGP)
#' step), ***b)*** calculate 2025 consecutive-year cohort- and baseline-referenced
#' SGP estimates and growth projections([`analyzeSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.1-0.0/topics/analyzeSGP)
#' step), ***c)*** merge the results into the master
#' longitudinal data set ([`combineSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.1-0.0/topics/combineSGP)
#' step). and ***d)*** save the results in both `.Rdata` and pipe delimited versions
#' ([`outputSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.1-0.0/topics/outputSGP)).
#'
#' The results were submitted after additional formatting, customization
#' and data validation were completed.