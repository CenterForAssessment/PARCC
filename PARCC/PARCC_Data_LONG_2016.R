################################################################################
###                                                                          ###
###             Create PARCC LONG Data for Spring 2016 Analyses              ###
###                                                                          ###
################################################################################

### Load required packages

require(SGP)
require(data.table)

setwd("/media/Data/Dropbox (SGP)/SGP/PARCC")

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

####  Invalidate Cases with missing IDs
PARCC_Data_LONG_2016[which(is.na(ID)), VALID_CASE := "INVALID_CASE"]

####  Duplicates
setkey(PARCC_Data_LONG_2016, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID, SummativeScaleScore)
setkey(PARCC_Data_LONG_2016, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID)
PARCC_Data_LONG_2016[which(duplicated(PARCC_Data_LONG_2016))-1, VALID_CASE := "INVALID_CASE"]

#  Duplicates if Grade ignored
setkey(PARCC_Data_LONG_2016, VALID_CASE, YEAR, CONTENT_AREA, ID, SummativeScaleScore)
setkey(PARCC_Data_LONG_2016, VALID_CASE, YEAR, CONTENT_AREA, ID)
PARCC_Data_LONG_2016[which(duplicated(PARCC_Data_LONG_2016))-1, VALID_CASE := "INVALID_CASE"]

####
###
##
#

PARCC_Data_LONG_2016[, IRTTheta := as.numeric(IRTTheta)]
PARCC_Data_LONG_2016[, SummativeCSEM := as.numeric(SummativeCSEM)]
PARCC_Data_LONG_2016[, SummativeScaleScore := as.numeric(SummativeScaleScore)]
# PARCC_Data_LONG_2016[, SS_2 := sample(SummativeScaleScore[!is.na(SummativeScaleScore)], length(ID), replace=TRUE), by="TestCode"]
# PARCC_Data_LONG_2016[which(!is.na(SummativeScaleScore)), SS_2 := SummativeScaleScore]

### Add scaling.constants
scaling.constants <- as.data.table(read.csv("/media/Data/Dropbox (SGP)/SGP/PARCC/PARCC/Data/Base_Files/2015-2016 PARCC Scaling Constants.csv"))
setkey(scaling.constants, CONTENT_AREA, GRADE)
setkey(PARCC_Data_LONG_2016, CONTENT_AREA, GRADE)
PARCC_Data_LONG_2016 <- scaling.constants[PARCC_Data_LONG_2016]

### Get CSEM Data
require(RSQLite)
parcc.db <- "./PARCC/Data/PARCC_Data_LONG.sqlite"
PARCC_CSEM <- rbindlist(list(
			dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select SCALE_SCORE_ACTUAL, SCALE_SCORE_CSEM_ACTUAL, TestCode from PARCC_Data_LONG_2015_1"),
			dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select SCALE_SCORE_ACTUAL, SCALE_SCORE_CSEM_ACTUAL, TestCode from PARCC_Data_LONG_2015_2")))

setnames(PARCC_CSEM, c("SCALE_SCORE_ACTUAL", "SCALE_SCORE_CSEM_ACTUAL"), c("SummativeScaleScore", "SummativeCSEM"))
PARCC_CSEM[, SummativeCSEM := as.numeric(SummativeCSEM)]
PARCC_CSEM[, SummativeScaleScore := as.numeric(SummativeScaleScore)]
# PARCC_CSEM <- PARCC_Data_LONG_2015[!is.na(SummativeCSEM)][, list(TestCode, SummativeScaleScore, SummativeCSEM)] # YES 2015.  No CSEM in prelim 2016.2 data
setkey(PARCC_CSEM, TestCode, SummativeScaleScore, SummativeCSEM)
PARCC_CSEM <- unique(PARCC_CSEM[!is.na(SummativeScaleScore)])

PARCC_CSEM[, SummativeCSEM := round(mean(SummativeCSEM), 1), by=c("TestCode", "SummativeScaleScore")]
PARCC_CSEM <- unique(PARCC_CSEM)
# PARCC_CSEM[, SummativeCSEM := NULL]
# setnames(PARCC_CSEM, c("SummativeScaleScore", "PARCC_CSEM"), c("SS_2", "SummativeCSEM"))

setkey(PARCC_CSEM, TestCode, SummativeScaleScore, SummativeCSEM)
PARCC_CSEM <- unique(PARCC_CSEM[!is.na(SummativeScaleScore)])
setkey(PARCC_CSEM, TestCode, SummativeScaleScore)

setkey(PARCC_Data_LONG_2016, TestCode, SummativeScaleScore)

# PARCC_Data_LONG_2016[, SS_CSEM := SummativeCSEM]

for (ca in unique(PARCC_Data_LONG_2016$TestCode)) {
	CSEM_Data_G <- PARCC_CSEM[TestCode == ca]
	CSEM_Function <- splinefun(CSEM_Data_G[["SummativeScaleScore"]], CSEM_Data_G[["SummativeCSEM"]], method="natural") # Use 'natural' since that's what's used in SIMEX routine.
	PARCC_Data_LONG_2016[which(TestCode == ca & is.na(SummativeCSEM)), SummativeCSEM := CSEM_Function(SummativeScaleScore)]
}
summary(PARCC_Data_LONG_2016$SummativeCSEM)
# summary(PARCC_Data_LONG_2016$SummativeCSEM)

# PARCC_Data_LONG_2016[, SummativeCSEM := NULL]
PARCC_Data_LONG_2016 <- PARCC_CSEM[PARCC_Data_LONG_2016]

# PARCC_Data_LONG_2016[, TH_2 := (as.numeric(SummativeScaleScore)-b) / a]
# PARCC_Data_LONG_2016[, TH_CSEM := (as.numeric(SS_CSEM))/a] # NO -b here...


# PARCC_Data_LONG_2016[, c("SummativeScaleScore", "SummativeCSEM", "IRTTheta") := NULL]
# setnames(PARCC_Data_LONG_2016, c("SS_2", "SS_CSEM", "TH_2"), c("SummativeScaleScore", "SummativeCSEM", "IRTTheta"))

# save(PARCC_Data_LONG_2016, file="PARCC/Data/Base_Files/Simulations/PARCC_Data_LONG_2016-Simulated_2.Rda")

# PARCC_Data_LONG_2016[, TestFormat := NULL]

# PARCC_Data_LONG_2016[, SS_1 := as.numeric(SummativeScaleScore)]
# PARCC_Data_LONG_2016[which(is.na(SS_1)), SS_1 := sample(SummativeScaleScore[!is.na(SummativeScaleScore)], length(which(is.na(SS_1))), replace=TRUE), by="TestCode"]

#
##
###
####

####  Establish seperate Theta and Scale Score long data sets

PARCC_Data_LONG_SS <- copy(PARCC_Data_LONG_2016)

PARCC_Data_LONG_SS[, c("IRTTheta", "Filler") := NULL]
PARCC_Data_LONG_SS[, CONTENT_AREA := paste(CONTENT_AREA, "SS", sep="_")]
setnames(PARCC_Data_LONG_SS, c("SummativeScaleScore", "SummativeCSEM"), c("SCALE_SCORE", "SCALE_SCORE_CSEM"))

####  Theta data set - create IRT CSEM First
scaling.constants <- as.data.table(read.csv("/media/Data/Dropbox (SGP)/SGP/PARCC/PARCC/Data/Base_Files/2015-2016 PARCC Scaling Constants.csv"))
# scaling.constants <- as.data.table(read.csv("/media/Data/Dropbox (SGP)/SGP/PARCC/PARCC/Data/Base_Files/2014-2015 PARCC Scaling Constants.csv"))
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
setcolorder(PARCC_Data_LONG_2016, c("CONTENT_AREA", "GRADE", "AssessmentYear", "StateAbbreviation", "ID", "GradeLevelWhenAssessed", "Period", "TestCode", 
	"SummativeScoreRecordUUID", "StudentTestUUID", "SCALE_SCORE_ACTUAL", "SCALE_SCORE", "SCALE_SCORE_CSEM_ACTUAL", "YEAR", "VALID_CASE", "SCALE_SCORE_CSEM", "TestFormat")) # To Match 2015 order
save(PARCC_Data_LONG_2016, file = "/media/Data/Dropbox (SGP)/SGP/PARCC/PARCC/Data/PARCC_Data_LONG_2016.Rdata")


#####  Create SQLite Databases for each year / period

require(RSQLite)
parcc.db <- "/media/Data/Dropbox (SGP)/SGP/PARCC/PARCC/Data/PARCC_Data_LONG.sqlite"

dbWriteTable(dbConnect(SQLite(), dbname = parcc.db), name = "PARCC_Data_LONG_2016_2", value=PARCC_Data_LONG_2016, overwrite=TRUE)
