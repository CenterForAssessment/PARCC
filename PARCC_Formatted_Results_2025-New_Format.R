###############################################################################
###                                                                         ###
###    Format Spring 2025 (Xsortium) Results to Pearson's specifications    ###
###                                                                         ###
###############################################################################

###   Load required packages
require(data.table)
require(SGP)

###   Read in Spring 2025 Output Files
org <- "Washington_DC"
abv <- "DC"

# for (org in c("Bureau_of_Indian_Education", "Department_Of_Defense",
            #   "Illinois", "New_Jersey", "Washington_DC", "PARCC")) {
    load(
        paste0(org, "/Data/Archive/2024_2025.2/",
               gsub("Of", "of", org), "_SGP_LONG_Data_2024_2025.2.Rdata")
    )
# }


###   Amend State Files as needed
##    IL and BIE only have percentiles/projections through grade 8  -  no EOCT
##    projection groups / need for SGP_TARGET_3_YEAR_CONTENT_AREA in combineSGP.
# Illinois_SGP_LONG_Data_2024_2025.2[,
#     SGP_TARGET_3_YEAR_CONTENT_AREA := as.character(NA)
# ][!is.na(SGP_TARGET_3_YEAR),
#     SGP_TARGET_3_YEAR_CONTENT_AREA := CONTENT_AREA
# ][, SGP_NOTE := NA_character_
# ]
# Bureau_of_Indian_Education_SGP_LONG_Data_2024_2025.2[
#     !is.na(SGP_TARGET_3_YEAR),
#     SGP_TARGET_3_YEAR_CONTENT_AREA := CONTENT_AREA
# ]


###   Set names based on Pearson file layout
pearson.var.names <- c(
    "AssessmentYear", "StateAbbreviation", "StudentUniqueUuid",
    "GradeLevelWhenAssessed", "Period", "TestCode", "TestFormat",
    "SummativeScoreRecordUUID", "StudentTestUUID", "TestScaleScore",
    "IRTTheta", "TestCSEMProbableRange", "ThetaSEM", "FormID", "TestingLocation",
    "LearningOption", "StudentIdentifier", "LocalStudentIdentifier",
    "TestingDistrictCode", "TestingDistrictName", "TestingSchoolCode",
    "TestingSchoolName", "ReportingDistrictCode", "ReportingDistrictName",
    "ReportingSchoolCode", "ReportingSchoolName", "Gender",
    "HispanicOrLatinoEthnicity", "AmericanIndianOrAlaskaNative", "Asian",
    "BlackOrAfricanAmerican", "NativeHawaiianOrOtherPacificIslander", "White",
    "FederalRaceEthnicity", "TwoOrMoreRaces", "EnglishLearnerEL",
    "MigrantStatus", "GiftedAndTalented", "EconomicDisadvantageStatus",
    "StudentWithDisabilities", "CustomerRefID", "testAdminReferenceId", "growthIdentifier"
)

center.var.names <- c(
    "SGPIRTThetaState1Prior", "SGPIRTThetaState2Prior",
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
    "SGPRankedSimexConsortiaBaseline", "SGPTargetConsortiaBaseline"
)

final.vars <- c(
    pearson.var.names[1:11], center.var.names[1:4],
    pearson.var.names[12:13], center.var.names[5:44],
    pearson.var.names[14], center.var.names[45:50],
    pearson.var.names[15:43])
# all.var.names <- c(final.vars, "MiddleEasternNorthAfrican") # IL ONLY
all.var.names <- c(final.vars, "EXACT_DUPLICATE") # ALL members

###   Combine states' data into single data table
# State_LONG_Data <-
#     rbindlist(
#         list(
#             Bureau_of_Indian_Education_SGP_LONG_Data_2024_2025.2,
#             Department_of_Defense_SGP_LONG_Data_2024_2025.2,
#             Illinois_SGP_LONG_Data_2024_2025.2,
#             New_Jersey_SGP_LONG_Data_2024_2025.2,
#             Washington_DC_SGP_LONG_Data_2024_2025.2
#         ),
#         fill = TRUE,
#         use.names = TRUE
#     )

###   For individual state data formatting
assign("State_LONG_Data", Washington_DC_SGP_LONG_Data_2024_2025.2)
rm(Washington_DC_SGP_LONG_Data_2024_2025.2); gc()

# assign("PARCC_LONG_Data", PARCC_SGP_LONG_Data_2024_2025.2)
# rm(list = grep("2024_2025", ls(), value = TRUE)); gc()


#####
###          State Data
#####

###   Combine SGP_NOTE and SGP variables
##    'NA' or <1000 per Pearson 2025 Growth File Layout v1
#     table(State_LONG_Data[, is.na(SGP), SGP_NOTE], exclude = NULL)
State_LONG_Data[,
    SGP := as.character(SGP)
][is.na(SGP),
    SGP := SGP_NOTE
]

# No BASELINE specific NOTE. Make sure its only replacing NAs!
State_LONG_Data[,
    SGP_BASELINE := as.character(SGP_BASELINE)
][is.na(SGP_BASELINE),
    SGP_BASELINE := SGP_NOTE
]

###   Now remove NOTE - Kathy/Pat 8/14/19 -- Just kidding :/
###   JK re JK. LOL. -- 8/18/2022 Kathy.
State_LONG_Data[,
    SGP_NORM_GROUP := as.character(SGP_NORM_GROUP)
][!is.na(SGP_NOTE), SGP_NORM_GROUP := ""
][,
    SGP_NORM_GROUP_BASELINE := as.character(SGP_NORM_GROUP_BASELINE)
][!is.na(SGP_NOTE), SGP_NORM_GROUP_BASELINE := ""
]


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

setnames(
    State_LONG_Data,
    sgp.names[sgp.names %in% names(State_LONG_Data)],
    c("StudentIdentifier", "TestScaleScore", "TestCSEMProbableRange",
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
    )[sgp.names %in% names(State_LONG_Data)]
)


###   Split SGP_NORM_GROUP to create 'SGPPreviousTestCode*' Variables
state.tmp.split <-
    State_LONG_Data$SGP_NORM_GROUP |> as.character() |> strsplit("; ")

State_LONG_Data[,
    CONTENT_AREA_1PRIOR :=
        factor(sapply(sapply(
            strsplit(
                sapply(
                    strsplit(
                        sapply(state.tmp.split,
                            \(x) rev(x)[2]
                        ), "/"
                    ), "[", 2
                ), "_"
            ), head, -1
        ), paste, collapse = "_"
    ))
][, CONTENT_AREA_2PRIOR :=
        factor(sapply(sapply(
            strsplit(
                sapply(
                    strsplit(
                        sapply(state.tmp.split,
                            \(x) rev(x)[3]
                        ), "/"
                    ), "[", 2
                ), "_"
            ), head, -1
        ), paste, collapse = "_"
    ))
]

##    Check! - table(State_LONG_Data$CONTENT_AREA_1PRIOR)
# levels(State_LONG_Data$CONTENT_AREA_1PRIOR) <-
#     c(NA, "ALG01", "ALG02", "ELA", "ELA", "GEO01", "MAT", "MAT")
setattr(State_LONG_Data$CONTENT_AREA_1PRIOR, "levels",
        # c(NA, "ALG01", "ELA", "GEO01", "MAT")) # NJ, DoDEA, ALL
        c(NA, "ALG01", "ELA", "MAT")) # DC
        # c(NA, "ELA", "MAT")) # IL, BIE
# table(State_LONG_Data$CONTENT_AREA_2PRIOR)
setattr(State_LONG_Data$CONTENT_AREA_2PRIOR, "levels",
        # c(NA, "ALG01", "ELA", "MAT")) # NJ, DoDEA, ALL Consortium
        c(NA, "ELA", "MAT"))   #   The rest...

State_LONG_Data[,
    GRADE_1PRIOR :=
        sapply(
            strsplit(
                sapply(
                    strsplit(
                        sapply(state.tmp.split,
                            \(x) rev(x)[2]
                        ), "/"
                    ), "[", 2
                ), "_"
            ), tail, 1
        )
][  GRADE_1PRIOR == "EOCT", GRADE_1PRIOR := ""
][  GRADE_1PRIOR %in% 3:9, GRADE_1PRIOR := paste0("0", GRADE_1PRIOR)
][,
    GRADE_2PRIOR :=
        sapply(
            strsplit(
                sapply(
                    strsplit(
                        sapply(state.tmp.split,
                            \(x) rev(x)[3]
                        ), "/"
                    ), "[", 2
                ), "_"
            ), tail, 1
        )
][  GRADE_2PRIOR == "EOCT", GRADE_2PRIOR := ""
][  GRADE_2PRIOR %in% 3:9, GRADE_2PRIOR := paste0("0", GRADE_2PRIOR)
]

State_LONG_Data[,
    SGPPreviousTestCodeState :=
        factor(paste0(
            CONTENT_AREA_2PRIOR, GRADE_2PRIOR, ";", CONTENT_AREA_1PRIOR, GRADE_1PRIOR
        ))
][, SGPPreviousTestCodeState := gsub("NANA;|NANA$", "", SGPPreviousTestCodeState)
][, SGPPreviousTestCodeState1Prior := factor(paste0(CONTENT_AREA_1PRIOR, GRADE_1PRIOR))
][, SGPPreviousTestCodeState2Prior := factor(paste0(CONTENT_AREA_2PRIOR, GRADE_2PRIOR))
][, SGPPreviousTestCodeState1Prior := gsub("NANA", "", SGPPreviousTestCodeState1Prior)
][, SGPPreviousTestCodeState2Prior := gsub("NANA", "", SGPPreviousTestCodeState2Prior)
]
table(State_LONG_Data[, SGPPreviousTestCodeState1Prior, SGPPreviousTestCodeState])

###    Split SGP_NORM_GROUP_SCALE_SCORES to create 'SGPIRTThetaState*' Variables
state.score.split <-
    State_LONG_Data$SGP_NORM_GROUP_SCALE_SCORES |> as.character() |> strsplit("; ")

State_LONG_Data[,
    SGPIRTThetaState1Prior := as.numeric(sapply(state.score.split, \(x) rev(x)[2]))
][, SGPIRTThetaState2Prior := as.numeric(sapply(state.score.split, \(x) rev(x)[3]))
]

###   Compute and Format SGPTargetTestCodeState
State_LONG_Data[, SGPTargetTestCodeState := factor(SGPTargetTestCodeState)]
# levels(State_LONG_Data$SGPTargetTestCodeState) <-
#         c("MAT", "ELA", "MAT") # BIE - ALG01 targets not possible!
setattr(State_LONG_Data$SGPTargetTestCodeState, "levels",
        # c("ALG01", "ALG02", "ELA", "GEO01", "MAT")) # NJ, ALL
        # c("ALG02", "ELA", "GEO01", "MAT")) # DoDEA - odd year due to no 7th grade math priors
        c("ALG01", "ELA", "GEO01", "MAT")) # DC
        # c("ELA", "MAT")) # IL, BIE

State_LONG_Data[,
    SGPTargetTestCodeState := as.character(SGPTargetTestCodeState)
][ (SGPTargetTestCodeState %in% c("ELA", "MAT")),
    SGPTargetTestCodeState := paste0(SGPTargetTestCodeState, "0", as.numeric(GRADE) + 3)
][, SGPTargetTestCodeState := gsub("010", "10", SGPTargetTestCodeState)
][, SGPTargetTestCodeState := gsub("011|012|013|014", "10", SGPTargetTestCodeState)
] # Does anyone (BIE?) use 11th grade ELA in 2025 ???

##    Illinois only goes to grade 8 & BIE only has data for SGP calcs through Grade 8
State_LONG_Data[
  StateAbbreviation %in% c("IL", "BI"),
    SGPTargetTestCodeState := gsub("ELA09|ELA10|ELA11", "ELA08", SGPTargetTestCodeState)
][StateAbbreviation %in% c("IL", "BI"),
    SGPTargetTestCodeState := gsub("MAT09|MAT10|MAT11", "MAT08", SGPTargetTestCodeState)
]
##    Non-IL States
State_LONG_Data[
  StateAbbreviation != "IL",
    SGPTargetTestCodeState := gsub("MAT09", "ALG01", SGPTargetTestCodeState)
][StateAbbreviation != "IL",
    SGPTargetTestCodeState := gsub("MAT10", "GEO01", SGPTargetTestCodeState)
][StateAbbreviation != "IL",
    SGPTargetTestCodeState := gsub("MAT11", "ALG02", SGPTargetTestCodeState)
]
##    DoDEA & NJ
State_LONG_Data[
  StateAbbreviation %in% c("DD"),
    SGPTargetTestCodeState := gsub("ELA11", "ELA10", SGPTargetTestCodeState)
][StateAbbreviation %in% c("NJ"),
    SGPTargetTestCodeState := gsub("ELA11|ELA10", "ELA09", SGPTargetTestCodeState)
]

table(State_LONG_Data[, SGPTargetTestCodeState, TestCode], exclude = NULL)
table(State_LONG_Data[, SGPTargetTestCodeState, StateAbbreviation])


####  For individual state data formatting
State_LONG_Data[,
    grep("Consortia", center.var.names, value = TRUE) := as.character(NA)
][, center.var.names[!center.var.names %in% names(State_LONG_Data)] :=
      as.character(NA)
]
####  END  For individual state data formatting


###   Re-order AND subset columns of State_LONG_Data
State_LONG_Data <-
    State_LONG_Data[,
        names(State_LONG_Data)[names(State_LONG_Data) %in% all.var.names],
        with = FALSE
    ]


####  SKIP CONSORTIUM STEP For individual state data formatting


#####
###          Consortium Data
#####

# ###   Combine SGP_NOTE and SGP variables
# PARCC_LONG_Data[,
#     SGP := as.character(SGP)
# ][which(is.na(SGP)),
#     SGP := SGP_NOTE
# ]

# ##     No BASELINE specific NOTE.  Make sure its only replacing NAs!
# # table(PARCC_LONG_Data[, is.na(SGP_BASELINE), SGP_NOTE], exclude = NULL)
# PARCC_LONG_Data[,
#     SGP_BASELINE := as.character(SGP_BASELINE)
# ][is.na(SGP_BASELINE),
#     SGP_BASELINE := SGP_NOTE
# ]

# ###   Now remove NOTE - Kathy/Pat 8/14/19 -- Just kidding :/
# ###   JK re JK. LOL. -- 8/18/2022 Kathy.  SMH FML IHTG
# PARCC_LONG_Data[,
#     SGP_NORM_GROUP := as.character(SGP_NORM_GROUP)
# ][!is.na(SGP_NOTE),
#     SGP_NORM_GROUP := ""
# ]

# PARCC_LONG_Data[,
#     SGP_NORM_GROUP_BASELINE := as.character(SGP_NORM_GROUP_BASELINE)
# ][!is.na(SGP_NOTE),
#     SGP_NORM_GROUP_BASELINE := ""
# ]

# ###   Change relevant SGP package convention names to Pearson's names
# setnames(PARCC_LONG_Data,
#     c("ID", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_CSEM_ACTUAL",
#       "SCALE_SCORE", "SCALE_SCORE_CSEM", "SGP", "SGP_0.05_CONFIDENCE_BOUND",
#       "SGP_0.95_CONFIDENCE_BOUND", "SGP_STANDARD_ERROR", "SGP_ORDER_1",
#       "SGP_ORDER_1_0.05_CONFIDENCE_BOUND", "SGP_ORDER_1_0.95_CONFIDENCE_BOUND",
#       "SGP_ORDER_1_STANDARD_ERROR", "SGP_ORDER_2",
#       "SGP_ORDER_2_0.05_CONFIDENCE_BOUND", "SGP_ORDER_2_0.95_CONFIDENCE_BOUND",
#       "SGP_ORDER_2_STANDARD_ERROR", "SGP_SIMEX_RANKED",
#       "SGP_SIMEX_RANKED_ORDER_1", "SGP_SIMEX_RANKED_ORDER_2",
#       "SGP_TARGET_3_YEAR", "SGP_TARGET_3_YEAR_CONTENT_AREA",
#       "SGP_BASELINE", "SGP_SIMEX_BASELINE", "SGP_TARGET_BASELINE_3_YEAR"
#     ),
#     c("PANUniqueStudentID", "SummativeScaleScore", "SummativeCSEM",
#       "IRTTheta", "ThetaSEM", "StudentGrowthPercentileComparedtoConsortia",
#       "SGPLowerBoundConsortia", "SGPUpperBoundConsortia",
#       "SGPStandardErrorConsortia",
#       "StudentGrowthPercentileComparedtoConsortia1Prior",
#       "SGPLowerBoundConsortia1Prior", "SGPUpperBoundConsortia1Prior",
#       "SGPStandardErrorConsortia1Prior",
#       "StudentGrowthPercentileComparedtoConsortia2Prior",
#       "SGPLowerBoundConsortia2Prior", "SGPUpperBoundConsortia2Prior",
#       "SGPStandardErrorConsortia2Prior", "SGPRankedSimexConsortia",
#       "SGPRankedSimexConsortia1Prior", "SGPRankedSimexConsortia2Prior",
#       "SGPTargetConsortia", "SGPTargetTestCodeConsortia",
#       "StudentGrowthPercentileComparedtoConsortiaBaseline",
#       "SGPRankedSimexConsortiaBaseline", "SGPTargetConsortiaBaseline"
#     )
# )

# ###   Split SGP_NORM_GROUP to create 'SGPPreviousTestCode*' Variables
# parcc.tmp.split <- strsplit(as.character(PARCC_LONG_Data$SGP_NORM_GROUP), "; ")

# PARCC_LONG_Data[,
#     CONTENT_AREA_1PRIOR :=
#         factor(
#             sapply(
#                 sapply(
#                     strsplit(
#                         sapply(
#                             strsplit(
#                                 sapply(parcc.tmp.split,
#                                     \(x) rev(x)[2]
#                                 ), "/"
#                             ), "[", 2
#                         ), "_"
#                     ), head, -1
#                 ), paste, collapse = "_"
#             )
#         )
# ][, CONTENT_AREA_2PRIOR :=
#         factor(
#             sapply(
#                 sapply(
#                     strsplit(
#                         sapply(
#                             strsplit(
#                                 sapply(parcc.tmp.split,
#                                     \(x) rev(x)[3]
#                                 ), "/"
#                             ), "[", 2
#                         ), "_"
#                     ), head, -1
#                 ), paste, collapse = "_"
#             )
#         )
# ]

# setattr(PARCC_LONG_Data$CONTENT_AREA_1PRIOR,
#         "levels", c(NA, "ALG01", "ELA", "GEO01", "MAT")) # "ALG02",
# setattr(PARCC_LONG_Data$CONTENT_AREA_2PRIOR,
#         "levels", c(NA, "ALG01", "ELA", "MAT"))

# PARCC_LONG_Data[,
#     GRADE_1PRIOR :=
#         sapply(
#             strsplit(
#                 sapply(
#                     strsplit(
#                         sapply(parcc.tmp.split,
#                             \(x) rev(x)[2]
#                         ), "/"
#                     ), "[", 2
#                 ), "_"
#             ), tail, 1
#         )
# ][
#     GRADE_1PRIOR == "EOCT", GRADE_1PRIOR := ""
# ][  GRADE_1PRIOR %in% 3:9,  GRADE_1PRIOR := paste0("0", GRADE_1PRIOR)
# ][,
#     GRADE_2PRIOR :=
#         sapply(
#             strsplit(
#                 sapply(
#                     strsplit(
#                         sapply(parcc.tmp.split,
#                                \(x) rev(x)[3]
#                         ), "/"
#                     ), "[", 2
#                 ), "_"
#             ), tail, 1
#         )
# ][  GRADE_2PRIOR == "EOCT", GRADE_2PRIOR := ""
# ][  GRADE_2PRIOR %in% 3:9,  GRADE_2PRIOR := paste0("0", GRADE_2PRIOR)]
# # table(PARCC_LONG_Data[, GRADE_1PRIOR, CONTENT_AREA_1PRIOR])

# PARCC_LONG_Data[,
#     SGPPreviousTestCodeConsortia :=
#         factor(paste0(
#             CONTENT_AREA_2PRIOR, GRADE_2PRIOR, ";", CONTENT_AREA_1PRIOR, GRADE_1PRIOR
#         ))
# ][, SGPPreviousTestCodeConsortia := gsub("NANA;|NANA$", "", SGPPreviousTestCodeConsortia)
# ][, SGPPreviousTestCodeConsortia1Prior := factor(paste0(CONTENT_AREA_1PRIOR, GRADE_1PRIOR))
# ][, SGPPreviousTestCodeConsortia1Prior := gsub("NANA", "", SGPPreviousTestCodeConsortia1Prior)
# ][, SGPPreviousTestCodeConsortia2Prior := factor(paste0(CONTENT_AREA_2PRIOR, GRADE_2PRIOR))
# ][, SGPPreviousTestCodeConsortia2Prior := gsub("NANA", "", SGPPreviousTestCodeConsortia2Prior)
# ]
# # table(PARCC_LONG_Data[,
# #     SGPPreviousTestCodeConsortia1Prior, SGPPreviousTestCodeConsortia])

# ###   Split SGP_NORM_GROUP_SCALE_SCORES for 'SGPIRTThetaConsortia*' Variables
# parcc.score.split <-
#     strsplit(as.character(PARCC_LONG_Data$SGP_NORM_GROUP_SCALE_SCORES), "; ")
# PARCC_LONG_Data[,
#     SGPIRTThetaConsortia1Prior :=
#         as.numeric(
#             sapply(parcc.score.split, \(x) rev(x)[2])
#         )
# ][, SGPIRTThetaConsortia2Prior :=
#         as.numeric(
#             sapply(parcc.score.split, \(x) rev(x)[3])
#         )
# ][, # Compute and Format SGPTargetTestCodeConsortia
#     SGPTargetTestCodeConsortia := factor(SGPTargetTestCodeConsortia)
# ]
# setattr(PARCC_LONG_Data$SGPTargetTestCodeConsortia,
#         "levels",  c("ALG01", "ALG02", "ELA", "GEO01", "MAT"))
# # No INTEGRATED_MATH_* as of 2019
# PARCC_LONG_Data[,
#     SGPTargetTestCodeConsortia := as.character(SGPTargetTestCodeConsortia)
# ][(SGPTargetTestCodeConsortia %in% c("ELA", "MAT")),
#     SGPTargetTestCodeConsortia := paste0(SGPTargetTestCodeConsortia, "0", as.numeric(GRADE) + 3)
# ][, SGPTargetTestCodeConsortia := gsub("010", "10", SGPTargetTestCodeConsortia)
# ][, SGPTargetTestCodeConsortia := gsub("011|012|013|014", "11", SGPTargetTestCodeConsortia)
# ][, SGPTargetTestCodeConsortia := gsub("MAT09", "ALG01", SGPTargetTestCodeConsortia)
# ][, SGPTargetTestCodeConsortia := gsub("MAT10", "GEO01", SGPTargetTestCodeConsortia)
# ][, SGPTargetTestCodeConsortia := gsub("MAT11", "ALG02", SGPTargetTestCodeConsortia)
# ]
# # table(PARCC_LONG_Data[, SGPTargetTestCodeConsortia, TestCode])

# ###  Re-order AND subset columns of PARCC_LONG_Data
# PARCC_LONG_Data <-
#     PARCC_LONG_Data[,
#         names(PARCC_LONG_Data)[
#             names(PARCC_LONG_Data) %in% all.var.names
#         ],
#         with = FALSE
#     ]

#####
###   Merge Consortia and State Data
#####

####  For individual state data formatting
FINAL_LONG_Data <- copy(State_LONG_Data)
####  For individual state data formatting

State_LONG_Data[, TestCSEMProbableRange := as.numeric(TestCSEMProbableRange)]
State_LONG_Data[, TestScaleScore := as.numeric(TestScaleScore)]

####  SKIP THIS STEP For individual state data formatting
###   Re-align IDs temporarily for merge
# State_LONG_Data[, TEMP_ID := PANUniqueStudentID]
# State_LONG_Data[
#     StateAbbreviation %in% c("BI", "DC", "IL"),
#     TEMP_ID := StudentIdentifier
# ]
# setnames(PARCC_LONG_Data, "PANUniqueStudentID", "TEMP_ID")

# FINAL_LONG_Data <-
#     merge(PARCC_LONG_Data, State_LONG_Data,
#           by = intersect(names(PARCC_LONG_Data), names(State_LONG_Data)),
#           all.x = TRUE
#     )
# grep("[.]x|[.]y", names(FINAL_LONG_Data), value = TRUE)
####  END SKIP For individual state data formatting

###  Fix EXACT_DUPLICATEs  (None in Spring 2019, 2021, 2022, 2024, [2025? - TBD])
FINAL_LONG_Data[EXACT_DUPLICATE == 2, (center.var.names) :=
    FINAL_LONG_Data[EXACT_DUPLICATE == 1, center.var.names, with = FALSE]
]
FINAL_LONG_Data[, EXACT_DUPLICATE := NULL]

##   Coordinate missing SGP notes for small N states
##   Now remove NOTE - Kathy/Pat 8/14/19 -- Just kidding :/
FINAL_LONG_Data[
    which(is.na(StudentGrowthPercentileComparedtoState) &
        StudentGrowthPercentileComparedtoConsortia == "<1000"),
    SGPPreviousTestCodeState := SGPPreviousTestCodeConsortia
][
    which(is.na(StudentGrowthPercentileComparedtoState) &
        StudentGrowthPercentileComparedtoConsortia == "<1000"),
    StudentGrowthPercentileComparedtoState := "<1000"
]

##   Per 2024 'Growth Layout' file:  "If no match is found in both
##   assessment years (any period) for the PARCC ID then report 'NA'."

#    'Max Order/Best' SGPs already converted to character to include SGP_NOTE:
FINAL_LONG_Data[
  which(is.na(StudentGrowthPercentileComparedtoState)),
    StudentGrowthPercentileComparedtoState := "NA"
][which(is.na(StudentGrowthPercentileComparedtoStateBaseline)),
    StudentGrowthPercentileComparedtoStateBaseline := "NA"
][which(is.na(StudentGrowthPercentileComparedtoConsortia)),
    StudentGrowthPercentileComparedtoConsortia := "NA"
][which(is.na(StudentGrowthPercentileComparedtoConsortiaBaseline)),
    StudentGrowthPercentileComparedtoConsortiaBaseline := "NA"
]

##    Convert order specific SGPs to `character` first, then insert 'NA's
FINAL_LONG_Data[,
    StudentGrowthPercentileComparedtoState1Prior :=
        as.character(StudentGrowthPercentileComparedtoState1Prior)
][which(is.na(StudentGrowthPercentileComparedtoState1Prior)),
    StudentGrowthPercentileComparedtoState1Prior := "NA"
][, StudentGrowthPercentileComparedtoState2Prior :=
        as.character(StudentGrowthPercentileComparedtoState2Prior)
][which(is.na(StudentGrowthPercentileComparedtoState2Prior)),
    StudentGrowthPercentileComparedtoState2Prior := "NA"
][,
    StudentGrowthPercentileComparedtoConsortia1Prior :=
        as.character(StudentGrowthPercentileComparedtoConsortia1Prior)
][which(is.na(StudentGrowthPercentileComparedtoConsortia1Prior)),
    StudentGrowthPercentileComparedtoConsortia1Prior := "NA"
][, StudentGrowthPercentileComparedtoConsortia2Prior :=
        as.character(StudentGrowthPercentileComparedtoConsortia2Prior)
][which(is.na(StudentGrowthPercentileComparedtoConsortia2Prior)),
    StudentGrowthPercentileComparedtoConsortia2Prior := "NA"
]


###   Make sure no exact duplicates remain.
setkey(FINAL_LONG_Data,
       StudentIdentifier, StudentTestUUID, TestCode, TestScaleScore)
setkey(FINAL_LONG_Data,
       StudentIdentifier, StudentTestUUID, TestCode)
dups <- duplicated(FINAL_LONG_Data, by = key(FINAL_LONG_Data))
table(dups) # Should be FALSE
findups <- FINAL_LONG_Data[c(which(dups) - 1, which(dups)), ]
nrow(findups) # Should be 0 rows!

# everything except "EXACT_DUPLICATE"
# final.vars <- all.var.names[-which(all.var.names == "EXACT_DUPLICATE")]
setcolorder(FINAL_LONG_Data, final.vars)


###   Format IRTTheta variables
FINAL_LONG_Data[,
    IRTTheta := format(IRTTheta, scientific = FALSE, trim = TRUE)
][, SGPIRTThetaState1Prior :=
        format(SGPIRTThetaState1Prior, scientific = FALSE, trim = TRUE)
][, SGPIRTThetaState2Prior :=
        format(SGPIRTThetaState2Prior, scientific = FALSE, trim = TRUE)
][,
    SGPIRTThetaConsortia1Prior :=
        format(SGPIRTThetaConsortia1Prior, scientific = FALSE, trim = TRUE)
][, SGPIRTThetaConsortia2Prior :=
        format(SGPIRTThetaConsortia2Prior, scientific = FALSE, trim = TRUE)
]

##    Clean up NAs after cleanup - NAs formatted as "      NA"
# table(FINAL_LONG_Data[, grepl("NA", SGPIRTThetaState1Prior)])
FINAL_LONG_Data[
  grep("NA", SGPIRTThetaState1Prior), SGPIRTThetaState1Prior := NA
][grep("NA", SGPIRTThetaState2Prior), SGPIRTThetaState2Prior := NA
]

# table(FINAL_LONG_Data[, grepl("NA", SGPIRTThetaConsortia1Prior)])
FINAL_LONG_Data[
  grep("NA", SGPIRTThetaConsortia1Prior), SGPIRTThetaConsortia1Prior := NA
][grep("NA", SGPIRTThetaConsortia2Prior), SGPIRTThetaConsortia2Prior := NA
]


###   Final data QC checks
FINAL_LONG_Data[,
    as.list(summary(as.numeric(StudentGrowthPercentileComparedtoState))),
    keyby = "TestCode"
]
FINAL_LONG_Data[,
    as.list(summary(as.numeric(StudentGrowthPercentileComparedtoStateBaseline))),
    keyby = "TestCode"
]
FINAL_LONG_Data[,
    as.list(summary(as.numeric(SGPRankedSimexState))),
    keyby = "TestCode"
]
FINAL_LONG_Data[,
    as.list(summary(as.numeric(SGPRankedSimexStateBaseline))),
    keyby = "TestCode"
]
table(FINAL_LONG_Data[, SGPPreviousTestCodeState1Prior, TestCode]) |>
    prop.table(1) |> round(3)*100 -> tt; tt[tt == 0] <- ""; print(tt) # calc rate
# table(FINAL_LONG_Data[
#     TestCode == "ELA10" & SGPPreviousTestCodeState1Prior == "ELA08",
#     StateAbbreviation]) # DD
# FINAL_LONG_Data[TestCode == "ELA10" & SGPPreviousTestCodeState1Prior == "ELA08",
#     as.list(summary(as.numeric(StudentGrowthPercentileComparedtoState))),
#     keyby = "StateAbbreviation"] # DD
# # table(FINAL_LONG_Data[
#     # TestCode == "GEO01" & SGPPreviousTestCodeState1Prior == "MAT08",
#     # StateAbbreviation])
# FINAL_LONG_Data[TestCode == "GEO01",
#     as.list(summary(as.numeric(StudentGrowthPercentileComparedtoState))),
#     keyby = "StateAbbreviation"
# ]
# tbl <-
#     FINAL_LONG_Data[grep("ELA04|ELA05|ELA06|ELA07|ELA08", TestCode),
#         as.list(summary(as.numeric(StudentGrowthPercentileComparedtoState))),
#         keyby = c("StateAbbreviation", "TestCode")]

# ###   Consortium
# FINAL_LONG_Data[,
#     as.list(summary(as.numeric(StudentGrowthPercentileComparedtoConsortia))),
#     keyby = "TestCode"
# ]
# FINAL_LONG_Data[,
#     as.list(summary(as.numeric(StudentGrowthPercentileComparedtoConsortiaBaseline))),
#     keyby = "TestCode"
# ]
# FINAL_LONG_Data[,
#     as.list(summary(as.numeric(SGPRankedSimexConsortia))),
#     keyby = "TestCode"
# ]
# FINAL_LONG_Data[,
#     as.list(summary(as.numeric(SGPRankedSimexConsortiaBaseline))),
#     keyby = "TestCode"
# ]
# table(FINAL_LONG_Data[, SGPPreviousTestCodeConsortia1Prior, TestCode])
# table(FINAL_LONG_Data[
#         TestCode == "ELA10" & SGPPreviousTestCodeConsortia1Prior == "ELA08",
#         StateAbbreviation])
# # table(FINAL_LONG_Data[
# #         TestCode == "GEO01" & SGPPreviousTestCodeConsortia1Prior == "MAT08",
# #         StateAbbreviation])
# FINAL_LONG_Data[
#     TestCode == "ELA10" & SGPPreviousTestCodeConsortia1Prior == "ELA08",
#       as.list(summary(as.numeric(StudentGrowthPercentileComparedtoConsortia))),
#       keyby = "StateAbbreviation"]
# FINAL_LONG_Data[TestCode == "GEO01",
#     as.list(
#         summary(as.numeric(StudentGrowthPercentileComparedtoConsortia))
#     ),
#     keyby = "StateAbbreviation"
# ]
# tbl <-
#     FINAL_LONG_Data[grep("ELA04|ELA05|ELA06|ELA07|ELA08", TestCode),
#         as.list(
#             summary(as.numeric(StudentGrowthPercentileComparedtoConsortia))
#         ),
#         keyby = c("StateAbbreviation", "TestCode")
#     ]


#####
###   Save R object and Export/zip State specific .csv files
#####

####  For individual state data formatting
# abv <- "DC"
fname <-
    paste0("./",
        gsub(" ", "_", SGP:::getStateAbbreviation(abv, type = "state")),
        "/Data/Pearson/", abv,
        "_Spring_2025_SGP-STATE_LEVEL_Results_",
        format(Sys.Date(), format = "%Y%m%d"), ".csv"
    )
if (abv == "DD") fname <- gsub("_of_", "_Of_", fname) # DoDEA folder name

options(scipen = 999)

##    Use `write.csv` - `fwrite` had bug with number of printed digits
write.csv(FINAL_LONG_Data[, ..final.vars], fname, row.names = FALSE, na = "")
# [StudentIdentifier %in% sample(StudentIdentifier, 100) &
# StateAbbreviation == abv & GradeLevelWhenAssessed %in% c("05", "08"), ]

zip(zipfile = paste0(fname, ".zip"), files = fname, flags = "-mqj")
###  END For individual state data formatting


####  Loop on State Abbreviation to write out each state file in
####  format that it was received and requested for return

# tmp.wd <- getwd()
# options(scipen = 999)
# for (abv in unique(FINAL_LONG_Data$StateAbbreviation)) {
#     fname <-
#         paste0("./",
#                 gsub(" ", "_", SGP:::getStateAbbreviation(abv, type = "state")),
#                 "/Data/Pearson/", abv, "_Spring_2025_SGP-Results_",
#                 format(Sys.Date(), format = "%Y%m%d"), ".csv")
#     if (abv == "DD") fname <- gsub("_of_", "_Of_", fname) # DoDEA folder name
#     if (!abv %in% c("DC", "DD", "BI")) {
#         tmp.vars <- final.vars[
#             !final.vars %in% c("EXACT_DUPLICATE", addl.new.names)]
#     } else {
#         tmp.vars <- final.vars # [!all.var.names %in% "EXACT_DUPLICATE"]
#     }

#     ##  Align DC & BIE names with the original (submitted) data
#     if (abv %in% c("DC", "BI")) {
#         TMP_Data_2025 <- FINAL_LONG_Data[StateAbbreviation == abv, ..tmp.vars]
#         setnames(TMP_Data_2025,
#             c("PANUniqueStudentID", "SummativeScaleScore", "SummativeCSEM",
#             # "TestingLocation", "LearningOption", # Not changed in BIE 2025
#             "StateStudentIdentifier",
#             "AccountableDistrictCode", "AccountableDistrictName",
#             "AccountableSchoolCode", "AccountableSchoolName",
#             "Sex", "customerReferenceId"),
#     # Mispelling in DC - "StudentIndentifier" in the original
#             c("StudentUniqueUuid", "TestScaleScore", "TestCSEMProbableRange",
#             #   "Filler51", "Filler52",
#               ifelse(abv == "DC", "StudentIndentifier", "StudentIdentifier"),
#               "ReportingDistrictCode", "ReportingDistrictName",
#               "ReportingSchoolCode", "ReportingSchoolName",
#               "Gender", "CustomerRefID")
#         )
#         write.csv(TMP_Data_2025, fname, row.names = FALSE, na = "")
#     } else {
#         ##    Use `write.csv` - `fwrite` had bug with number of printed digits
#         write.csv(FINAL_LONG_Data[StateAbbreviation == abv, ..tmp.vars],
#                   fname, row.names = FALSE, na = "")
#     }

#     zip(zipfile = paste0(fname, ".zip"), files = fname, flags = "-mqj")
#     # -mq doesn't leave a csv copy. j "junks" the directory structure (tree)
#     message("Finished with ", SGP:::getStateAbbreviation(abv, type = "state"))
# }

####  END State Abbreviation (ALL) Loop
