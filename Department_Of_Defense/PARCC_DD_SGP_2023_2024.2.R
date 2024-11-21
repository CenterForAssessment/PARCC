#+ include = FALSE, purl = FALSE, eval = FALSE
###############################################################################
###                                                                         ###
###      Department of Defense 2024 (Cohort and Baseline) SGP Analyses      ###
###                                                                         ###
###############################################################################

###   Load packages
require(SGP)
require(data.table)

###   Load data from previous SGP analyses
load("./Data/Archive/2021_2022.2/Department_of_Defense_SGP_LONG_Data_2021_2022.2.Rdata")
load("./Data/Archive/2022_2023.2/Department_of_Defense_SGP_LONG_Data_2022_2023.2.Rdata")
load("./Data/Archive/2023_2024.2/Department_of_Defense_Data_LONG_2023_2024.2.Rdata")

Department_of_Defense_Data_LONG <-
    rbindlist(
        list(
            Department_of_Defense_SGP_LONG_Data_2021_2022.2,
            Department_of_Defense_SGP_LONG_Data_2022_2023.2,
            Department_of_Defense_Data_LONG_2023_2024.2
        ),
        fill = TRUE
    )


###   Modify `SGPstateData`
##    Add baseline coefficient matrices directly rather than using `SGPmatrices`
##    due to SIMEX matrices size.
load("./Data/Archive/Department_of_Defense_Baseline_Matrices.Rdata")
SGPstateData[["DD"]][["Baseline_splineMatrix"]][["Coefficient_Matrices"]] <-
    Department_of_Defense_Baseline_Matrices


###   Read in SGP configuration scripts and combine
# source("../SGP_CONFIG/2023_2024.2/ELA.R")
# source("../SGP_CONFIG/2023_2024.2/MATHEMATICS.R")

##  Trim anything with ELA 9th grade
ELA.2024.config[["ELA.2024"]][["sgp.grade.sequences"]] <-
  ELA.2024.config[["ELA.2024"]][["sgp.grade.sequences"]][-(6:7)]

DD_Config_2024 <-
    c(ELA.2024.config, # Trimmed above
      ELA_SKIP.2024.config, # 10th grade
      MATHEMATICS.2024.config,
      ALGEBRA_I.2024.config,
      GEOMETRY.2024.config,
      ALGEBRA_II.2024.config
    )

###   Run Cohort Referenced Student Growth Percentiles

Department_of_Defense_SGP <-
    abcSGP(
        sgp_object = Department_of_Defense_Data_LONG,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
        sgp.config = DD_Config_2024,
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
            WORKERS = list(TAUS = 11, SIMEX = 11)
        )
    )

###   Add R session info & save results (`cfaDocs` version 0.0-1.12 or later)
source(
    system.file(
        "rmarkdown", "shared_resources", "rmd", "R_Session_Info.R",
        package = "cfaDocs"
    )
)
Department_of_Defense_SGP@Version$session_platform <-
    list("2024" = session_platform)
Department_of_Defense_SGP@Version$attached_pkgs <-
    list("2024" = attached_pkgs)
Department_of_Defense_SGP@Version$namespace_pkgs<-
    list("2024" = namespace_pkgs)

save(Department_of_Defense_SGP,
     file = "./Data/Archive/2023_2024.2/Department_of_Defense_SGP.Rdata"
)


#' ### Conduct SGP analyses
#'
#' All data analysis is conducted using the [`R` Software Environment](http://www.r-project.org/)
#' in conjunction with the [`SGP` package](http://sgp.io/). Cohort- and
#' baseline-referenced SGPs were calculated concurrently for the 2024 Department of Defense
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
#' SGP analyses were conducted at both the consortium and member/state level. In
#' the 2024 analyses, "consecutive-year" cohort-referenced SGPs were calculated
#' for grades 4 through 8 mathematics and ELA, the Algebra I, Geometry and Algebra II
#' EOC assessments, as well as "skipped-year" growth for grade 10 ELA (using 2022
#' grade 8 test scores). Due to differences in pre-pandemic test administration
#' patterns by grade and subject, baseline-referenced growth using only DoDEA
#' students as the reference norm groups are restricted to mathematics grades 4 - 6,
#' ELA grades 7 - 8, Geometry and Algebra II. However, students in those omitted
#' grades and subjects may have had baseline SGPs calculated using consortium
#' growth norms. Also note that the DoDEA baseline SGPs use only a single prior
#' score since pre-pandemic CCRS Summative Assessment data is only available for
#' 2018 and 2019.
#' 
#' In the calculation workflow, we first add pre-calculated baseline matrices
#' to the Department of Defense Education Activity's (i.e., "`DD`") entry in the
#' `SGPstateData` object. The 2024 configuration scripts were loaded and combined
#' into a single list object that serves to specify the exact analyses to be run.
#'
#' For all analyses we use the [`abcSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.1-0.0/topics/abcSGP)
#' function to ***a)*** format and combine the cleaned spring 2024 data to prior
#' years data ([`prepareSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.1-0.0/topics/prepareSGP)
#' step), ***b)*** calculate 2024 consecutive-year cohort- and baseline-referenced
#' SGP estimates and growth projections([`analyzeSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.1-0.0/topics/analyzeSGP)
#' step), ***c)*** merge the results into the master
#' longitudinal data set ([`combineSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.1-0.0/topics/combineSGP)
#' step). and ***d)*** save the results in both `.Rdata` and pipe delimited versions
#' ([`outputSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.1-0.0/topics/outputSGP)).
#'
#' The results were submitted after additional formatting, customization and
#' data validation were completed.


#+ include = FALSE, purl = FALSE, eval = FALSE
##    DON'T USE !!!!!

## the problem => SGPstateData[["DD"]][["SGP_Configuration"]][["use.cohort.for.baseline.when.missing"]] <- TRUE
# ls() # XXX

# load('./Data/Archive/2023_2024.2/Department_of_Defense_SGP.Rdata')
# table(Department_of_Defense_SGP@Data[, .(is.na(SGP), YEAR), !is.na(SGP_ORDER_2_0.05_CONFIDENCE_BOUND)]) # TRUE x TRUE is BAD*2

# Department_of_Defense_SGP@Data <- Department_of_Defense_Data_LONG
# setkeyv(Department_of_Defense_SGP@Data, SGP:::getKey(Department_of_Defense_SGP@Data))

# Department_of_Defense_SGP <-
#     combineSGP(
#         sgp_object = Department_of_Defense_SGP,
#         sgp.percentiles = TRUE,
#         sgp.projections = TRUE,
#         sgp.projections.lagged = TRUE,
#         sgp.percentiles.baseline = TRUE,
#         sgp.projections.baseline = TRUE,
#         sgp.projections.lagged.baseline = TRUE
#     )

# table(Department_of_Defense_SGP@Data[, is.na(SGP), !is.na(SGP_ORDER_2_0.05_CONFIDENCE_BOUND)])
# # table(slot.data[, is.na(SGP), !is.na(SGP_ORDER_2_0.05_CONFIDENCE_BOUND)])
