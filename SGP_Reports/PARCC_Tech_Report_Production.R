
############################################################################
####
#         2016
####
############################################################################

### Load required packages

require(SGP)
require(data.table)

setwd("~/Dropbox (SGP)/SGP/PARCC")

###
###    Read in Fall and Spring 2016 Output Files
###

load("./PARCC/Data/PARCC_SGP_LONG_Data_2015_2016.2.Rdata")

load("./Colorado/Data/Colorado_SGP_LONG_Data_2015_2016.2.Rdata")
load("./Illinois/Data/Illinois_SGP_LONG_Data_2015_2016.2.Rdata")
load("./Maryland/Data/Maryland_SGP_LONG_Data_2015_2016.2.Rdata")
load("./Massachusetts/Data/Massachusetts_SGP_LONG_Data_2015_2016.2.Rdata")
load("./New_Jersey/Data/New_Jersey_SGP_LONG_Data_2015_2016.2.Rdata")
load("./New_Mexico/Data/New_Mexico_SGP_LONG_Data_2015_2016.2.Rdata")
load("./Rhode_Island/Data/Rhode_Island_SGP_LONG_Data_2015_2016.2.Rdata")
load("./Washington_DC/Data/WASHINGTON_DC_SGP_LONG_Data_2015_2016.2.Rdata")

setwd("/Users/avi/Dropbox (SGP)/Github_Repos/Documentation/PARCC/SGP_Reports")

####  Subset PARCC Data

PARCC_LONG_Data <- PARCC_SGP_LONG_Data_2015_2016.2[grep("_SS", CONTENT_AREA, invert =TRUE), 
				c("VALID_CASE", "CONTENT_AREA", "GRADE", "YEAR", "ID", "SGP", "SGP_SIMEX", "ACHIEVEMENT_LEVEL", "ACHIEVEMENT_LEVEL_PRIOR",
					"SGP_NORM_GROUP","SCALE_SCORE", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_PRIOR", "SCALE_SCORE_PRIOR_STANDARDIZED", "StateAbbreviation")]

####  Subset State Data

State_LONG_Data <- rbindlist(list(
	Colorado_SGP_LONG_Data_2015_2016.2, Illinois_SGP_LONG_Data_2015_2016.2, Maryland_SGP_LONG_Data_2015_2016.2,
	Massachusetts_SGP_LONG_Data_2015_2016.2, New_Jersey_SGP_LONG_Data_2015_2016.2, New_Mexico_SGP_LONG_Data_2015_2016.2,
	Rhode_Island_SGP_LONG_Data_2015_2016.2, WASHINGTON_DC_SGP_LONG_Data_2015_2016.2), fill=TRUE)[grep("_SS", CONTENT_AREA, invert =TRUE),
				c("VALID_CASE", "CONTENT_AREA", "GRADE", "YEAR", "ID", "SGP", "SGP_SIMEX", "ACHIEVEMENT_LEVEL", "ACHIEVEMENT_LEVEL_PRIOR",
					"SGP_NORM_GROUP","SCALE_SCORE", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_PRIOR", "SCALE_SCORE_PRIOR_STANDARDIZED")]

# rm(list=ls()[c(-7,-10)]);gc()


state.vars <- c("SCALE_SCORE_PRIOR", "SCALE_SCORE_PRIOR_STANDARDIZED", "SGP", "SGP_SIMEX", "SGP_NORM_GROUP")
setnames(State_LONG_Data, state.vars, paste(state.vars, "_STATE", sep=""))
setkey(State_LONG_Data, VALID_CASE, CONTENT_AREA, YEAR, ID)
setkey(PARCC_LONG_Data, VALID_CASE, CONTENT_AREA, YEAR, ID)

###       Merge PARCC and State Data
PARCC_LONG_Data <- merge(PARCC_LONG_Data, State_LONG_Data, by=intersect(names(PARCC_LONG_Data), names(State_LONG_Data)), all.x=TRUE)

rm(State_LONG_Data); gc()

PARCC_LONG_Data[, Most_Recent_Prior := as.character(NA)]
PARCC_LONG_Data[, Most_Recent_Prior := sapply(strsplit(as.character(SGP_NORM_GROUP), "; "), function(x) rev(x)[2])]
PARCC_LONG_Data[, Most_Recent_Prior_State := as.character(NA)]
PARCC_LONG_Data[, Most_Recent_Prior_State := sapply(strsplit(as.character(SGP_NORM_GROUP_STATE), "; "), function(x) rev(x)[2])]

###   Add variables, etc used in State summary tables

PARCC_LONG_Data[ACHIEVEMENT_LEVEL %in% c("Level 1", "Level 2", "Level 3"), PROFICIENT:=0L]
PARCC_LONG_Data[ACHIEVEMENT_LEVEL %in% c("Level 4", "Level 5"), PROFICIENT:=1L]
PARCC_LONG_Data[, SCALE_SCORE_CURRENT_STANDARDIZED:=scale(SCALE_SCORE), keyby=list(CONTENT_AREA, YEAR, GRADE)]
PARCC_LONG_Data[, PRIOR_YEAR := strsplit(Most_Recent_Prior[1], "/")[[1]][1], by="Most_Recent_Prior"]
PARCC_LONG_Data[, PRIOR_GRADE := tail(strsplit(strsplit(Most_Recent_Prior[1], "/")[[1]][2], "_")[[1]], 1), by="Most_Recent_Prior"]
PARCC_LONG_Data[, PRIOR_CONTENT_AREA := paste(head(strsplit(strsplit(Most_Recent_Prior[1], "/")[[1]][2], "_")[[1]], -1), collapse="_"), by="Most_Recent_Prior"]

scaling.constants <- as.data.table(read.csv("PARCC/Data/Base_Files/2014-2015 PARCC Scaling Constants.csv"))
PARCC_LONG_Data[, SCALE_SCORE_PRIOR_ACTUAL := round((SCALE_SCORE_PRIOR*scaling.constants[CONTENT_AREA==PRIOR_CONTENT_AREA[1] & GRADE==PRIOR_GRADE[1]][["a"]]+scaling.constants[CONTENT_AREA==PRIOR_CONTENT_AREA[1] & GRADE==PRIOR_GRADE[1]][["b"]]), 0), by=c("PRIOR_CONTENT_AREA", "PRIOR_GRADE")]
cor(PARCC_LONG_Data$SCALE_SCORE_PRIOR_ACTUAL, PARCC_LONG_Data$SCALE_SCORE_PRIOR, use="complete")
PARCC_LONG_Data[which(SCALE_SCORE_PRIOR_ACTUAL < 650), SCALE_SCORE_PRIOR_ACTUAL := 650]
PARCC_LONG_Data[which(SCALE_SCORE_PRIOR_ACTUAL > 850), SCALE_SCORE_PRIOR_ACTUAL := 850]

# # These were causing problems with calculation of PRIOR_ACHIEVEMENT_PERCENTILE below
PARCC_LONG_Data[, PR_YEAR := PRIOR_YEAR] # Next time just use setnames(...)
PARCC_LONG_Data[, PR_GRADE := PRIOR_GRADE]
PARCC_LONG_Data[, PR_CONTENT_AREA := PRIOR_CONTENT_AREA]
PARCC_LONG_Data[, PRIOR_YEAR := NULL]
PARCC_LONG_Data[, PRIOR_GRADE := NULL]
PARCC_LONG_Data[, PRIOR_CONTENT_AREA := NULL]


PARCC_SGP <- prepareSGP(PARCC_LONG_Data, create.additional.variables = FALSE)

save(PARCC_SGP, file="../Data/PARCC_SGP-Tech_Reports.Rdata")

setwd("/Users/avi/Dropbox (SGP)/Github_Repos/Documentation/PARCC/SGP_Reports/PARCC/2016")

library(SGPreports)
use.data.table()

#####
#####			PARCC Consortium
#####

load("../../../Data/PARCC_SGP-Tech_Reports.Rdata")

renderMultiDocument(rmd_input = "PARCC_SGP_Report_2016.Rmd",
										output_format = c("HTML", "PDF"), # 
										cover_img="../img/cover.jpg",
										add_cover_title=TRUE, 
										# cleanup_aux_files = FALSE,
										pandoc_args = "--webtex")

renderMultiDocument(rmd_input = "Appendix_A_2016.Rmd",
										# output_format = c("HTML"),
										output_format = c("HTML", "PDF"), #, "EPUB", "DOCX"
										cover_img="../img/cover.jpg",
										# cleanup_aux_files = FALSE,
										add_cover_title=TRUE)

renderMultiDocument(rmd_input = "Appendix_C_2016.Rmd",
										# output_format = c("HTML"),
										output_format = c("HTML", "PDF"), #, "EPUB", "DOCX"
										cover_img="../img/cover.jpg",
										add_cover_title=TRUE)


############################################################################
####
#         2017
####
############################################################################

### Load required packages

require(SGP)
require(data.table)

setwd("~/Dropbox (SGP)/SGP/PARCC")

###
###    Read in Fall and Spring 2017 Output Files
###

load("./PARCC/Data/Archive/2016_2017.2/PARCC_SGP_LONG_Data_2016_2017.2.Rdata")

load("./Colorado/Data/Archive/2016_2017.2/Colorado_SGP_LONG_Data_2016_2017.2.Rdata")
load("./Illinois/Data/Archive/2016_2017.2/Illinois_SGP_LONG_Data_2016_2017.2.Rdata")
load("./Maryland/Data/Archive/2016_2017.2/Maryland_SGP_LONG_Data_2016_2017.2.Rdata")
load("./New_Jersey/Data/Archive/2016_2017.2/New_Jersey_SGP_LONG_Data_2016_2017.2.Rdata")
load("./New_Mexico/Data/Archive/2016_2017.2/New_Mexico_SGP_LONG_Data_2016_2017.2.Rdata")
load("./Rhode_Island/Data/Archive/2016_2017.2/Rhode_Island_SGP_LONG_Data_2016_2017.2.Rdata")
load("./Washington_DC/Data/Archive/2016_2017.2/WASHINGTON_DC_SGP_LONG_Data_2016_2017.2.Rdata")

setwd("/Users/avi/Dropbox (SGP)/Github_Repos/Documentation/PARCC/SGP_Reports")

####  Subset PARCC Data

PARCC_LONG_Data <- PARCC_SGP_LONG_Data_2016_2017.2[grep("_SS", CONTENT_AREA, invert =TRUE), 
																									 c("VALID_CASE", "CONTENT_AREA", "GRADE", "YEAR", "ID", "SGP", "SGP_SIMEX_RANKED", "ACHIEVEMENT_LEVEL", "ACHIEVEMENT_LEVEL_PRIOR",
																									 	"SGP_NORM_GROUP","SCALE_SCORE", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_PRIOR", "SCALE_SCORE_PRIOR_STANDARDIZED", "StateAbbreviation")]

####  Subset State Data

State_LONG_Data <- rbindlist(list(
	Colorado_SGP_LONG_Data_2016_2017.2, Illinois_SGP_LONG_Data_2016_2017.2, Maryland_SGP_LONG_Data_2016_2017.2,
	New_Jersey_SGP_LONG_Data_2016_2017.2, New_Mexico_SGP_LONG_Data_2016_2017.2,
	Rhode_Island_SGP_LONG_Data_2016_2017.2, Washington_DC_SGP_LONG_Data_2016_2017.2), fill=TRUE)[grep("_SS", CONTENT_AREA, invert =TRUE),
																																															 c("VALID_CASE", "CONTENT_AREA", "GRADE", "YEAR", "ID", "SGP", "SGP_SIMEX_RANKED", "ACHIEVEMENT_LEVEL", "ACHIEVEMENT_LEVEL_PRIOR",
																																															 	"SGP_NORM_GROUP","SCALE_SCORE", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_PRIOR", "SCALE_SCORE_PRIOR_STANDARDIZED")]

# rm(list=ls()[c(-7,-10)]);gc()


state.vars <- c("SCALE_SCORE_PRIOR", "SCALE_SCORE_PRIOR_STANDARDIZED", "SGP", "SGP_SIMEX_RANKED", "SGP_NORM_GROUP")
setnames(State_LONG_Data, state.vars, paste(state.vars, "_STATE", sep=""))
setkey(State_LONG_Data, VALID_CASE, CONTENT_AREA, YEAR, ID)
setkey(PARCC_LONG_Data, VALID_CASE, CONTENT_AREA, YEAR, ID)

###       Merge PARCC and State Data
PARCC_LONG_Data <- merge(PARCC_LONG_Data, State_LONG_Data, by=intersect(names(PARCC_LONG_Data), names(State_LONG_Data)), all.x=TRUE)

rm(State_LONG_Data); gc()

PARCC_LONG_Data[, Most_Recent_Prior := as.character(NA)]
PARCC_LONG_Data[, Most_Recent_Prior := sapply(strsplit(as.character(SGP_NORM_GROUP), "; "), function(x) rev(x)[2])]
PARCC_LONG_Data[, Most_Recent_Prior_State := as.character(NA)]
PARCC_LONG_Data[, Most_Recent_Prior_State := sapply(strsplit(as.character(SGP_NORM_GROUP_STATE), "; "), function(x) rev(x)[2])]

###   Add variables, etc used in State summary tables

PARCC_LONG_Data[ACHIEVEMENT_LEVEL %in% c("Level 1", "Level 2", "Level 3"), PROFICIENT:=0L]
PARCC_LONG_Data[ACHIEVEMENT_LEVEL %in% c("Level 4", "Level 5"), PROFICIENT:=1L]
PARCC_LONG_Data[, SCALE_SCORE_CURRENT_STANDARDIZED:=scale(SCALE_SCORE), keyby=list(CONTENT_AREA, YEAR, GRADE)]
PARCC_LONG_Data[, PRIOR_YEAR := strsplit(Most_Recent_Prior[1], "/")[[1]][1], by="Most_Recent_Prior"]
PARCC_LONG_Data[, PRIOR_GRADE := tail(strsplit(strsplit(Most_Recent_Prior[1], "/")[[1]][2], "_")[[1]], 1), by="Most_Recent_Prior"]
PARCC_LONG_Data[, PRIOR_CONTENT_AREA := paste(head(strsplit(strsplit(Most_Recent_Prior[1], "/")[[1]][2], "_")[[1]], -1), collapse="_"), by="Most_Recent_Prior"]

scaling.constants <- as.data.table(read.csv("PARCC/Data/Base_Files/2015-2016 PARCC Scaling Constants.csv"))
PARCC_LONG_Data[, SCALE_SCORE_PRIOR_ACTUAL := round((SCALE_SCORE_PRIOR*scaling.constants[CONTENT_AREA==PRIOR_CONTENT_AREA[1] & GRADE==PRIOR_GRADE[1]][["a"]]+scaling.constants[CONTENT_AREA==PRIOR_CONTENT_AREA[1] & GRADE==PRIOR_GRADE[1]][["b"]]), 0), by=c("PRIOR_CONTENT_AREA", "PRIOR_GRADE")]
cor(PARCC_LONG_Data$SCALE_SCORE_PRIOR_ACTUAL, PARCC_LONG_Data$SCALE_SCORE_PRIOR, use="complete")
PARCC_LONG_Data[which(SCALE_SCORE_PRIOR_ACTUAL < 650), SCALE_SCORE_PRIOR_ACTUAL := 650]
PARCC_LONG_Data[which(SCALE_SCORE_PRIOR_ACTUAL > 850), SCALE_SCORE_PRIOR_ACTUAL := 850]

# # These were causing problems with calculation of PRIOR_ACHIEVEMENT_PERCENTILE below
PARCC_LONG_Data[, PR_YEAR := PRIOR_YEAR] # Next time just use setnames(...)
PARCC_LONG_Data[, PR_GRADE := PRIOR_GRADE]
PARCC_LONG_Data[, PR_CONTENT_AREA := PRIOR_CONTENT_AREA]
PARCC_LONG_Data[, PRIOR_YEAR := NULL]
PARCC_LONG_Data[, PRIOR_GRADE := NULL]
PARCC_LONG_Data[, PRIOR_CONTENT_AREA := NULL]


PARCC_SGP <- prepareSGP(PARCC_LONG_Data, create.additional.variables = FALSE)

save(PARCC_SGP, file="../Data/PARCC_SGP-Tech_Reports_2017.2.Rdata")

setwd("/Users/avi/Dropbox (SGP)/Github_Repos/Documentation/PARCC/SGP_Reports/PARCC/2017")

library(Literasee)

#####
#####			PARCC Consortium
#####

load("../../../Data/PARCC_SGP-Tech_Reports_2017.2.Rdata")

renderMultiDocument(rmd_input = "PARCC_SGP_Report_2017.Rmd",
										output_format = c("HTML", "PDF"), # 
										cover_img="../img/cover.jpg",
										add_cover_title=TRUE, 
										# cleanup_aux_files = FALSE,
										pandoc_args = "--webtex")

renderMultiDocument(rmd_input = "Appendix_A_2017.Rmd",
										# output_format = c("HTML"),
										output_format = c("HTML", "PDF"), #, "EPUB", "DOCX"
										cover_img="../img/cover.jpg",
										# cleanup_aux_files = FALSE,
										add_cover_title=TRUE)

renderMultiDocument(rmd_input = "Appendix_C_2017.Rmd",
										# output_format = c("HTML"),
										output_format = c("HTML", "PDF"), #, "EPUB", "DOCX"
										cover_img="../img/cover.jpg",
										add_cover_title=TRUE)



############################################################################
####
#         Fall 2017
####
############################################################################

### Load required packages

require(SGP)
require(data.table)
require(Literasee)

setwd("/Users/avi/Dropbox (SGP)/Github_Repos/Documentation/PARCC/SGP_Reports/PARCC/2018")


###
##    Fall 2017 reports
###


renderMultiDocument(rmd_input = "Appendix_C_Fall_2017.Rmd",
										# output_format = c("HTML"),
										output_format = c("HTML", "PDF"), #, "EPUB", "DOCX"
										cover_img="../img/cover.jpg",
										add_cover_title=TRUE)



############################################################################
####
#         Spring 2018
####
############################################################################

### Load required packages

require(SGP)
require(data.table)

setwd("~/Dropbox (SGP)/SGP/PARCC")

###
###    Read in Spring 2018 Output Files
###

load("./PARCC/Data/Archive/2017_2018.2/PARCC_SGP_LONG_Data_2017_2018.2.Rdata")

load("./Illinois/Data/Archive/2017_2018.2/Illinois_SGP_LONG_Data_2017_2018.2.Rdata")
load("./Maryland/Data/Archive/2017_2018.2/Maryland_SGP_LONG_Data_2017_2018.2.Rdata")
load("./New_Jersey/Data/Archive/2017_2018.2/New_Jersey_SGP_LONG_Data_2017_2018.2.Rdata")
load("./New_Mexico/Data/Archive/2017_2018.2/New_Mexico_SGP_LONG_Data_2017_2018.2.Rdata")
load("./Washington_DC/Data/Archive/2017_2018.2/WASHINGTON_DC_SGP_LONG_Data_2017_2018.2.Rdata")
load("./Bureau_Indian_Affairs/Data/Archive/2017_2018.2/Bureau_Indian_Affairs_SGP_LONG_Data_2017_2018.2.Rdata")


####  Subset PARCC Data

PARCC_LONG_Data <- PARCC_SGP_LONG_Data_2017_2018.2[grep("_SS", CONTENT_AREA, invert =TRUE), 
					c("VALID_CASE", "CONTENT_AREA", "GRADE", "YEAR", "ID", "SGP", "SGP_SIMEX_RANKED", "ACHIEVEMENT_LEVEL", "ACHIEVEMENT_LEVEL_PRIOR",
						"SGP_NORM_GROUP","SCALE_SCORE", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_PRIOR", "SCALE_SCORE_PRIOR_STANDARDIZED", "StateAbbreviation",
						"SGP_TARGET_3_YEAR", "SGP_TARGET_3_YEAR_CURRENT", "CATCH_UP_KEEP_UP_STATUS_3_YEAR", "MOVE_UP_STAY_UP_STATUS_3_YEAR")]

####  Subset State Data

State_LONG_Data <- rbindlist(list(Bureau_Indian_Affairs_SGP_LONG_Data_2017_2018.2,
	Illinois_SGP_LONG_Data_2017_2018.2, Maryland_SGP_LONG_Data_2017_2018.2,
	New_Jersey_SGP_LONG_Data_2017_2018.2, New_Mexico_SGP_LONG_Data_2017_2018.2,
	Washington_DC_SGP_LONG_Data_2017_2018.2), fill=TRUE)[grep("_SS", CONTENT_AREA, invert =TRUE),
						c("VALID_CASE", "CONTENT_AREA", "GRADE", "YEAR", "ID", "SGP", "SGP_SIMEX_RANKED", "ACHIEVEMENT_LEVEL", "ACHIEVEMENT_LEVEL_PRIOR",
							"SGP_NORM_GROUP","SCALE_SCORE", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_PRIOR", "SCALE_SCORE_PRIOR_STANDARDIZED",
							"SGP_TARGET_3_YEAR", "SGP_TARGET_3_YEAR_CURRENT", "CATCH_UP_KEEP_UP_STATUS_3_YEAR", "MOVE_UP_STAY_UP_STATUS_3_YEAR")]


state.vars <- c("SCALE_SCORE_PRIOR", "SCALE_SCORE_PRIOR_STANDARDIZED", "SGP", "SGP_SIMEX_RANKED", "SGP_NORM_GROUP",
								"SGP_TARGET_3_YEAR", "SGP_TARGET_3_YEAR_CURRENT", "CATCH_UP_KEEP_UP_STATUS_3_YEAR", "MOVE_UP_STAY_UP_STATUS_3_YEAR")
setnames(State_LONG_Data, state.vars, paste(state.vars, "_STATE", sep=""))
setkey(State_LONG_Data, VALID_CASE, CONTENT_AREA, YEAR, ID)
setkey(PARCC_LONG_Data, VALID_CASE, CONTENT_AREA, YEAR, ID)

###       Merge PARCC and State Data
PARCC_LONG_Data <- merge(PARCC_LONG_Data, State_LONG_Data, by=intersect(names(PARCC_LONG_Data), names(State_LONG_Data)), all.x=TRUE)

rm(State_LONG_Data); gc()

PARCC_LONG_Data[, Most_Recent_Prior := as.character(NA)]
PARCC_LONG_Data[, Most_Recent_Prior := sapply(strsplit(as.character(SGP_NORM_GROUP), "; "), function(x) rev(x)[2])]
PARCC_LONG_Data[, Most_Recent_Prior_State := as.character(NA)]
PARCC_LONG_Data[, Most_Recent_Prior_State := sapply(strsplit(as.character(SGP_NORM_GROUP_STATE), "; "), function(x) rev(x)[2])]

###   Add variables, etc used in State summary tables

PARCC_LONG_Data[ACHIEVEMENT_LEVEL %in% c("Level 1", "Level 2", "Level 3"), PROFICIENT:=0L]
PARCC_LONG_Data[ACHIEVEMENT_LEVEL %in% c("Level 4", "Level 5"), PROFICIENT:=1L]
PARCC_LONG_Data[, SCALE_SCORE_CURRENT_STANDARDIZED:=scale(SCALE_SCORE), keyby=list(CONTENT_AREA, YEAR, GRADE)]
PARCC_LONG_Data[, PRIOR_YEAR := strsplit(Most_Recent_Prior[1], "/")[[1]][1], by="Most_Recent_Prior"]
PARCC_LONG_Data[, PRIOR_GRADE := tail(strsplit(strsplit(Most_Recent_Prior[1], "/")[[1]][2], "_")[[1]], 1), by="Most_Recent_Prior"]
PARCC_LONG_Data[, PRIOR_CONTENT_AREA := paste(head(strsplit(strsplit(Most_Recent_Prior[1], "/")[[1]][2], "_")[[1]], -1), collapse="_"), by="Most_Recent_Prior"]

scaling.constants <- as.data.table(read.csv("PARCC/Data/Base_Files/2015-2016 PARCC Scaling Constants.csv"))
PARCC_LONG_Data[, SCALE_SCORE_PRIOR_ACTUAL := round((SCALE_SCORE_PRIOR*scaling.constants[CONTENT_AREA==PRIOR_CONTENT_AREA[1] & GRADE==PRIOR_GRADE[1]][["a"]]+scaling.constants[CONTENT_AREA==PRIOR_CONTENT_AREA[1] & GRADE==PRIOR_GRADE[1]][["b"]]), 0), by=c("PRIOR_CONTENT_AREA", "PRIOR_GRADE")]
cor(PARCC_LONG_Data$SCALE_SCORE_PRIOR_ACTUAL, PARCC_LONG_Data$SCALE_SCORE_PRIOR, use="complete")
PARCC_LONG_Data[which(SCALE_SCORE_PRIOR_ACTUAL < 650), SCALE_SCORE_PRIOR_ACTUAL := 650]
PARCC_LONG_Data[which(SCALE_SCORE_PRIOR_ACTUAL > 850), SCALE_SCORE_PRIOR_ACTUAL := 850]

# # These were causing problems with calculation of PRIOR_ACHIEVEMENT_PERCENTILE below
PARCC_LONG_Data[, PR_YEAR := PRIOR_YEAR] # Next time just use setnames(...)
PARCC_LONG_Data[, PR_GRADE := PRIOR_GRADE]
PARCC_LONG_Data[, PR_CONTENT_AREA := PRIOR_CONTENT_AREA]
PARCC_LONG_Data[, PRIOR_YEAR := NULL]
PARCC_LONG_Data[, PRIOR_GRADE := NULL]
PARCC_LONG_Data[, PRIOR_CONTENT_AREA := NULL]


setwd("/Users/avi/Dropbox (SGP)/Github_Repos/Documentation/PARCC/SGP_Reports")

PARCC_SGP <- prepareSGP(PARCC_LONG_Data, create.additional.variables = FALSE)

save(PARCC_SGP, file="../Data/PARCC_SGP-Tech_Reports_2018.2.Rdata")

###
##    Spring 2018 reports
###

###   Load required packages and data
require(Literasee)

###   Read in Fall (truncated) SGP object

setwd("/Users/avi/Dropbox (SGP)/Github_Repos/Documentation/PARCC/SGP_Reports/PARCC/2018")
load ("../../../Data/PARCC_SGP-Tech_Reports_2018.2.Rdata")


renderMultiDocument(rmd_input = "Appendix_C_Spring_2018.Rmd",
										# output_format = c("HTML"),
										output_format = c("HTML", "PDF"), #, "EPUB", "DOCX"
										cover_img="../img/cover.jpg",
										add_cover_title=TRUE)

