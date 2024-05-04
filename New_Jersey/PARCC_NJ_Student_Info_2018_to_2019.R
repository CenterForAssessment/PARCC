###############################################################################
###                                                                         ###
###     Merge New Jersey student info from 2018 and 2019 with SGP @Data     ###
###                                                                         ###
###############################################################################

### Load required packages
require(SGP)
require(data.table)

freadZIP <- function(zipfile, all.to.char = TRUE, sep = NULL) {
    if (is.null(sep)) sep <- "auto"
    zipfile <- normalizePath(zipfile)
    fname <- gsub(".zip", "", basename(zipfile))
    tmp.dir <- getwd()
    setwd(tempdir())
    system(paste0("unzip '", zipfile, "'"))

    if (all.to.char) {
        TMP <- fread(fname, sep = sep, nrows = 10L)
        TMP <- fread(fname, sep = sep, colClasses = rep("character", ncol(TMP)))
    } else {
        TMP <- fread(fname, sep = sep)
    }
    unlink(fname)
    setwd(tmp.dir)
    return(TMP)
}

####   Read in demographics files
NJ_2018 <-
    freadZIP("Data/Base_Files/PC_pcspr18_NJ_PARCC_State_Summative_Record_File_Spring_D201809091804.csv.zip")
NJ_2019 <-
    freadZIP("Data/Base_Files/pcspr19_NJ_State_Summative_Record_File_Spring_D201908190007.csv.zip")

###   Define YEAR in SGP convention
NJ_2018[, YEAR := "2017_2018.2"]
NJ_2019[, YEAR := "2018_2019.2"]

###   Make ID name consistent for all 3 years.  Also fix capitalization in G 'and' T
setnames(NJ_2018, c("PARCCStudentIdentifier", "GiftedandTalented"), c("ID", "GiftedAndTalented"))
setnames(NJ_2019, c("StudentAssessmentIdentifier"), c("ID"))

###   Clean up unneeded variables to reduce visual clutter
NJ_2018[, grep("CSEM|Filler|PaperSection|ScaleScore|StateField|StudentGrowth|SGP|Subclaim|Unit", names(NJ_2018), value = TRUE) := NULL]
NJ_2019[, grep("CSEM|Filler|PaperSection|ScaleScore|StateField|StudentGrowth|SGP|Subclaim|Unit", names(NJ_2019), value = TRUE) := NULL]

# names(NJ_2019)[!names(NJ_2019) %in% (names(NJ_2018))]
# names(NJ_2018)[!names(NJ_2018) %in% (names(NJ_2019))]

var_name_and_order_2021 <- c(
  "YEAR", "ID", "StudentTestUUID", # "IRTTheta", # Merge/key vars. Don't merge on score
#   "FormID", "TestingLocation", "LearningOption",
  "StateStudentIdentifier", "LocalStudentIdentifier",
  "TestingDistrictCode", "TestingDistrictName",
  "TestingSchoolCode", "TestingSchoolName",
  "AccountableDistrictCode", "AccountableDistrictName",
  "AccountableSchoolCode", "AccountableSchoolName",
  "Sex", "HispanicOrLatinoEthnicity", "AmericanIndianOrAlaskaNative", "Asian",
  "BlackOrAfricanAmerican", "NativeHawaiianOrOtherPacificIslander", "White",
  "FederalRaceEthnicity", "TwoOrMoreRaces", "EnglishLearnerEL", "MigrantStatus",
  "GiftedAndTalented", "EconomicDisadvantageStatus", "StudentWithDisabilities")

var_name_and_order_2021[!var_name_and_order_2021 %in% names(NJ_2018)]
var_name_and_order_2021[!var_name_and_order_2021 %in% names(NJ_2019)]

##    Check SCHOOL/DISTRICT_NUMBER
# grep("School", names(NJ_2018), value = TRUE) # need "AccountableSchoolCode", "AccountableSchoolName"
# grep("District", names(NJ_2019), value = TRUE) # need "AccountableSchoolCode", "AccountableSchoolName"

setnames(NJ_2018,
    c("ResponsibleAccountableSchoolCode", "ResponsibleSchoolName",
      "ResponsibleAccountableDistrictCode", "ResponsibleDistrictName"),
    c("AccountableSchoolCode", "AccountableSchoolName",
      "AccountableDistrictCode", "AccountableDistrictName"))


# table(NJ_2018[, PaperFormID == "", OnlineFormID == ""], exclude = NULL)
form.ids <- c("PaperFormID", "OnlineFormID")

###   Fill in the missing variables to be added with 2021 analyses.
# NJ_2018[, c(var_name_and_order_2021[!var_name_and_order_2021 %in% names(NJ_2018)]) := ""]
NJ_2019[, c(var_name_and_order_2021[!var_name_and_order_2021 %in% names(NJ_2019)], form.ids) := ""]

###   Rbind all 3 years into a single data.table with required variables and in order.
NJ_Student_Info <- rbindlist(
    list(NJ_2018[, c(var_name_and_order_2021, form.ids), with = FALSE],
         NJ_2019[, c(var_name_and_order_2021, form.ids), with = FALSE]))

var_name_and_order_2021[!var_name_and_order_2021 %in% names(NJ_Student_Info)]
names(NJ_Student_Info)[!names(NJ_Student_Info) %in% var_name_and_order_2021]

NJ_Student_Info[PaperFormID != "", FormID := PaperFormID]
NJ_Student_Info[OnlineFormID != "", FormID := OnlineFormID]
# table(NJ_Student_Info[, FormID == "", PaperFormID == ""])
# table(NJ_Student_Info[, FormID == "", OnlineFormID == ""])
NJ_Student_Info[, c("OnlineFormID", "PaperFormID") := NULL]


###   Merge student info with New_Jersey_SGP@Data (post 2020 data addition and analysis)
load("Data/Archive/2018_2019.2/New_Jersey_SGP.Rdata")
New_Jersey_SGP@Data <- New_Jersey_SGP@Data[grep("_SS", CONTENT_AREA, invert = TRUE), ]

setkeyv(NJ_Student_Info, c("YEAR", "ID", "StudentTestUUID"))
setkeyv(New_Jersey_SGP@Data, c("YEAR", "ID", "StudentTestUUID"))

orig.names <- names(New_Jersey_SGP@Data)
New_Jersey_SGP@Data <- NJ_Student_Info[New_Jersey_SGP@Data]
table(New_Jersey_SGP@Data[YEAR > "2016_2017.2", is.na(SGP), is.na(AccountableSchoolCode)], exclude = NULL)
table(New_Jersey_SGP@Data[YEAR > "2016_2017.2" & AccountableSchoolCode == "", YEAR], exclude = NULL)
table(New_Jersey_SGP@Data[YEAR > "2016_2017.2", is.na(SGP), EconomicDisadvantageStatus], exclude = NULL)

setcolorder(New_Jersey_SGP@Data, union(orig.names, var_name_and_order_2021))

New_Jersey_SGP@Data <- New_Jersey_SGP@Data[YEAR != "2018_2019.1"]

###   Save data (in place of 2019 BASELINE analysis results)
# No baselines run, so not created originally - Don't save here now...
# save(New_Jersey_SGP, file = "Data/Archive/2018_2019.2/BASELINE/New_Jersey_SGP.Rdata")
save(NJ_Student_Info, file = "Data/NJ_Student_Info.rda")

outputSGP(New_Jersey_SGP,
  outputSGP.directory = "Data/Archive/2018_2019.2/BASELINE",
  output.type = "LONG_Data")

file.remove("Data/Archive/2018_2019.2/BASELINE/New_Jersey_SGP_LONG_Data.txt.zip")
