################################################################################
###                                                                          ###
###            Format PARCC 2016 Results Data to Return to Pearson           ###
###                                                                          ###
################################################################################

### Load required packages

require(SGP)
require(data.table)

setwd("/media/Data/PARCC")

###
###    Read in Fall and Spring 2016 Output Files
###

load("./PARCC/Data/PARCC_SGP_LONG_Data.Rdata")

load("./Colorado/Data/Colorado_SGP_LONG_Data.Rdata")
load("./Illinois/Data/Illinois_SGP_LONG_Data.Rdata")
load("./Maryland/Data/Maryland_SGP_LONG_Data.Rdata")
load("./Massachusetts/Data/Massachusetts_SGP_LONG_Data.Rdata")
load("./New_Jersey/Data/New_Jersey_SGP_LONG_Data.Rdata")
load("./New_Mexico/Data/New_Mexico_SGP_LONG_Data.Rdata")
load("./Rhode_Island/Data/Rhode_Island_SGP_LONG_Data.Rdata")
load("./Washington_DC/Data/WASHINGTON_DC_SGP_LONG_Data.Rdata")

####  Set names based on Pearson file layout
parcc.var.names <- c("AssessmentYear", "StateAbbreviation", "PARCCStudentIdentifier", "GradeLevelWhenAssessed", "Period", "TestCode", 
                     "SummativeScoreRecordUUID", "StudentTestUUID", "SummativeScaleScore", "IRTTheta", "SummativeCSEM", "Filler", "TestFormat")

center.var.names <- c("StudentGrowthPercentileComparedtoState", "StudentGrowthPercentileComparedtoPARCC", "SGPPreviousTestCodeState",
                      "SGPPreviousTestCodePARCC", "SGPUpperBoundState", "SGPLowerBoundState", "SGPUpperBoundPARCC", "SGPLowerBoundPARCC")

all.var.names <- c(head(parcc.var.names,-1), center.var.names, "TestFormat") # TestFormat is out of order

####  State Data

State_LONG_Data <- rbindlist(list(
	Colorado_SGP_LONG_Data, Illinois_SGP_LONG_Data, Maryland_SGP_LONG_Data,
	Massachusetts_SGP_LONG_Data, New_Jersey_SGP_LONG_Data, New_Mexico_SGP_LONG_Data,
	Rhode_Island_SGP_LONG_Data, WASHINGTON_DC_SGP_LONG_Data), fill=TRUE)


#####
###    Data for Consolodated SGP object
#####

load("./PARCC/Data/PARCC_SGP.Rdata")

State_Subset <- State_LONG_Data[, list(VALID_CASE, CONTENT_AREA, YEAR, ID, SGP_SIMEX, SGP, SGP_0.05_CONFIDENCE_BOUND, SGP_0.95_CONFIDENCE_BOUND, SGP_NORM_GROUP)][!is.na(SGP) & YEAR=='2015_2016.2']
state.vars <- c("SGP_SIMEX", "SGP", "SGP_0.05_CONFIDENCE_BOUND", "SGP_0.95_CONFIDENCE_BOUND", "SGP_NORM_GROUP")
setnames(State_Subset, state.vars, paste(state.vars, "_STATE", sep=""))
setkey(State_Subset, VALID_CASE, CONTENT_AREA, YEAR, ID)
setkey(PARCC_SGP_LONG_Data, VALID_CASE, CONTENT_AREA, YEAR, ID)
PARCC_SGP@Data <- merge(PARCC_SGP_LONG_Data, State_Subset, all.x=TRUE)

PARCC_SGP <- prepareSGP(PARCC_SGP)

dir.create("./CONSORTIUM/Data", recursive=TRUE)
save(PARCC_SGP, file="./CONSORTIUM/Data/PARCC_SGP-Consortium.Rdata")


#####
###    Data for formatted output to Pearson
#####

##  Add in the Missing SGP identifiers requested by Pearson

###  PARCC Consortium

####  ELA

PARCC_SGP_LONG_Data[, MISSING_SGP := "NA"]
na.ela.ids <- PARCC_SGP_LONG_Data[CONTENT_AREA == "ELA" & YEAR=='2015_2016.2' & is.na(SGP)]$ID
prior.ela.ids <- PARCC_SGP_LONG_Data[CONTENT_AREA == "ELA" & YEAR!='2015_2016.2']$ID

####  Identify the skipped grades and repeaters, and Fall to Spring (Actual Small Cohort)
yes.prior.ela.ids <- intersect(na.ela.ids, prior.ela.ids)
ela <- PARCC_SGP_LONG_Data[CONTENT_AREA == "ELA" & ID %in% yes.prior.ela.ids][, list(VALID_CASE, ID, StudentTestUUID, YEAR, GRADE)]
ela_wide <- dcast(ela, ID ~ YEAR, value.var="GRADE")

sm.cohort.ela.ids <- ela_wide[as.numeric(`2015_2016.2`)-as.numeric(`2015_2016.1`) == 1,]$ID
repeat.ela.ids <- ela_wide[`2014_2015.2`==`2015_2016.2` | `2015_2016.1`==`2015_2016.2`,]$ID
skip.ela.ids <- unique(c(ela_wide[as.numeric(`2015_2016.2`)-as.numeric(`2015_2016.1`) > 1,]$ID, ela_wide[as.numeric(`2015_2016.2`)-as.numeric(`2014_2015.2`) > 1,]$ID))
regr.ela.ids <- unique(c(ela_wide[as.numeric(`2015_2016.2`)-as.numeric(`2015_2016.1`) < 0,]$ID, ela_wide[as.numeric(`2015_2016.2`)-as.numeric(`2014_2015.2`) < 0,]$ID))
length(unique(c(sm.cohort.ela.ids, repeat.ela.ids, skip.ela.ids, regr.ela.ids))) == length(yes.prior.ela.ids)
table(ela_wide[ID %in% skip.ela.ids][, `2014_2015.2`, `2015_2016.2`]) # Only 9th to 11th grade ELA is close (still < 1000 @ 920)

PARCC_SGP_LONG_Data[CONTENT_AREA == "ELA" & YEAR=='2015_2016.2' & ID %in% regr.ela.ids, MISSING_SGP := "Regressed"]
PARCC_SGP_LONG_Data[CONTENT_AREA == "ELA" & YEAR=='2015_2016.2' & ID %in% skip.ela.ids, MISSING_SGP := "Skipped"]
PARCC_SGP_LONG_Data[CONTENT_AREA == "ELA" & YEAR=='2015_2016.2' & ID %in% repeat.ela.ids, MISSING_SGP := "Repeat"]
PARCC_SGP_LONG_Data[CONTENT_AREA == "ELA" & YEAR=='2015_2016.2' & ID %in% sm.cohort.ela.ids, MISSING_SGP := "<1000"]

table(PARCC_SGP_LONG_Data[, MISSING_SGP])

###  Grade Level Math

na.math.ids <- PARCC_SGP_LONG_Data[CONTENT_AREA == "MATHEMATICS" & YEAR=='2015_2016.2' & is.na(SGP)]$ID
prior.math.ids <- PARCC_SGP_LONG_Data[CONTENT_AREA == "MATHEMATICS" & YEAR!='2015_2016.2']$ID

####  Identify the skipped grades and repeaters, and Fall to Spring (NONE for Grade Level Math)
yes.prior.math.ids <- intersect(na.math.ids, prior.math.ids)
math <- PARCC_SGP_LONG_Data[CONTENT_AREA == "MATHEMATICS" & ID %in% yes.prior.math.ids][, list(VALID_CASE, ID, StudentTestUUID, YEAR, GRADE)]
math_wide <- dcast(math, ID ~ YEAR, value.var="GRADE")

# sm.cohort.math.ids <- math_wide[as.numeric(`2015_2016.2`)-as.numeric(`2014_2015.2`) == 1,]$ID
repeat.math.ids <- math_wide[`2014_2015.2`==`2015_2016.2`,]$ID
skip.math.ids <- math_wide[as.numeric(`2015_2016.2`)-as.numeric(`2014_2015.2`) > 1,]$ID
regr.math.ids <- math_wide[as.numeric(`2015_2016.2`)-as.numeric(`2014_2015.2`) < 0,]$ID
length(unique(c(repeat.math.ids, skip.math.ids, regr.math.ids))) == length(yes.prior.math.ids)
table(math_wide[ID %in% skip.math.ids][, `2014_2015.2`, `2015_2016.2`]) # Skipping from 6th to 8th grade Math would have been feasible

PARCC_SGP_LONG_Data[CONTENT_AREA == "MATHEMATICS" & YEAR=='2015_2016.2' & ID %in% regr.math.ids, MISSING_SGP := "Regressed"]
PARCC_SGP_LONG_Data[CONTENT_AREA == "MATHEMATICS" & YEAR=='2015_2016.2' & ID %in% skip.math.ids, MISSING_SGP := "Skipped"]
PARCC_SGP_LONG_Data[CONTENT_AREA == "MATHEMATICS" & YEAR=='2015_2016.2' & ID %in% repeat.math.ids, MISSING_SGP := "Repeat"]
# PARCC_SGP_LONG_Data[CONTENT_AREA == "MATHEMATICS" & YEAR=='2015_2016.2' & ID %in% sm.cohort.math.ids, MISSING_SGP := "<1000"]

table(PARCC_SGP_LONG_Data[, MISSING_SGP])


###  EOCT Math

na.eoct.ids <- PARCC_SGP_LONG_Data[!CONTENT_AREA %in% c("ELA", "ELA_SS", "MATHEMATICS", "MATHEMATICS_SS") & YEAR=='2015_2016.2' & is.na(SGP)]$ID
prior.eoct.ids <- PARCC_SGP_LONG_Data[!CONTENT_AREA %in% c("ELA", "ELA_SS") & YEAR!='2015_2016.2']$ID

####  Identify EOCT students with no SGP, but some Math prior
yes.prior.eoct.ids <- setdiff(intersect(na.eoct.ids, prior.eoct.ids), yes.prior.math.ids) # weed out grade level math only cases

####  Identify Fall to Spring (NONE for Grade Level Math)
eoct <- PARCC_SGP_LONG_Data[!CONTENT_AREA %in% c("ELA", "ELA_SS") & ID %in% yes.prior.eoct.ids][, list(VALID_CASE, ID, StudentTestUUID, CONTENT_AREA, YEAR)][grep("_SS", CONTENT_AREA, invert =TRUE),]
eoct_wide <- data.table(eoct[YEAR=='2015_2016.2'][, list(ID, StudentTestUUID, CONTENT_AREA)], key="ID")[data.table(eoct[YEAR!='2015_2016.2'][, list(ID, CONTENT_AREA)], key="ID")]

repeater.ids <- eoct_wide[CONTENT_AREA==i.CONTENT_AREA & i.CONTENT_AREA != "MATHEMATICS"]$ID # still 3 grade level Maths included.
repeater.test.ids <- eoct_wide[CONTENT_AREA==i.CONTENT_AREA & i.CONTENT_AREA != "MATHEMATICS"]$StudentTestUUID # still 3 grade level Maths included.
PARCC_SGP_LONG_Data[StudentTestUUID %in% repeater.test.ids, MISSING_SGP := "Repeat"]

sm.cohort.eoct.ids <- setdiff(yes.prior.eoct.ids, repeater.ids)
PARCC_SGP_LONG_Data[!CONTENT_AREA %in% c("ELA", "ELA_SS", "MATHEMATICS", "MATHEMATICS_SS") & YEAR=='2015_2016.2' & ID %in% sm.cohort.eoct.ids, MISSING_SGP := "<1000"]

###  Checks
nas <- PARCC_SGP_LONG_Data[MISSING_SGP=="NA" & is.na(SGP)]

na.ela.ids <- nas[CONTENT_AREA == "ELA" & YEAR=='2015_2016.2' & is.na(SGP)]$ID
prior.ela.ids <- nas[CONTENT_AREA == "ELA" & YEAR!='2015_2016.2']$ID
no.prior.ela.ids <- setdiff(na.ela.ids, prior.ela.ids)
identical(na.ela.ids, no.prior.ela.ids)

na.math.ids <- nas[CONTENT_AREA == "MATHEMATICS" & YEAR=='2015_2016.2' & is.na(SGP)]$ID
prior.math.ids <- nas[CONTENT_AREA == "MATHEMATICS" & YEAR!='2015_2016.2']$ID
no.prior.math.ids <- setdiff(na.math.ids, prior.math.ids)
identical(na.math.ids, no.prior.math.ids)

na.eoct.ids <- nas[grep("_SS", CONTENT_AREA, invert =TRUE),][!CONTENT_AREA %in% c("ELA", "MATHEMATICS") & YEAR=='2015_2016.2' & is.na(SGP)]$ID
prior.eoct.ids <- nas[grep("_SS", CONTENT_AREA, invert =TRUE),][!CONTENT_AREA %in% c("ELA", "ELA_SS") & YEAR!='2015_2016.2'][grep("_SS", CONTENT_AREA, invert =TRUE),]$ID
no.prior.eoct.ids <- setdiff(na.eoct.ids, prior.eoct.ids)
identical(na.eoct.ids, no.prior.eoct.ids)

xids <- setdiff(na.eoct.ids, no.prior.eoct.ids)
data.table(eoct[ID %in% xids], key="ID") # looks like kids with 2 records in 2015_2016.2 - one without an SGP and the other with (8 kids)


###  PARCC States

####  ELA

State_LONG_Data[, MISSING_SGP := "NA"]
na.ela.ids <- State_LONG_Data[CONTENT_AREA == "ELA" & YEAR=='2015_2016.2' & is.na(SGP)]$ID
prior.ela.ids <- State_LONG_Data[CONTENT_AREA == "ELA" & YEAR!='2015_2016.2']$ID

####  Identify the skipped grades and repeaters, and Fall to Spring (Actual Small Cohort)
yes.prior.ela.ids <- intersect(na.ela.ids, prior.ela.ids)
ela <- State_LONG_Data[CONTENT_AREA == "ELA" & ID %in% yes.prior.ela.ids][, list(VALID_CASE, ID, StudentTestUUID, YEAR, GRADE)]
ela_wide <- dcast(ela, ID ~ YEAR, value.var="GRADE")

sm.cohort.ela.ids <- unique(c(ela_wide[as.numeric(`2015_2016.2`)-as.numeric(`2015_2016.1`) == 1,]$ID, ela_wide[as.numeric(`2015_2016.2`)-as.numeric(`2014_2015.2`) == 1,]$ID))
repeat.ela.ids <- ela_wide[`2014_2015.2`==`2015_2016.2` | `2015_2016.1`==`2015_2016.2`,]$ID
skip.ela.ids <- unique(c(ela_wide[as.numeric(`2015_2016.2`)-as.numeric(`2015_2016.1`) > 1,]$ID, ela_wide[as.numeric(`2015_2016.2`)-as.numeric(`2014_2015.2`) > 1,]$ID))
regr.ela.ids <- unique(c(ela_wide[as.numeric(`2015_2016.2`)-as.numeric(`2015_2016.1`) < 0,]$ID, ela_wide[as.numeric(`2015_2016.2`)-as.numeric(`2014_2015.2`) < 0,]$ID))
length(unique(c(sm.cohort.ela.ids, repeat.ela.ids, skip.ela.ids, regr.ela.ids))) == length(yes.prior.ela.ids)
table(ela_wide[ID %in% skip.ela.ids][, `2014_2015.2`, `2015_2016.2`]) # Only 9th to 11th grade ELA is close (still < 1000 @ 920)

State_LONG_Data[CONTENT_AREA == "ELA" & YEAR=='2015_2016.2' & ID %in% regr.ela.ids, MISSING_SGP := "Regressed"]
State_LONG_Data[CONTENT_AREA == "ELA" & YEAR=='2015_2016.2' & ID %in% skip.ela.ids, MISSING_SGP := "Skipped"]
State_LONG_Data[CONTENT_AREA == "ELA" & YEAR=='2015_2016.2' & ID %in% repeat.ela.ids, MISSING_SGP := "Repeat"]
State_LONG_Data[CONTENT_AREA == "ELA" & YEAR=='2015_2016.2' & ID %in% sm.cohort.ela.ids, MISSING_SGP := "<1000"]

table(State_LONG_Data[, MISSING_SGP], exclude=NULL)

###  Grade Level Math

na.math.ids <- State_LONG_Data[CONTENT_AREA == "MATHEMATICS" & YEAR=='2015_2016.2' & is.na(SGP)]$ID
prior.math.ids <- State_LONG_Data[CONTENT_AREA == "MATHEMATICS" & YEAR!='2015_2016.2']$ID

####  Identify the skipped grades and repeaters, and Fall to Spring (NONE for Grade Level Math)
yes.prior.math.ids <- intersect(na.math.ids, prior.math.ids)
math <- State_LONG_Data[CONTENT_AREA == "MATHEMATICS" & ID %in% yes.prior.math.ids][, list(VALID_CASE, ID, StudentTestUUID, YEAR, GRADE)]
math_wide <- dcast(math, ID ~ YEAR, value.var="GRADE")

# sm.cohort.math.ids <- math_wide[as.numeric(`2015_2016.2`)-as.numeric(`2014_2015.2`) == 1,]$ID
repeat.math.ids <- math_wide[`2014_2015.2`==`2015_2016.2`,]$ID
skip.math.ids <- math_wide[as.numeric(`2015_2016.2`)-as.numeric(`2014_2015.2`) > 1,]$ID
regr.math.ids <- math_wide[as.numeric(`2015_2016.2`)-as.numeric(`2014_2015.2`) < 0,]$ID
length(unique(c(repeat.math.ids, skip.math.ids, regr.math.ids))) == length(yes.prior.math.ids)
table(math_wide[ID %in% skip.math.ids][, `2014_2015.2`, `2015_2016.2`]) # Skipping from 6th to 8th grade Math would have been feasible

State_LONG_Data[CONTENT_AREA == "MATHEMATICS" & YEAR=='2015_2016.2' & ID %in% regr.math.ids, MISSING_SGP := "Regressed"]
State_LONG_Data[CONTENT_AREA == "MATHEMATICS" & YEAR=='2015_2016.2' & ID %in% skip.math.ids, MISSING_SGP := "Skipped"]
State_LONG_Data[CONTENT_AREA == "MATHEMATICS" & YEAR=='2015_2016.2' & ID %in% repeat.math.ids, MISSING_SGP := "Repeat"]
# State_LONG_Data[CONTENT_AREA == "MATHEMATICS" & YEAR=='2015_2016.2' & ID %in% sm.cohort.math.ids, MISSING_SGP := "<1000"]

table(State_LONG_Data[, MISSING_SGP], exclude=NULL)


###  EOCT Math

na.eoct.ids <- State_LONG_Data[!CONTENT_AREA %in% c("ELA", "ELA_SS", "MATHEMATICS", "MATHEMATICS_SS") & YEAR=='2015_2016.2' & is.na(SGP)]$ID
prior.eoct.ids <- State_LONG_Data[!CONTENT_AREA %in% c("ELA", "ELA_SS") & YEAR!='2015_2016.2']$ID

####  Identify EOCT students with no SGP, but some Math prior
yes.prior.eoct.ids <- setdiff(intersect(na.eoct.ids, prior.eoct.ids), yes.prior.math.ids) # weed out grade level math only cases

####  Identify Fall to Spring (NONE for Grade Level Math)
eoct <- State_LONG_Data[!CONTENT_AREA %in% c("ELA", "ELA_SS") & ID %in% yes.prior.eoct.ids][, list(VALID_CASE, ID, StudentTestUUID, CONTENT_AREA, YEAR)][grep("_SS", CONTENT_AREA, invert =TRUE),]
eoct_wide <- data.table(eoct[YEAR=='2015_2016.2'][, list(ID, StudentTestUUID, CONTENT_AREA)], key="ID")[data.table(eoct[YEAR!='2015_2016.2'][, list(ID, CONTENT_AREA)], key="ID")]

repeater.ids <- eoct_wide[CONTENT_AREA==i.CONTENT_AREA & i.CONTENT_AREA != "MATHEMATICS"]$ID # still 3 grade level Maths included.
repeater.test.ids <- eoct_wide[CONTENT_AREA==i.CONTENT_AREA & i.CONTENT_AREA != "MATHEMATICS"]$StudentTestUUID # still 3 grade level Maths included.
State_LONG_Data[StudentTestUUID %in% repeater.test.ids, MISSING_SGP := "Repeat"]

sm.cohort.eoct.ids <- setdiff(yes.prior.eoct.ids, repeater.ids)
State_LONG_Data[!CONTENT_AREA %in% c("ELA", "ELA_SS", "MATHEMATICS", "MATHEMATICS_SS") & YEAR=='2015_2016.2' & ID %in% sm.cohort.eoct.ids, MISSING_SGP := "<1000"]

###  Checks
nas <- State_LONG_Data[MISSING_SGP=="NA" & is.na(SGP)]

na.ela.ids <- nas[CONTENT_AREA == "ELA" & YEAR=='2015_2016.2' & is.na(SGP)]$ID
prior.ela.ids <- nas[CONTENT_AREA == "ELA" & YEAR!='2015_2016.2']$ID
no.prior.ela.ids <- setdiff(na.ela.ids, prior.ela.ids)
identical(na.ela.ids, no.prior.ela.ids)
# xids <- setdiff(na.ela.ids, no.prior.ela.ids)
# m.ela <- data.table(State_LONG_Data[CONTENT_AREA == "ELA" & ID %in% xids], key="ID") # looks like kids with 2 records in 2015_2016.2 - one without an SGP and the other with (8 kids)

na.math.ids <- nas[CONTENT_AREA == "MATHEMATICS" & YEAR=='2015_2016.2' & is.na(SGP)]$ID
prior.math.ids <- nas[CONTENT_AREA == "MATHEMATICS" & YEAR!='2015_2016.2']$ID
no.prior.math.ids <- setdiff(na.math.ids, prior.math.ids)
identical(na.math.ids, no.prior.math.ids)

na.eoct.ids <- nas[grep("_SS", CONTENT_AREA, invert =TRUE),][!CONTENT_AREA %in% c("ELA", "MATHEMATICS") & YEAR=='2015_2016.2' & is.na(SGP)]$ID
prior.eoct.ids <- nas[grep("_SS", CONTENT_AREA, invert =TRUE),][!CONTENT_AREA %in% c("ELA", "ELA_SS") & YEAR!='2015_2016.2'][grep("_SS", CONTENT_AREA, invert =TRUE),]$ID
no.prior.eoct.ids <- setdiff(na.eoct.ids, prior.eoct.ids)
identical(na.eoct.ids, no.prior.eoct.ids)

xids <- setdiff(na.eoct.ids, no.prior.eoct.ids)
data.table(eoct[ID %in% xids], key="ID") # looks like kids with 2 records in 2015_2016.2 - one without an SGP and the other with (8 kids)

###  Substitute in MISSING_SGP coding where SGP is missing
State_LONG_Data <- State_LONG_Data[YEAR=='2015_2016.2'][grep("_SS", CONTENT_AREA, invert =TRUE),]
PARCC_LONG_Data <- PARCC_SGP_LONG_Data[YEAR=='2015_2016.2'][grep("_SS", CONTENT_AREA, invert =TRUE),]

State_LONG_Data[, SGP := as.character(SGP)]
State_LONG_Data[which(is.na(SGP)), SGP := MISSING_SGP]

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
levels(State_LONG_Data$SGPPreviousTestCodeState) <- c("ALG01", "ALG02", "ELA10", "ELA03", "ELA04", "ELA05", "ELA06", "ELA07", "ELA08", "ELA09",
	"GEO01", "MAT1I", "MAT03", "MAT04", "MAT05", "MAT06", "MAT07", "MAT08", NA)
State_LONG_Data[, SGPPreviousTestCodeState := as.character(SGPPreviousTestCodeState)]
State_LONG_Data[, CONTENT_AREA_PRIOR := NULL]
State_LONG_Data[, GRADE_PRIOR := NULL]

State_LONG_Data <- State_LONG_Data[, names(State_LONG_Data)[names(State_LONG_Data) %in% all.var.names], with=FALSE]

###   PARCC Consortium Data

PARCC_LONG_Data[, SGP := as.character(SGP)]
PARCC_LONG_Data[which(is.na(SGP)), SGP := MISSING_SGP]

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
levels(PARCC_LONG_Data$SGPPreviousTestCodePARCC) <- c("ALG01", "ALG02", "ELA10", "ELA03", "ELA04", "ELA05", "ELA06", "ELA07", "ELA08", "ELA09",
	"GEO01", "MAT1I", "MAT03", "MAT04", "MAT05", "MAT06", "MAT07", "MAT08", NA)
PARCC_LONG_Data[, SGPPreviousTestCodePARCC := as.character(SGPPreviousTestCodePARCC)]
PARCC_LONG_Data[, CONTENT_AREA_PRIOR := NULL]
PARCC_LONG_Data[, GRADE_PRIOR := NULL]

PARCC_LONG_Data <- PARCC_LONG_Data[, names(PARCC_LONG_Data)[names(PARCC_LONG_Data) %in% all.var.names], with=FALSE]

###       Merge PARCC and State Data
FINAL_LONG_Data <- merge(PARCC_LONG_Data, State_LONG_Data, by=intersect(names(PARCC_LONG_Data), names(State_LONG_Data)), all.x=TRUE)
FINAL_LONG_Data[is.na(StudentGrowthPercentileComparedtoState), StudentGrowthPercentileComparedtoState := "NA"]

setcolorder(FINAL_LONG_Data, all.var.names)

###  Export/zip State specific .csv files
dir.create("./CONSORTIUM/Data")
setwd("./CONSORTIUM/Data")
for (abv in tail(unique(FINAL_LONG_Data$StateAbbreviation), -1)) {
	fname <- paste("PARCC_", abv, "_2015-2016_SGP-Results_", format(Sys.Date(), format="%Y%m%d"), ".csv", sep="")
	fwrite(FINAL_LONG_Data[StateAbbreviation == abv & AssessmentYear == "2015-2016" & Period == "Spring"], fname) #, col.names = FALSE
	zip(zipfile=paste(fname, "zip", sep="."), files=fname, flags="-mq")
}

save(FINAL_LONG_Data, file="PARCC_SGP_LONG_Data_2015_2016.2-FORMATTED.Rdata")

