#################################################################################
###                                                                           ###
###   SGP analysis script for PARCC Alternative Test Consortiums - May 2019   ###
###                                                                           ###
#################################################################################

### Load Packages
require(SGP)
require(data.table)
later:::ensureInitialized()
options(error=recover)
workers <- 25

###  Load SGP object from Spring 2018 Analyses and Base data from 2015-2016.
load("./Data/Archive/2017_2018.2/PARCC_SGP.Rdata")
load("./Data/Archive/2016_2017.1/PARCC_SGP_LONG_Data.Rdata")
table(PARCC_SGP@Data[, YEAR])
table(PARCC_SGP_LONG_Data[YEAR != "2015_2016.2", YEAR])

PARCC_SGP@Data <- rbindlist(list(PARCC_SGP@Data, PARCC_SGP_LONG_Data[YEAR != "2015_2016.2"]), fill=TRUE)
PARCC_SGP@Data <- PARCC_SGP@Data[grep("_SS", CONTENT_AREA, invert =TRUE),]
PARCC_SGP@Data <- PARCC_SGP@Data[StateAbbreviation %in% c("BI", "DC", "DD", "IL", "MD", "NJ", "NM"), ]

###  These changes should have been made but weren't originally
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
save(PARCC_SGP, file="/media/Data/PARCC_Alt/PARCC_SGP_Alt2.rda")


####
####    Spring 2017 analyses
####


###  Read in the Spring 2017 & 2018 configuration code and combine into a single list.

source("../SGP_CONFIG/2016_2017.2/ELA.R")
source("../SGP_CONFIG/2016_2017.2/MATHEMATICS.R")

source("../SGP_CONFIG/2017_2018.2/ELA.R")
source("../SGP_CONFIG/2017_2018.2/MATHEMATICS.R")

PARCC_Alt_Consortium.config <- c(
	ELA.2017_2018.2.config,
	MATHEMATICS.2017_2018.2.config,

	ALGEBRA_I.2017_2018.2.config,
	GEOMETRY.2017_2018.2.config,
	ALGEBRA_II.2017_2018.2.config,

	ELA.2016_2017.2.config,
	MATHEMATICS.2016_2017.2.config,

	ALGEBRA_I.2016_2017.2.config,
	GEOMETRY.2016_2017.2.config,
	ALGEBRA_II.2016_2017.2.config
)

### abcSGP

# PARCC_SGP@Data[, VALID_CASE := VC_ORIG]

PARCC_SGP <- abcSGP(
		sgp_object=PARCC_SGP,
		sgp.config = PARCC_Alt_Consortium.config,
		steps=c("prepareSGP", "analyzeSGP", "combineSGP"),
		prepareSGP.create.additional.variables=FALSE,
		sgp.percentiles=TRUE,
		sgp.projections=FALSE,
		sgp.projections.lagged=FALSE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline=FALSE,
		sgp.projections.lagged.baseline=FALSE,
		# calculate.simex= TRUE, #
		save.intermediate.results= FALSE,
    parallel.config=list(
			BACKEND = "FOREACH", TYPE = "doParallel",
			WORKERS = list(TAUS = workers))) # , SIMEX = workers

####
####   Now rename/cleanup and then run ABO Consortium
####

ALL_SGP <- PARCC_SGP@SGP
save(ALL_SGP, file="ALL_SGP.rda")
PARCC_SGP@SGP <- NULL

###   INVALIDate student records for the states taking the FLAGSHIP PARCC form
PARCC_SGP@Data[StateAbbreviation %in% c("MD", "DC"), VALID_CASE := "INVALID_CASE"]

###   Rename ORIGINAL 'SGP' variables as 'ALL' 'ABO' and 'FLSHP' (except TARGET and PROJECTION variables)
grep('(?=^((?!TARGET|PROJECTION).)*$)SGP', names(PARCC_SGP@Data), value=TRUE, perl=TRUE)
setnames(PARCC_SGP@Data, grep('(?=^((?!TARGET|PROJECTION).)*$)SGP', names(PARCC_SGP@Data), value=TRUE, perl=TRUE), # more?  "SCALE_SCORE_PRIOR", "SCALE_SCORE_PRIOR_STANDARDIZED",
			gsub("SGP", "ALL", grep('(?=^((?!TARGET|PROJECTION).)*$)SGP', names(PARCC_SGP@Data), value=TRUE, perl=TRUE)))

###   Run abcSGP - lines 80 - 95 For ABO

####
####   Now rename/cleanup and then run MD/DC Consortium
####

ABO_SGP <- PARCC_SGP@SGP
save(ABO_SGP, file="ABO_SGP.rda")
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

###   Run abcSGP - lines 80 - 95 For MD/DC Flagship

FLSHP_SGP <- PARCC_SGP@SGP
save(FLSHP_SGP, file="FLSHP_SGP.rda")
PARCC_SGP@SGP <- NULL

###   Rename ORIGINAL 'SGP' variables as 'ALL' 'ABO' and 'FLSHP' (except TARGET and PROJECTION variables)
grep('(?=^((?!TARGET|PROJECTION).)*$)SGP', names(PARCC_SGP@Data), value=TRUE, perl=TRUE)
setnames(PARCC_SGP@Data, grep('(?=^((?!TARGET|PROJECTION).)*$)SGP', names(PARCC_SGP@Data), value=TRUE, perl=TRUE),
			gsub("SGP", "FLSHP", grep('(?=^((?!TARGET|PROJECTION).)*$)SGP', names(PARCC_SGP@Data), value=TRUE, perl=TRUE)))


####
####   Now Finish
####

###   Merge ABO and FLSHP variables into a single Variable (ALT)

PARCC_SGP@Data[is.na(ABO), ABO := FLSHP]
PARCC_SGP@Data[is.na(FLSHP), FLSHP := ABO]

###   Rename 'ALL' variables as 'SGP' so that they are merged in correctly
grep('(?=^((?!TARGET|PROJECTION).)*$)ALL', names(PARCC_SGP@Data), value=TRUE, perl=TRUE)
setnames(PARCC_SGP@Data, grep('(?=^((?!TARGET|PROJECTION).)*$)ALL', names(PARCC_SGP@Data), value=TRUE, perl=TRUE),
			gsub("ALL", "SGP", grep('(?=^((?!TARGET|PROJECTION).)*$)ALL', names(PARCC_SGP@Data), value=TRUE, perl=TRUE)))

	PARCC_SGP@Data[, ALT := ABO]
	PARCC_SGP@Data[, ALT_ORDER := ABO_ORDER]
	PARCC_SGP@Data[, ALT_NOTE := ABO_NOTE]
	PARCC_SGP@Data[, ALT_NORM_GROUP := as.character(ABO_NORM_GROUP)]
	PARCC_SGP@Data[is.na(ALT), ALT := FLSHP]
	table(PARCC_SGP@Data[is.na(ALT), !is.na(ABO), YEAR])
	table(PARCC_SGP@Data[is.na(ALT), !is.na(FLSHP), YEAR])
	PARCC_SGP@Data[is.na(ALT_ORDER), ALT_ORDER := FLSHP_ORDER]
	PARCC_SGP@Data[is.na(ALT_NOTE), ALT_NOTE := FLSHP_NOTE]
	PARCC_SGP@Data[is.na(ALT_NORM_GROUP), ALT_NORM_GROUP := as.character(FLSHP_NORM_GROUP)]

	PARCC_SGP@Data[, ORIG_NORM_GROUP := as.character(ORIG_NORM_GROUP)]
	PARCC_SGP@Data[, SGP_NORM_GROUP := as.character(SGP_NORM_GROUP)]

###   Output data and save SGP object
outputSGP(PARCC_SGP, output.type="LONG_Data")

###   Save SGP object
save(PARCC_SGP, file="./Data/PARCC_SGP.Rdata")


####
####    Analysis
####

setwd("/media/Data/PARCC_Alt/July_Redo")
require(data.table)
require("xlsx")
load("Data/PARCC_SGP_LONG_Data.Rdata")

table(PARCC_SGP_LONG_Data[StateAbbreviation == "DC" & TestCode == "ELA09", VALID_CASE])
table(PARCC_SGP_LONG_Data[StateAbbreviation == "DC" & TestCode == "ALG01" & GradeLevelWhenAssessed %in% c("09", "10", "11", "12", "99"), VC_ORIG])
table(PARCC_SGP_LONG_Data[StateAbbreviation == "DC" & TestCode == "ALG01" & GradeLevelWhenAssessed %in% c("09", "10", "11", "12", "99"), VALID_CASE])

###   Rename 'SGP' variables as 'ALL'
grep('(?=^((?!TARGET|PROJECTION).)*$)SGP', names(PARCC_SGP_LONG_Data), value=TRUE, perl=TRUE)
setnames(PARCC_SGP_LONG_Data, grep('(?=^((?!TARGET|PROJECTION).)*$)SGP', names(PARCC_SGP_LONG_Data), value=TRUE, perl=TRUE),
			gsub("SGP", "ALL", grep('(?=^((?!TARGET|PROJECTION).)*$)SGP', names(PARCC_SGP_LONG_Data), value=TRUE, perl=TRUE)))

table(PARCC_SGP_LONG_Data[, !is.na(ABO), !is.na(ALL),])
table(PARCC_SGP_LONG_Data[, !is.na(FLSHP), YEAR])
table(PARCC_SGP_LONG_Data[is.na(FLSHP), !is.na(ABO), YEAR])

PARCC_SGP_LONG_Data[, ALT := ABO]
PARCC_SGP_LONG_Data[, ALT_ORDER := ABO_ORDER]
PARCC_SGP_LONG_Data[, ALT_NOTE := ABO_NOTE]
PARCC_SGP_LONG_Data[, ALT_NORM_GROUP := as.character(ABO_NORM_GROUP)]
PARCC_SGP_LONG_Data[is.na(ALT), ALT := FLSHP]
table(PARCC_SGP_LONG_Data[is.na(ALT), !is.na(ABO), YEAR])
table(PARCC_SGP_LONG_Data[is.na(ALT), !is.na(FLSHP), YEAR])
PARCC_SGP_LONG_Data[is.na(ALT_ORDER), ALT_ORDER := FLSHP_ORDER]
PARCC_SGP_LONG_Data[is.na(ALT_NOTE), ALT_NOTE := FLSHP_NOTE]
PARCC_SGP_LONG_Data[is.na(ALT_NORM_GROUP), ALT_NORM_GROUP := as.character(FLSHP_NORM_GROUP)]

PARCC_SGP_LONG_Data[, ORIG_NORM_GROUP := as.character(ORIG_NORM_GROUP)]
PARCC_SGP_LONG_Data[, ALL_NORM_GROUP := as.character(ALL_NORM_GROUP)]

PARCC_SGP_LONG_Data[, VALID_CASE := VC_ORIG]

###   Keep all 4 versions (ORIG, ALL, and ALT (ABO/FLSHP))
PARCC_Alt <- PARCC_SGP_LONG_Data[ YEAR %in% c("2016_2017.2", "2017_2018.2") & (!is.na(ORIG) | !is.na(ALL) | !is.na(ALT)), # & VC_ORIG == "VALID_CASE" & ,
												c(names(PARCC_SGP_LONG_Data)[c(1:17, 19, 20, 32, 52)],
												"ORIG", "ORIG_ORDER", "ORIG_NOTE", "ORIG_NORM_GROUP",
												"ALL", "ALL_ORDER", "ALL_NOTE", "ALL_NORM_GROUP",
												"ALT", "ALT_ORDER", "ALT_NOTE", "ALT_NORM_GROUP"), with=FALSE]

table(PARCC_Alt[, !is.na(ALL), !is.na(ALL)])
table(PARCC_Alt[, !is.na(ALL), VALID_CASE])

PARCC_Alt[, Most_Recent_Prior := as.character(NA)]
PARCC_Alt[, Most_Recent_Prior := sapply(strsplit(as.character(ORIG_NORM_GROUP), "; "), function(x) rev(x)[2])]
PARCC_Alt[, Most_Recent_Prior2 := as.character(NA)]
PARCC_Alt[, Most_Recent_Prior2 := sapply(strsplit(as.character(ALL_NORM_GROUP), "; "), function(x) rev(x)[2])]
PARCC_Alt[, Most_Recent_Prior3 := as.character(NA)]
PARCC_Alt[, Most_Recent_Prior3 := sapply(strsplit(as.character(ALT_NORM_GROUP), "; "), function(x) rev(x)[2])]

###   Add variables, etc used in summary tables
PARCC_Alt[, PRIOR_YEAR := strsplit(Most_Recent_Prior[1], "/")[[1]][1], by="Most_Recent_Prior"]
PARCC_Alt[, PRIOR_GRADE := tail(strsplit(strsplit(Most_Recent_Prior[1], "/")[[1]][2], "_")[[1]], 1), by="Most_Recent_Prior"]
PARCC_Alt[, PRIOR_CONTENT_AREA := paste(head(strsplit(strsplit(Most_Recent_Prior[1], "/")[[1]][2], "_")[[1]], -1), collapse="_"), by="Most_Recent_Prior"]
table(PARCC_Alt[, PRIOR_CONTENT_AREA, PRIOR_YEAR])

table(PARCC_Alt[, Most_Recent_Prior == Most_Recent_Prior3])
table(PARCC_Alt[Most_Recent_Prior != Most_Recent_Prior3, Most_Recent_Prior, Most_Recent_Prior3])

PARCC_Alt <- PARCC_Alt[-which(Most_Recent_Prior != Most_Recent_Prior3),] # Just using Most_Recent_Prior == Most_Recent_Prior3 removes NAs as well
PARCC_Alt[as.numeric(GRADE)-as.numeric(PRIOR_GRADE) == 1, Most_Recent_Prior := NA]
PARCC_Alt[, Most_Recent_Prior2 := NULL]
PARCC_Alt[, Most_Recent_Prior3 := NULL]

PARCC_Alt[YEAR == "2016_2017.2", YEAR := '2017']
PARCC_Alt[YEAR == "2017_2018.2", YEAR := '2018']
# PARCC_Alt <- PARCC_Alt[!PRIOR_YEAR %in% c("2016_2017.1", "2017_2018.1"),]
table(PARCC_Alt[, PRIOR_CONTENT_AREA, PRIOR_YEAR])

save(PARCC_Alt, file="PARCC_Alt.Rdata")

###
###

smry.grd <- PARCC_Alt[!is.na(ALL) & !is.na(ORIG),
	list(Mean_Original=round(mean(ORIG, na.rm=T),2), Median_Original=median(as.numeric(ORIG),na.rm=T),
			 Mean_New= round(mean(ALL, na.rm=T), 2), Median_New= median(as.numeric(ALL), na.rm=T),
			 Mean_Alternative= round(mean(ALT, na.rm=T), 2), Median_Alternative= median(as.numeric(ALT), na.rm=T), N=.N),
	keyby=c("CONTENT_AREA", "GRADE", "Most_Recent_Prior", "YEAR")] # , "PRIOR_YEAR", "PRIOR_CONTENT_AREA", "PRIOR_GRADE"

smry.grd.st <- PARCC_Alt[!is.na(ALL) & !is.na(ORIG),
	list(Mean_Original=round(mean(ORIG, na.rm=T),2), Median_Original=median(as.numeric(ORIG),na.rm=T),
			 Mean_New= round(mean(ALL, na.rm=T), 2), Median_New= median(as.numeric(ALL), na.rm=T),
			 Mean_Alternative= round(mean(ALT, na.rm=T), 2), Median_Alternative= median(as.numeric(ALT), na.rm=T), N=.N),
	keyby=c("StateAbbreviation", "CONTENT_AREA", "GRADE", "Most_Recent_Prior", "YEAR")] # "Most_Recent_Prior",

diff.grd <- PARCC_Alt[!is.na(ALL) & !is.na(ORIG), as.list(round(summary(ORIG-ALL),2)),
	keyby=c("CONTENT_AREA", "GRADE", "Most_Recent_Prior", "YEAR")] # "Most_Recent_Prior",

diff.grd.st <- PARCC_Alt[!is.na(ALL) & !is.na(ORIG), as.list(round(summary(ORIG-ALL),2)),
	keyby=c("StateAbbreviation", "CONTENT_AREA", "GRADE", "Most_Recent_Prior", "YEAR")] # "Most_Recent_Prior",

smry.grd[, GRADE := as.numeric(GRADE)]
diff.grd[, GRADE := as.numeric(GRADE)]
smry.grd.st[, GRADE := as.numeric(GRADE)]
diff.grd.st[, GRADE := as.numeric(GRADE)]

setkey(smry.grd)
setkey(diff.grd)
setkey(smry.grd.st)
setkey(diff.grd.st)
diff.grd.st[StateAbbreviation=="MD" & CONTENT_AREA == "ELA",]

diff.grd[smry.grd][CONTENT_AREA == "ELA" & N > 999,]


smry.grd[, Most_Recent_Prior := sapply(gsub("/", " ", Most_Recent_Prior), SGP::capwords)]
smry.grd[, Most_Recent_Prior := gsub("2015 2016 2", "2016", Most_Recent_Prior)]
smry.grd[, Most_Recent_Prior := gsub("2016 2017 2", "2017", Most_Recent_Prior)]
smry.grd[, Most_Recent_Prior := gsub("2016 2017 1", "Fall 2016", Most_Recent_Prior)]
smry.grd[, Most_Recent_Prior := gsub("2017 2018 1", "Fall 2017", Most_Recent_Prior)]
smry.grd[, Most_Recent_Prior := gsub("Mathematics", "Math", Most_Recent_Prior)]
smry.grd[, Most_Recent_Prior := gsub(" Eoct", "", Most_Recent_Prior)]
smry.grd[, Most_Recent_Prior := gsub(" 8", " Grade 8", Most_Recent_Prior)]
smry.grd[, Most_Recent_Prior := gsub(" 7", " Grade 7", Most_Recent_Prior)]
smry.grd[, Most_Recent_Prior := gsub(" 6", " Grade 6", Most_Recent_Prior)]

smry.grd.st[, Most_Recent_Prior := sapply(gsub("/", " ", Most_Recent_Prior), SGP::capwords)]
smry.grd.st[, Most_Recent_Prior := gsub("2015 2016 2", "2016", Most_Recent_Prior)]
smry.grd.st[, Most_Recent_Prior := gsub("2016 2017 2", "2017", Most_Recent_Prior)]
smry.grd.st[, Most_Recent_Prior := gsub("2016 2017 1", "Fall 2016", Most_Recent_Prior)]
smry.grd.st[, Most_Recent_Prior := gsub("2017 2018 1", "Fall 2017", Most_Recent_Prior)]
smry.grd.st[, Most_Recent_Prior := gsub("Mathematics", "Math", Most_Recent_Prior)]
smry.grd.st[, Most_Recent_Prior := gsub(" Eoct", "", Most_Recent_Prior)]
smry.grd.st[, Most_Recent_Prior := gsub(" 8", " Grade 8", Most_Recent_Prior)]
smry.grd.st[, Most_Recent_Prior := gsub(" 7", " Grade 7", Most_Recent_Prior)]
smry.grd.st[, Most_Recent_Prior := gsub(" 6", " Grade 6", Most_Recent_Prior)]

smry.grd.st[StateAbbreviation=="MD" & CONTENT_AREA == "ELA" & N > 999,]

state.ela <- smry.grd.st[CONTENT_AREA == "ELA",]
parcc.ela <- smry.grd[CONTENT_AREA == "ELA",]
state.math <- smry.grd.st[CONTENT_AREA == "MATHEMATICS",]
parcc.math <- smry.grd[CONTENT_AREA == "MATHEMATICS",]
state.eoct <- smry.grd.st[!CONTENT_AREA %in% c("ELA", "MATHEMATICS"),]
parcc.eoct <- smry.grd[!CONTENT_AREA %in% c("ELA", "MATHEMATICS"),]

write.xlsx(parcc.ela, file="PARCC_Alternative_Consortium_Summaries.xlsx", sheetName="ELA_by_PARCC", append=TRUE, showNA=FALSE)
write.xlsx(state.ela, file="PARCC_Alternative_Consortium_Summaries.xlsx", sheetName="ELA_by_State", append=TRUE, showNA=FALSE)
write.xlsx(parcc.math, file="PARCC_Alternative_Consortium_Summaries.xlsx", sheetName="Math_by_PARCC", append=TRUE, showNA=FALSE)
write.xlsx(state.math, file="PARCC_Alternative_Consortium_Summaries.xlsx", sheetName="Math_by_State", append=TRUE, showNA=FALSE)
write.xlsx(parcc.eoct, file="PARCC_Alternative_Consortium_Summaries.xlsx", sheetName="EOCT_by_PARCC", append=TRUE, showNA=FALSE)
write.xlsx(state.eoct, file="PARCC_Alternative_Consortium_Summaries.xlsx", sheetName="EOCT_by_State", append=TRUE, showNA=FALSE)

# setnames(smry.grd, c("CONTENT_AREA", "GRADE", "YEAR"), c("CURNT_CONTENT_AREA", "CURNT_GRADE", "CURNT_YEAR"))

smry.grd.st[, State := factor(StateAbbreviation)]

set.seed(719)
levels(smry.grd.st$State) <- sample(LETTERS[1:6])

#####
#####   PARCC Alt Consortium Plotting Data
#####

require(ggplot2)

PARCC_Plot <- PARCC_SGP_LONG_Data[YEAR %in% c("2015_2016.2", "2016_2017.2", "2017_2018.2") & !grepl("INTEGRATED", CONTENT_AREA) & !grepl("3", GRADE) & VALID_CASE == "VALID_CASE",
												c(names(PARCC_SGP_LONG_Data)[c(1:6, 13, 8, 11, 16:17)], "ORIG", "ALL", "ALT"), with=FALSE]

save(PARCC_Plot, file="Data/PARCC_Plot.rda")


# state <- "DC"
# content.area <- "MATHEMATICS"
# grade <- "10"

my.colors <- c("#CC0000", "#FF3333", "#0000CC", "#6666FF", "#009966", "#00FF00") # "darkred", "lightred", "darkblue", "blue", "darkgreen", "lightgreen"
my.colors2 <- c("#990000", "#CC0000", "#FF3333", "#000099", "#0000FF", "#6666FF")

for (state in c("BI", "DC", "IL", "MD", "NJ", "NM")) { # No DD
	state.name <- gsub("_", " ", SGP::getStateAbbreviation(state, type="State"))

	for (content.area in c("ELA", "MATHEMATICS", "ALGEBRA_I", "ALGEBRA_II", "GEOMETRY")) {
	for (grade in c(4, 5, 6, 7, 8, 9, 10, 11, "EOCT")) {
		tmp.data.parcc <- PARCC_Plot[CONTENT_AREA == content.area & GRADE == grade, list(SCALE_SCORE, YEAR, ORIG, ALL, ALT)]
		tmp.data.state <- PARCC_Plot[CONTENT_AREA == content.area & GRADE == grade & StateAbbreviation == state, list(SCALE_SCORE, YEAR, ORIG, ALL, ALT)]
		if (content.area=="MATHEMATICS") ca.name <- "Math" else ca.name <- content.area

		if (nrow(tmp.data.state[YEAR %in% c("2016_2017.2", "2017_2018.2") & !is.na(ORIG),]) > 100) {
		###   Scale Scores by State/Content Area/Grade
		p <- ggplot() +
			scale_colour_manual(values = my.colors) +
			ggtitle(paste(state.name, "and PARCC IRT Theta:", ifelse(grade=="EOCT", "", paste("Grade", grade)), ca.name)) +
			theme(plot.title = element_text(size=14, face="bold.italic"))
		p <- p + geom_density(data = tmp.data.parcc[YEAR == "2015_2016.2" & abs(SCALE_SCORE) < 4], aes(SCALE_SCORE, colour= "'16 PARCC"))
		p <- p + geom_density(data = tmp.data.state[YEAR == "2015_2016.2" & abs(SCALE_SCORE) < 4], aes(SCALE_SCORE, colour= "'16 State"), linetype="dotted")
		p <- p + geom_density(data = tmp.data.parcc[YEAR == "2016_2017.2" & abs(SCALE_SCORE) < 4], aes(SCALE_SCORE, colour= "'17 PARCC"))
		p <- p + geom_density(data = tmp.data.state[YEAR == "2016_2017.2" & abs(SCALE_SCORE) < 4], aes(SCALE_SCORE, colour= "'17 State"), linetype="dotted")
		p <- p + geom_density(data = tmp.data.parcc[YEAR == "2017_2018.2" & abs(SCALE_SCORE) < 4], aes(SCALE_SCORE, colour= "'18 PARCC"))
		p <- p + geom_density(data = tmp.data.state[YEAR == "2017_2018.2" & abs(SCALE_SCORE) < 4], aes(SCALE_SCORE, colour= "'18 State"), linetype="dotted")
		p <- p + geom_vline(xintercept = mean(tmp.data.parcc[YEAR == "2015_2016.2", SCALE_SCORE], na.rm=T), color = my.colors[1])
		p <- p + geom_vline(xintercept = mean(tmp.data.state[YEAR == "2015_2016.2", SCALE_SCORE], na.rm=T), linetype="dotted", color = my.colors[2])
		p <- p + geom_vline(xintercept = mean(tmp.data.parcc[YEAR == "2016_2017.2", SCALE_SCORE], na.rm=T), color = my.colors[3])
		p <- p + geom_vline(xintercept = mean(tmp.data.state[YEAR == "2016_2017.2", SCALE_SCORE], na.rm=T), linetype="dotted", color = my.colors[4])
		p <- p + geom_vline(xintercept = mean(tmp.data.parcc[YEAR == "2017_2018.2", SCALE_SCORE], na.rm=T), color = my.colors[5])
		p <- p + geom_vline(xintercept = mean(tmp.data.state[YEAR == "2017_2018.2", SCALE_SCORE], na.rm=T), linetype="dotted", color = my.colors[6])
		p <- p + guides(colour = guide_legend(override.aes = list(linetype=rep(c("solid", "dotted"),3)), title = "Population"))
		p <- p + scale_x_continuous(name="IRT Theta Distribution and Mean (Vertical Line)")

		ggsave(filename = paste("./Plots/", state, ifelse(grade=="EOCT", "_", paste0("_Grade_", grade, "_")), ca.name, "_SS.pdf", sep=""), plot=p, device = "pdf", width = 6, height = 4, units = "in")
		}
		###   SGP Versions by State/Content Area/Grade
		if (nrow(tmp.data.state[YEAR %in% c("2016_2017.2", "2017_2018.2") & !is.na(ORIG),]) > 100){
		# tmp.tbl <- table(tmp.data.state[YEAR %in% c("2016_2017.2", "2017_2018.2"), YEAR, !is.na(ORIG)])
		# if (any(tmp.tbl[2,]==0)) message(paste(state.name, "and PARCC SGPs:", ifelse(grade=="EOCT", "", paste("Grade", grade)), ca.name, "NOT PRESENT"))
		if ((!grade %in% c(9, 10) & state %in% c("DC")) | !grade %in% c(11) & state %in% c("IL")) {
		c.17 <- paste("'17", ifelse(state %in%c("MD", "DC"), "Flagship", "ABO"))
		c.18 <- paste("'18", ifelse(state %in%c("MD", "DC"), "Flagship", "ABO"))

		p <- ggplot()+
			ggtitle(paste(state.name, "and PARCC SGPs:", ifelse(grade=="EOCT", "", paste("Grade", grade)), ca.name)) +
			theme(plot.title = element_text(size=14, face="bold.italic")) +
			scale_colour_manual(values = my.colors2) #, labels=c("'17 Partial", "'17 Reduced", "'17 Original", "'18 Partial", "'18 Original")) [c(1, 3, 5, 2, 4, 6)]
		p <- p + geom_density(data = tmp.data.state[YEAR == "2016_2017.2"], aes(ALT, colour= c.17), linetype="dotted")
		p <- p + geom_density(data = tmp.data.state[YEAR == "2016_2017.2"], aes(ALL, colour= "'17 Reduced"), linetype="dashed")
		p <- p + geom_density(data = tmp.data.state[YEAR == "2016_2017.2"], aes(ORIG, colour= "'17 Unchanged"))
		p <- p + geom_density(data = tmp.data.state[YEAR == "2017_2018.2"], aes(ALT, colour= c.18), linetype="dotted")
		p <- p + geom_density(data = tmp.data.state[YEAR == "2017_2018.2"], aes(ALL, colour= "'18 Reduced"), linetype="dashed")
		p <- p + geom_density(data = tmp.data.state[YEAR == "2017_2018.2"], aes(ORIG, colour= "'18 Unchanged"))
		p <- p + scale_x_continuous(name="SGP Distribution and Median (Vertical Line)")
		p <- p + geom_vline(xintercept = median(tmp.data.state[YEAR == "2017_2018.2", ALT], na.rm=T), linetype="dotted", size=1.1, color = my.colors2[4])
		p <- p + geom_vline(xintercept = median(tmp.data.state[YEAR == "2017_2018.2", ALL], na.rm=T), linetype="dashed", size=1.1, color = my.colors2[5])
		p <- p + geom_vline(xintercept = median(tmp.data.state[YEAR == "2017_2018.2", ORIG], na.rm=T), color = my.colors2[6])
		p <- p + geom_vline(xintercept = median(tmp.data.state[YEAR == "2016_2017.2", ALT], na.rm=T), linetype="dotted", size=1.1, color = my.colors2[1])
		p <- p + geom_vline(xintercept = median(tmp.data.state[YEAR == "2016_2017.2", ALL], na.rm=T), linetype="dashed", size=1.1, color = my.colors2[2])
		p <- p + geom_vline(xintercept = median(tmp.data.state[YEAR == "2016_2017.2", ORIG], na.rm=T), color = my.colors2[3])
		p <- p + guides(colour = guide_legend(override.aes = list(linetype=c(rep(c("dotted", "dashed", "solid"), 2))), title = "SGP Versions"))
		ggsave(filename = paste("./Plots/", state, ifelse(grade=="EOCT", "_", paste0("_Grade_", grade, "_")), ca.name, "_SGP.pdf", sep=""), plot=p, device = "pdf", width = 6, height = 4, units = "in")
	}} else message(paste(state.name, "and PARCC SGPs:", ifelse(grade=="EOCT", "", paste("Grade", grade)), ca.name, "NOT PRESENT"))
	}} # grade / content.area
} # state
