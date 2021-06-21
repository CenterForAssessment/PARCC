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
			dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select ID, YEAR, CONTENT_AREA, GRADE, VALID_CASE, StateAbbreviation from PARCC_Data_LONG_2017_2"), # , SCALE_SCORE, SCALE_SCORE_CSEM
			dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select ID, YEAR, CONTENT_AREA, GRADE, VALID_CASE, StateAbbreviation from PARCC_Data_LONG_2018_1"),
			dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select ID, YEAR, CONTENT_AREA, GRADE, VALID_CASE, StateAbbreviation from PARCC_Data_LONG_2018_2"), # PARCC_Data_LONG_2018_2019.1[,list(ID, YEAR, CONTENT_AREA, GRADE, VALID_CASE, StateAbbreviation)]
			dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select ID, YEAR, CONTENT_AREA, GRADE, VALID_CASE, StateAbbreviation from PARCC_Data_LONG_2019_1")
		))[grep("_SS", CONTENT_AREA, invert =TRUE),]

PARCC_Data_LONG <- PARCC_Data_LONG[StateAbbreviation %in% c("BI", "MD", "NJ", "NM")]

###  Get subset of PARCC_Data_LONG with only IDs from Fall 2017

ids <- unique(PARCC_Data_LONG[YEAR=="2018_2019.1", ID])
Fall_Data_LONG <- PARCC_Data_LONG[ID %in% ids,]

###  States
# Fall_Data_LONG <- Fall_Data_LONG[StateAbbreviation=="NJ"]
# BIA (Fall IDs subset?) has no previous fall (2017_2018.1) -- throws off PRIOR_YEAR.2, so it looks like some progressions should work that really don't.

table(Fall_Data_LONG[CONTENT_AREA != "ELA", CONTENT_AREA, YEAR])
table(Fall_Data_LONG[which(CONTENT_AREA == "ELA"), as.numeric(GRADE), YEAR])
table(Fall_Data_LONG[which(YEAR == '2018_2019.1'), GRADE, CONTENT_AREA])


###  Data for running prelim analyses - add in vars (SCALE_SCORE, SCALE_SCORE_CSEM) and keep SS version above in data pull.
# Fall_Data_LONG <- SGP:::getAchievementLevel(Fall_Data_LONG, state="PARCC") # ,
# table(Fall_Data_LONG[, ACHIEVEMENT_LEVEL, CONTENT_AREA], exclude=NULL) # Doesn't allign perfectly ...
# Maryland_Data_LONG <- Fall_Data_LONG[StateAbbreviation=="MD"]

###  Run courseProgressionSGP by content area subsets of the Fall_Data_LONG // Maryland_Data_LONG[grep("_SS", CONTENT_AREA, invert =TRUE),]

math.prog<- courseProgressionSGP(Fall_Data_LONG[!CONTENT_AREA %in% "ELA"], lag.direction="BACKWARD", year='2018_2019.1')
ela.prog <- courseProgressionSGP(Fall_Data_LONG[CONTENT_AREA %in% "ELA"], lag.direction="BACKWARD", year='2018_2019.1')


####
####     Mathematics
####

###  Find out which Math related content areas are present in the Fall data
names(math.prog$BACKWARD[['2018_2019.1']])

###
###   Algebra I (No Repeaters or Regression)
###

ALG1 <- math.prog$BACKWARD[['2018_2019.1']]$ALGEBRA_I.EOCT[!CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 %in% c("ALGEBRA_I.EOCT", "ALGEBRA_II.EOCT") | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks

table(ALG1$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
ALG1[COUNT > 100]  #  Major progressions

###   Viable 1 Prior (Spring 18) ALGEBRA_I Progressions
ALG1[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]

#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 Total
# 1:                      GEOMETRY.EOCT  1280
# 2:             INTEGRATED_MATH_1.EOCT     1
# 3:                     MATHEMATICS.05     1
# 4:                     MATHEMATICS.06     1
# 5:                     MATHEMATICS.07   219
# 6:                     MATHEMATICS.08  3475 (+3)

###   All listed
###   BI - None
###   MD - MATHEMATICS.08 1547 (+3)
###   NJ - MATHEMATICS.08 1670
###   NM - None > 1000


###   Viable 1 Prior (Fall 17) ALGEBRA_I Progressions (ENFORCE THAT NO SPRING 18 TEST AVAILABLE!)
ALG1[is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2)]

#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 Total
# 1:                     ALGEBRA_I.EOCT  1133  XXX  Exclude repeater analyses (+1)
# 2:                    ALGEBRA_II.EOCT    21  XXX  Exclude regressor analyses
# 3:                      GEOMETRY.EOCT    33  XXX  Include for SGP_NOTE


###   Viable 2 Prior (Spring 18 + Spring 17) ALGEBRA_I Progressions
ALG1[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.3")][Total > 100]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 CONTENT_AREA_by_GRADE_PRIOR_YEAR.3 Total
# 1:                      GEOMETRY.EOCT                               <NA>   339
# 2:                      GEOMETRY.EOCT                     ALGEBRA_I.EOCT   861
# 3:                     MATHEMATICS.07                     MATHEMATICS.06   207
# 4:                     MATHEMATICS.08                               <NA>   134
# 5:                     MATHEMATICS.08                     MATHEMATICS.07  3323   YYY  3472 w/ at least 8th grade (+2)

ALG1[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="MATHEMATICS.08" & CONTENT_AREA_by_GRADE_PRIOR_YEAR.3=="MATHEMATICS.07"]
###   8th and 7th Grade Math
###   MD - MATHEMATICS.08  <->  MATHEMATICS.07 1504 (+3)
###   NJ - MATHEMATICS.08  <->  MATHEMATICS.07 1580

ALG1[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="MATHEMATICS.06", list(Total=sum(COUNT))] #    1
ALG1[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="GEOMETRY.EOCT", list(Total=sum(COUNT))]  # 1280
ALG1[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="GEOMETRY.EOCT", list(Total=sum(COUNT))]  #   37



###
###   Geometry (No Repeaters)
###

GEOM <- math.prog$BACKWARD[['2018_2019.1']]$GEOMETRY.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "GEOMETRY.EOCT" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks

table(GEOM$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
GEOM[COUNT > 100]  #  Major progressions

###   Viable 1 Prior (Spring 18) GEOMETRY Progressions
GEOM[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1   Total
# 1:                     ALGEBRA_I.EOCT   2755 (+1)
# 2:                    ALGEBRA_II.EOCT    698
# 3:             INTEGRATED_MATH_1.EOCT     75
# 4:             INTEGRATED_MATH_2.EOCT     12
# 5:             INTEGRATED_MATH_3.EOCT     48
# 6:                     MATHEMATICS.08     23

###   All listed - Establish configs with ALGEBRA_II, Int Maths & Math 8 for the SGP_NOTE variables
###   MD - None > 1000
###   NJ - ALGEBRA_I.EOCT  2563 (+1)
###   NM - None > 1000


###   Viable 1 Prior (Fall 17) GEOMETRY Progressions (ENFORCE THAT NO Spring 18 TEST AVAILABLE!)
GEOM[is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2)]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 Total
# 1:                     ALGEBRA_I.EOCT   632  (743 if allow for Spring 18 tests - still not viable)
# 2:                    ALGEBRA_II.EOCT   160
# 3:                      GEOMETRY.EOCT    69
###   None - but establish configs with Algebra I and II for the SGP_NOTE variables
table(math.prog$BACKWARD[['2018_2019.1']]$GEOMETRY.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "ALGEBRA_I.EOCT",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1])
table(math.prog$BACKWARD[['2018_2019.1']]$GEOMETRY.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "ALGEBRA_II.EOCT",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1])
table(math.prog$BACKWARD[['2018_2019.1']]$GEOMETRY.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "GEOMETRY.EOCT",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1])


###   Viable 2 Prior (Spring 18 + Spring 17) GEOMETRY Progressions
GEOM[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.3")][Total > 100]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 CONTENT_AREA_by_GRADE_PRIOR_YEAR.3 Total
# 1:                     ALGEBRA_I.EOCT                               <NA>   353
# 2:                     ALGEBRA_I.EOCT                     ALGEBRA_I.EOCT   161
# 3:                     ALGEBRA_I.EOCT                     MATHEMATICS.07   730
# 4:                     ALGEBRA_I.EOCT                     MATHEMATICS.08  1481 (+1)
# 5:                    ALGEBRA_II.EOCT                     ALGEBRA_I.EOCT   370
# 6:                    ALGEBRA_II.EOCT                      GEOMETRY.EOCT   198

###   NJ - ALGEBRA_I.EOCT  <->  MATHEMATICS.08  1450 (+1)

###   Algebra I and 8th Grade Math, with exclusions
GEOM[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ALGEBRA_I.EOCT" & CONTENT_AREA_by_GRADE_PRIOR_YEAR.3=="MATHEMATICS.08"]
GEOM[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ALGEBRA_I.EOCT" & CONTENT_AREA_by_GRADE_PRIOR_YEAR.3=="MATHEMATICS.08", list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")]

GEOM[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.3), list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.3"]


###
###   Algebra II (No Repeaters)
###

ALG2 <- math.prog$BACKWARD[['2018_2019.1']]$ALGEBRA_II.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "ALGEBRA_II.EOCT" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks
ALG2[COUNT > 100]  #  Major progressions

###   Viable 1 Prior (Spring 18) ALGEBRA_II Progressions
ALG2[, list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 Total
# 1:                     ALGEBRA_I.EOCT   685
# 2:                      GEOMETRY.EOCT  2518
# 3:             INTEGRATED_MATH_1.EOCT     9
# 4:             INTEGRATED_MATH_2.EOCT    42
# 5:             INTEGRATED_MATH_3.EOCT     4

###   Geometry - Establish configs with Algebra I for the SGP_NOTE variables
###   MD - None > 1000
###   NJ - GEOMETRY.EOCT  1854

###   Viable 2 Prior (Spring 18 + Spring 17) GEOMETRY Progressions
ALG2[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.3")][Total > 100]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 CONTENT_AREA_by_GRADE_PRIOR_YEAR.3  Total
# 1:                     ALGEBRA_I.EOCT                               <NA>    106
# 2:                     ALGEBRA_I.EOCT                     MATHEMATICS.07    210
# 3:                     ALGEBRA_I.EOCT                     MATHEMATICS.08    230
# 4:                      GEOMETRY.EOCT                               <NA>    531
# 5:                      GEOMETRY.EOCT                     ALGEBRA_I.EOCT   1628
# 6:                      GEOMETRY.EOCT                     MATHEMATICS.08    169

###   NJ - GEOMETRY.EOCT  <->  ALGEBRA_I.EOCT  1362

###   Viable 1 Prior (Fall 17) ALGEBRA_II Progressions
ALG2[is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")] ### [!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2)] ### (NO Spring 18 TEST AVAILABLE!)
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 Total
# 1:                     ALGEBRA_I.EOCT   192
# 2:                    ALGEBRA_II.EOCT   195
# 3:                      GEOMETRY.EOCT  1228   YYY   1298   ###  1228 (NO Spring 18 TEST AVAILABLE)

###   Geometry - Establish configs with Algebra I for the SGP_NOTE variables
###   MD - None > 1000
###   NJ - GEOMETRY.EOCT  1129 (1158?)

table(math.prog$BACKWARD[['2018_2019.1']]$ALGEBRA_II.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "ALGEBRA_I.EOCT",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1]) # Exclude  GEOMETRY, ALGEBRA_I and ALGEBRA_II
table(math.prog$BACKWARD[['2018_2019.1']]$ALGEBRA_II.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "GEOMETRY.EOCT",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1])  # Exclude  GEOMETRY, ALGEBRA_I and ALGEBRA_II



####
####     ELA
####


###  Find out which grades are present in the Fall ELA data
names(ela.prog$BACKWARD[['2018_2019.1']])


###  Spring to FallBlock
sum(ela.prog$BACKWARD[['2018_2019.1']]$ELA.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.08"]$COUNT)   #   3994
sum(ela.prog$BACKWARD[['2018_2019.1']]$ELA.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.08" & !CONTENT_AREA_by_GRADE_PRIOR_YEAR.3 %in% "ELA.07"]$COUNT)  #  177
sum(ela.prog$BACKWARD[['2018_2019.1']]$ELA.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.09"]$COUNT)   #    129 (repeaters)
sum(ela.prog$BACKWARD[['2018_2019.1']]$ELA.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.09"]$COUNT)   #   2388 (+1)
sum(ela.prog$BACKWARD[['2018_2019.1']]$ELA.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.09" & !CONTENT_AREA_by_GRADE_PRIOR_YEAR.3 %in% "ELA.08"]$COUNT)  #  274
sum(ela.prog$BACKWARD[['2018_2019.1']]$ELA.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.10"]$COUNT)   #  12283 (repeaters) (mostly MD - 11666) (+3)
sum(ela.prog$BACKWARD[['2018_2019.1']]$ELA.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.10"]$COUNT)   #   3720
sum(ela.prog$BACKWARD[['2018_2019.1']]$ELA.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.10" & !CONTENT_AREA_by_GRADE_PRIOR_YEAR.3 %in% "ELA.09"]$COUNT)  # 1854  YYY  1849
sum(ela.prog$BACKWARD[['2018_2019.1']]$ELA.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.11"]$COUNT)   #   5772 (repeaters) (mostly NM (+ NJ))

###   Viable 2 Prior ELA Progressions  (ALL viable)
ela.prog$BACKWARD[['2018_2019.1']]$ELA.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.08", list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.2", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.3")][Total > 100]
ela.prog$BACKWARD[['2018_2019.1']]$ELA.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.09", list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.2", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.3")][Total > 100]
ela.prog$BACKWARD[['2018_2019.1']]$ELA.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.10", list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.2", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.3")][Total > 100]


###  Fall to Fall
sum(ela.prog$BACKWARD[['2018_2019.1']]$ELA.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.09"]$COUNT)   #    48 (repeaters)

sum(ela.prog$BACKWARD[['2018_2019.1']]$ELA.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.09"]$COUNT)   #  1536
sum(ela.prog$BACKWARD[['2018_2019.1']]$ELA.10[is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1) & CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.09"]$COUNT)   #  1507
table(ela.prog$BACKWARD[['2018_2019.1']]$ELA.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "ELA.09",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1])  # Some 9th & 10th.  Exclude in future?
sum(ela.prog$BACKWARD[['2018_2019.1']]$ELA.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.10"]$COUNT)   #  2851 (repeaters) (+4)

sum(ela.prog$BACKWARD[['2018_2019.1']]$ELA.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.10"]$COUNT)   #  2552  YYY   2483
sum(ela.prog$BACKWARD[['2018_2019.1']]$ELA.11[is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1) & CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.10"]$COUNT)   #  1942
table(ela.prog$BACKWARD[['2018_2019.1']]$ELA.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "ELA.10",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1])  # Some 9th, 10th & 11th.  Exclude in future?
sum(ela.prog$BACKWARD[['2018_2019.1']]$ELA.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.11"]$COUNT)   #   352 (repeaters)

###  2 Fall priors (NOT viable)
ela.prog$BACKWARD[['2018_2019.1']]$ELA.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.10", list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.4")][Total > 100]
