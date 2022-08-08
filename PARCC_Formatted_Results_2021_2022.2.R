###############################################################################
###                                                                         ###
###    Format Spring 2022 Consortium Results to Pearson's specifications    ###
###                                                                         ###
###############################################################################

###   Load required packages
require(SGP)
require(data.table)

###   Read in Spring 2022 Output Files
for (org in c("PARCC", "Department_Of_Defense",
              "Illinois", "Bureau_of_Indian_Education")) {
    load(paste0(org, "/Data/Archive/2021_2022.2/",
                org, "_SGP_LONG_Data_2021_2022.2.Rdata"))
}
# load("./Illinois/Data/Archive/2021_2022.2/Illinois_SGP_LONG_Data_2021_2022.2.Rdata")


###   Amend State Files as needed
##    Illinois only has percentiles/projections through grade 8 so no EOCT
##    projection groups / need for SGP_TARGET_3_YEAR_CONTENT_AREA in combineSGP.
Illinois_SGP_LONG_Data_2021_2022.2[,
    SGP_TARGET_3_YEAR_CONTENT_AREA := as.character(NA)]
Illinois_SGP_LONG_Data_2021_2022.2[!is.na(SGP_TARGET_3_YEAR),
    SGP_TARGET_3_YEAR_CONTENT_AREA := CONTENT_AREA]


###   Set names based on Pearson file layout
pearson.var.names <-
    c("AssessmentYear", "StateAbbreviation", "PANUniqueStudentID",
      "GradeLevelWhenAssessed", "Period", "TestCode", "TestFormat",
      "SummativeScoreRecordUUID", "StudentTestUUID", "SummativeScaleScore",
      "IRTTheta", "SummativeCSEM", "ThetaSEM", "FormID", "TestingLocation",
      "LearningOption", "StateStudentIdentifier", "LocalStudentIdentifier",
      "TestingDistrictCode", "TestingDistrictName", "TestingSchoolCode",
      "TestingSchoolName", "AccountableDistrictCode", "AccountableDistrictName",
      "AccountableSchoolCode", "AccountableSchoolName", "Sex",
      "HispanicOrLatinoEthnicity", "AmericanIndianOrAlaskaNative", "Asian",
      "BlackOrAfricanAmerican", "NativeHawaiianOrOtherPacificIslander",
      "White", "FederalRaceEthnicity", "TwoOrMoreRaces", "EnglishLearnerEL",
      "MigrantStatus", "GiftedAndTalented", "EconomicDisadvantageStatus",
      "StudentWithDisabilities")

center.var.names <-
    c("SGPIRTThetaState1Prior", "SGPIRTThetaState2Prior",
      "SGPIRTThetaConsortia1Prior", "SGPIRTThetaConsortia2Prior",
      "StudentGrowthPercentileComparedtoState",
      "StudentGrowthPercentileComparedtoState1Prior",
      "StudentGrowthPercentileComparedtoState2Prior",
      "StudentGrowthPercentileComparedtoConsortia",
      "StudentGrowthPercentileComparedtoConsortia1Prior",
      "StudentGrowthPercentileComparedtoConsortia2Prior",
      "SGPPreviousTestCodeState", "SGPPreviousTestCodeState1Prior",
      "SGPPreviousTestCodeState2Prior", "SGPPreviousTestCodeConsortia",
      "SGPPreviousTestCodeConsortia1Prior",
      "SGPPreviousTestCodeConsortia2Prior",
      "SGPUpperBoundState", "SGPUpperBoundState1Prior", 
      "SGPUpperBoundState2Prior", "SGPLowerBoundState",
      "SGPLowerBoundState1Prior", "SGPLowerBoundState2Prior",
      "SGPUpperBoundConsortia", "SGPUpperBoundConsortia1Prior",
      "SGPUpperBoundConsortia2Prior", "SGPLowerBoundConsortia",
      "SGPLowerBoundConsortia1Prior", "SGPLowerBoundConsortia2Prior",
      "SGPStandardErrorState", "SGPStandardErrorState1Prior",
      "SGPStandardErrorState2Prior", "SGPStandardErrorConsortia",
      "SGPStandardErrorConsortia1Prior",
      "SGPStandardErrorConsortia2Prior",
      "SGPRankedSimexState", "SGPRankedSimexState1Prior",
      "SGPRankedSimexState2Prior", "SGPRankedSimexConsortia",
      "SGPRankedSimexConsortia1Prior", "SGPRankedSimexConsortia2Prior",
      "SGPTargetState", "SGPTargetConsortia", "SGPTargetTestCodeState",
      "SGPTargetTestCodeConsortia",
      "StudentGrowthPercentileComparedtoStateBaseline",
      "SGPRankedSimexStateBaseline", "SGPTargetStateBaseline",
      "StudentGrowthPercentileComparedtoConsortiaBaseline",
      "SGPRankedSimexConsortiaBaseline", "SGPTargetConsortiaBaseline")

all.var.names <- c(pearson.var.names[1:11], center.var.names[1:4],
                   pearson.var.names[12:13], center.var.names[5:44], # Old order
                   pearson.var.names[14], center.var.names[45:50],
                   pearson.var.names[15:40], "EXACT_DUPLICATE") #  Added in 2021

##    Two additional variables for BIE & DoDEA
addl.bie.dd.names <- c("customerReferenceId", "testAdminReferenceId")
all.var.names <- c(all.var.names, addl.bie.dd.names)
pearson.var.names <- c(pearson.var.names, addl.bie.dd.names)

###   Combine states' data into single data table
# State_LONG_Data <-
#     rbindlist(list(
#                    Bureau_of_Indian_Education_SGP_LONG_Data_2021_2022.2,
#                    Department_of_Defense_SGP_LONG_Data_2021_2022.2,
#                    Illinois_SGP_LONG_Data_2021_2022.2),
#               fill = TRUE, use.names = TRUE)

###   For individual state data formatting
State_LONG_Data <- copy(Illinois_SGP_LONG_Data_2021_2022.2)
rm(Illinois_SGP_LONG_Data_2021_2022.2); gc()
# Parcc_LONG_Data <-
#     PARCC_SGP_LONG_Data_2021_2022.2[StateAbbreviation == "IL"]

assign("Parcc_LONG_Data", PARCC_SGP_LONG_Data_2021_2022.2)
rm(PARCC_SGP_LONG_Data_2021_2022.2); gc()


#####
###          State Data
#####

###   Combine SGP_NOTE and SGP variables
##    'NA' or <1000 per Pearson 2022 Growth File Layout v1
#     table(State_LONG_Data[, is.na(SGP), SGP_NOTE], exclude = NULL)
State_LONG_Data[, SGP := as.character(SGP)]
State_LONG_Data[is.na(SGP), SGP := SGP_NOTE]

# No BASELINE specific NOTE.  Make sure its only replacing NAs!
State_LONG_Data[, SGP_BASELINE := as.character(SGP_BASELINE)]
State_LONG_Data[is.na(SGP_BASELINE), SGP_BASELINE := SGP_NOTE]

###   Now remove NOTE - Kathy/Pat 8/14/19 -- Just kidding :/
###   JK re JK. LOL. -- 8/18/2021 Kathy.  SMH FML IHTG
State_LONG_Data[, SGP_NORM_GROUP := as.character(SGP_NORM_GROUP)]
State_LONG_Data[!is.na(SGP_NOTE), SGP_NORM_GROUP := ""]

State_LONG_Data[, SGP_NORM_GROUP_BASELINE :=
    as.character(SGP_NORM_GROUP_BASELINE)]
State_LONG_Data[!is.na(SGP_NOTE), SGP_NORM_GROUP_BASELINE := ""]

##    BASELINEs don't rename "SGP_0.**_CONFIDENCE_BOUND" with "_BASELINE" tag
##    Not an issue for State - see PARCC Below though...
# State_LONG_Data[!is.na(SGP_NOTE),
#     as.list(summary(SGP_0.05_CONFIDENCE_BOUND)), keyby = "TestCode"]


###   Change relevant SGP package convention names to Pearson's names
sgp.names <-
  c("ID", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_CSEM_ACTUAL",
    "SCALE_SCORE", "SCALE_SCORE_CSEM", "SGP", "SGP_STANDARD_ERROR",
    "SGP_0.05_CONFIDENCE_BOUND", "SGP_0.95_CONFIDENCE_BOUND",
    "SGP_ORDER_1", "SGP_ORDER_1_0.05_CONFIDENCE_BOUND",
    "SGP_ORDER_1_0.95_CONFIDENCE_BOUND", "SGP_ORDER_1_STANDARD_ERROR",
    "SGP_ORDER_2", "SGP_ORDER_2_0.05_CONFIDENCE_BOUND",
    "SGP_ORDER_2_0.95_CONFIDENCE_BOUND", "SGP_ORDER_2_STANDARD_ERROR",
    "SGP_SIMEX_RANKED", "SGP_SIMEX_RANKED_ORDER_1",
    "SGP_SIMEX_RANKED_ORDER_2", "SGP_TARGET_3_YEAR",
    "SGP_TARGET_3_YEAR_CONTENT_AREA",
    "SGP_BASELINE", "SGP_SIMEX_BASELINE", "SGP_TARGET_BASELINE_3_YEAR")

setnames(State_LONG_Data, sgp.names[sgp.names %in% names(State_LONG_Data)],
  c("PANUniqueStudentID", "SummativeScaleScore", "SummativeCSEM",
    "IRTTheta", "ThetaSEM",
    "StudentGrowthPercentileComparedtoState", "SGPStandardErrorState",
    "SGPLowerBoundState", "SGPUpperBoundState",
    "StudentGrowthPercentileComparedtoState1Prior", "SGPLowerBoundState1Prior",
    "SGPUpperBoundState1Prior", "SGPStandardErrorState1Prior",
    "StudentGrowthPercentileComparedtoState2Prior", "SGPLowerBoundState2Prior",
    "SGPUpperBoundState2Prior", "SGPStandardErrorState2Prior",
    "SGPRankedSimexState", "SGPRankedSimexState1Prior",
    "SGPRankedSimexState2Prior", "SGPTargetState", "SGPTargetTestCodeState",
    "StudentGrowthPercentileComparedtoStateBaseline",
    "SGPRankedSimexStateBaseline", "SGPTargetStateBaseline"
   )[sgp.names %in% names(State_LONG_Data)])

###   Split SGP_NORM_GROUP to create 'SGPPreviousTestCode*' Variables
state.tmp.split <-
    strsplit(as.character(State_LONG_Data$SGP_NORM_GROUP), "; ")
State_LONG_Data[, CONTENT_AREA_1PRIOR :=
    factor(sapply(sapply(strsplit(sapply(strsplit(sapply(state.tmp.split,
            function(x) rev(x)[2]), "/"), "[", 2), "_"), head, -1),
                paste, collapse = "_"))]
##    Only 1 prior for 2022
State_LONG_Data[, CONTENT_AREA_2PRIOR := as.character(NA)]
# State_LONG_Data[, CONTENT_AREA_2PRIOR :=
#     factor(sapply(sapply(strsplit(sapply(strsplit(sapply(state.tmp.split,
#             function(x) rev(x)[3]), "/"), "[", 2), "_"), head, -1),
#                 paste, collapse = "_"))]

##    Check! - levels(State_LONG_Data$CONTENT_AREA_1PRIOR)
setattr(State_LONG_Data$CONTENT_AREA_1PRIOR, "levels", c(NA, "ELA", "MAT")) # IL
# setattr(State_LONG_Data$CONTENT_AREA_1PRIOR, "levels", c(NA, "ALG01", "ELA", "MAT"))
# levels(State_LONG_Data$CONTENT_AREA_2PRIOR)
# setattr(State_LONG_Data$CONTENT_AREA_2PRIOR, "levels", c(NA, "ELA", "MAT"))
State_LONG_Data[, GRADE_1PRIOR :=
    sapply(strsplit(sapply(strsplit(sapply(state.tmp.split,
        function(x) rev(x)[2]), "/"), "[", 2), "_"), tail, 1)]
# State_LONG_Data[, GRADE_2PRIOR :=
#     sapply(strsplit(sapply(strsplit(sapply(state.tmp.split,
#         function(x) rev(x)[3]), "/"), "[", 2), "_"), tail, 1)]
State_LONG_Data[, GRADE_2PRIOR := ""]
State_LONG_Data[GRADE_1PRIOR == "EOCT", GRADE_1PRIOR := ""]
# State_LONG_Data[GRADE_2PRIOR == "EOCT", GRADE_2PRIOR := ""]
State_LONG_Data[GRADE_1PRIOR %in% 3:9, GRADE_1PRIOR := paste0("0", GRADE_1PRIOR)]
# State_LONG_Data[GRADE_2PRIOR %in% 3:9, GRADE_2PRIOR := paste0("0", GRADE_2PRIOR)]

# State_LONG_Data[, SGPPreviousTestCodeState :=
#     factor(paste0(CONTENT_AREA_2PRIOR, GRADE_2PRIOR, ";",
#                   CONTENT_AREA_1PRIOR, GRADE_1PRIOR))]
State_LONG_Data[, SGPPreviousTestCodeState :=
    factor(paste0(CONTENT_AREA_1PRIOR, GRADE_1PRIOR))] # 2022 ONLY (hopefully)
State_LONG_Data[, SGPPreviousTestCodeState :=
    gsub("NANA;|NANA$", "", SGPPreviousTestCodeState)]
State_LONG_Data[, SGPPreviousTestCodeState1Prior :=
    factor(paste0(CONTENT_AREA_1PRIOR, GRADE_1PRIOR))]
# State_LONG_Data[, SGPPreviousTestCodeState2Prior :=
#     factor(paste0(CONTENT_AREA_2PRIOR, GRADE_2PRIOR))]
State_LONG_Data[, SGPPreviousTestCodeState2Prior := ""]
State_LONG_Data[, SGPPreviousTestCodeState1Prior :=
    gsub("NANA", "", SGPPreviousTestCodeState1Prior)]
# State_LONG_Data[, SGPPreviousTestCodeState2Prior :=
#     gsub("NANA", "", SGPPreviousTestCodeState2Prior)]
# table(State_LONG_Data[, SGPPreviousTestCodeState1Prior, SGPPreviousTestCodeState])

###    Split SGP_NORM_GROUP_SCALE_SCORES to create 'SGPIRTThetaState*' Variables
state.score.split <-
    strsplit(as.character(State_LONG_Data$SGP_NORM_GROUP_SCALE_SCORES), "; ")
State_LONG_Data[, SGPIRTThetaState1Prior :=
    as.numeric(sapply(state.score.split, function(x) rev(x)[2]))]
# State_LONG_Data[, SGPIRTThetaState2Prior :=
#     as.numeric(sapply(state.score.split, function(x) rev(x)[3]))]
State_LONG_Data[, SGPIRTThetaState2Prior := as.numeric(NA)]

###   Compute and Format SGPTargetTestCodeState
State_LONG_Data[, SGPTargetTestCodeState := factor(SGPTargetTestCodeState)]
# levels(State_LONG_Data$SGPTargetTestCodeState)
setattr(State_LONG_Data$SGPTargetTestCodeState, "levels", c("ELA", "MAT"))
State_LONG_Data[, SGPTargetTestCodeState :=
    as.character(SGPTargetTestCodeState)]
State_LONG_Data[SGPTargetTestCodeState %in% c("ELA", "MAT"),
    SGPTargetTestCodeState := 
        paste0(SGPTargetTestCodeState, "0", as.numeric(GRADE) + 3)]
State_LONG_Data[, SGPTargetTestCodeState :=
    gsub("010", "10", SGPTargetTestCodeState)]
State_LONG_Data[, SGPTargetTestCodeState :=
    gsub("011|012|013|014", "11", SGPTargetTestCodeState)]
##    Illinois only goes to grade 8 & Only Illinois has state targets in 2021...
State_LONG_Data[StateAbbreviation == "IL", SGPTargetTestCodeState :=
    gsub("ELA09|ELA10|ELA11", "ELA08", SGPTargetTestCodeState)]
State_LONG_Data[StateAbbreviation == "IL", SGPTargetTestCodeState :=
    gsub("MAT09|MAT10|MAT11", "MAT08", SGPTargetTestCodeState)]
##    Non-IL States
State_LONG_Data[StateAbbreviation != "IL", SGPTargetTestCodeState :=
    gsub("MAT09", "ALG01", SGPTargetTestCodeState)]
State_LONG_Data[StateAbbreviation != "IL", SGPTargetTestCodeState :=
    gsub("MAT10", "GEO01", SGPTargetTestCodeState)]
State_LONG_Data[StateAbbreviation != "IL", SGPTargetTestCodeState :=
    gsub("MAT11", "ALG02", SGPTargetTestCodeState)]

table(State_LONG_Data[, SGPTargetTestCodeState, TestCode])
table(State_LONG_Data[, SGPTargetTestCodeState, StateAbbreviation]) # Only IL had (state) projections in 2021 - 2022 too?


####  For individual state data formatting
State_LONG_Data[,
    grep("Consortia", center.var.names, value = TRUE) := as.character(NA)]
State_LONG_Data[,
    center.var.names[!center.var.names %in% names(State_LONG_Data)] :=
        as.character(NA)] # None for IL in 2022 - '2Prior' vars created above
##     For IL ONLY! :
State_LONG_Data[, (addl.bie.dd.names) := as.character(NA)]
####  For individual state data formatting

###   Re-order AND subset columns of State_LONG_Data
State_LONG_Data <-
    State_LONG_Data[,
            names(State_LONG_Data)[names(State_LONG_Data) %in% all.var.names],
        with = FALSE]


####  SKIP THIS STEP For individual state data formatting

#####
###          Consortium Data
#####

###   Combine SGP_NOTE and SGP variables
Parcc_LONG_Data[, SGP := as.character(SGP)]
Parcc_LONG_Data[which(is.na(SGP)), SGP := SGP_NOTE]

##     No BASELINE specific NOTE.  Make sure its only replacing NAs!
# table(Parcc_LONG_Data[, is.na(SGP_BASELINE), SGP_NOTE], exclude = NULL)
Parcc_LONG_Data[, SGP_BASELINE := as.character(SGP_BASELINE)]
Parcc_LONG_Data[is.na(SGP_BASELINE), SGP_BASELINE := SGP_NOTE]

###   Now remove NOTE - Kathy/Pat 8/14/19 -- Just kidding :/
###   JK re JK. LOL. -- 8/18/2021 Kathy.  SMH FML IHTG
Parcc_LONG_Data[, SGP_NORM_GROUP := as.character(SGP_NORM_GROUP)]
Parcc_LONG_Data[!is.na(SGP_NOTE), SGP_NORM_GROUP := ""]

Parcc_LONG_Data[, SGP_NORM_GROUP_BASELINE :=
    as.character(SGP_NORM_GROUP_BASELINE)]
Parcc_LONG_Data[!is.na(SGP_NOTE), SGP_NORM_GROUP_BASELINE := ""]

##    BASELINEs don't rename "SGP_0.**_CONFIDENCE_BOUND" with "_BASELINE" tag.
##    The "ORDER" versions DO get renamed!
##    -- "SGP_BASELINE_ORDER_*_0.**_CONFIDENCE_BOUND"
# Parcc_LONG_Data[!is.na(SGP_NOTE), as.list(summary(SGP_0.05_CONFIDENCE_BOUND)), keyby = "TestCode"]
Parcc_LONG_Data[!is.na(SGP_NOTE), SGP_0.05_CONFIDENCE_BOUND := NA]
Parcc_LONG_Data[!is.na(SGP_NOTE), SGP_0.95_CONFIDENCE_BOUND := NA]

###   Change relevant SGP package convention names to Pearson's names
setnames(Parcc_LONG_Data,
  c("ID", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_CSEM_ACTUAL",
    "SCALE_SCORE", "SCALE_SCORE_CSEM", "SGP", "SGP_0.05_CONFIDENCE_BOUND",
    "SGP_0.95_CONFIDENCE_BOUND", "SGP_STANDARD_ERROR", "SGP_ORDER_1",
    "SGP_ORDER_1_0.05_CONFIDENCE_BOUND", "SGP_ORDER_1_0.95_CONFIDENCE_BOUND",
    "SGP_ORDER_1_STANDARD_ERROR", "SGP_ORDER_2",
    "SGP_ORDER_2_0.05_CONFIDENCE_BOUND", "SGP_ORDER_2_0.95_CONFIDENCE_BOUND",
    "SGP_ORDER_2_STANDARD_ERROR", "SGP_SIMEX_RANKED",
    "SGP_SIMEX_RANKED_ORDER_1", "SGP_SIMEX_RANKED_ORDER_2",
    "SGP_TARGET_3_YEAR", "SGP_TARGET_3_YEAR_CONTENT_AREA",
    "SGP_BASELINE", "SGP_SIMEX_BASELINE", "SGP_TARGET_BASELINE_3_YEAR"),
  c("PANUniqueStudentID", "SummativeScaleScore", "SummativeCSEM",
    "IRTTheta", "ThetaSEM", "StudentGrowthPercentileComparedtoConsortia",
    "SGPLowerBoundConsortia", "SGPUpperBoundConsortia",
    "SGPStandardErrorConsortia",
    "StudentGrowthPercentileComparedtoConsortia1Prior",
    "SGPLowerBoundConsortia1Prior", "SGPUpperBoundConsortia1Prior",
    "SGPStandardErrorConsortia1Prior",
    "StudentGrowthPercentileComparedtoConsortia2Prior",
    "SGPLowerBoundConsortia2Prior", "SGPUpperBoundConsortia2Prior",
    "SGPStandardErrorConsortia2Prior", "SGPRankedSimexConsortia",
    "SGPRankedSimexConsortia1Prior", "SGPRankedSimexConsortia2Prior",
    "SGPTargetConsortia", "SGPTargetTestCodeConsortia",
    "StudentGrowthPercentileComparedtoConsortiaBaseline",
    "SGPRankedSimexConsortiaBaseline", "SGPTargetConsortiaBaseline"))

###   Split SGP_NORM_GROUP to create 'SGPPreviousTestCode*' Variables
parcc.tmp.split <- strsplit(as.character(Parcc_LONG_Data$SGP_NORM_GROUP), "; ")

Parcc_LONG_Data[, CONTENT_AREA_1PRIOR :=
    factor(sapply(sapply(strsplit(sapply(strsplit(sapply(parcc.tmp.split,
            function(x) rev(x)[2]), "/"), "[", 2), "_"), head, -1),
                paste, collapse = "_"))]
# Single prior only in 2022
Parcc_LONG_Data[, CONTENT_AREA_2PRIOR := as.character(NA)]
# Parcc_LONG_Data[, CONTENT_AREA_2PRIOR :=
#     factor(sapply(sapply(strsplit(sapply(strsplit(sapply(parcc.tmp.split,
#             function(x) rev(x)[3]), "/"), "[", 2), "_"), head, -1),
#                 paste, collapse = "_"))]

setattr(Parcc_LONG_Data$CONTENT_AREA_1PRIOR,
        "levels", c(NA, "ALG01", "ELA", "MAT"))
# setattr(Parcc_LONG_Data$CONTENT_AREA_2PRIOR, "levels", c(NA, "ELA", "MAT"))
Parcc_LONG_Data[, GRADE_1PRIOR :=
    sapply(strsplit(sapply(strsplit(sapply(
        parcc.tmp.split, function(x) rev(x)[2]), "/"), "[", 2), "_"), tail, 1)]
Parcc_LONG_Data[, GRADE_2PRIOR := ""]
# Parcc_LONG_Data[, GRADE_2PRIOR :=
#     sapply(strsplit(sapply(strsplit(sapply(
#         parcc.tmp.split, function(x) rev(x)[3]), "/"), "[", 2), "_"), tail, 1)]
Parcc_LONG_Data[GRADE_1PRIOR == "EOCT", GRADE_1PRIOR := ""]
# Parcc_LONG_Data[GRADE_2PRIOR == "EOCT", GRADE_2PRIOR := ""]
# table(Parcc_LONG_Data[, GRADE_1PRIOR, CONTENT_AREA_1PRIOR])
Parcc_LONG_Data[GRADE_1PRIOR %in% 3:9, GRADE_1PRIOR := paste0("0", GRADE_1PRIOR)]
# Parcc_LONG_Data[GRADE_2PRIOR %in% 3:9, GRADE_2PRIOR := paste0("0", GRADE_2PRIOR)]
# Parcc_LONG_Data[, SGPPreviousTestCodeConsortia :=
#     factor(paste0(CONTENT_AREA_2PRIOR, GRADE_2PRIOR, ";",
#                   CONTENT_AREA_1PRIOR, GRADE_1PRIOR))]
Parcc_LONG_Data[, SGPPreviousTestCodeConsortia :=
    factor(paste0(CONTENT_AREA_1PRIOR, GRADE_1PRIOR))]
Parcc_LONG_Data[, SGPPreviousTestCodeConsortia :=
    gsub("NANA;|NANA$", "", SGPPreviousTestCodeConsortia)]
Parcc_LONG_Data[, SGPPreviousTestCodeConsortia1Prior :=
    factor(paste0(CONTENT_AREA_1PRIOR, GRADE_1PRIOR)) ]
Parcc_LONG_Data[, SGPPreviousTestCodeConsortia1Prior :=
    gsub("NANA", "", SGPPreviousTestCodeConsortia1Prior)]
Parcc_LONG_Data[, SGPPreviousTestCodeConsortia2Prior := ""]
# Parcc_LONG_Data[, SGPPreviousTestCodeConsortia2Prior :=
#     factor(paste0(CONTENT_AREA_2PRIOR, GRADE_2PRIOR)) ]
# Parcc_LONG_Data[, SGPPreviousTestCodeConsortia2Prior :=
#     gsub("NANA", "", SGPPreviousTestCodeConsortia2Prior)]
# table(Parcc_LONG_Data[,
#     SGPPreviousTestCodeConsortia2Prior, SGPPreviousTestCodeConsortia])

###   Split SGP_NORM_GROUP_SCALE_SCORES for 'SGPIRTThetaConsortia*' Variables
parcc.score.split <-
    strsplit(as.character(Parcc_LONG_Data$SGP_NORM_GROUP_SCALE_SCORES), "; ")
Parcc_LONG_Data[, SGPIRTThetaConsortia1Prior :=
    as.numeric(sapply(parcc.score.split, function(x) rev(x)[2]))]
# Parcc_LONG_Data[, SGPIRTThetaConsortia2Prior :=
#     as.numeric(sapply(parcc.score.split, function(x) rev(x)[3]))]
Parcc_LONG_Data[, SGPIRTThetaConsortia2Prior := as.numeric(NA)]

###   Compute and Format SGPTargetTestCodeConsortia
Parcc_LONG_Data[, SGPTargetTestCodeConsortia :=
    factor(SGPTargetTestCodeConsortia)]
setattr(Parcc_LONG_Data$SGPTargetTestCodeConsortia,
        "levels", c("ALG02", "ELA", "MAT"))
# "ALG01", "GEO01", - no students w/ "CANONICAL" progressions
# No INTEGRATED_MATH_* as of 2019
Parcc_LONG_Data[, SGPTargetTestCodeConsortia :=
    as.character(SGPTargetTestCodeConsortia)]
Parcc_LONG_Data[SGPTargetTestCodeConsortia %in% c("ELA", "MAT"),
    SGPTargetTestCodeConsortia :=
        paste0(SGPTargetTestCodeConsortia, "0", as.numeric(GRADE) + 3)]
Parcc_LONG_Data[, SGPTargetTestCodeConsortia :=
    gsub("010", "10", SGPTargetTestCodeConsortia)]
Parcc_LONG_Data[, SGPTargetTestCodeConsortia :=
    gsub("011|012|013|014", "11", SGPTargetTestCodeConsortia)]
Parcc_LONG_Data[, SGPTargetTestCodeConsortia :=
    gsub("MAT09", "ALG01", SGPTargetTestCodeConsortia)]
Parcc_LONG_Data[, SGPTargetTestCodeConsortia :=
    gsub("MAT10", "GEO01", SGPTargetTestCodeConsortia)]
Parcc_LONG_Data[, SGPTargetTestCodeConsortia :=
    gsub("MAT11", "ALG02", SGPTargetTestCodeConsortia)]
# table(Parcc_LONG_Data[, SGPTargetTestCodeConsortia, TestCode])

###  Re-order AND subset columns of Parcc_LONG_Data
Parcc_LONG_Data <-
    Parcc_LONG_Data[,
        names(Parcc_LONG_Data)[names(Parcc_LONG_Data) %in% all.var.names],
        with = FALSE]

#####
###   Merge Consortia and State Data
#####

####   SKIP THIS STEP For individual state data formatting
# State_LONG_Data[, SummativeCSEM := as.numeric(SummativeCSEM)]
# State_LONG_Data[, SummativeScaleScore := as.numeric(SummativeScaleScore)]

# FINAL_LONG_Data <-
#     merge(Parcc_LONG_Data, State_LONG_Data,
#           by = intersect(names(Parcc_LONG_Data), names(State_LONG_Data)),
#           all.x = TRUE)

####  For individual state data formatting
FINAL_LONG_Data <- copy(State_LONG_Data)

###  Fix EXACT_DUPLICATEs  (None in Spring 2019, 2021, 2022)
FINAL_LONG_Data[EXACT_DUPLICATE == 2, (center.var.names) :=
    FINAL_LONG_Data[EXACT_DUPLICATE == 1, center.var.names, with = FALSE]]
FINAL_LONG_Data[, EXACT_DUPLICATE := NULL]

###   Coordinate missing SGP notes for small N states
###   Now remove NOTE - Kathy/Pat 8/14/19 -- Just kidding :/
# FINAL_LONG_Data[which(is.na(StudentGrowthPercentileComparedtoState) &
#                       StudentGrowthPercentileComparedtoConsortia == "<1000"),
#                 SGPPreviousTestCodeState := SGPPreviousTestCodeConsortia]
# FINAL_LONG_Data[which(is.na(StudentGrowthPercentileComparedtoState) &
#                       StudentGrowthPercentileComparedtoConsortia == "<1000"),
#                 StudentGrowthPercentileComparedtoState := "<1000"]

###   Per 2022 'Growth Layout' file:  "If no match is found in both
###   assessment years (any period) for the PARCC ID then report 'NA'."

##    'Max Order/Best' SGPs already converted to character to include SGP_NOTE:
FINAL_LONG_Data[which(is.na(StudentGrowthPercentileComparedtoState)),
    StudentGrowthPercentileComparedtoState := "NA"]
FINAL_LONG_Data[which(is.na(StudentGrowthPercentileComparedtoStateBaseline)),
    StudentGrowthPercentileComparedtoStateBaseline := "NA"]
FINAL_LONG_Data[which(is.na(StudentGrowthPercentileComparedtoConsortia)),
    StudentGrowthPercentileComparedtoConsortia := "NA"]
FINAL_LONG_Data[which(is.na(StudentGrowthPercentileComparedtoConsortiaBaseline)),
    StudentGrowthPercentileComparedtoConsortiaBaseline := "NA"]

##    Convert order specific SGPs to `character` first, then insert 'NA's
FINAL_LONG_Data[, StudentGrowthPercentileComparedtoState1Prior :=
    as.character(StudentGrowthPercentileComparedtoState1Prior)]
FINAL_LONG_Data[which(is.na(StudentGrowthPercentileComparedtoState1Prior)),
    StudentGrowthPercentileComparedtoState1Prior := "NA"]
FINAL_LONG_Data[, StudentGrowthPercentileComparedtoState2Prior :=
    as.character(StudentGrowthPercentileComparedtoState2Prior)]
FINAL_LONG_Data[which(is.na(StudentGrowthPercentileComparedtoState2Prior)),
    StudentGrowthPercentileComparedtoState2Prior := "NA"]
FINAL_LONG_Data[, StudentGrowthPercentileComparedtoConsortia1Prior :=
    as.character(StudentGrowthPercentileComparedtoConsortia1Prior)]
FINAL_LONG_Data[which(is.na(StudentGrowthPercentileComparedtoConsortia1Prior)),
    StudentGrowthPercentileComparedtoConsortia1Prior := "NA"]
FINAL_LONG_Data[, StudentGrowthPercentileComparedtoConsortia2Prior :=
    as.character(StudentGrowthPercentileComparedtoConsortia2Prior)]
FINAL_LONG_Data[which(is.na(StudentGrowthPercentileComparedtoConsortia2Prior)),
    StudentGrowthPercentileComparedtoConsortia2Prior := "NA"]


###   Make sure no exact duplicates remain.
setkey(FINAL_LONG_Data,
       PANUniqueStudentID, StudentTestUUID, TestCode, SummativeScaleScore)
setkey(FINAL_LONG_Data,
       PANUniqueStudentID, StudentTestUUID, TestCode)
dups <- duplicated(FINAL_LONG_Data, by = key(FINAL_LONG_Data))
table(dups) # Should be FALSE
findups <- FINAL_LONG_Data[c(which(dups) - 1, which(dups)), ]
nrow(findups) # Should be 0 rows!

# everything except which(all.var.names == "EXACT_DUPLICATE")
setcolorder(FINAL_LONG_Data, all.var.names[-91])


###   Format IRTTheta variables
FINAL_LONG_Data[, IRTTheta :=
    format(IRTTheta, scientific = FALSE, trim = TRUE)]
FINAL_LONG_Data[, SGPIRTThetaState1Prior :=
    format(SGPIRTThetaState1Prior, scientific = FALSE, trim = TRUE)]
FINAL_LONG_Data[, SGPIRTThetaState2Prior :=
    format(SGPIRTThetaState2Prior, scientific = FALSE, trim = TRUE)]

FINAL_LONG_Data[, SGPIRTThetaConsortia1Prior :=
    format(SGPIRTThetaConsortia1Prior, scientific = FALSE, trim = TRUE)]
FINAL_LONG_Data[, SGPIRTThetaConsortia2Prior :=
    format(SGPIRTThetaConsortia2Prior, scientific = FALSE, trim = TRUE)]

##    Clean up NAs after cleanup - NAs formatted as "      NA"
table(FINAL_LONG_Data[, grepl("NA", SGPIRTThetaState1Prior)])
FINAL_LONG_Data[grep("NA", SGPIRTThetaState1Prior),
    SGPIRTThetaState1Prior := NA]
FINAL_LONG_Data[grep("NA", SGPIRTThetaState2Prior),
    SGPIRTThetaState2Prior := NA]

table(FINAL_LONG_Data[, grepl("NA", SGPIRTThetaConsortia1Prior)])
FINAL_LONG_Data[grep("NA", SGPIRTThetaConsortia1Prior),
    SGPIRTThetaConsortia1Prior := NA]
FINAL_LONG_Data[grep("NA", SGPIRTThetaConsortia2Prior),
    SGPIRTThetaConsortia2Prior := NA]


###   Final data QC checks
FINAL_LONG_Data[,
    as.list(summary(as.numeric(StudentGrowthPercentileComparedtoState))),
    keyby = "TestCode"]
FINAL_LONG_Data[,
    as.list(summary(as.numeric(
        StudentGrowthPercentileComparedtoStateBaseline))),
    keyby = "TestCode"]
FINAL_LONG_Data[,
    as.list(summary(as.numeric(SGPRankedSimexState))),
    keyby = "TestCode"]
FINAL_LONG_Data[,
    as.list(summary(as.numeric(SGPRankedSimexStateBaseline))),
    keyby = "TestCode"]
table(FINAL_LONG_Data[, TestCode, SGPPreviousTestCodeState1Prior])
# table(FINAL_LONG_Data[TestCode == "ELA10" & SGPPreviousTestCodeState1Prior == "ELA08", StateAbbreviation])
# table(FINAL_LONG_Data[TestCode == "GEO01" & SGPPreviousTestCodeState1Prior == "MAT08", StateAbbreviation])
FINAL_LONG_Data[TestCode == "ELA10" & SGPPreviousTestCodeState1Prior == "ELA08",
    as.list(summary(as.numeric(StudentGrowthPercentileComparedtoState))),
    keyby = "StateAbbreviation"]
FINAL_LONG_Data[TestCode == "GEO01",
    as.list(summary(as.numeric(StudentGrowthPercentileComparedtoState))),
    keyby = "StateAbbreviation"]
tbl <- FINAL_LONG_Data[grep("ELA04|ELA05|ELA06|ELA07|ELA08", TestCode),
    as.list(summary(as.numeric(StudentGrowthPercentileComparedtoState))),
    keyby = c("StateAbbreviation", "TestCode")]

FINAL_LONG_Data[,
    as.list(summary(
        as.numeric(StudentGrowthPercentileComparedtoConsortia))),
    keyby = "TestCode"]
FINAL_LONG_Data[,
    as.list(summary(
        as.numeric(StudentGrowthPercentileComparedtoConsortiaBaseline))),
    keyby = "TestCode"]
FINAL_LONG_Data[,
    as.list(summary(as.numeric(SGPRankedSimexConsortia))),
    keyby = "TestCode"]
FINAL_LONG_Data[,
    as.list(summary(as.numeric(SGPRankedSimexConsortiaBaseline))),
    keyby = "TestCode"]
table(FINAL_LONG_Data[, TestCode, SGPPreviousTestCodeConsortia1Prior])
# table(FINAL_LONG_Data[TestCode == "ELA10" & SGPPreviousTestCodeConsortia1Prior == "ELA08", StateAbbreviation])
# table(FINAL_LONG_Data[TestCode == "GEO01" & SGPPreviousTestCodeConsortia1Prior == "MAT08", StateAbbreviation])
FINAL_LONG_Data[
    TestCode == "ELA10" & SGPPreviousTestCodeConsortia1Prior == "ELA08",
      as.list(summary(as.numeric(StudentGrowthPercentileComparedtoConsortia))),
      keyby = "StateAbbreviation"]
FINAL_LONG_Data[TestCode == "GEO01",
    as.list(summary(as.numeric(StudentGrowthPercentileComparedtoConsortia))),
    keyby = "StateAbbreviation"]
tbl <- 
    FINAL_LONG_Data[grep("ELA04|ELA05|ELA06|ELA07|ELA08", TestCode),
      as.list(summary(as.numeric(StudentGrowthPercentileComparedtoConsortia))),
      keyby = c("StateAbbreviation", "TestCode")]

##    Tests for DC  --  might need again in the future...
# summary(FINAL_LONG_Data[TestCode == "ELA10" & SGPPreviousTestCodeState1Prior == "ELA08",
#     as.numeric(StudentGrowthPercentileComparedtoState)])
# table(FINAL_LONG_Data[TestCode == "ELA10" & SGPPreviousTestCodeState1Prior == "ELA08", StateAbbreviation])
# table(FINAL_LONG_Data[TestCode == "GEO01" & SGPPreviousTestCodeState1Prior == "MAT08", StateAbbreviation])
# summary(FINAL_LONG_Data[TestCode == "ELA10" & SGPPreviousTestCodeState1Prior == "ELA09",
#     as.numeric(StudentGrowthPercentileComparedtoState)])
# table(FINAL_LONG_Data[TestCode == "ELA10" & SGPPreviousTestCodeState1Prior == "ELA09", StateAbbreviation]) # No DC students!
# table(FINAL_LONG_Data[TestCode == "GEO01" & SGPPreviousTestCodeState1Prior == "ALG01", StateAbbreviation]) # No DC students!


#####
###   Save R object and Export/zip State specific .csv files
#####

####  For individual state data formatting
abv <- "IL"
fname <-
  paste0("./",
         gsub(" ", "_", SGP:::getStateAbbreviation(abv, type = "state")),
         "/Data/Pearson/PARCC_", abv,
         "_2021-2022_Spring_SGP-STATE_LEVEL_Results_",
         format(Sys.Date(), format = "%Y%m%d"), ".csv"
        )
fname <- gsub("_of_", "_Of_", fname) # DoDEA folder name
if (abv == "IL") FINAL_LONG_Data[, (addl.bie.dd.names) := NULL]
options(scipen = 999)

##    Use `write.csv` - `fwrite` had bug with number of printed digits
write.csv(FINAL_LONG_Data, fname, row.names = FALSE, na = "")
# [PANUniqueStudentID %in% sample(PANUniqueStudentID, 100) &
# StateAbbreviation == abv & GradeLevelWhenAssessed %in% c("05", "08"), ]
zip(zipfile = paste0(fname, ".zip"), files = fname, flags = "-mqj")
####  END For individual state data formatting


####  Loop on State Abbreviation to write out each state file in
####  format that it was recieved and return requested
tmp.wd <- getwd()
options(scipen = 999)
for (abv in unique(FINAL_LONG_Data$StateAbbreviation)) {
  fname <-
      paste0("./",
             gsub(" ", "_", SGP:::getStateAbbreviation(abv, type = "state")),
             "/Data/Pearson/PARCC_", abv, "_2021-2022_Spring_SGP-Results_",
             format(Sys.Date(), format = "%Y%m%d"), ".csv")
  if (abv == "DD") fname <- gsub("_of_", "_Of_", fname) # DoDEA folder name
  if (abv == "IL") {
    tmp.vars <- all.var.names[
        !all.var.names %in% c("EXACT_DUPLICATE", addl.bie.dd.names)]
  } else tmp.vars <- all.var.names[!all.var.names %in% "EXACT_DUPLICATE"]

  ##    Use `write.csv` - `fwrite` had bug with number of printed digits
  write.csv(FINAL_LONG_Data[StateAbbreviation == abv, ..tmp.vars],
            fname, row.names = FALSE, na = "")
  zip(zipfile = paste0(fname, ".zip"), files = fname, flags = "-mqj")
  # -mq doesn't leave a csv copy. j "junks" the directory structure (tree)
  message("Finished with ", SGP:::getStateAbbreviation(abv, type = "state"))
}
####  END State Loop

save(FINAL_LONG_Data,
     file = "./PARCC/Data/Pearson/PARCC_SGP_LONG_Data_2021_2022.2.Rdata")
