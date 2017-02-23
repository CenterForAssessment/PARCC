################################################################################
###                                                                          ###
###         Format PARCC Fall 2016 Results Data to Return to Pearson         ###
###                                                                          ###
################################################################################

### Load required packages

require(SGP)
require(data.table)

###
###    Read in Fall 2016 Output Files
###

load("./PARCC/Data/Archive/2016_2017.1/PARCC_SGP_LONG_Data_2016_2017.1.Rdata")

load("./Maryland/Data/Archive/2016_2017.1/Maryland_SGP_LONG_Data_2016_2017.1.Rdata")
load("./New_Jersey/Data/Archive/2016_2017.1/New_Jersey_SGP_LONG_Data_2016_2017.1.Rdata")

####  Set names based on Pearson file layout
parcc.names <- c("AssessmentYear", "StateAbbreviation", "PARCCStudentIdentifier", "GradeLevelWhenAssessed", "Period", "TestCode",
                 "SummativeScoreRecordUUID", "StudentTestUUID", "SummativeScaleScore", "IRTTheta", "SummativeCSEM", "Filler", "TestFormat")

nciea.names <- c("StudentGrowthPercentileComparedtoState", "StudentGrowthPercentileComparedtoPARCC", "SGPPreviousTestCodeState", "SGPPreviousTestCodePARCC",
                 "SGPUpperBoundState", "SGPLowerBoundState", "SGPUpperBoundPARCC", "SGPLowerBoundPARCC", "SGPStandardErrorPARCC", "SGPStandardErrorState")

all.names <- c(head(parcc.names,-1), head(nciea.names, -2), "TestFormat", "SGPStandardErrorPARCC", "SGPStandardErrorState") # TestFormat and new SEs are out of order.

####  Combine states' data into single data table
State_LONG_Data <- rbindlist(list(
	Maryland_SGP_LONG_Data_2016_2017.1, New_Jersey_SGP_LONG_Data_2016_2017.1), fill=TRUE)

####    Remove rows associated with the Scale Score SGP
State_LONG_Data <- State_LONG_Data[grep("_SS", CONTENT_AREA, invert =TRUE),]
PARCC_LONG_Data <- PARCC_SGP_LONG_Data_2016_2017.1[grep("_SS", CONTENT_AREA, invert =TRUE),]


#####
###    Format data to Pearson's specifications
#####

###   State Data

###  Remove "DUPS" label from IDs for duplicated records
State_LONG_Data[, ID:=gsub("_DUPS_[0-9]*", "", ID)]

###  Combine SGP_NOTE and SGP variables (use SGP_ORDER_1 as "official" SGP for Fall 2016 analyses)
State_LONG_Data[, SGP_ORDER_1 := as.character(SGP_ORDER_1)]
State_LONG_Data[which(is.na(SGP_ORDER_1)), SGP_ORDER_1 := SGP_NOTE]

###  Change relevant SGP package convention names to Pearson's names
setnames(State_LONG_Data,
	c("ID", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_CSEM_ACTUAL", "SCALE_SCORE", "SCALE_SCORE_CSEM",
	  "SGP_ORDER_1", "SGP_ORDER_1_0.05_CONFIDENCE_BOUND", "SGP_ORDER_1_0.95_CONFIDENCE_BOUND", "SGP_ORDER_1_STANDARD_ERROR"),
	c("PARCCStudentIdentifier", "SummativeScaleScore", "SummativeCSEM", "IRTTheta", "Filler",
	  "StudentGrowthPercentileComparedtoState", "SGPLowerBoundState", "SGPUpperBoundState", "SGPStandardErrorState"))

###    Split SGP_NORM_GROUP to create 'SGPPreviousTestCode*' Variables
state.tmp.split <- strsplit(as.character(State_LONG_Data$SGP_NORM_GROUP), "; ")
State_LONG_Data[, CONTENT_AREA_PRIOR := sapply(sapply(strsplit(sapply(strsplit(sapply(state.tmp.split, function(x) rev(x)[2]), "/"), '[', 2), "_"), head, -1), paste, collapse="_")]
State_LONG_Data[, GRADE_PRIOR := sapply(strsplit(sapply(strsplit(sapply(state.tmp.split, function(x) rev(x)[2]), "/"), '[', 2), "_"), tail, 1)]
State_LONG_Data[which(GRADE_PRIOR=="EOCT"), GRADE_PRIOR := ""]
State_LONG_Data[, SGPPreviousTestCodeState := factor(paste(CONTENT_AREA_PRIOR, GRADE_PRIOR))]

###  Recode new SGPPreviousTestCodeState Variable.  Check table(levels(State_LONG_Data$SGPPreviousTestCodeState)) before and after to ensure match!!!
table(State_LONG_Data$SGPPreviousTestCodeState)
levels(State_LONG_Data$SGPPreviousTestCodeState) <- c(NA, "ALG01", "ALG02", "ELA10", "ELA08", "ELA09", "GEO01", "MAT07", "MAT08")
table(State_LONG_Data$SGPPreviousTestCodeState, exclude=NULL) ##  Match???

State_LONG_Data[, SGPPreviousTestCodeState := as.character(SGPPreviousTestCodeState)]
State_LONG_Data[, CONTENT_AREA_PRIOR := NULL]
State_LONG_Data[, GRADE_PRIOR := NULL]

State_LONG_Data <- State_LONG_Data[, names(State_LONG_Data)[names(State_LONG_Data) %in% all.names], with=FALSE]


###   PARCC Consortium Data

###  Remove "DUPS" label from IDs for duplicated records
PARCC_LONG_Data[, ID:=gsub("_DUPS_[0-9]*", "", ID)]

###  Combine SGP_NOTE and SGP variables (use SGP_ORDER_1 as "official" SGP for Fall 2016 analyses)
PARCC_LONG_Data[, SGP_ORDER_1 := as.character(SGP_ORDER_1)]
PARCC_LONG_Data[which(is.na(SGP_ORDER_1)), SGP_ORDER_1 := SGP_NOTE]

###  Change relevant SGP package convention names to Pearson's names
setnames(PARCC_LONG_Data,
  c("ID", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_CSEM_ACTUAL", "SCALE_SCORE", "SCALE_SCORE_CSEM",
	  "SGP_ORDER_1", "SGP_ORDER_1_0.05_CONFIDENCE_BOUND", "SGP_ORDER_1_0.95_CONFIDENCE_BOUND", "SGP_ORDER_1_STANDARD_ERROR"),
	c("PARCCStudentIdentifier", "SummativeScaleScore", "SummativeCSEM", "IRTTheta", "Filler",
	  "StudentGrowthPercentileComparedtoPARCC", "SGPLowerBoundPARCC", "SGPUpperBoundPARCC", "SGPStandardErrorPARCC"))

### Split SGP_NORM_GROUP to create 'SGPPreviousTestCode*' Variables
parcc.tmp.split <- strsplit(as.character(PARCC_LONG_Data$SGP_NORM_GROUP), "; ")
PARCC_LONG_Data[, CONTENT_AREA_PRIOR := sapply(sapply(strsplit(sapply(strsplit(sapply(parcc.tmp.split, function(x) rev(x)[2]), "/"), '[', 2), "_"), head, -1), paste, collapse="_")]
PARCC_LONG_Data[, GRADE_PRIOR := sapply(strsplit(sapply(strsplit(sapply(parcc.tmp.split, function(x) rev(x)[2]), "/"), '[', 2), "_"), tail, 1)]
PARCC_LONG_Data[which(GRADE_PRIOR=="EOCT"), GRADE_PRIOR := ""]
PARCC_LONG_Data[, SGPPreviousTestCodePARCC := factor(paste(CONTENT_AREA_PRIOR, GRADE_PRIOR))]

###  Recode new SGPPreviousTestCodePARCC Variable.  Check table(levels(PARCC_LONG_Data$SGPPreviousTestCodePARCC)) before and after to ensure match!!!
table(PARCC_LONG_Data$SGPPreviousTestCodePARCC)
levels(PARCC_LONG_Data$SGPPreviousTestCodePARCC) <- c(NA, "ALG01", "ALG02", "ELA10","ELA08", "ELA09", "GEO01", "MAT1I", "MAT2I", "MAT3I", "MAT07", "MAT08")
table(PARCC_LONG_Data$SGPPreviousTestCodePARCC, exclude=NULL) ##  Match???

PARCC_LONG_Data[, SGPPreviousTestCodePARCC := as.character(SGPPreviousTestCodePARCC)]
PARCC_LONG_Data[, CONTENT_AREA_PRIOR := NULL]
PARCC_LONG_Data[, GRADE_PRIOR := NULL]

PARCC_LONG_Data <- PARCC_LONG_Data[, names(PARCC_LONG_Data)[names(PARCC_LONG_Data) %in% all.names], with=FALSE]

###       Merge PARCC and State Data
FINAL_LONG_Data <- merge(PARCC_LONG_Data, State_LONG_Data, by=intersect(names(PARCC_LONG_Data), names(State_LONG_Data)), all.x=TRUE)

###  Coordinate missing SGP notes for small N states and set remaining missings as character "NA" (currently logical NA)
FINAL_LONG_Data[which(is.na(StudentGrowthPercentileComparedtoState) & StudentGrowthPercentileComparedtoPARCC == "<1000"), SGPPreviousTestCodeState := SGPPreviousTestCodePARCC]
FINAL_LONG_Data[which(is.na(StudentGrowthPercentileComparedtoState) & StudentGrowthPercentileComparedtoPARCC == "<1000"), StudentGrowthPercentileComparedtoState := "<1000"]
FINAL_LONG_Data[which(is.na(StudentGrowthPercentileComparedtoState)), StudentGrowthPercentileComparedtoState := "NA"]
FINAL_LONG_Data[which(is.na(StudentGrowthPercentileComparedtoPARCC)), StudentGrowthPercentileComparedtoPARCC := "NA"]

setcolorder(FINAL_LONG_Data, all.names)

###
###  Save R object and Export/zip State specific .csv files
###

save(FINAL_LONG_Data, file="./PARCC/Data/Pearson/PARCC_SGP_LONG_Data_2016_2017.1-FORMATTED.Rdata")

####  Loop on State Abbreviation to write out each state file in format that it was recieved and return requested
dir.create("./Bureau_Indian_Affairs/Data/Pearson", recursive=TRUE)
for (abv in unique(FINAL_LONG_Data$StateAbbreviation)) {
  if (abv=="BI") tmp.state <- "Bureau Indian Affairs" else tmp.state <- SGP:::getStateAbbreviation(abv, type="state")
	dir.name <- paste0("./",  gsub(" ", "_", capwords(tmp.state, special.words="DC")), "/Data/Pearson")
	fname <- paste0(dir.name, "/PARCC_", abv, "_2016-2017_FallBlock_SGP-Results_", format(Sys.Date(), format="%Y%m%d"), ".csv")
	fwrite(FINAL_LONG_Data[StateAbbreviation == abv], fname) #, col.names = FALSE
	zip(zipfile=paste(fname, "zip", sep="."), files=fname, flags="-mq")
}
