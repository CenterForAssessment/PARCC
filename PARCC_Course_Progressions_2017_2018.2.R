################################################################################
###                                                                          ###
###               Identify Spring 2018 Progressions for PARCC                ###
###                                                                          ###
################################################################################

library(SGP)  # Version 1.7-X.X or later
library(data.table)
library(RSQLite)


###  Location of PARCC SQLite Database (Spring 2018 added in Data Prep step)
parcc.db <- "/media/Data/Dropbox (SGP)/SGP/PARCC/PARCC/Data/PARCC_Data_LONG.sqlite"

PARCC_Data_LONG <- rbindlist(list(
			dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select ID, YEAR, CONTENT_AREA, GRADE, VALID_CASE, StateAbbreviation from PARCC_Data_LONG_2016_2"),
			dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select ID, YEAR, CONTENT_AREA, GRADE, VALID_CASE, StateAbbreviation from PARCC_Data_LONG_2017_1"),
			dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select ID, YEAR, CONTENT_AREA, GRADE, VALID_CASE, StateAbbreviation from PARCC_Data_LONG_2017_2"),
			dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select ID, YEAR, CONTENT_AREA, GRADE, VALID_CASE, StateAbbreviation from PARCC_Data_LONG_2018_1"), #PARCC_Data_LONG_2017_2018.2[,list(ID, YEAR, CONTENT_AREA, GRADE, VALID_CASE, StateAbbreviation)]))[grep("_SS", CONTENT_AREA, invert =TRUE),]
			dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select ID, YEAR, CONTENT_AREA, GRADE, VALID_CASE, StateAbbreviation from PARCC_Data_LONG_2018_2")
		))[grep("_SS", CONTENT_AREA, invert =TRUE),]

###  States
source("/media/Data/Dropbox (SGP)/Github_Repos/Projects/PARCC/fetchPARCC.R")
PARCC_Data_LONG <- fetchPARCC(state="IL", parcc.db = parcc.db, prior.years=c("2016_2", "2017_2", "2018_1"), current.year="2018_2", fields="*")[grep("_SS", CONTENT_AREA, invert =TRUE),]


###  Get subset of PARCC_Data_LONG with only IDs from Spring 2018

ids <- unique(PARCC_Data_LONG[YEAR=="2017_2018.2", ID])
Spring_Data_LONG <- PARCC_Data_LONG[ID %in% ids,]

table(Spring_Data_LONG[!CONTENT_AREA %in% "ELA", CONTENT_AREA, YEAR])
table(Spring_Data_LONG[CONTENT_AREA %in% "ELA", as.numeric(GRADE), YEAR])
table(Spring_Data_LONG[YEAR=='2017_2018.2', GRADE, CONTENT_AREA])

###  Run courseProgressionSGP by content area subsets of the Spring_Data_LONG

math.prog<- courseProgressionSGP(Spring_Data_LONG[!CONTENT_AREA %in% "ELA"], lag.direction="BACKWARD", year='2017_2018.2')
ela.prog <- courseProgressionSGP(Spring_Data_LONG[CONTENT_AREA %in% "ELA"], lag.direction="BACKWARD", year='2017_2018.2')


####
####     Mathematics
####

###  Find out which Math related content areas are present in the Fall data
names(math.prog$BACKWARD[['2017_2018.2']])

###
###   Algebra I (No Repeaters or Regression)
###

ALG1 <- math.prog$BACKWARD[['2017_2018.2']]$ALGEBRA_I.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "ALGEBRA_I.EOCT" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks
ALG1 <- ALG1[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 != "ALGEBRA_I.EOCT"]
table(ALG1$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
ALG1[COUNT > 100]  #  Major progressions

###   Viable 1 Prior (Fall 17) ALGEBRA_I Progressions
ALG1[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 Total
# 1:                    ALGEBRA_II.EOCT    12		XXX  No REGRESSORS!
# 2:                      GEOMETRY.EOCT    13
###   Establish configs for the SGP_NOTE variable


###   Viable 1 Prior (Spring 17) ALGEBRA_I Progressions (ENFORCE THAT NO Fall 17 TEST AVAILABLE!)
ALG1[is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2)]
#      CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 Total
# 1:                    ALGEBRA_II.EOCT   236  XXX		REGRESSORS!
# 2:                      GEOMETRY.EOCT  1122
# 3:             INTEGRATED_MATH_1.EOCT    61
# 4:             INTEGRATED_MATH_2.EOCT     3
# 5:             INTEGRATED_MATH_3.EOCT     2
# 6:                     MATHEMATICS.04     3
# 7:                     MATHEMATICS.05   276
# 8:                     MATHEMATICS.06 11735
# 9:                     MATHEMATICS.07 60884
# 10:                    MATHEMATICS.08 97041

###   Also establish config with INTEGRATED_MATH_1, 2 and 3 for the SGP_NOTE variables

# Exclude Fall 2017 ALGEBRA_I, GEOMETRY and ALGEBRA_II for good measure?
table(math.prog$BACKWARD[['2017_2018.2']]$ALGEBRA_I.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "GEOMETRY.EOCT",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1])

###   Viable 2 Prior (Spring 17 + Spring 16) ALGEBRA_I Progressions
ALG1[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.4")][Total > 999]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 CONTENT_AREA_by_GRADE_PRIOR_YEAR.4  Total
# 1:                     MATHEMATICS.06                     MATHEMATICS.05 11340
# 2:                     MATHEMATICS.07                               <NA>  2538
# 3:                     MATHEMATICS.07                     MATHEMATICS.06 58116
# 4:                     MATHEMATICS.08                               <NA>  7062
# 5:                     MATHEMATICS.08                     MATHEMATICS.07 88578
# 6:                     MATHEMATICS.08                     MATHEMATICS.08  1192 XXX

ALG1[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="MATHEMATICS.08" & CONTENT_AREA_by_GRADE_PRIOR_YEAR.4=="MATHEMATICS.07"] # No Fall 17 (YEAR.1) exclusions necessary


###
###   Geometry (No Repeaters)
###

GEOM <- math.prog$BACKWARD[['2017_2018.2']]$GEOMETRY.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "GEOMETRY.EOCT" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks
GEOM <- GEOM[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 != "GEOMETRY.EOCT"]
table(GEOM$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
GEOM[COUNT > 100]  #  Major progressions

###   Viable 1 Prior (Fall 17) GEOMETRY Progressions
GEOM[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1   Total
# 1:                     ALGEBRA_I.EOCT   1823
# 2:                    ALGEBRA_II.EOCT   122    XXX

###  NONE - Don't exclude these either?

###   Viable 1 Prior (Spring 17) GEOMETRY Progressions (ENFORCE THAT NO Fall 17 TEST AVAILABLE?)
GEOM[is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2)]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.2  Total
# 1:                     ALGEBRA_I.EOCT 108955
# 2:                    ALGEBRA_II.EOCT   3611
# 3:             INTEGRATED_MATH_1.EOCT     61
# 4:             INTEGRATED_MATH_2.EOCT      7
# 5:             INTEGRATED_MATH_3.EOCT      7
# 6:                     MATHEMATICS.05      3
# 7:                     MATHEMATICS.06     19
# 8:                     MATHEMATICS.07    223
# 9:                     MATHEMATICS.08   1266
###   Also establish config with INTEGRATED_MATH_1-3 and MATHEMATICS.05-.07 for the SGP_NOTE variables

table(math.prog$BACKWARD[['2017_2018.2']]$GEOMETRY.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "ALGEBRA_I.EOCT",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1])  # Exclude  GEOMETRY, ALGEBRA_I and ALGEBRA_II
table(math.prog$BACKWARD[['2017_2018.2']]$GEOMETRY.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "ALGEBRA_II.EOCT",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1]) # Exclude  GEOMETRY, ALGEBRA_I and ALGEBRA_II
table(math.prog$BACKWARD[['2017_2018.2']]$GEOMETRY.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "MATHEMATICS.08",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1]) # Exclude  ALGEBRA_I

math.prog$BACKWARD[['2017_2018.2']]$GEOMETRY.EOCT[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1) & CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "ALGEBRA_II.EOCT", list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")]


###   Viable 2 Prior (Spring 17 + Spring 16) GEOMETRY Progressions
GEOM[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2) & !is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.4), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.4")][Total > 500]
# CONTENT_AREA_by_GRADE_PRIOR_YEAR.2    CONTENT_AREA_by_GRADE_PRIOR_YEAR.4 Total
# 1:                     ALGEBRA_I.EOCT                     ALGEBRA_I.EOCT  5943   XXX
# 2:                     ALGEBRA_I.EOCT                     MATHEMATICS.06  7809
# 3:                     ALGEBRA_I.EOCT                     MATHEMATICS.07 28515
# 4:                     ALGEBRA_I.EOCT                     MATHEMATICS.08 54760
# 5:                    ALGEBRA_II.EOCT                     ALGEBRA_I.EOCT  2862
# 6:                     MATHEMATICS.08                     MATHEMATICS.07  1416

GEOM[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ALGEBRA_I.EOCT" & CONTENT_AREA_by_GRADE_PRIOR_YEAR.4=="MATHEMATICS.08"] # Exclude 15 cases with GEOMETRY in Fall 17 (YEAR.1)?

###
###   Algebra II (No Repeaters)
###

ALG2 <- math.prog$BACKWARD[['2017_2018.2']]$ALGEBRA_II.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "ALGEBRA_II.EOCT" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks
ALG2 <- ALG2[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 != "ALGEBRA_II.EOCT"]

ALG2[COUNT > 500]  #  Major progressions

###   Viable 1 Prior (Fall 17) ALGEBRA_II Progressions
ALG2[, list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 Total
# 1:                     ALGEBRA_I.EOCT   428
# 2:                      GEOMETRY.EOCT   714

###   Viable 1 Prior (Spring 17) ALGEBRA_II Progressions (NO Fall 17 TEST AVAILABLE!)
ALG2[is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2)]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 Total
# 1:                     ALGEBRA_I.EOCT 12587
# 2:                      GEOMETRY.EOCT 82165
# 3:             INTEGRATED_MATH_1.EOCT   199		XXX
# 4:             INTEGRATED_MATH_2.EOCT    11		XXX
# 5:             INTEGRATED_MATH_3.EOCT     3		XXX
# 6:                     MATHEMATICS.07     5		XXX
# 7:                     MATHEMATICS.08  1777
###   Also establish config with INTEGRATED_MATH_1 to MATHEMATICS.08 for the SGP_NOTE variables

table(math.prog$BACKWARD[['2017_2018.2']]$ALGEBRA_II.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "ALGEBRA_I.EOCT",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1]) # Exclude  GEOMETRY, ALGEBRA_I and ALGEBRA_II
table(math.prog$BACKWARD[['2017_2018.2']]$ALGEBRA_II.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "GEOMETRY.EOCT",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1])  # Exclude  GEOMETRY, ALGEBRA_I and ALGEBRA_II

###   Viable 2 Prior (Spring 17 + Spring 16) ALGEBRA_II Progressions
ALG2[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2) & !is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.4), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.4")][Total > 500]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 CONTENT_AREA_by_GRADE_PRIOR_YEAR.4 Total
# 1:                     ALGEBRA_I.EOCT                     ALGEBRA_I.EOCT  1273		XXX
# 2:                     ALGEBRA_I.EOCT                     MATHEMATICS.07  3634
# 3:                     ALGEBRA_I.EOCT                     MATHEMATICS.08  5888
# 4:                      GEOMETRY.EOCT                     ALGEBRA_I.EOCT 74906
# 5:                      GEOMETRY.EOCT                      GEOMETRY.EOCT   680		XXX
# 6:                      GEOMETRY.EOCT                     MATHEMATICS.08   821		XXX
# 7:                     MATHEMATICS.08                     ALGEBRA_I.EOCT  1641		XXX ???
###   Don't establish configs for XXX  -  Only viable 2 priors

ALG2[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1) & CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="GEOMETRY.EOCT" & CONTENT_AREA_by_GRADE_PRIOR_YEAR.4=="ALGEBRA_I.EOCT"] # Exclude (194 total) cases with Fall 17 (YEAR.1) scores (Alg 1, 2 and Geometry)
ALG2[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1) & CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ALGEBRA_I.EOCT"] # Exclude cases with Fall 17 (YEAR.1) GEOMETRY scores (or Give that progression the higher priority)

###
###   Integrated Math 1
###

INTM1 <- math.prog$BACKWARD[['2017_2018.2']]$INTEGRATED_MATH_1.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "INTEGRATED_MATH_1.EOCT" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks
INTM1 <- INTM1[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 != "INTEGRATED_MATH_1.EOCT"]

INTM1[COUNT > 100]  #  Major progressions

###   Viable 1 Prior (Fall 17) GEOMETRY Progressions
INTM1[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
# CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 Total
# 1:                      GEOMETRY.EOCT     4   XXX  Also GEOM in Spring 17
### - NONE

###   Viable 1 Prior (Spring 17) GEOMETRY Progressions (ENFORCE THAT NO Fall 17 TEST AVAILABLE?)
INTM1[is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2)]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.2  Total
# 1:                     ALGEBRA_I.EOCT   230   XXX
# 2:                      GEOMETRY.EOCT   101   XXX
# 3:             INTEGRATED_MATH_2.EOCT     2   XXX
# 4:                     MATHEMATICS.06     2   XXX
# 5:                     MATHEMATICS.07    56   XXX
# 6:                     MATHEMATICS.08   206   XXX

###   Also establish config with ALGEBRA_I to MATHEMATICS.06 for the SGP_NOTE variables (NOT INTEGRATED_MATH_2.EOCT - No regressions)


###
###   Integrated Math 2
###

INTM2 <- math.prog$BACKWARD[['2017_2018.2']]$INTEGRATED_MATH_2.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "INTEGRATED_MATH_2.EOCT" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks
INTM2 <- INTM2[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 != "INTEGRATED_MATH_2.EOCT"]

INTM2[COUNT > 100]  #  Major progressions

###   Viable 1 Prior (Fall 17) INTEGRATED_MATH_2 Progressions
INTM2[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
# CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 Total
# 1:                    ALGEBRA_II.EOCT     2   XXX  All have INT Math 1 for YEAR.2

###   Viable 1 Prior (Spring 17) INTEGRATED_MATH_2 Progressions (ENFORCE THAT NO Fall 17 TEST AVAILABLE?)
INTM2[is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2)]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.2  Total
# 1:                     ALGEBRA_I.EOCT   298   XXX
# 2:                    ALGEBRA_II.EOCT     9   XXX
# 3:                      GEOMETRY.EOCT    75   XXX
# 4:             INTEGRATED_MATH_1.EOCT   245   XXX
# 5:             INTEGRATED_MATH_3.EOCT     1   XXX
# 6:                     MATHEMATICS.07     2   XXX
# 7:                     MATHEMATICS.08    56   XXX
###   Also establish config with ALGEBRA_I to MATHEMATICS.08 for the SGP_NOTE variables


###
###   Integrated Math 3
###

INTM3 <- math.prog$BACKWARD[['2017_2018.2']]$INTEGRATED_MATH_3.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "INTEGRATED_MATH_3.EOCT" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks
INTM3 <- INTM3[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 != "INTEGRATED_MATH_3.EOCT"]

INTM3[COUNT > 100]  #  Major progressions

###   Viable 1 Prior (Fall 17) INTEGRATED_MATH_2 Progressions
INTM3[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
# CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 Total
# 1:                    ALGEBRA_II.EOCT     4  All have INT GEOM for YEAR.2
### - NONE

###   Viable 1 Prior (Spring 17) INTEGRATED_MATH_2 Progressions (ENFORCE THAT NO Fall 17 TEST AVAILABLE?)
INTM3[is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2)]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.2  Total
# 1:                     ALGEBRA_I.EOCT     9		XXX
# 2:                    ALGEBRA_II.EOCT     4		XXX
# 3:                      GEOMETRY.EOCT    24		XXX
# 4:             INTEGRATED_MATH_1.EOCT    13		XXX
# 5:             INTEGRATED_MATH_2.EOCT    99		XXX

###   Establish configs for the SGP_NOTE variables



####
####     ELA
####

###  Find out which grades are present in the Fall ELA data
names(ela.prog$BACKWARD[['2017_2018.2']])

###  Spring to FallBlock  -  Establish configs for the SGP_NOTE variable
sum(ela.prog$BACKWARD[['2017_2018.2']]$ELA.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.08"]$COUNT)   #  0   XXX
sum(ela.prog$BACKWARD[['2017_2018.2']]$ELA.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.09"]$COUNT)   #  67 (repeaters)   XXX
sum(ela.prog$BACKWARD[['2017_2018.2']]$ELA.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.09"]$COUNT)   #  336   XXX
sum(ela.prog$BACKWARD[['2017_2018.2']]$ELA.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.10"]$COUNT)   #  3432 (repeaters)   XXX
sum(ela.prog$BACKWARD[['2017_2018.2']]$ELA.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.10"]$COUNT)   #  4066
sum(ela.prog$BACKWARD[['2017_2018.2']]$ELA.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.11"]$COUNT)   #  565 (repeaters)   XXX


###  Spring to Spring  -  Establish configs for the SGP_NOTE variable
sum(ela.prog$BACKWARD[['2017_2018.2']]$ELA.08[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.07"]$COUNT)   #  0   XXX
sum(ela.prog$BACKWARD[['2017_2018.2']]$ELA.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.08"]$COUNT)   #  0   XXX
sum(ela.prog$BACKWARD[['2017_2018.2']]$ELA.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.09"]$COUNT)   #  67 (repeaters)   XXX
sum(ela.prog$BACKWARD[['2017_2018.2']]$ELA.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.3=="ELA.08"]$COUNT)   #  49973  -  2 year skip
sum(ela.prog$BACKWARD[['2017_2018.2']]$ELA.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.09"]$COUNT)   #  336   XXX
sum(ela.prog$BACKWARD[['2017_2018.2']]$ELA.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.10"]$COUNT)   #  3432 (repeaters)   XXX
sum(ela.prog$BACKWARD[['2017_2018.2']]$ELA.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.10"]$COUNT)   #  4066
sum(ela.prog$BACKWARD[['2017_2018.2']]$ELA.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.11"]$COUNT)   #  565 (repeaters)   XXX


###   Washington DC
sum(ela.prog$BACKWARD[['2017_2018.2']]$ELA.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.08"]$COUNT)   #  3243  -  2 year skip


ELA <- ela.prog$BACKWARD[['2017_2018.2']]$ELA.10
table(ELA$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
ELA[COUNT > 100]  #  Major progressions

###  PARCC consortium
ELA[CONTENT_AREA_by_GRADE_PRIOR_YEAR.4 == "ELA.08"]
ELA[, list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.4")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.4)]
ELA[is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1) & is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2) & is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.3),
			list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.4")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.4)]

###   Individual States
ELA[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "ELA.08"]
ELA[, list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2)]
ELA[is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1),
			list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2)]
