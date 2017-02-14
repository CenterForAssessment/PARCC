################################################################################
###                                                                          ###
###         Format PARCC Fall 2016 Results Data to Return to Pearson         ###
###                                                                          ###
################################################################################

### Load required packages

require(SGP)
require(data.table)

###
###    Read in Fall 2016 Output Files
###

load("./PARCC/Data/PARCC_SGP_LONG_Data_2016_2017.1.Rdata")

load("./Colorado/Data/Colorado_SGP_LONG_Data_2016_2017.1.Rdata")
load("./Illinois/Data/Illinois_SGP_LONG_Data_2016_2017.1.Rdata")
load("./Maryland/Data/Maryland_SGP_LONG_Data_2016_2017.1.Rdata")
load("./New_Jersey/Data/New_Jersey_SGP_LONG_Data_2016_2017.1.Rdata")
load("./New_Mexico/Data/New_Mexico_SGP_LONG_Data_2016_2017.1.Rdata")
load("./Rhode_Island/Data/Rhode_Island_SGP_LONG_Data_2016_2017.1.Rdata")
load("./Washington_DC/Data/WASHINGTON_DC_SGP_LONG_Data_2016_2017.1.Rdata")

####  Set names based on Pearson file layout
parcc.names <- c("AssessmentYear", "StateAbbreviation", "PARCCStudentIdentifier", "GradeLevelWhenAssessed", "Period", "TestCode",
                 "SummativeScoreRecordUUID", "StudentTestUUID", "SummativeScaleScore", "IRTTheta", "SummativeCSEM", "Filler", "TestFormat")

nciea.names <- c("StudentGrowthPercentileComparedtoState", "StudentGrowthPercentileComparedtoPARCC", "SGPPreviousTestCodeState",
                 "SGPPreviousTestCodePARCC", "SGPUpperBoundState", "SGPLowerBoundState", "SGPUpperBoundPARCC", "SGPLowerBoundPARCC")

all.names <- c(head(parcc.names,-1), nciea.names, "TestFormat", "PACKAGE_NOTE") # TestFormat is out of order.  Add in PACKAGE_NOTE to check consistency between manual and package NOTE versions

####  Combine states' data into single data table
State_LONG_Data <- rbindlist(list(
	Colorado_SGP_LONG_Data, Illinois_SGP_LONG_Data, Maryland_SGP_LONG_Data,
	New_Jersey_SGP_LONG_Data, New_Mexico_SGP_LONG_Data,
	Rhode_Island_SGP_LONG_Data, WASHINGTON_DC_SGP_LONG_Data), fill=TRUE)


#####
###    Format data to Pearson's specifications
#####

##  Add in the Missing SGP identifiers requested by Pearson

###  Rename new SGP_NOTE variable to compare with constructed one from formatting process:
setnames(State_LONG_Data, "SGP_NOTE", "PACKAGE_NOTE")
setnames(PARCC_SGP_LONG_Data, "SGP_NOTE", "PACKAGE_NOTE")

###  PARCC Consortium

####  ELA

PARCC_SGP_LONG_Data[, SGP_NOTE := "NA"]
na.ela.ids <- PARCC_SGP_LONG_Data[CONTENT_AREA == "ELA" & YEAR=='2016_2017.1' & is.na(SGP)]$ID
prior.ela.ids <- PARCC_SGP_LONG_Data[CONTENT_AREA == "ELA" & YEAR!='2016_2017.1']$ID

####  Identify the skipped grades and repeaters, and Fall to Spring (Actual Small Cohort)
yes.prior.ela.ids <- intersect(na.ela.ids, prior.ela.ids)
ela <- PARCC_SGP_LONG_Data[CONTENT_AREA == "ELA" & ID %in% yes.prior.ela.ids][, list(VALID_CASE, ID, StudentTestUUID, YEAR, GRADE)]
ela_wide <- dcast(ela, ID ~ YEAR, value.var="GRADE")

sm.cohort.ela.ids <- ela_wide[as.numeric(`2016_2017.1`)-as.numeric(`2015_2016.2`) == 1,]$ID
repeat.ela.ids <- ela_wide[`2015_2016.2`==`2016_2017.1` | `2015_2016.2`==`2016_2017.1`,]$ID
skip.ela.ids <- unique(c(ela_wide[as.numeric(`2016_2017.1`)-as.numeric(`2015_2016.2`) > 1,]$ID, ela_wide[as.numeric(`2016_2017.1`)-as.numeric(`2015_2016.2`) > 1,]$ID))
regr.ela.ids <- unique(c(ela_wide[as.numeric(`2016_2017.1`)-as.numeric(`2015_2016.2`) < 0,]$ID, ela_wide[as.numeric(`2016_2017.1`)-as.numeric(`2015_2016.2`) < 0,]$ID))
length(unique(c(sm.cohort.ela.ids, repeat.ela.ids, skip.ela.ids, regr.ela.ids))) == length(yes.prior.ela.ids)
table(ela_wide[ID %in% skip.ela.ids][, `2015_2016.1`, `2016_2017.1`]) # Only 9th to 11th grade ELA is close (still < 1000 @ 920)

PARCC_SGP_LONG_Data[CONTENT_AREA == "ELA" & YEAR=='2016_2017.1' & ID %in% regr.ela.ids, SGP_NOTE := "Regressed"]
PARCC_SGP_LONG_Data[CONTENT_AREA == "ELA" & YEAR=='2016_2017.1' & ID %in% skip.ela.ids, SGP_NOTE := "Skipped"]
PARCC_SGP_LONG_Data[CONTENT_AREA == "ELA" & YEAR=='2016_2017.1' & ID %in% repeat.ela.ids, SGP_NOTE := "Repeat"]
PARCC_SGP_LONG_Data[CONTENT_AREA == "ELA" & YEAR=='2016_2017.1' & ID %in% sm.cohort.ela.ids, SGP_NOTE := "<1000"]

table(PARCC_SGP_LONG_Data[, SGP_NOTE])

###  Grade Level Math

na.math.ids <- PARCC_SGP_LONG_Data[CONTENT_AREA == "MATHEMATICS" & YEAR=='2016_2017.1' & is.na(SGP)]$ID
prior.math.ids <- PARCC_SGP_LONG_Data[CONTENT_AREA == "MATHEMATICS" & YEAR!='2016_2017.1']$ID

####  Identify the skipped grades and repeaters, and Fall to Spring (NONE for Grade Level Math)
yes.prior.math.ids <- intersect(na.math.ids, prior.math.ids)
math <- PARCC_SGP_LONG_Data[CONTENT_AREA == "MATHEMATICS" & ID %in% yes.prior.math.ids][, list(VALID_CASE, ID, StudentTestUUID, YEAR, GRADE)]
math_wide <- dcast(math, ID ~ YEAR, value.var="GRADE")

# sm.cohort.math.ids <- math_wide[as.numeric(`2016_2017.1`)-as.numeric(`2015_2016.1`) == 1,]$ID
repeat.math.ids <- math_wide[`2015_2016.2`==`2016_2017.1`,]$ID
skip.math.ids <- math_wide[as.numeric(`2016_2017.1`)-as.numeric(`2015_2016.2`) > 1,]$ID
regr.math.ids <- math_wide[as.numeric(`2016_2017.1`)-as.numeric(`2015_2016.2`) < 0,]$ID
length(unique(c(repeat.math.ids, skip.math.ids, regr.math.ids))) == length(yes.prior.math.ids)
table(math_wide[ID %in% skip.math.ids][, `2015_2016.1`, `2016_2017.1`]) # Skipping from 6th to 8th grade Math would have been feasible

PARCC_SGP_LONG_Data[CONTENT_AREA == "MATHEMATICS" & YEAR=='2016_2017.1' & ID %in% regr.math.ids, SGP_NOTE := "Regressed"]
PARCC_SGP_LONG_Data[CONTENT_AREA == "MATHEMATICS" & YEAR=='2016_2017.1' & ID %in% skip.math.ids, SGP_NOTE := "Skipped"]
PARCC_SGP_LONG_Data[CONTENT_AREA == "MATHEMATICS" & YEAR=='2016_2017.1' & ID %in% repeat.math.ids, SGP_NOTE := "Repeat"]
# PARCC_SGP_LONG_Data[CONTENT_AREA == "MATHEMATICS" & YEAR=='2016_2017.1' & ID %in% sm.cohort.math.ids, SGP_NOTE := "<1000"]

table(PARCC_SGP_LONG_Data[, SGP_NOTE])


###  EOCT Math

na.eoct.ids <- PARCC_SGP_LONG_Data[!CONTENT_AREA %in% c("ELA", "ELA_SS", "MATHEMATICS", "MATHEMATICS_SS") & YEAR=='2016_2017.1' & is.na(SGP)]$ID
prior.eoct.ids <- PARCC_SGP_LONG_Data[!CONTENT_AREA %in% c("ELA", "ELA_SS") & YEAR!='2016_2017.1']$ID

####  Identify EOCT students with no SGP, but some Math prior
yes.prior.eoct.ids <- setdiff(intersect(na.eoct.ids, prior.eoct.ids), yes.prior.math.ids) # weed out grade level math only cases

####  Identify Fall to Spring (NONE for Grade Level Math)
eoct <- PARCC_SGP_LONG_Data[!CONTENT_AREA %in% c("ELA", "ELA_SS") & ID %in% yes.prior.eoct.ids][, list(VALID_CASE, ID, StudentTestUUID, CONTENT_AREA, YEAR)][grep("_SS", CONTENT_AREA, invert =TRUE),]
eoct_wide <- data.table(eoct[YEAR=='2016_2017.1'][, list(ID, StudentTestUUID, CONTENT_AREA)], key="ID")[data.table(eoct[YEAR!='2016_2017.1'][, list(ID, CONTENT_AREA)], key="ID")]

repeater.ids <- eoct_wide[CONTENT_AREA==i.CONTENT_AREA & i.CONTENT_AREA != "MATHEMATICS"]$ID # still 3 grade level Maths included.
repeater.test.ids <- eoct_wide[CONTENT_AREA==i.CONTENT_AREA & i.CONTENT_AREA != "MATHEMATICS"]$StudentTestUUID
repeater.plus.test.ids <- unique(eoct_wide[StudentTestUUID %in% repeater.test.ids][CONTENT_AREA != i.CONTENT_AREA]$StudentTestUUID)
repeater.ids <- setdiff(repeater.ids, unique(eoct_wide[StudentTestUUID %in% repeater.plus.test.ids]$ID)) # Identify/remove students with repeat and an additional math (small cohort) prior
PARCC_SGP_LONG_Data[StudentTestUUID %in% setdiff(repeater.test.ids, repeater.plus.test.ids), SGP_NOTE := "Repeat"]

sm.cohort.eoct.ids <- setdiff(yes.prior.eoct.ids, repeater.ids)
PARCC_SGP_LONG_Data[!CONTENT_AREA %in% c("ELA", "ELA_SS", "MATHEMATICS", "MATHEMATICS_SS") & YEAR=='2016_2017.1' & ID %in% sm.cohort.eoct.ids, SGP_NOTE := "<1000"]

###  Checks
nas <- PARCC_SGP_LONG_Data[SGP_NOTE=="NA" & is.na(SGP)]

na.ela.ids <- nas[CONTENT_AREA == "ELA" & YEAR=='2016_2017.1' & is.na(SGP)]$ID
prior.ela.ids <- nas[CONTENT_AREA == "ELA" & YEAR!='2016_2017.1']$ID
no.prior.ela.ids <- setdiff(na.ela.ids, prior.ela.ids)
identical(na.ela.ids, no.prior.ela.ids) # TRUE

na.math.ids <- nas[CONTENT_AREA == "MATHEMATICS" & YEAR=='2016_2017.1' & is.na(SGP)]$ID
prior.math.ids <- nas[CONTENT_AREA == "MATHEMATICS" & YEAR!='2016_2017.1']$ID
no.prior.math.ids <- setdiff(na.math.ids, prior.math.ids)
identical(na.math.ids, no.prior.math.ids) # TRUE

na.eoct.ids <- nas[grep("_SS", CONTENT_AREA, invert =TRUE),][!CONTENT_AREA %in% c("ELA", "MATHEMATICS") & YEAR=='2016_2017.1' & is.na(SGP)]$ID
prior.eoct.ids <- nas[grep("_SS", CONTENT_AREA, invert =TRUE),][!CONTENT_AREA %in% c("ELA", "ELA_SS") & YEAR!='2016_2017.1'][grep("_SS", CONTENT_AREA, invert =TRUE),]$ID
no.prior.eoct.ids <- setdiff(na.eoct.ids, prior.eoct.ids)
identical(na.eoct.ids, no.prior.eoct.ids) #FALSE - examine in next two lines

xids <- setdiff(na.eoct.ids, no.prior.eoct.ids)
data.table(eoct[ID %in% xids], key="ID") # looks like kids with 2 records in 2015_2016 (Fall or Spring) - one without an SGP and the other with (8 kids)


###  PARCC States

####  ELA

State_LONG_Data[, SGP_NOTE := "NA"]
na.ela.ids <- State_LONG_Data[CONTENT_AREA == "ELA" & YEAR=='2016_2017.1' & is.na(SGP)]$ID
prior.ela.ids <- State_LONG_Data[CONTENT_AREA == "ELA" & YEAR!='2016_2017.1']$ID

####  Identify the skipped grades and repeaters, and Fall to Spring (Actual Small Cohort)
yes.prior.ela.ids <- intersect(na.ela.ids, prior.ela.ids)
ela <- State_LONG_Data[CONTENT_AREA == "ELA" & ID %in% yes.prior.ela.ids][, list(VALID_CASE, ID, StudentTestUUID, YEAR, GRADE)]
ela_wide <- dcast(ela, ID ~ YEAR, value.var="GRADE")

sm.cohort.ela.ids <- unique(c(ela_wide[as.numeric(`2016_2017.1`)-as.numeric(`2015_2016.2`) == 1,]$ID, ela_wide[as.numeric(`2016_2017.1`)-as.numeric(`2015_2016.2`) == 1,]$ID))
repeat.ela.ids <- ela_wide[`2015_2016.2`==`2016_2017.1` | `2015_2016.2`==`2016_2017.1`,]$ID
skip.ela.ids <- unique(c(ela_wide[as.numeric(`2016_2017.1`)-as.numeric(`2015_2016.2`) > 1,]$ID, ela_wide[as.numeric(`2016_2017.1`)-as.numeric(`2015_2016.2`) > 1,]$ID))
regr.ela.ids <- unique(c(ela_wide[as.numeric(`2016_2017.1`)-as.numeric(`2015_2016.2`) < 0,]$ID, ela_wide[as.numeric(`2016_2017.1`)-as.numeric(`2015_2016.2`) < 0,]$ID))
length(unique(c(sm.cohort.ela.ids, repeat.ela.ids, skip.ela.ids, regr.ela.ids))) == length(yes.prior.ela.ids)
table(ela_wide[ID %in% skip.ela.ids][, `2015_2016.1`, `2016_2017.1`]) # Only 9th to 11th grade ELA is close (still < 1000 @ 925)

State_LONG_Data[CONTENT_AREA == "ELA" & YEAR=='2016_2017.1' & ID %in% regr.ela.ids, SGP_NOTE := "Regressed"]
State_LONG_Data[CONTENT_AREA == "ELA" & YEAR=='2016_2017.1' & ID %in% skip.ela.ids, SGP_NOTE := "Skipped"]
State_LONG_Data[CONTENT_AREA == "ELA" & YEAR=='2016_2017.1' & ID %in% repeat.ela.ids, SGP_NOTE := "Repeat"]
State_LONG_Data[CONTENT_AREA == "ELA" & YEAR=='2016_2017.1' & ID %in% sm.cohort.ela.ids, SGP_NOTE := "<1000"]

table(State_LONG_Data[, SGP_NOTE], exclude=NULL)

###  Grade Level Math

na.math.ids <- State_LONG_Data[CONTENT_AREA == "MATHEMATICS" & YEAR=='2016_2017.1' & is.na(SGP)]$ID
prior.math.ids <- State_LONG_Data[CONTENT_AREA == "MATHEMATICS" & YEAR!='2016_2017.1']$ID

####  Identify the skipped grades and repeaters, and Fall to Spring (NONE for Grade Level Math)
yes.prior.math.ids <- intersect(na.math.ids, prior.math.ids)
math <- State_LONG_Data[CONTENT_AREA == "MATHEMATICS" & ID %in% yes.prior.math.ids][, list(VALID_CASE, ID, StudentTestUUID, YEAR, GRADE)]
math_wide <- dcast(math, ID ~ YEAR, value.var="GRADE")

repeat.math.ids <- math_wide[`2015_2016.2`==`2016_2017.1`,]$ID
skip.math.ids <- math_wide[as.numeric(`2016_2017.1`)-as.numeric(`2015_2016.2`) > 1,]$ID
regr.math.ids <- math_wide[as.numeric(`2016_2017.1`)-as.numeric(`2015_2016.2`) < 0,]$ID
length(unique(c(repeat.math.ids, skip.math.ids, regr.math.ids))) == length(yes.prior.math.ids)
table(math_wide[ID %in% skip.math.ids][, `2015_2016.1`, `2016_2017.1`]) # Skipping from 6th to 8th grade Math would have been feasible

State_LONG_Data[CONTENT_AREA == "MATHEMATICS" & YEAR=='2016_2017.1' & ID %in% regr.math.ids, SGP_NOTE := "Regressed"]
State_LONG_Data[CONTENT_AREA == "MATHEMATICS" & YEAR=='2016_2017.1' & ID %in% skip.math.ids, SGP_NOTE := "Skipped"]
State_LONG_Data[CONTENT_AREA == "MATHEMATICS" & YEAR=='2016_2017.1' & ID %in% repeat.math.ids, SGP_NOTE := "Repeat"]
# State_LONG_Data[CONTENT_AREA == "MATHEMATICS" & YEAR=='2016_2017.1' & ID %in% sm.cohort.math.ids, SGP_NOTE := "<1000"]

table(State_LONG_Data[, SGP_NOTE], exclude=NULL)


###  EOCT Math

na.eoct.ids <- State_LONG_Data[!CONTENT_AREA %in% c("ELA", "ELA_SS", "MATHEMATICS", "MATHEMATICS_SS") & YEAR=='2016_2017.1' & is.na(SGP)]$ID
prior.eoct.ids <- State_LONG_Data[!CONTENT_AREA %in% c("ELA", "ELA_SS") & YEAR!='2016_2017.1']$ID

####  Identify EOCT students with no SGP, but some Math prior
yes.prior.eoct.ids <- setdiff(intersect(na.eoct.ids, prior.eoct.ids), yes.prior.math.ids) # weed out grade level math only cases

####  Identify Fall to Spring (NONE for Grade Level Math)
eoct <- State_LONG_Data[!CONTENT_AREA %in% c("ELA", "ELA_SS") & ID %in% yes.prior.eoct.ids][, list(VALID_CASE, ID, StudentTestUUID, CONTENT_AREA, YEAR)][grep("_SS", CONTENT_AREA, invert =TRUE),]
eoct_wide <- data.table(eoct[YEAR=='2016_2017.1'][, list(ID, StudentTestUUID, CONTENT_AREA)], key="ID")[data.table(eoct[YEAR!='2016_2017.1'][, list(ID, CONTENT_AREA)], key="ID")]

repeater.ids <- eoct_wide[CONTENT_AREA==i.CONTENT_AREA & i.CONTENT_AREA != "MATHEMATICS"]$ID # still 3 grade level Maths included.
repeater.test.ids <- eoct_wide[CONTENT_AREA==i.CONTENT_AREA & i.CONTENT_AREA != "MATHEMATICS"]$StudentTestUUID
repeater.plus.test.ids <- unique(eoct_wide[StudentTestUUID %in% repeater.test.ids][CONTENT_AREA != i.CONTENT_AREA]$StudentTestUUID)
repeater.ids <- setdiff(repeater.ids, unique(eoct_wide[StudentTestUUID %in% repeater.plus.test.ids]$ID)) # Identify/remove students with repeat and an additional math (small cohort) prior
State_LONG_Data[StudentTestUUID %in% setdiff(repeater.test.ids, repeater.plus.test.ids), SGP_NOTE := "Repeat"]

sm.cohort.eoct.ids <- setdiff(yes.prior.eoct.ids, repeater.ids)
State_LONG_Data[!CONTENT_AREA %in% c("ELA", "ELA_SS", "MATHEMATICS", "MATHEMATICS_SS") & YEAR=='2016_2017.1' & ID %in% sm.cohort.eoct.ids, SGP_NOTE := "<1000"]

###  Checks
nas <- State_LONG_Data[SGP_NOTE=="NA" & is.na(SGP)]

na.ela.ids <- nas[CONTENT_AREA == "ELA" & YEAR=='2016_2017.1' & is.na(SGP)]$ID
prior.ela.ids <- nas[CONTENT_AREA == "ELA" & YEAR!='2016_2017.1']$ID
no.prior.ela.ids <- setdiff(na.ela.ids, prior.ela.ids)
identical(na.ela.ids, no.prior.ela.ids) # TRUE

na.math.ids <- nas[CONTENT_AREA == "MATHEMATICS" & YEAR=='2016_2017.1' & is.na(SGP)]$ID
prior.math.ids <- nas[CONTENT_AREA == "MATHEMATICS" & YEAR!='2016_2017.1']$ID
no.prior.math.ids <- setdiff(na.math.ids, prior.math.ids)
identical(na.math.ids, no.prior.math.ids) # TRUE

na.eoct.ids <- nas[grep("_SS", CONTENT_AREA, invert =TRUE),][!CONTENT_AREA %in% c("ELA", "MATHEMATICS") & YEAR=='2016_2017.1' & is.na(SGP)]$ID
prior.eoct.ids <- nas[grep("_SS", CONTENT_AREA, invert =TRUE),][!CONTENT_AREA %in% c("ELA", "ELA_SS") & YEAR!='2016_2017.1'][grep("_SS", CONTENT_AREA, invert =TRUE),]$ID
no.prior.eoct.ids <- setdiff(na.eoct.ids, prior.eoct.ids)
identical(na.eoct.ids, no.prior.eoct.ids)

xids <- setdiff(na.eoct.ids, no.prior.eoct.ids)
data.table(eoct[ID %in% xids], key="ID") # looks like kids with 2 records in 2015_2016 (Fall or Spring) - ALL without an SGP (23 kids)
uniqueN(eoct[ID %in% xids]$ID)

###  Substitute in SGP_NOTE coding where SGP is missing
State_LONG_Data <- State_LONG_Data[YEAR=='2016_2017.1'][grep("_SS", CONTENT_AREA, invert =TRUE),]
PARCC_LONG_Data <- PARCC_SGP_LONG_Data[YEAR=='2016_2017.1'][grep("_SS", CONTENT_AREA, invert =TRUE),]

State_LONG_Data[, SGP := as.character(SGP)]
State_LONG_Data[which(is.na(SGP)), SGP := SGP_NOTE]

PARCC_LONG_Data[, SGP := as.character(SGP)]
PARCC_LONG_Data[which(is.na(SGP)), SGP := SGP_NOTE]

###  Compare the SGP_NOTE with PACKAGE_NOTE
###     These all appear to be 1) VERY rare EOCT math progressions (and regressions - e.g. Alg 2 to Alg 1).
###     or the Fall to Spring ELA progressions (high school grades) with too few kids.
###     These didn't have config scripts written out and so did not recieve a PACKAGE_NOTE.
###     Pearson will have to decide how these recors should be coded.
###     Does Pearson want any/all possible EOCT math progressions with <1000 identified (SGP_NOTE)?
###     Or do they want only those that were attempted (have a config identified)?

table(PARCC_SGP_LONG_Data[, SGP_NOTE, PACKAGE_NOTE], exclude=NULL)

table(PARCC_SGP_LONG_Data[SGP_NOTE=="<1000" & is.na(PACKAGE_NOTE), as.character(SGP_NORM_GROUP)], exclude=NULL)
table(PARCC_SGP_LONG_Data[SGP_NOTE=="Repeat" & !is.na(PACKAGE_NOTE), as.character(SGP_NORM_GROUP)], exclude=NULL) # should be 0 now

####  Explore cases where there is a SGP_NOTE, but no PACKAGE_NOTE
tmp.ids <- head(PARCC_SGP_LONG_Data[SGP_NOTE=="<1000" & is.na(PACKAGE_NOTE) & is.na(SGP_NORM_GROUP), ID], 25)
PARCC_SGP_LONG_Data[ID == tmp.ids[25]] ##  An EOCT Math course regression - Alg 2 to Alg 1

####  ELA fall to spring course progression (10th & 11th Grade ELA)
table(PARCC_SGP_LONG_Data[SGP_NOTE=="<1000" & is.na(PACKAGE_NOTE) & is.na(SGP_NORM_GROUP) & CONTENT_AREA=="ELA", TestCode], exclude=NULL)
tmp.ids <- head(PARCC_SGP_LONG_Data[SGP_NOTE=="<1000" & is.na(PACKAGE_NOTE) & is.na(SGP_NORM_GROUP) & CONTENT_AREA=="ELA", ID], 25)
PARCC_SGP_LONG_Data[ID == tmp.ids[2]] # Can check any of the 25 sample IDs in tmp.ids


##
##   Final data cleanup and construction of variables Pearson requested
##

###   State Data

###    Remove rows associated with the Scale Score SGP
State_LONG_Data[, ID:=gsub("_DUPS_[0-9]*", "", ID)]

setnames(State_LONG_Data,
	c("ID", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_CSEM_ACTUAL", "SCALE_SCORE", "SCALE_SCORE_CSEM",
	  "SGP", "SGP_0.05_CONFIDENCE_BOUND", "SGP_0.95_CONFIDENCE_BOUND"),
	c("PARCCStudentIdentifier", "SummativeScaleScore", "SummativeCSEM", "IRTTheta", "Filler",
	  "StudentGrowthPercentileComparedtoState", "SGPLowerBoundState", "SGPUpperBoundState"))

###    Split SGP_NORM_GROUP to create 'SGPPreviousTestCode*' Variables
state.tmp.split <- strsplit(as.character(State_LONG_Data$SGP_NORM_GROUP), "; ")
State_LONG_Data[, CONTENT_AREA_PRIOR := sapply(sapply(strsplit(sapply(strsplit(sapply(state.tmp.split, function(x) rev(x)[2]), "/"), '[', 2), "_"), head, -1), paste, collapse="_")]
State_LONG_Data[, GRADE_PRIOR := sapply(strsplit(sapply(strsplit(sapply(state.tmp.split, function(x) rev(x)[2]), "/"), '[', 2), "_"), tail, 1)]
State_LONG_Data[which(GRADE_PRIOR=="EOCT"), GRADE_PRIOR := ""]
State_LONG_Data[, SGPPreviousTestCodeState := factor(paste(CONTENT_AREA_PRIOR, GRADE_PRIOR))]

###  Recode new SGPPreviousTestCodeState Variable.  Check table(levels(State_LONG_Data$SGPPreviousTestCodeState)) before and after to ensure match!!!
table(State_LONG_Data$SGPPreviousTestCodeState)
levels(State_LONG_Data$SGPPreviousTestCodeState) <- c(NA, "ALG01", "ALG02", "ELA10", "ELA03", "ELA04", "ELA05", "ELA06", "ELA07", "ELA08", "ELA09",
	"GEO01", "MAT1I", "MAT2I", "MAT3I", "MAT03", "MAT04", "MAT05", "MAT06", "MAT07", "MAT08")
table(State_LONG_Data$SGPPreviousTestCodeState, exclude=NULL) ##  Match???

State_LONG_Data[, SGPPreviousTestCodeState := as.character(SGPPreviousTestCodeState)]
State_LONG_Data[, CONTENT_AREA_PRIOR := NULL]
State_LONG_Data[, GRADE_PRIOR := NULL]

save(State_LONG_Data, file="./PARCC/Data/Pearson/State_LONG_Data-FORMATTED.Rdata")

State_LONG_Data <- State_LONG_Data[, names(State_LONG_Data)[names(State_LONG_Data) %in% all.names], with=FALSE]


###   PARCC Consortium Data

PARCC_LONG_Data[, ID:=gsub("_DUPS_[0-9]*", "", ID)]

setnames(PARCC_LONG_Data,
	c("ID", "SCALE_SCORE_ACTUAL", "SCALE_SCORE", "SCALE_SCORE_CSEM_ACTUAL", "SCALE_SCORE_CSEM",
	  "SGP", "SGP_0.05_CONFIDENCE_BOUND", "SGP_0.95_CONFIDENCE_BOUND"),
	c("PARCCStudentIdentifier", "SummativeScaleScore", "IRTTheta", "SummativeCSEM", "Filler",
	  "StudentGrowthPercentileComparedtoPARCC", "SGPLowerBoundPARCC", "SGPUpperBoundPARCC"))

### Split SGP_NORM_GROUP to create 'SGPPreviousTestCode*' Variables
parcc.tmp.split <- strsplit(as.character(PARCC_LONG_Data$SGP_NORM_GROUP), "; ")
PARCC_LONG_Data[, CONTENT_AREA_PRIOR := sapply(sapply(strsplit(sapply(strsplit(sapply(parcc.tmp.split, function(x) rev(x)[2]), "/"), '[', 2), "_"), head, -1), paste, collapse="_")]
PARCC_LONG_Data[, GRADE_PRIOR := sapply(strsplit(sapply(strsplit(sapply(parcc.tmp.split, function(x) rev(x)[2]), "/"), '[', 2), "_"), tail, 1)]
PARCC_LONG_Data[which(GRADE_PRIOR=="EOCT"), GRADE_PRIOR := ""]
PARCC_LONG_Data[, SGPPreviousTestCodePARCC := factor(paste(CONTENT_AREA_PRIOR, GRADE_PRIOR))]

###  Recode new SGPPreviousTestCodePARCC Variable.  Check table(levels(PARCC_LONG_Data$SGPPreviousTestCodePARCC)) before and after to ensure match!!!
table(PARCC_LONG_Data$SGPPreviousTestCodePARCC)
levels(PARCC_LONG_Data$SGPPreviousTestCodePARCC) <- c(NA, "ALG01", "ALG02", "ELA10", "ELA03", "ELA04", "ELA05", "ELA06", "ELA07", "ELA08", "ELA09",
	"GEO01", "MAT1I", "MAT2I", "MAT3I", "MAT03", "MAT04", "MAT05", "MAT06", "MAT07", "MAT08")
table(PARCC_LONG_Data$SGPPreviousTestCodePARCC, exclude=NULL) ##  Match???

PARCC_LONG_Data[, SGPPreviousTestCodePARCC := as.character(SGPPreviousTestCodePARCC)]
PARCC_LONG_Data[, CONTENT_AREA_PRIOR := NULL]
PARCC_LONG_Data[, GRADE_PRIOR := NULL]

save(PARCC_LONG_Data, file="./PARCC/Data/Pearson/PARCC_LONG_Data-FORMATTED.Rdata")

PARCC_LONG_Data <- PARCC_LONG_Data[, names(PARCC_LONG_Data)[names(PARCC_LONG_Data) %in% all.names], with=FALSE]

###       Merge PARCC and State Data
FINAL_LONG_Data <- merge(PARCC_LONG_Data, State_LONG_Data, by=intersect(names(PARCC_LONG_Data), names(State_LONG_Data)), all.x=TRUE)
FINAL_LONG_Data[is.na(StudentGrowthPercentileComparedtoState), StudentGrowthPercentileComparedtoState := "NA"]

setcolorder(FINAL_LONG_Data, all.names)

###
###  Save R object and Export/zip State specific .csv files
###

dir.create("./PARCC/Data/Pearson")
save(FINAL_LONG_Data, file="./PARCC/Data/Pearson/PARCC_SGP_LONG_Data_2016_2017.1-FORMATTED.Rdata")

####  First remove unused/unrequested NOTE versions and values/levels

FINAL_LONG_Data[, PACKAGE_NOTE := NULL]
FINAL_LONG_Data[which(StudentGrowthPercentileComparedtoPARCC %in% c("NA", "Regressed", "Repeat", "Skipped")), StudentGrowthPercentileComparedtoPARCC := as.character(NA)]
FINAL_LONG_Data[which(StudentGrowthPercentileComparedtoState %in% c("NA", "Regressed", "Repeat", "Skipped")), StudentGrowthPercentileComparedtoState := as.character(NA)]

####  Loop on State Abbreviation to write out each state file in format that it was recieved and return requested
for (abv in tail(unique(FINAL_LONG_Data$StateAbbreviation), -1)) {
	dir.create(dir.name <- paste0("./",  gsub(" ", "_", capwords(SGP:::getStateAbbreviation(abv, type="state"), special.words="DC")), "/Data/Pearson"), recursive=TRUE)
	fname <- paste0(dir.name, "/PARCC_", abv, "_2015-2016_SGP-Results_", format(Sys.Date(), format="%Y%m%d"), ".csv")
	fwrite(FINAL_LONG_Data[StateAbbreviation == abv & AssessmentYear == "2015-2016" & Period == "Spring"], fname) #, col.names = FALSE
	zip(zipfile=paste(fname, "zip", sep="."), files=fname, flags="-mq")
}
