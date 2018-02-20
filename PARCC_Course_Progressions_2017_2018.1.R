################################################################################
###                                                                          ###
###                Identify Fall 2017 Progressions for PARCC                 ###
###                                                                          ###
################################################################################

library(SGP)  # Version 1.7-X.X or later
library(data.table)
library(RSQLite)


###  Location of PARCC SQLite Database (Fall 2017 added in Data Prep step)
parcc.db <- "./Data/PARCC_Data_LONG.sqlite"

PARCC_Data_LONG <- rbindlist(list(
			dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select ID, YEAR, CONTENT_AREA, GRADE, VALID_CASE, StateAbbreviation from PARCC_Data_LONG_2015_2"),
			dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select ID, YEAR, CONTENT_AREA, GRADE, VALID_CASE, StateAbbreviation from PARCC_Data_LONG_2016_1"),
			dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select ID, YEAR, CONTENT_AREA, GRADE, VALID_CASE, StateAbbreviation from PARCC_Data_LONG_2016_2"),
			dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select ID, YEAR, CONTENT_AREA, GRADE, VALID_CASE, StateAbbreviation from PARCC_Data_LONG_2017_1"),
			dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select ID, YEAR, CONTENT_AREA, GRADE, VALID_CASE, StateAbbreviation from PARCC_Data_LONG_2017_2"), # PARCC_Data_LONG_2017_2018.1[,list(ID, YEAR, CONTENT_AREA, GRADE, VALID_CASE, StateAbbreviation)]))
			dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select ID, YEAR, CONTENT_AREA, GRADE, VALID_CASE, StateAbbreviation from PARCC_Data_LONG_2018_1")
		))[grep("_SS", CONTENT_AREA, invert =TRUE),]

###  States
# source("~/Dropbox (SGP)/Github_Repos/Projects/PARCC/fetchPARCC.R")
# PARCC_Data_LONG <-
# 		fetchPARCC(state="NM", parcc.db = "./Data/PARCC_Data_LONG.sqlite", prior.years=c("2016_2", "2017_1", "2017_2"), current.year="2018_1", fields="*")[grep("_SS", CONTENT_AREA, invert =TRUE),]


###  Get subset of PARCC_Data_LONG with only IDs from Fall 2017

ids <- unique(PARCC_Data_LONG[YEAR=="2017_2018.1", ID])
Fall_Data_LONG <- PARCC_Data_LONG[ID %in% ids,]

table(Fall_Data_LONG[CONTENT_AREA != "ELA", CONTENT_AREA, YEAR])
table(Fall_Data_LONG[which(CONTENT_AREA == "ELA"), as.numeric(GRADE), YEAR])
table(Fall_Data_LONG[which(YEAR == '2017_2018.1'), GRADE, CONTENT_AREA])

###  Run courseProgressionSGP by content area subsets of the Fall_Data_LONG

math.prog<- courseProgressionSGP(Fall_Data_LONG[!CONTENT_AREA %in% "ELA"], lag.direction="BACKWARD", year='2017_2018.1')
ela.prog <- courseProgressionSGP(Fall_Data_LONG[CONTENT_AREA %in% "ELA"], lag.direction="BACKWARD", year='2017_2018.1')



########
###       NEED TO LOOK AT Fall 2016 Course Progressions script to make sure this is set up right
###       Also need to add in 2nd prior investigation
########



####
####     Mathematics
####

###  Find out which Math related content areas are present in the Fall data
names(math.prog$BACKWARD[['2017_2018.1']])


###
###   Algebra I (No Repeaters or Regression)
###

ALG1 <- math.prog$BACKWARD[['2017_2018.1']]$ALGEBRA_I.EOCT[!CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 %in% c("ALGEBRA_I.EOCT", "ALGEBRA_II.EOCT") | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks

table(ALG1$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
ALG1[COUNT > 100]  #  Major progressions

###   Viable 1 Prior (Spring 17) ALGEBRA_I Progressions
ALG1[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]

#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 Total
# 1:                      GEOMETRY.EOCT   135
# 2:             INTEGRATED_MATH_1.EOCT     5
# 3:                     MATHEMATICS.07   178
# 4:                     MATHEMATICS.08  3453
###   All listed
###   BI - None
###   MD - MATHEMATICS.08 1606
###   NJ - MATHEMATICS.08 1560
###   NM - None  250  XXX


###   Viable 1 Prior (Fall 16) ALGEBRA_I Progressions (ENFORCE THAT NO SPRING 16 TEST AVAILABLE!)
ALG1[is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2)]

#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 Total
# 1:                     ALGEBRA_I.EOCT   169
# 2:                    ALGEBRA_II.EOCT    21
# 3:                      GEOMETRY.EOCT    13
###   None - but establish configs with Geometry for the SGP_NOTE variables


###   Viable 2 Prior (Spring 16 + Spring 15) ALGEBRA_I Progressions
ALG1[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.3")][Total > 100]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 CONTENT_AREA_by_GRADE_PRIOR_YEAR.3 Total
# 1:                     MATHEMATICS.07                     MATHEMATICS.06   175
# 2:                     MATHEMATICS.08                                 NA   171
# 3:                     MATHEMATICS.08                     MATHEMATICS.07  3260

ALG1[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="MATHEMATICS.08" & CONTENT_AREA_by_GRADE_PRIOR_YEAR.3=="MATHEMATICS.07"]
###   8th and 7th Grade Math
###   MD - MATHEMATICS.08  <->  MATHEMATICS.07 1560
###   NJ - MATHEMATICS.08  <->  MATHEMATICS.07 1560

ALG1[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="MATHEMATICS.06", list(Total=sum(COUNT))] #   0
ALG1[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="GEOMETRY.EOCT", list(Total=sum(COUNT))]  # 135
ALG1[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="GEOMETRY.EOCT", list(Total=sum(COUNT))]  #  13



###
###   Geometry (No Repeaters)
###
GEOM <- math.prog$BACKWARD[['2017_2018.1']]$GEOMETRY.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "GEOMETRY.EOCT" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks

table(GEOM$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
GEOM[COUNT > 100]  #  Major progressions

###   Viable 1 Prior (Spring 17) GEOMETRY Progressions
GEOM[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1   Total
# 1:                     ALGEBRA_I.EOCT  2953
# 2:                    ALGEBRA_II.EOCT   765
# 3:             INTEGRATED_MATH_1.EOCT     1
# 4:             INTEGRATED_MATH_2.EOCT    15
# 5:             INTEGRATED_MATH_3.EOCT     6
# 6:                     MATHEMATICS.08    16
###   All listed - Establish configs with ALGEBRA_II, Int Maths & Math 8 for the SGP_NOTE variables
###   MD - None
###   NJ - ALGEBRA_I.EOCT  2579
###   NM - None


###   Viable 1 Prior (Fall 16) GEOMETRY Progressions (ENFORCE THAT NO Spring 16 TEST AVAILABLE!)
GEOM[is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2)]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 Total
# 1:                     ALGEBRA_I.EOCT   665
# 2:                    ALGEBRA_II.EOCT   253
# 3:                      GEOMETRY.EOCT    86
###   None - but establish configs with Algebra I and II for the SGP_NOTE variables
table(math.prog$BACKWARD[['2017_2018.1']]$GEOMETRY.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "ALGEBRA_I.EOCT",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1])
table(math.prog$BACKWARD[['2017_2018.1']]$GEOMETRY.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "ALGEBRA_II.EOCT",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1])
table(math.prog$BACKWARD[['2017_2018.1']]$GEOMETRY.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "GEOMETRY.EOCT",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1])


###   Viable 2 Prior (Spring 16 + Spring 15) GEOMETRY Progressions
GEOM[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.3")][Total > 100]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 CONTENT_AREA_by_GRADE_PRIOR_YEAR.3 Total
# 1:                     ALGEBRA_I.EOCT                                 NA   425
# 2:                     ALGEBRA_I.EOCT                     ALGEBRA_I.EOCT   183
# 3:                     ALGEBRA_I.EOCT                     MATHEMATICS.07   864
# 4:                     ALGEBRA_I.EOCT                     MATHEMATICS.08  1421
# 5:                    ALGEBRA_II.EOCT                                 NA   113
# 6:                    ALGEBRA_II.EOCT                     ALGEBRA_I.EOCT   412
# 7:                    ALGEBRA_II.EOCT                      GEOMETRY.EOCT   169

###   NJ - ALGEBRA_I.EOCT  <->  MATHEMATICS.08  1340

###   Algebra I and 8th Grade Math, with exclusions
GEOM[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ALGEBRA_I.EOCT" & CONTENT_AREA_by_GRADE_PRIOR_YEAR.3=="MATHEMATICS.08"]
GEOM[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ALGEBRA_I.EOCT" & CONTENT_AREA_by_GRADE_PRIOR_YEAR.3=="MATHEMATICS.08", list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")]

GEOM[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.3), list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.3"]


###
###   Algebra II (No Repeaters)
###

ALG2 <- math.prog$BACKWARD[['2017_2018.1']]$ALGEBRA_II.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "ALGEBRA_II.EOCT" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks
ALG2[COUNT > 100]  #  Major progressions

###   Viable 1 Prior (Spring 17) ALGEBRA_II Progressions
ALG2[, list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 Total
# 1:                     ALGEBRA_I.EOCT   608
# 2:                      GEOMETRY.EOCT  2372
# 3:             INTEGRATED_MATH_1.EOCT   192
# 4:             INTEGRATED_MATH_2.EOCT    50
# 5:             INTEGRATED_MATH_3.EOCT     5
# 6:                     MATHEMATICS.05     1  XXX
# 7:                     MATHEMATICS.08     5
###   Geometry - Establish configs for the SGP_NOTE variables for all except G5 math
###   NJ - GEOMETRY.EOCT  1789


###   Viable 1 Prior (Fall 17) ALGEBRA_II Progressions (NO Spring 17 TEST AVAILABLE!)
ALG2[is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2)]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 Total
# 1:                     ALGEBRA_I.EOCT   220
# 2:                    ALGEBRA_II.EOCT   217
# 3:                      GEOMETRY.EOCT  1177
###   Geometry - Establish configs with Algebra I for the SGP_NOTE variables
###   NJ - GEOMETRY.EOCT  996  XXX  Close!

table(math.prog$BACKWARD[['2017_2018.1']]$ALGEBRA_II.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "ALGEBRA_I.EOCT",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1]) # Exclude  GEOMETRY, ALGEBRA_I and ALGEBRA_II
table(math.prog$BACKWARD[['2017_2018.1']]$ALGEBRA_II.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "GEOMETRY.EOCT",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1])  # Exclude  GEOMETRY, ALGEBRA_I and ALGEBRA_II



####
####     ELA
####


###  Find out which grades are present in the Fall ELA data
names(ela.prog$BACKWARD[['2017_2018.1']])


###  Spring to FallBlock
sum(ela.prog$BACKWARD[['2017_2018.1']]$ELA.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.08"]$COUNT)   #  3845
sum(ela.prog$BACKWARD[['2017_2018.1']]$ELA.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.09"]$COUNT)   #   118 (repeaters)
sum(ela.prog$BACKWARD[['2017_2018.1']]$ELA.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.09"]$COUNT)   #  2245
sum(ela.prog$BACKWARD[['2017_2018.1']]$ELA.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.10"]$COUNT)   #  9721 (repeaters) (mostly MD)
sum(ela.prog$BACKWARD[['2017_2018.1']]$ELA.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.10"]$COUNT)   #  3627
sum(ela.prog$BACKWARD[['2017_2018.1']]$ELA.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.11"]$COUNT)   #  7326 (repeaters) (mostly NM (+ NJ))

###   Viable 2 Prior ELA Progressions  (ALL viable)
ela.prog$BACKWARD[['2017_2018.1']]$ELA.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.08", list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.2", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.3")][Total > 100]
ela.prog$BACKWARD[['2017_2018.1']]$ELA.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.09", list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.2", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.3")][Total > 100]
ela.prog$BACKWARD[['2017_2018.1']]$ELA.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.10", list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.2", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.3")][Total > 100]


###  Fall to Fall
sum(ela.prog$BACKWARD[['2017_2018.1']]$ELA.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.09"]$COUNT)   #    58 (repeaters)

sum(ela.prog$BACKWARD[['2017_2018.1']]$ELA.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.09"]$COUNT)   #  1823
sum(ela.prog$BACKWARD[['2017_2018.1']]$ELA.10[is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1) & CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.09"]$COUNT)   #  1758
table(ela.prog$BACKWARD[['2017_2018.1']]$ELA.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "ELA.09",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1])  # Some 9th & 10th.  Exclude in future?
sum(ela.prog$BACKWARD[['2017_2018.1']]$ELA.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.10"]$COUNT)   #   268 (repeaters)

sum(ela.prog$BACKWARD[['2017_2018.1']]$ELA.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.10"]$COUNT)   #  1868
sum(ela.prog$BACKWARD[['2017_2018.1']]$ELA.11[is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1) & CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.10"]$COUNT)   #  1746
table(ela.prog$BACKWARD[['2017_2018.1']]$ELA.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "ELA.10",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1])  # Some 9th, 10th & 11th.  Exclude in future?
sum(ela.prog$BACKWARD[['2017_2018.1']]$ELA.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.11"]$COUNT)   #   355 (repeaters)

###  2 Fall priors (NOT viable)
ela.prog$BACKWARD[['2017_2018.1']]$ELA.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.10", list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.4")][Total > 100]
