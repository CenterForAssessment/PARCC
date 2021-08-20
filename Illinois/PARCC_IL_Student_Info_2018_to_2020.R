################################################################################
###                                                                          ###
###    Merge Illinois student info from 2018, 2019 & 2020 with SGP @Data     ###
###                                                                          ###
################################################################################

### Load required packages

require(SGP)
require(data.table)

###  Set working directory to top level (PARCC) directory
my.dir <- getwd()

####   Read in ZIP files
setwd(tempdir())
system(paste0("unzip '", file.path(my.dir, 'Illinois/Data/Base_Files/pcspr18_il_Growth_Vendor_Summative_File_Spring_D20210624.csv.zip'), "'"))
system(paste0("unzip '", file.path(my.dir, 'Illinois/Data/Base_Files/pcspr19_il_Growth_Vendor_Summative_File_Spring_D20210624.csv.zip'), "'"))
system(paste0("unzip '", file.path(my.dir, 'Illinois/Data/Base_Files/pcspr20_il_Growth_Vendor_Summative_File_Spring_D20210624.csv.zip'), "'"))
IL_2018 <- fread("pcspr18_il_Growth_Vendor_Summative_File_Spring_D20210624.csv", sep=",", colClasses=rep("character", 196))
IL_2019 <- fread("pcspr19_il_Growth_Vendor_Summative_File_Spring_D20210624.csv", sep=",", colClasses=rep("character", 197))
IL_2020 <- fread("pcspr20_il_Growth_Vendor_Summative_File_Spring_D20210624.csv", sep=",", colClasses=rep("character", 197))
unlink(grep("il_Growth_Vendor", list.files(), value=TRUE))
setwd(my.dir)

###   Check that 2020 has scores
# table(IL_2020[, IRTTheta != "", TestCode]) # 87,425 2020 test scores from all content areas and grades


###   Define YEAR in SGP convention
IL_2018[, YEAR := "2017_2018.2"]
IL_2019[, YEAR := "2018_2019.2"]
IL_2020[, YEAR := "2019_2020.2"]

###   Make ID name consistent for all 3 years.  Also fix capitalization in G 'and' T
setnames(IL_2018, c("PARCCStudentIdentifier", "GiftedandTalented"), c("ID", "GiftedAndTalented"))
setnames(IL_2019, c("UniquePearsonStudentID", "GiftedandTalented"), c("ID", "GiftedAndTalented"))
setnames(IL_2020, c("UniquePearsonStudentID", "GiftedandTalented"), c("ID", "GiftedAndTalented"))

###   Clean up unneeded variables to reduce visual clutter
IL_2018[, grep("CSEM|Filler|PaperSection|ScaleScore|StateField|StudentGrowth|SGP|Subclaim|Unit", names(IL_2018), value=TRUE) := NULL]
IL_2019[, grep("CSEM|Filler|PaperSection|ScaleScore|StateField|StudentGrowth|SGP|Subclaim|Unit", names(IL_2019), value=TRUE) := NULL]
IL_2020[, grep("CSEM|Filler|PaperSection|ScaleScore|StateField|StudentGrowth|SGP|Subclaim|Unit", names(IL_2020), value=TRUE) := NULL]

# names(IL_2020)[!names(IL_2020) %in% (names(IL_2019))]
# names(IL_2020)[!names(IL_2020) %in% (names(IL_2018))]
# names(IL_2019)[!names(IL_2019) %in% (names(IL_2018))]
# names(IL_2018)[!names(IL_2018) %in% (names(IL_2019))]
# names(IL_2018)[!names(IL_2018) %in% (names(IL_2020))]
# names(IL_2019)[!names(IL_2019) %in% (names(IL_2020))]

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

var_name_and_order_2021[!var_name_and_order_2021 %in% names(IL_2018)]
var_name_and_order_2021[!var_name_and_order_2021 %in% names(IL_2019)]
var_name_and_order_2021[!var_name_and_order_2021 %in% names(IL_2020)]

##    Check SCHOOL/DISTRICT_NUMBER
# grep("School", names(IL_2018), value=TRUE) # need "ResponsibleAccountableSchoolCode", "ResponsibleSchoolName"
# grep("School", names(IL_2019), value=TRUE) # need "ResponsibleAccountableSchoolCode", "ResponsibleSchoolName"
# grep("District", names(IL_2020), value=TRUE) # ? "HomeSchoolCode"

setnames(IL_2018,
    c("ResponsibleAccountableSchoolCode", "ResponsibleSchoolName", "ResponsibleAccountableDistrictCode", "ResponsibleDistrictName"),
    c("AccountableSchoolCode", "AccountableSchoolName", "AccountableDistrictCode", "AccountableDistrictName"))
setnames(IL_2019,
    c("ResponsibleAccountableSchoolCode", "ResponsibleSchoolName", "ResponsibleAccountableDistrictCode", "ResponsibleDistrictName"),
    c("AccountableSchoolCode", "AccountableSchoolName", "AccountableDistrictCode", "AccountableDistrictName"))
setnames(IL_2020,
    c("HomeSchoolCode", "HomeSchoolName", "HomeDistrictCode", "HomeDistrictName"),
    c("AccountableSchoolCode", "AccountableSchoolName", "AccountableDistrictCode", "AccountableDistrictName"))


###   Keep FormID (?) - seperate Paper/Online in 2018-2020
# table(IL_2018[, PaperFormID == "", OnlineFormID == ""], exclude=NULL)
form.ids <- c("PaperFormID", "OnlineFormID")

###   Fill in the missing variables to be added with 2021 analyses.
IL_2018[, c(var_name_and_order_2021[!var_name_and_order_2021 %in% names(IL_2018)]) := ""]
IL_2019[, c(var_name_and_order_2021[!var_name_and_order_2021 %in% names(IL_2019)]) := ""]
IL_2020[, c(var_name_and_order_2021[!var_name_and_order_2021 %in% names(IL_2020)]) := ""]

###   Rbind all 3 years into a single data.table with required variables and in order.
IL_Student_Info <- rbindlist(
    list(
        IL_2018[, c(var_name_and_order_2021, form.ids), with=FALSE],
        IL_2019[, c(var_name_and_order_2021, form.ids), with=FALSE],
        IL_2020[, c(var_name_and_order_2021, form.ids), with=FALSE]))

var_name_and_order_2021[!var_name_and_order_2021 %in% names(IL_Student_Info)]
names(IL_Student_Info)[!names(IL_Student_Info) %in% var_name_and_order_2021]

IL_Student_Info[PaperFormID != "", FormID := PaperFormID]
IL_Student_Info[OnlineFormID != "", FormID := OnlineFormID]
# table(IL_Student_Info[, FormID == "", PaperFormID == ""])
# table(IL_Student_Info[, FormID == "", OnlineFormID == ""])
IL_Student_Info[, c("OnlineFormID", "PaperFormID") := NULL]


###   Merge student info with Illinois_SGP@Data (post 2020 data addition and analysis)
load("./Illinois/Data/Illinois_SGP.Rdata")

Illinois_SGP@Data[, FormID := NULL] # Same as IL_2020/IL_Student_Info - verified
setkeyv(IL_Student_Info, c("YEAR", "ID", "StudentTestUUID"))
setkeyv(Illinois_SGP@Data, c("YEAR", "ID", "StudentTestUUID"))

orig.names <- names(Illinois_SGP@Data)
Illinois_SGP@Data <- IL_Student_Info[Illinois_SGP@Data]
table(Illinois_SGP@Data[YEAR > '2016_2017.2', is.na(SGP), is.na(AccountableSchoolCode)], exclude=NULL)
table(Illinois_SGP@Data[YEAR > '2016_2017.2' & AccountableSchoolCode == "", YEAR], exclude=NULL)
table(Illinois_SGP@Data[YEAR > '2016_2017.2', is.na(SGP), EconomicDisadvantageStatus], exclude=NULL)

setcolorder(Illinois_SGP@Data, union(orig.names, var_name_and_order_2021))

###   Save data (or run 2021 directly with this)
save(Illinois_SGP, file="./Illinois/Data/Archive/2019_2020.2/Illinois_SGP.Rdata")
save(IL_Student_Info, file="./Illinois/Data/IL_Student_Info.rda")
