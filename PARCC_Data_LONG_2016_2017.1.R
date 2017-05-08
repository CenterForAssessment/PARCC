################################################################################
###                                                                          ###
###              Create PARCC LONG Data for Fall 2016 Analyses               ###
###                                                                          ###
################################################################################

### Load required packages

require(SGP)
require(data.table)

###  Set working directory to top level directory (PARCC)

###
###    Read in Fall 2016 Pearson base data
###

####  Set names based on Pearson file layout
parcc.var.names <- c("AssessmentYear", "StateAbbreviation", "PARCCStudentIdentifier", "GradeLevelWhenAssessed", "Period", "TestCode",
                     "SummativeScoreRecordUUID", "StudentTestUUID", "SummativeScaleScore", "IRTTheta", "SummativeCSEM", "Filler", "TestFormat")

center.var.names <- c("StudentGrowthPercentileComparedtoState", "StudentGrowthPercentileComparedtoPARCC", "SGPPreviousTestCodeState",
                      "SGPPreviousTestCodePARCC", "SGPUpperBoundState", "SGPLowerBoundState", "SGPUpperBoundPARCC", "SGPLowerBoundPARCC")

all.var.names <- c(head(parcc.var.names,-1), center.var.names, "TestFormat")

####   Function to read in individual state files

read.parcc <- function(state, year, Fall=FALSE) {
	if (state == "BI") tmp.name <- "Bureau_Indian_Affairs" else tmp.name <- gsub(" ", "_", SGP:::getStateAbbreviation(state, type="state"))
	if(tmp.name=="WASHINGTON_DC") tmp.name <- "Washington_DC"
	tmp.files <- list.files(file.path(tmp.name, "Data/Base_Files"))
	my.zip <- grep(year, tmp.files, value=TRUE)
	my.file <- gsub(".zip",  "", my.zip)
	tmp.dir <- getwd()
	setwd(tempdir())
	system(paste("unzip '", file.path(tmp.dir, tmp.name, "Data/Base_Files", my.zip), "'", sep=""))
	if (year=="2014-2015" | Fall==TRUE) {
		tmp.var.names <- head(all.var.names,-1)
		cols <- 20
	} else {
		tmp.var.names <- all.var.names
		cols <- 21
	}
	TMP <- fread(my.file, sep=',', header=FALSE, skip=1L, colClasses=rep("character", cols))
	unlink(my.file)
	setwd(tmp.dir)
	setnames(TMP, tmp.var.names)
	return(TMP)
}

####  Fall 2016

PARCC_Data_LONG_2016_2017.1 <- rbindlist(list(read.parcc("BI", "D20170214"),
	read.parcc("MD", "D20170214"), read.parcc("NJ", "D20170214"),
	read.parcc("NM", "D20170214"), read.parcc("RI", "D20170214")))

setkey(PARCC_Data_LONG_2016_2017.1, PARCCStudentIdentifier, TestCode, Period)
PARCC_Data_LONG_2016_2017.1 <- PARCC_Data_LONG_2016_2017.1[, parcc.var.names, with=FALSE]


###
###       Data Cleaning  -  Create Required SGP Variables
###

####  ID
setnames(PARCC_Data_LONG_2016_2017.1, "PARCCStudentIdentifier", "ID")

####  CONTENT_AREA from TestCode
PARCC_Data_LONG_2016_2017.1[, CONTENT_AREA := factor(TestCode)]
levels(PARCC_Data_LONG_2016_2017.1$CONTENT_AREA) <- c("ALGEBRA_I", "ALGEBRA_II", rep("ELA", 3), "GEOMETRY")
PARCC_Data_LONG_2016_2017.1[, CONTENT_AREA := as.character(CONTENT_AREA)]

####  GRADE from TestCode
PARCC_Data_LONG_2016_2017.1[, GRADE := gsub("ELA|MAT", "", TestCode)]
PARCC_Data_LONG_2016_2017.1[, GRADE := as.character(as.numeric(GRADE))]
PARCC_Data_LONG_2016_2017.1[which(is.na(GRADE)), GRADE := "EOCT"]
PARCC_Data_LONG_2016_2017.1[, GRADE := as.character(GRADE)]
table(PARCC_Data_LONG_2016_2017.1[, GRADE, TestCode])

####  YEAR
PARCC_Data_LONG_2016_2017.1[, YEAR := gsub("-", "_", AssessmentYear)]
PARCC_Data_LONG_2016_2017.1[which(Period == "FallBlock"), YEAR := paste(YEAR, "1", sep=".")]
PARCC_Data_LONG_2016_2017.1[which(Period == "Spring"), YEAR := paste(YEAR, "2", sep=".")]

####  Valid Cases
PARCC_Data_LONG_2016_2017.1[, VALID_CASE := "VALID_CASE"]

####  Invalidate Cases with missing IDs - 0 invalid in FINAL data
PARCC_Data_LONG_2016_2017.1[which(is.na(ID)), VALID_CASE := "INVALID_CASE"]

####  Duplicates

####  DON'T FIX DUPLICATES!  Per email from Pat Taylor 7/18 (NO Dups anyway for Fall 2016)

##  36 dups in same grade
# setkey(PARCC_Data_LONG_2016_2017.1, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID, SummativeScaleScore)
# setkey(PARCC_Data_LONG_2016_2017.1, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID)
# PARCC_Data_LONG_2016_2017.1[which(duplicated(PARCC_Data_LONG_2016_2017.1, by=key(PARCC_Data_LONG_2016_2017.1)))-1, VALID_CASE := "INVALID_CASE"]

#  Duplicates if grade ignored  -  198
# setkey(PARCC_Data_LONG_2016_2017.1, VALID_CASE, YEAR, CONTENT_AREA, ID, SummativeScaleScore)
# setkey(PARCC_Data_LONG_2016_2017.1, VALID_CASE, YEAR, CONTENT_AREA, ID)
# PARCC_Data_LONG_2016_2017.1[which(duplicated(PARCC_Data_LONG_2016_2017.1, by=key(PARCC_Data_LONG_2016_2017.1)))-1, VALID_CASE := "INVALID_CASE"]


####
####  Establish seperate Theta and Scale Score long data sets
####

PARCC_Data_LONG_SS <- copy(PARCC_Data_LONG_2016_2017.1)

PARCC_Data_LONG_SS[, c("IRTTheta", "Filler") := NULL]
PARCC_Data_LONG_SS[, CONTENT_AREA := paste(CONTENT_AREA, "SS", sep="_")]
setnames(PARCC_Data_LONG_SS, c("SummativeScaleScore", "SummativeCSEM"), c("SCALE_SCORE", "SCALE_SCORE_CSEM"))

####  Theta data set - create IRT CSEM First
scaling.constants <- as.data.table(read.csv("./PARCC/Data/Base_Files/2015-2016 PARCC Scaling Constants.csv")) # Same as spring 2016 per Pat Taylor 2/10/17
setkey(scaling.constants, CONTENT_AREA, GRADE)
setkey(PARCC_Data_LONG_2016_2017.1, CONTENT_AREA, GRADE)
PARCC_Data_LONG_2016_2017.1 <- scaling.constants[PARCC_Data_LONG_2016_2017.1]

PARCC_Data_LONG_2016_2017.1[, SCALE_SCORE_CSEM := (as.numeric(SummativeCSEM))/a] # NO -b here...

PARCC_Data_LONG_2016_2017.1[, c("a", "b", "Filler") := NULL]

setnames(PARCC_Data_LONG_2016_2017.1, c("IRTTheta", "SummativeScaleScore", "SummativeCSEM"), c("SCALE_SCORE", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_CSEM_ACTUAL"))


####  Stack Theta and SS Data
PARCC_Data_LONG_2016_2017.1 <- rbindlist(list(PARCC_Data_LONG_2016_2017.1, PARCC_Data_LONG_SS), fill=TRUE)
PARCC_Data_LONG_2016_2017.1[, CONTENT_AREA := as.character(CONTENT_AREA)]

####  Save Fall 2016 LONG Data

require(RSQLite)
parcc.db <- "./PARCC/Data/PARCC_Data_LONG.sqlite"
db.order <- dbListFields(dbConnect(SQLite(), dbname = parcc.db), name = "PARCC_Data_LONG_2015_2")


setcolorder(PARCC_Data_LONG_2016_2017.1, db.order) # To match original var order

PARCC_Data_LONG_2016_2017.1[, GRADE := as.character(GRADE)]
PARCC_Data_LONG_2016_2017.1[, SCALE_SCORE := as.numeric(SCALE_SCORE)]
PARCC_Data_LONG_2016_2017.1[, SCALE_SCORE_CSEM := as.numeric(SCALE_SCORE_CSEM)]
PARCC_Data_LONG_2016_2017.1[, SCALE_SCORE_ACTUAL := as.numeric(SCALE_SCORE_ACTUAL)]
PARCC_Data_LONG_2016_2017.1[, SCALE_SCORE_CSEM_ACTUAL := as.numeric(SCALE_SCORE_CSEM_ACTUAL)]

####  Save Fall 2016 LONG Data
dir.create("./PARCC/Data//2016_2017.1")
save(PARCC_Data_LONG_2016_2017.1, file = "./PARCC/Data/PARCC_Data_LONG_2016_2017.1.Rdata")


#####  Add Fall 2016 LONG data to existing SQLite Database.  Tables stored by each year / period

dbWriteTable(dbConnect(SQLite(), dbname = parcc.db), name = "PARCC_Data_LONG_2017_1", value=PARCC_Data_LONG_2016_2017.1, overwrite=TRUE)
