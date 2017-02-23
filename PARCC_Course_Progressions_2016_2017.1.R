################################################################################
###                                                                          ###
###         Identify Spring 2016 to Fall 2016 Progressions for PARCC         ###
###                                                                          ###
################################################################################

library(SGP)  # Version 1.6-2.5 or later
library(data.table)
library(RSQLite)


###  Location of PARCC SQLite Database (Fall 2016 added in Data Prep step)
parcc.db <- "./Data/PARCC_Data_LONG.sqlite"

PARCC_Data_LONG <- rbindlist(list(
			dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select ID, YEAR, CONTENT_AREA, GRADE, VALID_CASE, StateAbbreviation from PARCC_Data_LONG_2015_2"),
			dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select ID, YEAR, CONTENT_AREA, GRADE, VALID_CASE, StateAbbreviation from PARCC_Data_LONG_2016_1"),
			dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select ID, YEAR, CONTENT_AREA, GRADE, VALID_CASE, StateAbbreviation from PARCC_Data_LONG_2016_2"),
			dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select ID, YEAR, CONTENT_AREA, GRADE, VALID_CASE, StateAbbreviation from PARCC_Data_LONG_2017_1")))

PARCC_Data_LONG <- PARCC_Data_LONG[grep("_SS", CONTENT_AREA, invert =TRUE),]


###  Get subset of PARCC_Data_LONG with only IDs from Fall 2016

ids <- unique(PARCC_Data_LONG[YEAR=="2016_2017.1", ID])
FALL_Data_LONG <- PARCC_Data_LONG[ID %in% ids,]

table(FALL_Data_LONG[!CONTENT_AREA %in% "ELA", CONTENT_AREA, YEAR])
table(FALL_Data_LONG[CONTENT_AREA %in% "ELA", as.numeric(GRADE), YEAR])

table(FALL_Data_LONG[YEAR == "2016_2017.1" & CONTENT_AREA %in% "ELA", CONTENT_AREA, StateAbbreviation]) # NM, NJ, MD
table(FALL_Data_LONG[YEAR == "2016_2017.1" & !CONTENT_AREA %in% "ELA", CONTENT_AREA, StateAbbreviation]) # NM, NJ, MD

###  Run courseProgressionSGP by content area subsets of the FALL_Data_LONG

math.prog<- courseProgressionSGP(FALL_Data_LONG[!CONTENT_AREA %in% "ELA"], lag.direction="BACKWARD", year='2016_2017.1')
ela.prog <- courseProgressionSGP(FALL_Data_LONG[CONTENT_AREA %in% "ELA"], lag.direction="BACKWARD", year='2016_2017.1')

###  State specific analyses - re-run for NM, NJ, & MD
# math.prog<- courseProgressionSGP(FALL_Data_LONG[!CONTENT_AREA %in% "ELA" & StateAbbreviation == "MD"], lag.direction="BACKWARD", year='2016_2017.1')
# ela.prog <- courseProgressionSGP(FALL_Data_LONG[CONTENT_AREA %in% "ELA" & StateAbbreviation == "MD"], lag.direction="BACKWARD", year='2016_2017.1')


####
####     Mathematics
####

###  Find out which Math related content areas are present in the Fall data
names(math.prog$BACKWARD[['2016_2017.1']])


###   Algebra I (No Repeaters or Regression)
###

ALG1 <- math.prog$BACKWARD[['2016_2017.1']]$ALGEBRA_I.EOCT[!CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 %in% c("ALGEBRA_I.EOCT", "ALGEBRA_II.EOCT") | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks

table(ALG1$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
ALG1[COUNT > 100]  #  Major progressions

###   Viable 1 Prior (Spring 16) ALGEBRA_I Progressions
ALG1[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 Total
# 1:                      GEOMETRY.EOCT   141
# 2:             INTEGRATED_MATH_2.EOCT     2
# 3:                     MATHEMATICS.07   157
# 4:                     MATHEMATICS.08  3367
###   All listed
###   NM - None
###   NJ - MATHEMATICS.08 1478
###   MD - MATHEMATICS.08 1607

###   Viable 1 Prior (Fall 15) ALGEBRA_I Progressions (ENFORCE THAT NO SPRING 16 TEST AVAILABLE!)
ALG1[is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2)]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 Total
# 1:                     ALGEBRA_I.EOCT    94
# 2:                    ALGEBRA_II.EOCT    24
# 3:                      GEOMETRY.EOCT     8
###   None - but establish configs with Geometry for the SGP_NOTE variables
table(math.prog$BACKWARD[['2016_2017.1']]$ALGEBRA_I.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "GEOMETRY.EOCT",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1])  # Exclude ALGEBRA_I + GEOMETRY and ALGEBRA_II for good measure

###   Viable 2 Prior (Spring 16 + Spring 15) ALGEBRA_I Progressions
ALG1[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.3")][Total > 999]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 CONTENT_AREA_by_GRADE_PRIOR_YEAR.3 Total
# 1:                     MATHEMATICS.08                     MATHEMATICS.07  3105

ALG1[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="MATHEMATICS.08" & CONTENT_AREA_by_GRADE_PRIOR_YEAR.3=="MATHEMATICS.07"] # No Fall 15 (YEAR.2) exclusions necessary
###   8th and 7th Grade Math
###   NJ - MATHEMATICS.08  <->  MATHEMATICS.07 1311
###   MD - MATHEMATICS.08  <->  MATHEMATICS.07 1546


###   Geometry (No Repeaters)
###

GEOM <- math.prog$BACKWARD[['2016_2017.1']]$GEOMETRY.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "GEOMETRY.EOCT" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks

table(GEOM$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
GEOM[COUNT > 100]  #  Major progressions

###   Viable 1 Prior (Spring 16) GEOMETRY Progressions
GEOM[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 Total
# 1:                     ALGEBRA_I.EOCT  3244
# 2:                    ALGEBRA_II.EOCT   842
# 3:             INTEGRATED_MATH_1.EOCT     3
# 4:             INTEGRATED_MATH_2.EOCT     1
# 5:             INTEGRATED_MATH_3.EOCT     1
# 6:                     MATHEMATICS.08    34
###   All listed
###   NM - None
###   NJ - ALGEBRA_I.EOCT 2506
###   MD - None

###   Viable 1 Prior (Fall 15) GEOMETRY Progressions (ENFORCE THAT NO SPRING 16 TEST AVAILABLE!)
GEOM[is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2)]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 Total
# 1:                     ALGEBRA_I.EOCT   566
# 2:                    ALGEBRA_II.EOCT   167
# 3:                      GEOMETRY.EOCT    51
###   None - but establish configs with Algebra I and II for the SGP_NOTE variables
table(math.prog$BACKWARD[['2016_2017.1']]$GEOMETRY.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "ALGEBRA_I.EOCT",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1])  # Exclude  GEOMETRY, ALGEBRA_I and ALGEBRA_II
table(math.prog$BACKWARD[['2016_2017.1']]$GEOMETRY.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "ALGEBRA_II.EOCT",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1]) # Exclude  GEOMETRY, ALGEBRA_I and ALGEBRA_II


###   Viable 2 Prior (Spring 16 + Spring 15) GEOMETRY Progressions
GEOM[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.3")][Total > 999]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 CONTENT_AREA_by_GRADE_PRIOR_YEAR.3 Total
# 1:                     ALGEBRA_I.EOCT                     MATHEMATICS.08  1474

GEOM[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ALGEBRA_I.EOCT" & CONTENT_AREA_by_GRADE_PRIOR_YEAR.3=="MATHEMATICS.08"] # Exclude 12 cases with ALGEBRA_I in Fall 15 (YEAR.2)
###   Algebra I and 8th Grade Math, with exclusions
###   NJ - ALGEBRA_I.EOCT  <->  MATHEMATICS.08    1277


###   Algebra II (No Repeaters)
###

ALG2 <- math.prog$BACKWARD[['2016_2017.1']]$ALGEBRA_II.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "ALGEBRA_II.EOCT" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks

ALG2[COUNT > 100]  #  Major progressions

###   Viable 1 Prior (Spring 16) ALGEBRA_II Progressions
ALG2[, list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 Total
# 1:                     ALGEBRA_I.EOCT   781
# 2:                      GEOMETRY.EOCT  2817
# 3:             INTEGRATED_MATH_2.EOCT    24
# 4:             INTEGRATED_MATH_3.EOCT   160
# 5:                     MATHEMATICS.08     4
###   All listed
###   NM - None
###   NJ - GEOMETRY.EOCT 2007
###   MD - None

###   Viable 1 Prior (Fall 15) ALGEBRA_II Progressions (NO SPRING 16 TEST AVAILABLE!)
ALG2[is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2)]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 Total
# 1:                     ALGEBRA_I.EOCT   352
# 2:                    ALGEBRA_II.EOCT   137
# 3:                      GEOMETRY.EOCT  1050
###   Geometry  -  also establish config with Algebra I for the SGP_NOTE variables
table(math.prog$BACKWARD[['2016_2017.1']]$ALGEBRA_II.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "ALGEBRA_I.EOCT",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1]) # Exclude  GEOMETRY, ALGEBRA_I and ALGEBRA_II
table(math.prog$BACKWARD[['2016_2017.1']]$ALGEBRA_II.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "GEOMETRY.EOCT",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1])  # Exclude  GEOMETRY, ALGEBRA_I and ALGEBRA_II

###   Viable 2 Prior (Spring 16 + Spring 15) ALGEBRA_II Progressions
ALG2[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.3")][Total > 999]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 CONTENT_AREA_by_GRADE_PRIOR_YEAR.3 Total
# 1:                      GEOMETRY.EOCT                     ALGEBRA_I.EOCT  1823

ALG2[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="GEOMETRY.EOCT" & CONTENT_AREA_by_GRADE_PRIOR_YEAR.3=="ALGEBRA_I.EOCT"] # Exclude (79 total) cases with Fall 15 (YEAR.2) scores (Alg 1, 2 and Geometry)
###   Geometry and Algebra I, with exclusions
###   NJ - GEOMETRY.EOCT  <->  ALGEBRA_I.EOCT 1382


####
####     ELA
####

###  Find out which grades are present in the Fall ELA data
names(ela.prog$BACKWARD[['2016_2017.1']])

sum(ela.prog$BACKWARD[['2016_2017.1']]$ELA.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.08"]$COUNT)   # 4036
sum(ela.prog$BACKWARD[['2016_2017.1']]$ELA.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.09"]$COUNT)   #  176 (repeaters)
sum(ela.prog$BACKWARD[['2016_2017.1']]$ELA.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.09"]$COUNT)   # 2575
sum(ela.prog$BACKWARD[['2016_2017.1']]$ELA.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.10"]$COUNT)   #  361 (repeaters)
sum(ela.prog$BACKWARD[['2016_2017.1']]$ELA.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.10"]$COUNT)   # 4159
sum(ela.prog$BACKWARD[['2016_2017.1']]$ELA.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.11"]$COUNT)   # 6621 (repeaters)

###   NM - None
###   NJ - All 3 Grades
###   MD - 11th Grade
