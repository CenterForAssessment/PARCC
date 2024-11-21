#+ include = FALSE, purl = FALSE, eval = FALSE
###############################################################################
###                                                                         ###
###   Bureau of Indian Education 2024 (Cohort and Baseline) SGP Analyses    ###
###                                                                         ###
###############################################################################

###   Load packages
require(SGP)
require(data.table)

###   Load historical growth and cleaned 2024 LONG data
load("./Data/Archive/2021_2022.2/Bureau_of_Indian_Education_SGP_LONG_Data_2021_2022.2.Rdata")
load("./Data/Archive/2022_2023.2/Bureau_of_Indian_Education_SGP_LONG_Data_2022_2023.2.Rdata")
load("./Data/Archive/2023_2024.2/Bureau_of_Indian_Education_Data_LONG_2023_2024.2.Rdata")

##    See 2023 Growth layout -- Blank if not enrolled in 2022.
##    Now validate as their `StateStudentIdentifier` are non-null
Bureau_of_Indian_Education_SGP_LONG_Data_2022_2023.2[, VALID_CASE := "VALID_CASE"]
Bureau_of_Indian_Education_SGP_LONG_Data_2022_2023.2[, PANUniqueStudentID := NULL]

Bureau_of_Indian_Education_Data_LONG <-
    rbindlist(
        list(
            Bureau_of_Indian_Education_SGP_LONG_Data_2021_2022.2,
            Bureau_of_Indian_Education_SGP_LONG_Data_2022_2023.2,
            Bureau_of_Indian_Education_Data_LONG_2023_2024.2
        ),
        fill = TRUE
    )
setnames(
    Bureau_of_Indian_Education_Data_LONG,
    c("StateStudentIdentifier", "ID"), # 2024
    c("ID", "PANUniqueStudentID")
)


# Bureau_of_Indian_Education_Data_LONG |>
#     setkey(VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID, SCALE_SCORE) |>
#     setkey(VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID)
# dupl <- duplicated(
#             Bureau_of_Indian_Education_Data_LONG,
#             by = key(Bureau_of_Indian_Education_Data_LONG)
#         )
# table(dupl) # 0 in 2022 - 2024
# dups <- Bureau_of_Indian_Education_Data_LONG[c(which(dupl)-1, which(dupl)), ]
# setkeyv(dups, key(Bureau_of_Indian_Education_Data_LONG))
# Bureau_of_Indian_Education_Data_LONG[which(dupl), VALID_CASE := "INVALID_CASE"]

##    Make sure YEAR is correct format!
# table(Bureau_of_Indian_Education_Data_LONG$YEAR)


###   Modify `SGPstateData`
##    Add baseline coefficient matrices directly rather than using `SGPmatrices`
##    due to SIMEX matrices size.
load("./Data/Archive/Bureau_of_Indian_Education_Baseline_Matrices.Rdata")
SGPstateData[["BI"]][["Baseline_splineMatrix"]][["Coefficient_Matrices"]] <-
    Bureau_of_Indian_Education_Baseline_Matrices


###   Read in SGP configuration scripts and combine
source("../SGP_CONFIG/2023_2024.2/ELA.R")
source("../SGP_CONFIG/2023_2024.2/MATHEMATICS.R")

##  Trim anything above ELA 8th grade
ELA.2024.config[["ELA.2024"]][["sgp.grade.sequences"]] <-
  ELA.2024.config[["ELA.2024"]][["sgp.grade.sequences"]][-(6:7)]

BIE_Config_2024 <-
    c(ELA.2024.config,  #  Trimmed
      MATHEMATICS.2024.config
    #   ALGEBRA_I.2024.config,
    #   GEOMETRY.2024.config,
    #   ALGEBRA_II.2024.config
    )

###   Run Cohort and Baseline Referenced Student Growth Percentiles

Bureau_of_Indian_Education_SGP <-
    abcSGP(
        sgp_object = Bureau_of_Indian_Education_Data_LONG,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
        sgp.config = BIE_Config_2024,
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
                TAUS = 11, SIMEX = 11
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
Bureau_of_Indian_Education_SGP@Version$session_platform <-
    list("2024" = session_platform)
Bureau_of_Indian_Education_SGP@Version$attached_pkgs <-
    list("2024" = attached_pkgs)
Bureau_of_Indian_Education_SGP@Version$namespace_pkgs<-
    list("2024" = namespace_pkgs)

save(Bureau_of_Indian_Education_SGP,
     file = "./Data/Archive/2023_2024.2/Bureau_of_Indian_Education_SGP.Rdata"
)


#' ### Conduct SGP analyses
#'
#' All data analysis is conducted using the [`R` Software Environment](http://www.r-project.org/)
#' in conjunction with the [`SGP` package](http://sgp.io/). Cohort- and
#' baseline-referenced SGPs were calculated concurrently for the `r params$report.year` Department of Defense
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
#' #### `r params$report.year` Growth Analyses
#'
#' SGP analyses were conducted at both the consortium and member level. In the
#' `r params$report.year` analyses, we calculated "consecutive-year" cohort- and baseline-referenced
#' SGPs for grades 4 through 8 in ELA and mathematics using strictly BIE data.
#' There were no viable EOC or high school ELA analyses for `r params$report.year` with BIE only data,
#' although those students with valid assessment scores may have had growth
#' calculated at the consortium level.
#'
#' In the calculation workflow, we first add pre-calculated baseline matrices
#' to the Bureau of Indian Education's (i.e., "`BI`") entry in the
#' `SGPstateData` object. The `r params$report.year` configuration scripts were loaded and combined
#' into a single list object that serves to specify the exact analyses to be run.
#'
#' For all analyses we use the [`abcSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.1-0.0/topics/abcSGP)
#' function to ***a)*** format and combine the cleaned spring `r params$report.year` data to prior
#' years data ([`prepareSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.1-0.0/topics/prepareSGP)
#' step), ***b)*** calculate `r params$report.year` consecutive-year cohort- and baseline-referenced
#' SGP estimates and growth projections([`analyzeSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.1-0.0/topics/analyzeSGP)
#' step), ***c)*** merge the results into the master
#' longitudinal data set ([`combineSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.1-0.0/topics/combineSGP)
#' step). and ***d)*** save the results in both `.Rdata` and pipe delimited versions
#' ([`outputSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.1-0.0/topics/outputSGP)).
#'
#' The results were submitted after additional formatting, customization and
#' data validation were completed.
