################################################################################
###                                                                          ###
###  Merge IL, BI and DD student info from 2018, 2019 & 2020 with SGP @Data  ###
###                                                                          ###
################################################################################

### Load required packages

require(SGP)
require(data.table)

###  Set working directory to top level (PARCC) directory

####   Load formatted and cleaned student info files
load("./Illinois/Data/IL_Student_Info.rda")
load("./Department_Of_Defense/Data/DOD_Student_Info.rda")
load("./Bureau_of_Indian_Education/Data/BIE_Student_Info.rda")

PARCC_Student_Info <- rbindlist(list(BIE_Student_Info, DOD_Student_Info, IL_Student_Info))

###   2021 student info names and order:
var_name_and_order_2021 <- c(
  "YEAR", "ID", "StudentTestUUID", # "IRTTheta", # Merge/key vars. Don't merge on score
  "FormID", "TestingLocation", "LearningOption",
  "StateStudentIdentifier", "LocalStudentIdentifier",
  "TestingDistrictCode", "TestingDistrictName",
  "TestingSchoolCode", "TestingSchoolName",
  "AccountableDistrictCode", "AccountableDistrictName",
  "AccountableSchoolCode", "AccountableSchoolName",
  "Sex", "HispanicOrLatinoEthnicity", "AmericanIndianOrAlaskaNative", "Asian",
  "BlackOrAfricanAmerican", "NativeHawaiianOrOtherPacificIslander", "White",
  "FederalRaceEthnicity", "TwoOrMoreRaces", "EnglishLearnerEL", "MigrantStatus",
  "GiftedAndTalented", "EconomicDisadvantageStatus", "StudentWithDisabilities")

###   Merge student info with PARCC_SGP@Data (post 2020 data addition and analysis)
load("./PARCC/Data/Archive/2019_2020.2/PARCC_SGP.Rdata")

PARCC_SGP@Data[, FormID := NULL] # Same as IL_2020/PARCC_Student_Info - verified
setkeyv(PARCC_Student_Info, c("YEAR", "ID", "StudentTestUUID"))
setkeyv(PARCC_SGP@Data, c("YEAR", "ID", "StudentTestUUID"))

orig.names <- names(PARCC_SGP@Data)
PARCC_SGP@Data <- PARCC_Student_Info[PARCC_SGP@Data]
table(PARCC_SGP@Data[YEAR > '2016_2017.2', is.na(SGP), is.na(AccountableSchoolCode)], exclude=NULL)
table(PARCC_SGP@Data[YEAR > '2016_2017.2' & AccountableSchoolCode == "", YEAR], exclude=NULL)
table(PARCC_SGP@Data[YEAR > '2016_2017.2', is.na(SGP), EconomicDisadvantageStatus], exclude=NULL)
table(PARCC_SGP@Data[YEAR > '2016_2017.2', StateAbbreviation, EconomicDisadvantageStatus], exclude=NULL)

setcolorder(PARCC_SGP@Data, union(orig.names, var_name_and_order_2021))

###   PANUniqueStudentID to Refid now used in 2021
DOD_Refid <- fread("Department_Of_Defense/Data/Base_Files/DoDEA19_PA_to_PAN_Growth_Crosswalk_File.csv", sep=",", colClasses=rep("character", 2))
BIE_Refid <- fread("Bureau_of_Indian_Education/Data/Base_Files/BIE_18_19_files_BIE_18__19_PA_to_PAN_Growth_Crosswalk_File.csv", sep=",", colClasses=rep("character", 2))
PARCC_Refid <- rbindlist(list(BIE_Refid, DOD_Refid))

setnames(PARCC_Refid, "PANUniqueStudentID", "ID")

setkey(PARCC_Refid, ID)
setkey(PARCC_SGP@Data, ID)
PARCC_SGP@Data <- PARCC_Refid[PARCC_SGP@Data]
# table(PARCC_SGP@Data[, .(is.na(Refid), YEAR), GRADE], exclude=NULL) # Not very good coverage ...
# table(BIE_Refid$Refid %in% unique(PARCC_SGP@Data[StateAbbreviation == "BI", ID])) # 100% match rate
# table(DOD_Refid$Refid %in% unique(PARCC_SGP@Data[StateAbbreviation == "DD", ID])) # 100% match rate

PARCC_SGP@Data[!is.na(Refid), ID := Refid]


###   Save data (replace 2020 analysis)
save(PARCC_SGP, file="./PARCC/Data/Archive/2019_2020.2/PARCC_SGP.Rdata")
# save(PARCC_Student_Info, file="./PARCC/Data/PARCC_Student_Info.rda")

outputSGP(PARCC_SGP,
  outputSGP.directory="./PARCC/Data/Archive/2019_2020.2",
  output.type="LONG_Data")

file.remove("./PARCC/Data/Archive/2019_2020.2/PARCC_SGP_LONG_Data.txt.zip")
