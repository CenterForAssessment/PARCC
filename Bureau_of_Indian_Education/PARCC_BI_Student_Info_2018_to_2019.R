################################################################################
###                                                                          ###
###       Merge B.I.E. student info from 2018 and 2019 with SGP @Data        ###
###                                                                          ###
################################################################################

### Load required packages

require(SGP)
require(data.table)

####   Read in demographics files
BIE_2018 <- fread("Bureau_of_Indian_Education/Data/Base_Files/pcspr18_bi_Growth_Vendor_Summative_File_Spring_D20210629.csv", sep=",", colClasses=rep("character", 196))
BIE_2019 <- fread("Bureau_of_Indian_Education/Data/Base_Files/pcspr19_bi_Growth_Vendor_Summative_File_Spring_D20210629.csv", sep=",", colClasses=rep("character", 197))

###   Define YEAR in SGP convention
BIE_2018[, YEAR := "2017_2018.2"]
BIE_2019[, YEAR := "2018_2019.2"]

###   Make ID name consistent for all 3 years.  Also fix capitalization in G 'and' T
setnames(BIE_2018, c("PARCCStudentIdentifier", "GiftedandTalented"), c("ID", "GiftedAndTalented"))
setnames(BIE_2019, c("UniquePearsonStudentID", "GiftedandTalented"), c("ID", "GiftedAndTalented"))

###   Clean up unneeded variables to reduce visual clutter
BIE_2018[, grep("CSEM|Filler|PaperSection|ScaleScore|StateField|StudentGrowth|SGP|Subclaim|Unit", names(BIE_2018), value=TRUE) := NULL]
BIE_2019[, grep("CSEM|Filler|PaperSection|ScaleScore|StateField|StudentGrowth|SGP|Subclaim|Unit", names(BIE_2019), value=TRUE) := NULL]

# names(BIE_2019)[!names(BIE_2019) %in% (names(BIE_2018))]
# names(BIE_2018)[!names(BIE_2018) %in% (names(BIE_2019))]

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

var_name_and_order_2021[!var_name_and_order_2021 %in% names(BIE_2018)]
var_name_and_order_2021[!var_name_and_order_2021 %in% names(BIE_2019)]

##    Check SCHOOL/DISTRICT_NUMBER
# grep("School", names(BIE_2018), value=TRUE) # need "ResponsibleAccountableSchoolCode", "ResponsibleSchoolName"
# grep("District", names(BIE_2019), value=TRUE) # need "ResponsibleAccountableSchoolCode", "ResponsibleSchoolName"

setnames(BIE_2018,
    c("ResponsibleAccountableSchoolCode", "ResponsibleSchoolName", "ResponsibleAccountableDistrictCode", "ResponsibleDistrictName"),
    c("AccountableSchoolCode", "AccountableSchoolName", "AccountableDistrictCode", "AccountableDistrictName"))
setnames(BIE_2019,
    c("ResponsibleAccountableSchoolCode", "ResponsibleSchoolName", "ResponsibleAccountableDistrictCode", "ResponsibleDistrictName"),
    c("AccountableSchoolCode", "AccountableSchoolName", "AccountableDistrictCode", "AccountableDistrictName"))


###   Keep FormID (?) - seperate Paper/Online in 2018-2020
# table(BIE_2018[, PaperFormID == "", OnlineFormID == ""], exclude=NULL)
form.ids <- c("PaperFormID", "OnlineFormID")

###   Fill in the missing variables to be added with 2021 analyses.
BIE_2018[, c(var_name_and_order_2021[!var_name_and_order_2021 %in% names(BIE_2018)]) := ""]
BIE_2019[, c(var_name_and_order_2021[!var_name_and_order_2021 %in% names(BIE_2019)]) := ""]

###   Rbind all 3 years into a single data.table with required variables and in order.
BIE_Student_Info <- rbindlist(
    list(
        BIE_2018[, c(var_name_and_order_2021, form.ids), with=FALSE],
        BIE_2019[, c(var_name_and_order_2021, form.ids), with=FALSE]))

var_name_and_order_2021[!var_name_and_order_2021 %in% names(BIE_Student_Info)]
names(BIE_Student_Info)[!names(BIE_Student_Info) %in% var_name_and_order_2021]

BIE_Student_Info[PaperFormID != "", FormID := PaperFormID]
BIE_Student_Info[OnlineFormID != "", FormID := OnlineFormID]
# table(BIE_Student_Info[, FormID == "", PaperFormID == ""])
# table(BIE_Student_Info[, FormID == "", OnlineFormID == ""])
BIE_Student_Info[, c("OnlineFormID", "PaperFormID") := NULL]


###   Merge student info with Bureau_of_Indian_Education_SGP@Data (post 2019 BASELINE analysis)
load("./Bureau_of_Indian_Education/Data/Archive/2018_2019.2/BASELINE/Bureau_of_Indian_Education_SGP.Rdata")

setkeyv(BIE_Student_Info, c("YEAR", "ID", "StudentTestUUID"))
setkeyv(Bureau_of_Indian_Education_SGP@Data, c("YEAR", "ID", "StudentTestUUID"))

orig.names <- names(Bureau_of_Indian_Education_SGP@Data)
Bureau_of_Indian_Education_SGP@Data <- BIE_Student_Info[Bureau_of_Indian_Education_SGP@Data]
table(Bureau_of_Indian_Education_SGP@Data[YEAR > '2016_2017.2', is.na(SGP), is.na(AccountableSchoolCode)], exclude=NULL)
table(Bureau_of_Indian_Education_SGP@Data[YEAR > '2016_2017.2' & AccountableSchoolCode == "", YEAR], exclude=NULL)
table(Bureau_of_Indian_Education_SGP@Data[YEAR > '2016_2017.2', is.na(SGP), EconomicDisadvantageStatus], exclude=NULL)

setcolorder(Bureau_of_Indian_Education_SGP@Data, union(orig.names, var_name_and_order_2021))

###   PANUniqueStudentID to Refid now used in 2021
BIE_Refid <- fread("Bureau_of_Indian_Education/Data/Base_Files/BIE_18_19_files_BIE_18__19_PA_to_PAN_Growth_Crosswalk_File.csv", sep=",", colClasses=rep("character", 2))
setnames(BIE_Refid, "PANUniqueStudentID", "ID")

setkey(BIE_Refid, ID)
setkey(Bureau_of_Indian_Education_SGP@Data, ID)
Bureau_of_Indian_Education_SGP@Data <- BIE_Refid[Bureau_of_Indian_Education_SGP@Data]
# table(Bureau_of_Indian_Education_SGP@Data[, .(is.na(Refid), YEAR), GRADE], exclude=NULL) # Not a very good match rate...

# setnames(Bureau_of_Indian_Education_SGP@Data, c("ID", "Refid"), c("PAN_ID", "ID"))
Bureau_of_Indian_Education_SGP@Data[!is.na(Refid), ID := Refid]


###   Save data (replace 2019 BASELINE analysis results)
# save(Bureau_of_Indian_Education_SGP, file="./Bureau_of_Indian_Education/Data/Archive/2018_2019.2/BASELINE/Bureau_of_Indian_Education_SGP.Rdata")
save(BIE_Student_Info, file="./Bureau_of_Indian_Education/Data/BIE_Student_Info.rda")

assign("Bureau_of_Indian_Education_SGP", Bureau_of_Indian_Education_SGP)
outputSGP(Bureau_of_Indian_Education_SGP,
  outputSGP.directory="./Bureau_of_Indian_Education/Data/Archive/2018_2019.2/BASELINE",
  output.type="LONG_Data")

file.remove("./Bureau_of_Indian_Education/Data/Archive/2018_2019.2/BASELINE/Bureau_of_Indian_Education_SGP_LONG_Data.txt.zip")
