################################################################################
###                                                                          ###
###               Create PARCC LONG Data for Fall 2018 Analyses              ###
###                                                                          ###
################################################################################

### Load required packages

require(SGP)
require(data.table)

###  Set working directory to top level directory (PARCC)

###
###    Read in Fall 2018 Pearson base data
###

####  Set names based on Pearson file layout
parcc.var.names <- c("AssessmentYear", "StateAbbreviation", "PARCCStudentIdentifier", "GradeLevelWhenAssessed", "Period", "TestCode", "TestFormat",
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

####   Fall 2018

PARCC_Data_LONG_2018_2019.1 <- rbindlist(list(
  fread("Bureau_Indian_Affairs/Data/Base_Files/PARCC_BI_2018-2019_SGPO_D20190214.csv", colClasses=rep("character", length(all.var.names))),
  fread("Maryland/Data/Base_Files/PARCC_MD_2018-2019_SGPO_D20190215.csv", colClasses=rep("character", length(all.var.names))),
  fread("Maryland/Data/Base_Files/PARCC_MD_2018-2019_SGPO_D20190304.csv", colClasses=rep("character", length(all.var.names))),
  fread("New_Jersey/Data/Base_Files/PARCC_NJ_2018-2019_SGPO_D20190212.csv", colClasses=rep("character", length(all.var.names))),
  fread("New_Mexico/Data/Base_Files/PARCC_NM_2018-2019_SGPO_D20190214.csv", colClasses=rep("character", length(all.var.names)))))[, parcc.var.names, with=FALSE]

# PARCC_Data_LONG_2018_2019.1 <- fread("Maryland/Data/Base_Files/PARCC_MD_2018-2019_SGPO_D20190304.csv", colClasses=rep("character", length(all.var.names))) #  Use this to create `Additional_Maryland_Data_LONG_2018_2019.1`

setkey(PARCC_Data_LONG_2018_2019.1, PARCCStudentIdentifier, TestCode, Period)

###
###       Data Cleaning  -  Create Required SGP Variables
###

####  ID
setnames(PARCC_Data_LONG_2018_2019.1, "PARCCStudentIdentifier", "ID")

####  CONTENT_AREA from TestCode
PARCC_Data_LONG_2018_2019.1[, CONTENT_AREA := factor(TestCode)]
levels(PARCC_Data_LONG_2018_2019.1$CONTENT_AREA) <- c("ALGEBRA_I", "ALGEBRA_II", rep("ELA", 3), "GEOMETRY") # levels(PARCC_Data_LONG_2018_2019.1$CONTENT_AREA) <- c("ALGEBRA_I", "ELA")
PARCC_Data_LONG_2018_2019.1[, CONTENT_AREA := as.character(CONTENT_AREA)]

####  GRADE from TestCode
PARCC_Data_LONG_2018_2019.1[, GRADE := gsub("ELA|MAT", "", TestCode)]
PARCC_Data_LONG_2018_2019.1[, GRADE := as.character(as.numeric(GRADE))]
PARCC_Data_LONG_2018_2019.1[which(is.na(GRADE)), GRADE := "EOCT"]
PARCC_Data_LONG_2018_2019.1[, GRADE := as.character(GRADE)]
# table(PARCC_Data_LONG_2018_2019.1[, GRADE, TestCode])

####  YEAR
PARCC_Data_LONG_2018_2019.1[, YEAR := gsub("-", "_", AssessmentYear)]
PARCC_Data_LONG_2018_2019.1[which(Period == "FallBlock"), YEAR := paste(YEAR, "1", sep=".")]


####
####  Establish seperate Theta and Scale Score long data sets
####

PARCC_Data_LONG_SS <- copy(PARCC_Data_LONG_2018_2019.1)

PARCC_Data_LONG_SS[, c("IRTTheta", "ThetaSEM") := NULL]
PARCC_Data_LONG_SS[, CONTENT_AREA := paste(CONTENT_AREA, "SS", sep="_")]
setnames(PARCC_Data_LONG_SS, c("SummativeScaleScore", "SummativeCSEM"), c("SCALE_SCORE", "SCALE_SCORE_CSEM"))

####  Theta data set - create IRT CSEM First
scaling.constants <- as.data.table(read.csv("./PARCC/Data/Base_Files/2015-2016 PARCC Scaling Constants.csv")) # Same as spring 2016 per Pat Taylor 2/10/17
setkey(scaling.constants, CONTENT_AREA, GRADE)
setkey(PARCC_Data_LONG_2018_2019.1, CONTENT_AREA, GRADE)
PARCC_Data_LONG_2018_2019.1 <- scaling.constants[PARCC_Data_LONG_2018_2019.1]

PARCC_Data_LONG_2018_2019.1[, SCALE_SCORE_CSEM := (as.numeric(SummativeCSEM))/a] # NO -b here...
# summary(PARCC_Data_LONG_2018_2019.1[, as.numeric(IRTTheta)])

PARCC_Data_LONG_2018_2019.1[, c("a", "b", "ThetaSEM") := NULL]

setnames(PARCC_Data_LONG_2018_2019.1, c("IRTTheta", "SummativeScaleScore", "SummativeCSEM"), c("SCALE_SCORE", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_CSEM_ACTUAL"))


####  Stack Theta and SS Data
PARCC_Data_LONG_2018_2019.1 <- rbindlist(list(PARCC_Data_LONG_2018_2019.1, PARCC_Data_LONG_SS), fill=TRUE)
PARCC_Data_LONG_2018_2019.1[, CONTENT_AREA := as.character(CONTENT_AREA)]

####  Valid Cases
PARCC_Data_LONG_2018_2019.1[, VALID_CASE := "VALID_CASE"]

####  Invalidate Cases with missing IDs - 0 invalid in FINAL data
PARCC_Data_LONG_2018_2019.1[which(is.na(ID)), VALID_CASE := "INVALID_CASE"]

####  ACHIEVEMENT_LEVEL
PARCC_Data_LONG_2018_2019.1 <- SGP:::getAchievementLevel(PARCC_Data_LONG_2018_2019.1, state="PARCC")
table(PARCC_Data_LONG_2018_2019.1[, ACHIEVEMENT_LEVEL, CONTENT_AREA], exclude=NULL) # Doesn't allign perfectly ...

####
####  Duplicates
####  DON'T FIX DUPLICATES!  Per email from Pat Taylor 7/18/16
####

#X#  Exact duplicates still need to be dealt with
PARCC_Data_LONG_2018_2019.1[, EXACT_DUPLICATE := as.numeric(NA)]

#X#  0 Duplicates in Fall 2018 data

# setkey(PARCC_Data_LONG_2018_2019.1, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID, SCALE_SCORE_ACTUAL, SCALE_SCORE)
# dups <- PARCC_Data_LONG_2018_2019.1[c(which(duplicated(PARCC_Data_LONG_2018_2019.1, by=key(PARCC_Data_LONG_2018_2019.1))), which(duplicated(PARCC_Data_LONG_2018_2019.1, by=key(PARCC_Data_LONG_2018_2019.1)))-1),]
# setkeyv(dups, key(PARCC_Data_LONG_2018_2019.1))
# PARCC_Data_LONG_2018_2019.1[which(duplicated(PARCC_Data_LONG_2018_2019.1, by=key(PARCC_Data_LONG_2018_2019.1)))-1, EXACT_DUPLICATE := 1]
# PARCC_Data_LONG_2018_2019.1[which(duplicated(PARCC_Data_LONG_2018_2019.1, by=key(PARCC_Data_LONG_2018_2019.1))), EXACT_DUPLICATE := 2]
# PARCC_Data_LONG_2018_2019.1[which(duplicated(PARCC_Data_LONG_2018_2019.1, by=key(PARCC_Data_LONG_2018_2019.1))), VALID_CASE := "INVALID_CASE"]

#X#  0 dups in same grade.  Shouldn't be an issue and Pearson/PARCC requested duplicate results for current year as of ?2016?
# setkey(PARCC_Data_LONG_2018_2019.1, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID, SCALE_SCORE)
# setkey(PARCC_Data_LONG_2018_2019.1, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID)
# dups <- PARCC_Data_LONG_2018_2019.1[c(which(duplicated(PARCC_Data_LONG_2018_2019.1, by=key(PARCC_Data_LONG_2018_2019.1))), which(duplicated(PARCC_Data_LONG_2018_2019.1, by=key(PARCC_Data_LONG_2018_2019.1)))-1),]
# PARCC_Data_LONG_2018_2019.1[which(duplicated(PARCC_Data_LONG_2018_2019.1, by=key(PARCC_Data_LONG_2018_2019.1)))-1, VALID_CASE := "INVALID_CASE"]

#X#  Duplicates if grade ignored  -  524 ( 524/2/2 = 131 duplicates -- mostly Maryland - looks like took 10th and 11th ELA -- table(dups[, GRADE, CONTENT_AREA])  )
# setkey(PARCC_Data_LONG_2018_2019.1, VALID_CASE, YEAR, CONTENT_AREA, ID, SCALE_SCORE)
# setkey(PARCC_Data_LONG_2018_2019.1, VALID_CASE, YEAR, CONTENT_AREA, ID)
# dups <- PARCC_Data_LONG_2018_2019.1[c(which(duplicated(PARCC_Data_LONG_2018_2019.1, by=key(PARCC_Data_LONG_2018_2019.1))), which(duplicated(PARCC_Data_LONG_2018_2019.1, by=key(PARCC_Data_LONG_2018_2019.1)))-1),]
# setkeyv(dups, key(PARCC_Data_LONG_2018_2019.1))
### PARCC_Data_LONG_2018_2019.1[which(duplicated(PARCC_Data_LONG_2018_2019.1, by=key(PARCC_Data_LONG_2018_2019.1)))-1, VALID_CASE := "INVALID_CASE"]


####  Save Fall 2018 LONG Data

require(RSQLite)
parcc.db <- "./PARCC/Data/PARCC_Data_LONG.sqlite"

con <- dbConnect(SQLite(), dbname = parcc.db)
db.order <- dbListFields(con, name = "PARCC_Data_LONG_2015_2") # Use PARCC_Data_LONG_2015_2 table's var order for all future tables
dbDisconnect(con)

setcolorder(PARCC_Data_LONG_2018_2019.1, c(db.order, "ACHIEVEMENT_LEVEL", "EXACT_DUPLICATE")) # To match original var order

PARCC_Data_LONG_2018_2019.1[, GRADE := as.character(GRADE)]
PARCC_Data_LONG_2018_2019.1[, SCALE_SCORE := as.numeric(SCALE_SCORE)]
PARCC_Data_LONG_2018_2019.1[, SCALE_SCORE_CSEM := as.numeric(SCALE_SCORE_CSEM)]
PARCC_Data_LONG_2018_2019.1[, SCALE_SCORE_ACTUAL := as.numeric(SCALE_SCORE_ACTUAL)]
PARCC_Data_LONG_2018_2019.1[, SCALE_SCORE_CSEM_ACTUAL := as.numeric(SCALE_SCORE_CSEM_ACTUAL)]

####  Save Fall 2018 LONG Data

# dir.create("./PARCC/Data/Archive/2018_2019.1/")
save(PARCC_Data_LONG_2018_2019.1, file = "./PARCC/Data/Archive/2018_2019.1/PARCC_Data_LONG_2018_2019.1.Rdata")

# Additional_Maryland_Data_LONG_2018_2019.1 <- PARCC_Data_LONG_2018_2019.1 #  Format additional data seperately for `updateSGP` of PARCC_SGP object
# save(Additional_Maryland_Data_LONG_2018_2019.1, file = "./Maryland/Data/Archive/2018_2019.1/Additional_Maryland_Data_LONG_2018_2019.1.Rdata")


#####  Add Fall 2018 LONG data to existing SQLite Database.  Tables stored by each year / period

con <- dbConnect(SQLite(), dbname = parcc.db)
dbWriteTable(con, name = "PARCC_Data_LONG_2019_1", value=PARCC_Data_LONG_2018_2019.1, overwrite=TRUE)
dbDisconnect(con)
