################################################################################
###                                                                          ###
###              Create PARCC LONG Data for Spring 2019 Analyses             ###
###                                                                          ###
################################################################################

### Load required packages

require(SGP)
require(data.table)

###  Set working directory to top level directory (PARCC)

###
###    Read in Spring 2019 Pearson base data
###

####  Set names based on Pearson file layout
parcc.var.names <- c("AssessmentYear", "StateAbbreviation", "PANUniqueStudentID", "GradeLevelWhenAssessed", "Period", "TestCode", "TestFormat",
                     "SummativeScoreRecordUUID", "StudentTestUUID", "SummativeScaleScore", "IRTTheta", "SummativeCSEM", "ThetaSEM")

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

all.var.names <- c(parcc.var.names[1:11], center.var.names[1:4], parcc.var.names[12:13], center.var.names[5:44])

####   Function to read in individual state files

read.parcc <- function(state, year) {
	tmp.name <- gsub(" ", "_", SGP:::getStateAbbreviation(state, type="state"))
  if (state == "DD") tmp.name <- "Department_Of_Defense" else tmp.name <- gsub(" ", "_", SGP:::getStateAbbreviation(state, type="state"))
	if (tmp.name=="WASHINGTON_DC") tmp.name <- "Washington_DC"
	tmp.files <- list.files(file.path(tmp.name, "Data/Base_Files"))
	my.file <- gsub(".zip",  "", grep(year, tmp.files, value=TRUE))
	tmp.dir <- getwd()
	setwd(tempdir())
	system(paste0("unzip '", file.path(tmp.dir, tmp.name, "Data/Base_Files", paste0(my.file, ".zip")), "'"))

	TMP <- fread(my.file, sep=",", colClasses=rep("character", length(all.var.names)))
	unlink(my.file)
	setwd(tmp.dir)
	return(TMP)
}

####   Spring 2019

PARCC_Data_LONG_2018_2019.2 <- fread("./Bureau_Indian_Affairs/Data/Base_Files/PARCC_BI_2018-2019_SGPO_D20190606.csv", colClasses=rep("character", length(all.var.names)))[, parcc.var.names, with=FALSE]
PARCC_Data_LONG_2018_2019.2 <- read.parcc("IL", "D20190624")[, parcc.var.names, with=FALSE]
PARCC_Data_LONG_2018_2019.2 <- fread("./New_Mexico/Data/Base_Files/PARCC_NM_2018-2019_SGPO_D20190611.csv", colClasses=rep("character", length(all.var.names)))[, parcc.var.names, with=FALSE]
PARCC_Data_LONG_2018_2019.2 <- fread("./Department_Of_Defense/Data/Base_Files/PARCC_DD_2018-2019_SGPO_D20190613.csv", colClasses=rep("character", length(all.var.names)))[, parcc.var.names, with=FALSE]
PARCC_Data_LONG_2018_2019.2 <- read.parcc("MD", "D20190621")[, parcc.var.names, with=FALSE]
PARCC_Data_LONG_2018_2019.2 <- read.parcc("NJ", "D20190619")[, parcc.var.names, with=FALSE] # Had to add extra commas at the end of pre-equated file
PARCC_Data_LONG_2018_2019.2 <- read.parcc("DC", "D20190627")[, parcc.var.names, with=FALSE]

PARCC_Data_LONG_2018_2019.2 <- rbindlist(list(
  read.parcc("BI", "D20190606"), read.parcc("DC", "D20190629")
  read.parcc("DD", "D20190613"), read.parcc("IL", "D20190624"),
  read.parcc("MD", "D20190629"), read.parcc("NJ", "D20190629"),
  read.parcc("NM", "D20190629")))[, parcc.var.names, with=FALSE]

setkey(PARCC_Data_LONG_2018_2019.2, PANUniqueStudentID, TestCode, Period)

###
###       Data Cleaning  -  Create Required SGP Variables
###

####  ID
setnames(PARCC_Data_LONG_2018_2019.2, "PANUniqueStudentID", "ID")

####  CONTENT_AREA from TestCode
PARCC_Data_LONG_2018_2019.2[, CONTENT_AREA := factor(TestCode)]
# levels(PARCC_Data_LONG_2018_2019.2$CONTENT_AREA) <- c(rep("ELA", 6), rep("MATHEMATICS", 6)) # IL test run
# levels(PARCC_Data_LONG_2018_2019.2$CONTENT_AREA) <- c("ALGEBRA_I", "ALGEBRA_II", rep("ELA", 4), "GEOMETRY", rep("MATHEMATICS", 4)) # DoDEA
levels(PARCC_Data_LONG_2018_2019.2$CONTENT_AREA) <- c("ALGEBRA_I", "ALGEBRA_II", rep("ELA", 9), "GEOMETRY", rep("MATHEMATICS", 6), "INTEGRATED_MATH_1", "INTEGRATED_MATH_2", "INTEGRATED_MATH_3")
PARCC_Data_LONG_2018_2019.2[, CONTENT_AREA := as.character(CONTENT_AREA)]

####  GRADE from TestCode
PARCC_Data_LONG_2018_2019.2[, GRADE := gsub("ELA|MAT", "", TestCode)]
PARCC_Data_LONG_2018_2019.2[, GRADE := as.character(as.numeric(GRADE))]
PARCC_Data_LONG_2018_2019.2[which(is.na(GRADE)), GRADE := "EOCT"]
PARCC_Data_LONG_2018_2019.2[, GRADE := as.character(GRADE)]
table(PARCC_Data_LONG_2018_2019.2[, GRADE, TestCode])

####  YEAR
PARCC_Data_LONG_2018_2019.2[, YEAR := gsub("-", "_", AssessmentYear)]
PARCC_Data_LONG_2018_2019.2[which(Period == "Spring"), YEAR := paste(YEAR, "2", sep=".")]


####
####  Establish seperate Theta and Scale Score long data sets
####

PARCC_Data_LONG_SS <- copy(PARCC_Data_LONG_2018_2019.2)

PARCC_Data_LONG_SS[, c("IRTTheta", "ThetaSEM") := NULL]
PARCC_Data_LONG_SS[, CONTENT_AREA := paste(CONTENT_AREA, "SS", sep="_")]
setnames(PARCC_Data_LONG_SS, c("SummativeScaleScore", "SummativeCSEM"), c("SCALE_SCORE", "SCALE_SCORE_CSEM"))

####  Theta data set - create IRT CSEM First
scaling.constants <- as.data.table(read.csv("./PARCC/Data/Base_Files/2015-2016 PARCC Scaling Constants.csv")) # Same as spring 2016 per Pat Taylor 2/10/17
setkey(scaling.constants, CONTENT_AREA, GRADE)
setkey(PARCC_Data_LONG_2018_2019.2, CONTENT_AREA, GRADE)
PARCC_Data_LONG_2018_2019.2 <- scaling.constants[PARCC_Data_LONG_2018_2019.2]

PARCC_Data_LONG_2018_2019.2[, SCALE_SCORE_CSEM := (as.numeric(SummativeCSEM))/a] # NO -b here...
# summary(PARCC_Data_LONG_2018_2019.2[, as.numeric(IRTTheta)])

PARCC_Data_LONG_2018_2019.2[, c("a", "b", "ThetaSEM") := NULL]

setnames(PARCC_Data_LONG_2018_2019.2, c("IRTTheta", "SummativeScaleScore", "SummativeCSEM"), c("SCALE_SCORE", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_CSEM_ACTUAL"))


####  Stack Theta and SS Data
PARCC_Data_LONG_2018_2019.2 <- rbindlist(list(PARCC_Data_LONG_2018_2019.2, PARCC_Data_LONG_SS), fill=TRUE)
PARCC_Data_LONG_2018_2019.2[, CONTENT_AREA := as.character(CONTENT_AREA)]

####  Valid Cases
PARCC_Data_LONG_2018_2019.2[, VALID_CASE := "VALID_CASE"]

####  Invalidate Cases with missing IDs - 0 invalid in FINAL data
PARCC_Data_LONG_2018_2019.2[which(is.na(ID)), VALID_CASE := "INVALID_CASE"]

####  ACHIEVEMENT_LEVEL
PARCC_Data_LONG_2018_2019.2 <- SGP:::getAchievementLevel(PARCC_Data_LONG_2018_2019.2, state="PARCC")

table(PARCC_Data_LONG_2018_2019.2[, ACHIEVEMENT_LEVEL, CONTENT_AREA], exclude=NULL)
# gl <- c("ELA", "ELA_SS", "MATHEMATICS", "MATHEMATICS_SS")
# PARCC_Data_LONG_2018_2019.2[!CONTENT_AREA %in% gl, list(MAX= max(as.numeric(SCALE_SCORE))), keyby=c("CONTENT_AREA", "ACHIEVEMENT_LEVEL")] # summary(as.numeric(SCALE_SCORE))
# PARCC_Data_LONG_2018_2019.2[CONTENT_AREA == "ELA", list(MIN= min(as.numeric(SCALE_SCORE))), keyby=c("CONTENT_AREA", "ACHIEVEMENT_LEVEL", "GRADE")]
# SGPstateData[["PARCC"]][["Achievement"]][["Cutscores"]]$ELA.2015_2016.2

####  Invalidate 9th grade Cases for Washington DC
#
#  email from K Johnson April 27, 2018
#  1. ELA09 will always be excluded
#  2. Algebra I and Integrated Math I will be excluded when the "Grade Level When Assessed" field is = 09, 10, 11, 12, 13, 99, OS or PS
#
# table(PARCC_Data_LONG_2018_2019.2[StateAbbreviation == "DC", TestCode, GradeLevelWhenAssessed])

PARCC_Data_LONG_2018_2019.2[StateAbbreviation == "DC" & TestCode == "ELA09", VALID_CASE := "INVALID_CASE"] # 6,936 cases
PARCC_Data_LONG_2018_2019.2[StateAbbreviation == "DC" & TestCode == "ALG01" & GradeLevelWhenAssessed %in% c("09", "10", "11", "12", "99"), VALID_CASE := "INVALID_CASE"] # 5,528 cases
# PARCC_Data_LONG_2018_2019.2[StateAbbreviation == "DC" & TestCode == "MAT1I" & GradeLevelWhenAssessed %in% c("09", "10", "11", "12", "99"), VALID_CASE := "INVALID_CASE"] # 0 cases


####

####
####  Duplicates
####  DON'T FIX DUPLICATES!  Per email from Pat Taylor 7/18/16
####

#X#  Exact duplicates still need to be dealt with
PARCC_Data_LONG_2018_2019.2[, EXACT_DUPLICATE := as.numeric(NA)]

setkey(PARCC_Data_LONG_2018_2019.2, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID, SCALE_SCORE_ACTUAL, SCALE_SCORE)
dups <- PARCC_Data_LONG_2018_2019.2[c(which(duplicated(PARCC_Data_LONG_2018_2019.2, by=key(PARCC_Data_LONG_2018_2019.2))), which(duplicated(PARCC_Data_LONG_2018_2019.2, by=key(PARCC_Data_LONG_2018_2019.2)))-1),]
setkeyv(dups, key(PARCC_Data_LONG_2018_2019.2))
PARCC_Data_LONG_2018_2019.2[which(duplicated(PARCC_Data_LONG_2018_2019.2, by=key(PARCC_Data_LONG_2018_2019.2)))-1, EXACT_DUPLICATE := 1]
PARCC_Data_LONG_2018_2019.2[which(duplicated(PARCC_Data_LONG_2018_2019.2, by=key(PARCC_Data_LONG_2018_2019.2))), EXACT_DUPLICATE := 2]
PARCC_Data_LONG_2018_2019.2[which(duplicated(PARCC_Data_LONG_2018_2019.2, by=key(PARCC_Data_LONG_2018_2019.2))), VALID_CASE := "INVALID_CASE"]

#X#  17 (8 - NM, 1 - NJ) dups in same grade.  Shouldn't be an issue and Pearson/PARCC requested duplicate results for current year as of ?2016?
setkey(PARCC_Data_LONG_2018_2019.2, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID, SCALE_SCORE)
setkey(PARCC_Data_LONG_2018_2019.2, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID)
dups <- PARCC_Data_LONG_2018_2019.2[c(which(duplicated(PARCC_Data_LONG_2018_2019.2, by=key(PARCC_Data_LONG_2018_2019.2))), which(duplicated(PARCC_Data_LONG_2018_2019.2, by=key(PARCC_Data_LONG_2018_2019.2)))-1),]
# PARCC_Data_LONG_2018_2019.2[which(duplicated(PARCC_Data_LONG_2018_2019.2, by=key(PARCC_Data_LONG_2018_2019.2)))-1, VALID_CASE := "INVALID_CASE"]

#X#  Duplicates if grade ignored  -  0 more (all same grade)
# setkey(PARCC_Data_LONG_2018_2019.2, VALID_CASE, YEAR, CONTENT_AREA, ID, SCALE_SCORE)
# setkey(PARCC_Data_LONG_2018_2019.2, VALID_CASE, YEAR, CONTENT_AREA, ID)
### PARCC_Data_LONG_2018_2019.2[which(duplicated(PARCC_Data_LONG_2018_2019.2, by=key(PARCC_Data_LONG_2018_2019.2)))-1, VALID_CASE := "INVALID_CASE"]


####  Save Spring 2019 LONG Data

require(RSQLite)
parcc.db <- "./PARCC/Data/PARCC_Data_LONG.sqlite"

con <- dbConnect(SQLite(), dbname = parcc.db)
db.order <- dbListFields(con, name = "PARCC_Data_LONG_2015_2") # Use PARCC_Data_LONG_2015_2 table's var order for all future tables
dbDisconnect(con)

setcolorder(PARCC_Data_LONG_2018_2019.2, c(db.order, "ACHIEVEMENT_LEVEL", "EXACT_DUPLICATE")) # To match original var order

PARCC_Data_LONG_2018_2019.2[, GRADE := as.character(GRADE)]
PARCC_Data_LONG_2018_2019.2[, SCALE_SCORE := as.numeric(SCALE_SCORE)]
PARCC_Data_LONG_2018_2019.2[, SCALE_SCORE_CSEM := as.numeric(SCALE_SCORE_CSEM)]
PARCC_Data_LONG_2018_2019.2[, SCALE_SCORE_ACTUAL := as.numeric(SCALE_SCORE_ACTUAL)]
PARCC_Data_LONG_2018_2019.2[, SCALE_SCORE_CSEM_ACTUAL := as.numeric(SCALE_SCORE_CSEM_ACTUAL)]

####  Save Spring 2019 individual states LONG data
dir.create("./Washington_DC/Data/Archive/2018_2019.2", recursive = TRUE)
assign("Washington_DC_Data_LONG_2018_2019.2", PARCC_Data_LONG_2018_2019.2)

# load("./New_Mexico/Data/Archive/2018_2019.2/PARCC_Data_LONG_2018_2019.2.Rdata")
# names(New_Mexico_Data_LONG_2018_2019.2) %in% names(PARCC_Data_LONG_2018_2019.2)
# identical(PARCC_Data_LONG_2018_2019.2, New_Mexico_Data_LONG_2018_2019.2)
# sapply(1:19, function(z) identical(PARCC_Data_LONG_2018_2019.2[[z]], New_Mexico_Data_LONG_2018_2019.2[[z]]))

save(Washington_DC_Data_LONG_2018_2019.2, file = "./Washington_DC/Data/Archive/2018_2019.2/Washington_DC_Data_LONG_2018_2019.2.Rdata")



####  Save Spring 2019 LONG Data

save(PARCC_Data_LONG_2018_2019.2, file = "./PARCC/Data/Archive/2018_2019.2/PARCC_Data_LONG_2018_2019.2.Rdata")


#####  Add Spring 2019 LONG data to existing SQLite Database.  Tables stored by each year / period

con <- dbConnect(SQLite(), dbname = parcc.db)
dbWriteTable(con, name = "PARCC_Data_LONG_2019_2", value=PARCC_Data_LONG_2018_2019.2, overwrite=TRUE)
dbDisconnect(con)
