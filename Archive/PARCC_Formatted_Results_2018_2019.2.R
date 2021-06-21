################################################################################
###                                                                          ###
###        Format PARCC Spring 2019 Results Data to Return to Pearson        ###
###                                                                          ###
################################################################################

### Load required packages

require(SGP)
require(data.table)

###
###    Read in Spring 2019 Output Files
###

load("./PARCC/Data/Archive/2018_2019.2/PARCC_SGP_LONG_Data_2018_2019.2.Rdata")

load("./Illinois/Data/Archive/2018_2019.2/Illinois_SGP_LONG_Data_2018_2019.2.Rdata")
load("./Maryland/Data/Archive/2018_2019.2/Maryland_SGP_LONG_Data_2018_2019.2.Rdata")
load("./New_Jersey/Data/Archive/2018_2019.2/New_Jersey_SGP_LONG_Data_2018_2019.2.Rdata")
load("./New_Mexico/Data/Archive/2018_2019.2/New_Mexico_SGP_LONG_Data_2018_2019.2.Rdata")
load("./Washington_DC/Data/Archive/2018_2019.2/Washington_DC_SGP_LONG_Data_2018_2019.2.Rdata")
load("./Bureau_Indian_Affairs/Data/Archive/2018_2019.2/Bureau_Indian_Affairs_SGP_LONG_Data_2018_2019.2.Rdata")
load("./Department_Of_Defense/Data/Archive/2018_2019.2/Department_of_Defense_SGP_LONG_Data_2018_2019.2.Rdata")


###  Amend State Files as needed

#    Illinois & Washington_DC only have percentiles/projections through grade 8 so no EOCT projection groups / need for SGP_TARGET_3_YEAR_CONTENT_AREA in combineSGP.
Illinois_SGP_LONG_Data_2018_2019.2[, SGP_TARGET_3_YEAR_CONTENT_AREA := as.character(NA)]
Illinois_SGP_LONG_Data_2018_2019.2[!is.na(SGP_TARGET_3_YEAR), SGP_TARGET_3_YEAR_CONTENT_AREA := CONTENT_AREA]

Washington_DC_SGP_LONG_Data_2018_2019.2[, SGP_TARGET_3_YEAR_CONTENT_AREA := as.character(NA)]
Washington_DC_SGP_LONG_Data_2018_2019.2[!is.na(SGP_TARGET_3_YEAR), SGP_TARGET_3_YEAR_CONTENT_AREA := CONTENT_AREA]


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

all.var.names <- c(parcc.var.names[1:11], center.var.names[1:4], parcc.var.names[12:13], center.var.names[-c(1:4)], "EXACT_DUPLICATE")

####  Combine states' data into single data table
State_LONG_Data <- rbindlist(list(Bureau_Indian_Affairs_SGP_LONG_Data_2018_2019.2,
  Department_of_Defense_SGP_LONG_Data_2018_2019.2, Illinois_SGP_LONG_Data_2018_2019.2,
  Maryland_SGP_LONG_Data_2018_2019.2, New_Jersey_SGP_LONG_Data_2018_2019.2,
  New_Mexico_SGP_LONG_Data_2018_2019.2, Washington_DC_SGP_LONG_Data_2018_2019.2), fill=TRUE)

####    Remove rows associated with the Scale Score SGP
State_LONG_Data <- State_LONG_Data[grep("_SS", CONTENT_AREA, invert =TRUE),]
PARCC_LONG_Data <- PARCC_SGP_LONG_Data_2018_2019.2[grep("_SS", CONTENT_AREA, invert =TRUE),]


####   For individual state data formatting
State_LONG_Data <- New_Mexico_SGP_LONG_Data_2018_2019.2[grep("_SS", CONTENT_AREA, invert =TRUE),]
PARCC_LONG_Data <- PARCC_SGP_LONG_Data_2018_2019.2[StateAbbreviation == "NM"]
PARCC_LONG_Data <- PARCC_LONG_Data[grep("_SS", CONTENT_AREA, invert =TRUE),]


#####
###    Format data to Pearson's specifications
#####

###         State Data

###   Combine SGP_NOTE and SGP variables
State_LONG_Data[, SGP := as.character(SGP)]
State_LONG_Data[which(is.na(SGP)), SGP := SGP_NOTE]

###   Now remove NOTE - Kathy/Pat 8/14/19 -- Just kidding :/
# State_LONG_Data[, SGP_NORM_GROUP := as.character(SGP_NORM_GROUP)]
# State_LONG_Data[!is.na(SGP_NOTE), SGP_NORM_GROUP := ""]

###  Change relevant SGP package convention names to Pearson's names
sgp.names <- c(
  "ID", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_CSEM_ACTUAL", "SCALE_SCORE", "SCALE_SCORE_CSEM",
  "SGP", "SGP_0.05_CONFIDENCE_BOUND", "SGP_0.95_CONFIDENCE_BOUND", "SGP_STANDARD_ERROR",
  "SGP_ORDER_1", "SGP_ORDER_1_0.05_CONFIDENCE_BOUND", "SGP_ORDER_1_0.95_CONFIDENCE_BOUND", "SGP_ORDER_1_STANDARD_ERROR",
  "SGP_ORDER_2", "SGP_ORDER_2_0.05_CONFIDENCE_BOUND", "SGP_ORDER_2_0.95_CONFIDENCE_BOUND", "SGP_ORDER_2_STANDARD_ERROR",
  "SGP_SIMEX_RANKED", "SGP_SIMEX_RANKED_ORDER_1", "SGP_SIMEX_RANKED_ORDER_2",
  "SGP_TARGET_3_YEAR", "SGP_TARGET_3_YEAR_CONTENT_AREA")

setnames(State_LONG_Data,
    	sgp.names[sgp.names  %in% names(State_LONG_Data)],
    	c("PANUniqueStudentID", "SummativeScaleScore", "SummativeCSEM", "IRTTheta", "ThetaSEM",
        "StudentGrowthPercentileComparedtoState", "SGPLowerBoundState", "SGPUpperBoundState", "SGPStandardErrorState",
        "StudentGrowthPercentileComparedtoState1Prior", "SGPLowerBoundState1Prior", "SGPUpperBoundState1Prior", "SGPStandardErrorState1Prior",
    	  "StudentGrowthPercentileComparedtoState2Prior", "SGPLowerBoundState2Prior", "SGPUpperBoundState2Prior", "SGPStandardErrorState2Prior",
        "SGPRankedSimexState", "SGPRankedSimexState1Prior", "SGPRankedSimexState2Prior",
        "SGPTargetState", "SGPTargetTestCodeState")[sgp.names  %in% names(State_LONG_Data)])

###    Split SGP_NORM_GROUP to create 'SGPPreviousTestCode*' Variables
state.tmp.split <- strsplit(as.character(State_LONG_Data$SGP_NORM_GROUP), "; ")
State_LONG_Data[, CONTENT_AREA_1PRIOR := factor(sapply(sapply(strsplit(sapply(strsplit(sapply(state.tmp.split, function(x) rev(x)[2]), "/"), '[', 2), "_"), head, -1), paste, collapse="_"))]
State_LONG_Data[, CONTENT_AREA_2PRIOR := factor(sapply(sapply(strsplit(sapply(strsplit(sapply(state.tmp.split, function(x) rev(x)[3]), "/"), '[', 2), "_"), head, -1), paste, collapse="_"))]
##   Check!
levels(State_LONG_Data$CONTENT_AREA_1PRIOR) <- c(NA, "ALG01", "ALG02", "ELA", "GEO01", "MAT1I", "MAT2I", "MAT")
# levels(State_LONG_Data$CONTENT_AREA_1PRIOR) <- c(NA, "ALG01", "ELA", "GEO01", "MAT")
levels(State_LONG_Data$CONTENT_AREA_2PRIOR) <- c(NA, "ALG01", "ELA", "MAT")
State_LONG_Data[, GRADE_1PRIOR := sapply(strsplit(sapply(strsplit(sapply(state.tmp.split, function(x) rev(x)[2]), "/"), '[', 2), "_"), tail, 1)]
State_LONG_Data[, GRADE_2PRIOR := sapply(strsplit(sapply(strsplit(sapply(state.tmp.split, function(x) rev(x)[3]), "/"), '[', 2), "_"), tail, 1)]
State_LONG_Data[which(GRADE_1PRIOR=="EOCT"), GRADE_1PRIOR := ""]#XX#
State_LONG_Data[which(GRADE_2PRIOR=="EOCT"), GRADE_2PRIOR := ""]#XX#
State_LONG_Data[which(GRADE_1PRIOR %in% 3:9), GRADE_1PRIOR := paste0("0", GRADE_1PRIOR)] #XX#
State_LONG_Data[which(GRADE_2PRIOR %in% 3:9), GRADE_2PRIOR := paste0("0", GRADE_2PRIOR)] #XX#
State_LONG_Data[, SGPPreviousTestCodeState := factor(paste0(CONTENT_AREA_2PRIOR, GRADE_2PRIOR, ";", CONTENT_AREA_1PRIOR, GRADE_1PRIOR))]
State_LONG_Data[, SGPPreviousTestCodeState := gsub("NANA;", "", SGPPreviousTestCodeState)]
State_LONG_Data[, SGPPreviousTestCodeState := gsub("NANA", "", SGPPreviousTestCodeState)]
State_LONG_Data[, SGPPreviousTestCodeState1Prior := factor(paste0(CONTENT_AREA_1PRIOR, GRADE_1PRIOR)) ]
State_LONG_Data[, SGPPreviousTestCodeState2Prior := factor(paste0(CONTENT_AREA_2PRIOR, GRADE_2PRIOR)) ]
State_LONG_Data[, SGPPreviousTestCodeState1Prior := gsub("NANA", "", SGPPreviousTestCodeState1Prior)]
State_LONG_Data[, SGPPreviousTestCodeState2Prior := gsub("NANA", "", SGPPreviousTestCodeState2Prior)]
# table(State_LONG_Data[, SGPPreviousTestCodeState1Prior, SGPPreviousTestCodeState])

###    Split SGP_NORM_GROUP_SCALE_SCORES to create 'SGPIRTThetaPARCC*' Variables
State.score.split <- strsplit(as.character(State_LONG_Data$SGP_NORM_GROUP_SCALE_SCORES), "; ")
State_LONG_Data[, SGPIRTThetaState1Prior := as.numeric(sapply(State.score.split, function(x) rev(x)[2]))]
State_LONG_Data[, SGPIRTThetaState2Prior := as.numeric(sapply(State.score.split, function(x) rev(x)[3]))]

###    Compute and Format SGPTargetTestCodeState
State_LONG_Data[, SGPTargetTestCodeState := factor(SGPTargetTestCodeState)]
levels(State_LONG_Data$SGPTargetTestCodeState) <- c("ALG01", "ALG02", "ELA", "GEO01", "MAT") # "MAT1I",
# levels(State_LONG_Data$SGPTargetTestCodeState) <- c("ELA", "MAT")
State_LONG_Data[, SGPTargetTestCodeState := as.character(SGPTargetTestCodeState)]
State_LONG_Data[SGPTargetTestCodeState %in% c("ELA", "MAT"), SGPTargetTestCodeState := paste0(SGPTargetTestCodeState, "0", as.numeric(GRADE)+3)]
# State_LONG_Data[, SGPTargetTestCodeState := gsub("09|010|011|013", "08", SGPTargetTestCodeState)] # Illinois/Washington_DC
State_LONG_Data[, SGPTargetTestCodeState := gsub("010", "10", SGPTargetTestCodeState)]
State_LONG_Data[, SGPTargetTestCodeState := gsub("011|012|013|014", "11", SGPTargetTestCodeState)]
State_LONG_Data[, SGPTargetTestCodeState := gsub("MAT09|MAT10|MAT11", "MAT08", SGPTargetTestCodeState)]
table(State_LONG_Data[, SGPTargetTestCodeState, TestCode])

####   For individual state data formatting
# State_LONG_Data[, grep("PARCC", center.var.names, value=T) := NA]
# State_LONG_Data[, center.var.names[!center.var.names %in% names(State_LONG_Data)] := NA]
####   For individual state data formatting


###  Re-order and SUBSET columns of State_LONG_Data
State_LONG_Data <- State_LONG_Data[, names(State_LONG_Data)[names(State_LONG_Data) %in% all.var.names], with=FALSE]


####   SKIP THIS STEP For individual state data formatting
###         PARCC Consortium Data

###  Combine SGP_NOTE and SGP variables
PARCC_LONG_Data[, SGP := as.character(SGP)]
PARCC_LONG_Data[which(is.na(SGP)), SGP := SGP_NOTE]

###   Now remove NOTE - Kathy/Pat 8/14/19 -- Just kidding :/
# PARCC_LONG_Data[, SGP_NORM_GROUP := as.character(SGP_NORM_GROUP)]
# PARCC_LONG_Data[!is.na(SGP_NOTE), SGP_NORM_GROUP := ""]

###  Change relevant SGP package convention names to Pearson's names
setnames(PARCC_LONG_Data,
    c("ID", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_CSEM_ACTUAL", "SCALE_SCORE", "SCALE_SCORE_CSEM",
      "SGP", "SGP_0.05_CONFIDENCE_BOUND", "SGP_0.95_CONFIDENCE_BOUND", "SGP_STANDARD_ERROR",
      "SGP_ORDER_1", "SGP_ORDER_1_0.05_CONFIDENCE_BOUND", "SGP_ORDER_1_0.95_CONFIDENCE_BOUND", "SGP_ORDER_1_STANDARD_ERROR",
      "SGP_ORDER_2", "SGP_ORDER_2_0.05_CONFIDENCE_BOUND", "SGP_ORDER_2_0.95_CONFIDENCE_BOUND", "SGP_ORDER_2_STANDARD_ERROR",
      "SGP_SIMEX_RANKED", "SGP_SIMEX_RANKED_ORDER_1", "SGP_SIMEX_RANKED_ORDER_2",
      "SGP_TARGET_3_YEAR", "SGP_TARGET_3_YEAR_CONTENT_AREA"),
    c("PANUniqueStudentID", "SummativeScaleScore", "SummativeCSEM", "IRTTheta", "ThetaSEM",
      "StudentGrowthPercentileComparedtoPARCC", "SGPLowerBoundPARCC", "SGPUpperBoundPARCC", "SGPStandardErrorPARCC",
      "StudentGrowthPercentileComparedtoPARCC1Prior", "SGPLowerBoundPARCC1Prior", "SGPUpperBoundPARCC1Prior", "SGPStandardErrorPARCC1Prior",
      "StudentGrowthPercentileComparedtoPARCC2Prior", "SGPLowerBoundPARCC2Prior", "SGPUpperBoundPARCC2Prior", "SGPStandardErrorPARCC2Prior",
      "SGPRankedSimexPARCC", "SGPRankedSimexPARCC1Prior", "SGPRankedSimexPARCC2Prior",
      "SGPTargetPARCC", "SGPTargetTestCodePARCC"))

### Split SGP_NORM_GROUP to create 'SGPPreviousTestCode*' Variables
PARCC.tmp.split <- strsplit(as.character(PARCC_LONG_Data$SGP_NORM_GROUP), "; ")

PARCC_LONG_Data[, CONTENT_AREA_1PRIOR := factor(sapply(sapply(strsplit(sapply(strsplit(sapply(PARCC.tmp.split, function(x) rev(x)[2]), "/"), '[', 2), "_"), head, -1), paste, collapse="_"))]
PARCC_LONG_Data[, CONTENT_AREA_2PRIOR := factor(sapply(sapply(strsplit(sapply(strsplit(sapply(PARCC.tmp.split, function(x) rev(x)[3]), "/"), '[', 2), "_"), head, -1), paste, collapse="_"))]
levels(PARCC_LONG_Data$CONTENT_AREA_1PRIOR) <- c(NA, "ALG01", "ALG02", "ELA", "GEO01", "MAT1I", "MAT2I", "MAT")
levels(PARCC_LONG_Data$CONTENT_AREA_2PRIOR) <- c(NA, "ALG01", "ELA", "MAT")
PARCC_LONG_Data[, GRADE_1PRIOR := sapply(strsplit(sapply(strsplit(sapply(PARCC.tmp.split, function(x) rev(x)[2]), "/"), '[', 2), "_"), tail, 1)]
PARCC_LONG_Data[, GRADE_2PRIOR := sapply(strsplit(sapply(strsplit(sapply(PARCC.tmp.split, function(x) rev(x)[3]), "/"), '[', 2), "_"), tail, 1)]
# PARCC_LONG_Data[which(CONTENT_AREA_1PRIOR=="MAT3I"), GRADE_1PRIOR := ""]#XX# MAT3I grade didn't get changed to "EOCT" in 2018(?) for some reason
PARCC_LONG_Data[which(GRADE_1PRIOR=="EOCT"), GRADE_1PRIOR := ""]#XX#
PARCC_LONG_Data[which(GRADE_2PRIOR=="EOCT"), GRADE_2PRIOR := ""]#XX# table(PARCC_LONG_Data[, GRADE_1PRIOR, CONTENT_AREA_1PRIOR])
PARCC_LONG_Data[which(GRADE_1PRIOR %in% 3:9), GRADE_1PRIOR := paste0("0", GRADE_1PRIOR)] #XX#
PARCC_LONG_Data[which(GRADE_2PRIOR %in% 3:9), GRADE_2PRIOR := paste0("0", GRADE_2PRIOR)] #XX#
PARCC_LONG_Data[, SGPPreviousTestCodePARCC := factor(paste0(CONTENT_AREA_2PRIOR, GRADE_2PRIOR, ";", CONTENT_AREA_1PRIOR, GRADE_1PRIOR))]
PARCC_LONG_Data[, SGPPreviousTestCodePARCC := gsub("NANA;", "", SGPPreviousTestCodePARCC)]
PARCC_LONG_Data[, SGPPreviousTestCodePARCC := gsub("NANA", "", SGPPreviousTestCodePARCC)]
PARCC_LONG_Data[, SGPPreviousTestCodePARCC1Prior := factor(paste0(CONTENT_AREA_1PRIOR, GRADE_1PRIOR)) ]
PARCC_LONG_Data[, SGPPreviousTestCodePARCC2Prior := factor(paste0(CONTENT_AREA_2PRIOR, GRADE_2PRIOR)) ]
PARCC_LONG_Data[, SGPPreviousTestCodePARCC1Prior := gsub("NANA", "", SGPPreviousTestCodePARCC1Prior)]
PARCC_LONG_Data[, SGPPreviousTestCodePARCC2Prior := gsub("NANA", "", SGPPreviousTestCodePARCC2Prior)]
# table(PARCC_LONG_Data[, SGPPreviousTestCodePARCC2Prior, SGPPreviousTestCodePARCC])

###    Split SGP_NORM_GROUP_SCALE_SCORES to create 'SGPIRTThetaPARCC*' Variables
PARCC.score.split <- strsplit(as.character(PARCC_LONG_Data$SGP_NORM_GROUP_SCALE_SCORES), "; ")
PARCC_LONG_Data[, SGPIRTThetaPARCC1Prior := as.numeric(sapply(PARCC.score.split, function(x) rev(x)[2]))]
PARCC_LONG_Data[, SGPIRTThetaPARCC2Prior := as.numeric(sapply(PARCC.score.split, function(x) rev(x)[3]))]

###    Compute and Format SGPTargetTestCodePARCC
PARCC_LONG_Data[, SGPTargetTestCodePARCC := factor(SGPTargetTestCodePARCC)]
levels(PARCC_LONG_Data$SGPTargetTestCodePARCC) <- c("ALG01", "ALG02", "ELA", "GEO01", "MAT") # No INTEGRATED_MATH_* as of 2019
PARCC_LONG_Data[, SGPTargetTestCodePARCC := as.character(SGPTargetTestCodePARCC)]
PARCC_LONG_Data[SGPTargetTestCodePARCC %in% c("ELA", "MAT"), SGPTargetTestCodePARCC := paste0(SGPTargetTestCodePARCC, "0", as.numeric(GRADE)+3)]
PARCC_LONG_Data[, SGPTargetTestCodePARCC := gsub("010", "10", SGPTargetTestCodePARCC)]
PARCC_LONG_Data[, SGPTargetTestCodePARCC := gsub("011|012|013|014", "11", SGPTargetTestCodePARCC)]
table(PARCC_LONG_Data[, SGPTargetTestCodePARCC, TestCode])

###  Re-order and SUBSET columns of PARCC_LONG_Data
PARCC_LONG_Data <- PARCC_LONG_Data[, names(PARCC_LONG_Data)[names(PARCC_LONG_Data) %in% all.var.names], with=FALSE]

###
###       Merge PARCC and State Data
###

####   SKIP THIS STEP For individual state data formatting
State_LONG_Data[, SummativeCSEM := as.numeric(SummativeCSEM)]
State_LONG_Data[, SummativeScaleScore := as.numeric(SummativeScaleScore)]

FINAL_LONG_Data <- merge(PARCC_LONG_Data, State_LONG_Data, by=intersect(names(PARCC_LONG_Data), names(State_LONG_Data)), all.x=TRUE)

####   For individual state data formatting
# FINAL_LONG_Data <- State_LONG_Data

###  Fix EXACT_DUPLICATEs  (None in Spring 2019)
FINAL_LONG_Data[EXACT_DUPLICATE==2, (center.var.names) := FINAL_LONG_Data[EXACT_DUPLICATE==1, center.var.names, with=FALSE]]
FINAL_LONG_Data[, EXACT_DUPLICATE := NULL]

###   Coordinate missing SGP notes for small N states
###   Now remove NOTE - Kathy/Pat 8/14/19 -- Just kidding :/
FINAL_LONG_Data[which(is.na(StudentGrowthPercentileComparedtoState) & StudentGrowthPercentileComparedtoPARCC == "<1000"), SGPPreviousTestCodeState := SGPPreviousTestCodePARCC]
FINAL_LONG_Data[which(is.na(StudentGrowthPercentileComparedtoState) & StudentGrowthPercentileComparedtoPARCC == "<1000"), StudentGrowthPercentileComparedtoState := "<1000"]

#  Return NA values blank for 2019?
# FINAL_LONG_Data[which(is.na(StudentGrowthPercentileComparedtoState)), StudentGrowthPercentileComparedtoState := "NA"]
# FINAL_LONG_Data[which(is.na(StudentGrowthPercentileComparedtoPARCC)), StudentGrowthPercentileComparedtoPARCC := "NA"]


###  Make sure no exact duplicates remain.
setkey(FINAL_LONG_Data, PANUniqueStudentID, StudentTestUUID, TestCode, SummativeScaleScore)
setkey(FINAL_LONG_Data, PANUniqueStudentID, StudentTestUUID, TestCode)
table(duplicated(FINAL_LONG_Data, by=key(FINAL_LONG_Data))) # Should be FALSE
findups <- FINAL_LONG_Data[c(which(duplicated(FINAL_LONG_Data, by=key(FINAL_LONG_Data)))-1, which(duplicated(FINAL_LONG_Data, by=key(FINAL_LONG_Data)))),]
nrow(findups) # Should be 0 rows!

setcolorder(FINAL_LONG_Data, head(all.var.names, -1))


###  Format IRTTheta variables
FINAL_LONG_Data[, IRTTheta := format(IRTTheta, scientific = FALSE)]
FINAL_LONG_Data[, SGPIRTThetaState1Prior := format(SGPIRTThetaState1Prior, scientific = FALSE)]
FINAL_LONG_Data[, SGPIRTThetaState2Prior := format(SGPIRTThetaState2Prior, scientific = FALSE)]

FINAL_LONG_Data[, SGPIRTThetaPARCC1Prior := format(SGPIRTThetaPARCC1Prior, scientific = FALSE)]
FINAL_LONG_Data[, SGPIRTThetaPARCC2Prior := format(SGPIRTThetaPARCC2Prior, scientific = FALSE)]


###   Final data QC checks
FINAL_LONG_Data[, as.list(summary(as.numeric(StudentGrowthPercentileComparedtoPARCC))), keyby="TestCode"] # SGPRankedSimexPARCC
table(FINAL_LONG_Data[, TestCode, SGPPreviousTestCodePARCC1Prior])
table(FINAL_LONG_Data[TestCode=="ELA10" & SGPPreviousTestCodePARCC1Prior=="ELA08", StateAbbreviation])
table(FINAL_LONG_Data[TestCode=="GEO01" & SGPPreviousTestCodePARCC1Prior=="MAT08", StateAbbreviation])
FINAL_LONG_Data[TestCode=="ELA10" & SGPPreviousTestCodePARCC1Prior=="ELA08", as.list(summary(as.numeric(StudentGrowthPercentileComparedtoPARCC))), keyby="StateAbbreviation"]
FINAL_LONG_Data[TestCode=="GEO01" & SGPPreviousTestCodePARCC1Prior=="MAT08", as.list(summary(as.numeric(StudentGrowthPercentileComparedtoPARCC))), keyby="StateAbbreviation"]
tbl <- FINAL_LONG_Data[grep("ELA04|ELA05|ELA06|ELA07|ELA08", TestCode), as.list(summary(as.numeric(StudentGrowthPercentileComparedtoPARCC))), keyby=c("StateAbbreviation", "TestCode")]
tbl[StateAbbreviation=="MD"]

summary(FINAL_LONG_Data[TestCode=="ELA10" & SGPPreviousTestCodeState1Prior=="ELA08", as.numeric(StudentGrowthPercentileComparedtoState)])
table(FINAL_LONG_Data[TestCode=="ELA10" & SGPPreviousTestCodeState1Prior=="ELA08", StateAbbreviation])
table(FINAL_LONG_Data[TestCode=="GEO01" & SGPPreviousTestCodeState1Prior=="MAT08", StateAbbreviation])

summary(FINAL_LONG_Data[TestCode=="ELA10" & SGPPreviousTestCodeState1Prior=="ELA09", as.numeric(StudentGrowthPercentileComparedtoState)])
table(FINAL_LONG_Data[TestCode=="ELA10" & SGPPreviousTestCodeState1Prior=="ELA09", StateAbbreviation]) # No DC students!
table(FINAL_LONG_Data[TestCode=="GEO01" & SGPPreviousTestCodeState1Prior=="ALG01", StateAbbreviation]) # No DC students!


###
###  Save R object and Export/zip State specific .csv files
###

# ####   For individual state data formatting
# abv <- "NJ"
# fname <- paste0("./", gsub(" ", "_", SGP:::getStateAbbreviation(abv, type="state")), "/Data/Pearson/PARCC_", abv, "_2018-2019_Spring_SGP-STATE_LEVEL_Results_", format(Sys.Date(), format="%Y%m%d"), ".csv")
# fname <- gsub("_of_", "_Of_", fname) # DoDEA folder name
# # fwrite(FINAL_LONG_Data, fname)
# options(scipen = 999)
# write.csv(FINAL_LONG_Data, fname, row.names = FALSE)
# zip(zipfile=paste0(fname, ".zip"), files=fname, flags="-mqj") # -mq doesn't leave a csv copy. j "junks" the directory structure (tree)
# ####   END For individual state data formatting


save(FINAL_LONG_Data, file="./PARCC/Data/Pearson/PARCC_SGP_LONG_Data_2018_2019.2-FORMATTED.Rdata")

####  Loop on State Abbreviation to write out each state file in format that it was recieved and return requested
tmp.wd <- getwd()
options(scipen = 999)
for (abv in unique(FINAL_LONG_Data$StateAbbreviation)) {
  fname <- paste0("./", gsub(" ", "_", SGP:::getStateAbbreviation(abv, type="state")), "/Data/Pearson/PARCC_", abv, "_2018-2019_Spring_SGP-Results_", format(Sys.Date(), format="%Y%m%d"), ".csv")
  fname <- gsub("_of_", "_Of_", fname) # DoDEA folder name
  write.csv(FINAL_LONG_Data[StateAbbreviation == abv], fname, row.names = FALSE) # , na="" --> Use for 2020???
  zip(zipfile=paste0(fname, ".zip"), files=fname, flags="-mqj") # -mq doesn't leave a csv copy. j "junks" the directory structure (tree)
  message("Finished with ", SGP:::getStateAbbreviation(abv, type="state"))
}

#   tmp.state <- SGP:::getStateAbbreviation(abv, type="state")
# 	fname <- paste0("PARCC_", abv, "_2018-2019_Spring_SGP-Results_", format(Sys.Date(), format="%Y%m%d"), ".csv")
#   setwd(paste0("./",  gsub(" ", "_", capwords(tmp.state, special.words="DC")), "/Data/Pearson"))
#   fwrite(FINAL_LONG_Data[StateAbbreviation == abv], fname) #, col.names = FALSE
#   zip(zipfile=paste0(fname, ".zip"), files=fname, flags="-mq") # -mq doesn't leave a csv copy.
#   setwd(tmp.wd)
# }
