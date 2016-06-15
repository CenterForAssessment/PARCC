################################################################################
###                                                                          ###
###        Format PARCC Spring 2016 Results Data to Return to Pearson        ###
###                                                                          ###
################################################################################

### Load required packages

require(SGP)
require(data.table)

setwd("~/PARCC")
setwd("/media/Data/Dropbox (SGP)/SGP/PARCC")

###
###    Read in Fall and Spring 2016 Output Files
###

####  Set names based on Pearson file layout
parcc.var.names <- c("AssessmentYear", "StateAbbreviation", "PARCCStudentIdentifier", "GradeLevelWhenAssessed", "Period", "TestCode", 
                     "SummativeScoreRecordUUID", "StudentTestUUID", "SummativeScaleScore", "IRTTheta", "SummativeCSEM", "Filler", "TestFormat")

center.var.names <- c("StudentGrowthPercentileComparedtoState", "StudentGrowthPercentileComparedtoPARCC", "SGPPreviousTestCodeState",
                      "SGPPreviousTestCodePARCC", "SGPUpperBoundState", "SGPLowerBoundState", "SGPUpperBoundPARCC", "SGPLowerBoundPARCC")

all.var.names <- c(head(parcc.var.names,-1), center.var.names, "TestFormat") # TestFormat is out of order



####  Spring 2016

PARCC_Data_LONG_2016 <- rbindlist(list(
	read.parcc("CO", "2015-2016"), read.parcc("IL", "2015-2016"), 
	read.parcc("MD", "2015-2016"), read.parcc("MA", "2015-2016"), 
	read.parcc("NJ", "2015-2016"), read.parcc("NM", "2015-2016"),
	read.parcc("RI", "2015-2016"), read.parcc("DC", "2015-2016")))

setkey(PARCC_Data_LONG_2016, PARCCStudentIdentifier, TestCode, Period)
PARCC_Data_LONG_2016 <- PARCC_Data_LONG_2016[, parcc.var.names, with=FALSE]


###
###       Data Cleaning  -  Create Required SGP Variables
###

####  ID
setnames(PARCC_Data_LONG, "PARCCStudentIdentifier", "ID")

####  CONTENT_AREA from TestCode
PARCC_Data_LONG[, CONTENT_AREA := factor(TestCode)]
levels(PARCC_Data_LONG$CONTENT_AREA) <- c("ALGEBRA_I", "ALGEBRA_II", rep("ELA", 9), "GEOMETRY", rep("MATHEMATICS", 6), "INTEGRATED_MATH_1", "INTEGRATED_MATH_2", "INTEGRATED_MATH_3")
PARCC_Data_LONG[, CONTENT_AREA := as.character(CONTENT_AREA)]

####  GRADE from TestCode
PARCC_Data_LONG[, GRADE := gsub("ELA|MAT", "", TestCode)]
PARCC_Data_LONG[, GRADE := as.character(as.numeric(GRADE))]
PARCC_Data_LONG[which(is.na(GRADE)), GRADE := "EOCT"]
PARCC_Data_LONG[, GRADE := as.character(GRADE)]

####  YEAR
PARCC_Data_LONG[, YEAR := gsub("-", "_", AssessmentYear)]
PARCC_Data_LONG[which(Period == "FallBlock"), YEAR := paste(YEAR, "1", sep=".")]
PARCC_Data_LONG[which(Period == "Spring"), YEAR := paste(YEAR, "2", sep=".")]

####  Valid Cases
PARCC_Data_LONG[, VALID_CASE := "VALID_CASE"]

####  Invalidate Cases with missing IDs
PARCC_Data_LONG[which(is.na(ID)), VALID_CASE := "INVALID_CASE"]

####  Duplicates
setkey(PARCC_Data_LONG, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID, SummativeScaleScore)
setkey(PARCC_Data_LONG, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID)
PARCC_Data_LONG[which(duplicated(PARCC_Data_LONG))-1, VALID_CASE := "INVALID_CASE"]

#  Duplicates if Grade ignored
setkey(PARCC_Data_LONG, VALID_CASE, YEAR, CONTENT_AREA, ID, SummativeScaleScore)
setkey(PARCC_Data_LONG, VALID_CASE, YEAR, CONTENT_AREA, ID)
PARCC_Data_LONG[which(duplicated(PARCC_Data_LONG))-1, VALID_CASE := "INVALID_CASE"]


####  Establish seperate Theta and Scale Score long data sets

PARCC_Data_LONG_SS <- copy(PARCC_Data_LONG)

PARCC_Data_LONG_SS[, IRTTheta := NULL]
PARCC_Data_LONG_SS[, CONTENT_AREA := paste(CONTENT_AREA, "SS", sep="_")]
setnames(PARCC_Data_LONG_SS, c("SummativeScaleScore", "SummativeCSEM"), c("SCALE_SCORE", "SCALE_SCORE_CSEM"))

####  Theta data set - create IRT CSEM First
scaling.constants <- as.data.table(read.csv("/media/Data/Dropbox (SGP)/SGP/PARCC/PARCC/Data/Base_Files/2015-2016 PARCC Scaling Constants.csv"))
setkey(scaling.constants, CONTENT_AREA, GRADE)
setkey(PARCC_Data_LONG, CONTENT_AREA, GRADE)
PARCC_Data_LONG <- scaling.constants[PARCC_Data_LONG]

PARCC_Data_LONG[, SCALE_SCORE_CSEM := (as.numeric(SummativeCSEM))/a] # NO -b here...

PARCC_Data_LONG[, c("a", "b", "SummativeCSEM") := NULL]

setnames(PARCC_Data_LONG, c("IRTTheta", "SummativeScaleScore"), c("SCALE_SCORE", "SCALE_SCORE_ACTUAL"))

####  Stack Theta and SS Data
PARCC_Data_LONG <- rbindlist(list(PARCC_Data_LONG, PARCC_Data_LONG_SS), fill=TRUE)
PARCC_Data_LONG[, CONTENT_AREA := as.character(CONTENT_AREA)]

####  Save 2016 LONG Data
save(PARCC_Data_LONG, file = "/media/Data/Dropbox (SGP)/SGP/PARCC/PARCC/Data/PARCC_Data_LONG_2016.Rdata")
