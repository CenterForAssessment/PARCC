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

load("./PARCC/Data/Archive/2020_2021.2/PARCC_SGP_LONG_Data_2020_2021.2.Rdata")

load("./Illinois/Data/Archive/2020_2021.2/Illinois_SGP_LONG_Data_2020_2021.2.Rdata")
load("./Bureau_of_Indian_Education/Data/Archive/2020_2021.2/Bureau_of_Indian_Education_SGP_LONG_Data_2020_2021.2.Rdata")
load("./Department_Of_Defense/Data/Archive/2020_2021.2/Department_of_Defense_SGP_LONG_Data_2020_2021.2.Rdata")


###  Amend State Files as needed

#    Illinois only has percentiles/projections through grade 8 so no EOCT projection groups / need for SGP_TARGET_3_YEAR_CONTENT_AREA in combineSGP.
#    In 2021 we could only run BASELINE projections.  Fill in the SGP_TARGET_3_YEAR_CONTENT_AREA for reference to the BASELINE projections (no SGPTargetTestCode* Baseline)
Illinois_SGP_LONG_Data_2020_2021.2[, SGP_TARGET_3_YEAR_CONTENT_AREA := as.character(NA)]
Illinois_SGP_LONG_Data_2020_2021.2[!is.na(SGP_TARGET_BASELINE_3_YEAR), SGP_TARGET_3_YEAR_CONTENT_AREA := CONTENT_AREA]

PARCC_SGP_LONG_Data_2020_2021.2[, SGP_TARGET_3_YEAR_CONTENT_AREA := as.character(NA)]
PARCC_SGP_LONG_Data_2020_2021.2[!is.na(SGP_TARGET_BASELINE_3_YEAR), SGP_TARGET_3_YEAR_CONTENT_AREA := CONTENT_AREA]


####  Set names based on Pearson file layout
parcc.var.names <- c(
    "AssessmentYear", "StateAbbreviation", "PANUniqueStudentID", "GradeLevelWhenAssessed",
    "Period", "TestCode", "TestFormat", "SummativeScoreRecordUUID", "StudentTestUUID",
    "SummativeScaleScore", "IRTTheta", "SummativeCSEM", "ThetaSEM", "FormID",
    "TestingLocation", "LearningOption", "StateStudentIdentifier", "LocalStudentIdentifier",
    "TestingDistrictCode", "TestingDistrictName", "TestingSchoolCode", "TestingSchoolName",
    "AccountableDistrictCode", "AccountableDistrictName", "AccountableSchoolCode",
    "AccountableSchoolName", "Sex", "HispanicOrLatinoEthnicity", "AmericanIndianOrAlaskaNative",
    "Asian", "BlackOrAfricanAmerican", "NativeHawaiianOrOtherPacificIslander",
    "White", "FederalRaceEthnicity", "TwoOrMoreRaces", "EnglishLearnerEL", "MigrantStatus",
    "GiftedAndTalented", "EconomicDisadvantageStatus", "StudentWithDisabilities")

center.var.names <- c(
    "SGPIRTThetaState1Prior", "SGPIRTThetaState2Prior", "SGPIRTThetaPARCC1Prior",
    "SGPIRTThetaPARCC2Prior", "StudentGrowthPercentileComparedtoState",
    "StudentGrowthPercentileComparedtoState1Prior", "StudentGrowthPercentileComparedtoState2Prior",
    "StudentGrowthPercentileComparedtoPARCC", "StudentGrowthPercentileComparedtoPARCC1Prior",
    "StudentGrowthPercentileComparedtoPARCC2Prior", "SGPPreviousTestCodeState",
    "SGPPreviousTestCodeState1Prior", "SGPPreviousTestCodeState2Prior", "SGPPreviousTestCodePARCC",
    "SGPPreviousTestCodePARCC1Prior", "SGPPreviousTestCodePARCC2Prior", "SGPUpperBoundState",
    "SGPUpperBoundState1Prior", "SGPUpperBoundState2Prior", "SGPLowerBoundState",
    "SGPLowerBoundState1Prior", "SGPLowerBoundState2Prior", "SGPUpperBoundPARCC",
    "SGPUpperBoundPARCC1Prior", "SGPUpperBoundPARCC2Prior", "SGPLowerBoundPARCC",
    "SGPLowerBoundPARCC1Prior", "SGPLowerBoundPARCC2Prior", "SGPStandardErrorState",
    "SGPStandardErrorState1Prior", "SGPStandardErrorState2Prior", "SGPStandardErrorPARCC",
    "SGPStandardErrorPARCC1Prior", "SGPStandardErrorPARCC2Prior", "SGPRankedSimexState",
    "SGPRankedSimexState1Prior", "SGPRankedSimexState2Prior", "SGPRankedSimexPARCC",
    "SGPRankedSimexPARCC1Prior", "SGPRankedSimexPARCC2Prior", "SGPTargetState",
    "SGPTargetPARCC", "SGPTargetTestCodeState", "SGPTargetTestCodePARCC",
    "StudentGrowthPercentileComparedtoStateBaseline", "SGPRankedSimexStateBaseline",
    "SGPTargetStateBaseline", "StudentGrowthPercentileComparedtoPARCCBaseline",
    "SGPRankedSimexPARCCBaseline", "SGPTargetPARCCBaseline")

all.var.names <- c(parcc.var.names[1:11], center.var.names[1:4], parcc.var.names[12:13], center.var.names[5:44], # Old order
                   parcc.var.names[14], center.var.names[45:50], parcc.var.names[15:40], "EXACT_DUPLICATE")  #  Added in 2021 for Center and Pearson

##  Two additional variables for BIE & DoDEA
addl.bie.dd.names <- c("customerReferenceId", "testAdminReferenceId")
all.var.names <- c(all.var.names, addl.bie.dd.names)
parcc.var.names <- c(parcc.var.names, addl.bie.dd.names)

###   Combine states' data into single data table
State_LONG_Data <- rbindlist(list(
                              Bureau_of_Indian_Education_SGP_LONG_Data_2020_2021.2,
                              Department_of_Defense_SGP_LONG_Data_2020_2021.2,
                              Illinois_SGP_LONG_Data_2020_2021.2), fill=TRUE, use.names=TRUE)

###   For individual state data formatting
# State_LONG_Data <- copy(Illinois_SGP_LONG_Data_2020_2021.2)
# PARCC_LONG_Data <- PARCC_SGP_LONG_Data_2020_2021.2[StateAbbreviation == "IL"]

assign("PARCC_LONG_Data", PARCC_SGP_LONG_Data_2020_2021.2); rm(PARCC_SGP_LONG_Data_2020_2021.2)


#####
###    Format data to Pearson's specifications
#####

###         State Data

###   Combine SGP_NOTE and SGP variables
##    'NA' or <1000 per Pearson 2021 Growth File Layout v1
#    table(State_LONG_Data[, is.na(SGP), SGP_NOTE], exclude=NULL)
State_LONG_Data[, SGP := as.character(SGP)]
State_LONG_Data[is.na(SGP), SGP := SGP_NOTE]

State_LONG_Data[, SGP_BASELINE := as.character(SGP_BASELINE)]
State_LONG_Data[is.na(SGP_BASELINE), SGP_BASELINE := SGP_NOTE] # No BASELINE specific NOTE.  Make sure its only replacing NAs!

###   Now remove NOTE - Kathy/Pat 8/14/19 -- Just kidding :/
###   JK re JK. LOL. -- 8/18/2021 Kathy.  SMH FML IHTG
State_LONG_Data[, SGP_NORM_GROUP := as.character(SGP_NORM_GROUP)]
State_LONG_Data[!is.na(SGP_NOTE), SGP_NORM_GROUP := ""]

State_LONG_Data[, SGP_NORM_GROUP_BASELINE := as.character(SGP_NORM_GROUP_BASELINE)]
State_LONG_Data[!is.na(SGP_NOTE), SGP_NORM_GROUP_BASELINE := ""]

##  BASELINEs don't rename "SGP_0.**_CONFIDENCE_BOUND" with "_BASELINE" tag - Not an issue for State - see PARCC Below though...
# State_LONG_Data[!is.na(SGP_NOTE), as.list(summary(SGP_0.05_CONFIDENCE_BOUND)), keyby="TestCode"]


###  Change relevant SGP package convention names to Pearson's names
sgp.names <- c(
  "ID", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_CSEM_ACTUAL", "SCALE_SCORE", "SCALE_SCORE_CSEM",
  "SGP", "SGP_0.05_CONFIDENCE_BOUND", "SGP_0.95_CONFIDENCE_BOUND", "SGP_STANDARD_ERROR",
  "SGP_ORDER_1", "SGP_ORDER_1_0.05_CONFIDENCE_BOUND", "SGP_ORDER_1_0.95_CONFIDENCE_BOUND", "SGP_ORDER_1_STANDARD_ERROR",
  "SGP_ORDER_2", "SGP_ORDER_2_0.05_CONFIDENCE_BOUND", "SGP_ORDER_2_0.95_CONFIDENCE_BOUND", "SGP_ORDER_2_STANDARD_ERROR",
  "SGP_SIMEX_RANKED", "SGP_SIMEX_RANKED_ORDER_1", "SGP_SIMEX_RANKED_ORDER_2",
  "SGP_TARGET_3_YEAR", "SGP_TARGET_3_YEAR_CONTENT_AREA",
  "SGP_BASELINE", "SGP_SIMEX_BASELINE", "SGP_TARGET_BASELINE_3_YEAR")

setnames(State_LONG_Data,
    	sgp.names[sgp.names  %in% names(State_LONG_Data)],
    	c("PANUniqueStudentID", "SummativeScaleScore", "SummativeCSEM", "IRTTheta", "ThetaSEM",
        "StudentGrowthPercentileComparedtoState", "SGPLowerBoundState", "SGPUpperBoundState", "SGPStandardErrorState",
        "StudentGrowthPercentileComparedtoState1Prior", "SGPLowerBoundState1Prior", "SGPUpperBoundState1Prior", "SGPStandardErrorState1Prior",
    	  "StudentGrowthPercentileComparedtoState2Prior", "SGPLowerBoundState2Prior", "SGPUpperBoundState2Prior", "SGPStandardErrorState2Prior",
        "SGPRankedSimexState", "SGPRankedSimexState1Prior", "SGPRankedSimexState2Prior",
        "SGPTargetState", "SGPTargetTestCodeState",
        "StudentGrowthPercentileComparedtoStateBaseline", "SGPRankedSimexStateBaseline","SGPTargetStateBaseline")[sgp.names %in% names(State_LONG_Data)])

###    Split SGP_NORM_GROUP to create 'SGPPreviousTestCode*' Variables
state.tmp.split <- strsplit(as.character(State_LONG_Data$SGP_NORM_GROUP), "; ")
State_LONG_Data[, CONTENT_AREA_1PRIOR := factor(sapply(sapply(strsplit(sapply(strsplit(sapply(state.tmp.split, function(x) rev(x)[2]), "/"), '[', 2), "_"), head, -1), paste, collapse="_"))]
State_LONG_Data[, CONTENT_AREA_2PRIOR := factor(sapply(sapply(strsplit(sapply(strsplit(sapply(state.tmp.split, function(x) rev(x)[3]), "/"), '[', 2), "_"), head, -1), paste, collapse="_"))]

##   Check!
# levels(State_LONG_Data$CONTENT_AREA_1PRIOR) <- c(NA, "ALG01", "ALG02", "ELA", "GEO01", "MAT1I", "MAT2I", "MAT")
setattr(State_LONG_Data$CONTENT_AREA_1PRIOR, "levels", c(NA, "ALG01", "ELA", "MAT"))
setattr(State_LONG_Data$CONTENT_AREA_2PRIOR, "levels", c(NA, "ELA", "MAT"))
# levels(State_LONG_Data$CONTENT_AREA_2PRIOR) <- c(NA, "ALG01", "ELA", "MAT")
State_LONG_Data[, GRADE_1PRIOR := sapply(strsplit(sapply(strsplit(sapply(state.tmp.split, function(x) rev(x)[2]), "/"), '[', 2), "_"), tail, 1)]
State_LONG_Data[, GRADE_2PRIOR := sapply(strsplit(sapply(strsplit(sapply(state.tmp.split, function(x) rev(x)[3]), "/"), '[', 2), "_"), tail, 1)]
State_LONG_Data[GRADE_1PRIOR=="EOCT", GRADE_1PRIOR := ""]#XX#
State_LONG_Data[GRADE_2PRIOR=="EOCT", GRADE_2PRIOR := ""]#XX#
State_LONG_Data[GRADE_1PRIOR %in% 3:9, GRADE_1PRIOR := paste0("0", GRADE_1PRIOR)] #XX#
State_LONG_Data[GRADE_2PRIOR %in% 3:9, GRADE_2PRIOR := paste0("0", GRADE_2PRIOR)] #XX#
State_LONG_Data[, SGPPreviousTestCodeState := factor(paste0(CONTENT_AREA_2PRIOR, GRADE_2PRIOR, ";", CONTENT_AREA_1PRIOR, GRADE_1PRIOR))]
State_LONG_Data[, SGPPreviousTestCodeState := gsub("NANA;|NANA$", "", SGPPreviousTestCodeState)]
State_LONG_Data[, SGPPreviousTestCodeState1Prior := factor(paste0(CONTENT_AREA_1PRIOR, GRADE_1PRIOR))]
State_LONG_Data[, SGPPreviousTestCodeState2Prior := factor(paste0(CONTENT_AREA_2PRIOR, GRADE_2PRIOR))]
State_LONG_Data[, SGPPreviousTestCodeState1Prior := gsub("NANA", "", SGPPreviousTestCodeState1Prior)]
State_LONG_Data[, SGPPreviousTestCodeState2Prior := gsub("NANA", "", SGPPreviousTestCodeState2Prior)]
# table(State_LONG_Data[, SGPPreviousTestCodeState1Prior, SGPPreviousTestCodeState])

###    Split SGP_NORM_GROUP_SCALE_SCORES to create 'SGPIRTThetaState*' Variables
State.score.split <- strsplit(as.character(State_LONG_Data$SGP_NORM_GROUP_SCALE_SCORES), "; ")
State_LONG_Data[, SGPIRTThetaState1Prior := as.numeric(sapply(State.score.split, function(x) rev(x)[2]))]
State_LONG_Data[, SGPIRTThetaState2Prior := as.numeric(sapply(State.score.split, function(x) rev(x)[3]))]

###    Compute and Format SGPTargetTestCodeState
State_LONG_Data[, SGPTargetTestCodeState := factor(SGPTargetTestCodeState)]
# levels(State_LONG_Data$SGPTargetTestCodeState) <- c("ALG01", "ALG02", "ELA", "GEO01", "MAT") # "MAT1I",
setattr(State_LONG_Data$SGPTargetTestCodeState, "levels", c("ELA", "MAT"))
State_LONG_Data[, SGPTargetTestCodeState := as.character(SGPTargetTestCodeState)]
State_LONG_Data[SGPTargetTestCodeState %in% c("ELA", "MAT"), SGPTargetTestCodeState := paste0(SGPTargetTestCodeState, "0", as.numeric(GRADE)+3)]
# State_LONG_Data[, SGPTargetTestCodeState := gsub("09|010|011|013", "08", SGPTargetTestCodeState)] # Illinois/Washington_DC
State_LONG_Data[, SGPTargetTestCodeState := gsub("010", "10", SGPTargetTestCodeState)]
State_LONG_Data[, SGPTargetTestCodeState := gsub("011|012|013|014", "11", SGPTargetTestCodeState)]
##    Illinois only goes to grade 8 & Only Illinois has state targets in 2021...
State_LONG_Data[StateAbbreviation == "IL", SGPTargetTestCodeState := gsub("MAT09|MAT10|MAT11", "MAT08", SGPTargetTestCodeState)]
# State_LONG_Data[StateAbbreviation != "IL", SGPTargetTestCodeState := gsub("MAT09", "ALG01", SGPTargetTestCodeState)]
# State_LONG_Data[StateAbbreviation != "IL", SGPTargetTestCodeState := gsub("MAT10", "GEO01", SGPTargetTestCodeState)]
# State_LONG_Data[StateAbbreviation != "IL", SGPTargetTestCodeState := gsub("MAT11", "ALG02", SGPTargetTestCodeState)]
##  Do this for Illinois too!
State_LONG_Data[StateAbbreviation == "IL", SGPTargetTestCodeState := gsub("ELA09|ELA10|ELA11", "ELA08", SGPTargetTestCodeState)]

table(State_LONG_Data[, SGPTargetTestCodeState, TestCode])
table(State_LONG_Data[, SGPTargetTestCodeState, StateAbbreviation]) # Only IL had (state) projections in 2021

####   For individual state data formatting
# State_LONG_Data[, grep("PARCC", center.var.names, value=TRUE) := NA]
# State_LONG_Data[, center.var.names[!center.var.names %in% names(State_LONG_Data)] := NA] # None for IL in 2021
####   For individual state data formatting


###  Re-order and SUBSET columns of State_LONG_Data
State_LONG_Data <- State_LONG_Data[, names(State_LONG_Data)[names(State_LONG_Data) %in% all.var.names], with=FALSE]


####   SKIP THIS STEP For individual state data formatting
###         PARCC Consortium Data

###  Combine SGP_NOTE and SGP variables
PARCC_LONG_Data[, SGP := as.character(SGP)]
PARCC_LONG_Data[which(is.na(SGP)), SGP := SGP_NOTE]

# table(PARCC_LONG_Data[, is.na(SGP_BASELINE), SGP_NOTE], exclude=NULL)
PARCC_LONG_Data[, SGP_BASELINE := as.character(SGP_BASELINE)]
PARCC_LONG_Data[is.na(SGP_BASELINE), SGP_BASELINE := SGP_NOTE] # No BASELINE specific NOTE.  Make sure its only replacing NAs!

###   Now remove NOTE - Kathy/Pat 8/14/19 -- Just kidding :/
###   JK re JK. LOL. -- 8/18/2021 Kathy.  SMH FML IHTG
PARCC_LONG_Data[, SGP_NORM_GROUP := as.character(SGP_NORM_GROUP)]
PARCC_LONG_Data[!is.na(SGP_NOTE), SGP_NORM_GROUP := ""]

PARCC_LONG_Data[, SGP_NORM_GROUP_BASELINE := as.character(SGP_NORM_GROUP_BASELINE)]
PARCC_LONG_Data[!is.na(SGP_NOTE), SGP_NORM_GROUP_BASELINE := ""]

##  BASELINEs don't rename "SGP_0.**_CONFIDENCE_BOUND" with "_BASELINE" tag.
##  The "ORDER" versions DO get renamed -- "SGP_BASELINE_ORDER_*_0.**_CONFIDENCE_BOUND"
# PARCC_LONG_Data[!is.na(SGP_NOTE), as.list(summary(SGP_0.05_CONFIDENCE_BOUND)), keyby="TestCode"]
PARCC_LONG_Data[!is.na(SGP_NOTE), SGP_0.05_CONFIDENCE_BOUND := NA]
PARCC_LONG_Data[!is.na(SGP_NOTE), SGP_0.95_CONFIDENCE_BOUND := NA]

###  Change relevant SGP package convention names to Pearson's names
setnames(PARCC_LONG_Data,
    c("ID", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_CSEM_ACTUAL", "SCALE_SCORE", "SCALE_SCORE_CSEM",
      "SGP", "SGP_0.05_CONFIDENCE_BOUND", "SGP_0.95_CONFIDENCE_BOUND", "SGP_STANDARD_ERROR",
      "SGP_ORDER_1", "SGP_ORDER_1_0.05_CONFIDENCE_BOUND", "SGP_ORDER_1_0.95_CONFIDENCE_BOUND", "SGP_ORDER_1_STANDARD_ERROR",
      "SGP_ORDER_2", "SGP_ORDER_2_0.05_CONFIDENCE_BOUND", "SGP_ORDER_2_0.95_CONFIDENCE_BOUND", "SGP_ORDER_2_STANDARD_ERROR",
      "SGP_SIMEX_RANKED", "SGP_SIMEX_RANKED_ORDER_1", "SGP_SIMEX_RANKED_ORDER_2",
      "SGP_TARGET_3_YEAR", "SGP_TARGET_3_YEAR_CONTENT_AREA",
      "SGP_BASELINE", "SGP_SIMEX_BASELINE", "SGP_TARGET_BASELINE_3_YEAR"),
    c("PANUniqueStudentID", "SummativeScaleScore", "SummativeCSEM", "IRTTheta", "ThetaSEM",
      "StudentGrowthPercentileComparedtoPARCC", "SGPLowerBoundPARCC", "SGPUpperBoundPARCC", "SGPStandardErrorPARCC",
      "StudentGrowthPercentileComparedtoPARCC1Prior", "SGPLowerBoundPARCC1Prior", "SGPUpperBoundPARCC1Prior", "SGPStandardErrorPARCC1Prior",
      "StudentGrowthPercentileComparedtoPARCC2Prior", "SGPLowerBoundPARCC2Prior", "SGPUpperBoundPARCC2Prior", "SGPStandardErrorPARCC2Prior",
      "SGPRankedSimexPARCC", "SGPRankedSimexPARCC1Prior", "SGPRankedSimexPARCC2Prior",
      "SGPTargetPARCC", "SGPTargetTestCodePARCC",
      "StudentGrowthPercentileComparedtoPARCCBaseline", "SGPRankedSimexPARCCBaseline", "SGPTargetPARCCBaseline"))

### Split SGP_NORM_GROUP to create 'SGPPreviousTestCode*' Variables
PARCC.tmp.split <- strsplit(as.character(PARCC_LONG_Data$SGP_NORM_GROUP), "; ")

PARCC_LONG_Data[, CONTENT_AREA_1PRIOR := factor(sapply(sapply(strsplit(sapply(strsplit(sapply(PARCC.tmp.split, function(x) rev(x)[2]), "/"), '[', 2), "_"), head, -1), paste, collapse="_"))]
PARCC_LONG_Data[, CONTENT_AREA_2PRIOR := factor(sapply(sapply(strsplit(sapply(strsplit(sapply(PARCC.tmp.split, function(x) rev(x)[3]), "/"), '[', 2), "_"), head, -1), paste, collapse="_"))]
setattr(PARCC_LONG_Data$CONTENT_AREA_1PRIOR, "levels", c(NA, "ALG01", "ELA", "MAT"))
setattr(PARCC_LONG_Data$CONTENT_AREA_2PRIOR, "levels", c(NA, "ELA", "MAT"))
PARCC_LONG_Data[, GRADE_1PRIOR := sapply(strsplit(sapply(strsplit(sapply(PARCC.tmp.split, function(x) rev(x)[2]), "/"), '[', 2), "_"), tail, 1)]
PARCC_LONG_Data[, GRADE_2PRIOR := sapply(strsplit(sapply(strsplit(sapply(PARCC.tmp.split, function(x) rev(x)[3]), "/"), '[', 2), "_"), tail, 1)]
PARCC_LONG_Data[GRADE_1PRIOR=="EOCT", GRADE_1PRIOR := ""]#XX#
PARCC_LONG_Data[GRADE_2PRIOR=="EOCT", GRADE_2PRIOR := ""]#XX# table(PARCC_LONG_Data[, GRADE_1PRIOR, CONTENT_AREA_1PRIOR])
PARCC_LONG_Data[GRADE_1PRIOR %in% 3:9, GRADE_1PRIOR := paste0("0", GRADE_1PRIOR)] #XX#
PARCC_LONG_Data[GRADE_2PRIOR %in% 3:9, GRADE_2PRIOR := paste0("0", GRADE_2PRIOR)] #XX#
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
setattr(PARCC_LONG_Data$SGPTargetTestCodePARCC, "levels", c("ALG02", "ELA", "MAT")) # "ALG01", "GEO01", - no students w/ "CANONICAL" progressions # No INTEGRATED_MATH_* as of 2019
PARCC_LONG_Data[, SGPTargetTestCodePARCC := as.character(SGPTargetTestCodePARCC)]
PARCC_LONG_Data[SGPTargetTestCodePARCC %in% c("ELA", "MAT"), SGPTargetTestCodePARCC := paste0(SGPTargetTestCodePARCC, "0", as.numeric(GRADE)+3)]
PARCC_LONG_Data[, SGPTargetTestCodePARCC := gsub("010", "10", SGPTargetTestCodePARCC)]
PARCC_LONG_Data[, SGPTargetTestCodePARCC := gsub("011|012|013|014", "11", SGPTargetTestCodePARCC)]
PARCC_LONG_Data[, SGPTargetTestCodePARCC := gsub("MAT09", "ALG01", SGPTargetTestCodePARCC)]
PARCC_LONG_Data[, SGPTargetTestCodePARCC := gsub("MAT10", "GEO01", SGPTargetTestCodePARCC)]
PARCC_LONG_Data[, SGPTargetTestCodePARCC := gsub("MAT11", "ALG02", SGPTargetTestCodePARCC)]
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
# FINAL_LONG_Data <- copy(State_LONG_Data)

###  Fix EXACT_DUPLICATEs  (None in Spring 2019, 2021)
FINAL_LONG_Data[EXACT_DUPLICATE==2, (center.var.names) := FINAL_LONG_Data[EXACT_DUPLICATE==1, center.var.names, with=FALSE]]
FINAL_LONG_Data[, EXACT_DUPLICATE := NULL]

###   Coordinate missing SGP notes for small N states
###   Now remove NOTE - Kathy/Pat 8/14/19 -- Just kidding :/
# FINAL_LONG_Data[which(is.na(StudentGrowthPercentileComparedtoState) & StudentGrowthPercentileComparedtoPARCC == "<1000"), SGPPreviousTestCodeState := SGPPreviousTestCodePARCC]
# FINAL_LONG_Data[which(is.na(StudentGrowthPercentileComparedtoState) & StudentGrowthPercentileComparedtoPARCC == "<1000"), StudentGrowthPercentileComparedtoState := "<1000"]

#  Return NA values blank for 2021? - emailed K. Brown 7/9/2021
FINAL_LONG_Data[which(is.na(StudentGrowthPercentileComparedtoState)), StudentGrowthPercentileComparedtoState := "NA"]
FINAL_LONG_Data[which(is.na(StudentGrowthPercentileComparedtoStateBaseline)), StudentGrowthPercentileComparedtoStateBaseline := "NA"]
FINAL_LONG_Data[which(is.na(StudentGrowthPercentileComparedtoPARCC)), StudentGrowthPercentileComparedtoPARCC := "NA"]
FINAL_LONG_Data[which(is.na(StudentGrowthPercentileComparedtoPARCCBaseline)), StudentGrowthPercentileComparedtoPARCCBaseline := "NA"]

###   These can be blank (or 'NA') just don't confuse them and send one and then the other the next time... Per Zoom 8/20/21
# FINAL_LONG_Data[, StudentGrowthPercentileComparedtoState1Prior := as.character(StudentGrowthPercentileComparedtoState1Prior)]
# FINAL_LONG_Data[which(is.na(StudentGrowthPercentileComparedtoState1Prior)), StudentGrowthPercentileComparedtoState1Prior := "NA"]
# FINAL_LONG_Data[, StudentGrowthPercentileComparedtoState2Prior := as.character(StudentGrowthPercentileComparedtoState2Prior)]
# FINAL_LONG_Data[which(is.na(StudentGrowthPercentileComparedtoState2Prior)), StudentGrowthPercentileComparedtoState2Prior := "NA"]
# FINAL_LONG_Data[, StudentGrowthPercentileComparedtoPARCC1Prior := as.character(StudentGrowthPercentileComparedtoPARCC1Prior)]
# FINAL_LONG_Data[which(is.na(StudentGrowthPercentileComparedtoPARCC1Prior)), StudentGrowthPercentileComparedtoPARCC1Prior := "NA"]
# FINAL_LONG_Data[, StudentGrowthPercentileComparedtoPARCC2Prior := as.character(StudentGrowthPercentileComparedtoPARCC2Prior)]
# FINAL_LONG_Data[which(is.na(StudentGrowthPercentileComparedtoPARCC2Prior)), StudentGrowthPercentileComparedtoPARCC2Prior := "NA"]


###  Make sure no exact duplicates remain.
setkey(FINAL_LONG_Data, PANUniqueStudentID, StudentTestUUID, TestCode, SummativeScaleScore)
setkey(FINAL_LONG_Data, PANUniqueStudentID, StudentTestUUID, TestCode)
table(duplicated(FINAL_LONG_Data, by=key(FINAL_LONG_Data))) # Should be FALSE
findups <- FINAL_LONG_Data[c(which(duplicated(FINAL_LONG_Data, by=key(FINAL_LONG_Data)))-1, which(duplicated(FINAL_LONG_Data, by=key(FINAL_LONG_Data)))),]
nrow(findups) # Should be 0 rows!

setcolorder(FINAL_LONG_Data, all.var.names[-91]) # everything except which(all.var.names == "EXACT_DUPLICATE")


###  Format IRTTheta variables
FINAL_LONG_Data[, IRTTheta := format(IRTTheta, scientific = FALSE, trim=TRUE)]
FINAL_LONG_Data[, SGPIRTThetaState1Prior := format(SGPIRTThetaState1Prior, scientific = FALSE, trim=TRUE)]
FINAL_LONG_Data[, SGPIRTThetaState2Prior := format(SGPIRTThetaState2Prior, scientific = FALSE, trim=TRUE)]

FINAL_LONG_Data[, SGPIRTThetaPARCC1Prior := format(SGPIRTThetaPARCC1Prior, scientific = FALSE, trim=TRUE)]
FINAL_LONG_Data[, SGPIRTThetaPARCC2Prior := format(SGPIRTThetaPARCC2Prior, scientific = FALSE, trim=TRUE)]

##   Clean up NAs after cleanup.  IRTTheta not affected (No NAs)
table(FINAL_LONG_Data[, grepl("NA", SGPIRTThetaState1Prior)]) # NAs formatted as "      NA"
FINAL_LONG_Data[grep("NA", SGPIRTThetaState1Prior), SGPIRTThetaState1Prior := NA]
FINAL_LONG_Data[grep("NA", SGPIRTThetaState2Prior), SGPIRTThetaState2Prior := NA]

table(FINAL_LONG_Data[, grepl("NA", SGPIRTThetaPARCC1Prior)]) # NAs formatted as "      NA"
FINAL_LONG_Data[grep("NA", SGPIRTThetaPARCC1Prior), SGPIRTThetaPARCC1Prior := NA]
FINAL_LONG_Data[grep("NA", SGPIRTThetaPARCC2Prior), SGPIRTThetaPARCC2Prior := NA]


###   Final data QC checks
FINAL_LONG_Data[, as.list(summary(as.numeric(StudentGrowthPercentileComparedtoState))), keyby="TestCode"] # SGPRankedSimexState
FINAL_LONG_Data[, as.list(summary(as.numeric(StudentGrowthPercentileComparedtoStateBaseline))), keyby="TestCode"] # SGPRankedSimexState
FINAL_LONG_Data[, as.list(summary(as.numeric(SGPRankedSimexStateBaseline))), keyby="TestCode"] # SGPRankedSimexState
table(FINAL_LONG_Data[, TestCode, SGPPreviousTestCodeState1Prior])
# table(FINAL_LONG_Data[TestCode=="ELA10" & SGPPreviousTestCodeState1Prior=="ELA08", StateAbbreviation])
# table(FINAL_LONG_Data[TestCode=="GEO01" & SGPPreviousTestCodeState1Prior=="MAT08", StateAbbreviation])
FINAL_LONG_Data[TestCode=="ELA10" & SGPPreviousTestCodeState1Prior=="ELA08", as.list(summary(as.numeric(StudentGrowthPercentileComparedtoState))), keyby="StateAbbreviation"]
FINAL_LONG_Data[TestCode=="GEO01", as.list(summary(as.numeric(StudentGrowthPercentileComparedtoState))), keyby="StateAbbreviation"]
tbl <- FINAL_LONG_Data[grep("ELA04|ELA05|ELA06|ELA07|ELA08", TestCode), as.list(summary(as.numeric(StudentGrowthPercentileComparedtoState))), keyby=c("StateAbbreviation", "TestCode")]

FINAL_LONG_Data[, as.list(summary(as.numeric(StudentGrowthPercentileComparedtoPARCC))), keyby="TestCode"] # SGPRankedSimexPARCC
FINAL_LONG_Data[, as.list(summary(as.numeric(StudentGrowthPercentileComparedtoPARCCBaseline))), keyby="TestCode"] # SGPRankedSimexState
FINAL_LONG_Data[, as.list(summary(as.numeric(SGPRankedSimexPARCCBaseline))), keyby="TestCode"] # SGPRankedSimexState
table(FINAL_LONG_Data[, TestCode, SGPPreviousTestCodePARCC1Prior])
# table(FINAL_LONG_Data[TestCode=="ELA10" & SGPPreviousTestCodePARCC1Prior=="ELA08", StateAbbreviation])
# table(FINAL_LONG_Data[TestCode=="GEO01" & SGPPreviousTestCodePARCC1Prior=="MAT08", StateAbbreviation])
FINAL_LONG_Data[TestCode=="ELA10" & SGPPreviousTestCodePARCC1Prior=="ELA08", as.list(summary(as.numeric(StudentGrowthPercentileComparedtoPARCC))), keyby="StateAbbreviation"]
FINAL_LONG_Data[TestCode=="GEO01", as.list(summary(as.numeric(StudentGrowthPercentileComparedtoPARCC))), keyby="StateAbbreviation"]
tbl <- FINAL_LONG_Data[grep("ELA04|ELA05|ELA06|ELA07|ELA08", TestCode), as.list(summary(as.numeric(StudentGrowthPercentileComparedtoPARCC))), keyby=c("StateAbbreviation", "TestCode")]

##  Tests for DC  --  might need again in the future...
# summary(FINAL_LONG_Data[TestCode=="ELA10" & SGPPreviousTestCodeState1Prior=="ELA08", as.numeric(StudentGrowthPercentileComparedtoState)])
# table(FINAL_LONG_Data[TestCode=="ELA10" & SGPPreviousTestCodeState1Prior=="ELA08", StateAbbreviation])
# table(FINAL_LONG_Data[TestCode=="GEO01" & SGPPreviousTestCodeState1Prior=="MAT08", StateAbbreviation])

# summary(FINAL_LONG_Data[TestCode=="ELA10" & SGPPreviousTestCodeState1Prior=="ELA09", as.numeric(StudentGrowthPercentileComparedtoState)])
# table(FINAL_LONG_Data[TestCode=="ELA10" & SGPPreviousTestCodeState1Prior=="ELA09", StateAbbreviation]) # No DC students!
# table(FINAL_LONG_Data[TestCode=="GEO01" & SGPPreviousTestCodeState1Prior=="ALG01", StateAbbreviation]) # No DC students!


###
###  Save R object and Export/zip State specific .csv files
###

####   For individual state data formatting
# abv <- "IL"
# fname <- paste0("./", gsub(" ", "_", SGP:::getStateAbbreviation(abv, type="state")), "/Data/Pearson/PARCC_", abv, "_2020-2021_Spring_SGP-STATE_LEVEL_Results_", format(Sys.Date(), format="%Y%m%d"), ".csv")
# fname <- gsub("_of_", "_Of_", fname) # DoDEA folder name
# # fwrite(FINAL_LONG_Data, fname)
# options(scipen = 999)
# write.csv(FINAL_LONG_Data, fname, row.names = FALSE, na="") # [PANUniqueStudentID %in% sample(PANUniqueStudentID, 100) & StateAbbreviation == abv & GradeLevelWhenAssessed %in% c('05','08'),]
# zip(zipfile=paste0(fname, ".zip"), files=fname, flags="-mqj") # -mq doesn't leave a csv copy. j "junks" the directory structure (tree)
####   END For individual state data formatting


####  Loop on State Abbreviation to write out each state file in format that it was recieved and return requested
tmp.wd <- getwd()
options(scipen = 999)
for (abv in unique(FINAL_LONG_Data$StateAbbreviation)) {
  fname <- paste0("./", gsub(" ", "_", SGP:::getStateAbbreviation(abv, type="state")), "/Data/Pearson/PARCC_", abv, "_2020-2021_Spring_SGP-Results_", format(Sys.Date(), format="%Y%m%d"), ".csv")
  if (abv == "DD") fname <- gsub("_of_", "_Of_", fname) # DoDEA folder name
  if (abv=="IL") {
    tmp.vars <- all.var.names[!all.var.names %in% c("EXACT_DUPLICATE", addl.bie.dd.names)]
  } else tmp.vars <- all.var.names[!all.var.names %in% "EXACT_DUPLICATE"]
  write.csv(FINAL_LONG_Data[StateAbbreviation == abv, ..tmp.vars], fname, row.names = FALSE, na="") # , na="" --> Use for 2021???
  zip(zipfile=paste0(fname, ".zip"), files=fname, flags="-mqj") # -mq doesn't leave a csv copy. j "junks" the directory structure (tree)
  message("Finished with ", SGP:::getStateAbbreviation(abv, type="state"))
}

save(FINAL_LONG_Data, file="./PARCC/Data/Pearson/PARCC_SGP_LONG_Data_2020_2021.2.Rdata")

#   tmp.state <- SGP:::getStateAbbreviation(abv, type="state")
# 	fname <- paste0("PARCC_", abv, "_2018-2019_Spring_SGP-Results_", format(Sys.Date(), format="%Y%m%d"), ".csv")
#   setwd(paste0("./",  gsub(" ", "_", capwords(tmp.state, special.words="DC")), "/Data/Pearson"))
#   fwrite(FINAL_LONG_Data[StateAbbreviation == abv], fname) #, col.names = FALSE
#   zip(zipfile=paste0(fname, ".zip"), files=fname, flags="-mq") # -mq doesn't leave a csv copy.
#   setwd(tmp.wd)
# }
