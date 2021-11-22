################################################################################
###                                                                          ###
###              Create PARCC LONG Data for Spring 2021 Analyses             ###
###                                                                          ###
################################################################################

### Load required packages

require(SGP)
require(data.table)

###  Set working directory to top level directory (PARCC)

###
###   Read in Spring 2021 Pearson base data
###

###   Set names based on Pearson file layout

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

center.var.names <- c(
    "SGPIRTThetaState1Prior", "SGPIRTThetaState2Prior", "SGPIRTThetaPARCC1Prior",
    "SGPIRTThetaPARCC2Prior", "StudentGrowthPercentileComparedtoState",
    "StudentGrowthPercentileComparedtoState1Prior", "StudentGrowthPercentileComparedtoState2Prior",
    "StudentGrowthPercentileComparedtoPARCC", "StudentGrowthPercentileComparedtoPARCC1Prior",
    "StudentGrowthPercentileComparedtoPARCC2Prior", "SGPPreviousTestCodeState",
    "SGPPreviousTestCodeState1Prior", "SGPPreviousTestCodeState2Prior", "SGPPreviousTestCodePARCC",
    "SGPPreviousTestCodePARCC1Prior", "SGPPreviousTestCodePARCC2Prior", "SGPUpperBoundState",
    "SGPUpperBoundState1Prior", "SGPUpperBoundState2Prior", "SGPLowerBoundState",
    "SGPLowerBoundState1Prior", "SGPLowerBoundState2Prior", "SGPUpperBoundPARCC",
    "SGPUpperBoundPARCC1Prior", "SGPUpperBoundPARCC2Prior", "SGPLowerBoundPARCC",
    "SGPLowerBoundPARCC1Prior", "SGPLowerBoundPARCC2Prior", "SGPStandardErrorState",
    "SGPStandardErrorState1Prior", "SGPStandardErrorState2Prior", "SGPStandardErrorPARCC",
    "SGPStandardErrorPARCC1Prior", "SGPStandardErrorPARCC2Prior", "SGPRankedSimexState",
    "SGPRankedSimexState1Prior", "SGPRankedSimexState2Prior", "SGPRankedSimexPARCC",
    "SGPRankedSimexPARCC1Prior", "SGPRankedSimexPARCC2Prior", "SGPTargetState",
    "SGPTargetPARCC", "SGPTargetTestCodeState", "SGPTargetTestCodePARCC",
    "StudentGrowthPercentileComparedtoStateBaseline", "SGPRankedSimexStateBaseline",
    "SGPTargetStateBaseline", "StudentGrowthPercentileComparedtoPARCCBaseline",
    "SGPRankedSimexPARCCBaseline", "SGPTargetPARCCBaseline")

all.var.names <- c(parcc.var.names[1:11], center.var.names[1:4], parcc.var.names[12:13], center.var.names[5:44], # Old order
                   parcc.var.names[14], center.var.names[45:50], parcc.var.names[15:40])  #  Added in 2021 for Center and Pearson

##  Two additional variables for BIE & DoDEA
addl.bie.dd.names <- c("customerReferenceId", "testAdminReferenceId")
all.var.names <- c(all.var.names, addl.bie.dd.names)
parcc.var.names <- c(parcc.var.names, addl.bie.dd.names)

###   Spring 2021

# PARCC_Data_LONG_2020_2021.2 <- fread("./Bureau_of_Indian_Education/Data/Base_Files/bi_pcspr21_state_Student_Growth_20210723151340223283.csv", colClasses=rep("character", length(all.var.names)))[, parcc.var.names, with=FALSE]
# PARCC_Data_LONG_2020_2021.2 <- fread("./Department_Of_Defense/Data/Base_Files/pcspr21_dodea_state_Student_Growth_20210726153550747902.csv", colClasses=rep("character", length(all.var.names)))[, parcc.var.names, with=FALSE]
PARCC_Data_LONG_2020_2021.2 <- fread("./Illinois/Data/Base_Files/PARCC_IL_2020-2021_SGPO_D20211031.csv", colClasses=rep("character", length(head(all.var.names, -2))))[, head(parcc.var.names, -2), with=FALSE]
load("./Illinois/Data/Archive/2020_2021.2/IL_OG_IDs.rda")
setnames(IL_OG_IDs, "ID", "PANUniqueStudentID")
IL_OG_IDs[, SPRING_TEST := TRUE]
IL_OG_IDs[, c("StudentTestUUID", "FormID") := NULL]

setkey(IL_OG_IDs, PANUniqueStudentID, TestCode) # StudentTestUUID, FormID,
setkey(PARCC_Data_LONG_2020_2021.2, PANUniqueStudentID, TestCode)

PARCC_Data_LONG_2020_2021.2 <- IL_OG_IDs[PARCC_Data_LONG_2020_2021.2]
PARCC_Data_LONG_2020_2021.2[is.na(SPRING_TEST), SPRING_TEST := FALSE]

setkey(PARCC_Data_LONG_2020_2021.2, PANUniqueStudentID, TestCode, Period)

#####
###   Data Cleaning  -  Create Required SGP Variables
#####

###   ID
setnames(PARCC_Data_LONG_2020_2021.2, "PANUniqueStudentID", "ID")

###   CONTENT_AREA from TestCode
PARCC_Data_LONG_2020_2021.2[, CONTENT_AREA := factor(TestCode)]
table(PARCC_Data_LONG_2020_2021.2$CONTENT_AREA)
setattr(PARCC_Data_LONG_2020_2021.2$CONTENT_AREA, "levels",
        # c("ALGEBRA_I", "ALGEBRA_II", rep("ELA", 7), "GEOMETRY", rep("MATHEMATICS", 6), "INTEGRATED_MATH_1", "INTEGRATED_MATH_2", "INTEGRATED_MATH_3")) # BIE
        # c("ALGEBRA_I", "ALGEBRA_II", rep("ELA", 7), "GEOMETRY", rep("MATHEMATICS", 5))) # DoDEA
        c(rep("ELA", 6), rep("MATHEMATICS", 6))) # IL
PARCC_Data_LONG_2020_2021.2[, CONTENT_AREA := as.character(CONTENT_AREA)]

###   GRADE from TestCode
PARCC_Data_LONG_2020_2021.2[, GRADE := gsub("ELA|MAT", "", TestCode)]
PARCC_Data_LONG_2020_2021.2[, GRADE := as.character(as.numeric(GRADE))]
PARCC_Data_LONG_2020_2021.2[which(is.na(GRADE)), GRADE := "EOCT"]
PARCC_Data_LONG_2020_2021.2[, GRADE := as.character(GRADE)]
table(PARCC_Data_LONG_2020_2021.2[, GRADE, TestCode])

###   YEAR
PARCC_Data_LONG_2020_2021.2[, YEAR := gsub("-", "_", AssessmentYear)]
PARCC_Data_LONG_2020_2021.2[which(Period == "Spring"), YEAR := paste(YEAR, "2", sep=".")]


###   Theta - create IRT CSEM
scaling.constants <- as.data.table(read.csv("./PARCC/Data/Base_Files/2015-2016 PARCC Scaling Constants.csv")) # Same as spring 2016 per Pat Taylor 2/10/17
setkey(scaling.constants, CONTENT_AREA, GRADE)
setkey(PARCC_Data_LONG_2020_2021.2, CONTENT_AREA, GRADE)
PARCC_Data_LONG_2020_2021.2 <- scaling.constants[PARCC_Data_LONG_2020_2021.2]

PARCC_Data_LONG_2020_2021.2[, SCALE_SCORE_CSEM := (as.numeric(SummativeCSEM))/a] # NO -b here...
# summary(PARCC_Data_LONG_2020_2021.2[, as.numeric(IRTTheta)])

PARCC_Data_LONG_2020_2021.2[, c("a", "b", "ThetaSEM") := NULL]

setnames(PARCC_Data_LONG_2020_2021.2, c("IRTTheta", "SummativeScaleScore", "SummativeCSEM"), c("SCALE_SCORE", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_CSEM_ACTUAL"))


###   Valid Cases
PARCC_Data_LONG_2020_2021.2[, VALID_CASE := "VALID_CASE"]

###   Invalidate Cases with missing IDs - 0 invalid in FINAL data
PARCC_Data_LONG_2020_2021.2[ID=="", VALID_CASE := "INVALID_CASE"]  #  | is.na(ID)

###   ACHIEVEMENT_LEVEL
PARCC_Data_LONG_2020_2021.2 <- SGP:::getAchievementLevel(PARCC_Data_LONG_2020_2021.2, state="PARCC")

table(PARCC_Data_LONG_2020_2021.2[, ACHIEVEMENT_LEVEL, CONTENT_AREA], exclude=NULL)

###   Invalidate 9th grade Cases for Washington DC
#
#  email from K Johnson April 27, 2018
#  1. ELA09 will always be excluded
#  2. Algebra I and Integrated Math I will be excluded when the "Grade Level When Assessed" field is = 09, 10, 11, 12, 13, 99, OS or PS
#
# table(PARCC_Data_LONG_2020_2021.2[StateAbbreviation == "DC", TestCode, GradeLevelWhenAssessed])

# PARCC_Data_LONG_2020_2021.2[StateAbbreviation == "DC" & TestCode == "ELA09", VALID_CASE := "INVALID_CASE"] # 6,936 cases
# PARCC_Data_LONG_2020_2021.2[StateAbbreviation == "DC" & TestCode == "ALG01" & GradeLevelWhenAssessed %in% c("09", "10", "11", "12", "99"), VALID_CASE := "INVALID_CASE"] # 5,528 cases
# PARCC_Data_LONG_2020_2021.2[StateAbbreviation == "DC" & TestCode == "MAT1I" & GradeLevelWhenAssessed %in% c("09", "10", "11", "12", "99"), VALID_CASE := "INVALID_CASE"] # 0 cases


####
###   Duplicates
###   DON'T FIX DUPLICATES!  Per email from Pat Taylor 7/18/16
####

#X#  Exact duplicates still need to be dealt with (if present)
PARCC_Data_LONG_2020_2021.2[, EXACT_DUPLICATE := as.numeric(NA)]

setkey(PARCC_Data_LONG_2020_2021.2, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID, SCALE_SCORE_ACTUAL, SCALE_SCORE)
dups <- PARCC_Data_LONG_2020_2021.2[c(which(duplicated(PARCC_Data_LONG_2020_2021.2, by=key(PARCC_Data_LONG_2020_2021.2))), which(duplicated(PARCC_Data_LONG_2020_2021.2, by=key(PARCC_Data_LONG_2020_2021.2)))-1),]
setkeyv(dups, key(PARCC_Data_LONG_2020_2021.2))
PARCC_Data_LONG_2020_2021.2[which(duplicated(PARCC_Data_LONG_2020_2021.2, by=key(PARCC_Data_LONG_2020_2021.2)))-1, EXACT_DUPLICATE := 1]
PARCC_Data_LONG_2020_2021.2[which(duplicated(PARCC_Data_LONG_2020_2021.2, by=key(PARCC_Data_LONG_2020_2021.2))), EXACT_DUPLICATE := 2]
PARCC_Data_LONG_2020_2021.2[which(duplicated(PARCC_Data_LONG_2020_2021.2, by=key(PARCC_Data_LONG_2020_2021.2))), VALID_CASE := "INVALID_CASE"]


###   Final reformat of some variables
PARCC_Data_LONG_2020_2021.2[, GRADE := as.character(GRADE)]
PARCC_Data_LONG_2020_2021.2[, SCALE_SCORE := as.numeric(SCALE_SCORE)]
PARCC_Data_LONG_2020_2021.2[, SCALE_SCORE_CSEM := as.numeric(SCALE_SCORE_CSEM)]
PARCC_Data_LONG_2020_2021.2[, SCALE_SCORE_ACTUAL := as.numeric(SCALE_SCORE_ACTUAL)]
PARCC_Data_LONG_2020_2021.2[, SCALE_SCORE_CSEM_ACTUAL := as.numeric(SCALE_SCORE_CSEM_ACTUAL)]

###   Save Spring 2021 individual states LONG data
dir.create("./Illinois/Data/Archive/2020_2021.2", recursive = TRUE)
assign("Illinois_Data_LONG_2020_2021.2", PARCC_Data_LONG_2020_2021.2)
save(Illinois_Data_LONG_2020_2021.2, file = "./Illinois/Data/Archive/2020_2021.2/Illinois_Data_LONG_2020_2021.2.Rdata")


#####
###   "Optional" variables for IL according to Growth Layout (v1)
###   All blank for BIE & DoDEA
#####

table(PARCC_Data_LONG_2020_2021.2[, LearningOption], exclude=NULL)
table(PARCC_Data_LONG_2020_2021.2[, TestingLocation], exclude=NULL)
