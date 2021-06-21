################################################################################
###                                                                          ###
###                Identify Fall 2019 Progressions for PARCC                 ###
###                                                                          ###
################################################################################

library(SGP)
library(data.table)


###  Combine long data from Spring 2019 analyses with Fall 2019 (NJ only) data
load("./PARCC/Data/Archive/2018_2019.2/PARCC_SGP_LONG_Data.Rdata")
load("./New_Jersey/Data/Archive/2019_2020.1/New_Jersey_Data_LONG_2019_2020.1.Rdata")

PARCC_SGP_LONG_Data <- PARCC_SGP_LONG_Data[StateAbbreviation %in% c("NJ")][grep("_SS", CONTENT_AREA, invert =TRUE),]; gc() # (NJ only) data

PARCC_Data_LONG <- rbindlist(list(
			PARCC_SGP_LONG_Data,
			New_Jersey_Data_LONG_2019_2020.1[grep("_SS", CONTENT_AREA, invert =TRUE),]), fill=TRUE)

# PARCC_Data_LONG <- PARCC_Data_LONG[StateAbbreviation %in% c("NJ")]

###  Get subset of PARCC_Data_LONG with only IDs from Fall 2019

ids <- unique(PARCC_Data_LONG[YEAR=="2019_2020.1", ID])
# nj.ids <- unique(New_Jersey_Data_LONG_2019_2020.1[, ID]); identical(sort(nj.ids), sort(ids))
Fall_Data_LONG <- PARCC_Data_LONG[ID %in% ids,]

###  States
# Fall_Data_LONG <- Fall_Data_LONG[StateAbbreviation=="NJ"]
# BIA (Fall IDs subset?) has no previous fall (2019_2020.1) -- throws off PRIOR_YEAR.2, so it looks like some progressions should work that really don't.

table(Fall_Data_LONG[CONTENT_AREA != "ELA", CONTENT_AREA, YEAR])
table(Fall_Data_LONG[which(CONTENT_AREA == "ELA"), as.numeric(GRADE), YEAR])
table(Fall_Data_LONG[which(YEAR == '2019_2020.1'), GRADE, CONTENT_AREA])

###  Run courseProgressionSGP by content area subsets of the Fall_Data_LONG // Maryland_Data_LONG[grep("_SS", CONTENT_AREA, invert =TRUE),]

math.prog<- courseProgressionSGP(Fall_Data_LONG[!CONTENT_AREA %in% "ELA"], lag.direction="BACKWARD", year='2019_2020.1')
ela.prog <- courseProgressionSGP(Fall_Data_LONG[CONTENT_AREA %in% "ELA"], lag.direction="BACKWARD", year='2019_2020.1')


####
####     Mathematics
####

###  Find out which Math related content areas are present in the Fall data
names(math.prog$BACKWARD[['2019_2020.1']])

###
###   Algebra I (No Repeaters or Regression)
###

ALG1 <- math.prog$BACKWARD[['2019_2020.1']]$ALGEBRA_I.EOCT[!CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 %in% c("ALGEBRA_I.EOCT", "ALGEBRA_II.EOCT") | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks

table(ALG1$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
ALG1[COUNT > 100]  #  Major progressions

###   Viable 1 Prior (Spring 19) ALGEBRA_I Progressions
ALG1[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]

#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1    Total
# 1:                      GEOMETRY.EOCT      106
# 2:                     MATHEMATICS.07       26
# 3:                     MATHEMATICS.08     1542

###   All listed
###   NJ - MATHEMATICS.08 1542


###   Viable 1 Prior (Fall 18) ALGEBRA_I Progressions (ENFORCE THAT NO SPRING 19 TEST AVAILABLE!)
ALG1[is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2)]

#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.2    Total
# 1:                     ALGEBRA_I.EOCT       56  XXX  Exclude repeater analyses
# 2:                    ALGEBRA_II.EOCT        9  XXX  Exclude regressor analyses
# 3:                      GEOMETRY.EOCT        2  XXX  Include for SGP_NOTE


###   Viable 2 Prior (Spring 19 + Spring 18) ALGEBRA_I Progressions
ALG1[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.3")][Total > 100]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1   CONTENT_AREA_by_GRADE_PRIOR_YEAR.3   Total
# 1:                     MATHEMATICS.08                       MATHEMATICS.07    1439

ALG1[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="MATHEMATICS.08" & CONTENT_AREA_by_GRADE_PRIOR_YEAR.3=="MATHEMATICS.07"]
###   8th and 7th Grade Math
###   NJ - MATHEMATICS.08  <->  MATHEMATICS.07

ALG1[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="MATHEMATICS.07", list(Total=sum(COUNT))] #   26
ALG1[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="GEOMETRY.EOCT", list(Total=sum(COUNT))]  #  106
ALG1[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="GEOMETRY.EOCT", list(Total=sum(COUNT))]  #    2


###
###   Geometry (No Repeaters)
###

GEOM <- math.prog$BACKWARD[['2019_2020.1']]$GEOMETRY.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "GEOMETRY.EOCT" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks

table(GEOM$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
GEOM[COUNT > 100]  #  Major progressions

###   Viable 1 Prior (Spring 19) GEOMETRY Progressions
GEOM[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1    Total
# 1:                     ALGEBRA_I.EOCT     2697
# 2:                    ALGEBRA_II.EOCT      286
# 3:                     MATHEMATICS.08        9

###   All listed - Establish configs with ALGEBRA_II, Int Maths & Math 8 for the SGP_NOTE variables
###   NJ - ALGEBRA_I.EOCT  2697


###   Viable 1 Prior (Fall 18) GEOMETRY Progressions (ENFORCE THAT NO Spring 19 TEST AVAILABLE!)
GEOM[is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2)]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 Total
# 1:                     ALGEBRA_I.EOCT   664
# 2:                    ALGEBRA_II.EOCT   119
# 3:                      GEOMETRY.EOCT    24

###   None - but establish configs with Algebra I and II for the SGP_NOTE variables
table(math.prog$BACKWARD[['2019_2020.1']]$GEOMETRY.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "ALGEBRA_I.EOCT",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1])
table(math.prog$BACKWARD[['2019_2020.1']]$GEOMETRY.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "ALGEBRA_II.EOCT",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1])
table(math.prog$BACKWARD[['2019_2020.1']]$GEOMETRY.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "GEOMETRY.EOCT",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1])


###   Viable 2 Prior (Spring 19 + Spring 18) GEOMETRY Progressions
GEOM[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.3")][Total > 100]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1    CONTENT_AREA_by_GRADE_PRIOR_YEAR.3    Total
# 1:                     ALGEBRA_I.EOCT                                  <NA>      237
# 2:                     ALGEBRA_I.EOCT                        ALGEBRA_I.EOCT      108
# 3:                     ALGEBRA_I.EOCT                        MATHEMATICS.07      863
# 4:                     ALGEBRA_I.EOCT                        MATHEMATICS.08     1482
# 5:                    ALGEBRA_II.EOCT                        ALGEBRA_I.EOCT      215

###   NJ - ALGEBRA_I.EOCT  <->  MATHEMATICS.08  1482

###   Algebra I and 8th Grade Math, with exclusions
GEOM[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ALGEBRA_I.EOCT" & CONTENT_AREA_by_GRADE_PRIOR_YEAR.3=="MATHEMATICS.08"]
GEOM[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ALGEBRA_I.EOCT" & CONTENT_AREA_by_GRADE_PRIOR_YEAR.3=="MATHEMATICS.08", list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")]

GEOM[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.3), list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.3"]


###
###   Algebra II (No Repeaters)
###

ALG2 <- math.prog$BACKWARD[['2019_2020.1']]$ALGEBRA_II.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "ALGEBRA_II.EOCT" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks
ALG2[COUNT > 100]  #  Major progressions

###   Viable 1 Prior (Spring 19) ALGEBRA_II Progressions
ALG2[, list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1    Total
# 1:                     ALGEBRA_I.EOCT      144
# 2:                      GEOMETRY.EOCT      945  #  XXX  Close!  Ask Pearson/NJ

###   Geometry - Establish configs with Algebra I for the SGP_NOTE variables
###   NJ - GEOMETRY.EOCT  945

###   Viable 2 Prior (Spring 19 + Spring 18) GEOMETRY Progressions
ALG2[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.3")][Total > 100]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1    CONTENT_AREA_by_GRADE_PRIOR_YEAR.3   Total
# 1:                      GEOMETRY.EOCT                        ALGEBRA_I.EOCT     729


###   Viable 1 Prior (Fall 18) ALGEBRA_II Progressions
ALG2[is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")] ### [!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2)] ### (NO Spring 18 TEST AVAILABLE!)
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 Total
# 1:                               <NA>    91
# 2:                     ALGEBRA_I.EOCT    64
# 3:                    ALGEBRA_II.EOCT     8
# 4:                      GEOMETRY.EOCT   440

###   Geometry - Establish configs with Algebra I & Geometry for the SGP_NOTE variables
###   NJ - GEOMETRY.EOCT  440

table(math.prog$BACKWARD[['2019_2020.1']]$ALGEBRA_II.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "ALGEBRA_I.EOCT",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1]) # Exclude  GEOMETRY, ALGEBRA_I and ALGEBRA_II
table(math.prog$BACKWARD[['2019_2020.1']]$ALGEBRA_II.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "GEOMETRY.EOCT",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1])  # Exclude  GEOMETRY, ALGEBRA_I and ALGEBRA_II



####
####     ELA
####


###  Find out which grades are present in the Fall ELA data
names(ela.prog$BACKWARD[['2019_2020.1']])


###  Spring to FallBlock
sum(ela.prog$BACKWARD[['2019_2020.1']]$ELA.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.08"]$COUNT)   #   3529
sum(ela.prog$BACKWARD[['2019_2020.1']]$ELA.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.08" & !CONTENT_AREA_by_GRADE_PRIOR_YEAR.3 %in% "ELA.07"]$COUNT)  #  151
sum(ela.prog$BACKWARD[['2019_2020.1']]$ELA.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.09"]$COUNT)   #    116 (repeaters)
sum(ela.prog$BACKWARD[['2019_2020.1']]$ELA.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.09"]$COUNT)   #   2002
sum(ela.prog$BACKWARD[['2019_2020.1']]$ELA.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.09" & !CONTENT_AREA_by_GRADE_PRIOR_YEAR.3 %in% "ELA.08"]$COUNT)  #  192
sum(ela.prog$BACKWARD[['2019_2020.1']]$ELA.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.10"]$COUNT)   #    487 (repeaters)

###   Viable 2 Prior ELA Progressions  (ALL viable)
ela.prog$BACKWARD[['2019_2020.1']]$ELA.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.08", list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.2", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.3")][Total > 100]
ela.prog$BACKWARD[['2019_2020.1']]$ELA.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.09", list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.2", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.3")][Total > 100]


###  Fall to Fall
sum(ela.prog$BACKWARD[['2019_2020.1']]$ELA.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.09"]$COUNT)   #    65 (repeaters)

sum(ela.prog$BACKWARD[['2019_2020.1']]$ELA.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.09"]$COUNT)   #  1626
sum(ela.prog$BACKWARD[['2019_2020.1']]$ELA.10[is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1) & CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.09"]$COUNT)   #  1600
table(ela.prog$BACKWARD[['2019_2020.1']]$ELA.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "ELA.09",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1])  # Some 9th & 10th.  Exclude in future?
sum(ela.prog$BACKWARD[['2019_2020.1']]$ELA.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.10"]$COUNT)   #   147 (repeaters)
