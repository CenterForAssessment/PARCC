################################################################################
###                                                                          ###
###         Identify Spring 2015 to Fall 2015 Progressions for PARCC         ###
###                                                                          ###
################################################################################

library(SGP)
library(plyr)
library(data.table)
library(RSQLite)
library(data.table)
# source('./PARCC/courseProgressionSGP.R', chdir = TRUE)

parcc.db <- "./PARCC/Data/PARCC_Data_LONG.sqlite"
PARCC_Data_LONG <- rbindlist(list(
			dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select ID, YEAR, CONTENT_AREA, GRADE, VALID_CASE from PARCC_Data_LONG_2015_2"),
			dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select ID, YEAR, CONTENT_AREA, GRADE, VALID_CASE from PARCC_Data_LONG_2016_1")))

PARCC_Data_LONG <- PARCC_Data_LONG[grep("_SS", CONTENT_AREA, invert =TRUE),]

###  Get subset of Fall 2015 and Spring 2015 from those IDs
ids <- unique(PARCC_Data_LONG[YEAR=="2015_2016.1"]$ID)
FALL_Data_LONG <- PARCC_Data_LONG[ID %in% ids,]

###  Subset by content area

PARCC_MATH<- FALL_Data_LONG[!CONTENT_AREA %in% "ELA"]
table(PARCC_MATH$CONTENT_AREA, PARCC_MATH$YEAR)

PARCC_ELA <- FALL_Data_LONG[CONTENT_AREA %in% "ELA"]
table(PARCC_ELA$GRADE)

math.prog <- courseProgressionSGP(PARCC_MATH, lag.direction="BACKWARD", year='2015_2016.1')
ela.prog <- courseProgressionSGP(PARCC_ELA, lag.direction="BACKWARD", year='2015_2016.1')


####
####     Mathematics
####

names(math.prog$BACKWARD[['2015_2016.1']])

math.prog$BACKWARD[['2015_2016.1']]$ALGEBRA_I.CT[COUNT>100]
sum(math.prog$BACKWARD[['2015_2016.1']]$ALGEBRA_I.CT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="MATHEMATICS.08"]$COUNT) # 3132
sum(math.prog$BACKWARD[['2015_2016.1']]$ALGEBRA_I.CT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="GEOMETRY.CT"]$COUNT) # 73
sum(math.prog$BACKWARD[['2015_2016.1']]$ALGEBRA_I.CT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ALGEBRA_I.CT"]$COUNT) # 905 repeaters


math.prog$BACKWARD[['2015_2016.1']]$GEOMETRY.CT[COUNT>100]
sum(math.prog$BACKWARD[['2015_2016.1']]$GEOMETRY.CT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ALGEBRA_I.CT"]$COUNT)  # 2615
sum(math.prog$BACKWARD[['2015_2016.1']]$GEOMETRY.CT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ALGEBRA_II.CT"]$COUNT) # 582
sum(math.prog$BACKWARD[['2015_2016.1']]$GEOMETRY.CT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="GEOMETRY.CT"]$COUNT)   # 1012 (repeaters)


math.prog$BACKWARD[['2015_2016.1']]$ALGEBRA_II.CT[COUNT>100]
sum(math.prog$BACKWARD[['2015_2016.1']]$ALGEBRA_II.CT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="GEOMETRY.CT"]$COUNT) # 1884
sum(math.prog$BACKWARD[['2015_2016.1']]$ALGEBRA_II.CT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ALGEBRA_I.CT"]$COUNT) # 699
sum(math.prog$BACKWARD[['2015_2016.1']]$ALGEBRA_II.CT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ALGEBRA_II.CT"]$COUNT) # 4877 (repeaters)

math.prog$BACKWARD[['2015_2016.2']]$INTEGRATED_MATH_2.CT[COUNT>100]
sum(math.prog$BACKWARD[['2015_2016.2']]$INTEGRATED_MATH_3.CT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="GEOMETRY.CT"]$COUNT) # 

###
###     ELA
###

names(ela.prog$BACKWARD[['2015_2016.1']])

ela.prog$BACKWARD[['2015_2016.1']]$ELA.09
ela.prog$BACKWARD[['2015_2016.1']]$ELA.10
ela.prog$BACKWARD[['2015_2016.1']]$ELA.11

