################################################################################
###                                                                          ###
###        Format PARCC Spring 2017 Results Data to Return to Pearson        ###
###                                                                          ###
################################################################################

### Load required packages

require(SGP)
require(data.table)

###
###    Read in Spring 2017 Output Files
###

load("./PARCC/Data/Archive/2016_2017.2/PARCC_SGP_LONG_Data_2016_2017.2.Rdata")

load("./Colorado/Data/Archive/2016_2017.2/Colorado_SGP_LONG_Data_2016_2017.2.Rdata")
load("./Illinois/Data/Archive/2016_2017.2/Illinois_SGP_LONG_Data_2016_2017.2.Rdata")
load("./Maryland/Data/Archive/2016_2017.2/Maryland_SGP_LONG_Data_2016_2017.2.Rdata")
load("./Massachusetts/Data/Archive/2016_2017.2/Massachusetts_SGP_LONG_Data_2016_2017.2.Rdata")
load("./New_Jersey/Data/Archive/2016_2017.2/New_Jersey_SGP_LONG_Data_2016_2017.2.Rdata")
load("./New_Mexico/Data/Archive/2016_2017.2/New_Mexico_SGP_LONG_Data_2016_2017.2.Rdata")
load("./Rhode_Island/Data/Archive/2016_2017.2/Rhode_Island_SGP_LONG_Data_2016_2017.2.Rdata")
load("./Washington_DC/Data/Archive/2016_2017.2/WASHINGTON_DC_SGP_LONG_Data_2016_2017.2.Rdata")
load("./Bureau_Indian_Affairs/Data/Archive/2016_2017.2/Bureau_Indian_Affairs_SGP_LONG_Data_2016_2017.2.Rdata")

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

all.var.names <- c(parcc.var.names, center.var.names)

####  Combine states' data into single data table
State_LONG_Data <- rbindlist(list(
	Maryland_SGP_LONG_Data_2016_2017.2, New_Jersey_SGP_LONG_Data_2016_2017.2), fill=TRUE)

####    Remove rows associated with the Scale Score SGP
State_LONG_Data <- State_LONG_Data[grep("_SS", CONTENT_AREA, invert =TRUE),]
PARCC_LONG_Data <- PARCC_SGP_LONG_Data_2016_2017.2[grep("_SS", CONTENT_AREA, invert =TRUE),]


#####
###    Format data to Pearson's specifications
#####

###   State Data

###  Change relevant SGP package convention names to Pearson's names
setnames(State_LONG_Data,
    	c("ID", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_CSEM_ACTUAL", "SCALE_SCORE", "SCALE_SCORE_CSEM",
        "SGP_ORDER_1", "SGP_0.05_CONFIDENCE_BOUND", "SGP_0.95_CONFIDENCE_BOUND", "SGP_STANDARD_ERROR",
        "SGP_ORDER_1", "SGP_ORDER_1_0.05_CONFIDENCE_BOUND", "SGP_ORDER_1_0.95_CONFIDENCE_BOUND", "SGP_ORDER_1_STANDARD_ERROR",
    	  "SGP_ORDER_2", "SGP_ORDER_2_0.05_CONFIDENCE_BOUND", "SGP_ORDER_2_0.95_CONFIDENCE_BOUND", "SGP_ORDER_2_STANDARD_ERROR",
        "SGP_SIMEX_RANKED", "SGP_SIMEX_RANKED_ORDER_1", "SGP_SIMEX_RANKED_ORDER_2",
        "SGP_TARGET_3_YEAR", "SGP_TARGET_3_YEAR_CONTENT_AREA"),
    	c("PARCCStudentIdentifier", "SummativeScaleScore", "SummativeCSEM", "IRTTheta", "ThetaSEM",
        "StudentGrowthPercentileComparedtoState", "SGPLowerBoundState", "SGPUpperBoundState", "SGPStandardErrorState",
        "StudentGrowthPercentileComparedtoState1Prior", "SGPLowerBoundState1Prior", "SGPUpperBoundState1Prior", "SGPStandardErrorState1Prior",
    	  "StudentGrowthPercentileComparedtoState2Prior", "SGPLowerBoundState2Prior", "SGPUpperBoundState2Prior", "SGPStandardErrorState2Prior",
        "SGPRankedSimexState", "SGPRankedSimexState1Prior", "SGPRankedSimexState2Prior",
        "SGPTargetState", "SGPTargetTestCodeState"))

###    Split SGP_NORM_GROUP to create 'SGPPreviousTestCode*' Variables
state.tmp.split <- strsplit(as.character(State_LONG_Data$SGP_NORM_GROUP), "; ")
State_LONG_Data[, CONTENT_AREA_1PRIOR := sapply(sapply(strsplit(sapply(strsplit(sapply(state.tmp.split, function(x) rev(x)[2]), "/"), '[', 2), "_"), head, -1), paste, collapse="_")]
State_LONG_Data[, CONTENT_AREA_2PRIOR := sapply(sapply(strsplit(sapply(strsplit(sapply(state.tmp.split, function(x) rev(x)[3]), "/"), '[', 2), "_"), head, -1), paste, collapse="_")]
State_LONG_Data[, GRADE_1PRIOR := sapply(strsplit(sapply(strsplit(sapply(state.tmp.split, function(x) rev(x)[2]), "/"), '[', 2), "_"), tail, 1)]
State_LONG_Data[, GRADE_2PRIOR := sapply(strsplit(sapply(strsplit(sapply(state.tmp.split, function(x) rev(x)[3]), "/"), '[', 2), "_"), tail, 1)]
State_LONG_Data[which(GRADE_1PRIOR=="EOCT"), GRADE_1PRIOR := ""]
State_LONG_Data[which(GRADE_2PRIOR=="EOCT"), GRADE_2PRIOR := ""]
State_LONG_Data[, SGPPreviousTestCodeState := factor(paste(CONTENT_AREA_2PRIOR, GRADE_2PRIOR, ";", CONTENT_AREA_1PRIOR, GRADE_1PRIOR))]

State_LONG_Data[, SGPPreviousTestCodeState1Prior := factor(paste(CONTENT_AREA_1PRIOR, GRADE_1PRIOR)) ]
State_LONG_Data[, SGPPreviousTestCodeState2Prior := factor(paste(CONTENT_AREA_2PRIOR, GRADE_2PRIOR)) ]


###  Recode new SGPPreviousTestCodeState(*)Prior Variables.  Check table(levels(State_LONG_Data$SGPPreviousTestCodeState(*)Prior)) before and after to ensure match!!!
table(State_LONG_Data$SGPPreviousTestCodeState)
levels(State_LONG_Data$SGPPreviousTestCodeState) <- #c(NA, "ALG01;ALG02", "ALG01;GEOM", "GEOM;ALG02", "ELA07;ELA08", "ELA08;ELA09", "ELA09;ELA10", "GEO01", "MAT07;MAT08"
table(State_LONG_Data$SGPPreviousTestCodeState, exclude=NULL) ##  Match???

table(State_LONG_Data$SGPPreviousTestCodeState1Prior)
levels(State_LONG_Data$SGPPreviousTestCodeState1Prior) <- c(NA, "ALG01", "ALG02", "ELA10", "ELA03", "ELA04", "ELA05", "ELA06", "ELA07", "ELA08", "ELA09",
	                                                          "GEO01", "MAT1I", "MAT2I", "MAT3I", "MAT03", "MAT04", "MAT05", "MAT06", "MAT07", "MAT08")
table(State_LONG_Data$SGPPreviousTestCodeState1Prior, exclude=NULL) ##  Match???

table(State_LONG_Data$SGPPreviousTestCodeState2Prior)
levels(State_LONG_Data$SGPPreviousTestCodeState2Prior)<- c(NA, "ALG01", "ALG02", "ELA10", "ELA03", "ELA04", "ELA05", "ELA06", "ELA07", "ELA08", "ELA09",
	                                                         "GEO01", "MAT1I", "MAT2I", "MAT3I", "MAT03", "MAT04", "MAT05", "MAT06", "MAT07", "MAT08")
table(State_LONG_Data$SGPPreviousTestCodeState2Prior, exclude=NULL) ##  Match???

State_LONG_Data[, SGPPreviousTestCodeState := as.character(SGPPreviousTestCodeState)]
State_LONG_Data[, SGPPreviousTestCodeState1Prior := as.character(SGPPreviousTestCodeState1Prior)]
State_LONG_Data[, SGPPreviousTestCodeState2Prior := as.character(SGPPreviousTestCodeState2Prior)]
State_LONG_Data[, CONTENT_AREA_1PRIOR := NULL]
State_LONG_Data[, CONTENT_AREA_2PRIOR := NULL]
State_LONG_Data[, GRADE_1PRIOR := NULL]
State_LONG_Data[, GRADE_2PRIOR := NULL]

###  Re-order columns of State_LONG_Data
State_LONG_Data <- State_LONG_Data[, names(State_LONG_Data)[names(State_LONG_Data) %in% all.names], with=FALSE]


###   PARCC Consortium Data

###  Change relevant SGP package convention names to Pearson's names
setnames(PARCC_LONG_Data,
    c("ID", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_CSEM_ACTUAL", "SCALE_SCORE", "SCALE_SCORE_CSEM",
      "SGP_ORDER_1", "SGP_0.05_CONFIDENCE_BOUND", "SGP_0.95_CONFIDENCE_BOUND", "SGP_STANDARD_ERROR",
      "SGP_ORDER_1", "SGP_ORDER_1_0.05_CONFIDENCE_BOUND", "SGP_ORDER_1_0.95_CONFIDENCE_BOUND", "SGP_ORDER_1_STANDARD_ERROR",
      "SGP_ORDER_2", "SGP_ORDER_2_0.05_CONFIDENCE_BOUND", "SGP_ORDER_2_0.95_CONFIDENCE_BOUND", "SGP_ORDER_2_STANDARD_ERROR",
      "SGP_SIMEX_RANKED", "SGP_SIMEX_RANKED_ORDER_1", "SGP_SIMEX_RANKED_ORDER_2",
      "SGP_TARGET_3_YEAR", "SGP_TARGET_3_YEAR_CONTENT_AREA"),
    c("PARCCStudentIdentifier", "SummativeScaleScore", "SummativeCSEM", "IRTTheta", "ThetaSEM",
      "StudentGrowthPercentileComparedtoPARCC", "SGPLowerBoundPARCC", "SGPUpperBoundPARCC", "SGPStandardErrorPARCC",
      "StudentGrowthPercentileComparedtoPARCC1Prior", "SGPLowerBoundPARCC1Prior", "SGPUpperBoundPARCC1Prior", "SGPStandardErrorPARCC1Prior",
      "StudentGrowthPercentileComparedtoPARCC2Prior", "SGPLowerBoundPARCC2Prior", "SGPUpperBoundPARCC2Prior", "SGPStandardErrorPARCC2Prior",
      "SGPRankedSimexPARCC", "SGPRankedSimexPARCC1Prior", "SGPRankedSimexPARCC2Prior",
      "SGPTargetPARCC", "SGPTargetTestCodePARCC"))

### Split SGP_NORM_GROUP to create 'SGPPreviousTestCode*' Variables
PARCC.tmp.split <- strsplit(as.character(PARCC_LONG_Data$SGP_NORM_GROUP), "; ")
PARCC_LONG_Data[, CONTENT_AREA_1PRIOR := sapply(sapply(strsplit(sapply(strsplit(sapply(PARCC.tmp.split, function(x) rev(x)[2]), "/"), '[', 2), "_"), head, -1), paste, collapse="_")]
PARCC_LONG_Data[, CONTENT_AREA_2PRIOR := sapply(sapply(strsplit(sapply(strsplit(sapply(PARCC.tmp.split, function(x) rev(x)[3]), "/"), '[', 2), "_"), head, -1), paste, collapse="_")]
PARCC_LONG_Data[, GRADE_1PRIOR := sapply(strsplit(sapply(strsplit(sapply(PARCC.tmp.split, function(x) rev(x)[2]), "/"), '[', 2), "_"), tail, 1)]
PARCC_LONG_Data[, GRADE_2PRIOR := sapply(strsplit(sapply(strsplit(sapply(PARCC.tmp.split, function(x) rev(x)[3]), "/"), '[', 2), "_"), tail, 1)]
PARCC_LONG_Data[which(GRADE_1PRIOR=="EOCT"), GRADE_1PRIOR := ""]
PARCC_LONG_Data[which(GRADE_2PRIOR=="EOCT"), GRADE_2PRIOR := ""]
PARCC_LONG_Data[, SGPPreviousTestCodePARCC := factor(paste(CONTENT_AREA_2PRIOR, GRADE_2PRIOR, ";", CONTENT_AREA_1PRIOR, GRADE_1PRIOR))]

PARCC_LONG_Data[, SGPPreviousTestCodePARCC1Prior := factor(paste(CONTENT_AREA_1PRIOR, GRADE_1PRIOR)) ]
PARCC_LONG_Data[, SGPPreviousTestCodePARCC2Prior := factor(paste(CONTENT_AREA_2PRIOR, GRADE_2PRIOR)) ]


###  Recode new SGPPreviousTestCodePARCC(*)Prior Variables.  Check table(levels(PARCC_LONG_Data$SGPPreviousTestCodePARCC(*)Prior)) before and after to ensure match!!!
table(PARCC_LONG_Data$SGPPreviousTestCodePARCC)
levels(PARCC_LONG_Data$SGPPreviousTestCodePARCC) <- #c(NA, "ALG01;ALG02", "ALG01;GEOM", "GEOM;ALG02", "ELA07;ELA08", "ELA08;ELA09", "ELA09;ELA10", "GEO01", "MAT07;MAT08"
table(PARCC_LONG_Data$SGPPreviousTestCodePARCC, exclude=NULL) ##  Match???

table(PARCC_LONG_Data$SGPPreviousTestCodePARCC1Prior)
levels(PARCC_LONG_Data$SGPPreviousTestCodePARCC1Prior) <- c(NA, "ALG01", "ALG02", "ELA10", "ELA03", "ELA04", "ELA05", "ELA06", "ELA07", "ELA08", "ELA09",
	                                                          "GEO01", "MAT1I", "MAT2I", "MAT3I", "MAT03", "MAT04", "MAT05", "MAT06", "MAT07", "MAT08")
table(PARCC_LONG_Data$SGPPreviousTestCodePARCC1Prior, exclude=NULL) ##  Match???

table(PARCC_LONG_Data$SGPPreviousTestCodePARCC2Prior)
levels(PARCC_LONG_Data$SGPPreviousTestCodePARCC2Prior)<- c(NA, "ALG01", "ALG02", "ELA10", "ELA03", "ELA04", "ELA05", "ELA06", "ELA07", "ELA08", "ELA09",
	                                                         "GEO01", "MAT1I", "MAT2I", "MAT3I", "MAT03", "MAT04", "MAT05", "MAT06", "MAT07", "MAT08")
table(PARCC_LONG_Data$SGPPreviousTestCodePARCC2Prior, exclude=NULL) ##  Match???

PARCC_LONG_Data[, SGPPreviousTestCodePARCC := as.character(SGPPreviousTestCodePARCC)]
PARCC_LONG_Data[, SGPPreviousTestCodePARCC1Prior := as.character(SGPPreviousTestCodePARCC1Prior)]
PARCC_LONG_Data[, SGPPreviousTestCodePARCC2Prior := as.character(SGPPreviousTestCodePARCC2Prior)]
PARCC_LONG_Data[, CONTENT_AREA_1PRIOR := NULL]
PARCC_LONG_Data[, CONTENT_AREA_2PRIOR := NULL]
PARCC_LONG_Data[, GRADE_1PRIOR := NULL]
PARCC_LONG_Data[, GRADE_2PRIOR := NULL]

###  Re-order columns of PARCC_LONG_Data
PARCC_LONG_Data <- PARCC_LONG_Data[, names(PARCC_LONG_Data)[names(PARCC_LONG_Data) %in% all.names], with=FALSE]

###
###       Merge PARCC and State Data
###

FINAL_LONG_Data <- merge(PARCC_LONG_Data, State_LONG_Data, by=intersect(names(PARCC_LONG_Data), names(State_LONG_Data)), all.x=TRUE)

###  Coordinate missing SGP notes for small N states and set remaining missings as character "NA" (currently logical NA)
FINAL_LONG_Data[which(is.na(StudentGrowthPercentileComparedtoState) & StudentGrowthPercentileComparedtoPARCC == "<1000"), SGPPreviousTestCodeState := SGPPreviousTestCodePARCC]
FINAL_LONG_Data[which(is.na(StudentGrowthPercentileComparedtoState) & StudentGrowthPercentileComparedtoPARCC == "<1000"), StudentGrowthPercentileComparedtoState := "<1000"]
FINAL_LONG_Data[which(is.na(StudentGrowthPercentileComparedtoState)), StudentGrowthPercentileComparedtoState := "NA"]
FINAL_LONG_Data[which(is.na(StudentGrowthPercentileComparedtoPARCC)), StudentGrowthPercentileComparedtoPARCC := "NA"]

###  Make sure no exact duplicates remain.
setkey(FINAL_LONG_Data, PARCCStudentIdentifier, StudentTestUUID, TestCode, SummativeScaleScore)
setkey(FINAL_LONG_Data, PARCCStudentIdentifier, StudentTestUUID, TestCode)
table(duplicated(FINAL_LONG_Data, by=key(FINAL_LONG_Data))) # Should be FALSE
findups <- FINAL_LONG_Data[c(which(duplicated(FINAL_LONG_Data, by=key(FINAL_LONG_Data)))-1, which(duplicated(FINAL_LONG_Data, by=key(FINAL_LONG_Data)))),]
dim(findups) # Should be 0 rows!

setcolorder(FINAL_LONG_Data, all.names)

###
###  Save R object and Export/zip State specific .csv files
###

save(FINAL_LONG_Data, file="./PARCC/Data/Pearson/PARCC_SGP_LONG_Data_2016_2017.2-FORMATTED.Rdata")

####  Loop on State Abbreviation to write out each state file in format that it was recieved and return requested
dir.create("./Bureau_Indian_Affairs/Data/Pearson", recursive=TRUE)
for (abv in unique(FINAL_LONG_Data$StateAbbreviation)) {
  if (abv=="BI") tmp.state <- "Bureau Indian Affairs" else tmp.state <- SGP:::getStateAbbreviation(abv, type="state")
	dir.name <- paste0("./",  gsub(" ", "_", capwords(tmp.state, special.words="DC")), "/Data/Pearson")
	fname <- paste0(dir.name, "/PARCC_", abv, "_2016-2017_Spring_SGP-Results_", format(Sys.Date(), format="%Y%m%d"), ".csv")
	fwrite(FINAL_LONG_Data[StateAbbreviation == abv], fname) #, col.names = FALSE
	zip(zipfile=paste(fname, "zip", sep="."), files=fname, flags="-mq")
}
