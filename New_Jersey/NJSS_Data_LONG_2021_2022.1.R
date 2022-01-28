################################################################################
###                                                                          ###
###         Create NJ Start Strong LONG Data for Spring 2022 Analyses        ###
###                                                                          ###
################################################################################

###  Set working directory to top level directory (PARCC)

### Load required packages
require(data.table)
require(psych)

###
###   Read in Spring 2021 Pearson base data
###

nj1 <- fread("./New_Jersey/Data/Base_Files/NJ Start Strong Summative/njssf21_NJ_State_Summative_Record_File_StartStrong_D202111081433_File1.csv", colClasses=rep("character", 201))
nj2 <- fread("./New_Jersey/Data/Base_Files/NJ Start Strong Summative/njssf21_NJ_State_Summative_Record_File_StartStrong_D202111081433_File2.csv", colClasses=rep("character", 201))

NJSS_Data_LONG_2021_2022.1 <- rbindlist(list(nj1, nj2)); rm(nj1); rm(nj2); gc()

##    Weed out blank columns and unused TestCode records
NJSS_Data_LONG_2021_2022.1 <- NJSS_Data_LONG_2021_2022.1[!TestCode %in% c("SC06", "SC09", "SC12")]
NJSS_Data_LONG_2021_2022.1 <- NJSS_Data_LONG_2021_2022.1[, names(NJSS_Data_LONG_2021_2022.1)[!unlist(lapply(names(NJSS_Data_LONG_2021_2022.1), function(f) all(NJSS_Data_LONG_2021_2022.1[,get(f)] == "")))], with=FALSE]

setnames(NJSS_Data_LONG_2021_2022.1, c("StudentAssessmentIdentifier", "TestRawScore", "SupportLevel"), c("ID",  "SCALE_SCORE_ACTUAL", "ACHIEVEMENT_LEVEL_ACTUAL"))
NJSS_Data_LONG_2021_2022.1[, StateAbbreviation := "NJ"]


NJSS_Data_LONG_2021_2022.1[, SCALE_SCORE_ACTUAL := as.numeric(SCALE_SCORE_ACTUAL)]
NJSS_Data_LONG_2021_2022.1[, ReportingConcept1RawScore := as.numeric(ReportingConcept1RawScore)]
NJSS_Data_LONG_2021_2022.1[, ReportingConcept2RawScore := as.numeric(ReportingConcept2RawScore)]
NJSS_Data_LONG_2021_2022.1[, ReportingConcept3RawScore := as.numeric(ReportingConcept3RawScore)]
NJSS_Data_LONG_2021_2022.1[, ReportingConcept4RawScore := as.numeric(ReportingConcept4RawScore)]


###   Create VALID_CASE based on business rules
NJSS_Data_LONG_2021_2022.1[, VALID_CASE := "VALID_CASE"]
NJSS_Data_LONG_2021_2022.1[VoidScoreCode == "Y" | NotTestedCode == "Y" | TestAttemptednessFlag == "N", VALID_CASE := "INVALID_CASE"]
NJSS_Data_LONG_2021_2022.1[is.na(SCALE_SCORE_ACTUAL), VALID_CASE := "INVALID_CASE"]
# table(NJSS_Data_LONG_2021_2022.1[, VALID_CASE])


###   CONTENT_AREA from TestCode
NJSS_Data_LONG_2021_2022.1[, CONTENT_AREA := factor(TestCode)]
# table(NJSS_Data_LONG_2021_2022.1$CONTENT_AREA)
setattr(NJSS_Data_LONG_2021_2022.1$CONTENT_AREA, "levels",
        c("ALG_I_NJSS", "ALG_II_NJSS", rep("ELA_NJSS", 7), "GEOM_NJSS", rep("MATH_NJSS", 5)))
NJSS_Data_LONG_2021_2022.1[, CONTENT_AREA := as.character(CONTENT_AREA)]

###   GRADE from TestCode
NJSS_Data_LONG_2021_2022.1[, GRADE := gsub("ELA|MAT", "", TestCode)]
NJSS_Data_LONG_2021_2022.1[, GRADE := as.character(as.numeric(GRADE))]
NJSS_Data_LONG_2021_2022.1[which(is.na(GRADE)), GRADE := "EOCT"]
NJSS_Data_LONG_2021_2022.1[, GRADE := as.character(GRADE)]
# table(NJSS_Data_LONG_2021_2022.1[, GRADE, TestCode])

###   YEAR
NJSS_Data_LONG_2021_2022.1[, YEAR := "2021_2022.1"]

###
###   Create a more nuanced "Scale Score" from the subscore/components
###   Justification for use: https://link.springer.com/article/10.3758/s13428-020-01398-0  /:::/  https://doi.org/10.3758/s13428-020-01398-0
###

##    Function to apply `psych::principal` or `stats::princomp` to longitudinal data
`princompLong` <- function(
  data_table,
  vars_to_use,
  digits=2) {
    use.index <- data_table[,VALID_CASE=="VALID_CASE"]
    tmp.data <- data_table[, mget(vars_to_use)][,
        vars_to_use[!unlist(lapply(vars_to_use, function(f) all(is.na(data_table[,get(f)]))))], with=FALSE]
    round(as.numeric(principal(tmp.data)[["scores"]]), digits)#, cor="poly", nfactors = 1)
    # pca <- princomp(tmp.data, subset = use.index)[["scores"]][,1]
    # res <- rep(as.numeric(NA), length(use.index))
    # res[which(use.index == TRUE)] <- round(pca, digits)
    # res
}

component.scores <- c("ReportingConcept1RawScore", "ReportingConcept2RawScore", "ReportingConcept3RawScore", "ReportingConcept4RawScore")

NJSS_Data_LONG_2021_2022.1[, SCALE_SCORE := princompLong(.SD, vars_to_use = component.scores), by = list(TestCode), .SDcols = c("VALID_CASE", component.scores)]
# NJSS_Data_LONG_2021_2022.1[!is.na(SCALE_SCORE), as.list(summary(nchar(SCALE_SCORE)))]

##    Function to apply cutscores to princomp scores
##    Mapping "SupportLevel" to Achievement Levels based on section 2.2.2 from "Score Interpretation Guide":
##    https://nj.mypearsonsupport.com/resources/educator-resources/startStrong/Start%20Strong%20SIG%20Accessible.pdf

`getCutsNJSS` <- function(
  data_table,
  predict.cuts = TRUE,
  digits=2) {
    if (predict.cuts)
      tmp.lm <- lm(SCALE_SCORE ~ SCALE_SCORE_ACTUAL, data = data_table)

    tmp.dt <- data_table[ACHIEVEMENT_LEVEL_ACTUAL != "", list(
                MIN = min(SCALE_SCORE_ACTUAL),
                MAX = max(SCALE_SCORE_ACTUAL)), keyby = "ACHIEVEMENT_LEVEL_ACTUAL"]

    tmp.data <- data.table(SCALE_SCORE_ACTUAL = c(unlist(floor(tmp.dt[1,3,]/2)), unlist(tmp.dt[2:3,2]), ceiling(mean(unlist(c(tmp.dt[3,2], tmp.dt[3,3]))))))
    if (predict.cuts) {
      tmp.cuts <- round(predict(tmp.lm, tmp.data), digits)
    } else tmp.cuts <- as.numeric(tmp.data[, SCALE_SCORE_ACTUAL])
    as.character(factor(findInterval(data_table[, SCALE_SCORE], tmp.cuts)+1,
  				              levels=1:5, labels=c("Level 1", "Level 2", "Level 3", "Level 4", "Level 5")))
}

NJSS_Data_LONG_2021_2022.1[, ACHIEVEMENT_LEVEL := getCutsNJSS(.SD), by = list(TestCode), .SDcols = c("SCALE_SCORE", "SCALE_SCORE_ACTUAL", "ACHIEVEMENT_LEVEL_ACTUAL")]

# NJSS_Data_LONG_2021_2022.1[!is.na(SCALE_SCORE), as.list(summary(SCALE_SCORE)), keyby = c("TestCode", "ACHIEVEMENT_LEVEL")]
# table(NJSS_Data_LONG_2021_2022.1[, .(ACHIEVEMENT_LEVEL, TestCode), ACHIEVEMENT_LEVEL_ACTUAL]) # Check disagr by VALID_CASE too


###   Invalidate duplicate cases (put here in code after creating SGP convention variables)
setkey(NJSS_Data_LONG_2021_2022.1, VALID_CASE, CONTENT_AREA, YEAR, GRADE, ID, SCALE_SCORE)
setkey(NJSS_Data_LONG_2021_2022.1, VALID_CASE, CONTENT_AREA, YEAR, GRADE, ID)
# dups <- data.table(NJSS_Data_LONG_2021_2022.1[unique(c(which(duplicated(NJSS_Data_LONG_2021_2022.1, by=key(NJSS_Data_LONG_2021_2022.1)))-1,
#                                                 which(duplicated(NJSS_Data_LONG_2021_2022.1, by=key(NJSS_Data_LONG_2021_2022.1))))), ],
#                                             key=key(NJSS_Data_LONG_2021_2022.1))
# table(dups$VALID_CASE) # 285 2021.1 duplicates that are VALID_CASEs
# table(NJSS_Data_LONG_2021_2022.1[which(duplicated(NJSS_Data_LONG_2021_2022.1, by=key(NJSS_Data_LONG_2021_2022.1)))-1, is.na(SCALE_SCORE), GRADE])
NJSS_Data_LONG_2021_2022.1[which(duplicated(NJSS_Data_LONG_2021_2022.1, by=key(NJSS_Data_LONG_2021_2022.1)))-1, VALID_CASE:="INVALID_CASE"]


###   Create PCA based Quantiles within Raw/Count Scores to provide more distinctions,
###   while keeping the Raw score ranking (avoid overlap between PCA and Raw scores)

`quantileOrder` <- function(data_table) {
  vals <- data_table[, SCALE_SCORE]
  tmp.pts <- sort(unique(vals))
  denom <- length(tmp.pts)
  # if ((denom <- length(tmp.pts)) > 9) denom <- 10
  if (denom > 1) {
    if (denom > 9) {
      tmp.cuts <- quantile(vals, probs = 0:10/10, na.rm = TRUE, names = FALSE)
      tmp.deci <- (findInterval(vals, tmp.cuts, rightmost.closed = TRUE)-1)/10
    } else {
      if (denom > 2) {
        tmp.deci <- as.numeric(as.character(factor(vals, levels = tmp.pts, labels = c(0, round(((2:(denom-1))/9)*(9/(denom+1)), 1), 0.9))))
      } else tmp.deci <- as.numeric(as.character(factor(vals, levels = tmp.pts, labels = c(0, 0.5)))) # denom == 2
      # tmp.deci <- findInterval(vals, tmp.pts, rightmost.closed = TRUE)-1 # also works, but not spaced out
    }
    return(data_table[, SCALE_SCORE_ACTUAL] + tmp.deci)
  } else {
    return(as.numeric(data_table[, SCALE_SCORE_ACTUAL]))
  }
}

NJSS_Data_LONG_2021_2022.1[, SCALE_SCORE_RANKED := quantileOrder(.SD), by = list(TestCode, SCALE_SCORE_ACTUAL), .SDcols = c("SCALE_SCORE", "SCALE_SCORE_ACTUAL")] # "TestCode" for debug

setnames(NJSS_Data_LONG_2021_2022.1, c("SCALE_SCORE", "SCALE_SCORE_RANKED"), c("SSX", "SCALE_SCORE"))
NJSS_Data_LONG_2021_2022.1[, ACHIEVEMENT_LEVEL_RANKED := getCutsNJSS(.SD, predict.cuts = FALSE), by = list(TestCode), .SDcols = c("SCALE_SCORE", "SCALE_SCORE_ACTUAL", "ACHIEVEMENT_LEVEL_ACTUAL")]
setnames(NJSS_Data_LONG_2021_2022.1, c("SSX", "SCALE_SCORE"), c("SCALE_SCORE", "SCALE_SCORE_RANKED"))
# table(NJSS_Data_LONG_2021_2022.1[, .(ACHIEVEMENT_LEVEL_RANKED, TestCode), ACHIEVEMENT_LEVEL])
# table(NJSS_Data_LONG_2021_2022.1[, .(ACHIEVEMENT_LEVEL_RANKED, TestCode), ACHIEVEMENT_LEVEL_ACTUAL])

##    Test Results.  Differences should all be between 0 and 1
# ss.smry <- NJSS_Data_LONG_2021_2022.1[VALID_CASE == "VALID_CASE", as.list(summary(SCALE_SCORE)), keyby = c("TestCode", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_RANKED")] # Should all be between 0 and 1
# # ss.smry[TestCode == "ELA08"]
# ss.smry[, MAX_PRIOR := shift(Max., 1, type = "lag"), by = list(TestCode, SCALE_SCORE_ACTUAL)]
# ss.smry[, MIN_NEXT := shift(Min., 1, type = "lead"), by = list(TestCode, SCALE_SCORE_ACTUAL)]
# ss.smry[, MAX_PRIOR_lt_MIN := Min. - MAX_PRIOR]
# ss.smry[, MIN_NEXT_gt_MAX := MIN_NEXT - Max.]
#
# ss.smry[, as.list(summary(MAX_PRIOR_lt_MIN)), keyby = "TestCode"]
# ss.smry[, as.list(summary(MIN_NEXT_gt_MAX)), keyby = "TestCode"]


###   Weed out variables based on Pearson file layout and SGP conventions

parcc.var.names <- c(
    "AssessmentYear", "StateAbbreviation", "PANUniqueStudentID", "GradeLevelWhenAssessed",
    "Period", "TestCode", "TestFormat", "SummativeScoreRecordUUID", "StudentTestUUID",
    "SummativeScaleScore", "IRTTheta", "SummativeCSEM", "ThetaSEM", "FormID",
    "TestingLocation", "LearningOption", "StateStudentIdentifier", "LocalStudentIdentifier",
    "TestingDistrictCode", "TestingDistrictName", "TestingSchoolCode", "TestingSchoolName",
    "AccountableDistrictCode", "AccountableDistrictName", "AccountableSchoolCode",
    "AccountableSchoolName", "Sex", "HispanicOrLatinoEthnicity", "AmericanIndianOrAlaskaNative",
    "Asian", "BlackOrAfricanAmerican", "NativeHawaiianOrOtherPacificIslander",
    "White", "FederalRaceEthnicity", "TwoOrMoreRaces", "EnglishLearnerEL", "MigrantStatus",
    "GiftedAndTalented", "EconomicDisadvantageStatus", "StudentWithDisabilities")

added.sgp.names <- c("ID", "VALID_CASE", "CONTENT_AREA", "GRADE", "YEAR",
                     "SCALE_SCORE", "ACHIEVEMENT_LEVEL",
                     "SCALE_SCORE_ACTUAL", "ACHIEVEMENT_LEVEL_ACTUAL",
                     "SCALE_SCORE_RANKED", "ACHIEVEMENT_LEVEL_RANKED")

vars.to.keep <- c(parcc.var.names[parcc.var.names %in% names(NJSS_Data_LONG_2021_2022.1)], "StudentUUID", "TestingOrganizationalType")
vars.to.remove <- names(NJSS_Data_LONG_2021_2022.1)[!names(NJSS_Data_LONG_2021_2022.1) %in% c(added.sgp.names, unique(c(parcc.var.names, vars.to.keep)))]

NJSS_Data_LONG_2021_2022.1[, (vars.to.remove) := NULL]

setcolorder(NJSS_Data_LONG_2021_2022.1, c(added.sgp.names, vars.to.keep))

###   Create Data Directory and Save Object
if (!dir.exists("./New_Jersey/Data/Archive/2021_2022.1")) dir.create("./New_Jersey/Data/Archive/2021_2022.1", recursive=TRUE)


save(NJSS_Data_LONG_2021_2022.1, file = "./New_Jersey/Data/Archive/2021_2022.1/NJSS_Data_LONG_2021_2022.1.Rdata")



#####
###   Some descriptives/checks
#####

# NJSS_Data_LONG_2021_2022.1[, .(
#       # UNIQUE_PCA4 = length(unique(SS_FULL)),
#       # UNIQUE_PCA3 = length(unique(round(SS_FULL, 3))),
#       UNIQUE_PCA2 = length(unique(round(SCALE_SCORE, 2))),
#       UNIQUE_PCA1 = length(unique(round(SCALE_SCORE, 1))),
#       UNIQUE_RANK = length(unique(SCALE_SCORE_RANKED)),
#       UNIQUE_RAWS = length(unique(SCALE_SCORE_ACTUAL))), keyby = "TestCode"]

# hist(round(NJSS_Data_LONG_2021_2022.1[VALID_CASE == "VALID_CASE" & TestCode == "MAT06", SCALE_SCORE], 2), breaks = 35)
# hist(NJSS_Data_LONG_2021_2022.1[VALID_CASE == "VALID_CASE" & TestCode == "MAT06", SCALE_SCORE_ACTUAL], breaks = 35)
#
# hist(round(NJSS_Data_LONG_2021_2022.1[VALID_CASE == "VALID_CASE" & TestCode == "ELA07", SCALE_SCORE], 2), breaks = 35)
# hist(NJSS_Data_LONG_2021_2022.1[VALID_CASE == "VALID_CASE" & TestCode == "ELA07", SCALE_SCORE_ACTUAL], breaks = 35)
#
# NJSS_Data_LONG_2021_2022.1[, TestCode := factor(TestCode)]
#
# require(lattice)
# xyplot(SCALE_SCORE ~ SCALE_SCORE_RANKED|TestCode, data = NJSS_Data_LONG_2021_2022.1,
#    main="Scatterplots of PCA vs Ranked Raw Scores",
#    ylab="PCA", xlab="Augmented Raw Scores")
#
# xyplot(SCALE_SCORE_ACTUAL ~ SCALE_SCORE_RANKED|TestCode, data = NJSS_Data_LONG_2021_2022.1,
#   main="Scatterplots of Raw/Count vs Ranked Raw Scores",
#   ylab="Raw", xlab="Augmented Raw Scores")
