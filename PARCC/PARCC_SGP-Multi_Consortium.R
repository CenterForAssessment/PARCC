##################################################################################
###                                                                            ###
###   SGP analysis script for PARCC Alternative Test Consortiums - July 2019   ###
###                                                                            ###
##################################################################################

### Load Packages
require(SGP)
require(data.table)


#####
###   Alternative consortium SGPs
#####

###   ABO Lite

load('/media/Data/PARCC/PARCC_ABO_Lite/Data/Archive/2018_2019.2/PARCC_SGP_LONG_Data_2018_2019.2.Rdata')
table(PARCC_SGP_LONG_Data_2018_2019.2[, StateAbbreviation, is.na(SGP)], exclude=NULL)
PARCC_SGP_LONG_Data_2018_2019.2 <- PARCC_SGP_LONG_Data_2018_2019.2[StateAbbreviation %in% c("IL", "NM", "BI")] # "NJ",

PARCC_ABO_Lite <- PARCC_SGP_LONG_Data_2018_2019.2[,
												c(names(PARCC_SGP_LONG_Data_2018_2019.2)[c(1:6, 14, 19, 8, 11, 16)],
												"SGP", "SGP_ORDER", "SGP_NOTE", "SGP_NORM_GROUP"), with=FALSE][grep("_SS", CONTENT_AREA, invert =TRUE),]

setnames(PARCC_ABO_Lite, c("SGP", "SGP_ORDER", "SGP_NOTE", "SGP_NORM_GROUP"), c("ABOL", "ABOL_ORDER", "ABOL_NOTE", "ABOL_NORM_GROUP"))
setkeyv(PARCC_ABO_Lite, names(PARCC_SGP_LONG_Data_2018_2019.2)[c(1:6, 14, 19, 8, 11, 16)])

##   ABO NonEq
load('/media/Data/PARCC/PARCC_ABO2/PARCC_SGP_LONG_Data_2018_2019.2.Rdata')
# table(PARCC_SGP_LONG_Data_2018_2019.2[, StateAbbreviation, is.na(SGP)], exclude=NULL)
# PARCC_SGP_LONG_Data_2018_2019.2 <- PARCC_SGP_LONG_Data_2018_2019.2[StateAbbreviation %in% c("IL", "NJ", "NM", "BI")] # Did this in analysis step

PARCC_ABO_NonEq <- PARCC_SGP_LONG_Data_2018_2019.2[,
												c(names(PARCC_SGP_LONG_Data_2018_2019.2)[c(1:6, 14, 19, 8, 11, 16)],
												"SGP", "SGP_ORDER", "SGP_NOTE", "SGP_NORM_GROUP"), with=FALSE][grep("_SS", CONTENT_AREA, invert =TRUE),]

setnames(PARCC_ABO_NonEq, c("SGP", "SGP_ORDER", "SGP_NOTE", "SGP_NORM_GROUP"), c("ALT", "ALT_ORDER", "ALT_NOTE", "ALT_NORM_GROUP"))
setkeyv(PARCC_ABO_NonEq, names(PARCC_SGP_LONG_Data_2018_2019.2)[c(1:6, 14, 19, 8, 11, 16)])

###   Combine ABO consortium SGP versions
PARCC_ABO <- PARCC_ABO_Lite[PARCC_ABO_NonEq]

###   Flagship
load('/media/Data/PARCC/PARCC_Flagship/Data/Archive/2018_2019.2/PARCC_SGP_LONG_Data_2018_2019.2.Rdata')
# table(PARCC_SGP_LONG_Data_2018_2019.2[, StateAbbreviation, is.na(SGP)], exclude=NULL)
# PARCC_SGP_LONG_Data_2018_2019.2 <- PARCC_SGP_LONG_Data_2018_2019.2[StateAbbreviation %in% c("DD", "MD", "DC")] # Did this in analysis step

PARCC_Flagship <- PARCC_SGP_LONG_Data_2018_2019.2[,
												c(names(PARCC_SGP_LONG_Data_2018_2019.2)[c(1:6, 14, 19, 8, 11, 16)],
												"SGP", "SGP_ORDER", "SGP_NOTE", "SGP_NORM_GROUP"), with=FALSE][grep("_SS", CONTENT_AREA, invert =TRUE),]

setnames(PARCC_Flagship, c("SGP", "SGP_ORDER", "SGP_NOTE", "SGP_NORM_GROUP"), c("ALT", "ALT_ORDER", "ALT_NOTE", "ALT_NORM_GROUP"))
setkeyv(PARCC_Flagship, names(PARCC_SGP_LONG_Data_2018_2019.2)[c(1:6, 14, 19, 8, 11, 16)])

###   Combine alternative consortium SGPs

PARCC_ALT_2019 <- rbindlist(list(PARCC_ABO, PARCC_Flagship), fill=TRUE)
setkeyv(PARCC_ALT_2019, names(PARCC_SGP_LONG_Data_2018_2019.2)[c(1:6, 14, 19, 8, 11, 16)])

#####
###   Complete consortium SGPs
#####

# load('/media/Data/PARCC/PARCC_Complete/Data/Archive/2018_2019.2/PARCC_SGP_LONG_Data_2018_2019.2.Rdata')
# table(PARCC_SGP_LONG_Data_2018_2019.2[, StateAbbreviation, is.na(SGP)], exclude=NULL)
load('/media/Data/PARCC/PARCC_Comp2/Data/Archive/2018_2019.2/PARCC_SGP_LONG_Data_2018_2019.2-EqV2.Rdata')
table(PARCC_SGP_LONG_Data_2018_2019.2[, StateAbbreviation, is.na(SGP)], exclude=NULL)

PARCC_Complete <- PARCC_SGP_LONG_Data_2018_2019.2[,
												c(names(PARCC_SGP_LONG_Data_2018_2019.2)[c(1:6, 14, 19, 8, 11, 16)],
												"SGP_NonEq", "SGP_ORDER", "SGP_NOTE", "SGP_NORM_GROUP"), with=FALSE][grep("_SS", CONTENT_AREA, invert =TRUE),]

setnames(PARCC_Complete, c("SGP_NonEq", "SGP_ORDER", "SGP_NOTE", "SGP_NORM_GROUP"), c("ALL", "ALL_ORDER", "ALL_NOTE", "ALL_NORM_GROUP"))
setkeyv(PARCC_Complete, names(PARCC_SGP_LONG_Data_2018_2019.2)[c(1:6, 14, 19, 8, 11, 16)])


###   Combine complete and alternative consortium SGPs
# PARCC_2019 <- PARCC_Complete[PARCC_ALT_2019]
PARCC_2019b <- merge(PARCC_Complete[!is.na(ALL)], PARCC_ALT_2019[!is.na(ALT)], all=TRUE)
PARCC_2019 <- merge(PARCC_Complete, PARCC_ALT_2019, all=TRUE)
PARCC_2019 <- PARCC_2019[-which(is.na(ALT) & is.na(ALL))]

PARCC_2019[, Most_Recent_Prior := as.character(NA)]
PARCC_2019[, Most_Recent_Prior := sapply(strsplit(as.character(ALL_NORM_GROUP), "; "), function(x) rev(x)[2])]
PARCC_2019[, Most_Recent_Prior2 := as.character(NA)]
PARCC_2019[, Most_Recent_Prior2 := sapply(strsplit(as.character(ABOL_NORM_GROUP), "; "), function(x) rev(x)[2])]
PARCC_2019[, Most_Recent_Prior3 := as.character(NA)]
PARCC_2019[, Most_Recent_Prior3 := sapply(strsplit(as.character(ALT_NORM_GROUP), "; "), function(x) rev(x)[2])]

###   Add variables, etc used in summary tables
PARCC_2019[, PRIOR_YEAR := strsplit(Most_Recent_Prior[1], "/")[[1]][1], by="Most_Recent_Prior"]
PARCC_2019[, PRIOR_GRADE := tail(strsplit(strsplit(Most_Recent_Prior[1], "/")[[1]][2], "_")[[1]], 1), by="Most_Recent_Prior"]
PARCC_2019[, PRIOR_CONTENT_AREA := paste(head(strsplit(strsplit(Most_Recent_Prior[1], "/")[[1]][2], "_")[[1]], -1), collapse="_"), by="Most_Recent_Prior"]
table(PARCC_2019[, PRIOR_CONTENT_AREA, PRIOR_YEAR])

table(PARCC_2019[, Most_Recent_Prior == Most_Recent_Prior2])
table(PARCC_2019[, Most_Recent_Prior == Most_Recent_Prior3])
table(PARCC_2019[Most_Recent_Prior != Most_Recent_Prior2, Most_Recent_Prior, Most_Recent_Prior2])
table(PARCC_2019[Most_Recent_Prior != Most_Recent_Prior3, Most_Recent_Prior, Most_Recent_Prior3])

# PARCC_2019 <- PARCC_2019[-which(Most_Recent_Prior != Most_Recent_Prior2),] #  700 cases that aren't equal to Most_Recent_Prior or Most_Recent_Prior3
# PARCC_2019 <- PARCC_2019[-which(Most_Recent_Prior != Most_Recent_Prior3),] #  1900 cases that aren't equal to Most_Recent_Prior
PARCC_2019[as.numeric(GRADE)-as.numeric(PRIOR_GRADE) == 1, Most_Recent_Prior := NA]
PARCC_2019[, Most_Recent_Prior2 := NULL]
PARCC_2019[, Most_Recent_Prior3 := NULL]

PARCC_2019[, YEAR := '2019']
table(PARCC_2019[, PRIOR_CONTENT_AREA, PRIOR_YEAR])

# PARCC_2019 <- PARCC_2019[grep("_SS", CONTENT_AREA, invert =TRUE),]

save(PARCC_2019, file="./PARCC_2019.rda")

#####
###   Load Historical data and combine
#####

# load("/media/Data/Dropbox (SGP)/SGP/PARCC_Alt_Consortium/Data/PARCC_Alt.Rdata")
load('/media/Data/PARCC_Alt/July_Redo/PARCC_Alt.Rdata')

PARCC_Alt[, names(PARCC_Alt)[!names(PARCC_Alt) %in% names(PARCC_2019)] := NULL]
setcolorder(PARCC_Alt, names(PARCC_2019)[names(PARCC_2019) %in% names(PARCC_Alt)])

PARCC_Consortiums <- rbindlist(list(PARCC_Alt, PARCC_2019), fill=TRUE)

PARCC_Consortiums[, Sub_Consortium := as.character(NA)]
PARCC_Consortiums[StateAbbreviation %in% c("MD", "DC", "DD"), Sub_Consortium := "Flagship"]
PARCC_Consortiums[!StateAbbreviation %in% c("MD", "DC", "DD"), Sub_Consortium := "ABO"]
table(PARCC_Consortiums[, Sub_Consortium, StateAbbreviation])
save(PARCC_Consortiums, file="Data/PARCC_Consortiums.rda")


#####
###   Summaries and visualizations
#####

smry.grd <- PARCC_Consortiums[!is.na(ALL),
	list(Mean_Score = round(mean(SCALE_SCORE_ACTUAL, na.rm=T), 1), Median_Score = median(SCALE_SCORE_ACTUAL, na.rm=T),
			 Mean_Full= round(mean(ALL, na.rm=T), 3), Median_Full= median(as.numeric(ALL), na.rm=T),
			 Mean_Alternative= round(mean(ALT, na.rm=T), 3), Median_Alternative= median(as.numeric(ALT), na.rm=T),
			 Mean_ABO_Lite=round(mean(ABOL, na.rm=T),2), Median_ABO_Lite=median(as.numeric(ABOL),na.rm=T), N=.N),
	keyby=c("Sub_Consortium", "CONTENT_AREA", "GRADE", "YEAR")]

smry.grd.m <- PARCC_Consortiums[!is.na(ALL),
	list(Mean_Score = round(mean(SCALE_SCORE_ACTUAL, na.rm=T), 3), Median_Score = median(SCALE_SCORE_ACTUAL, na.rm=T),
			 Mean_Full= round(mean(ALL, na.rm=T), 3), Median_Full= median(as.numeric(ALL), na.rm=T),
			 Mean_Alternative= round(mean(ALT, na.rm=T), 3), Median_Alternative= median(as.numeric(ALT), na.rm=T),
			 Mean_ABO_Lite=round(mean(ABOL, na.rm=T), 3), Median_ABO_Lite=median(as.numeric(ABOL),na.rm=T), N=.N),
	keyby=c("Sub_Consortium", "CONTENT_AREA", "GRADE", "Most_Recent_Prior", "YEAR")]

smry.grd.st <- PARCC_Consortiums[!is.na(ALL),
	list(Mean_Score = round(mean(SCALE_SCORE_ACTUAL, na.rm=T), 3), Median_Score = median(SCALE_SCORE_ACTUAL, na.rm=T),
			 Mean_Full= round(mean(ALL, na.rm=T), 3), Median_Full= median(as.numeric(ALL), na.rm=T),
			 Mean_Alternative= round(mean(ALT, na.rm=T), 3), Median_Alternative= median(as.numeric(ALT), na.rm=T),
			 Mean_ABO_Lite=round(mean(ABOL, na.rm=T), 3), Median_ABO_Lite=median(as.numeric(ABOL),na.rm=T), N=.N),
	keyby=c("StateAbbreviation", "CONTENT_AREA", "GRADE", "YEAR")]

smry.grd.st.m <- PARCC_Consortiums[!is.na(ALL),
	list(Mean_Score = round(mean(SCALE_SCORE_ACTUAL, na.rm=T), 3), Median_Score = median(SCALE_SCORE_ACTUAL, na.rm=T),
			 Mean_Full= round(mean(ALL, na.rm=T), 3), Median_Full= median(as.numeric(ALL), na.rm=T),
			 Mean_Alternative= round(mean(ALT, na.rm=T), 3), Median_Alternative= median(as.numeric(ALT), na.rm=T),
			 Mean_ABO_Lite=round(mean(ABOL, na.rm=T), 3), Median_ABO_Lite=median(as.numeric(ABOL),na.rm=T), N=.N),
	keyby=c("StateAbbreviation", "CONTENT_AREA", "GRADE", "Most_Recent_Prior", "YEAR")]

diff.grd <- PARCC_Consortiums[!is.na(ALL) & !is.na(ALT), as.list(round(summary(ALL-ALT),2)),
	keyby=c("CONTENT_AREA", "GRADE", "Most_Recent_Prior", "YEAR")]

diff.grd.st <- PARCC_Consortiums[!is.na(ALL) & !is.na(ALT), as.list(round(summary(ALL-ALT),2)),
	keyby=c("StateAbbreviation", "CONTENT_AREA", "GRADE", "Most_Recent_Prior", "YEAR")]

smry.grd[, GRADE := as.numeric(GRADE)]
smry.grd.m[, GRADE := as.numeric(GRADE)]
diff.grd[, GRADE := as.numeric(GRADE)]
smry.grd.st[, GRADE := as.numeric(GRADE)]
smry.grd.st.m[, GRADE := as.numeric(GRADE)]
diff.grd.st[, GRADE := as.numeric(GRADE)]

setkey(smry.grd)
setkey(smry.grd.m)
setkey(diff.grd)
setkey(smry.grd.st.m)
setkey(smry.grd.st)
setkey(diff.grd.st)
diff.grd.st[StateAbbreviation=="MD" & CONTENT_AREA == "ELA",]

diff.grd[smry.grd][CONTENT_AREA == "ELA" & N > 999,]


smry.grd.m[, Most_Recent_Prior := sapply(gsub("/", " ", Most_Recent_Prior), SGP::capwords)]
smry.grd.m[, Most_Recent_Prior := gsub("2015 2016 2", "2016", Most_Recent_Prior)]
smry.grd.m[, Most_Recent_Prior := gsub("2016 2017 2", "2017", Most_Recent_Prior)]
smry.grd.m[, Most_Recent_Prior := gsub("2016 2017 1", "Fall 2016", Most_Recent_Prior)]
smry.grd.m[, Most_Recent_Prior := gsub("2017 2018 1", "Fall 2017", Most_Recent_Prior)]
smry.grd.m[, Most_Recent_Prior := gsub("2017 2018 2", "2018", Most_Recent_Prior)]
smry.grd.m[, Most_Recent_Prior := gsub("2018 2019 1", "Fall 2018", Most_Recent_Prior)]
smry.grd.m[, Most_Recent_Prior := gsub("Mathematics", "Math", Most_Recent_Prior)]
smry.grd.m[, Most_Recent_Prior := gsub(" Eoct", "", Most_Recent_Prior)]
smry.grd.m[, Most_Recent_Prior := gsub(" 8", " Grade 8", Most_Recent_Prior)]
smry.grd.m[, Most_Recent_Prior := gsub(" 7", " Grade 7", Most_Recent_Prior)]
smry.grd.m[, Most_Recent_Prior := gsub(" 6", " Grade 6", Most_Recent_Prior)]

smry.grd.st.m[, Most_Recent_Prior := sapply(gsub("/", " ", Most_Recent_Prior), SGP::capwords)]
smry.grd.st.m[, Most_Recent_Prior := gsub("2015 2016 2", "2016", Most_Recent_Prior)]
smry.grd.st.m[, Most_Recent_Prior := gsub("2016 2017 2", "2017", Most_Recent_Prior)]
smry.grd.st.m[, Most_Recent_Prior := gsub("2016 2017 1", "Fall 2016", Most_Recent_Prior)]
smry.grd.st.m[, Most_Recent_Prior := gsub("2017 2018 1", "Fall 2017", Most_Recent_Prior)]
smry.grd.st.m[, Most_Recent_Prior := gsub("2017 2018 2", "2018", Most_Recent_Prior)]
smry.grd.st.m[, Most_Recent_Prior := gsub("2018 2019 1", "Fall 2018", Most_Recent_Prior)]
smry.grd.st.m[, Most_Recent_Prior := gsub("Mathematics", "Math", Most_Recent_Prior)]
smry.grd.st.m[, Most_Recent_Prior := gsub(" Eoct", "", Most_Recent_Prior)]
smry.grd.st.m[, Most_Recent_Prior := gsub(" 8", " Grade 8", Most_Recent_Prior)]
smry.grd.st.m[, Most_Recent_Prior := gsub(" 7", " Grade 7", Most_Recent_Prior)]
smry.grd.st.m[, Most_Recent_Prior := gsub(" 6", " Grade 6", Most_Recent_Prior)]

smry.grd[CONTENT_AREA == "ELA" & GRADE == 4 & N > 999,]
smry.grd.st[StateAbbreviation=="MD" & CONTENT_AREA == "ELA" & GRADE == 4 & N > 999,] # MD Table 1

state.ela <- smry.grd.st[CONTENT_AREA == "ELA",]
state.ela.m <- smry.grd.st.m[CONTENT_AREA == "ELA",]
parcc.ela <- smry.grd[CONTENT_AREA == "ELA",]
parcc.ela.m <- smry.grd.m[CONTENT_AREA == "ELA",]
state.math <- smry.grd.st[CONTENT_AREA == "MATHEMATICS",]
parcc.math <- smry.grd[CONTENT_AREA == "MATHEMATICS",]
state.eoct <- smry.grd.st[!CONTENT_AREA %in% c("ELA", "MATHEMATICS"),]
state.eoct.m <- smry.grd.st.m[!CONTENT_AREA %in% c("ELA", "MATHEMATICS"),]
parcc.eoct <- smry.grd[!CONTENT_AREA %in% c("ELA", "MATHEMATICS"),]
parcc.eoct.m <- smry.grd.m[!CONTENT_AREA %in% c("ELA", "MATHEMATICS"),]

library(xlsx)
write.xlsx(parcc.ela, file="Consortium_Comparisons_Summaries.xlsx", sheetName="ELA", showNA=FALSE)
write.xlsx(parcc.ela.m, file="Consortium_Comparisons_Summaries.xlsx", sheetName="ELA_by_MRP", append=TRUE, showNA=FALSE)
write.xlsx(parcc.math, file="Consortium_Comparisons_Summaries.xlsx", sheetName="Math", append=TRUE, showNA=FALSE)
write.xlsx(parcc.eoct, file="Consortium_Comparisons_Summaries.xlsx", sheetName="EOCT", append=TRUE, showNA=FALSE)
write.xlsx(parcc.eoct.m, file="Consortium_Comparisons_Summaries.xlsx", sheetName="EOCT_by_MRP", append=TRUE, showNA=FALSE)

write.xlsx(state.ela, file="State_Comparisons_Summaries.xlsx", sheetName="ELA", showNA=FALSE)
write.xlsx(state.ela.m, file="State_Comparisons_Summaries.xlsx", sheetName="ELA_by_MRP", append=TRUE, showNA=FALSE)
write.xlsx(state.math, file="State_Comparisons_Summaries.xlsx", sheetName="Math", append=TRUE, showNA=FALSE)
write.xlsx(state.eoct, file="State_Comparisons_Summaries.xlsx", sheetName="EOCT", append=TRUE, showNA=FALSE)
write.xlsx(state.eoct.m, file="State_Comparisons_Summaries.xlsx", sheetName="EOCT_by_MRP", append=TRUE, showNA=FALSE)


#####
#####   PARCC Alt Consortium Plotting Data
#####

require(ggplot2)
require(data.table)


content.area <- "ELA"
grade <- "4"

my.colors <- c("#FF3333", "#CC0000", "#6666FF", "#0000CC", "#00FF00", "#009966") # "darkred", "lightred", "darkblue", "blue", "darkgreen", "lightgreen"
for (content.area in c("ELA", "MATHEMATICS", "ALGEBRA_I", "ALGEBRA_II", "GEOMETRY")) {
for (grade in c(4, 5, 6, 7, 8, 10, "EOCT")) {
	tmp.data.parcc <- PARCC_Consortiums[CONTENT_AREA == content.area & GRADE == grade, list(Sub_Consortium, SCALE_SCORE, SCALE_SCORE_ACTUAL, YEAR, ALL, ALT, ABOL)]
	if (content.area=="MATHEMATICS") ca.name <- "Math" else ca.name <- content.area

	if (nrow(tmp.data.parcc[YEAR %in% c("2019") & !is.na(SCALE_SCORE),]) > 100) {
		p <- ggplot() +
			scale_color_manual(values = my.colors) +
			ggtitle(paste("IRT Theta by Sub-Consortium:", ifelse(grade=="EOCT", "", paste("Grade", grade)), ca.name)) +
			theme(plot.title = element_text(size=18, face="bold.italic"), axis.title.x=element_text(size=15), axis.title.y=element_text(size=15), axis.text.x=element_text(size=14), axis.text.y=element_text(size=14))

		p <- p + geom_density(data = tmp.data.parcc[YEAR == "2019" & abs(SCALE_SCORE) < 4 & Sub_Consortium == "ABO"], aes(SCALE_SCORE, color= "'19 ABO"), size=1.15)
		p <- p + geom_density(data = tmp.data.parcc[YEAR == "2019" & abs(SCALE_SCORE) < 4 & Sub_Consortium == "Flagship"], aes(SCALE_SCORE, color= "'19 Flagship"), size=1.15)
		p <- p + geom_vline(xintercept = mean(tmp.data.parcc[YEAR == "2019" & Sub_Consortium == "ABO", SCALE_SCORE], na.rm=T), size=1.15, color = my.colors[5])
		p <- p + geom_vline(xintercept = mean(tmp.data.parcc[YEAR == "2019" & Sub_Consortium == "Flagship", SCALE_SCORE], na.rm=T), size=1.15, color = my.colors[6])
		p <- p + geom_density(data = tmp.data.parcc[YEAR == "2018" & abs(SCALE_SCORE) < 4 & Sub_Consortium == "ABO"], aes(SCALE_SCORE, color= "'18 ABO"), size=1.15, linetype="dashed")
		p <- p + geom_density(data = tmp.data.parcc[YEAR == "2018" & abs(SCALE_SCORE) < 4 & Sub_Consortium == "Flagship"], aes(SCALE_SCORE, color= "'18 Flagship"), size=1.15, linetype="dotted")
		p <- p + geom_vline(xintercept = mean(tmp.data.parcc[YEAR == "2018" & Sub_Consortium == "ABO", SCALE_SCORE], na.rm=T), size=1.15, linetype="dashed", color = my.colors[3])
		p <- p + geom_vline(xintercept = mean(tmp.data.parcc[YEAR == "2018" & Sub_Consortium == "Flagship", SCALE_SCORE], na.rm=T), size=1.15, linetype="dotted", color = my.colors[4])
		p <- p + geom_density(data = tmp.data.parcc[YEAR == "2017" & abs(SCALE_SCORE) < 4 & Sub_Consortium == "ABO"], aes(SCALE_SCORE, color= "'17 ABO"), size=1.15, linetype="dashed")
		p <- p + geom_density(data = tmp.data.parcc[YEAR == "2017" & abs(SCALE_SCORE) < 4 & Sub_Consortium == "Flagship"], aes(SCALE_SCORE, color= "'17 Flagship"), size=1.15, linetype="dotted")
		p <- p + geom_vline(xintercept = mean(tmp.data.parcc[YEAR == "2017" & Sub_Consortium == "ABO", SCALE_SCORE], na.rm=T), size=1.15, linetype="dashed", color = my.colors[1])
		p <- p + geom_vline(xintercept = mean(tmp.data.parcc[YEAR == "2017" & Sub_Consortium == "Flagship", SCALE_SCORE], na.rm=T), size=1.15, linetype="dotted", color = my.colors[2])

		p <- p + guides(color = guide_legend(override.aes = list(linetype=c(rep(c("dashed", "dotted"), 2), "solid", "solid")), title = "Sub\nConsortiums", title.theme = element_text(size = 16), label.theme = element_text(size = 15)))
		p <- p + scale_x_continuous(name="IRT Theta Distribution and Mean (Vertical Line)")

		ggsave(filename = paste("./Plots/PARCC_Subconsortium", ifelse(grade=="EOCT", "_", paste0("_Grade_", grade, "_")), ca.name, "_IRT.pdf", sep=""), plot=p, device = "pdf", width = 9, height = 7, units = "in")

		p <- ggplot() +
			scale_color_manual(values = my.colors) +
			ggtitle(paste("Scale Score by Sub-Consortium:", ifelse(grade=="EOCT", "", paste("Grade", grade)), ca.name)) +
			theme(plot.title = element_text(size=18, face="bold.italic"), axis.title.x=element_text(size=15), axis.title.y=element_text(size=15), axis.text.x=element_text(size=14), axis.text.y=element_text(size=14))

		p <- p + geom_density(data = tmp.data.parcc[YEAR == "2019" & SCALE_SCORE_ACTUAL & Sub_Consortium == "ABO"], aes(SCALE_SCORE_ACTUAL, color= "'19 ABO"), size=1.15)
		p <- p + geom_density(data = tmp.data.parcc[YEAR == "2019" & SCALE_SCORE_ACTUAL & Sub_Consortium == "Flagship"], aes(SCALE_SCORE_ACTUAL, color= "'19 Flagship"), size=1.15)
		p <- p + geom_vline(xintercept = mean(tmp.data.parcc[YEAR == "2019" & Sub_Consortium == "ABO", SCALE_SCORE_ACTUAL], na.rm=T), size=1.15, color = my.colors[5])
		p <- p + geom_vline(xintercept = mean(tmp.data.parcc[YEAR == "2019" & Sub_Consortium == "Flagship", SCALE_SCORE_ACTUAL], na.rm=T), size=1.15, color = my.colors[6])
		p <- p + geom_density(data = tmp.data.parcc[YEAR == "2018" & SCALE_SCORE_ACTUAL & Sub_Consortium == "ABO"], aes(SCALE_SCORE_ACTUAL, color= "'18 ABO"), size=1.15, linetype="dashed")
		p <- p + geom_density(data = tmp.data.parcc[YEAR == "2018" & SCALE_SCORE_ACTUAL & Sub_Consortium == "Flagship"], aes(SCALE_SCORE_ACTUAL, color= "'18 Flagship"), size=1.15, linetype="dotted")
		p <- p + geom_vline(xintercept = mean(tmp.data.parcc[YEAR == "2018" & Sub_Consortium == "ABO", SCALE_SCORE_ACTUAL], na.rm=T), size=1.15, linetype="dashed", color = my.colors[3])
		p <- p + geom_vline(xintercept = mean(tmp.data.parcc[YEAR == "2018" & Sub_Consortium == "Flagship", SCALE_SCORE_ACTUAL], na.rm=T), size=1.15, linetype="dotted", color = my.colors[4])
		p <- p + geom_density(data = tmp.data.parcc[YEAR == "2017" & SCALE_SCORE_ACTUAL & Sub_Consortium == "ABO"], aes(SCALE_SCORE_ACTUAL, color= "'17 ABO"), size=1.15, linetype="dashed")
		p <- p + geom_density(data = tmp.data.parcc[YEAR == "2017" & SCALE_SCORE_ACTUAL & Sub_Consortium == "Flagship"], aes(SCALE_SCORE_ACTUAL, color= "'17 Flagship"), size=1.15, linetype="dotted")
		p <- p + geom_vline(xintercept = mean(tmp.data.parcc[YEAR == "2017" & Sub_Consortium == "ABO", SCALE_SCORE_ACTUAL], na.rm=T), size=1.15, linetype="dashed", color = my.colors[1])
		p <- p + geom_vline(xintercept = mean(tmp.data.parcc[YEAR == "2017" & Sub_Consortium == "Flagship", SCALE_SCORE_ACTUAL], na.rm=T), size=1.15, linetype="dotted", color = my.colors[2])

		p <- p + guides(color = guide_legend(override.aes = list(linetype=c(rep(c("dashed", "dotted"), 2), "solid", "solid")), title = "Sub\nConsortiums", title.theme = element_text(size = 16), label.theme = element_text(size = 15)))
		p <- p + scale_x_continuous(name="Scale Score Distribution and Mean (Vertical Line)")

		ggsave(filename = paste("./Plots/PARCC_Subconsortium", ifelse(grade=="EOCT", "_", paste0("_Grade_", grade, "_")), ca.name, "_SS.pdf", sep=""), plot=p, device = "pdf", width = 9, height = 7, units = "in")
	}
}}

for (content.area in c("ELA", "MATHEMATICS", "ALGEBRA_I", "ALGEBRA_II", "GEOMETRY")) {
for (grade in c(4, 5, 6, 7, 8, 10, "EOCT")) { # Not enough ELA 9 and 11 Flag and ABO respectively
	tmp.data.parcc <- PARCC_Consortiums[CONTENT_AREA == content.area & GRADE == grade, list(Sub_Consortium, SCALE_SCORE, SCALE_SCORE_ACTUAL, YEAR, ALL, ALT, ABOL)]
	if (content.area=="MATHEMATICS") ca.name <- "Math" else ca.name <- content.area

	if (nrow(tmp.data.parcc[YEAR %in% c("2019") & !is.na(ALL),]) > 100) {

		p <- ggplot() +
			scale_color_manual(values = my.colors) +
			ggtitle(paste("SGPs by Sub Consortium:", ifelse(grade=="EOCT", "", paste("Grade", grade)), ca.name)) +
			theme(plot.title = element_text(size=12, face="bold.italic"))

		p <- p + geom_density(data = tmp.data.parcc[YEAR == "2019" & Sub_Consortium == "ABO"], aes(ALL, color= "'19 ABO"), size=1.15)
		p <- p + geom_density(data = tmp.data.parcc[YEAR == "2019" & Sub_Consortium == "Flagship"], aes(ALL, color= "'19 Flagship"), size=1.15)
		p <- p + geom_vline(xintercept = mean(tmp.data.parcc[YEAR == "2019" & Sub_Consortium == "ABO", ALL], na.rm=T), size=1.15, color = my.colors[5])
		p <- p + geom_vline(xintercept = mean(tmp.data.parcc[YEAR == "2019" & Sub_Consortium == "Flagship", ALL], na.rm=T), size=1.15, color = my.colors[6])
		p <- p + geom_density(data = tmp.data.parcc[YEAR == "2018" & Sub_Consortium == "ABO"], aes(ALL, color= "'18 ABO"), size=1.15, linetype="dashed")
		p <- p + geom_density(data = tmp.data.parcc[YEAR == "2018" & Sub_Consortium == "Flagship"], aes(ALL, color= "'18 Flagship"), size=1.15, linetype="dotted")
		p <- p + geom_vline(xintercept = mean(tmp.data.parcc[YEAR == "2018" & Sub_Consortium == "ABO", ALL], na.rm=T), size=1.15, linetype="dashed", color = my.colors[3])
		p <- p + geom_vline(xintercept = mean(tmp.data.parcc[YEAR == "2018" & Sub_Consortium == "Flagship", ALL], na.rm=T), size=1.15, linetype="dotted", color = my.colors[4])
		p <- p + geom_density(data = tmp.data.parcc[YEAR == "2017" & Sub_Consortium == "ABO"], aes(ALL, color= "'17 ABO"), size=1.15, linetype="dashed")
		p <- p + geom_density(data = tmp.data.parcc[YEAR == "2017" & Sub_Consortium == "Flagship"], aes(ALL, color= "'17 Flagship"), size=1.15, linetype="dotted")
		p <- p + geom_vline(xintercept = mean(tmp.data.parcc[YEAR == "2017" & Sub_Consortium == "ABO", ALL], na.rm=T), size=1.15, linetype="dashed", color = my.colors[1])
		p <- p + geom_vline(xintercept = mean(tmp.data.parcc[YEAR == "2017" & Sub_Consortium == "Flagship", ALL], na.rm=T), size=1.15, linetype="dotted", color = my.colors[2])

		# p <- p + guides(color = guide_legend(override.aes = list(linetype=c(rep(c("dashed", "dotted"), 2), "solid", "solid")), title = "Sub\nConsortiums"))
		p <- p + theme(legend.position = "none")
		p <- p + scale_x_continuous(name="SGP Distribution and Mean (Vertical Line)")

		ggsave(filename = paste("./Plots/PARCC_Subconsortium", ifelse(grade=="EOCT", "_", paste0("_Grade_", grade, "_")), ca.name, "_SGP.pdf", sep=""), plot=p, device = "pdf", width = 5.5, height = 4.25, units = "in")
	}
}}

# state <- "DC"
# content.area <- "MATHEMATICS"
# grade <- "11"

for (state in c("BI", "DD", "DC", "IL", "MD", "NJ", "NM")) {
	state.name <- gsub("_", " ", SGP::getStateAbbreviation(state, type="State"))

	for (content.area in c("ELA", "MATHEMATICS", "ALGEBRA_I", "ALGEBRA_II", "GEOMETRY")) {
	for (grade in c(4, 5, 6, 7, 8, 9, 10, 11, "EOCT")) {
		tmp.data.parcc <- PARCC_Consortiums[CONTENT_AREA == content.area & GRADE == grade, list(SCALE_SCORE, SCALE_SCORE_ACTUAL, YEAR, ALL, ALT, ABOL)]
		tmp.data.state <- PARCC_Consortiums[CONTENT_AREA == content.area & GRADE == grade & StateAbbreviation == state, list(SCALE_SCORE, SCALE_SCORE_ACTUAL, YEAR, ALL, ALT, ABOL)]
		if (content.area=="MATHEMATICS") ca.name <- "Math" else ca.name <- content.area

		my.colors <- c("#CC0000", "#FF3333", "#0000CC", "#6666FF", "#009966", "#00FF00") # "darkred", "lightred", "darkblue", "blue", "darkgreen", "lightgreen"
		my.colors2 <- c("#990000", "#FF3333", "#000099", "#6666FF", "#009966", "#9ACD32", "#00FF00") # med red "#CC0000", med blue "#0000FF",
		if (!"2017" %in% tmp.data.state$YEAR) my.colors <- tail(my.colors, -2)
		if (!"2018" %in% tmp.data.state$YEAR) my.colors <- tail(my.colors, -2)
		if (!"2017" %in% tmp.data.state$YEAR | all(is.na(tmp.data.state[YEAR == "2017", ALT]))) my.colors2 <- tail(my.colors2, -2)
		if (!"2018" %in% tmp.data.state$YEAR | all(is.na(tmp.data.state[YEAR == "2018", ALT]))) my.colors2 <- tail(my.colors2, -2)
		if (all(is.na(tmp.data.state$ABOL))) {my.colors2 <- my.colors2[-(length(my.colors2)-1)]; clength <- 0} else clength <- 1

		if (nrow(tmp.data.state[YEAR %in% c("2019") & !is.na(ALL),]) > 100) {
		###   IRT Theta by State/Content Area/Grade
		year.count <- 1
		p <- ggplot() +
			scale_color_manual(values = my.colors) +
			ggtitle(paste(state.name, "and Consortium Scores:", ifelse(grade=="EOCT", "", paste("Grade", grade)), ca.name)) +
			theme(plot.title = element_text(size=14, face="bold.italic"))
		if ("2017" %in% tmp.data.state$YEAR) {
			p <- p + geom_density(data = tmp.data.parcc[YEAR == "2017" & abs(SCALE_SCORE) < 4], aes(SCALE_SCORE, color= "'17 Consortium"), size=1.1, linetype="dashed")
			p <- p + geom_density(data = tmp.data.state[YEAR == "2017" & abs(SCALE_SCORE) < 4], aes(SCALE_SCORE, color= "'17 State"), size=1.1)
			p <- p + geom_vline(xintercept = mean(tmp.data.parcc[YEAR == "2017", SCALE_SCORE], na.rm=T), size=1.1, linetype="dashed", color = my.colors[1])
			p <- p + geom_vline(xintercept = mean(tmp.data.state[YEAR == "2017", SCALE_SCORE], na.rm=T), size=1.1, color = my.colors[2])
			year.count <- year.count + 1
		}
		if ("2018" %in% tmp.data.state$YEAR) {
			p <- p + geom_density(data = tmp.data.parcc[YEAR == "2018" & abs(SCALE_SCORE) < 4], aes(SCALE_SCORE, color= "'18 Consortium"), size=1.1, linetype="dashed")
			p <- p + geom_density(data = tmp.data.state[YEAR == "2018" & abs(SCALE_SCORE) < 4], aes(SCALE_SCORE, color= "'18 State"), size=1.1)
			p <- p + geom_vline(xintercept = mean(tmp.data.parcc[YEAR == "2018", SCALE_SCORE], na.rm=T), size=1.1, linetype="dashed", color = my.colors[length(my.colors)-3])
			p <- p + geom_vline(xintercept = mean(tmp.data.state[YEAR == "2018", SCALE_SCORE], na.rm=T), size=1.1, color = my.colors[length(my.colors)-2])
			year.count <- year.count + 1
		}
		p <- p + geom_density(data = tmp.data.parcc[YEAR == "2019" & abs(SCALE_SCORE) < 4], aes(SCALE_SCORE, color= "'19 Consortium"), size=1.1, linetype="dashed")
		p <- p + geom_density(data = tmp.data.state[YEAR == "2019" & abs(SCALE_SCORE) < 4], aes(SCALE_SCORE, color= "'19 State"), size=1.1)
		p <- p + geom_vline(xintercept = mean(tmp.data.parcc[YEAR == "2019", SCALE_SCORE], na.rm=T), size=1.1, linetype="dashed", color = my.colors[length(my.colors)-1])
		p <- p + geom_vline(xintercept = mean(tmp.data.state[YEAR == "2019", SCALE_SCORE], na.rm=T), size=1.1, color = my.colors[length(my.colors)])
		p <- p + guides(color = guide_legend(override.aes = list(linetype=rep(c("dashed", "solid"), year.count)), title = "Population"))
		p <- p + scale_x_continuous(name="IRT Theta Distribution and Mean (Vertical Line)")

		ggsave(filename = paste("./Plots/", state, ifelse(grade=="EOCT", "_", paste0("_Grade_", grade, "_")), ca.name, "_IRT.pdf", sep=""), plot=p, device = "pdf", width = 6, height = 4, units = "in")

		###   Scale Scores by State/Content Area/Grade
		year.count <- 1
		p <- ggplot() +
			scale_color_manual(values = my.colors) +
			ggtitle(paste(state.name, "and Consortium Scores:", ifelse(grade=="EOCT", "", paste("Grade", grade)), ca.name)) +
			theme(plot.title = element_text(size=14, face="bold.italic"))
		if ("2017" %in% tmp.data.state$YEAR) {
			p <- p + geom_density(data = tmp.data.parcc[YEAR == "2017" & SCALE_SCORE_ACTUAL], aes(SCALE_SCORE_ACTUAL, color= "'17 Consortium"), size=1.1, linetype="dashed")
			p <- p + geom_density(data = tmp.data.state[YEAR == "2017" & SCALE_SCORE_ACTUAL], aes(SCALE_SCORE_ACTUAL, color= "'17 State"), size=1.1)
			p <- p + geom_vline(xintercept = mean(tmp.data.parcc[YEAR == "2017", SCALE_SCORE_ACTUAL], na.rm=T), size=1.1, linetype="dashed", color = my.colors[1])
			p <- p + geom_vline(xintercept = mean(tmp.data.state[YEAR == "2017", SCALE_SCORE_ACTUAL], na.rm=T), size=1.1, color = my.colors[2])
			year.count <- year.count + 1
		}
		if ("2018" %in% tmp.data.state$YEAR) {
			p <- p + geom_density(data = tmp.data.parcc[YEAR == "2018" & SCALE_SCORE_ACTUAL], aes(SCALE_SCORE_ACTUAL, color= "'18 Consortium"), size=1.1, linetype="dashed")
			p <- p + geom_density(data = tmp.data.state[YEAR == "2018" & SCALE_SCORE_ACTUAL], aes(SCALE_SCORE_ACTUAL, color= "'18 State"), size=1.1)
			p <- p + geom_vline(xintercept = mean(tmp.data.parcc[YEAR == "2018", SCALE_SCORE_ACTUAL], na.rm=T), size=1.1, linetype="dashed", color = my.colors[length(my.colors)-3])
			p <- p + geom_vline(xintercept = mean(tmp.data.state[YEAR == "2018", SCALE_SCORE_ACTUAL], na.rm=T), size=1.1, color = my.colors[length(my.colors)-2])
			year.count <- year.count + 1
		}
		p <- p + geom_density(data = tmp.data.parcc[YEAR == "2019" & SCALE_SCORE_ACTUAL], aes(SCALE_SCORE_ACTUAL, color= "'19 Consortium"), size=1.1, linetype="dashed")
		p <- p + geom_density(data = tmp.data.state[YEAR == "2019" & SCALE_SCORE_ACTUAL], aes(SCALE_SCORE_ACTUAL, color= "'19 State"), size=1.1)
		p <- p + geom_vline(xintercept = mean(tmp.data.parcc[YEAR == "2019", SCALE_SCORE_ACTUAL], na.rm=T), size=1.1, linetype="dashed", color = my.colors[length(my.colors)-1])
		p <- p + geom_vline(xintercept = mean(tmp.data.state[YEAR == "2019", SCALE_SCORE_ACTUAL], na.rm=T), size=1.1, color = my.colors[length(my.colors)])
		p <- p + guides(color = guide_legend(override.aes = list(linetype=rep(c("dashed", "solid"), year.count)), title = "Population"))
		p <- p + scale_x_continuous(name="Scale Score Distribution and Mean (Vertical Line)")

		ggsave(filename = paste("./Plots/", state, ifelse(grade=="EOCT", "_", paste0("_Grade_", grade, "_")), ca.name, "_SS.pdf", sep=""), plot=p, device = "pdf", width = 6, height = 4, units = "in")
		}

		###   SGP Versions by State/Content Area/Grade
		if (nrow(tmp.data.state[YEAR %in% "2019" & !is.na(ALT),]) > 100){
		# tmp.tbl <- table(tmp.data.state[YEAR %in% c("2018", "2019"), YEAR, !is.na(ALL)])
		# if (any(tmp.tbl[2,]==0)) message(paste(state.name, "and PARCC SGPs:", ifelse(grade=="EOCT", "", paste("Grade", grade)), ca.name, "NOT PRESENT"))
		if (!(grade %in% 9 & state %in% c("DC")) | !(grade %in% 11 & state %in% c("IL"))) {
		c.17 <- paste("'17", ifelse(state %in%c("MD", "DC", "DD"), "Flagship", "ABO"))
		c.18 <- paste("'18", ifelse(state %in%c("MD", "DC", "DD"), "Flagship", "ABO"))
		c.19 <- paste("'19", ifelse(state %in%c("MD", "DC", "DD"), "Flagship", "ABO"))

		year.count <- 1; my.linetype <- NA
		p <- ggplot()+
			ggtitle(paste(state.name, "Consortium SGPs:", ifelse(grade=="EOCT", "", paste("Grade", grade)), ca.name)) +
			theme(plot.title = element_text(size=14, face="bold.italic")) +
			scale_color_manual(values = my.colors2)
		if ("2017" %in% tmp.data.state$YEAR & any(!is.na(tmp.data.state[YEAR == "2017", ALT]))) {
			p <- p + geom_density(data = tmp.data.state[YEAR == "2017"], aes(ALL, color= "'17 Full"), size=1.1)
			p <- p + geom_density(data = tmp.data.state[YEAR == "2017"], aes(ALT, color= c.17), size=1.1, linetype="dashed")
			p <- p + geom_vline(xintercept = median(tmp.data.state[YEAR == "2017", ALL], na.rm=T), size=1.1, color = my.colors2[2])
			p <- p + geom_vline(xintercept = median(tmp.data.state[YEAR == "2017", ALT], na.rm=T), size=1.1, linetype="dashed", color = my.colors2[1])
			year.count <- year.count + 1; my.linetype <- c("dashed", "solid") # follows factor order (ABO, Flagship, PARCC), not timing order
		}
		if ("2018" %in% tmp.data.state$YEAR & any(!is.na(tmp.data.state[YEAR == "2018", ALT]))) {
			p <- p + geom_density(data = tmp.data.state[YEAR == "2018"], aes(ALL, color= "'18 Full"), size=1.1)
			p <- p + geom_density(data = tmp.data.state[YEAR == "2018"], aes(ALT, color= c.18), size=1.1, linetype="dashed")
			p <- p + geom_vline(xintercept = median(tmp.data.state[YEAR == "2018", ALL], na.rm=T), size=1.1, color = my.colors2[4]) #[length(my.colors2)-(2+clength)])
			p <- p + geom_vline(xintercept = median(tmp.data.state[YEAR == "2018", ALT], na.rm=T), linetype="dashed", size=1.1, color = my.colors2[3]) #[length(my.colors2)-(3+clength)])
			year.count <- year.count + 1; my.linetype <- c(my.linetype, c("dashed", "solid"))
		}
		p <- p + geom_density(data = tmp.data.state[YEAR == "2019"], aes(ALL, color= "'19 Full"), size=1.1)
		p <- p + geom_density(data = tmp.data.state[YEAR == "2019"], aes(ALT, color= c.19), size=1.1, linetype="dashed")
		if (any(!is.na(tmp.data.state$ABOL))) {
			p <- p + geom_density(data = tmp.data.state[YEAR == "2019"], aes(ABOL, color= "'19 ABO Lite"), size=1.1, linetype="dotted")
			p <- p + geom_vline(xintercept = median(tmp.data.state[YEAR == "2019", ABOL], na.rm=T), size=1.1, linetype="dotted", color = my.colors2[6])
			my.linetype <- c(my.linetype, c("dashed", "dotted", "solid"))
		} else my.linetype <- c(my.linetype, c("dashed", "solid"))
		p <- p + geom_vline(xintercept = median(tmp.data.state[YEAR == "2019", ALL], na.rm=T), size=1.1, color = my.colors2[length(my.colors2)])
		p <- p + geom_vline(xintercept = median(tmp.data.state[YEAR == "2019", ALT], na.rm=T), linetype="dashed", size=1.1, color = my.colors2[length(my.colors2)-(1+clength)])

		p <- p + scale_x_continuous(name="SGP Distribution and Median (Vertical Line)")
		p <- p + guides(color = guide_legend(override.aes = list(linetype=my.linetype[!is.na(my.linetype)]), title = "SGP Versions"))
		ggsave(filename = paste("./Plots/", state, ifelse(grade=="EOCT", "_", paste0("_Grade_", grade, "_")), ca.name, "_SGP.pdf", sep=""), plot=p, device = "pdf", width = 6, height = 4, units = "in")
	}} else {
			if ((grade=="EOCT" & content.area %in% c("ALGEBRA_I", "ALGEBRA_II", "GEOMETRY")) | (grade!="EOCT" & content.area=="ELA") | (!grade %in% c(9:11,"EOCT") & content.area=="MATHEMATICS")) {
				message(paste(state.name, "and Consortium SGPs:", ifelse(grade=="EOCT", "", paste("Grade", grade)), ca.name, "NOT PRESENT"))
			}
		}
	}} # grade / content.area
} # state


###  GoFit Plots ???

content.area <- "ELA"
grade <- "6"

setwd("Plots")

for (content.area in c("ELA", "MATHEMATICS")) { # , "ALGEBRA_I", "ALGEBRA_II", "GEOMETRY")) {
for (grade in c(4, 5, 6, 7, 8, 10)) { #, "EOCT")) {
	dat <- PARCC_Consortiums[Sub_Consortium == "Flagship" & GRADE == grade & CONTENT_AREA == content.area,]
	setnames(dat, "ALL", "Consortium SGP - Flagship Subset")
	if (nrow(dat[YEAR %in% c("2019") & !is.na(`Consortium SGP - Flagship Subset`),]) > 100) {
		gofSGP(dat, state="PARCC", years='2019', content_areas=content.area, use.sgp="Consortium SGP - Flagship Subset", ceiling.floor = FALSE, output.format="PNG")
		file.rename(
			paste0("Goodness_of_Fit/", content.area, ".2019/gofSGP_Grade_", grade, ".png"),
			paste0("Goodness_of_Fit/", content.area, ".2019/gofSGP_Grade_", grade, "_Flag.png"))

		dat <- PARCC_Consortiums[Sub_Consortium == "ABO" & GRADE == grade & CONTENT_AREA == content.area,]
		setnames(dat, "ALL", "Consortium SGP - A.B.O. Subset")

		gofSGP(dat, state="PARCC", years='2019', content_areas=content.area, use.sgp="Consortium SGP - A.B.O. Subset", ceiling.floor = FALSE, output.format="PNG")
		file.rename(
				paste0("Goodness_of_Fit/", content.area, ".2019/gofSGP_Grade_", grade, ".png"),
				paste0("Goodness_of_Fit/", content.area, ".2019/gofSGP_Grade_", grade, "_ABO.png"))
	}
}}

setwd("..")
