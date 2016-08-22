################################################################################
###                                                                          ###
###             Create PARCC LONG Data for Spring 2016 Analyses              ###
###                                                                          ###
################################################################################

### Load required packages

require(SGP)
require(data.table)

setwd("PARCC")

###
###  Read in Spring 2016 Pearson base data
###

####  Set names based on Pearson file layout
parcc.var.names <- c("AssessmentYear", "StateAbbreviation", "PARCCStudentIdentifier", "GradeLevelWhenAssessed", "Period", "TestCode", 
                     "SummativeScoreRecordUUID", "StudentTestUUID", "SummativeScaleScore", "IRTTheta", "SummativeCSEM", "Filler", "TestFormat")

center.var.names <- c("StudentGrowthPercentileComparedtoState", "StudentGrowthPercentileComparedtoPARCC", "SGPPreviousTestCodeState",
                      "SGPPreviousTestCodePARCC", "SGPUpperBoundState", "SGPLowerBoundState", "SGPUpperBoundPARCC", "SGPLowerBoundPARCC")

all.var.names <- c(head(parcc.var.names,-1), center.var.names, "TestFormat")

####  Function to read in individual state files

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

####  Spring 2016

PARCC_Data_LONG_2016 <- rbindlist(list(read.parcc("BI", "D201607"),
	read.parcc("CO", "D201607"), read.parcc("IL", "D201607"), 
	read.parcc("MD", "D201607"), read.parcc("MA", "D201607"), 
	read.parcc("NJ", "D201607"), read.parcc("NM", "D201607"),
	read.parcc("RI", "D201607"), read.parcc("DC", "D201607")))

setkey(PARCC_Data_LONG_2016, PARCCStudentIdentifier, TestCode, Period)
PARCC_Data_LONG_2016 <- PARCC_Data_LONG_2016[, parcc.var.names, with=FALSE]


###
###       Data Cleaning  -  Create Required SGP Variables
###

####  ID
setnames(PARCC_Data_LONG_2016, "PARCCStudentIdentifier", "ID")

####  CONTENT_AREA from TestCode
PARCC_Data_LONG_2016[, CONTENT_AREA := factor(TestCode)]
levels(PARCC_Data_LONG_2016$CONTENT_AREA) <- c("ALGEBRA_I", "ALGEBRA_II", rep("ELA", 9), "GEOMETRY", rep("MATHEMATICS", 6), "INTEGRATED_MATH_1", "INTEGRATED_MATH_2", "INTEGRATED_MATH_3")
PARCC_Data_LONG_2016[, CONTENT_AREA := as.character(CONTENT_AREA)]

####  GRADE from TestCode
PARCC_Data_LONG_2016[, GRADE := gsub("ELA|MAT", "", TestCode)]
PARCC_Data_LONG_2016[, GRADE := as.character(as.numeric(GRADE))]
PARCC_Data_LONG_2016[which(is.na(GRADE)), GRADE := "EOCT"]
PARCC_Data_LONG_2016[, GRADE := as.character(GRADE)]

####  YEAR
PARCC_Data_LONG_2016[, YEAR := gsub("-", "_", AssessmentYear)]
PARCC_Data_LONG_2016[which(Period == "FallBlock"), YEAR := paste(YEAR, "1", sep=".")]
PARCC_Data_LONG_2016[which(Period == "Spring"), YEAR := paste(YEAR, "2", sep=".")]

####  Valid Cases
PARCC_Data_LONG_2016[, VALID_CASE := "VALID_CASE"]

####  Invalidate Cases with missing IDs - 0 invalid in FINAL data
PARCC_Data_LONG_2016[which(is.na(ID)), VALID_CASE := "INVALID_CASE"]

####  Duplicates

####  DON'T FIX DUPLICATES!  Per email from Pat Taylor 7/18

# setkey(PARCC_Data_LONG_2016, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID, SummativeScaleScore)
# setkey(PARCC_Data_LONG_2016, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID)
# PARCC_Data_LONG_2016[which(duplicated(PARCC_Data_LONG_2016))-1, VALID_CASE := "INVALID_CASE"]

# #  Duplicates if Grade ignored
# setkey(PARCC_Data_LONG_2016, VALID_CASE, YEAR, CONTENT_AREA, ID, SummativeScaleScore)
# setkey(PARCC_Data_LONG_2016, VALID_CASE, YEAR, CONTENT_AREA, ID)
# PARCC_Data_LONG_2016[which(duplicated(PARCC_Data_LONG_2016))-1, VALID_CASE := "INVALID_CASE"]


####
####  Establish seperate Theta and Scale Score long data sets
####

PARCC_Data_LONG_SS <- copy(PARCC_Data_LONG_2016)

PARCC_Data_LONG_SS[, c("IRTTheta", "Filler") := NULL]
PARCC_Data_LONG_SS[, CONTENT_AREA := paste(CONTENT_AREA, "SS", sep="_")]
setnames(PARCC_Data_LONG_SS, c("SummativeScaleScore", "SummativeCSEM"), c("SCALE_SCORE", "SCALE_SCORE_CSEM"))

####  Theta data set - create IRT CSEM First
scaling.constants <- as.data.table(read.csv("./PARCC/Data/Base_Files/2015-2016 PARCC Scaling Constants.csv"))
# scaling.constants <- as.data.table(read.csv("./PARCC/Data/Base_Files/2014-2015 PARCC Scaling Constants.csv"))
setkey(scaling.constants, CONTENT_AREA, GRADE)
setkey(PARCC_Data_LONG_2016, CONTENT_AREA, GRADE)
PARCC_Data_LONG_2016 <- scaling.constants[PARCC_Data_LONG_2016]

PARCC_Data_LONG_2016[, SCALE_SCORE_CSEM := (as.numeric(SummativeCSEM))/a] # NO -b here...

PARCC_Data_LONG_2016[, c("a", "b", "Filler") := NULL]

setnames(PARCC_Data_LONG_2016, c("IRTTheta", "SummativeScaleScore", "SummativeCSEM"), c("SCALE_SCORE", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_CSEM_ACTUAL"))


####  Stack Theta and SS Data
PARCC_Data_LONG_2016 <- rbindlist(list(PARCC_Data_LONG_2016, PARCC_Data_LONG_SS), fill=TRUE)
PARCC_Data_LONG_2016[, CONTENT_AREA := as.character(CONTENT_AREA)]

####  Save 2016 LONG Data

require(RSQLite)
parcc.db <- "./PARCC/Data/PARCC_Data_LONG.sqlite"
db.order <- dbListFields(dbConnect(SQLite(), dbname = parcc.db), name = "PARCC_Data_LONG_2015_2")


setcolorder(PARCC_Data_LONG_2016, db.order) # To Match 2015 order

PARCC_Data_LONG_2016[, GRADE := as.character(GRADE)]
PARCC_Data_LONG_2016[, SCALE_SCORE := as.numeric(SCALE_SCORE)]
PARCC_Data_LONG_2016[, SCALE_SCORE_CSEM := as.numeric(SCALE_SCORE_CSEM)]
PARCC_Data_LONG_2016[, SCALE_SCORE_ACTUAL := as.numeric(SCALE_SCORE_ACTUAL)]
PARCC_Data_LONG_2016[, SCALE_SCORE_CSEM_ACTUAL := as.numeric(SCALE_SCORE_CSEM_ACTUAL)]

####  Save 2016 LONG Data
save(PARCC_Data_LONG_2016, file = "./PARCC/Data/PARCC_Data_LONG_2016.Rdata")


#####  Add 2016 LONG data to existing SQLite Database.  Tables stored by each year / period

dbWriteTable(dbConnect(SQLite(), dbname = parcc.db), name = "PARCC_Data_LONG_2016_2", value=PARCC_Data_LONG_2016, overwrite=TRUE)
