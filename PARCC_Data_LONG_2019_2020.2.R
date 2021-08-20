################################################################################
###                                                                          ###
###     Create PARCC (Illinois ONLY) LONG Data for Spring 2020 Analyses      ###
###                                                                          ###
################################################################################

### Load required packages

require(SGP)
require(data.table)

###  Set working directory to top level directory (PARCC)

#####
###   Read in Spring 2020 Pearson base data
#####

###   Set names based on Pearson file layout
parcc.var.names <- c("AssessmentYear", "StateAbbreviation", "PANUniqueStudentID", "GradeLevelWhenAssessed", "Period", "TestCode", "TestFormat",
                     "SummativeScoreRecordUUID", "StudentTestUUID", "SummativeScaleScore", "IRTTheta", "SummativeCSEM", "ThetaSEM", "FormID")

center.var.names <- c("SGPIRTThetaState1Prior", "SGPIRTThetaState2Prior", "SGPIRTThetaPARCC1Prior", "SGPIRTThetaPARCC2Prior",
                      "StudentGrowthPercentileComparedtoState", "StudentGrowthPercentileComparedtoState1Prior", "StudentGrowthPercentileComparedtoState2Prior",
                      "StudentGrowthPercentileComparedtoPARCC", "StudentGrowthPercentileComparedtoPARCC1Prior", "StudentGrowthPercentileComparedtoPARCC2Prior",
                      "SGPPreviousTestCodeState", "SGPPreviousTestCodeState1Prior", "SGPPreviousTestCodeState2Prior",
                      "SGPPreviousTestCodePARCC", "SGPPreviousTestCodePARCC1Prior", "SGPPreviousTestCodePARCC2Prior",
                      "SGPUpperBoundState", "SGPUpperBoundState1Prior", "SGPUpperBoundState2Prior", "SGPLowerBoundState", "SGPLowerBoundState1Prior", "SGPLowerBoundState2Prior",
                      "SGPUpperBoundPARCC", "SGPUpperBoundPARCC1Prior", "SGPUpperBoundPARCC2Prior", "SGPLowerBoundPARCC", "SGPLowerBoundPARCC1Prior", "SGPLowerBoundPARCC2Prior",
                      "SGPStandardErrorState", "SGPStandardErrorState1Prior", "SGPStandardErrorState2Prior",
                      "SGPStandardErrorPARCC", "SGPStandardErrorPARCC1Prior", "SGPStandardErrorPARCC2Prior",
                      "SGPRankedSimexState", "SGPRankedSimexState1Prior", "SGPRankedSimexState2Prior",
                      "SGPRankedSimexPARCC", "SGPRankedSimexPARCC1Prior", "SGPRankedSimexPARCC2Prior",
                      "SGPTargetState", "SGPTargetPARCC", "SGPTargetTestCodeState", "SGPTargetTestCodePARCC")

all.var.names <- c(parcc.var.names[1:11], center.var.names[1:4], parcc.var.names[12:13], center.var.names[5:44], parcc.var.names[14])

###   Spring 2020

PARCC_Data_LONG_2019_2020.2 <- fread("./Illinois/Data/Base_Files/PARCC_IL_2019-2020_SGPO_D20201222.csv", colClasses=rep("character", length(all.var.names)))[, parcc.var.names, with=FALSE]

setkey(PARCC_Data_LONG_2019_2020.2, PANUniqueStudentID, TestCode, Period)

#####
###   Data Cleaning  -  Create Required SGP Variables
#####

###   ID
setnames(PARCC_Data_LONG_2019_2020.2, "PANUniqueStudentID", "ID")

###   CONTENT_AREA from TestCode
PARCC_Data_LONG_2019_2020.2[, CONTENT_AREA := factor(TestCode)]
levels(PARCC_Data_LONG_2019_2020.2$CONTENT_AREA) <- c(rep("ELA", 6), rep("MATHEMATICS", 6)) # IL test run
PARCC_Data_LONG_2019_2020.2[, CONTENT_AREA := as.character(CONTENT_AREA)]

###   GRADE from TestCode
PARCC_Data_LONG_2019_2020.2[, GRADE := gsub("ELA|MAT", "", TestCode)]
PARCC_Data_LONG_2019_2020.2[, GRADE := as.character(as.numeric(GRADE))]
# table(PARCC_Data_LONG_2019_2020.2[, GRADE, TestCode])

###   YEAR
PARCC_Data_LONG_2019_2020.2[, YEAR := gsub("-", "_", AssessmentYear)]
PARCC_Data_LONG_2019_2020.2[which(Period == "Spring"), YEAR := paste(YEAR, "2", sep=".")]


####
###   Establish IRT CSEM
####

scaling.constants <- as.data.table(read.csv("./PARCC/Data/Base_Files/2015-2016 PARCC Scaling Constants.csv")) # Same as spring 2016 per Pat Taylor 2/10/17
setkey(scaling.constants, CONTENT_AREA, GRADE)
setkey(PARCC_Data_LONG_2019_2020.2, CONTENT_AREA, GRADE)
PARCC_Data_LONG_2019_2020.2 <- scaling.constants[PARCC_Data_LONG_2019_2020.2]

PARCC_Data_LONG_2019_2020.2[, SCALE_SCORE_CSEM := (as.numeric(SummativeCSEM))/a] # NO -b here...

PARCC_Data_LONG_2019_2020.2[, c("a", "b", "ThetaSEM") := NULL]

setnames(PARCC_Data_LONG_2019_2020.2, c("IRTTheta", "SummativeScaleScore", "SummativeCSEM"), c("SCALE_SCORE", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_CSEM_ACTUAL"))


###   Valid Cases
PARCC_Data_LONG_2019_2020.2[, VALID_CASE := "VALID_CASE"]

###   Invalidate Cases with missing IDs - 0 invalid in FINAL data
PARCC_Data_LONG_2019_2020.2[ID=="", VALID_CASE := "INVALID_CASE"]  #  | is.na(ID)

###   ACHIEVEMENT_LEVEL
PARCC_Data_LONG_2019_2020.2 <- SGP:::getAchievementLevel(PARCC_Data_LONG_2019_2020.2, state="PARCC")
table(PARCC_Data_LONG_2019_2020.2[, ACHIEVEMENT_LEVEL, CONTENT_AREA], exclude=NULL)


#####
###   Duplicates
###   DON'T FIX DUPLICATES!  Per email from Pat Taylor 7/18/16
#####

#X#  Exact duplicates still need to be dealt with (if present)
PARCC_Data_LONG_2019_2020.2[, EXACT_DUPLICATE := as.numeric(NA)]

setkey(PARCC_Data_LONG_2019_2020.2, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID, SCALE_SCORE_ACTUAL, SCALE_SCORE)
dups <- PARCC_Data_LONG_2019_2020.2[c(which(duplicated(PARCC_Data_LONG_2019_2020.2, by=key(PARCC_Data_LONG_2019_2020.2))), which(duplicated(PARCC_Data_LONG_2019_2020.2, by=key(PARCC_Data_LONG_2019_2020.2)))-1),]
setkeyv(dups, key(PARCC_Data_LONG_2019_2020.2))
PARCC_Data_LONG_2019_2020.2[which(duplicated(PARCC_Data_LONG_2019_2020.2, by=key(PARCC_Data_LONG_2019_2020.2)))-1, EXACT_DUPLICATE := 1]
PARCC_Data_LONG_2019_2020.2[which(duplicated(PARCC_Data_LONG_2019_2020.2, by=key(PARCC_Data_LONG_2019_2020.2))), EXACT_DUPLICATE := 2]
PARCC_Data_LONG_2019_2020.2[which(duplicated(PARCC_Data_LONG_2019_2020.2, by=key(PARCC_Data_LONG_2019_2020.2))), VALID_CASE := "INVALID_CASE"]


###   Final reformat of some variables
PARCC_Data_LONG_2019_2020.2[, GRADE := as.character(GRADE)]
PARCC_Data_LONG_2019_2020.2[, SCALE_SCORE := as.numeric(SCALE_SCORE)]
PARCC_Data_LONG_2019_2020.2[, SCALE_SCORE_CSEM := as.numeric(SCALE_SCORE_CSEM)]
PARCC_Data_LONG_2019_2020.2[, SCALE_SCORE_ACTUAL := as.numeric(SCALE_SCORE_ACTUAL)]
PARCC_Data_LONG_2019_2020.2[, SCALE_SCORE_CSEM_ACTUAL := as.numeric(SCALE_SCORE_CSEM_ACTUAL)]

###   Save Spring 2020 Illinois LONG data
dir.create("./Illinois/Data/Archive/2019_2020.2", recursive = TRUE)
assign("Illinois_Data_LONG_2019_2020.2", PARCC_Data_LONG_2019_2020.2)

save(Illinois_Data_LONG_2019_2020.2, file = "./Illinois/Data/Archive/2019_2020.2/Illinois_Data_LONG_2019_2020.2.Rdata")
