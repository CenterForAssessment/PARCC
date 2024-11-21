#+ include = FALSE, purl = FALSE, eval = FALSE
##############################################################################
###                                                                        ###
###     Create Individual State LONG Data for Spring 2024 SGP Analyses     ###
###                                                                        ###
##############################################################################

###   Set working directory to top level directory (PARCC)

###   Load required packages
require(data.table)
require(SGP)

#####
###   Read in Spring 2024 Pearson base data
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

##    Two additional variables for BIE & DoDEA
addl.bie.dd.names <- c("customerReferenceId", "testAdminReferenceId", "growthIdentifier")
all.var.names <- c(var.name.order, addl.bie.dd.names)
bie.dd.var.names <- c(pearson.var.names, addl.bie.dd.names)


###   Read in spring 2024 data by state
# TMP_Data_2024 <- fread(
#     "./New_Jersey/Data/Base_Files/PARCC_NJ_2023-2024_SGPO_D20240704.csv.gz",
#     colClasses = rep("character", 90))[, ..pearson.var.names]
TMP_Data_2024 <-
    fread("./Bureau_of_Indian_Education/Data/Base_Files/bi_24_biespr24_SGPO_20240724-2137.csv",
          colClasses = rep("character", length(all.var.names)))
##  Align DC names with the other states/members
# names(TMP_Data_2024)[!names(TMP_Data_2024) %in% all.var.names]
setnames(TMP_Data_2024,
    c("StudentUniqueUuid", "TestScaleScore", "TestCSEMProbableRange",
    "Filler51", "Filler52", # Watch for mispelling in DC - "StudentIndentifier"
    "StudentIdentifier", "ReportingDistrictCode", "ReportingDistrictName",
    "ReportingSchoolCode", "ReportingSchoolName", "Gender", "CustomerRefID"),
    # all.var.names[!all.var.names %in% names(TMP_Data_2024)]
    c("PANUniqueStudentID", "SummativeScaleScore", "SummativeCSEM",
    "TestingLocation", "LearningOption",
    "StateStudentIdentifier", "AccountableDistrictCode", "AccountableDistrictName",
    "AccountableSchoolCode", "AccountableSchoolName", "Sex", "customerReferenceId")
)
TMP_Data_2024 <- TMP_Data_2024[, ..bie.dd.var.names]
# TMP_Data_2024 <-
#     fread("./Department_Of_Defense/Data/Base_Files/pcspr24_state_Student_Growth_20240605201928380746.csv.gz",
#           colClasses = rep("character", length(all.var.names)))[, ..bie.dd.var.names]
# TMP_Data_2024 <- fread(
#     "./Illinois/Data/Base_Files/PARCC_IL_2023-2024_SGPO_D20240516.csv.gz",
#     colClasses = rep("character", 90))[, ..pearson.var.names]
# TMP_Data_2024 <- fread(
#     "./Washington_DC/Data/Base_Files/dc_24_dcspr24_SGPO_20240708-1557.csv.gz",
#     colClasses = rep("character", length(all.var.names)))#[, ..pearson.var.names]
# ##  Align DC names with the other states/members
# # names(TMP_Data_2024)[!names(TMP_Data_2024) %in% all.var.names]
# setnames(TMP_Data_2024,
#     c("StudentUniqueUuid", "TestScaleScore", "TestCSEMProbableRange",
#     "Filler51", "Filler52", # Mispelling in DC - should be "StudentIdentifier"
#     "StudentIndentifier", "ReportingDistrictCode", "ReportingDistrictName",
#     "ReportingSchoolCode", "ReportingSchoolName", "Gender", "CustomerRefID"),
#     # all.var.names[!all.var.names %in% names(TMP_Data_2024)]
#     c("PANUniqueStudentID", "SummativeScaleScore", "SummativeCSEM",
#     "TestingLocation", "LearningOption",
#     "StateStudentIdentifier", "AccountableDistrictCode", "AccountableDistrictName",
#     "AccountableSchoolCode", "AccountableSchoolName", "Sex", "customerReferenceId")
# )
# TMP_Data_2024 <- TMP_Data_2024[, ..pearson.var.names]

setkey(TMP_Data_2024, PANUniqueStudentID, StateStudentIdentifier, TestCode, Period)


#####
###   Data Cleaning  -  Create Required SGP Variables
#####

###   ID
##    DoDEA use `growthIdentifier` as of '23 
##    BIE & DC uses `StateStudentIdentifier` as of '24 
##    - Make changes in 1) analyses and 2) post- analysis formatting scripts
setnames(TMP_Data_2024, "PANUniqueStudentID", "ID")

###   CONTENT_AREA from TestCode
TMP_Data_2024[, CONTENT_AREA := factor(TestCode)]
table(TMP_Data_2024$CONTENT_AREA, exclude = NULL)
setattr(TMP_Data_2024$CONTENT_AREA, "levels",
        # c("ALGEBRA_I", "ALGEBRA_II", rep("ELA", 8),  #   DC
        #   "GEOMETRY", rep("MATHEMATICS", 6)))
        # c("ALGEBRA_I", "ALGEBRA_II", rep("ELA", 7), #   NJ
        #   "GEOMETRY", rep("MATHEMATICS", 6)))
        c("ALGEBRA_I", "ALGEBRA_II", rep("ELA", 7),   #   BI
          "GEOMETRY", rep("MATHEMATICS", 6),
          "INTEGRATED_MATH_1", "INTEGRATED_MATH_2", "INTEGRATED_MATH_3"))
        # c("ALGEBRA_I", "ALGEBRA_II", rep("ELA", 7),   #   DoDEA
        #   "GEOMETRY", rep("MATHEMATICS", 6)))
        # c(rep("ELA", 6), rep("MATHEMATICS", 6)))      #   IL
TMP_Data_2024[, CONTENT_AREA := as.character(CONTENT_AREA)]

###   GRADE from TestCode
TMP_Data_2024[, GRADE := gsub("ELA|MAT", "", TestCode)]
TMP_Data_2024[, GRADE := as.character(as.numeric(GRADE))]
TMP_Data_2024[which(is.na(GRADE)), GRADE := "EOCT"]
TMP_Data_2024[, GRADE := as.character(GRADE)]
table(TMP_Data_2024[, GRADE, TestCode], exclude = NULL)

###   YEAR
# TMP_Data_2024[, YEAR := gsub("-", "_", AssessmentYear)]
# TMP_Data_2024[which(Period == "Spring"), YEAR := paste0(YEAR, ".2")]
TMP_Data_2024[, YEAR := "2023_2024.2"]  #  DC

###   Theta - create IRT CSEM
scaling.constants <- as.data.table(read.csv(
    "./PARCC/Data/Base_Files/2015-2016 PARCC Scaling Constants.csv"))
setkey(scaling.constants, CONTENT_AREA, GRADE)
setkey(TMP_Data_2024, CONTENT_AREA, GRADE)
TMP_Data_2024 <- scaling.constants[TMP_Data_2024]

TMP_Data_2024[, SCALE_SCORE_CSEM := (as.numeric(SummativeCSEM)) / a]
# summary(TMP_Data_2024[, as.numeric(IRTTheta)])

TMP_Data_2024[, c("a", "b", "ThetaSEM") := NULL]

setnames(TMP_Data_2024,
        c("IRTTheta", "SummativeScaleScore", "SummativeCSEM"),
        c("SCALE_SCORE", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_CSEM_ACTUAL")
)


###   Valid Cases
TMP_Data_2024[, VALID_CASE := "VALID_CASE"]

###   Invalidate Cases with missing IDs - 0 invalid in FINAL data
TMP_Data_2024[ID == "", VALID_CASE := "INVALID_CASE"] #|is.na(ID)
# TMP_Data_2024[StateStudentIdentifier == "", VALID_CASE := "INVALID_CASE"] # BIE, DC, etc.

###   ACHIEVEMENT_LEVEL
TMP_Data_2024 <- SGP:::getAchievementLevel(TMP_Data_2024, state = "PARCC")

table(TMP_Data_2024[, ACHIEVEMENT_LEVEL, CONTENT_AREA], exclude = NULL)# |> prop.table(1) |> round(3) *100

#####
###   Duplicates -- DON'T FIX DUPLICATES!  Per email from Pat Taylor 7/18/16
#####

###   Exact duplicates still need to be dealt with (if present)
TMP_Data_2024[, EXACT_DUPLICATE := as.numeric(NA)]

setkey(TMP_Data_2024,
    VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID, SCALE_SCORE_ACTUAL, SCALE_SCORE)
dupl <- duplicated(TMP_Data_2024, by = key(TMP_Data_2024))
dups <- TMP_Data_2024[c(which(dupl)-1, which(dupl)), ]
setkeyv(dups, key(TMP_Data_2024))

TMP_Data_2024[which(dupl)-1, EXACT_DUPLICATE := 1]
TMP_Data_2024[which(dupl), EXACT_DUPLICATE := 2]
TMP_Data_2024[which(dupl), VALID_CASE := "INVALID_CASE"]

###   Final reformat of some variables
TMP_Data_2024[, GRADE := as.character(GRADE)]
TMP_Data_2024[, SCALE_SCORE := as.numeric(SCALE_SCORE)]
TMP_Data_2024[, SCALE_SCORE_CSEM := as.numeric(SCALE_SCORE_CSEM)]
TMP_Data_2024[, SCALE_SCORE_ACTUAL := as.numeric(SCALE_SCORE_ACTUAL)]
TMP_Data_2024[, SCALE_SCORE_CSEM_ACTUAL := as.numeric(SCALE_SCORE_CSEM_ACTUAL)]

dir.create("./Bureau_of_Indian_Education/Data/Archive/2023_2024.2")
assign("Bureau_of_Indian_Education_Data_LONG_2023_2024.2", TMP_Data_2024)
save(Bureau_of_Indian_Education_Data_LONG_2023_2024.2,
    file =
      file.path("Bureau_of_Indian_Education/Data/Archive/2023_2024.2",
                "Bureau_of_Indian_Education_Data_LONG_2023_2024.2.Rdata")
)


#####
###   "Optional" variables for IL according to Growth Layout (v1)
#####
# table(TMP_Data_2024[, LearningOption], exclude = NULL)
# table(TMP_Data_2024[, TestingLocation], exclude = NULL)


###   For the member-specific reports, the below is located in
###   Technical_Reports/*state*/2024/assets/rmd/Custom_Content/3.1_ANALYTICS__Data_Prep_PARCC.Rmd

#' ## Data Preparation
#'
#' For the 2024 Consortium data preparation and cleaning, we first combine all
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
#' In 2024 there were no duplicate or invalid cases found in the data received from
#' Pearson.
