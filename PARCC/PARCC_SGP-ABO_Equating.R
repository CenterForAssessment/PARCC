##################################################################################
###                                                                            ###
###   SGP analysis script for PARCC ABO Form Equating Comparison - July 2019   ###
###                                                                            ###
##################################################################################

### Load Packages
require(data.table)

#####
###   Complete consortium SGPs
#####

load('/media/Data/PARCC/PARCC_Comp2/Data/Archive/2018_2019.2/PARCC_SGP_LONG_Data_2018_2019.2-EqV2.Rdata')
table(PARCC_SGP_LONG_Data_2018_2019.2[, StateAbbreviation, is.na(SGP)], exclude=NULL)

ABO_Equating <- PARCC_SGP_LONG_Data_2018_2019.2[CONTENT_AREA == "ELA",
												c(names(PARCC_SGP_LONG_Data_2018_2019.2)[c(1:6, 19, 8, 11, 16)],
												"SGP_NonEq", "SGP", "SGP_ORDER", "SGP_NOTE", "SGP_NORM_GROUP"), with=FALSE][grep("_SS", CONTENT_AREA, invert =TRUE),]

setkeyv(ABO_Equating, names(PARCC_SGP_LONG_Data_2018_2019.2)[c(1:6, 19, 8, 11, 16)])

ABO_Equating[, Most_Recent_Prior := as.character(NA)]
ABO_Equating[, Most_Recent_Prior := sapply(strsplit(as.character(SGP_NORM_GROUP), "; "), function(x) rev(x)[2])]

save(ABO_Equating, file="Data/ABO_Equating.rda")

# ABO_Equating[, Most_Recent_Prior := sapply(gsub("/", " ", Most_Recent_Prior), SGP::capwords)]
# ABO_Equating[, Most_Recent_Prior := gsub("2016 2017 2", "2017", Most_Recent_Prior)]
# ABO_Equating[, Most_Recent_Prior := gsub("2017 2018 2", "2018", Most_Recent_Prior)]
# ABO_Equating[, Most_Recent_Prior := gsub(" 8", " Grade 8", Most_Recent_Prior)]
# ABO_Equating[, Most_Recent_Prior := gsub(" 9", " Grade 9", Most_Recent_Prior)]
# ABO_Equating[, Most_Recent_Prior := gsub(" 10", " Grade 10", Most_Recent_Prior)]

smry.grd <- ABO_Equating[VALID_CASE == "VALID_CASE" & !is.na(SGP) & !is.na(SGP_NonEq),
	list(Mean__Equated= round(mean(SGP, na.rm=T), 1), Median__Equated= median(as.numeric(SGP), na.rm=T),
			 Mean__Pre_Equated=round(mean(SGP_NonEq, na.rm=T), 1), Median__Pre_Equated=median(as.numeric(SGP_NonEq),na.rm=T), N=.N),
	keyby=c("GRADE")]
smry.grd
smry.grd.preeq <- ABO_Equating[VALID_CASE == "VALID_CASE" & !is.na(SGP) & !is.na(SGP_NonEq) & StateAbbreviation %in% c("BI", "DD", "DC", "IL", "MD", "NM"),
	list(Mean__Equated= round(mean(SGP, na.rm=T), 1), Median__Equated= median(as.numeric(SGP), na.rm=T),
			 Mean__Pre_Equated=round(mean(SGP_NonEq, na.rm=T), 1), Median__Pre_Equated=median(as.numeric(SGP_NonEq),na.rm=T), N=.N),
	keyby=c("GRADE")]

smry.grd.st <- ABO_Equating[VALID_CASE == "VALID_CASE" & !is.na(SGP) & !is.na(SGP_NonEq),
	list(Mean__Equated= round(mean(SGP, na.rm=T), 1), Median__Equated= median(as.numeric(SGP), na.rm=T),
			 Mean__Pre_Equated=round(mean(SGP_NonEq, na.rm=T), 1), Median__Pre_Equated=median(as.numeric(SGP_NonEq),na.rm=T), N=.N),
	keyby=c("StateAbbreviation", "GRADE")] # , "Most_Recent_Prior"

diff.grd <- ABO_Equating[VALID_CASE == "VALID_CASE" & !is.na(SGP) & !is.na(SGP_NonEq), as.list(round(summary(SGP-SGP_NonEq),2)),
	keyby=c("GRADE")]
diff.grd[, Included_States := "All States"]

diff.grd.preeq <- ABO_Equating[VALID_CASE == "VALID_CASE" & !is.na(SGP) & !is.na(SGP_NonEq) & StateAbbreviation %in% c("BI", "DD", "DC", "IL", "MD", "NM"), as.list(round(summary(SGP-SGP_NonEq),2)),
	keyby=c("GRADE")]
diff.grd.preeq[, Included_States := "Non-Equated Subset"]

diff.grd <- rbind(diff.grd, diff.grd.preeq)
setcolorder(diff.grd, c(1, 8, 2:7))

diff.grd.st <- ABO_Equating[VALID_CASE == "VALID_CASE" & !is.na(SGP) & !is.na(SGP_NonEq), as.list(round(summary(SGP-SGP_NonEq),2)),
	keyby=c("StateAbbreviation", "GRADE")]

smry.grd[, GRADE := as.numeric(GRADE)]
diff.grd[, GRADE := as.numeric(GRADE)]
smry.grd.st[, GRADE := as.numeric(GRADE)]
diff.grd.st[, GRADE := as.numeric(GRADE)]

setkey(smry.grd)
setkey(diff.grd)
setkey(smry.grd.st)
setkey(diff.grd.st)
diff.grd.st[StateAbbreviation=="MD",]

diff.grd[smry.grd][ N > 999,]

smry.grd.st[StateAbbreviation=="MD" & N > 999,]

state.ela <- smry.grd.st[CONTENT_AREA == "ELA",]
parcc.ela <- smry.grd[CONTENT_AREA == "ELA",]

library(xlsx)
write.xlsx(parcc.ela, file="Consortium_Comparisons_Summaries.xlsx", sheetName="ELA_by_Consortium", showNA=FALSE)
write.xlsx(state.ela, file="Consortium_Comparisons_Summaries.xlsx", sheetName="ELA_by_State", append=TRUE, showNA=FALSE)
# write.xlsx(parcc.math, file="Consortium_Comparisons_Summaries.xlsx", sheetName="Math_by_Consortium", append=TRUE, showNA=FALSE)
# write.xlsx(state.math, file="Consortium_Comparisons_Summaries.xlsx", sheetName="Math_by_State", append=TRUE, showNA=FALSE)
# write.xlsx(parcc.eoct, file="Consortium_Comparisons_Summaries.xlsx", sheetName="EOCT_by_Consortium", append=TRUE, showNA=FALSE)
# write.xlsx(state.eoct, file="Consortium_Comparisons_Summaries.xlsx", sheetName="EOCT_by_State", append=TRUE, showNA=FALSE)
#

#####
#####   Equating Analysis Plotting Data
#####

require(ggplot2)
require(data.table)

my.colors <- c("#FF3333", "#6666FF") # "darkred", "darkblue"
ca.name <- "ELA"

for (state in c("BI", "DD", "DC", "IL", "MD", "NJ", "NM")) {
	state.name <- gsub("_", " ", SGP::getStateAbbreviation(state, type="State"))

	tmp.data.parcc <- ABO_Equating[VALID_CASE == "VALID_CASE" & GRADE != 3 & StateAbbreviation == state, list(SGP, SGP_NonEq, GRADE)]
	tmp.data.parcc <- tmp.data.parcc[GRADE %in% as.numeric(names(table(tmp.data.parcc[, GRADE]))[table(tmp.data.parcc[, GRADE]) > 100])]
	if (state == "DD") tmp.data.parcc <- tmp.data.parcc[GRADE %in% 7:8]

	tmp.data.parcc[, GRADE := as.numeric(GRADE)]
	setkey(tmp.data.parcc)

	p <- ggplot() +
		scale_colour_manual(values = my.colors) +
		ggtitle(paste(state.name, "ELA SGPs with Pre- and Post-Equating:")) +
		theme(plot.title = element_text(size=12, face="bold.italic"))
	p <- p + facet_wrap( ~ GRADE, ncol=2)

	p <- p + geom_density(data = tmp.data.parcc, aes(SGP, colour= "Post-Equated"))
	p <- p + geom_density(data = tmp.data.parcc, aes(SGP_NonEq, colour= "Pre-Equated"))
	p <- p + geom_vline(xintercept = mean(tmp.data.parcc[, SGP], na.rm=T), color = my.colors[1])
	p <- p + geom_vline(xintercept = mean(tmp.data.parcc[, SGP_NonEq], na.rm=T), color = my.colors[2])
	p <- p + scale_x_continuous(name="SGP Distribution and Mean (Vertical Line)")
	p <- p + guides(colour = guide_legend(title = "Test Used"))

	ggsave(filename = paste("./Plots/", state, "_Equating_SGPs.pdf", sep=""), plot=p, device = "pdf", width = 7, height = 5, units = "in")
}
