###############################################################################
###                                                                         ###
###   Bureau of Indian Education 2023 (Cohort and Baseline) SGP Analyses    ###
###                                                                         ###
###############################################################################

###   Load packages
require(SGP)
require(data.table)

###   Load cleaned 2023 LONG data
load("./Data/Archive/2021_2022.2/Bureau_of_Indian_Education_SGP_LONG_Data_2021_2022.2.Rdata")
load("./Data/Archive/2022_2023.2/Bureau_of_Indian_Education_Data_LONG_2022_2023.2.Rdata")

setnames(
    Bureau_of_Indian_Education_Data_LONG_2022_2023.2,
    c("ID", "growthIdentifier"),
    c("PANUniqueStudentID", "ID")
)

##    See 2023 Growth layout -- Blank if not enrolled in 2022.
##    Invalidate due to duplicate cases and subsequent errors.
Bureau_of_Indian_Education_Data_LONG_2022_2023.2[
    ID == "", ID := NA
][is.na(ID),
    VALID_CASE := "INVALID_CASE"
]

Bureau_of_Indian_Education_Data_LONG <-
    rbindlist(
        list(
            Bureau_of_Indian_Education_SGP_LONG_Data_2021_2022.2,
            Bureau_of_Indian_Education_Data_LONG_2022_2023.2
        ),
        fill = TRUE
    )

setkey(Bureau_of_Indian_Education_Data_LONG,
    VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID, SCALE_SCORE)
setkey(Bureau_of_Indian_Education_Data_LONG,
    VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID)
dupl <- duplicated(Bureau_of_Indian_Education_Data_LONG, by = key(Bureau_of_Indian_Education_Data_LONG))
dups <- Bureau_of_Indian_Education_Data_LONG[c(which(dupl)-1, which(dupl)), ]
table(dups$VALID_CASE)

###   Modify `SGPstateData`
##    Add baseline coefficient matrices directly rather than using `SGPmatrices`
##    due to SIMEX matrices size.
load("./Data/Archive/Bureau_of_Indian_Education_Baseline_Matrices.Rdata")
SGPstateData[["BI"]][["Baseline_splineMatrix"]][["Coefficient_Matrices"]] <-
    Bureau_of_Indian_Education_Baseline_Matrices

##    Remove "Percentile Cuts" from data - not used or returned to Pearson
# percentile.cuts <-
#     grep("PERCENTILE_CUT_", names(Bureau_of_Indian_Education_Data_LONG), value = TRUE)
# Bureau_of_Indian_Education_SGP_LONG_Data[, (percentile.cuts) := NULL]

SGPstateData[["BI"]][["Growth"]][["Cutscores"]] <-
    SGPstateData[["BI"]][["Growth"]][["Levels"]] <- NULL

###   Create analysis configurations

BIE_Config_2023 <- c(
    list(
        ELA.2022_2023.2 = list(
            sgp.content.areas = rep("ELA", 2),
            sgp.panel.years = c("2021_2022.2", "2022_2023.2"),
            sgp.grade.sequences = list(
                c("3", "4"), c("4", "5"),
                c("5", "6"), c("6", "7"), c("7", "8"))
    )),
    list(
        MATHEMATICS.2022_2023.2 = list(
            sgp.content.areas = rep("MATHEMATICS", 2),
            sgp.panel.years = c("2021_2022.2", "2022_2023.2"),
            sgp.grade.sequences = list(
                c("3", "4"), c("4", "5"),
                c("5", "6"), c("6", "7"), c("7", "8")
            )
    ))
)

###   Run Cohort Referenced Student Growth Percentiles

Bureau_of_Indian_Education_SGP <-
    abcSGP(
        sgp_object = Bureau_of_Indian_Education_Data_LONG,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
        sgp.config = BIE_Config_2023,
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
        outputSGP.directory = "Data/Archive/2022_2023.2",
        outputSGP.output.type = c("LONG_Data", "LONG_FINAL_YEAR_Data"),
        parallel.config = list(
            BACKEND = "PARALLEL",
            WORKERS = list(
                TAUS = 10, SIMEX = 12
            )
        )
    )

###   Save results
save(Bureau_of_Indian_Education_SGP,
     file = "./Data/Archive/2022_2023.2/Bureau_of_Indian_Education_SGP.Rdata"
)
