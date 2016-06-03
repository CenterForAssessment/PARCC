library(SGP)
library(plyr)
library(data.table)
source('~/Dropbox (SGP)/Application_Projects/EOC Course progressions/courseProgressionSGP.R', chdir = TRUE)

###  Get subset of Fall 2015 and Spring 2015 from those IDs
ids <- unique(PARCC_Data_LONG_2016$PARCCStudentIdentifier)
sub <- PARCC_Data_LONG_2015[PARCCStudentIdentifier %in% ids,]
FALL_Data_LONG <- rbindlist(list(sub[,head(parcc.var.names, -1), with=FALSE], PARCC_Data_LONG_2016[,head(parcc.var.names, -1), with=FALSE]), fill=TRUE)

###  Spring 2015 SGPs?
ids <- unique(PARCC_Data_LONG[YEAR == '2014_2015.1']$ID)
sub <- PARCC_Data_LONG[ID %in% ids,]
sub[, GRADE := as.character(GRADE)]

###  Subset by content area

PARCC_ELA <- FALL_Data_LONG[CONTENT_AREA %in% c("ELA", "ELA_SS")][, c("ID", "YEAR", "CONTENT_AREA", "GRADE", "VALID_CASE"), with=FALSE]
PARCC_MATH<-FALL_Data_LONG[!CONTENT_AREA %in% c("ELA", "ELA_SS")][, c("ID", "YEAR", "CONTENT_AREA", "GRADE", "VALID_CASE"), with=FALSE]

PARCC_ELA <- sub[CONTENT_AREA %in% c("ELA", "ELA_SS")][, c("ID", "YEAR", "CONTENT_AREA", "GRADE", "VALID_CASE"), with=FALSE]
PARCC_MATH<-sub[!CONTENT_AREA %in% c("ELA", "ELA_SS")][, c("ID", "YEAR", "CONTENT_AREA", "GRADE", "VALID_CASE"), with=FALSE]

table(PARCC_ELA$GRADE)

math.prog <- courseProgressionSGP(PARCC_MATH, lag.direction.argument="BACKWARD", year='2015_2016.1')
ela.prog <- courseProgressionSGP(PARCC_ELA, lag.direction.argument="BACKWARD", year='2015_2016.1')

math.prog <- courseProgressionSGP(PARCC_MATH, lag.direction.argument="BACKWARD", year='2014_2015.2')
ela.prog <- courseProgressionSGP(PARCC_ELA, lag.direction.argument="BACKWARD", year='2014_2015.2')


####
####     Mathematics
####

names(math.prog$BACKWARD[['2015_2016.1']])

math.prog$BACKWARD[['2015_2016.1']]$ALGEBRA_I.CT[COUNT>100]
sum(math.prog$BACKWARD[['2015_2016.1']]$ALGEBRA_I.CT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="MATHEMATICS.08"]$COUNT) # 3114
sum(math.prog$BACKWARD[['2015_2016.1']]$ALGEBRA_I.CT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ALGEBRA_I.CT"]$COUNT) # 905 repeaters


math.prog$BACKWARD[['2015_2016.1']]$GEOMETRY.CT[COUNT>100] # ALL sgp.content.areas=c('PRE_ALGEBRA', 'ALGEBRA_I', 'GEOMETRY'),
sum(math.prog$BACKWARD[['2015_2016.1']]$GEOMETRY.CT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ALGEBRA_I.CT"]$COUNT) # 2615
sum(math.prog$BACKWARD[['2015_2016.1']]$GEOMETRY.CT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="GEOMETRY.CT"]$COUNT) # 1012 (repeaters)


math.prog$BACKWARD[['2015_2016.1']]$ALGEBRA_II.CT[COUNT>100]
sum(math.prog$BACKWARD[['2015_2016.1']]$ALGEBRA_II.CT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="GEOMETRY.CT"]$COUNT) # 1884
sum(math.prog$BACKWARD[['2015_2016.1']]$ALGEBRA_II.CT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ALGEBRA_I.CT"]$COUNT) # 699
sum(math.prog$BACKWARD[['2015_2016.1']]$ALGEBRA_II.CT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ALGEBRA_II.CT"]$COUNT) # 4877 (repeaters)
sum(math.prog$BACKWARD[['2015_2016.1']]$ALGEBRA_II.CT[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2)]$COUNT) # 378

math.prog$BACKWARD[['2015_2016.2']]$INTEGRATED_MATH_3.CT[COUNT>100]
sum(math.prog$BACKWARD[['2015_2016.2']]$INTEGRATED_MATH_3.CT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="GEOMETRY.CT"]$COUNT) # 

###
###
###

names(ela.prog$BACKWARD[['2015_2016.1']])

ela.prog$BACKWARD[['2015_2016.1']]$ELA.09
ela.prog$BACKWARD[['2015_2016.1']]$ELA.10
ela.prog$BACKWARD[['2015_2016.1']]$ELA.11

###
###		Using Fall 2015.  Nothing there ....
###


names(math.prog$BACKWARD[['2014_2015.2']])

math.prog$BACKWARD[['2014_2015.2']]$ALGEBRA_II.CT[COUNT>100]
sum(math.prog$BACKWARD[['2014_2015.2']]$ALGEBRA_II.CT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ALGEBRA_I.CT"]$COUNT)
sum(math.prog$BACKWARD[['2014_2015.2']]$ALGEBRA_II.CT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="GEOMETRY.CT"]$COUNT) # 905 repeaters

ela.prog$BACKWARD[['2014_2015.2']]$ELA.09
ela.prog$BACKWARD[['2014_2015.2']]$ELA.10
ela.prog$BACKWARD[['2014_2015.2']]$ELA.11
