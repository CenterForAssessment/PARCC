#+ include = FALSE, purl = FALSE, eval = FALSE
###############################################################################
###                                                                         ###
###          Washington_DC 2025 (Cohort and Baseline) SGP Analyses          ###
###                                                                         ###
###############################################################################

###   Load packages
require(SGP)
require(data.table)

###   Setup `SGPstateData` with baseline coefficient matrices
###   Add directly rather than using `SGPmatrices` due to SIMEX matrices size.
###   Use the "2024" baselines per Pearson/OSSE email 6/11/25

load("./Data/Archive/Washington_DC_Baseline_Matrices-2024.Rdata")
# Washington_DC_Baseline_Matrices$ALGEBRA_I.BASELINE.SIMEX[[1]][["ranked_simex_table"]] <-
# Washington_DC_Baseline_Matrices$ALGEBRA_I.BASELINE.SIMEX[[1]][["ranked_simex_table"]][-1]
SGPstateData[["DC"]][["Baseline_splineMatrix"]][["Coefficient_Matrices"]] <-
    Washington_DC_Baseline_Matrices

#####
###   Cohort and Baseline SGP Analyses
#####

###   Load required LONG data
load("./Data/Archive/2022_2023.2/Washington_DC_SGP_LONG_Data_2022_2023.2.Rdata")
load("./Data/Archive/2023_2024.2/Washington_DC_SGP_LONG_Data_2023_2024.2.Rdata")
load("./Data/Archive/2024_2025.2/Washington_DC_Data_LONG_2024_2025.2.Rdata")

##    Use `StateStudentIdentifier` per Pearson/OSSE April 2024 & Growth Layout
setnames(
    Washington_DC_SGP_LONG_Data_2022_2023.2,
    c("StateStudentIdentifier", "ID"),
    c("ID", "PANUniqueStudentID")
)

Washington_DC_Data_LONG <-
    rbindlist(
        list(
          Washington_DC_SGP_LONG_Data_2022_2023.2,
          Washington_DC_SGP_LONG_Data_2023_2024.2,
          Washington_DC_Data_LONG_2024_2025.2
        ),
        fill = TRUE
    )

rm(list =
    c("Washington_DC_Baseline_Matrices",
      "Washington_DC_SGP_LONG_Data_2022_2023.2",
      "Washington_DC_SGP_LONG_Data_2023_2024.2",
      "Washington_DC_Data_LONG_2024_2025.2"
    )
);gc()


###   Create analysis configurations

##    Read in configuration scripts and combine
source("../SGP_CONFIG/2024_2025.2/ELA.R")
source("../SGP_CONFIG/2024_2025.2/MATHEMATICS.R")

DC_Config_2025 <-
    c(ELA.2025.config,
      MATHEMATICS.2025.config,
      ALGEBRA_I.2025.config,
      GEOMETRY.2025.config#,
      # ALGEBRA_II.2025.config # Do not add when calculating baseline growth concurrently
    )


###   Run Cohort AND Baseline Referenced Student Growth Percentiles

Washington_DC_SGP <-
    abcSGP(
        sgp_object = Washington_DC_Data_LONG,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
        sgp.config = DC_Config_2025,
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
            save.matrices = FALSE, use.cohort.for.ranking = FALSE),
        save.intermediate.results = FALSE,
        outputSGP.directory = "Data/Archive/2024_2025.2",
        outputSGP.output.type = c("LONG_Data", "LONG_FINAL_YEAR_Data"),
        parallel.config = list(
            BACKEND = "PARALLEL",
            WORKERS = list(
                TAUS = 11, SIMEX = 11,
                PROJECTIONS = 8, LAGGED_PROJECTIONS = 4
            )
        )
    )
        # NOTE: Baseline coefficient matrices are not available for:
        #         ALGEBRA_I: MATHEMATICS 6 --> ALGEBRA_I;
        #         ALGEBRA_I: GEOMETRY --> ALGEBRA_I;
        #         GEOMETRY: ALGEBRA_II --> GEOMETRY;
        #         GEOMETRY: MATHEMATICS 5 --> GEOMETRY;
        #         GEOMETRY: MATHEMATICS 6 --> GEOMETRY;
        #         GEOMETRY: MATHEMATICS 7 --> GEOMETRY;
        #         GEOMETRY: MATHEMATICS 8 --> GEOMETRY.

###   Add R session info & save results (`cfaDocs` version 0.0-1.12 or later)
source(
    system.file(
        "rmarkdown", "shared_resources", "rmd", "R_Session_Info.R",
        package = "cfaDocs"
    )
)

Washington_DC_SGP@Version[["session_platform"]][["2025"]] <- session_platform
Washington_DC_SGP@Version[["attached_pkgs"]][["2025"]]    <- attached_pkgs
Washington_DC_SGP@Version[["namespace_pkgs"]][["2025"]]   <- namespace_pkgs

save(Washington_DC_SGP, file = "./Data/Archive/2024_2025.2/Washington_DC_SGP.Rdata")


#' ### Conduct SGP analyses
#'
#' All data analysis is conducted using the [`R` Software Environment](http://www.r-project.org/)
#' in conjunction with the [`SGP` package](http://sgp.io/). Cohort- and
#' baseline-referenced SGPs were calculated concurrently for the 2025 Washington DC
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
#' The 2025 SGP analyses were conducted at both the consortium and member/state
#' level. We calculated "consecutive-year" cohort- and baseline-referenced
#' SGPs for grades 4 through 10 ELA, grades 4 through 8 mathematics, as well as
#' the Algebra 1 and Geometry EOC assessments. There were no viable Algebra 2
#' analyses for 2025 with DC only data, although those students with Algebra 2
#' scores may have had growth calculated at the Consortium level. The 2025
#' baseline SGP analysis versions use a single prior year score (2024 where
#' available) as the baseline norm groups are the 2024 cohorts, which only have
#' as single prior available since DC assessments did not resume until 2023.
#' The 2025 cohort-referenced SGP analyses use up to two prior years' scores
#' (2023 and 2024) where available.
#'
#' In the calculation workflow, we first add pre-calculated baseline matrices
#' to the Washington DC (i.e., "`DC`") entry in the `SGPstateData` object.
#' The 2025 configuration scripts were loaded and combined into a single list
#' object that serves to specify the exact analyses to be run.
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