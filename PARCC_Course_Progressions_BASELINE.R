################################################################################
###                                                                          ###
###     Identify 2019 BASELINE Progressions for New Meridian Consortium      ###
###                                                                          ###
################################################################################

library(SGP)
library(data.table)


###   Load Original Consortium data from 2019 PARCC SGP Analyses

load("PARCC/Data/Archive/2018_2019.2/PARCC_SGP_LONG_Data.Rdata")
load("PARCC/Data/Archive/2015_2016.2/PARCC_SGP_LONG_Data_2015_2016.2.Rdata")

###   Create a smaller subset of the LONG data to work with.
parcc.members <- c("BI", "DC", "DD", "IL", "MD", "NJ", "NM") # c("BI", "DD", "IL")
parcc.years <- c("2016_2017.2", "2017_2018.2", "2018_2019.2")
parcc.subjects <- c("ELA", "MATHEMATICS", "ALGEBRA_I", "GEOMETRY", "ALGEBRA_II")

PARCC_Baseline_Data <- rbindlist(list(
		PARCC_SGP_LONG_Data_2015_2016.2[
			StateAbbreviation %in% parcc.members & CONTENT_AREA %in% parcc.subjects,
			list(VALID_CASE, ID, YEAR, CONTENT_AREA, GRADE, SCALE_SCORE, SCALE_SCORE_CSEM, ACHIEVEMENT_LEVEL, StateAbbreviation)],
		PARCC_SGP_LONG_Data[
			StateAbbreviation %in% parcc.members & CONTENT_AREA %in% parcc.subjects & YEAR %in% parcc.years,
			list(VALID_CASE, ID, YEAR, CONTENT_AREA, GRADE, SCALE_SCORE, SCALE_SCORE_CSEM, ACHIEVEMENT_LEVEL, StateAbbreviation)]))

###  Get subset of PARCC_Baseline_Data with only IDs from Spring 2018

ids <- unique(PARCC_Baseline_Data[YEAR=="2018_2019.2", ID])
Baseline_Data_LONG <- PARCC_Baseline_Data[ID %in% ids,]

table(Baseline_Data_LONG[!CONTENT_AREA %in% "ELA", CONTENT_AREA, YEAR])
table(Baseline_Data_LONG[CONTENT_AREA %in% "ELA", as.numeric(GRADE), YEAR])
table(Baseline_Data_LONG[YEAR=="2018_2019.2", GRADE, CONTENT_AREA])

###  Run courseProgressionSGP by content area subsets of the Baseline_Data_LONG

math.prog<- courseProgressionSGP(Baseline_Data_LONG[!CONTENT_AREA %in% "ELA"], lag.direction="BACKWARD", year="2018_2019.2")
ela.prog <- courseProgressionSGP(Baseline_Data_LONG[CONTENT_AREA %in% "ELA"], lag.direction="BACKWARD", year="2018_2019.2")


####
####     Mathematics
####

###  Find out which Math related content areas are present in the Fall data
names(math.prog$BACKWARD[["2018_2019.2"]])

###
###   Algebra I (No Repeaters or Regression)
###

ALG1 <- math.prog$BACKWARD[["2018_2019.2"]]$ALGEBRA_I.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "ALGEBRA_I.EOCT" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks
ALG1 <- ALG1[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "ALGEBRA_I.EOCT"]
table(ALG1$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
ALG1[COUNT > 100]  #  Major progressions

###   Viable 1 Prior (Fall 18) ALGEBRA_I Progressions
ALG1[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]

###   Viable skip-year prior (Spring 17) ALGEBRA_I Progressions
ALG1[, list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2)][Total > 100]
ALG1[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.2"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2)][Total > 100]

###   Viable 2 Prior (Spring 17 + Spring 16) ALGEBRA_I Progressions
ALG1[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.3")][Total > 999]


###
###   Geometry (No Repeaters)
###

GEOM <- math.prog$BACKWARD[["2018_2019.2"]]$GEOMETRY.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "GEOMETRY.EOCT" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks
GEOM <- GEOM[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "GEOMETRY.EOCT"]
table(GEOM$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
GEOM[COUNT > 100]  #  Major progressions

###   Viable 1 Prior (Fall 18) ALGEBRA_I Progressions
GEOM[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]

###   Viable skip-year prior (Spring 17) ALGEBRA_I Progressions
GEOM[, list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2)][Total > 100]
GEOM[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.2"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2)][Total > 100]

###   Viable 2 Prior (Spring 17 + Spring 16) ALGEBRA_I Progressions
GEOM[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.3")][Total > 999]

###
###   Algebra II (No Repeaters)
###

ALG2 <- math.prog$BACKWARD[["2018_2019.2"]]$ALGEBRA_II.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "ALGEBRA_II.EOCT" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks
ALG2 <- ALG2[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "ALGEBRA_II.EOCT"]
ALG2[COUNT > 500]  #  Major progressions

###   Viable 1 Prior (Fall 18) ALGEBRA_I Progressions
ALG2[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]

###   Viable skip-year prior (Spring 17) ALGEBRA_I Progressions
ALG2[, list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2)][Total > 100]
ALG2[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.2"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2)][Total > 100]

###   Viable 2 Prior (Spring 17 + Spring 16) ALGEBRA_I Progressions
ALG2[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.3")][Total > 999]


####
####     ELA
####

###  Find out which grades are present in the Fall ELA data
names(ela.prog$BACKWARD[["2018_2019.2"]])

###  Spring to Spring  -  Establish configs for the SGP_NOTE variable
sum(ela.prog$BACKWARD[["2018_2019.2"]]$ELA.08[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.07"]$COUNT)   #    XXX
sum(ela.prog$BACKWARD[["2018_2019.2"]]$ELA.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.08"]$COUNT)   #    XXX
sum(ela.prog$BACKWARD[["2018_2019.2"]]$ELA.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.09"]$COUNT)   #   (repeaters)   XXX
sum(ela.prog$BACKWARD[["2018_2019.2"]]$ELA.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.09"]$COUNT)   #     XXX
sum(ela.prog$BACKWARD[["2018_2019.2"]]$ELA.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.10"]$COUNT)   #   (repeaters)   XXX
sum(ela.prog$BACKWARD[["2018_2019.2"]]$ELA.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.10"]$COUNT)   #
sum(ela.prog$BACKWARD[["2018_2019.2"]]$ELA.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.11"]$COUNT)   #   (repeaters)   XXX
