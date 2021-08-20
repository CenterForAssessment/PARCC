load("/Users/avi/Dropbox (SGP)/SGP/PARCC/Illinois/Data/Archive/2020_2021.2/Illinois_SGP_LONG_Data.Rdata")

require(SGP)
require(VIM)
require(cfaTools)
require(data.table)

fixThetaRange <- function(x) {
  shrunk.range <- extendrange(x[abs(x)!=15])
  x[x==-15] <- shrunk.range[1]
  x[x==15] <- shrunk.range[2]
  x
}

###   Look at missingness related to prior scale scores and demographics.

Illinois_SGP_LONG_Data <- Illinois_SGP_LONG_Data[YEAR != "2019_2020.2"]
Illinois_SGP_LONG_Data[, YEAR := factor(YEAR)]
levels(Illinois_SGP_LONG_Data$YEAR) <- c("2018", "2019", "2021")

###   Fix stupid range of PARCC Theta
Illinois_SGP_LONG_Data[, SCALE_SCORE := fixThetaRange(SCALE_SCORE), keyby = c("CONTENT_AREA", "GRADE")]
Illinois_SGP_LONG_Data[, as.list(round(summary(SCALE_SCORE), 3)), keyby = c("CONTENT_AREA", "GRADE")]

vars.to.get <- c("VALID_CASE", "GRADE", "SCALE_SCORE", "SCALE_SCORE_ACTUAL", "ACHIEVEMENT_LEVEL",
                 "EconomicDisadvantageStatus", "FederalRaceEthnicity", "EnglishLearnerEL", "StudentWithDisabilities", "Sex",
                 "AccountableDistrictCode", "AccountableSchoolCode")

wide_data <- dcast(Illinois_SGP_LONG_Data[YEAR %in% c("2018", "2019", "2021") & VALID_CASE =="VALID_CASE"],
                  ID + CONTENT_AREA ~ YEAR, sep=".", drop=FALSE, value.var=vars.to.get)

##    Trim things down - remove cases with NAs in 2 most recent years and fill in some missing info (partial.fill)
# wide_data <- wide_data[!(is.na(SCALE_SCORE.2019) & is.na(SCALE_SCORE.2021))]

table(wide_data[, GRADE.2018], exclude=NULL)
wide_data[is.na(GRADE.2018), GRADE.2018 := as.numeric(GRADE.2019)-1L]
wide_data[is.na(GRADE.2018), GRADE.2018 := as.numeric(GRADE.2021)-3L]
table(wide_data[, GRADE.2018], exclude=NULL) # some non-sensical GRADE values we'll get rid of later

table(wide_data[, GRADE.2019], exclude=NULL)
wide_data[is.na(GRADE.2019), GRADE.2019 := as.numeric(GRADE.2018)+1L]
wide_data[is.na(GRADE.2019), GRADE.2019 := as.numeric(GRADE.2021)-2L]
table(wide_data[, GRADE.2019], exclude=NULL) # some non-sensical GRADE values we'll get rid of later

table(wide_data[, GRADE.2021], exclude=NULL)
wide_data[is.na(GRADE.2021), GRADE.2021 := as.numeric(GRADE.2019)+2L]
wide_data[is.na(GRADE.2021), GRADE.2021 := as.numeric(GRADE.2018)+3L]
table(wide_data[, GRADE.2021], exclude=NULL) # some non-sensical GRADE values we'll get rid of later

wide_data[!GRADE.2021 %in% 3:8, GRADE.2021 := NA]
wide_data[!GRADE.2019 %in% 3:8, GRADE.2019 := NA]
wide_data[!GRADE.2018 %in% 3:8, GRADE.2018 := NA]

#####
###   Plots
#####

plot_directory <- "Data/Imputation/VIM_Plots"
if (!dir.exists(plot_directory)) dir.create(plot_directory, recursive=TRUE)

svg(file.path(plot_directory, "SS_Histograms-All_Grades.svg"))
par(mfrow = c(2, 2))
# 2019
histMiss(as.data.frame(wide_data[GRADE.2019 %in% 4:8, c("SCALE_SCORE_ACTUAL.2018", "SCALE_SCORE_ACTUAL.2019")]),
         main = "Missing 2019 - All 2018 Priors", breaks=50, interactive=FALSE, only.miss=FALSE)
abline(v=proficiency.cut.ss, col="green", lwd=2)

histMiss(as.data.frame(wide_data[GRADE.2019 %in% 4:8, c("SCALE_SCORE.2018", "SCALE_SCORE.2019")]),
         main = "Missing 2019 - Theta Scale", breaks=50, interactive=FALSE, only.miss=FALSE)
abline(v=0, col="green", lwd=2)

# 2021
histMiss(as.data.frame(wide_data[GRADE.2021 %in% 5:8, c("SCALE_SCORE_ACTUAL.2019", "SCALE_SCORE_ACTUAL.2021")]),
         main = "Missing 2021 - All 2019 Priors", breaks=50, interactive=FALSE, only.miss=FALSE)
abline(v=proficiency.cut.ss, col="green", lwd=2)

histMiss(as.data.frame(wide_data[GRADE.2021 %in% 5:8, c("SCALE_SCORE.2019", "SCALE_SCORE.2021")]),
         main = "Missing 2021 - Theta Scale", breaks=50, interactive=FALSE, only.miss=FALSE)
abline(v=0, col="green", lwd=2)
dev.off()


proficiency.cut <- SGPstateData[["IL"]][["Achievement"]][["Cutscores"]][["ELA"]][["GRADE_4"]][3]
proficiency.cut.ss <- SGPstateData[["IL"]][["Achievement"]][["Cutscores"]][["ELA_SS"]][["GRADE_4"]][3]

svg(file.path(plot_directory, "SS_Histograms_G5_ELA.svg"))
par(mfrow = c(2, 2))
# 2019
histMiss(as.data.frame(wide_data[GRADE.2019 == 5 & CONTENT_AREA == "ELA", c("SCALE_SCORE_ACTUAL.2018", "SCALE_SCORE_ACTUAL.2019")]),
         main = "Missing 2019 - All 2018 Priors", breaks=50, interactive=FALSE, only.miss=FALSE)
abline(v=proficiency.cut.ss, col="green", lwd=2)

histMiss(as.data.frame(wide_data[GRADE.2019 == 5 & CONTENT_AREA == "ELA", c("SCALE_SCORE.2018", "SCALE_SCORE.2019")]),
         main = "Missing 2019 - Theta Scale", breaks=50, interactive=FALSE, only.miss=FALSE)
abline(v=proficiency.cut, col="green", lwd=2)

# 2021
histMiss(as.data.frame(wide_data[GRADE.2021 == 5 & CONTENT_AREA == "ELA", c("SCALE_SCORE_ACTUAL.2019", "SCALE_SCORE_ACTUAL.2021")]),
         main = "Missing 2021 - All 2019 Priors", breaks=50, interactive=FALSE, only.miss=FALSE)
abline(v=proficiency.cut.ss, col="green", lwd=2)

histMiss(as.data.frame(wide_data[GRADE.2021 == 5 & CONTENT_AREA == "ELA", c("SCALE_SCORE.2019", "SCALE_SCORE.2021")]),
         main = "Missing 2021 - Theta Scale", breaks=50, interactive=FALSE, only.miss=FALSE)
abline(v=proficiency.cut, col="green", lwd=2)
dev.off()


# marginplot(as.data.frame(wide_data[, c("SCALE_SCORE.2019", "SCALE_SCORE.2021")]))
# scattmatrixMiss(as.data.frame(wide_data[, c("SCALE_SCORE.2018", "SCALE_SCORE.2019", "SCALE_SCORE.2021")]), interactive=FALSE)

scattmatrixMiss(as.data.frame(wide_data[GRADE.2021 %in% 5, c("SCALE_SCORE.2019", "SCALE_SCORE.2021")]), interactive=FALSE)
marginplot(as.data.frame(wide_data[GRADE.2021 %in% 5, c("SCALE_SCORE.2019", "SCALE_SCORE.2021")]))
marginplot(as.data.frame(wide_data[GRADE.2019 %in% 5, c("SCALE_SCORE.2018", "SCALE_SCORE.2019")]))

scattmatrixMiss(as.data.frame(wide_data[GRADE.2021 %in% 8, c("SCALE_SCORE.2018", "SCALE_SCORE.2019", "SCALE_SCORE.2021")]), interactive=FALSE)

##    "EconomicDisadvantageStatus", "FederalRaceEthnicity", "EnglishLearnerEL", "StudentWithDisabilities", "Sex",

spineMiss(as.data.frame(wide_data[, c("ACHIEVEMENT_LEVEL.2019", "SCALE_SCORE.2021")]), interactive=FALSE, only.miss=FALSE)
spineMiss(as.data.frame(wide_data[, c("ACHIEVEMENT_LEVEL.2018", "SCALE_SCORE.2019")]), interactive=FALSE, only.miss=FALSE)
spineMiss(as.data.frame(wide_data[, c("FederalRaceEthnicity.2019", "SCALE_SCORE.2021")]), interactive=FALSE, only.miss=FALSE)
spineMiss(as.data.frame(wide_data[, c("StudentWithDisabilities.2019", "SCALE_SCORE.2021")]), interactive=FALSE, only.miss=FALSE)
spineMiss(as.data.frame(wide_data[, c("EconomicDisadvantageStatus.2019", "SCALE_SCORE.2021")]), interactive=FALSE, only.miss=FALSE)


histMiss(as.data.frame(wide_data[!is.na(SGP.2020) & GRADE.2021 %in% 1:5, c("SGP.2020", "SCALE_SCORE.2021")]), breaks=25, interactive=FALSE, only.miss=FALSE)
histMiss(as.data.frame(wide_data[!is.na(SGP.2020) & GRADE.2021 %in% 6:8, c("SGP.2020", "SCALE_SCORE.2021")]), breaks=25, interactive=FALSE, only.miss=FALSE)
histMiss(as.data.frame(wide_data[!is.na(SGP.2020) & GRADE.2021 %in% 9:12, c("SGP.2020", "SCALE_SCORE.2021")]), breaks=25, interactive=FALSE, only.miss=FALSE)

spineMiss(as.data.frame(wide_data[GRADE.2021 %in% 1:5, c("ACHIEVEMENT_LEVEL.2020", "SCALE_SCORE.2021")]), interactive=FALSE, only.miss=FALSE)
spineMiss(as.data.frame(wide_data[GRADE.2021 %in% 6:8, c("ACHIEVEMENT_LEVEL.2020", "SCALE_SCORE.2021")]), interactive=FALSE, only.miss=FALSE)
spineMiss(as.data.frame(wide_data[GRADE.2021 %in% 9:12, c("ACHIEVEMENT_LEVEL.2020", "SCALE_SCORE.2021")]), interactive=FALSE, only.miss=FALSE)

mosaicMiss(as.data.frame(wide_data[GRADE.2021 == 5, c("EconomicDisadvantageStatus.2019", "ACHIEVEMENT_LEVEL.2019", "SCALE_SCORE.2021")]),
           highlight = 3, plotvars = 1:2, miss.labels = FALSE)

mosaicMiss(as.data.frame(wide_data[GRADE.2021 == 5, c("EconomicDisadvantageStatus.2019", "FederalRaceEthnicity.2019", "SCALE_SCORE.2021")]),
          highlight = 3, plotvars = 1:2, miss.labels = FALSE)

spineMiss(as.data.frame(wide_data[, c("FREE_REDUCED_LUNCH_STATUS.2020", "SCALE_SCORE.2021")]), interactive=FALSE, only.miss=FALSE)



svg(file.path(plot_directory, "IL_Mosaic_AchLev_SES.svg"))
mosaicMiss(as.data.frame(wide_data[GRADE.2021 %in% 5:8, c("ACHIEVEMENT_LEVEL.2019", "EconomicDisadvantageStatus.2019", "SCALE_SCORE.2021")]),
           highlight = 3, plotvars = 1:2, miss.labels = FALSE)
dev.off()

svg(file.path(plot_directory, "IL_Mosaic_Ethn_SES.svg"))
mosaicMiss(as.data.frame(wide_data[GRADE.2021 %in% 5:8, c("FederalRaceEthnicity.2019", "EconomicDisadvantageStatus.2019", "SCALE_SCORE.2021")]),
          highlight = 3, plotvars = 1:2, miss.labels = FALSE, only.miss=FALSE)
dev.off()

svg(file.path(plot_directory, "IL_Mosaic_SwD_SES.svg"))
mosaicMiss(as.data.frame(wide_data[GRADE.2021 %in% 5:8, c("StudentWithDisabilities.2019", "EconomicDisadvantageStatus.2019", "SCALE_SCORE.2021")]),
          highlight = 3, plotvars = 1:2, miss.labels = FALSE, only.miss=FALSE)
dev.off()

svg(file.path(plot_directory, "IL_Mosaic_Gender_SES.svg"))
mosaicMiss(as.data.frame(wide_data[GRADE.2021 %in% 5:8, c("Sex.2019", "EconomicDisadvantageStatus.2019", "SCALE_SCORE.2021")]),
          highlight = 3, plotvars = 1:2, miss.labels = FALSE, only.miss=FALSE)
dev.off()




attrit_2021 <-
  wide_data[GRADE.2021 %in% 5:8 & !is.na(SCALE_SCORE.2019),
                .(Pct_Attrit = round(sum(is.na(VALID_CASE.2021))/.N, 3)*100,
                  Total_Attrit = sum(is.na(VALID_CASE.2021)),
                  Total_Enrolled = sum(!is.na(VALID_CASE.2021))),
               keyby = .(CONTENT_AREA, GRADE.2021)]
setnames(attrit_2021, 2, "GRADE")
attrit_2021[, YEAR := "2019_to_2021"]

attrit_2019 <-
  wide_data[GRADE.2019 %in% 5:8 & !is.na(SCALE_SCORE.2017),
               .(Pct_Attrit = round(sum(is.na(VALID_CASE.2019))/.N, 3)*100,
                 Total_Attrit = sum(is.na(VALID_CASE.2019)),
                 Total_Enrolled = sum(!is.na(VALID_CASE.2019))),
               keyby = .(CONTENT_AREA, GRADE.2019)]
setnames(attrit_2019, 2, "GRADE")
attrit_2019[, YEAR := "2017_to_2019"]

attrit_2018 <-
  wide_data[GRADE.2018 %in% 5:8 & !is.na(SCALE_SCORE.2016),
               .(Pct_Attrit = round(sum(is.na(VALID_CASE.2018))/.N, 3)*100,
                 Total_Attrit = sum(is.na(VALID_CASE.2018)),
                 Total_Enrolled = sum(!is.na(VALID_CASE.2018))),
               keyby = .(CONTENT_AREA, GRADE.2018)]
setnames(attrit_2018, 2, "GRADE")
attrit_2018[, YEAR := "2016_to_2018"]

attrit_wide <- dcast(rbindlist(list(attrit_2018, attrit_2019, attrit_2021)),
                  CONTENT_AREA + GRADE ~ YEAR, sep=".", value.var = c("Pct_Attrit", "Total_Attrit", "Total_Enrolled"))

Report_Analyses[["participation"]][[assessment]][["state_attrition"]] <- attrit_wide
