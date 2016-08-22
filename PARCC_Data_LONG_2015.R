################################################################################
###                                                                          ###
###              Create PARCC LONG Data for Fall 2016 Analyses               ###
###                                                                          ###
################################################################################

### Load required packages

require(SGP)
require(data.table)

setwd("PARCC")

###
###       Read in Spring 2015 & Fall 2016 Pearson base data
###

####  Set names based on Pearson file layout

parcc.var.names <- c("AssessmentYear", "StateAbbreviation", "PARCCStudentIdentifier", "GradeLevelWhenAssessed", "Period", "TestCode", 
                     "SummativeScoreRecordUUID", "StudentTestUUID", "SummativeScaleScore", "IRTTheta", "SummativeCSEM", "Filler", "TestFormat")

center.var.names <- c("StudentGrowthPercentileComparedtoState", "StudentGrowthPercentileComparedtoPARCC", "SGPPreviousTestCodeState",
                      "SGPPreviousTestCodePARCC", "SGPUpperBoundState", "SGPLowerBoundState", "SGPUpperBoundPARCC", "SGPLowerBoundPARCC")

all.var.names <- c(head(parcc.var.names,-1), center.var.names, "TestFormat")

####  Function to read in individual state files

read.parcc <- function(state, year, Fall=FALSE) {
	tmp.name <- gsub(" ", "_", SGP:::getStateAbbreviation(state, type="state"))
	if(tmp.name=="WASHINGTON_DC") tmp.name <- "Washington_DC"
	tmp.files <- list.files(file.path(tmp.name, "Data/Base_Files"))
	my.zip <- grep(year, tmp.files, value=TRUE)
	my.file <- gsub(".zip",  "", my.zip)
	tmp.dir <- getwd()
	setwd("~")
	system(paste("unzip '", file.path(tmp.dir, tmp.name, "Data/Base_Files", my.zip), "'", sep=""))
	TMP <- fread(my.file, sep=',', header=FALSE, skip=1L, colClasses=rep("character", 20))
	unlink(my.file)
	setwd(tmp.dir)
	if (year=="2014-2015" | Fall==TRUE) {
		setnames(TMP, head(all.var.names,-1))
	} else setnames(TMP, all.var.names)
	return(TMP)
}

####  Fall 2014 / Spring 2015

PARCC_Data_LONG_2015 <- rbindlist(list(
	read.parcc("CO", "2014-2015"), read.parcc("IL", "2014-2015"), 
	read.parcc("MD", "2014-2015"), read.parcc("MA", "2014-2015"), 
	read.parcc("NJ", "2014-2015"), read.parcc("NM", "2014-2015"),
	read.parcc("RI", "2014-2015"), read.parcc("DC", "2014-2015")))

setkey(PARCC_Data_LONG_2015, PARCCStudentIdentifier, TestCode, Period)

####  Merge in the TestFormat variable from 2015 data obtained from client states

PARCC_TEST_MODE <- as.data.table(read.csv("./Colorado/Data/Base_Files/PARCC_TEST_MODE.csv"))
PARCC_TEST_MODE[, SASID := NULL]
setnames(PARCC_TEST_MODE, "summativeScoreRecordUuid", "SummativeScoreRecordUUID")
setkey(PARCC_TEST_MODE, SummativeScoreRecordUUID)
setkey(PARCC_Data_LONG_2015, SummativeScoreRecordUUID)	
PARCC_Data_LONG_2015 <- PARCC_TEST_MODE[PARCC_Data_LONG_2015]
setnames(PARCC_Data_LONG_2015, "PARCC_MODE", "TestFormat")

load("/media/Data/Dropbox (SGP)/SGP/Rhode_Island/Data/Rhode_Island_Data_LONG_2014_2015.Rdata")
RI.15 <- as.data.table(foreign::read.spss("/media/Data/Dropbox (SGP)/SGP/Rhode_Island/Data/Base_Files/2015 Summative File with Test Format.sav", to.data.frame=TRUE, use.value.labels=FALSE))
RI.15 <- RI.15[,c("summativeScoreRecordUuid", "TestFormat"), with=FALSE]
setnames(RI.15, "summativeScoreRecordUuid", "SummativeScoreRecordUUID")
setkey(RI.15, SummativeScoreRecordUUID)
setkey(PARCC_Data_LONG_2015, SummativeScoreRecordUUID)	
PARCC_Data_LONG_2015 <- RI.15[PARCC_Data_LONG_2015]
PARCC_Data_LONG_2015[which(!is.na(i.TestFormat)), TestFormat := i.TestFormat]
PARCC_Data_LONG_2015[, i.TestFormat := NULL]

PARCC_Data_LONG_2015 <- PARCC_Data_LONG_2015[, parcc.var.names, with=FALSE]

save(PARCC_Data_LONG_2015, file="./PARCC/Data/Base_Files/PARCC_Data_LONG_2015.Rdata")


####  Fall 2015

setwd("/media/Data/Dropbox (SGP)/SGP/PARCC")

PARCC_Data_LONG_2016 <- rbindlist(list(read.parcc("IL", "2016_SGPO_D201605", Fall=TRUE), 
	read.parcc("MD", "2016_SGPO_D201605", Fall=TRUE), read.parcc("NJ", "2016_SGPO_D201605", Fall=TRUE), 
	read.parcc("NM", "2016_SGPO_D201605", Fall=TRUE), read.parcc("RI", "2016_SGPO_D201605", Fall=TRUE)))

setkey(PARCC_Data_LONG_2016, PARCCStudentIdentifier, TestCode, Period)


####   Create PARCC_Data_LONG
PARCC_Data_LONG <- rbindlist(list(PARCC_Data_LONG_2015[, parcc.var.names, with=FALSE], PARCC_Data_LONG_2016[, head(parcc.var.names, -1), with=FALSE]), fill = TRUE)


###
###       Data Cleaning  -  Create Required SGP Variables
###

####  ID
setnames(PARCC_Data_LONG, "PARCCStudentIdentifier", "ID")

####  CONTENT_AREA from TestCode
PARCC_Data_LONG[, CONTENT_AREA := factor(TestCode)]
levels(PARCC_Data_LONG$CONTENT_AREA) <- c("ALGEBRA_I", "ALGEBRA_II", rep("ELA", 9), "GEOMETRY", rep("MATHEMATICS", 6), "INTEGRATED_MATH_1", "INTEGRATED_MATH_2", "INTEGRATED_MATH_3")
PARCC_Data_LONG[, CONTENT_AREA := as.character(CONTENT_AREA)]

####  GRADE from GradeLevelWhenAssessed
# PARCC_Data_LONG[, GRADE := as.character(as.numeric(GradeLevelWhenAssessed))]
# PARCC_Data_LONG[which(!CONTENT_AREA %in% c("ELA", "MATHEMATICS")), GRADE := "EOCT"]

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

####  Invalidate Cases with missing IDs - 0 invalid in FINAL data
PARCC_Data_LONG[which(is.na(ID)), VALID_CASE := "INVALID_CASE"]

####  Invalidate Grades not used.  NOT NEEDED WHEN GRADE ASSIGNED BY TestCode
# PARCC_Data_LONG[which(GRADE %in% c(NA,1,2)), VALID_CASE := "INVALID_CASE"] # Keep ELA Grade 12?
# PARCC_Data_LONG[which(GRADE %in% 9:12 & CONTENT_AREA == "MATHEMATICS"), VALID_CASE := "INVALID_CASE"]

####  Duplicates

####  DON'T FIX DUPLICATES!  Per email from Pat Taylor 7/18

# setkey(PARCC_Data_LONG, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID, SummativeScaleScore)
# setkey(PARCC_Data_LONG, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID)
# # sum(duplicated(PARCC_Data_LONG[VALID_CASE != "INVALID_CASE"]))
# # PARCC_Data_LONG[which(duplicated(PARCC_Data_LONG))-1, VALID_CASE := "INVALID_CASE"]
# PARCC_Data_LONG[which(duplicated(PARCC_Data_LONG))-1, VALID_CASE := "INVALID_CASE"]

# #  Duplicates if Grade ignored
# setkey(PARCC_Data_LONG, VALID_CASE, YEAR, CONTENT_AREA, ID, SummativeScaleScore)
# setkey(PARCC_Data_LONG, VALID_CASE, YEAR, CONTENT_AREA, ID)
# PARCC_Data_LONG[which(duplicated(PARCC_Data_LONG))-1, VALID_CASE := "INVALID_CASE"]


####  Establish seperate Theta and Scale Score long data sets

PARCC_Data_LONG_SS <- copy(PARCC_Data_LONG)

PARCC_Data_LONG_SS[, c("IRTTheta", "Filler") := NULL]
PARCC_Data_LONG_SS[, CONTENT_AREA := paste(CONTENT_AREA, "SS", sep="_")]
setnames(PARCC_Data_LONG_SS, c("SummativeScaleScore", "SummativeCSEM"), c("SCALE_SCORE", "SCALE_SCORE_CSEM"))

####  Theta data set - create IRT CSEM First
scaling.constants <- as.data.table(read.csv("./PARCC/Data/Base_Files/2014-2015 PARCC Scaling Constants.csv"))
setkey(scaling.constants, CONTENT_AREA, GRADE)
setkey(PARCC_Data_LONG, CONTENT_AREA, GRADE)
PARCC_Data_LONG <- scaling.constants[PARCC_Data_LONG]

PARCC_Data_LONG[, SCALE_SCORE_CSEM := (as.numeric(SummativeCSEM))/a] # NO -b here...

PARCC_Data_LONG[, c("a", "b", "Filler") := NULL]

setnames(PARCC_Data_LONG, c("IRTTheta", "SummativeScaleScore", "SummativeCSEM"), c("SCALE_SCORE", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_CSEM_ACTUAL"))

####  Stack Theta and SS Data
PARCC_Data_LONG <- rbindlist(list(PARCC_Data_LONG, PARCC_Data_LONG_SS), fill=TRUE)

####  Save Initial LONG Data

PARCC_Data_LONG[, GRADE := as.character(GRADE)]
PARCC_Data_LONG[, SCALE_SCORE := as.numeric(SCALE_SCORE)]
PARCC_Data_LONG[, SCALE_SCORE_CSEM := as.numeric(SCALE_SCORE_CSEM)]
PARCC_Data_LONG[, SCALE_SCORE_ACTUAL := as.numeric(SCALE_SCORE_ACTUAL)]
PARCC_Data_LONG[, SCALE_SCORE_CSEM_ACTUAL := as.numeric(SCALE_SCORE_CSEM_ACTUAL)]

save(PARCC_Data_LONG, file = "./PARCC/Data/PARCC_Data_LONG.Rdata")

#####  Create SQLite Databases for each year / period
require(RSQLite)

# file.create(parcc.db <- "./PARCC/Data/PARCC_Data_LONG.sqlite") # only create file once (or to overwrite)
parcc.db <- "./PARCC/Data/PARCC_Data_LONG.sqlite"

dbWriteTable(dbConnect(SQLite(), dbname = parcc.db), name = "PARCC_Data_LONG_2015_1", value=PARCC_Data_LONG[YEAR == "2014_2015.1"], overwrite=TRUE)
dbWriteTable(dbConnect(SQLite(), dbname = parcc.db), name = "PARCC_Data_LONG_2015_2", value=PARCC_Data_LONG[YEAR == "2014_2015.2"], overwrite=TRUE)
dbWriteTable(dbConnect(SQLite(), dbname = parcc.db), name = "PARCC_Data_LONG_2016_1", value=PARCC_Data_LONG[YEAR == "2015_2016.1"], overwrite=TRUE)
