################################################################################
###                                                                          ###
###         Identify Spring 2016 to Fall 2016 Progressions for PARCC         ###
###                                                                          ###
################################################################################

library(SGP)
library(plyr)
library(data.table)
library(RSQLite)
library(data.table)


###  Location of PARCC SQLite Database (Fall 2016 added in Data Prep step)
parcc.db <- "./Data/PARCC_Data_LONG.sqlite"

PARCC_Data_LONG <- rbindlist(list(
			dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select ID, YEAR, CONTENT_AREA, GRADE, VALID_CASE from PARCC_Data_LONG_2015_2"),
			dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select ID, YEAR, CONTENT_AREA, GRADE, VALID_CASE from PARCC_Data_LONG_2016_1"),
			dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select ID, YEAR, CONTENT_AREA, GRADE, VALID_CASE from PARCC_Data_LONG_2016_2"),
			dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select ID, YEAR, CONTENT_AREA, GRADE, VALID_CASE from PARCC_Data_LONG_2017_1")))

PARCC_Data_LONG <- PARCC_Data_LONG[grep("_SS", CONTENT_AREA, invert =TRUE),]


###  Get subset of PARCC_Data_LONG with only IDs from Fall 2016

ids <- unique(PARCC_Data_LONG[YEAR=="2016_2017.1", ID])
FALL_Data_LONG <- PARCC_Data_LONG[ID %in% ids,]

table(FALL_Data_LONG[!CONTENT_AREA %in% "ELA", CONTENT_AREA, YEAR])
table(FALL_Data_LONG[CONTENT_AREA %in% "ELA", GRADE])


###  Run courseProgressionSGP by content area subsets of the FALL_Data_LONG

math.prog<- courseProgressionSGP(FALL_Data_LONG[!CONTENT_AREA %in% "ELA"], lag.direction="BACKWARD", year='2016_2017.1')
ela.prog <- courseProgressionSGP(FALL_Data_LONG[CONTENT_AREA %in% "ELA"], lag.direction="BACKWARD", year='2016_2017.1')


####
####     Mathematics
####

###  Find out which Math related content areas are present in the Fall data
names(math.prog$BACKWARD[['2016_2017.1']])

math.prog$BACKWARD[['2016_2017.1']]$ALGEBRA_I.CT[COUNT > 100]
sum(math.prog$BACKWARD[['2016_2017.1']]$ALGEBRA_I.CT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="MATHEMATICS.08"]$COUNT) #
sum(math.prog$BACKWARD[['2016_2017.1']]$ALGEBRA_I.CT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="GEOMETRY.CT"]$COUNT)    #
sum(math.prog$BACKWARD[['2016_2017.1']]$ALGEBRA_I.CT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ALGEBRA_I.CT"]$COUNT)   #  repeaters


math.prog$BACKWARD[['2016_2017.1']]$GEOMETRY.CT[COUNT > 100]
sum(math.prog$BACKWARD[['2016_2017.1']]$GEOMETRY.CT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ALGEBRA_I.CT"]$COUNT)  #
sum(math.prog$BACKWARD[['2016_2017.1']]$GEOMETRY.CT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ALGEBRA_II.CT"]$COUNT) #
sum(math.prog$BACKWARD[['2016_2017.1']]$GEOMETRY.CT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="GEOMETRY.CT"]$COUNT)   #  (repeaters)


math.prog$BACKWARD[['2016_2017.1']]$ALGEBRA_II.CT[COUNT > 100]
sum(math.prog$BACKWARD[['2016_2017.1']]$ALGEBRA_II.CT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="GEOMETRY.CT"]$COUNT)   #
sum(math.prog$BACKWARD[['2016_2017.1']]$ALGEBRA_II.CT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ALGEBRA_I.CT"]$COUNT)  #
sum(math.prog$BACKWARD[['2016_2017.1']]$ALGEBRA_II.CT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ALGEBRA_II.CT"]$COUNT) #  (repeaters)


###
###     ELA
###

###  Find out which grades are present in the Fall ELA data
names(ela.prog$BACKWARD[['2016_2017.1']])

ela.prog$BACKWARD[['2016_2017.1']]$ELA.09
ela.prog$BACKWARD[['2016_2017.1']]$ELA.10
ela.prog$BACKWARD[['2016_2017.1']]$ELA.11
