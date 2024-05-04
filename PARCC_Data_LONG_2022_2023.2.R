##############################################################################
###                                                                        ###
###     Create Individual State LONG Data for Spring 2023 SGP Analyses     ###
###                                                                        ###
##############################################################################

###   Set working directory to top level directory (PARCC)

###   Load required packages
require(SGP)
require(data.table)

fletch <-
    function(.data,
             output.dir = ".",
             partitions = "YEAR",
             ...) {
        if (!"ArrowObject" %in% class(.data)) {
            .data <- arrow::arrow_table(.data)
        }
        arrow::write_dataset(
            dataset = .data,
            path = output.dir,
            partitioning = partitions,
            compression = "gzip",
            ...
        )
    }


#####
###   Read in Spring 2023 Pearson base data
#####

###   Set names based on Pearson file layout
pearson.var.names <- c(
    "AssessmentYear", "StateAbbreviation", "PANUniqueStudentID",
    "GradeLevelWhenAssessed", "Period", "TestCode", "TestFormat",
    "SummativeScoreRecordUUID", "StudentTestUUID", "SummativeScaleScore",
    "IRTTheta", "SummativeCSEM", "ThetaSEM", "FormID", "TestingLocation",
    "LearningOption", "StateStudentIdentifier", "LocalStudentIdentifier",
    "TestingDistrictCode", "TestingDistrictName", "TestingSchoolCode",
    "TestingSchoolName", "AccountableDistrictCode", "AccountableDistrictName",
    "AccountableSchoolCode", "AccountableSchoolName", "Sex",
    "HispanicOrLatinoEthnicity", "AmericanIndianOrAlaskaNative", "Asian",
    "BlackOrAfricanAmerican", "NativeHawaiianOrOtherPacificIslander", "White",
    "FederalRaceEthnicity", "TwoOrMoreRaces", "EnglishLearnerEL",
    "MigrantStatus", "GiftedAndTalented", "EconomicDisadvantageStatus",
    "StudentWithDisabilities")

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
    "SGPPreviousTestCodeConsortia1Prior", "SGPPreviousTestCodeConsortia2Prior",
    "SGPUpperBoundState", "SGPUpperBoundState1Prior",
    "SGPUpperBoundState2Prior", "SGPLowerBoundState",
    "SGPLowerBoundState1Prior", "SGPLowerBoundState2Prior",
    "SGPUpperBoundConsortia", "SGPUpperBoundConsortia1Prior",
    "SGPUpperBoundConsortia2Prior", "SGPLowerBoundConsortia",
    "SGPLowerBoundConsortia1Prior", "SGPLowerBoundConsortia2Prior",
    "SGPStandardErrorState", "SGPStandardErrorState1Prior",
    "SGPStandardErrorState2Prior", "SGPStandardErrorConsortia",
    "SGPStandardErrorConsortia1Prior", "SGPStandardErrorConsortia2Prior",
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
                   pearson.var.names[15:40])  #  Added in 2021

##    Two additional variables for BIE & DoDEA
addl.bie.dd.names <- c("customerReferenceId", "testAdminReferenceId", "growthIdentifier")
all.var.names <- c(all.var.names, addl.bie.dd.names)
bie.dd.var.names <- c(pearson.var.names, addl.bie.dd.names)


###   Read in spring 2023 data by state
# TMP_Data_2023 <- fread(
#     "./New_Jersey/Data/Base_Files/PARCC_NJ_2022-2023_SGPO_D20230711.csv.gz",
#     colClasses = rep("character", 90))[, ..pearson.var.names]
# TMP_Data_2023 <-
#     fread("./Bureau_of_Indian_Education/Data/Base_Files/pcspr23_state_Student_Growth_20230626175141729589.csv",
#           colClasses = rep("character", length(all.var.names)))[, ..bie.dd.var.names]
TMP_Data_2023 <-
    fread("./Department_Of_Defense/Data/Base_Files/pcspr23_state_Student_Growth_20230725165129502783.csv",
          colClasses = rep("character", length(all.var.names)))[, ..bie.dd.var.names]
# TMP_Data_2023 <- fread(
#     "./Illinois/Data/Base_Files/PARCC_IL_2022-2023_SGPO_D20230516.csv.gz",
#     colClasses = rep("character", 90))[, ..pearson.var.names]
# TMP_Data_2023 <- fread(
#     "./Washington_DC/Data/Base_Files/PARCC_DC_2022-2023_SGPO_D20230619.csv.gz",
#     colClasses = rep("character", 90))[, ..pearson.var.names]


setkey(TMP_Data_2023, PANUniqueStudentID, TestCode, Period)


#####
###   Data Cleaning  -  Create Required SGP Variables
#####

###   ID
##    BIE & DoDEA use `growthIdentifier` as of '23 -- change in formatting script
setnames(TMP_Data_2023, "PANUniqueStudentID", "ID")

###   CONTENT_AREA from TestCode
TMP_Data_2023[, CONTENT_AREA := factor(TestCode)]
table(TMP_Data_2023$CONTENT_AREA)
setattr(TMP_Data_2023$CONTENT_AREA, "levels",
        # c("ALGEBRA_I", "ALGEBRA_II", rep("ELA", 8),  #   DC
        #   "GEOMETRY", rep("MATHEMATICS", 6)))
        # c("ALGEBRA_I", "ALGEBRA_II", rep("ELA", 7), #   NJ
        #   "GEOMETRY", rep("MATHEMATICS", 6)))
        # c("ALGEBRA_I", "ALGEBRA_II", rep("ELA", 7),   #   BI
        #   "GEOMETRY", rep("MATHEMATICS", 6),
        #   "INTEGRATED_MATH_1", "INTEGRATED_MATH_2"))
        c("ALGEBRA_I", "ALGEBRA_II", rep("ELA", 7),   #   DoDEA
          "GEOMETRY", rep("MATHEMATICS", 6)))
        # c(rep("ELA", 6), rep("MATHEMATICS", 6)))      #   IL
TMP_Data_2023[, CONTENT_AREA := as.character(CONTENT_AREA)]

###   GRADE from TestCode
TMP_Data_2023[, GRADE := gsub("ELA|MAT", "", TestCode)]
TMP_Data_2023[, GRADE := as.character(as.numeric(GRADE))]
TMP_Data_2023[which(is.na(GRADE)), GRADE := "EOCT"]
TMP_Data_2023[, GRADE := as.character(GRADE)]
table(TMP_Data_2023[, GRADE, TestCode], exclude = NULL)

###   YEAR
TMP_Data_2023[, YEAR := gsub("-", "_", AssessmentYear)]
TMP_Data_2023[which(Period == "Spring"), YEAR := paste0(YEAR, ".2")]


###   Theta - create IRT CSEM
scaling.constants <- as.data.table(read.csv(
    "./PARCC/Data/Base_Files/2015-2016 PARCC Scaling Constants.csv"))
setkey(scaling.constants, CONTENT_AREA, GRADE)
setkey(TMP_Data_2023, CONTENT_AREA, GRADE)
TMP_Data_2023 <- scaling.constants[TMP_Data_2023]

TMP_Data_2023[, SCALE_SCORE_CSEM := (as.numeric(SummativeCSEM)) / a]
# summary(TMP_Data_2023[, as.numeric(IRTTheta)])

TMP_Data_2023[, c("a", "b", "ThetaSEM") := NULL]

setnames(TMP_Data_2023,
        c("IRTTheta", "SummativeScaleScore", "SummativeCSEM"),
        c("SCALE_SCORE", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_CSEM_ACTUAL")
)


###   Valid Cases
TMP_Data_2023[, VALID_CASE := "VALID_CASE"]

###   Invalidate Cases with missing IDs - 0 invalid in FINAL data
TMP_Data_2023[ID == "", VALID_CASE := "INVALID_CASE"] #|is.na(ID)

###   ACHIEVEMENT_LEVEL
TMP_Data_2023 <- SGP:::getAchievementLevel(TMP_Data_2023, state = "PARCC")

table(TMP_Data_2023[, ACHIEVEMENT_LEVEL, CONTENT_AREA], exclude = NULL)# |> prop.table(1) |> round(3) *100

#####
###   Duplicates -- DON'T FIX DUPLICATES!  Per email from Pat Taylor 7/18/16
#####

###   Exact duplicates still need to be dealt with (if present)
TMP_Data_2023[, EXACT_DUPLICATE := as.numeric(NA)]

setkey(TMP_Data_2023,
    VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID, SCALE_SCORE_ACTUAL, SCALE_SCORE)
dupl <- duplicated(TMP_Data_2023, by = key(TMP_Data_2023))
dups <- TMP_Data_2023[c(which(dupl)-1, which(dupl)), ]
setkeyv(dups, key(TMP_Data_2023))

TMP_Data_2023[which(dupl)-1, EXACT_DUPLICATE := 1]
TMP_Data_2023[which(dupl), EXACT_DUPLICATE := 2]
TMP_Data_2023[which(dupl), VALID_CASE := "INVALID_CASE"]

###   Final reformat of some variables
TMP_Data_2023[, GRADE := as.character(GRADE)]
TMP_Data_2023[, SCALE_SCORE := as.numeric(SCALE_SCORE)]
TMP_Data_2023[, SCALE_SCORE_CSEM := as.numeric(SCALE_SCORE_CSEM)]
TMP_Data_2023[, SCALE_SCORE_ACTUAL := as.numeric(SCALE_SCORE_ACTUAL)]
TMP_Data_2023[, SCALE_SCORE_CSEM_ACTUAL := as.numeric(SCALE_SCORE_CSEM_ACTUAL)]

###   Save Spring 2023 individual states LONG data
# fletch(
#     TMP_Data_2023,
#     output.dir = "./Data/Arrow_SGP/LONG",
#     partitions = c("StateAbbreviation", "YEAR"),
#     existing_data_behavior = "overwrite"
# )

dir.create("./Department_Of_Defense/Data/Archive/2022_2023.2", recursive = TRUE)
assign("Department_of_Defense_Data_LONG_2022_2023.2", TMP_Data_2023)
save(Department_of_Defense_Data_LONG_2022_2023.2,
     file = file.path("Department_Of_Defense/Data/Archive/2022_2023.2",
                      "Department_of_Defense_Data_LONG_2022_2023.2.Rdata")
)


#####
###   "Optional" variables for IL according to Growth Layout (v1)
#####

# table(TMP_Data_2023[, LearningOption], exclude = NULL)
# table(TMP_Data_2023[, TestingLocation], exclude = NULL)
