#+ include = FALSE, purl = FALSE, eval = FALSE
##############################################################################
###                                                                        ###
###     Create Individual State LONG Data for Spring 2025 SGP Analyses     ###
###                                                                        ###
##############################################################################

###   Set working directory to top level directory (PARCC)

###   Load required packages
require(data.table)
require(SGP)

#####
###   Read in Spring 2025 Pearson base data
#####

###   Set names based on Pearson file layout
pearson.var.names <- c(
    "AssessmentYear", "StateAbbreviation", "PANUniqueStudentID",
    "GradeLevelWhenAssessed", "Period", "TestCode", "TestFormat",
    "SummativeScoreRecordUUID", "StudentTestUUID", "SummativeScaleScore",
    "IRTTheta", "SummativeCSEM", "ThetaSEM", "FormID", "TestingLocation",
    "LearningOption", "StateStudentIdentifier", "LocalStudentIdentifier",
    "TestingDistrictCode", "TestingDistrictName", "TestingSchoolCode",
    "TestingSchoolName", "AccountableDistrictCode", "AccountableDistrictName",
    "AccountableSchoolCode", "AccountableSchoolName", "Sex",
    "HispanicOrLatinoEthnicity", "AmericanIndianOrAlaskaNative", "Asian",
    "BlackOrAfricanAmerican", "NativeHawaiianOrOtherPacificIslander", "White",
    "FederalRaceEthnicity", "TwoOrMoreRaces", "EnglishLearnerEL",
    "MigrantStatus", "GiftedAndTalented", "EconomicDisadvantageStatus",
    "StudentWithDisabilities")

center.var.names <- c(
    "SGPIRTThetaState1Prior", "SGPIRTThetaState2Prior",
    "SGPIRTThetaConsortia1Prior", "SGPIRTThetaConsortia2Prior",
    "StudentGrowthPercentileComparedtoState",
    "StudentGrowthPercentileComparedtoState1Prior",
    "StudentGrowthPercentileComparedtoState2Prior",
    "StudentGrowthPercentileComparedtoConsortia",
    "StudentGrowthPercentileComparedtoConsortia1Prior",
    "StudentGrowthPercentileComparedtoConsortia2Prior",
    "SGPPreviousTestCodeState", "SGPPreviousTestCodeState1Prior",
    "SGPPreviousTestCodeState2Prior", "SGPPreviousTestCodeConsortia",
    "SGPPreviousTestCodeConsortia1Prior", "SGPPreviousTestCodeConsortia2Prior",
    "SGPUpperBoundState", "SGPUpperBoundState1Prior",
    "SGPUpperBoundState2Prior", "SGPLowerBoundState",
    "SGPLowerBoundState1Prior", "SGPLowerBoundState2Prior",
    "SGPUpperBoundConsortia", "SGPUpperBoundConsortia1Prior",
    "SGPUpperBoundConsortia2Prior", "SGPLowerBoundConsortia",
    "SGPLowerBoundConsortia1Prior", "SGPLowerBoundConsortia2Prior",
    "SGPStandardErrorState", "SGPStandardErrorState1Prior",
    "SGPStandardErrorState2Prior", "SGPStandardErrorConsortia",
    "SGPStandardErrorConsortia1Prior", "SGPStandardErrorConsortia2Prior",
    "SGPRankedSimexState", "SGPRankedSimexState1Prior",
    "SGPRankedSimexState2Prior", "SGPRankedSimexConsortia",
    "SGPRankedSimexConsortia1Prior", "SGPRankedSimexConsortia2Prior",
    "SGPTargetState", "SGPTargetConsortia", "SGPTargetTestCodeState",
    "SGPTargetTestCodeConsortia",
    "StudentGrowthPercentileComparedtoStateBaseline",
    "SGPRankedSimexStateBaseline", "SGPTargetStateBaseline",
    "StudentGrowthPercentileComparedtoConsortiaBaseline",
    "SGPRankedSimexConsortiaBaseline", "SGPTargetConsortiaBaseline")

var.name.order <- c(pearson.var.names[1:11], center.var.names[1:4],
                    pearson.var.names[12:13], center.var.names[5:44], # Old order
                    pearson.var.names[14], center.var.names[45:50],
                    pearson.var.names[15:40])  #  Added in 2021

###   Read in spring 2025 data by state
###   As of '25, only New Jersey uses the old file layout.
TMP_Data_2025 <- fread(
    "./New_Jersey/Data/Base_Files/PARCC_NJ_2024-2025_SGPO_D20250619.csv.gz",
    colClasses = rep("character", 90))[, ..pearson.var.names]

setkey(TMP_Data_2025, PANUniqueStudentID, TestCode)


#####
###   Data Cleaning  -  Create Required SGP Variables
#####

###   ID
setnames(TMP_Data_2025, "PANUniqueStudentID", "ID")

###   CONTENT_AREA from TestCode
TMP_Data_2025[, CONTENT_AREA := factor(TestCode)]
table(TMP_Data_2025$CONTENT_AREA, exclude = NULL)
setattr(TMP_Data_2025$CONTENT_AREA, "levels",
        c("ALGEBRA_I", "ALGEBRA_II", rep("ELA", 7),
          "GEOMETRY", rep("MATHEMATICS", 6)))
TMP_Data_2025[, CONTENT_AREA := as.character(CONTENT_AREA)]

###   GRADE from TestCode
TMP_Data_2025[,
    GRADE := gsub("ELA|MAT", "", TestCode)
][, GRADE := as.character(as.numeric(GRADE))
][ which(is.na(GRADE)), GRADE := "EOCT"
][, GRADE := as.character(GRADE)
]
table(TMP_Data_2025[, GRADE, TestCode], exclude = NULL)

###   YEAR
TMP_Data_2025[, YEAR := "2024_2025.2"]

###   Theta - create IRT CSEM
scaling.constants <- as.data.table(read.csv(
    "./PARCC/Data/Base_Files/2015-2016 PARCC Scaling Constants.csv"))
setkey(scaling.constants, CONTENT_AREA, GRADE)
setkey(TMP_Data_2025, CONTENT_AREA, GRADE)
TMP_Data_2025 <- scaling.constants[TMP_Data_2025]

TMP_Data_2025[, SCALE_SCORE_CSEM := (as.numeric(SummativeCSEM)) / a]
# TMP_Data_2025[, as.list(summary(as.numeric(IRTTheta))), keyby = TestCode]

TMP_Data_2025[, c("a", "b", "ThetaSEM") := NULL]

setnames(TMP_Data_2025,
    c("IRTTheta", "SummativeScaleScore", "SummativeCSEM"),
    c("SCALE_SCORE", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_CSEM_ACTUAL")
)

###   Valid Cases
###   Invalidate Cases with missing IDs - 0 invalid in FINAL data
TMP_Data_2025[,
    VALID_CASE := "VALID_CASE"
][ID == "" | is.na(ID),
    VALID_CASE := "INVALID_CASE"
]

###   ACHIEVEMENT_LEVEL
TMP_Data_2025 <- SGP:::getAchievementLevel(TMP_Data_2025, state = "PARCC")

table(TMP_Data_2025[, ACHIEVEMENT_LEVEL, CONTENT_AREA], exclude = NULL)# |> prop.table(1) |> round(3) *100

#####
###   Duplicates -- DON'T FIX DUPLICATES!  Per email from Pat Taylor 7/18/16
#####

###   Exact duplicates still need to be dealt with (if present)
TMP_Data_2025[, EXACT_DUPLICATE := as.numeric(NA)]

setkey(TMP_Data_2025,
    VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID, SCALE_SCORE_ACTUAL, SCALE_SCORE)
dupl <- duplicated(TMP_Data_2025, by = key(TMP_Data_2025))
dups <- TMP_Data_2025[c(which(dupl)-1, which(dupl)), ]
setkeyv(dups, key(TMP_Data_2025))

TMP_Data_2025[
  which(dupl)-1, EXACT_DUPLICATE := 1
][which(dupl), EXACT_DUPLICATE := 2
][which(dupl), VALID_CASE := "INVALID_CASE"
]

###   Final reformat of some variables
TMP_Data_2025[,
    GRADE := as.character(GRADE)
][, SCALE_SCORE := as.numeric(SCALE_SCORE)
][, SCALE_SCORE_CSEM := as.numeric(SCALE_SCORE_CSEM)
][, SCALE_SCORE_ACTUAL := as.numeric(SCALE_SCORE_ACTUAL)
][, SCALE_SCORE_CSEM_ACTUAL := as.numeric(SCALE_SCORE_CSEM_ACTUAL)
]

dir.create("./New_Jersey/Data/Archive/2024_2025.2")
assign("New_Jersey_Data_LONG_2024_2025.2", TMP_Data_2025)
save(New_Jersey_Data_LONG_2024_2025.2,
    file =
      file.path("New_Jersey/Data/Archive/2024_2025.2",
                "New_Jersey_Data_LONG_2024_2025.2.Rdata")
)


###   For the member-specific reports, the below is located in
###   Technical_Reports/*state*/2025/assets/rmd/Custom_Content/3.1_ANALYTICS__Data_Prep_PARCC.Rmd

#' ## Data Preparation
#'
#' For the 2025 Consortium data preparation and cleaning, we first combine all
#' Consortium members individual datasets into a single table. We then modify
#' the provided variable names to match what has been used in previous years
#' or as required to conform to the `SGP` package conventions. Required variables
#' `GRADE` and `CONTENT_AREA` are created from the provided `testCode` variable,
#' and an achievement level variable is computed based on historical cut scores
#' for each assessment.
#' 
#' The data was also examined to identify invalid records. 
#' Student records were flagged as "invalid" based on the following criteria:
#'
#' * Students with **exact** duplicate records.
#' * Student records in which the unique student identifier is missing.
#' 
#' In 2025 there were no duplicate or invalid cases found in the data received from
#' Pearson.
