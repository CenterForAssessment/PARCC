#################################################################################
###                                                                           ###
###   SGP analysis script for PARCC Alternative Test Consortiums - May 2019   ###
###                                                                           ###
#################################################################################

### Load Packages
require(SGP)
require(data.table)
later:::ensureInitialized()
workers <- 20

###  Load SGP object from Spring 2018 Analyses and Base data from 2015-2016.
load("./Data/Archive/2017_2018.2/PARCC_SGP.Rdata")
load("./Data/Archive/2016_2017.1/PARCC_SGP_LONG_Data.Rdata")
table(PARCC_SGP@Data[, YEAR])
table(PARCC_SGP_LONG_Data[YEAR != "2015_2016.2"])

PARCC_SGP@Data <- rbindlist(list(PARCC_SGP@Data, PARCC_SGP_LONG_Data[YEAR != "2015_2016.2"]), fill=TRUE)
PARCC_SGP@Data <- PARCC_SGP@Data[grep("_SS", CONTENT_AREA, invert =TRUE),]
PARCC_SGP@Data <- PARCC_SGP@Data[StateAbbreviation %in% c("BI", "DC", "DD", "IL", "MD", "NJ", "NM"), ]

###  These changes should have been made but weren't
###  This problem required manual reconciling in the script below (after abcSGP function)
###  As a result ~3,000 DC kids were included in the PARCC ELA 10 norm group who otherwise would not have.  (However, these cases are VALID otherwise for inclusion).
PARCC_SGP@Data[StateAbbreviation == "DC" & TestCode == "ELA09", VALID_CASE := "INVALID_CASE"] # 14,122 cases
PARCC_SGP@Data[StateAbbreviation == "DC" & TestCode == "ALG01" & GradeLevelWhenAssessed %in% c("09", "10", "11", "12", "99"), VALID_CASE := "INVALID_CASE"] # 11,120 cases

###   Rename ORIGINAL 'SGP' variables as 'ORIG' (except TARGET and PROJECTION variables)
grep('(?=^((?!TARGET|PROJECTION).)*$)SGP', names(PARCC_SGP@Data), value=TRUE, perl=TRUE)
setnames(PARCC_SGP@Data, grep('(?=^((?!TARGET|PROJECTION).)*$)SGP', names(PARCC_SGP@Data), value=TRUE, perl=TRUE),
			gsub("SGP", "ORIG", grep('(?=^((?!TARGET|PROJECTION).)*$)SGP', names(PARCC_SGP@Data), value=TRUE, perl=TRUE)))

###   Create Alternative VALID_CASE Variable
PARCC_SGP@Data$VC_ORIG <- as.character(NA)
PARCC_SGP@Data[, VC_ORIG := VALID_CASE]

###   Remove @SGP Slot from ORIG analyses
PARCC_SGP@SGP <- NULL;gc()
PARCC_SGP@Data[, CATCH_UP_KEEP_UP_STATUS := NULL]
PARCC_SGP@Data[, MOVE_UP_STAY_UP_STATUS := NULL]
PARCC_SGP <- prepareSGP(PARCC_SGP, create.additional.variables=FALSE)
save(PARCC_SGP, file="/media/Data/PARCC_Alt/PARCC_SGP_Alt.rda")


####
####    Spring 2017 analyses
####


###  Read in the Spring 2017 configuration code and combine into a single list.

source("../SGP_CONFIG/2016_2017.2/ELA.R")
source("../SGP_CONFIG/2016_2017.2/ELA_SS.R")
source("../SGP_CONFIG/2016_2017.2/MATHEMATICS.R")
source("../SGP_CONFIG/2016_2017.2/MATHEMATICS_SS.R")

PARCC_2016_2017.2.config <- c(
	ELA.2016_2017.2.config,
	MATHEMATICS.2016_2017.2.config,

	ALGEBRA_I.2016_2017.2.config,
	GEOMETRY.2016_2017.2.config,
	ALGEBRA_II.2016_2017.2.config,

	INTEGRATED_MATH_1.2016_2017.2.config,
	INTEGRATED_MATH_2.2016_2017.2.config,
	INTEGRATED_MATH_3.2016_2017.2.config
)

### abcSGP

PARCC_SGP <- abcSGP(
		sgp_object=PARCC_SGP,
		sgp.config = PARCC_2016_2017.2.config,
		steps=c("prepareSGP", "analyzeSGP", "combineSGP"),
		prepareSGP.create.additional.variables=FALSE,
		sgp.percentiles=TRUE,
		sgp.projections=FALSE,
		sgp.projections.lagged=FALSE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline=FALSE,
		sgp.projections.lagged.baseline=FALSE,
		# calculate.simex= TRUE, #

		sgp.test.cohort.size = 2500,
		# return.sgp.test.results=TRUE,

		save.intermediate.results= FALSE,
    parallel.config=list(
			BACKEND = "FOREACH", TYPE = "doParallel",
			WORKERS = list(TAUS = workers))) # , SIMEX = workers

#
# save(PARCC_SGP, file="./Data/PARCC_SGP.Rdata")
# PARCC_SGP <- combineSGP(
# 					sgp_object=PARCC_SGP


####
####   Now rename/cleanup and then run ABO Consortium
####

ALL_SGP_SLOT <- PARCC_SGP@SGP
save(ALL_SGP_SLOT, file="ALL_SGP_SLOT.rda")
PARCC_SGP@SGP <- NULL

###   INVALIDate student records for the states taking the FLAGSHIP PARCC form
PARCC_SGP@Data[StateAbbreviation %in% c("MD", "DC"), VALID_CASE := "INVALID_CASE"]

###   Rename ORIGINAL 'SGP' variables as 'ALL' 'ABO' and 'FLSHP' (except TARGET and PROJECTION variables)
grep('(?=^((?!TARGET|PROJECTION).)*$)SGP', names(PARCC_SGP@Data), value=TRUE, perl=TRUE)
setnames(PARCC_SGP@Data, grep('(?=^((?!TARGET|PROJECTION).)*$)SGP', names(PARCC_SGP@Data), value=TRUE, perl=TRUE),
			gsub("SGP", "ALL", grep('(?=^((?!TARGET|PROJECTION).)*$)SGP', names(PARCC_SGP@Data), value=TRUE, perl=TRUE)))

###   Run abcSGP - lines 76 - 95 For ABO

####
####   Now rename/cleanup and then run MD/DC Consortium
####

ABO_SGP_SLOT <- PARCC_SGP@SGP
save(ABO_SGP_SLOT, file="ABO_SGP_SLOT.rda")
PARCC_SGP@SGP <- NULL

###   INVALIDate student records for the states taking the ABO form
PARCC_SGP@Data[, VALID_CASE := VC_ORIG]
PARCC_SGP@Data[StateAbbreviation %in% c("IL", "NJ", "NM", "BI"), VALID_CASE := "INVALID_CASE"]
table(PARCC_SGP@Data[, VALID_CASE, VC_ORIG])
table(PARCC_SGP@Data[, VALID_CASE, StateAbbreviation])

###   Rename ORIGINAL 'SGP' variables as 'ALL' 'ABO' and 'FLSHP' (except TARGET and PROJECTION variables)
grep('(?=^((?!TARGET|PROJECTION).)*$)SGP', names(PARCC_SGP@Data), value=TRUE, perl=TRUE)
setnames(PARCC_SGP@Data, grep('(?=^((?!TARGET|PROJECTION).)*$)SGP', names(PARCC_SGP@Data), value=TRUE, perl=TRUE),
			gsub("SGP", "ABO", grep('(?=^((?!TARGET|PROJECTION).)*$)SGP', names(PARCC_SGP@Data), value=TRUE, perl=TRUE)))

###   Run abcSGP - lines 76 - 95 For MD/DC Flagship

####
####   Now Finish
####

###  Ran MD/DC right away So I woul

###   Rename ORIGINAL 'SGP' variables as 'ALL' 'ABO' and 'FLSHP' (except TARGET and PROJECTION variables)
grep('(?=^((?!TARGET|PROJECTION).)*$)SGP', names(PARCC_SGP@Data), value=TRUE, perl=TRUE)
setnames(PARCC_SGP@Data, grep('(?=^((?!TARGET|PROJECTION).)*$)SGP', names(PARCC_SGP@Data), value=TRUE, perl=TRUE),
			gsub("SGP", "FLSHP", grep('(?=^((?!TARGET|PROJECTION).)*$)SGP', names(PARCC_SGP@Data), value=TRUE, perl=TRUE)))

###   Save SGP object
save(PARCC_SGP, file="./Data/PARCC_SGP.Rdata")



####
####    Spring 2018 analyses
####

PARCC_SGP@Data[, VALID_CASE := VC_ORIG]


###   Rename 'ALL' variables as 'SGP' so that they are merged in correctly
grep('(?=^((?!TARGET|PROJECTION).)*$)ALL', names(PARCC_SGP@Data), value=TRUE, perl=TRUE)
setnames(PARCC_SGP@Data, grep('(?=^((?!TARGET|PROJECTION).)*$)ALL', names(PARCC_SGP@Data), value=TRUE, perl=TRUE),
			gsub("ALL", "SGP", grep('(?=^((?!TARGET|PROJECTION).)*$)ALL', names(PARCC_SGP@Data), value=TRUE, perl=TRUE)))

table(PARCC_SGP@Data[,is.na(SGP), YEAR])


###  Read in the Spring 2018 configuration code and combine into a single list.

source("../SGP_CONFIG/2017_2018.2/ELA.R")
source("../SGP_CONFIG/2017_2018.2/ELA_SS.R")
source("../SGP_CONFIG/2017_2018.2/MATHEMATICS.R")
source("../SGP_CONFIG/2017_2018.2/MATHEMATICS_SS.R")

PARCC_2017_2018.2.config <- c(
	ELA.2017_2018.2.config,
	MATHEMATICS.2017_2018.2.config,

	ALGEBRA_I.2017_2018.2.config,
	GEOMETRY.2017_2018.2.config,
	ALGEBRA_II.2017_2018.2.config,

	INTEGRATED_MATH_1.2017_2018.2.config,
	INTEGRATED_MATH_2.2017_2018.2.config,
	INTEGRATED_MATH_3.2017_2018.2.config
)

### abcSGP

PARCC_SGP <- abcSGP(
		sgp_object=PARCC_SGP,
		sgp.config = PARCC_2017_2018.2.config,
		steps=c("prepareSGP", "analyzeSGP", "combineSGP"),
		prepareSGP.create.additional.variables=FALSE,
		sgp.percentiles=TRUE,
		sgp.projections=FALSE,
		sgp.projections.lagged=FALSE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline=FALSE,
		sgp.projections.lagged.baseline=FALSE,

				# sgp.test.cohort.size = 2500,
				# return.sgp.test.results=TRUE,

		save.intermediate.results=FALSE,
    parallel.config=list(
			BACKEND = "FOREACH", TYPE = "doParallel",
			WORKERS = list(TAUS = workers)))

table(PARCC_SGP@Data[,is.na(SGP), StateAbbreviation])

####
####   Now run ABO Consortium
####

ALL_SGP_SLOT2 <- PARCC_SGP@SGP
save(ALL_SGP_SLOT2, file="ALL_SGP_SLOT2.rda")
PARCC_SGP@SGP <- NULL

###   INVALIDate student records for the states taking the FLAGSHIP PARCC form
PARCC_SGP@Data[StateAbbreviation %in% c("MD", "DC"), VALID_CASE := "INVALID_CASE"]

###   Rename 'SGP' variables as 'ALL' 'ABO' and 'FLSHP' (except TARGET and PROJECTION variables)
grep('(?=^((?!TARGET|PROJECTION).)*$)SGP', names(PARCC_SGP@Data), value=TRUE, perl=TRUE)
setnames(PARCC_SGP@Data, grep('(?=^((?!TARGET|PROJECTION).)*$)SGP', names(PARCC_SGP@Data), value=TRUE, perl=TRUE),
			gsub("SGP", "ALL", grep('(?=^((?!TARGET|PROJECTION).)*$)SGP', names(PARCC_SGP@Data), value=TRUE, perl=TRUE)))

###   Rename 'ABO' variables as 'SGP' so that they are merged in correctly
grep('(?=^((?!TARGET|PROJECTION).)*$)ABO', names(PARCC_SGP@Data), value=TRUE, perl=TRUE)
setnames(PARCC_SGP@Data, grep('(?=^((?!TARGET|PROJECTION).)*$)ABO', names(PARCC_SGP@Data), value=TRUE, perl=TRUE),
			gsub("ABO", "SGP", grep('(?=^((?!TARGET|PROJECTION).)*$)ABO', names(PARCC_SGP@Data), value=TRUE, perl=TRUE)))

table(PARCC_SGP@Data[,is.na(SGP), YEAR])

####   Now run lines 192 - 210 For ABO Consortium

####
####   Now run MD/DC Consortium
####

ABO_SGP_SLOT2 <- PARCC_SGP@SGP
save(ABO_SGP_SLOT2, file="ABO_SGP_SLOT2.rda")
PARCC_SGP@SGP <- NULL

###   INVALIDate student records for the states taking the ABO form
PARCC_SGP@Data[, VALID_CASE := VC_ORIG]
PARCC_SGP@Data[StateAbbreviation %in% c("IL", "NJ", "NM", "BI"), VALID_CASE := "INVALID_CASE"]
table(PARCC_SGP@Data[, VALID_CASE, VC_ORIG])
table(PARCC_SGP@Data[, VALID_CASE, StateAbbreviation])

###   Rename 'SGP' variables as 'ALL' 'ABO' and 'FLSHP' (except TARGET and PROJECTION variables)
grep('(?=^((?!TARGET|PROJECTION).)*$)SGP', names(PARCC_SGP@Data), value=TRUE, perl=TRUE)
setnames(PARCC_SGP@Data, grep('(?=^((?!TARGET|PROJECTION).)*$)SGP', names(PARCC_SGP@Data), value=TRUE, perl=TRUE),
			gsub("SGP", "ABO", grep('(?=^((?!TARGET|PROJECTION).)*$)SGP', names(PARCC_SGP@Data), value=TRUE, perl=TRUE)))

###   Rename 'FLSHP' variables as 'SGP' so that they are merged in correctly
grep('(?=^((?!TARGET|PROJECTION).)*$)FLSHP', names(PARCC_SGP@Data), value=TRUE, perl=TRUE)
setnames(PARCC_SGP@Data, grep('(?=^((?!TARGET|PROJECTION).)*$)FLSHP', names(PARCC_SGP@Data), value=TRUE, perl=TRUE),
			gsub("FLSHP", "SGP", grep('(?=^((?!TARGET|PROJECTION).)*$)FLSHP', names(PARCC_SGP@Data), value=TRUE, perl=TRUE)))

###   Run abcSGP - lines 193 - 211 For Flagship


####
####   Now Finish
####

FLSHP_SGP_SLOT <- PARCC_SGP@SGP
save(FLSHP_SGP_SLOT, file="FLSHP_SGP_SLOT.rda")
PARCC_SGP@SGP <- NULL

###   Rename 'SGP' variables as 'ALL' 'ABO' and 'FLSHP' (except TARGET and PROJECTION variables)
grep('(?=^((?!TARGET|PROJECTION).)*$)SGP', names(PARCC_SGP@Data), value=TRUE, perl=TRUE)
setnames(PARCC_SGP@Data, grep('(?=^((?!TARGET|PROJECTION).)*$)SGP', names(PARCC_SGP@Data), value=TRUE, perl=TRUE),
			gsub("SGP", "FLSHP", grep('(?=^((?!TARGET|PROJECTION).)*$)SGP', names(PARCC_SGP@Data), value=TRUE, perl=TRUE)))


###   Output data and save SGP object
outputSGP(PARCC_SGP, output.type="LONG_Data")

###   Save SGP object
save(PARCC_SGP, file="./Data/PARCC_SGP.Rdata")
