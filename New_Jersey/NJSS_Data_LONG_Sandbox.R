setwd("/Users/avi/Dropbox (SGP)/SGP/PARCC")
load("./New_Jersey/Data/Archive/2018_2019.2/New_Jersey_Data_LONG_2018_2019.2.Rdata")

NJSS_Data_LONG_2021_2022.1[, ReportingConcept1MaxScore := as.numeric(ReportingConcept1MaxScore)]
NJSS_Data_LONG_2021_2022.1[, ReportingConcept2MaxScore := as.numeric(ReportingConcept2MaxScore)]
NJSS_Data_LONG_2021_2022.1[, ReportingConcept3MaxScore := as.numeric(ReportingConcept3MaxScore)]
NJSS_Data_LONG_2021_2022.1[, ReportingConcept4MaxScore := as.numeric(ReportingConcept4MaxScore)]

NJSS_Data_LONG_2021_2022.1[, Concept1_Pct := ReportingConcept1RawScore/ReportingConcept1MaxScore]
NJSS_Data_LONG_2021_2022.1[, Concept2_Pct := ReportingConcept2RawScore/ReportingConcept2MaxScore]
NJSS_Data_LONG_2021_2022.1[, Concept3_Pct := ReportingConcept3RawScore/ReportingConcept3MaxScore]
NJSS_Data_LONG_2021_2022.1[, Concept4_Pct := ReportingConcept4RawScore/ReportingConcept4MaxScore]


######
######
######

table(NJSS_Data_LONG_2021_2022.1[, AssessmentGrade, TestCode])
table(NJSS_Data_LONG_2021_2022.1[, GradeLevelWhenAssessed, TestCode])

table(NJSS_Data_LONG_2021_2022.1[, EconomicDisadvantageStatus])
table(NJSS_Data_LONG_2021_2022.1[, StudentWithDisabilities])
# FederalRaceEthnicity # yes


table(NJSS_Data_LONG_2021_2022.1[, AssessmentGrade, TestStatus])
table(NJSS_Data_LONG_2021_2022.1[, AssessmentGrade, TestAttemptednessFlag])
NJSS_Data_LONG_2021_2022.1[!is.na(SCALE_SCORE_ACTUAL), as.list(summary(SCALE_SCORE_ACTUAL)), keyby = c("TestStatus", "TestAttemptednessFlag")] #

table(NJSS_Data_LONG_2021_2022.1[, AssessmentGrade, NotTestedReason])
NJSS_Data_LONG_2021_2022.1[!is.na(SCALE_SCORE_ACTUAL), as.list(summary(SCALE_SCORE_ACTUAL)), keyby = c("NotTestedReason")] # Any 'NotTestedReason' -> NA score
NJSS_Data_LONG_2021_2022.1[!is.na(SCALE_SCORE_ACTUAL), as.list(summary(SCALE_SCORE_ACTUAL)), keyby = c("VoidScoreCode", "VoidScoreReason")]
NJSS_Data_LONG_2021_2022.1[, .(.N), keyby = c("VoidScoreReason")]

table(NJSS_Data_LONG_2021_2022.1[, VoidScoreCode, NotTestedCode]) # VALID_CASE
table(NJSS_Data_LONG_2021_2022.1[, VoidScoreReason, NotTestedReason])
table(NJSS_Data_LONG_2021_2022.1[VoidScoreReason == "" & NotTestedReason == "", TestAttemptednessFlag])

NJSS_Data_LONG_2021_2022.1[, PCT_ATTMPT := as.numeric(TotalTestItemsAttempted)/as.numeric(TotalTestItems)]
NJSS_Data_LONG_2021_2022.1[!is.na(SCALE_SCORE_ACTUAL), as.list(summary(PCT_ATTMPT)), keyby = c("VoidScoreReason")]

# Valid Case inspection
NJSS_Data_LONG_2021_2022.1[VoidScoreReason == "" & NotTestedReason == "" & TestAttemptednessFlag == "N", as.list(summary(as.numeric(PCT_ATTMPT))), keyby = c("AssessmentGrade")] #
table(NJSS_Data_LONG_2021_2022.1[, VoidScoreCode, NotTestedCode]) # VALID_CASE
table(NJSS_Data_LONG_2021_2022.1[, .(VoidScoreCode, TestAttemptednessFlag), NotTestedCode]) # VALID_CASE

NJSS_Data_LONG_2021_2022.1[!is.na(SCALE_SCORE_ACTUAL), as.list(summary(SCALE_SCORE_ACTUAL)), keyby = c("VALID_CASE")]

table(NJSS_Data_LONG_2021_2022.1[, !is.na(SCALE_SCORE_ACTUAL), VALID_CASE])
table(NJSS_Data_LONG_2021_2022.1[, .(TestCode, !is.na(SCALE_SCORE_ACTUAL)), VALID_CASE])
round(prop.table(table(NJSS_Data_LONG_2021_2022.1[, .(TestCode, !is.na(SCALE_SCORE_ACTUAL)), VALID_CASE]), 2)*100, 1)
round(prop.table(table(NJSS_Data_LONG_2021_2022.1[!is.na(SCALE_SCORE_ACTUAL), TestCode, VALID_CASE]), 2)*100, 1)
round(prop.table(table(NJSS_Data_LONG_2021_2022.1[, TestCode, VALID_CASE]), 2)*100, 1) # Overall (assigned/missing & administered)

hist(NJSS_Data_LONG_2021_2022.1[VALID_CASE == "VALID_CASE" & TestCode == "ELA05", SCALE_SCORE_ACTUAL], breaks = 35)
hist(NJSS_Data_LONG_2021_2022.1[VALID_CASE == "VALID_CASE" & TestCode == "ALG01", SCALE_SCORE_ACTUAL], breaks = 35)



##  Principal Components Analysis inspection
NJSS_Data_LONG_2021_2022.1[, as.list(summary(as.numeric(ReportingConcept1RawScore))), keyby = "TestCode"]
NJSS_Data_LONG_2021_2022.1[, as.list(summary(as.numeric(ReportingConcept2RawScore))), keyby = "TestCode"]
NJSS_Data_LONG_2021_2022.1[, as.list(summary(as.numeric(ReportingConcept3RawScore))), keyby = "TestCode"]
NJSS_Data_LONG_2021_2022.1[, as.list(summary(as.numeric(ReportingConcept4RawScore))), keyby = "TestCode"]

hist(NJSS_Data_LONG_2021_2022.1[VALID_CASE == "VALID_CASE" & TestCode == "MAT05", SCALE_SCORE_ACTUAL], breaks = 35)
hist(NJSS_Data_LONG_2021_2022.1[VALID_CASE == "VALID_CASE" & TestCode == "MAT05", as.numeric(ReportingConcept1RawScore)], breaks = 35)
hist(NJSS_Data_LONG_2021_2022.1[VALID_CASE == "VALID_CASE" & TestCode == "MAT05", as.numeric(ReportingConcept2RawScore)], breaks = 35)
hist(NJSS_Data_LONG_2021_2022.1[VALID_CASE == "VALID_CASE" & TestCode == "MAT05", as.numeric(ReportingConcept3RawScore)], breaks = 35)
hist(NJSS_Data_LONG_2021_2022.1[VALID_CASE == "VALID_CASE" & TestCode == "MAT05", as.numeric(ReportingConcept4RawScore)], breaks = 35)


njm5 <- NJSS_Data_LONG_2021_2022.1[VALID_CASE == "VALID_CASE" & TestCode == "MAT05",]
plot(njm5[, ReportingConcept1RawScore, ReportingConcept3RawScore])
plot(jitter(as.numeric(njm5[, ReportingConcept1RawScore])), jitter(as.numeric(njm5[, ReportingConcept3RawScore])))

pca.m5 <- princomp(njm5[, .(ReportingConcept1RawScore, ReportingConcept2RawScore, ReportingConcept3RawScore, ReportingConcept4RawScore)])
pca.m5b <- princomp(njm5[, .(Concept1_Pct, Concept2_Pct, Concept3_Pct, Concept4_Pct)])

pca.m5x <- princomp(njm5[, .(PCT_ATTMPT, ReportingConcept1RawScore, ReportingConcept2RawScore, ReportingConcept3RawScore, ReportingConcept4RawScore)])

require(psych)
pca.m5p <- principal(njm5[, .(ReportingConcept1RawScore, ReportingConcept2RawScore, ReportingConcept3RawScore, ReportingConcept4RawScore)], nfactors = 1)
# pca.m5p2 <- principal(njm5[, .(ReportingConcept1RawScore, ReportingConcept2RawScore, ReportingConcept3RawScore, ReportingConcept4RawScore)], nfactors = 2)

summary(pca.m5$scores)
plot(pca.m5$scores[,1], jitter(njm5$SCALE_SCORE_ACTUAL))
cor(pca.m5$scores[,1], njm5$SCALE_SCORE_ACTUAL)

hist(pca.m5$scores[,1], breaks = 50)
hist(as.numeric(njm5$SCALE_SCORE_ACTUAL))

hist(pca$scores[,1] * as.numeric(njm5$SCALE_SCORE_ACTUAL))

nje5 <- NJSS_Data_LONG_2021_2022.1[VALID_CASE == "VALID_CASE" & TestCode == "ELA05",]
pca.e <- princomp(nje5[, .(ReportingConcept1RawScore, ReportingConcept2RawScore)])
pca.eb <- princomp(nje5[, .(Concept1_Pct, Concept2_Pct)])
plot(pca.e$scores[,1], jitter(as.numeric(nje5$SCALE_SCORE_ACTUAL)))
length(unique(pca.e$scores[,1]))
cor(pca.e$scores[,1], as.numeric(nje5$SCALE_SCORE_ACTUAL))

hist(pca.e$scores[,1], breaks = 35)
hist(as.numeric(nje5$SCALE_SCORE_ACTUAL))

NJSS_Data_LONG_2021_2022.1[, SCALE_SCORE1 := princompLong(.SD, vars_to_use = component.scores, digits=1), by = list(TestCode), .SDcols = c("VALID_CASE", component.scores)]
NJSS_Data_LONG_2021_2022.1[, SCALE_SCORE2 := princompLong(.SD, vars_to_use = component.scores, digits=2), by = list(TestCode), .SDcols = c("VALID_CASE", component.scores)]
NJSS_Data_LONG_2021_2022.1[, SCALE_SCORE4 := princompLong(.SD, vars_to_use = component.scores), by = list(TestCode), .SDcols = c("VALID_CASE", component.scores)] # WINNER! - Just do rounding later.
NJSS_Data_LONG_2021_2022.1[, SCALE_SCOREX := round(SCALE_SCORE4, 1)]

NJSS_Data_LONG_2021_2022.1[, as.list(summary(SCALE_SCORE)), keyby = c("TestCode")] #
tbl <- NJSS_Data_LONG_2021_2022.1[VALID_CASE=="VALID_CASE", as.list(summary(SCALE_SCORE)), keyby = c("TestCode", "SupportLevel")] #

NJSS_Data_LONG_2021_2022.1[, list(UNIQUE_PCA4 = length(unique(SCALE_SCORE4)),
          COR_PCA4 = cor(SCALE_SCORE_ACTUAL, SCALE_SCORE4, use='na.or.complete'),
          UNIQUE_PCA2 = length(unique(SCALE_SCORE2)),
          COR_PCA2 = cor(SCALE_SCORE_ACTUAL, SCALE_SCORE2, use='na.or.complete'),
          UNIQUE_PCA1 = length(unique(SCALE_SCORE1)),
          COR_PCA1 = cor(SCALE_SCORE_ACTUAL, SCALE_SCOREX, use='na.or.complete'),
          UNIQUE_PCAX = length(unique(SCALE_SCORE1)),
          COR_PCAX = cor(SCALE_SCORE_ACTUAL, SCALE_SCOREX, use='na.or.complete'),
          UNIQUE_PCA = length(unique(SCALE_SCORE)),
          COR_PCA = cor(SCALE_SCORE_ACTUAL, SCALE_SCORE, use='na.or.complete')), keyby = c("TestCode")] #

table(NJSS_Data_LONG_2021_2022.1[, VALID_CASE, is.na(SCALE_SCORE)])

plot(NJSS_Data_LONG_2021_2022.1[TestCode == "MAT04", SCALE_SCORE_ACTUAL, SCALE_SCORE])
plot(NJSS_Data_LONG_2021_2022.1[TestCode == "MAT07", SCALE_SCORE_ACTUAL, SCALE_SCORE])
plot(NJSS_Data_LONG_2021_2022.1[TestCode == "ELA04", SCALE_SCORE_ACTUAL, SCALE_SCORE])
plot(NJSS_Data_LONG_2021_2022.1[TestCode == "ELA07", SCALE_SCORE_ACTUAL, SCALE_SCORE])
plot(NJSS_Data_LONG_2021_2022.1[TestCode == "ALG01", SCALE_SCORE_ACTUAL, SCALE_SCORE])
plot(NJSS_Data_LONG_2021_2022.1[TestCode == "GEO01", SCALE_SCORE_ACTUAL, SCALE_SCORE])
plot(NJSS_Data_LONG_2021_2022.1[TestCode == "ALG02", SCALE_SCORE_ACTUAL, SCALE_SCORE])


NJSS_Data_LONG_2021_2022.1[TestCode == "ELA06" & SupportLevel != "", list(min(SCALE_SCORE_ACTUAL)), keyby = "SupportLevel"]
nje6 <- NJSS_Data_LONG_2021_2022.1[VALID_CASE == "VALID_CASE" & TestCode == "ELA06",]

tmp.lm <- lm(SCALE_SCORE ~ SCALE_SCORE_ACTUAL, data = nje6)

tmp.dt <- nje6[SupportLevel != "", list(
            MIN = min(SCALE_SCORE_ACTUAL),
            MAX = max(SCALE_SCORE_ACTUAL)), keyby = "SupportLevel"]
tmp.dt[1,2] <- as.numeric(floor(tmp.dt[1,3,]/2))
tmp.cuts <- data.table(SCALE_SCORE_ACTUAL = c(unlist(floor(tmp.dt[1,3,]/2)), unlist(tmp.dt[2:3,2]), ceiling(mean(unlist(c(tmp.dt[3,2], tmp.dt[3,3]))))))
round(predict(tmp.lm, tmp.cuts), digits)


setnames(NJSS_Data_LONG_2021_2022.1, c("SCALE_SCORE", "ACHIEVEMENT_LEVEL"), c("SCALE_SCORE_1", "ACHIEVEMENT_LEVEL_1"))
component.scores2 <- c("Concept1_Pct", "Concept1_Pct", "Concept1_Pct", "Concept4_Pct")
NJSS_Data_LONG_2021_2022.1[, SCALE_SCORE := princompLong(.SD, vars_to_use = component.scores2, digits=1), by = list(TestCode), .SDcols = c("VALID_CASE", component.scores2)] # Winner by Occam's Razor
NJSS_Data_LONG_2021_2022.1[, ACHIEVEMENT_LEVEL := getCutsNJSS(.SD, digits=1), by = list(TestCode), .SDcols = c("SCALE_SCORE", "SCALE_SCORE_ACTUAL", "SupportLevel")]
table(NJSS_Data_LONG_2021_2022.1[, ACHIEVEMENT_LEVEL_1, SupportLevel])
table(NJSS_Data_LONG_2021_2022.1[, ACHIEVEMENT_LEVEL, SupportLevel]) # Way worse!


###   Ranked RAW/Count
###   Create PCA based Quantiles within Raw/Count Scores to provide more distinctions,
###   while keeping the Raw score ranking (avoid overlap between PCA and Raw scores)

source("/Users/avi/Dropbox (SGP)/SGP/State_Alt_Analyses/Universal_Content/Learning_Loss_Analysis/Functions/Quantile_Cut_Functions.R")

##    Have to add in SCALE_SCORE_ACTUAL consideration
getFCASE <- function(variable, lookup) {
  getCondition <- function(r) {
    max.q <- max(lookup[SCALE_SCORE_ACTUAL == lookup[r, SCALE_SCORE_ACTUAL], Qx]) # Move and change
    precond <- paste0(
      if("CONTENT_AREA" %in% names(lookup)) paste0("CONTENT_AREA=='", lookup[r, CONTENT_AREA], "' & "),
      if("GRADE" %in% names(lookup)) paste0("GRADE=='", lookup[r, GRADE], "' & "),
      if("SCALE_SCORE_ACTUAL" %in% names(lookup)) paste0("SCALE_SCORE_ACTUAL=='", lookup[r, SCALE_SCORE_ACTUAL], "' & "),
      variable)
    if (lookup[r, LOW] == lookup[r, HIGH]) {
      return(paste0(precond, " == ", lookup[r, LOW], ", 'Q", lookup[r, Qx], "'"))
    }
    if (lookup[r, Qx]==1) {
      return(paste0(precond, " < ", lookup[r, HIGH], ", 'Q1'"))
    }
    if (lookup[r, Qx] != max.q) {
      return(paste0(precond, " >= ", lookup[r, LOW], " & ", variable, " < ", lookup[r, HIGH], ", 'Q", lookup[r, Qx], "'"))
    } else {
      return(paste0(precond, " >= ", lookup[r, LOW], ", 'Q", lookup[r, Qx], "'"))
    }
  }
  tmp.fcase <- unlist(lapply(seq(nrow(lookup)), getCondition))
  return(paste0("fcase(", paste(tmp.fcase, collapse = ","), ")"))
}

`rankPCA` <- function(data_table) {
  dec.tbl <- data_table[VALID_CASE == "VALID_CASE" & !SCALE_SCORE_ACTUAL %in% range(SCALE_SCORE_ACTUAL, na.rm = TRUE),
                            as.list(getQuantcut(SCALE_SCORE, quantiles = 0:10/10)), keyby = c("SCALE_SCORE_ACTUAL")]

  prior.decile.fcase <- getFCASE("SCALE_SCORE", dec.tbl)
  tmp.dt <- copy(data_table)
  tmp.dt[, WITHIN_SCORE_DECILE := eval(parse(text=prior.decile.fcase))]
  tmp.dt[, WITHIN_SCORE_DECILE := as.numeric(gsub("Q", "", WITHIN_SCORE_DECILE))-1]

  tmp.dt[, RETVAL := (WITHIN_SCORE_DECILE/10)]
  tmp.dt[is.na(RETVAL), RETVAL := 0]
  tmp.dt[, RETVAL := (RETVAL + SCALE_SCORE_ACTUAL)]
  return(as.numeric(tmp.dt[, RETVAL]))
}


##    Need to round to 2 decimals to work well for all
NJSS_Data_LONG_2021_2022.1[, SS_FULL := SCALE_SCORE]
NJSS_Data_LONG_2021_2022.1[, SCALE_SCORE := round(SS_FULL, 2)]

NJSS_Data_LONG_2021_2022.1[, SCALE_SCORE_RANKED := rankPCA(.SD), by = list(TestCode), .SDcols = c("VALID_CASE", "SCALE_SCORE", "SCALE_SCORE_ACTUAL")] # "TestCode" for debug
NJSS_Data_LONG_2021_2022.1[, SCALE_SCORE := SCALE_SCORE_RANKED]
NJSS_Data_LONG_2021_2022.1[, ACHIEVEMENT_LEVEL_RANKED := getCutsNJSS(.SD, predict.cuts = FALSE, digits=2), by = list(TestCode), .SDcols = c("SCALE_SCORE", "SCALE_SCORE_ACTUAL", "ACHIEVEMENT_LEVEL_ACTUAL")]
# table(NJSS_Data_LONG_2021_2022.1[, .(ACHIEVEMENT_LEVEL_RANKED, TestCode), ACHIEVEMENT_LEVEL])
# table(NJSS_Data_LONG_2021_2022.1[, .(ACHIEVEMENT_LEVEL_RANKED, TestCode), ACHIEVEMENT_LEVEL_ACTUAL])

NJSS_Data_LONG_2021_2022.1[, SCALE_SCORE := SS_FULL]
NJSS_Data_LONG_2021_2022.1[, SS_FULL := NULL]

# plot(NJSS_Data_LONG_2021_2022.1[VALID_CASE == "VALID_CASE" & TestCode == "MAT06", SCALE_SCORE_ACTUAL, SCALE_SCORE_RANKED])
# NJSS_Data_LONG_2021_2022.1[VALID_CASE == "VALID_CASE", as.list(summary(SCALE_SCORE_RANKED - SCALE_SCORE_ACTUAL)), keyby = "TestCode"] # Should all be between 0 and 1
##    Test Results.  Differences should all be between 0 and 1
ss.smry <- NJSS_Data_LONG_2021_2022.1[VALID_CASE == "VALID_CASE", as.list(summary(SCALE_SCORE)), keyby = c("TestCode", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_RANKED")]
# ss.smry[TestCode == "ELA08"]
ss.smry[, MAX_PRIOR := shift(Max., 1, type = "lag"), by = list(TestCode, SCALE_SCORE_ACTUAL)]
ss.smry[, MIN_NEXT := shift(Min., 1, type = "lead"), by = list(TestCode, SCALE_SCORE_ACTUAL)]
ss.smry[, MAX_PRIOR_lt_MIN := Min. - MAX_PRIOR]
ss.smry[, MIN_NEXT_gt_MAX := MIN_NEXT - Max.]

ss.smry[, as.list(summary(MAX_PRIOR_lt_MIN)), keyby = "TestCode"]
ss.smry[, as.list(summary(MIN_NEXT_gt_MAX)), keyby = "TestCode"]

off.res1 <- ss.smry[MAX_PRIOR_lt_MIN < 0]  #  | MIN_NEXT_gt_MAX < 0
off.res2 <- ss.smry[MIN_NEXT_gt_MAX < 0]
off.res1[TestCode=="GEO01"]
off.res2[TestCode=="GEO01"]
ss.smry[TestCode=="GEO01" & SCALE_SCORE_ACTUAL == 18]


NJSS_Data_LONG_2021_2022.1[, SS_FULL := SCALE_SCORE]
NJSS_Data_LONG_2021_2022.1[, SCALE_SCORE := round(SS_FULL, 2)]

tst.rank <- NJSS_Data_LONG_2021_2022.1[VALID_CASE == "VALID_CASE" & TestCode == "GEO01", ]

tst.rank[, .(
      UNIQUE_PCA4 = length(unique(SS_FULL)),
      UNIQUE_PCA3 = length(unique(round(SS_FULL, 3))),
      UNIQUE_PCA2 = length(unique(round(SS_FULL, 2))),
      UNIQUE_PCA1 = length(unique(round(SS_FULL, 1)))), keyby = "SCALE_SCORE_ACTUAL"]

tst.rank[!is.na(SCALE_SCORE), as.list(summary(nchar(SCALE_SCORE)))]



##    Establish a decile lookup based on 2019 for each CONTENT_AREA/GRADE combination
Decile_Lookup <- tst.rank[!is.na(SCALE_SCORE) & !SCALE_SCORE_ACTUAL %in% range(SCALE_SCORE_ACTUAL),
                          as.list(getQuantcut(SCALE_SCORE, quantiles = 0:10/10)), keyby = c("SCALE_SCORE_ACTUAL")] # "CONTENT_AREA", "GRADE",

tst <- NJSS_Data_LONG_2021_2022.1[VALID_CASE == "VALID_CASE" & TestCode == "GEO01" & SCALE_SCORE_ACTUAL == 18, SCALE_SCORE]
# getQuantcut(tst)

tmp.pts <- unique(tst)
if (denom <- length(tmp.pts) > 9) denom <- 10
tmp.cuts <- quantile(tst, probs = seq(0, 1, 1/denom), na.rm = TRUE, names = FALSE)
tmp.deci <- findInterval(tst, tmp.cuts, rightmost.closed = TRUE)-1

, rightmost.closed = FALSE, all.inside = FALSE,
                  left.open = FALSE)


`quantileOrder` <- function(data_table) {
  vals <- data_table[, SCALE_SCORE]
  tmp.pts <- sort(unique(vals))
  denom <- length(tmp.pts)
  # if ((denom <- length(tmp.pts)) > 9) denom <- 10
  if (denom > 1) {
    if (denom > 9) {
      tmp.cuts <- quantile(vals, probs = 0:10/10, na.rm = TRUE, names = FALSE)
      tmp.deci <- (findInterval(vals, tmp.cuts, rightmost.closed = TRUE)-1)/10
    } else {
      if (denom > 2) {
        tmp.deci <- as.numeric(as.character(factor(vals, levels = tmp.pts, labels = c(0, round(((2:(denom-1))/9)*(9/(denom+1)), 1), 0.9))))
      } else tmp.deci <- as.numeric(as.character(factor(vals, levels = tmp.pts, labels = c(0, 0.5)))) # denom == 2
      # tmp.deci <- findInterval(vals, tmp.pts, rightmost.closed = TRUE)-1 # also works, but not spaced out
    }
    return(data_table[, SCALE_SCORE_ACTUAL] + tmp.deci)
  } else {
    return(as.numeric(data_table[, SCALE_SCORE_ACTUAL]))
  }
}

NJSS_Data_LONG_2021_2022.1[, SCALE_SCORE_R2 := quantileOrder(.SD), by = list(TestCode, SCALE_SCORE_ACTUAL), .SDcols = c("SCALE_SCORE", "SCALE_SCORE_ACTUAL")] # "TestCode" for debug

NJSS_Data_LONG_2021_2022.1[, .(
      UNIQUE_PCA4 = length(unique(SS_FULL)),
      UNIQUE_PCA3 = length(unique(round(SS_FULL, 3))),
      UNIQUE_PCA2 = length(unique(round(SS_FULL, 2))),
      UNIQUE_PCA1 = length(unique(round(SS_FULL, 1))),
      UNIQUE_RNK4 = length(unique(SCALE_SCORE_R2)),
      UNIQUE_RNK2 = length(unique(SCALE_SCORE_RANKED)),
      UNIQUE_RAWS = length(unique(SCALE_SCORE_ACTUAL))), keyby = "TestCode"]

ss.smry <- NJSS_Data_LONG_2021_2022.1[VALID_CASE == "VALID_CASE", as.list(summary(SCALE_SCORE)), keyby = c("TestCode", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_R2")] # Should all be between 0 and 1
# ss.smry[TestCode == "ELA08"]
ss.smry[, MAX_PRIOR := shift(Max., 1, type = "lag"), by = list(TestCode, SCALE_SCORE_ACTUAL)]
ss.smry[, MIN_NEXT := shift(Min., 1, type = "lead"), by = list(TestCode, SCALE_SCORE_ACTUAL)]
ss.smry[, MAX_PRIOR_lt_MIN := Min. - MAX_PRIOR]
ss.smry[, MIN_NEXT_gt_MAX := MIN_NEXT - Max.]

ss.smry[, as.list(summary(MAX_PRIOR_lt_MIN)), keyby = "TestCode"]
ss.smry[, as.list(summary(MIN_NEXT_gt_MAX)), keyby = "TestCode"]



prior.decile.fcase <- getFCASE("SCALE_SCORE", Decile_Lookup)
# tst.rank[, SCALE_SCORE := round(SCALE_SCORE, 2)]
tst.rank[, WITHIN_SCORE_DECILE := eval(parse(text=prior.decile.fcase))]
tst.rank[, WITHIN_SCORE_DECILE := as.numeric(gsub("Q", "", WITHIN_SCORE_DECILE))-1]

table(tst.rank[, WITHIN_SCORE_DECILE, SCALE_SCORE_ACTUAL], exclude=NULL)

tst.rank[, SS_COUNT_DEC := (WITHIN_SCORE_DECILE/10)]
tst.rank[is.na(SS_COUNT_DEC), SS_COUNT_DEC := 0]
tst.rank[, SS_COUNT_DEC := (SS_COUNT_DEC + SCALE_SCORE_ACTUAL)]

SCALE_SCORE_ACTUAL=='23' & SCALE_SCORE == 1.75, 'Q1',
SCALE_SCORE_ACTUAL=='23' & SCALE_SCORE == 1.76, 'Q2',
SCALE_SCORE_ACTUAL=='23' & SCALE_SCORE == 1.77, 'Q3',
SCALE_SCORE_ACTUAL=='23' & SCALE_SCORE >= 1.77, 'Q4',
Decile_Lookup[SCALE_SCORE_ACTUAL=='11']
table(tst.rank[SCALE_SCORE_ACTUAL=='11' & is.na(WITHIN_SCORE_DECILE), SCALE_SCORE])


###
table(NJSS_Data_LONG_2021_2022.1[, OnlineTestStartDateTime=="", TestCode], exclude=NULL)

NJSS_Data_LONG_2021_2022.1[, END := strptime(OnlineTestEndDateTime, "%m/%d/%Y %H:%M", tz="EST")]
NJSS_Data_LONG_2021_2022.1[, BEGIN := strptime(OnlineTestStartDateTime, "%m/%d/%Y %H:%M", tz="EST")]
# NJSS_Data_LONG_2021_2022.1[, TIME_TAKEN := as.numeric(END - BEGIN)]
NJSS_Data_LONG_2021_2022.1[, TIME_TAKEN := as.numeric(difftime(END, BEGIN, units="mins"))]

b <- strptime("9/29/2021 11:58", "%m/%d/%Y %H:%M", tz="EST") #"%R"
e <- strptime("9/29/2021 13:05", "%m/%d/%Y %H:%M", tz="EST")
as.numeric(e - b)
