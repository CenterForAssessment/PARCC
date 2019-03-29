################################################################################
###                                                                          ###
###         Format PARCC Fall 2018 Results Data to Return to Pearson         ###
###                                                                          ###
################################################################################

### Load required packages

require(SGP)
require(data.table)

###
###    Read in Fall 2018 Output Files
###

###  Set working directory to top level directory
load("./PARCC/Data/Archive/2018_2019.1/PARCC_SGP_LONG_Data_2018_2019.1.Rdata")

load("./Maryland/Data/Archive/2018_2019.1/Maryland_SGP_LONG_Data_2018_2019.1.Rdata")
load("./New_Jersey/Data/Archive/2018_2019.1/New_Jersey_SGP_LONG_Data_2018_2019.1.Rdata")
load("./New_Mexico/Data/Archive/2018_2019.1/New_Mexico_SGP_LONG_Data_2018_2019.1.Rdata")
load("./Bureau_Indian_Affairs/Data/Archive/2018_2019.1/Bureau_Indian_Affairs_SGP_LONG_Data_2018_2019.1.Rdata")

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

all.var.names <- c(parcc.var.names[1:11], center.var.names[1:4], parcc.var.names[12:13], center.var.names[-c(1:4)])

####  Combine states' data into single data table
State_LONG_Data <- rbindlist(list(
  Maryland_SGP_LONG_Data_2018_2019.1, New_Jersey_SGP_LONG_Data_2018_2019.1,
  New_Mexico_SGP_LONG_Data_2018_2019.1, Bureau_Indian_Affairs_SGP_LONG_Data_2018_2019.1), fill=TRUE)

####    Remove rows associated with the Scale Score SGP
State_LONG_Data <- State_LONG_Data[grep("_SS", CONTENT_AREA, invert =TRUE),]
PARCC_LONG_Data <- PARCC_SGP_LONG_Data_2018_2019.1[grep("_SS", CONTENT_AREA, invert =TRUE),]


#####
###    Format data to Pearson's specifications
#####

###         State Data

###  Combine SGP_NOTE and SGP variables
State_LONG_Data[, SGP := as.character(SGP)]
State_LONG_Data[which(is.na(SGP)), SGP := SGP_NOTE]

###  Change relevant SGP package convention names to Pearson's names
setnames(State_LONG_Data,
    	c("ID", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_CSEM_ACTUAL", "SCALE_SCORE", "SCALE_SCORE_CSEM",
        "SGP", "SGP_0.05_CONFIDENCE_BOUND", "SGP_0.95_CONFIDENCE_BOUND", "SGP_STANDARD_ERROR",
        "SGP_ORDER_1", "SGP_ORDER_1_0.05_CONFIDENCE_BOUND", "SGP_ORDER_1_0.95_CONFIDENCE_BOUND", "SGP_ORDER_1_STANDARD_ERROR",
    	  "SGP_ORDER_2", "SGP_ORDER_2_0.05_CONFIDENCE_BOUND", "SGP_ORDER_2_0.95_CONFIDENCE_BOUND", "SGP_ORDER_2_STANDARD_ERROR",
        "SGP_SIMEX_RANKED", "SGP_SIMEX_RANKED_ORDER_1", "SGP_SIMEX_RANKED_ORDER_2"),
        # "SGP_TARGET_3_YEAR", "SGP_TARGET_3_YEAR_CONTENT_AREA"),   "/Users/avi/Dropbox (SGP)/SGP/PARCC"
    	c("PARCCStudentIdentifier", "SummativeScaleScore", "SummativeCSEM", "IRTTheta", "ThetaSEM",
        "StudentGrowthPercentileComparedtoState", "SGPLowerBoundState", "SGPUpperBoundState", "SGPStandardErrorState",
        "StudentGrowthPercentileComparedtoState1Prior", "SGPLowerBoundState1Prior", "SGPUpperBoundState1Prior", "SGPStandardErrorState1Prior",
    	  "StudentGrowthPercentileComparedtoState2Prior", "SGPLowerBoundState2Prior", "SGPUpperBoundState2Prior", "SGPStandardErrorState2Prior",
        "SGPRankedSimexState", "SGPRankedSimexState1Prior", "SGPRankedSimexState2Prior"))#,
        # "SGPTargetState", "SGPTargetTestCodeState"))

###    Split SGP_NORM_GROUP to create 'SGPPreviousTestCode*' Variables
state.tmp.split <- strsplit(as.character(State_LONG_Data$SGP_NORM_GROUP), "; ")
State_LONG_Data[, CONTENT_AREA_1PRIOR := factor(sapply(sapply(strsplit(sapply(strsplit(sapply(state.tmp.split, function(x) rev(x)[2]), "/"), '[', 2), "_"), head, -1), paste, collapse="_"))]
State_LONG_Data[, CONTENT_AREA_2PRIOR := factor(sapply(sapply(strsplit(sapply(strsplit(sapply(state.tmp.split, function(x) rev(x)[3]), "/"), '[', 2), "_"), head, -1), paste, collapse="_"))]
levels(State_LONG_Data$CONTENT_AREA_1PRIOR) <- c(NA, "ALG01", "ALG02", "ELA", "GEO01", "MAT1I", "MAT2I", "MAT3I", "MAT") #XX#
levels(State_LONG_Data$CONTENT_AREA_2PRIOR) <- c(NA, "ALG01", "ELA", "MAT") #XX#
State_LONG_Data[, GRADE_1PRIOR := sapply(strsplit(sapply(strsplit(sapply(state.tmp.split, function(x) rev(x)[2]), "/"), '[', 2), "_"), tail, 1)]
State_LONG_Data[, GRADE_2PRIOR := sapply(strsplit(sapply(strsplit(sapply(state.tmp.split, function(x) rev(x)[3]), "/"), '[', 2), "_"), tail, 1)]
State_LONG_Data[which(GRADE_1PRIOR=="EOCT"), GRADE_1PRIOR := ""]   #XX#
State_LONG_Data[which(GRADE_2PRIOR=="EOCT"), GRADE_2PRIOR := ""]   #XX#
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

###  Re-order and subset columns of State_LONG_Data
State_LONG_Data <- State_LONG_Data[, names(State_LONG_Data)[names(State_LONG_Data) %in% head(all.var.names, -4)], with=FALSE]


###         PARCC Consortium Data

###  Combine SGP_NOTE and SGP variables
PARCC_LONG_Data[, SGP := as.character(SGP)]
PARCC_LONG_Data[which(is.na(SGP)), SGP := SGP_NOTE]

###  Change relevant SGP package convention names to Pearson's names
setnames(PARCC_LONG_Data,
    c("ID", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_CSEM_ACTUAL", "SCALE_SCORE", "SCALE_SCORE_CSEM",
      "SGP", "SGP_0.05_CONFIDENCE_BOUND", "SGP_0.95_CONFIDENCE_BOUND", "SGP_STANDARD_ERROR",
      "SGP_ORDER_1", "SGP_ORDER_1_0.05_CONFIDENCE_BOUND", "SGP_ORDER_1_0.95_CONFIDENCE_BOUND", "SGP_ORDER_1_STANDARD_ERROR",
      "SGP_ORDER_2", "SGP_ORDER_2_0.05_CONFIDENCE_BOUND", "SGP_ORDER_2_0.95_CONFIDENCE_BOUND", "SGP_ORDER_2_STANDARD_ERROR",
      "SGP_SIMEX_RANKED", "SGP_SIMEX_RANKED_ORDER_1", "SGP_SIMEX_RANKED_ORDER_2"),
      # "SGP_TARGET_3_YEAR", "SGP_TARGET_3_YEAR_CONTENT_AREA"),
    c("PARCCStudentIdentifier", "SummativeScaleScore", "SummativeCSEM", "IRTTheta", "ThetaSEM",
      "StudentGrowthPercentileComparedtoPARCC", "SGPLowerBoundPARCC", "SGPUpperBoundPARCC", "SGPStandardErrorPARCC",
      "StudentGrowthPercentileComparedtoPARCC1Prior", "SGPLowerBoundPARCC1Prior", "SGPUpperBoundPARCC1Prior", "SGPStandardErrorPARCC1Prior",
      "StudentGrowthPercentileComparedtoPARCC2Prior", "SGPLowerBoundPARCC2Prior", "SGPUpperBoundPARCC2Prior", "SGPStandardErrorPARCC2Prior",
      "SGPRankedSimexPARCC", "SGPRankedSimexPARCC1Prior", "SGPRankedSimexPARCC2Prior"))#,
      # "SGPTargetPARCC", "SGPTargetTestCodePARCC"))

### Split SGP_NORM_GROUP to create 'SGPPreviousTestCode*' Variables
PARCC.tmp.split <- strsplit(as.character(PARCC_LONG_Data$SGP_NORM_GROUP), "; ")

PARCC_LONG_Data[, CONTENT_AREA_1PRIOR := factor(sapply(sapply(strsplit(sapply(strsplit(sapply(PARCC.tmp.split, function(x) rev(x)[2]), "/"), '[', 2), "_"), head, -1), paste, collapse="_"))]
PARCC_LONG_Data[, CONTENT_AREA_2PRIOR := factor(sapply(sapply(strsplit(sapply(strsplit(sapply(PARCC.tmp.split, function(x) rev(x)[3]), "/"), '[', 2), "_"), head, -1), paste, collapse="_"))]
levels(PARCC_LONG_Data$CONTENT_AREA_1PRIOR) <- c(NA, "ALG01", "ALG02", "ELA", "GEO01", "MAT1I", "MAT2I", "MAT3I", "MAT")
levels(PARCC_LONG_Data$CONTENT_AREA_2PRIOR) <- c(NA, "ALG01", "ELA", "MAT")
PARCC_LONG_Data[, GRADE_1PRIOR := sapply(strsplit(sapply(strsplit(sapply(PARCC.tmp.split, function(x) rev(x)[2]), "/"), '[', 2), "_"), tail, 1)]
PARCC_LONG_Data[, GRADE_2PRIOR := sapply(strsplit(sapply(strsplit(sapply(PARCC.tmp.split, function(x) rev(x)[3]), "/"), '[', 2), "_"), tail, 1)]
PARCC_LONG_Data[which(GRADE_1PRIOR=="EOCT"), GRADE_1PRIOR := ""]  #XX#
PARCC_LONG_Data[which(GRADE_2PRIOR=="EOCT"), GRADE_2PRIOR := ""]  #XX#
PARCC_LONG_Data[which(GRADE_1PRIOR %in% 3:9), GRADE_1PRIOR := paste0("0", GRADE_1PRIOR)]  #XX#
PARCC_LONG_Data[which(GRADE_2PRIOR %in% 3:9), GRADE_2PRIOR := paste0("0", GRADE_2PRIOR)]  #XX#
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

###  Re-order columns of PARCC_LONG_Data
PARCC_LONG_Data <- PARCC_LONG_Data[, names(PARCC_LONG_Data)[names(PARCC_LONG_Data) %in% head(all.var.names, -4)], with=FALSE]

###
###       Merge PARCC and State Data
###

FINAL_LONG_Data <- merge(PARCC_LONG_Data, State_LONG_Data, by=intersect(names(PARCC_LONG_Data), names(State_LONG_Data)), all.x=TRUE)
FINAL_LONG_Data[, c("SGPTargetState", "SGPTargetPARCC", "SGPTargetTestCodeState", "SGPTargetTestCodePARCC") := "NA"]

###  Coordinate missing SGP notes for small N states and set remaining missings as character "NA" (currently logical NA)
FINAL_LONG_Data[which(is.na(StudentGrowthPercentileComparedtoState) & StudentGrowthPercentileComparedtoPARCC == "<1000"), SGPPreviousTestCodeState := SGPPreviousTestCodePARCC]
FINAL_LONG_Data[which(is.na(StudentGrowthPercentileComparedtoState) & StudentGrowthPercentileComparedtoPARCC == "<1000"), StudentGrowthPercentileComparedtoState := "<1000"]
table(FINAL_LONG_Data[StudentGrowthPercentileComparedtoPARCC == "<1000", StudentGrowthPercentileComparedtoState], exclude=NULL) # 2766 None NA/NULL
table(FINAL_LONG_Data[StudentGrowthPercentileComparedtoState == "<1000", is.na(StudentGrowthPercentileComparedtoPARCC)], exclude=NULL)
summary(as.numeric(FINAL_LONG_Data[StudentGrowthPercentileComparedtoState == "<1000", StudentGrowthPercentileComparedtoPARCC]))

# table(FINAL_LONG_Data[TestCode=="ALG02", SGPPreviousTestCodeState!="", SGPPreviousTestCodePARCC!=""])
# table(FINAL_LONG_Data[SGPPreviousTestCodeState=="" & SGPPreviousTestCodePARCC!="", SGPPreviousTestCodePARCC, TestCode])
# table(FINAL_LONG_Data[SGPPreviousTestCodeState1Prior=="" & SGPPreviousTestCodePARCC1Prior!="", SGPPreviousTestCodePARCC, TestCode])
table(FINAL_LONG_Data[TestCode=="ALG02", StateAbbreviation, SGPPreviousTestCodeState])
# FINAL_LONG_Data[which(SGPPreviousTestCodeState1Prior=="" & SGPPreviousTestCodePARCC1Prior!=""), SGPPreviousTestCodeState1Prior := SGPPreviousTestCodePARCC1Prior]
# FINAL_LONG_Data[which(SGPPreviousTestCodeState=="" & SGPPreviousTestCodePARCC!=""), SGPPreviousTestCodeState := SGPPreviousTestCodePARCC]
# table(FINAL_LONG_Data[TestCode=="ALG02", StateAbbreviation, SGPPreviousTestCodeState])
table(FINAL_LONG_Data[TestCode=="ELA11", StateAbbreviation, SGPPreviousTestCodeState])

FINAL_LONG_Data[which(is.na(StudentGrowthPercentileComparedtoState)), StudentGrowthPercentileComparedtoState := "NA"]
FINAL_LONG_Data[which(is.na(StudentGrowthPercentileComparedtoPARCC)), StudentGrowthPercentileComparedtoPARCC := "NA"]

###  Make sure no exact duplicates remain.
setkey(FINAL_LONG_Data, PARCCStudentIdentifier, StudentTestUUID, TestCode, SummativeScaleScore)
setkey(FINAL_LONG_Data, PARCCStudentIdentifier, StudentTestUUID, TestCode)
table(duplicated(FINAL_LONG_Data, by=key(FINAL_LONG_Data))) # Should be FALSE
findups <- FINAL_LONG_Data[c(which(duplicated(FINAL_LONG_Data, by=key(FINAL_LONG_Data)))-1, which(duplicated(FINAL_LONG_Data, by=key(FINAL_LONG_Data)))),]
dim(findups) # Should be 0 rows!

setcolorder(FINAL_LONG_Data, all.var.names)

# FINAL_LONG_Data[, as.list(summary(as.numeric(StudentGrowthPercentileComparedtoPARCC))), keyby="TestCode"]
# FINAL_LONG_Data[, list(cor(as.numeric(StudentGrowthPercentileComparedtoPARCC), as.numeric(StudentGrowthPercentileComparedtoState), use="complete")), keyby="TestCode"]
# FINAL_LONG_Data[, list(cor(as.numeric(StudentGrowthPercentileComparedtoPARCC1Prior), as.numeric(StudentGrowthPercentileComparedtoState1Prior), use="complete")), keyby="TestCode"]
# FINAL_LONG_Data[!is.na(as.numeric(StudentGrowthPercentileComparedtoPARCC2Prior)), list(cor(as.numeric(StudentGrowthPercentileComparedtoPARCC1Prior), as.numeric(StudentGrowthPercentileComparedtoPARCC2Prior), use="complete")), keyby="TestCode"]
#
# x1 <- FINAL_LONG_Data[!is.na(as.numeric(StudentGrowthPercentileComparedtoPARCC1Prior))]
# x1[, Diff := as.numeric(StudentGrowthPercentileComparedtoPARCC1Prior) - as.numeric(StudentGrowthPercentileComparedtoPARCC2Prior)]
# x1[, as.list(summary(Diff)), keyby="TestCode"]
# x1[is.na(as.numeric(StudentGrowthPercentileComparedtoPARCC2Prior)), as.list(summary(StudentGrowthPercentileComparedtoPARCC1Prior)), keyby=c("TestCode", "SGPPreviousTestCodeState1Prior")]
# x1[is.na(as.numeric(StudentGrowthPercentileComparedtoPARCC2Prior)), as.list(summary(StudentGrowthPercentileComparedtoPARCC1Prior)), keyby=c("TestCode", "SGPPreviousTestCodeState1Prior", "StateAbbreviation")]
# table(x1[is.na(as.numeric(StudentGrowthPercentileComparedtoPARCC2Prior)) & TestCode == "ALG01", StateAbbreviation, SGPPreviousTestCodeState1Prior])
# x1[TestCode != "ALG02", as.list(cor(Diff, SGPIRTThetaPARCC1Prior, use="complete")), keyby="TestCode"]
# x1[TestCode != "ALG02", as.list(cor(Diff, SGPIRTThetaPARCC2Prior, use="complete")), keyby="TestCode"]
#
# table(FINAL_LONG_Data[, is.na(as.numeric(StudentGrowthPercentileComparedtoPARCC1Prior)), is.na(as.numeric(StudentGrowthPercentileComparedtoPARCC2Prior))])

###
###  Save R object and Export/zip State specific .csv files
###

save(FINAL_LONG_Data, file="./PARCC/Data/Pearson/PARCC_SGP_LONG_Data_2018_2019.1-FORMATTED.Rdata")

####  Loop on State Abbreviation to write out each state file in format that it was recieved and return requested
tmp.wd <- getwd()
for (abv in sort(unique(FINAL_LONG_Data$StateAbbreviation))) {
  tmp.state <- SGP:::getStateAbbreviation(abv, type="state")
	fname <- paste0("PARCC_", abv, "_2018-2019_Fall_SGP-Results_", format(Sys.Date(), format="%Y%m%d"), ".csv")
  setwd(paste0("./",  gsub(" ", "_", capwords(tmp.state, special.words="DC")), "/Data/Pearson"))
  fwrite(FINAL_LONG_Data[StateAbbreviation == abv], fname) #, col.names = FALSE
  zip(zipfile=paste0(fname, ".zip"), files=fname, flags="-mq") # -mq doesn't leave a csv copy.
  setwd(tmp.wd)
}
