#+ include = FALSE, purl = FALSE, eval = FALSE
###############################################################################
###                                                                         ###
###            Illinois 2024 (Cohort and Baseline) SGP Analyses             ###
###                                                                         ###
###############################################################################

###   Load packages
require(SGP)
require(data.table)

###   Setup `SGPstateData` with baseline coefficient matrices
###   Add directly rather than using `SGPmatrices` due to SIMEX matrices size.
load("./Data/Archive/Illinois_Baseline_Matrices.Rdata")
SGPstateData[["IL"]][["Baseline_splineMatrix"]][["Coefficient_Matrices"]] <-
    Illinois_Baseline_Matrices

#####
###   Cohort and Baseline SGP Analyses
#####

###   Load required LONG data
load("./Data/Archive/2021_2022.2/Illinois_Data_LONG_2021_2022.2.Rdata")
load("./Data/Archive/2022_2023.2/Illinois_Data_LONG_2022_2023.2.Rdata")
load("./Data/Archive/2023_2024.2/Illinois_Data_LONG_2023_2024.2.Rdata")

Illinois_Data_LONG <-
    rbindlist(
        list(
            Illinois_Data_LONG_2021_2022.2,
            Illinois_Data_LONG_2022_2023.2,
            Illinois_Data_LONG_2023_2024.2
        ),
        fill = TRUE
    )

rm(list = c("Illinois_Data_LONG_2021_2022.2",
            "Illinois_Data_LONG_2022_2023.2",
            "Illinois_Data_LONG_2023_2024.2")
)

###   Create analysis configurations

IL_Config_2024 <- c(
    list(
        ELA.2023_2024.2 = list(
            sgp.content.areas = rep("ELA", 3),
            sgp.panel.years = c("2021_2022.2", "2022_2023.2", "2023_2024.2"),
            sgp.grade.sequences = list(
                c("3", "4"), c("3", "4", "5"),
                c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8"))
        )),
    list(
        MATHEMATICS.2023_2024.2 = list(
            sgp.content.areas = rep("MATHEMATICS", 3),
            sgp.panel.years = c("2021_2022.2", "2022_2023.2", "2023_2024.2"),
            sgp.grade.sequences = list(
                c("3", "4"), c("3", "4", "5"),
                c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8")
            )
        ))
)


###   Run Cohort and Baseline Referenced Student Growth Percentiles

Illinois_SGP <-
    abcSGP(
        sgp_object = Illinois_Data_LONG,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
        sgp.config = IL_Config_2024,
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
        outputSGP.directory = "Data/Archive/2023_2024.2",
        outputSGP.output.type = c("LONG_Data", "LONG_FINAL_YEAR_Data"),
        parallel.config = list(
            BACKEND = "PARALLEL",
            WORKERS = list(
                TAUS = 11, SIMEX = 11,
                PROJECTIONS = 6,
                LAGGED_PROJECTIONS = 4
            )
        )
    )

###   Add R session info & save results (`cfaDocs` version 0.0-1.12 or later)
source(
    system.file(
        "rmarkdown", "shared_resources", "rmd", "R_Session_Info.R",
        package = "cfaDocs"
    )
)
Illinois_SGP@Version$session_platform <- list("2024" = session_platform)
Illinois_SGP@Version$attached_pkgs <- list("2024" = attached_pkgs)
Illinois_SGP@Version$namespace_pkgs<-  list("2024" = namespace_pkgs)

save(Illinois_SGP, file = "./Data/Archive/2023_2024.2/Illinois_SGP.Rdata")


#' ### Conduct SGP analyses
#'
#' All data analysis is conducted using the [`R` Software Environment](http://www.r-project.org/)
#' in conjunction with the [`SGP` package](http://sgp.io/). Cohort- and
#' baseline-referenced SGPs were calculated concurrently for the 2024 Illinois
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
#' #### 2024 Growth Analyses
#'
#' The 2024 SGP analyses were conducted at both the consortium and member/state level.
#' For Illinois, we calculated "consecutive-year" cohort- and baseline-referenced
#' SGPs for grades 4 through 8 ELA and mathematics. All SGP analyses calculate
#' both uncorrected and SIMEX measurement corrected growth measures, resulting
#' in four "versions" of the SGP growth metric using the same student data. All
#' versions include up to two prior years' scores (2022 and 2023) where available.
#'
#' In the calculation workflow, we first add pre-calculated baseline matrices
#' to the Illinois (i.e., "`IL`") entry in the `SGPstateData` object.
#' The 2024 configuration scripts were loaded and combined into a single list
#' object that serves to specify the exact analyses to be run.
#' 
#' For all analyses we use the [`abcSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.1-0.0/topics/abcSGP)
#' function to ***a)*** format the the cleaned spring 2024 data according to the `SGP`
#' package conventions and combine it with Illinois' two most recent prior years data
#' (the [`prepareSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.1-0.0/topics/prepareSGP)
#' step), ***b)*** calculate 2024 consecutive-year cohort- and baseline-referenced
#' SGP estimates and growth projections
#' ([`analyzeSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.1-0.0/topics/analyzeSGP)
#' step), ***c)*** merge the results into the master longitudinal data set
#' ([`combineSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.1-0.0/topics/combineSGP)
#' step). and ***d)*** save the results in both `.Rdata` and pipe delimited versions
#' ([`outputSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.1-0.0/topics/outputSGP)).
#'
#' The results were submitted after additional formatting, customization
#' and data validation were completed.