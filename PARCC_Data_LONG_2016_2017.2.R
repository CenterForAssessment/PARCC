################################################################################
###                                                                          ###
###              Create PARCC LONG Data for Spring 2017 Analyses             ###
###                                                                          ###
################################################################################

### Load required packages

require(SGP)
require(data.table)

###  Set working directory to top level directory (PARCC)

###
###    Read in Spring 2017 Pearson base data
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

####   Function to read in individual state files

read.parcc <- function(state, year, Fall=FALSE) {
	if (state == "BI") tmp.name <- "Bureau_Indian_Affairs" else tmp.name <- gsub(" ", "_", SGP:::getStateAbbreviation(state, type="state"))
	if(tmp.name=="WASHINGTON_DC") tmp.name <- "Washington_DC"
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

####  Spring 2017

PARCC_Data_LONG_2016_2017.2 <- rbindlist(list(
  read.parcc("BI", "D201706"), read.parcc("CO", "D201706"),
	read.parcc("IL", "D201706"), read.parcc("MD", "D201706"),
  read.parcc("NJ", "D201706"), read.parcc("NM", "D201706"),
  read.parcc("DC", "D201706"), read.parcc("RI", "D201706")))[, parcc.var.names, with=FALSE]

setkey(PARCC_Data_LONG_2016_2017.2, PARCCStudentIdentifier, TestCode, Period)


###
###       Data Cleaning  -  Create Required SGP Variables
###

####  ID
setnames(PARCC_Data_LONG_2016_2017.2, "PARCCStudentIdentifier", "ID")

####  CONTENT_AREA from TestCode
PARCC_Data_LONG_2016_2017.2[, CONTENT_AREA := factor(TestCode)]
levels(PARCC_Data_LONG_2016_2017.2$CONTENT_AREA) <- c("ALGEBRA_I", "ALGEBRA_II", rep("ELA", 9), "GEOMETRY", rep("MATHEMATICS", 6), "INTEGRATED_MATH_1", "INTEGRATED_MATH_2", "INTEGRATED_MATH_3")
PARCC_Data_LONG_2016_2017.2[, CONTENT_AREA := as.character(CONTENT_AREA)]

####  GRADE from TestCode
PARCC_Data_LONG_2016_2017.2[, GRADE := gsub("ELA|MAT", "", TestCode)]
PARCC_Data_LONG_2016_2017.2[, GRADE := as.character(as.numeric(GRADE))]
PARCC_Data_LONG_2016_2017.2[which(is.na(GRADE)), GRADE := "EOCT"]
PARCC_Data_LONG_2016_2017.2[, GRADE := as.character(GRADE)]
table(PARCC_Data_LONG_2016_2017.2[, GRADE, TestCode])

####  YEAR
PARCC_Data_LONG_2016_2017.2[, YEAR := gsub("-", "_", AssessmentYear)]
PARCC_Data_LONG_2016_2017.2[which(Period == "FallBlock"), YEAR := paste(YEAR, "1", sep=".")]
PARCC_Data_LONG_2016_2017.2[which(Period == "Spring"), YEAR := paste(YEAR, "2", sep=".")]

####  Valid Cases
PARCC_Data_LONG_2016_2017.2[, VALID_CASE := "VALID_CASE"]

####  Invalidate Cases with missing IDs - 0 invalid in FINAL data
PARCC_Data_LONG_2016_2017.2[which(is.na(ID)), VALID_CASE := "INVALID_CASE"]

####  Duplicates

####  DON'T FIX DUPLICATES!  Per email from Pat Taylor 7/18/16

#X#  52 dups in same grade
setkey(PARCC_Data_LONG_2016_2017.2, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID, SummativeScaleScore)
setkey(PARCC_Data_LONG_2016_2017.2, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID)
dups <- PARCC_Data_LONG_2016_2017.2[c(which(duplicated(PARCC_Data_LONG_2016_2017.2, by=key(PARCC_Data_LONG_2016_2017.2))), which(duplicated(PARCC_Data_LONG_2016_2017.2, by=key(PARCC_Data_LONG_2016_2017.2)))-1),]
# PARCC_Data_LONG_2016_2017.2[which(duplicated(PARCC_Data_LONG_2016_2017.2, by=key(PARCC_Data_LONG_2016_2017.2)))-1, VALID_CASE := "INVALID_CASE"]

#X#  Duplicates if grade ignored  -  310
setkey(PARCC_Data_LONG_2016_2017.2, VALID_CASE, YEAR, CONTENT_AREA, ID, SummativeScaleScore)
setkey(PARCC_Data_LONG_2016_2017.2, VALID_CASE, YEAR, CONTENT_AREA, ID)
# PARCC_Data_LONG_2016_2017.2[which(duplicated(PARCC_Data_LONG_2016_2017.2, by=key(PARCC_Data_LONG_2016_2017.2)))-1, VALID_CASE := "INVALID_CASE"]


####
####  Establish seperate Theta and Scale Score long data sets
####

PARCC_Data_LONG_SS <- copy(PARCC_Data_LONG_2016_2017.2)

PARCC_Data_LONG_SS[, c("IRTTheta", "ThetaSEM") := NULL]
PARCC_Data_LONG_SS[, CONTENT_AREA := paste(CONTENT_AREA, "SS", sep="_")]
setnames(PARCC_Data_LONG_SS, c("SummativeScaleScore", "SummativeCSEM"), c("SCALE_SCORE", "SCALE_SCORE_CSEM"))

####  Theta data set - create IRT CSEM First
scaling.constants <- as.data.table(read.csv("./PARCC/Data/Base_Files/2015-2016 PARCC Scaling Constants.csv")) # Same as spring 2016 per Pat Taylor 2/10/17
setkey(scaling.constants, CONTENT_AREA, GRADE)
setkey(PARCC_Data_LONG_2016_2017.2, CONTENT_AREA, GRADE)
PARCC_Data_LONG_2016_2017.2 <- scaling.constants[PARCC_Data_LONG_2016_2017.2]

PARCC_Data_LONG_2016_2017.2[, SCALE_SCORE_CSEM := (as.numeric(SummativeCSEM))/a] # NO -b here...
# PARCC_Data_LONG_2016_2017.2[, IRTTheta := (as.numeric(SummativeScaleScore)-b)/a] # Fake it until Pearson provides IRTTheta 6/20/17

PARCC_Data_LONG_2016_2017.2[, c("a", "b", "ThetaSEM") := NULL]

setnames(PARCC_Data_LONG_2016_2017.2, c("IRTTheta", "SummativeScaleScore", "SummativeCSEM"), c("SCALE_SCORE", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_CSEM_ACTUAL"))


####  Stack Theta and SS Data
PARCC_Data_LONG_2016_2017.2 <- rbindlist(list(PARCC_Data_LONG_2016_2017.2, PARCC_Data_LONG_SS), fill=TRUE)
PARCC_Data_LONG_2016_2017.2[, CONTENT_AREA := as.character(CONTENT_AREA)]

####  Save Spring 2017 LONG Data

require(RSQLite)
parcc.db <- "./PARCC/Data/PARCC_Data_LONG.sqlite"
db.order <- dbListFields(dbConnect(SQLite(), dbname = parcc.db), name = "PARCC_Data_LONG_2015_2") # Use PARCC_Data_LONG_2015_2 table's var order for all future tables


setcolorder(PARCC_Data_LONG_2016_2017.2, db.order) # To match original var order

PARCC_Data_LONG_2016_2017.2[, GRADE := as.character(GRADE)]
PARCC_Data_LONG_2016_2017.2[, SCALE_SCORE := as.numeric(SCALE_SCORE)]
PARCC_Data_LONG_2016_2017.2[, SCALE_SCORE_CSEM := as.numeric(SCALE_SCORE_CSEM)]
PARCC_Data_LONG_2016_2017.2[, SCALE_SCORE_ACTUAL := as.numeric(SCALE_SCORE_ACTUAL)]
PARCC_Data_LONG_2016_2017.2[, SCALE_SCORE_CSEM_ACTUAL := as.numeric(SCALE_SCORE_CSEM_ACTUAL)]

####  Save Spring 2017 LONG Data
# dir.create("./PARCC/Data/2016_2017.2")
save(PARCC_Data_LONG_2016_2017.2, file = "./PARCC/Data/PARCC_Data_LONG_2016_2017.2.Rdata")


#####  Add Spring 2017 LONG data to existing SQLite Database.  Tables stored by each year / period

dbWriteTable(dbConnect(SQLite(), dbname = parcc.db), name = "PARCC_Data_LONG_2017_2", value=PARCC_Data_LONG_2016_2017.2, overwrite=TRUE)


###
###   INVALIDate Duplicate Prior Test scores
###

"~/Dropbox (SGP)/SGP/PARCC"
"/media/Data/Dropbox (SGP)/SGP/PARCC"
library(readxl)
library(data.table)

PARCC_2015_2016_duplicates <- rbindlist(
  list(read_excel("./PARCC/Data/Base_Files/duplicate_priors/CO_2015_2016_duplicates.xlsx"),
       read_excel("./PARCC/Data/Base_Files/duplicate_priors/MD_2015_2016_duplicates.xlsx"),
       read_excel("./PARCC/Data/Base_Files/duplicate_priors/NJ_2015_2016_duplicates.xlsx"),
       read_excel("./PARCC/Data/Base_Files/duplicate_priors/NM_2015_2016_duplicates.xlsx")))

table(PARCC_2015_2016_duplicates[, is.na(SummativeScoreRecordUUID), is.na(StudentTestUUID)])

PARCC_SGP_LONG_Data[SummativeScoreRecordUUID %in% PARCC_2015_2016_duplicates[!is.na(SummativeScoreRecordUUID), SummativeScoreRecordUUID]]

# PARCC_2015_2016_duplicates[, YEAR := gsub("-", "_", AssessmentYear)]
# PARCC_2015_2016_duplicates[which(Period == "FallBlock"), YEAR := paste(YEAR, "1", sep=".")]
# PARCC_2015_2016_duplicates[which(Period == "Spring"), YEAR := paste(YEAR, "2", sep=".")]


PARCC_Data_LONG <- copy(PARCC_SGP_LONG_Data[StateAbbreviation != "MA"])[, ID:=gsub("_DUPS_[0-9]*", "", ID)]#[,VALID_CASE := NULL]
# dim(PARCC_Data_LONG)
# dim(unique(PARCC_Data_LONG))
setkeyv(PARCC_Data_LONG, names(PARCC_Data_LONG)[1:14])
PARCC_Data_LONG <- unique(PARCC_Data_LONG, by=key(PARCC_Data_LONG)) # Get rid of exact duplicates created in prior analyses (old way of dealing with dups)

PARCC_Data_LONG[SummativeScoreRecordUUID=="gwx+pj8yQDqP4oljnk0vzOTNgtUkGkRdiMwW",]

table(PARCC_Data_LONG[, VALID_CASE])

PARCC_Data_LONG[StudentTestUUID %in% PARCC_2015_2016_duplicates[!is.na(StudentTestUUID) & KEEP_Duplicate =="Y", StudentTestUUID], VALID_CASE := "VALID_CASE"]
PARCC_Data_LONG[StudentTestUUID %in% PARCC_2015_2016_duplicates[!is.na(StudentTestUUID) & KEEP_Duplicate =="N", StudentTestUUID], VALID_CASE := "INVALID_CASE"]
PARCC_Data_LONG[SummativeScoreRecordUUID %in% PARCC_2015_2016_duplicates[!is.na(SummativeScoreRecordUUID) & KEEP_Duplicate =="Y", SummativeScoreRecordUUID], VALID_CASE := "VALID_CASE"]
PARCC_Data_LONG[SummativeScoreRecordUUID %in% PARCC_2015_2016_duplicates[!is.na(SummativeScoreRecordUUID) & KEEP_Duplicate =="N", SummativeScoreRecordUUID], VALID_CASE := "INVALID_CASE"]

# table(PARCC_Data_LONG[SummativeScoreRecordUUID %in% PARCC_2015_2016_duplicates[!is.na(SummativeScoreRecordUUID) & KEEP_Duplicate =="Y", SummativeScoreRecordUUID], VALID_CASE])
# table(PARCC_Data_LONG[StudentTestUUID %in% PARCC_2015_2016_duplicates[!is.na(StudentTestUUID) & KEEP_Duplicate =="Y", StudentTestUUID], VALID_CASE])
# PARCC_Data_LONG[StudentTestUUID %in% PARCC_2015_2016_duplicates[!is.na(StudentTestUUID) & KEEP_Duplicate =="Y", StudentTestUUID] & VALID_CASE == "INVALID_CASE",]

####
# PARCC_Data_LONG[, VALID_CASE := "VALID_CASE"]

setkey(PARCC_Data_LONG, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID)
sum(duplicated(PARCC_Data_LONG, by=key(PARCC_Data_LONG)))

PARCC_Data_LONG[c(which(duplicated(PARCC_Data_LONG, by=key(PARCC_Data_LONG)))-1, which(duplicated(PARCC_Data_LONG, by=key(PARCC_Data_LONG)))), VALID_CASE := "DUPLICATE_CASE"]
table(PARCC_Data_LONG[, VALID_CASE])
table(PARCC_Data_LONG[, VALID_CASE, StateAbbreviation])
table(PARCC_Data_LONG[VALID_CASE== 'DUPLICATE_CASE', StateAbbreviation, YEAR])

setkey(PARCC_Data_LONG, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID, SCALE_SCORE, SCALE_SCORE_ACTUAL)
setkey(PARCC_Data_LONG, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID)
dups <- PARCC_Data_LONG[c(which(duplicated(PARCC_Data_LONG, by=key(PARCC_Data_LONG)))-1, which(duplicated(PARCC_Data_LONG, by=key(PARCC_Data_LONG)))),]
setkeyv(dups, key(PARCC_Data_LONG))
dups[VALID_CASE=='VALID_CASE' & StateAbbreviation=='MD',] # 3 unaddressed cases from MD - looks like they took the test twice and had same (SCALE) score (one had different Theta)
PARCC_Data_LONG[which(duplicated(PARCC_Data_LONG, by=key(PARCC_Data_LONG)))-1, VALID_CASE := "INVALID_CASE"]

PARCC_Data_LONG[StateAbbreviation=='MD' & ID=="3e8674c0-cca7-4ece-8e4c-cf252b6d92a9" & TestCode=="ELA05",]
# setkey(PARCC_Data_LONG, VALID_CASE, YEAR, CONTENT_AREA, ID, SCALE_SCORE, SCALE_SCORE_ACTUAL)
# setkey(PARCC_Data_LONG, VALID_CASE, YEAR, CONTENT_AREA, ID)
# sum(duplicated(PARCC_Data_LONG, by=key(PARCC_Data_LONG)))
# dups <- PARCC_Data_LONG[c(which(duplicated(PARCC_Data_LONG, by=key(PARCC_Data_LONG)))-1, which(duplicated(PARCC_Data_LONG, by=key(PARCC_Data_LONG)))),]
# PARCC_Data_LONG[which(duplicated(PARCC_Data_LONG, by=key(PARCC_Data_LONG)))-1, VALID_CASE := "INVALID_CASE"]


all(PARCC_2015_2016_duplicates[!is.na(StudentTestUUID), StudentTestUUID] %in% PARCC_Data_LONG[,StudentTestUUID])
all(PARCC_2015_2016_duplicates[!is.na(SummativeScoreRecordUUID), SummativeScoreRecordUUID] %in% PARCC_Data_LONG[,SummativeScoreRecordUUID])
PARCC_2015_2016_duplicates[!is.na(SummativeScoreRecordUUID), SummativeScoreRecordUUID][(!PARCC_2015_2016_duplicates[!is.na(SummativeScoreRecordUUID), SummativeScoreRecordUUID] %in% PARCC_Data_LONG[,SummativeScoreRecordUUID])]

table(PARCC_Data_LONG[SummativeScoreRecordUUID %in% PARCC_2015_2016_duplicates[!is.na(SummativeScoreRecordUUID), SummativeScoreRecordUUID], VALID_CASE])
table(PARCC_Data_LONG[StudentTestUUID %in% PARCC_2015_2016_duplicates[!is.na(StudentTestUUID), StudentTestUUID], VALID_CASE])

PARCC_Data_LONG[StudentTestUUID %in% PARCC_2015_2016_duplicates[!is.na(StudentTestUUID), StudentTestUUID], VALID_CASE := "VALID_CASE"]
PARCC_Data_LONG[SummativeScoreRecordUUID %in% PARCC_2015_2016_duplicates[!is.na(SummativeScoreRecordUUID), SummativeScoreRecordUUID], VALID_CASE := "VALID_CASE"]

dim(PARCC_Data_LONG)
dim(unique(PARCC_Data_LONG))
