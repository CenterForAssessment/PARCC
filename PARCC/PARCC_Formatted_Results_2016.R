################################################################################
###                                                                          ###
###            Format PARCC 2016 Results Data to Return to Pearson           ###
###                                                                          ###
################################################################################

### Load required packages

require(SGP)
require(data.table)

setwd("/media/Data/PARCC")

###
###    Read in Fall and Spring 2016 Output Files
###

load("./PARCC/Data/PARCC_SGP-Sim.Rdata")
load("./PARCC/Data/PARCC_SGP_LONG_Data.Rdata")

load("./Colorado/Data/Colorado_SGP_LONG_Data_2015_2016.2.Rdata")
load("./Illinois/Data/Illinois_SGP_LONG_Data_2015_2016.2.Rdata")
load("./Maryland/Data/Maryland_SGP_LONG_Data_2015_2016.2.Rdata")
load("./Massachusetts/Data/Massachusetts_SGP_LONG_Data_2015_2016.2.Rdata")
load("./New_Jersey/Data/New_Jersey_SGP_LONG_Data_2015_2016.2.Rdata")
load("./New_Mexico/Data/New_Mexico_SGP_LONG_Data_2015_2016.2.Rdata")
load("./Rhode_Island/Data/Rhode_Island_SGP_LONG_Data_2015_2016.2.Rdata")
load("./Washington_DC/Data/WASHINGTON_DC_SGP_LONG_Data_2015_2016.2.Rdata")

####  Set names based on Pearson file layout
parcc.var.names <- c("AssessmentYear", "StateAbbreviation", "PARCCStudentIdentifier", "GradeLevelWhenAssessed", "Period", "TestCode", 
                     "SummativeScoreRecordUUID", "StudentTestUUID", "SummativeScaleScore", "IRTTheta", "SummativeCSEM", "Filler", "TestFormat")

center.var.names <- c("StudentGrowthPercentileComparedtoState", "StudentGrowthPercentileComparedtoPARCC", "SGPPreviousTestCodeState",
                      "SGPPreviousTestCodePARCC", "SGPUpperBoundState", "SGPLowerBoundState", "SGPUpperBoundPARCC", "SGPLowerBoundPARCC")

all.var.names <- c(head(parcc.var.names,-1), center.var.names, "TestFormat") # TestFormat is out of order

####  State Data

State_SGP_LONG_Data <- rbindlist(list(
	Colorado_SGP_LONG_Data_2015_2016.2, Illinois_SGP_LONG_Data_2015_2016.2, Maryland_SGP_LONG_Data_2015_2016.2,
	Massachusetts_SGP_LONG_Data_2015_2016.2, New_Jersey_SGP_LONG_Data_2015_2016.2, New_Mexico_SGP_LONG_Data_2015_2016.2,
	Rhode_Island_SGP_LONG_Data_2015_2016.2, WASHINGTON_DC_SGP_LONG_Data_2015_2016.2), fill=TRUE)


#####
###    Data for Consolodated SGP object
#####

State_Subset <- State_SGP_LONG_Data[, list(VALID_CASE, CONTENT_AREA, YEAR, ID, SGP_SIMEX, SGP, SGP_0.05_CONFIDENCE_BOUND, SGP_0.95_CONFIDENCE_BOUND, SGP_NORM_GROUP)][!is.na(SGP)]
state.vars <- c("SGP_SIMEX", "SGP", "SGP_0.05_CONFIDENCE_BOUND", "SGP_0.95_CONFIDENCE_BOUND", "SGP_NORM_GROUP")
setnames(State_Subset, state.vars, paste(state.vars, "_STATE", sep=""))
setkey(State_Subset, VALID_CASE, CONTENT_AREA, YEAR, ID)
setkey(PARCC_SGP_LONG_Data, VALID_CASE, CONTENT_AREA, YEAR, ID)
PARCC_SGP@Data <- merge(PARCC_SGP_LONG_Data, State_Subset, all.x=TRUE)

PARCC_SGP <- prepareSGP(PARCC_SGP)

dir.create("./CONSORTIUM/Data", recursive=TRUE)
save(PARCC_SGP, file="./CONSORTIUM/Data/PARCC_SGP-Consortium.Rdata")

#####
###    Data for formatted output to Pearson
#####

###    Remove rows associated with the Scale Score SGP
State_SGP_LONG_Data <- State_SGP_LONG_Data[grep("_SS", CONTENT_AREA, invert =TRUE),]
PARCC_SGP_LONG_Data <- PARCC_SGP_LONG_Data[grep("_SS", CONTENT_AREA, invert =TRUE),]

setnames(State_SGP_LONG_Data,
	c("ID", "SCALE_SCORE_ACTUAL", "SCALE_SCORE", "SCALE_SCORE_CSEM",
	  "SGP", "SGP_0.05_CONFIDENCE_BOUND", "SGP_0.95_CONFIDENCE_BOUND"),
	c("PARCCStudentIdentifier", "SummativeScaleScore", "IRTTheta", "SummativeCSEM",
	  "StudentGrowthPercentileComparedtoState", "SGPLowerBoundState", "SGPUpperBoundState"))

###    Split SGP_NORM_GROUP to create 'SGPPreviousTestCode*' Variables
state.tmp.split <- strsplit(as.character(State_SGP_LONG_Data$SGP_NORM_GROUP), "; ")
State_SGP_LONG_Data[, CONTENT_AREA_PRIOR := sapply(sapply(strsplit(sapply(strsplit(sapply(state.tmp.split, function(x) rev(x)[2]), "/"), '[', 2), "_"), head, -1), paste, collapse="_")]
State_SGP_LONG_Data[, GRADE_PRIOR := sapply(strsplit(sapply(strsplit(sapply(state.tmp.split, function(x) rev(x)[2]), "/"), '[', 2), "_"), tail, 1)]
State_SGP_LONG_Data[which(GRADE_PRIOR=="EOCT"), GRADE_PRIOR := ""]
State_SGP_LONG_Data[, SGPPreviousTestCodeState := factor(paste(CONTENT_AREA_PRIOR, GRADE_PRIOR))]
levels(State_SGP_LONG_Data$SGPPreviousTestCodeState) <- c("ALG01", "ELA10", "ELA03", "ELA04", "ELA05", "ELA06", "ELA07", "ELA08", "ELA09",
	"GEO01", "MAT1I", "MAT2I", "MAT03", "MAT04", "MAT05", "MAT06", "MAT07", "MAT08", NA)
State_SGP_LONG_Data[, SGPPreviousTestCodeState := as.character(SGPPreviousTestCodeState)]
State_SGP_LONG_Data[, CONTENT_AREA_PRIOR := NULL]
State_SGP_LONG_Data[, GRADE_PRIOR := NULL]

State_SGP_LONG_Data <- State_SGP_LONG_Data[, names(State_SGP_LONG_Data)[names(State_SGP_LONG_Data) %in% all.var.names], with=FALSE]

###   PARCC Consortium Data

setnames(PARCC_SGP_LONG_Data,
	c("ID", "SCALE_SCORE_ACTUAL", "SCALE_SCORE", "SCALE_SCORE_CSEM",
	  "SGP", "SGP_0.05_CONFIDENCE_BOUND", "SGP_0.95_CONFIDENCE_BOUND"),
	c("PARCCStudentIdentifier", "SummativeScaleScore", "IRTTheta", "SummativeCSEM",
	  "StudentGrowthPercentileComparedtoPARCC", "SGPLowerBoundPARCC", "SGPUpperBoundPARCC"))

### Split SGP_NORM_GROUP to create 'SGPPreviousTestCode*' Variables
parcc.tmp.split <- strsplit(as.character(PARCC_SGP_LONG_Data$SGP_NORM_GROUP), "; ")
PARCC_SGP_LONG_Data[, CONTENT_AREA_PRIOR := sapply(sapply(strsplit(sapply(strsplit(sapply(parcc.tmp.split, function(x) rev(x)[2]), "/"), '[', 2), "_"), head, -1), paste, collapse="_")]
PARCC_SGP_LONG_Data[, GRADE_PRIOR := sapply(strsplit(sapply(strsplit(sapply(parcc.tmp.split, function(x) rev(x)[2]), "/"), '[', 2), "_"), tail, 1)]
PARCC_SGP_LONG_Data[which(GRADE_PRIOR=="EOCT"), GRADE_PRIOR := ""]
PARCC_SGP_LONG_Data[, SGPPreviousTestCodePARCC := factor(paste(CONTENT_AREA_PRIOR, GRADE_PRIOR))]
levels(PARCC_SGP_LONG_Data$SGPPreviousTestCodePARCC) <- c("ALG01", "ELA10", "ELA03", "ELA04", "ELA05", "ELA06", "ELA07", "ELA08", "ELA09", 
	"GEO01", "MAT1I", "MAT2I", "MAT03", "MAT04", "MAT05", "MAT06", "MAT07", "MAT08", NA)
PARCC_SGP_LONG_Data[, SGPPreviousTestCodePARCC := as.character(SGPPreviousTestCodePARCC)]
PARCC_SGP_LONG_Data[, CONTENT_AREA_PRIOR := NULL]
PARCC_SGP_LONG_Data[, GRADE_PRIOR := NULL]

PARCC_SGP_LONG_Data <- PARCC_SGP_LONG_Data[, names(PARCC_SGP_LONG_Data)[names(PARCC_SGP_LONG_Data) %in% all.var.names], with=FALSE]
# setkey(PARCC_SGP_LONG_Data, VALID_CASE, CONTENT_AREA, YEAR, PARCCStudentIdentifier)

###       Merge PARCC and State Data

PARCC_SGP_LONG_Data <- merge(PARCC_SGP_LONG_Data, State_SGP_LONG_Data, by=intersect(names(PARCC_SGP_LONG_Data), names(State_SGP_LONG_Data)), all.x=TRUE)

PARCC_SGP_LONG_Data[, TestFormat := ""]
setcolorder(PARCC_SGP_LONG_Data, all.var.names)


###  Export/zip State specific .csv files

setwd("./CONSORTIUM/Data")
for (abv in unique(PARCC_SGP_LONG_Data$StateAbbreviation)) {
	# state <- SGP:::getStateAbbreviation(abv, type="state")
	fname <- paste("PARCC_", abv, "_2015-2016_SGP-Results_", format(Sys.Date(), format="%Y%m%d"), ".csv", sep="")
	fwrite(PARCC_SGP_LONG_Data[StateAbbreviation == abv & AssessmentYear == "2015-2016"], fname, col.names = FALSE)
	zip(zipfile=paste(fname, "zip", sep="."), files=fname, flags="-mq")
}
