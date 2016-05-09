################################################################################
###                                                                          ###
###                 Create PARCC LONG Data for 2016 Analyses                 ###
###                                                                          ###
################################################################################

### Load required packages

require(SGP)
require(data.table)

###  Read in 2015 & 2016 Pearson base data

trimWhiteSpace <- function(line) gsub("(^ +)|( +$)", "", line)

PARCC_Data_LONG_2015 <- fread("~/Dropbox (SGP)/SGP/PARCC/PARCC/Data/Base_Files/Simulations/PARCC_Data_LONG_2015-Simulated.csv")
PARCC_Data_LONG_2016 <- fread("~/Dropbox (SGP)/SGP/PARCC/PARCC/Data/Base_Files/Simulations/PARCC_Data_LONG_2016-Simulated.csv")

###  Set names based on Pearson file layout
parcc.var.names <- c("AssessmentYear", "StateAbbreviation", "PARCCStudentIdentifier", "GradeLevelWhenAssessed", "Period", "TestCode", 
										 "SummativeScoreRecordUUID", "StudentTestUUID", "SummativeScaleScore", "IRTTheta", "SummativeCSEM", "Filler", "Mode")

center.var.names <- c("StudentGrowthPercentileComparedtoState", "StudentGrowthPercentileComparedtoPARCC", "SGPPreviousTestCodeState",
											"SGPPreviousTestCodePARCC", "SGPUpperBoundState", "SGPLowerBoundState", "SGPUpperBoundPARCC", "SGPLowerBoundPARCC")

setnames(PARCC_Data_LONG_2015, parcc.var.names)
setnames(PARCC_Data_LONG_2016, parcc.var.names)

####   Create PARCC_Data_LONG with Constructed Vars included
PARCC_Data_LONG <- rbindlist(list(PARCC_Data_LONG_2015, PARCC_Data_LONG_2016))

###
###       Data Cleaning
###

###   Create New Required Variables

####  ID
setnames(PARCC_Data_LONG, "PARCCStudentIdentifier", "ID")

####  CONTENT_AREA from TestCode
PARCC_Data_LONG[, CONTENT_AREA := factor(TestCode)]
levels(PARCC_Data_LONG$CONTENT_AREA) <- c("", "ALGEBRA_I", "ALGEBRA_II", rep("ELA", 9), "GEOMETRY", rep("MATHEMATICS", 6), "INTEGRATED_MATH_1", "INTEGRATED_MATH_2", "INTEGRATED_MATH_3")
PARCC_Data_LONG[, CONTENT_AREA := as.character(CONTENT_AREA)]

####  GRADE from GradeLevelWhenAssessed
PARCC_Data_LONG[, GRADE := as.character(as.numeric(GradeLevelWhenAssessed))]
PARCC_Data_LONG[which(!CONTENT_AREA %in% c("ELA", "MATHEMATICS")), GRADE := "EOCT"]

####  YEAR
PARCC_Data_LONG[, YEAR := gsub("-", "_", AssessmentYear)]
PARCC_Data_LONG[which(Period == "FallBlock"), YEAR := paste(YEAR, "1", sep=".")]
PARCC_Data_LONG[which(Period == "Spring"), YEAR := paste(YEAR, "2", sep=".")]

####  Valid Cases
PARCC_Data_LONG[, VALID_CASE := "VALID_CASE"]

####  Invalidate Cases with missing IDs
PARCC_Data_LONG[which(is.na(ID)), VALID_CASE := "INVALID_CASE"]

####  Invalidate Grades not used:
PARCC_Data_LONG[which(GRADE %in% c(NA,1,2,12)), VALID_CASE := "INVALID_CASE"]
PARCC_Data_LONG[which(GRADE %in% 9:11 & CONTENT_AREA == "MATHEMATICS"), VALID_CASE := "INVALID_CASE"]

####  Duplicates
setkey(PARCC_Data_LONG, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID, SummativeScaleScore)
setkey(PARCC_Data_LONG, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID)
# sum(duplicated(PARCC_Data_LONG[VALID_CASE != "INVALID_CASE"])) # 10 duplicates with valid SSIDs -- all NJ
PARCC_Data_LONG[which(duplicated(PARCC_Data_LONG))-1, VALID_CASE := "INVALID_CASE"]


#  Still 4 kids with duplicates if Grade ignored -- take highest SummativeScaleScore again ...
setkey(PARCC_Data_LONG, VALID_CASE, YEAR, CONTENT_AREA, ID, SummativeScaleScore)
setkey(PARCC_Data_LONG, VALID_CASE, YEAR, CONTENT_AREA, ID)
PARCC_Data_LONG[which(duplicated(PARCC_Data_LONG))-1, VALID_CASE := "INVALID_CASE"]


####  Finish the "Center Prep'd Data" Simulation - double length

PARCC_Data_LONG_SS <- copy(PARCC_Data_LONG)

PARCC_Data_LONG_SS[, IRTTheta := NULL]
PARCC_Data_LONG_SS[, CONTENT_AREA := paste(CONTENT_AREA, "SS", sep="_")]
setnames(PARCC_Data_LONG_SS, c("SummativeScaleScore", "SummativeCSEM"), c("SCALE_SCORE", "SCALE_SCORE_CSEM"))

####  Theta data set  -  create IRT CSEM First
scaling.constants <- as.data.table(read.csv("~/Dropbox (SGP)/SGP/PARCC/PARCC/Data/Base_Files/2014-2015 PARCC Scaling Constants.csv"))
setkey(scaling.constants, CONTENT_AREA, GRADE)
setkey(PARCC_Data_LONG, CONTENT_AREA, GRADE)
PARCC_Data_LONG<- scaling.constants[PARCC_Data_LONG]

PARCC_Data_LONG[, SCALE_SCORE_CSEM := (as.numeric(SummativeCSEM))/a] # NO -b here...

PARCC_Data_LONG[, c("a", "b", "SummativeCSEM") := NULL]

setnames(PARCC_Data_LONG, c("IRTTheta", "SummativeScaleScore"), c("SCALE_SCORE", "SCALE_SCORE_ACTUAL"))

####  Stack Theta and SS Data
PARCC_Data_LONG <- rbindlist(list(PARCC_Data_LONG, PARCC_Data_LONG_SS), fill=TRUE)
PARCC_Data_LONG <- PARCC_Data_LONG[CONTENT_AREA!=""] #[!is.na(CONTENT_AREA)] - Hopefully not a problem with actual data
PARCC_Data_LONG[which(!is.na(SCALE_SCORE) & is.na(SCALE_SCORE_CSEM)), VALID_CASE := "INVALID_CASE"] # remove to avoid problems with SIMEX, etc.

save(PARCC_Data_LONG, file = "Data/PARCC_Data_LONG_Simulated.Rdata")
