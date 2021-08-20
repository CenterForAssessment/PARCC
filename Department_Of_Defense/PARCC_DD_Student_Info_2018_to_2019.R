################################################################################
###                                                                          ###
###        Merge DoDEA student info from 2018 and 2019 with SGP @Data        ###
###                                                                          ###
################################################################################

### Load required packages

require(SGP)
require(data.table)

####   Read in demographics files
DOD_2018 <- fread("Department_Of_Defense/Data/Base_Files/pcspr18_dodea_Growth_Vendor_Summative_File_Spring_D20210629.csv", sep=",", colClasses=rep("character", 196))
DOD_2019 <- fread("Department_Of_Defense/Data/Base_Files/pcspr19_dodea_Growth_Vendor_Summative_File_Spring_D20210629.csv", sep=",", colClasses=rep("character", 197))

###   Define YEAR in SGP convention
DOD_2018[, YEAR := "2017_2018.2"]
DOD_2019[, YEAR := "2018_2019.2"]

###   Make ID name consistent for all 3 years.  Also fix capitalization in G 'and' T
setnames(DOD_2018, c("PARCCStudentIdentifier", "GiftedandTalented"), c("ID", "GiftedAndTalented"))
setnames(DOD_2019, c("UniquePearsonStudentID", "GiftedandTalented"), c("ID", "GiftedAndTalented"))

###   Clean up unneeded variables to reduce visual clutter
DOD_2018[, grep("CSEM|Filler|PaperSection|ScaleScore|StateField|StudentGrowth|SGP|Subclaim|Unit", names(DOD_2018), value=TRUE) := NULL]
DOD_2019[, grep("CSEM|Filler|PaperSection|ScaleScore|StateField|StudentGrowth|SGP|Subclaim|Unit", names(DOD_2019), value=TRUE) := NULL]

# names(DOD_2019)[!names(DOD_2019) %in% (names(DOD_2018))]
# names(DOD_2018)[!names(DOD_2018) %in% (names(DOD_2019))]

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

var_name_and_order_2021[!var_name_and_order_2021 %in% names(DOD_2018)]
var_name_and_order_2021[!var_name_and_order_2021 %in% names(DOD_2019)]

##    Check SCHOOL/DISTRICT_NUMBER
# grep("School", names(DOD_2018), value=TRUE) # need "ResponsibleAccountableSchoolCode", "ResponsibleSchoolName"
# grep("District", names(DOD_2019), value=TRUE) # need "ResponsibleAccountableSchoolCode", "ResponsibleSchoolName"

setnames(DOD_2018,
    c("ResponsibleAccountableSchoolCode", "ResponsibleSchoolName", "ResponsibleAccountableDistrictCode", "ResponsibleDistrictName"),
    c("AccountableSchoolCode", "AccountableSchoolName", "AccountableDistrictCode", "AccountableDistrictName"))
setnames(DOD_2019,
    c("ReportingSchoolCode", "ReportingSchoolName", "ReportingDistrictCode", "ReportingDistrictName"),
    c("AccountableSchoolCode", "AccountableSchoolName", "AccountableDistrictCode", "AccountableDistrictName"))


###   Keep FormID (?) - seperate Paper/Online in 2018-2020
# table(DOD_2018[, PaperFormID == "", OnlineFormID == ""], exclude=NULL)
form.ids <- c("PaperFormID", "OnlineFormID")

###   Fill in the missing variables to be added with 2021 analyses.
DOD_2018[, c(var_name_and_order_2021[!var_name_and_order_2021 %in% names(DOD_2018)]) := ""]
DOD_2019[, c(var_name_and_order_2021[!var_name_and_order_2021 %in% names(DOD_2019)]) := ""]

###   Rbind all 3 years into a single data.table with required variables and in order.
DOD_Student_Info <- rbindlist(
    list(
        DOD_2018[, c(var_name_and_order_2021, form.ids), with=FALSE],
        DOD_2019[, c(var_name_and_order_2021, form.ids), with=FALSE]))

var_name_and_order_2021[!var_name_and_order_2021 %in% names(DOD_Student_Info)]
names(DOD_Student_Info)[!names(DOD_Student_Info) %in% var_name_and_order_2021]

DOD_Student_Info[PaperFormID != "", FormID := PaperFormID]
DOD_Student_Info[OnlineFormID != "", FormID := OnlineFormID]
# table(DOD_Student_Info[, FormID == "", PaperFormID == ""])
# table(DOD_Student_Info[, FormID == "", OnlineFormID == ""])
DOD_Student_Info[, c("OnlineFormID", "PaperFormID") := NULL]


###   Merge student info with Department_of_Defense_SGP@Data (post 2020 data addition and analysis)
load("./Department_Of_Defense/Data/Archive/2018_2019.2/Department_of_Defense_SGP.Rdata") # No BASELINE version - Don't re-save!
Department_of_Defense_SGP@Data <- Department_of_Defense_SGP@Data[grep("_SS", CONTENT_AREA, invert =TRUE),]

setkeyv(DOD_Student_Info, c("YEAR", "ID", "StudentTestUUID"))
setkeyv(Department_of_Defense_SGP@Data, c("YEAR", "ID", "StudentTestUUID"))

orig.names <- names(Department_of_Defense_SGP@Data)
Department_of_Defense_SGP@Data <- DOD_Student_Info[Department_of_Defense_SGP@Data]
table(Department_of_Defense_SGP@Data[YEAR > '2016_2017.2', is.na(SGP), is.na(AccountableSchoolCode)], exclude=NULL)
table(Department_of_Defense_SGP@Data[YEAR > '2016_2017.2' & AccountableSchoolCode == "", YEAR], exclude=NULL)
table(Department_of_Defense_SGP@Data[YEAR > '2016_2017.2', is.na(SGP), EconomicDisadvantageStatus], exclude=NULL)

setcolorder(Department_of_Defense_SGP@Data, union(orig.names, var_name_and_order_2021))

###   PANUniqueStudentID to Refid now used in 2021
DOD_Refid <- fread("Department_Of_Defense/Data/Base_Files/DoDEA19_PA_to_PAN_Growth_Crosswalk_File.csv", sep=",", colClasses=rep("character", 2))
setnames(DOD_Refid, "PANUniqueStudentID", "ID")

setkey(DOD_Refid, ID)
setkey(Department_of_Defense_SGP@Data, ID)
Department_of_Defense_SGP@Data <- DOD_Refid[Department_of_Defense_SGP@Data]
# table(Department_of_Defense_SGP@Data[, .(is.na(Refid), YEAR), GRADE], exclude=NULL) # Not a very good match rate...

# setnames(Department_of_Defense_SGP@Data, c("ID", "Refid"), c("PAN_ID", "ID"))
Department_of_Defense_SGP@Data[!is.na(Refid), ID := Refid]

###   Save data (in place of 2019 BASELINE analysis results)
# save(Department_of_Defense_SGP, file="./Department_Of_Defense/Data/Archive/2018_2019.2/BASELINE/Department_of_Defense_SGP.Rdata") # No baselines run, so not created originally - Don't save here now...
save(DOD_Student_Info, file="./Department_Of_Defense/Data/DOD_Student_Info.rda")

outputSGP(Department_of_Defense_SGP,
  outputSGP.directory="./Department_Of_Defense/Data/Archive/2018_2019.2/BASELINE",
  output.type="LONG_Data")

file.remove("./Department_Of_Defense/Data/Archive/2018_2019.2/BASELINE/Department_of_Defense_SGP_LONG_Data.txt.zip")
