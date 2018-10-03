my.probs <- c(0.05, 0.25, 0.5, 0.75, 0.95)
my.key <- c("CONTENT_AREA", "YEAR", "TestFormat")
tbl.ca.sgp <- PARCC_SGP@Data[YEAR %in% c("2015_2016.2", "2016_2017.2") & !grepl("_SS", CONTENT_AREA) & !is.na(SGP), as.list(quantile(SGP, probs=my.probs)), keyby=my.key][
   PARCC_SGP@Data[YEAR %in% c("2015_2016.2", "2016_2017.2") & !grepl("_SS", CONTENT_AREA) & !is.na(SGP), list(Median=median(SGP, na.rm=T), Mean=mean(SGP, na.rm=T), N=.N), keyby=my.key]]
tbl.ca.sgp[, N := prettyNum(N, preserve.width = "individual", big.mark=',')]

my.key <- c("CONTENT_AREA", "GRADE", "TestFormat")
tbl.g.ca.sgp <- PARCC_SGP@Data[YEAR=="2016_2017.2" & !grepl("_SS", CONTENT_AREA) & !is.na(SGP), as.list(quantile(SGP, probs=my.probs)), keyby=my.key][
   PARCC_SGP@Data[YEAR=="2016_2017.2" & !grepl("_SS", CONTENT_AREA) & !is.na(SGP), list(Median=median(SGP, na.rm=T), Mean=mean(SGP, na.rm=T), N=.N), keyby=my.key]]
tbl.g.ca.sgp[, N := prettyNum(N, preserve.width = "individual", big.mark=',')]
tbl.g.ca.sgp[, Mean := round(Mean, 2)]

tbl.g.ca.smx <- PARCC_SGP@Data[YEAR=="2016_2017.2" & !grepl("_SS", CONTENT_AREA) & !is.na(SGP_SIMEX_RANKED), as.list(quantile(SGP_SIMEX_RANKED, probs=my.probs)), keyby=my.key][
   PARCC_SGP@Data[YEAR=="2016_2017.2" & !grepl("_SS", CONTENT_AREA) & !is.na(SGP_SIMEX_RANKED), list(Median=median(SGP_SIMEX_RANKED, na.rm=T), Mean=mean(SGP_SIMEX_RANKED, na.rm=T), N=.N), keyby=my.key]]
tbl.g.ca.smx[, N := prettyNum(N, preserve.width = "individual", big.mark=',')]
tbl.g.ca.smx[, Mean := round(Mean, 2)]

tbl.g.ca.sgp2 <- PARCC_SGP@Data[YEAR=="2015_2016.2" & !grepl("_SS", CONTENT_AREA) & !is.na(SGP), as.list(quantile(SGP, probs=my.probs)), keyby=my.key][
   PARCC_SGP@Data[YEAR=="2015_2016.2" & !grepl("_SS", CONTENT_AREA) & !is.na(SGP), list(Median=median(SGP, na.rm=T), Mean=mean(SGP, na.rm=T), N=.N), keyby=my.key]]
tbl.g.ca.sgp2[, N := prettyNum(N, preserve.width = "individual", big.mark=',')]
tbl.g.ca.sgp2[, Mean := round(Mean, 2)]


tbl.g.ca <- PARCC_SGP@Data[YEAR=="2016_2017.2" & !grepl("_SS", CONTENT_AREA) & !is.na(SGP), list(Median=median(SGP, na.rm=T), Mean=mean(SGP, na.rm=T), `Median Ranked`=median(SGP_SIMEX_RANKED, na.rm=T), `Mean Ranked`=mean(SGP_SIMEX_RANKED, na.rm=T), N=.N), keyby=my.key]
tbl.g.ca[, N := prettyNum(N, preserve.width = "individual", big.mark=',')]
tbl.g.ca[, Mean := round(Mean, 2)]
tbl.g.ca[, `Mean Ranked` := round(`Mean Ranked`, 2)]

tbl.g.ca2 <- PARCC_SGP@Data[YEAR=="2015_2016.2" & !grepl("_SS", CONTENT_AREA) & !is.na(SGP), list(Median=median(SGP, na.rm=T), Mean=mean(SGP, na.rm=T), `Median SIMEX`=median(SGP_SIMEX, na.rm=T), `Mean SIMEX`=mean(SGP_SIMEX, na.rm=T), N=.N), keyby=my.key]
tbl.g.ca2[, N := prettyNum(N, preserve.width = "individual", big.mark=',')]
tbl.g.ca2[, Mean := round(Mean, 2)]
tbl.g.ca2[, `Mean SIMEX` := round(`Mean SIMEX`, 2)]

tbl.g.ca.yr <- PARCC_SGP@Data[YEAR=="2015_2016.2" & !grepl("_SS", CONTENT_AREA) & !is.na(SGP), list(`Median SGP 16`=median(SGP, na.rm=T), `Mean SGP 16`=mean(SGP, na.rm=T), `Mean Score 16`=mean(SCALE_SCORE, na.rm=T), `Mean Score Prior 16`=mean(SCALE_SCORE_PRIOR_STANDARDIZED, na.rm=T), `N 16`=.N), keyby=my.key][
               PARCC_SGP@Data[YEAR=="2016_2017.2" & !grepl("_SS", CONTENT_AREA) & !is.na(SGP), list(`Median SGP 17`=median(SGP, na.rm=T), `Mean SGP 17`=mean(SGP, na.rm=T), `Mean Score 17`=mean(SCALE_SCORE, na.rm=T), `Mean Score Prior 17`=mean(SCALE_SCORE_PRIOR_STANDARDIZED, na.rm=T), `N 17`=.N), keyby=my.key]]
tbl.g.ca.yr[, `N 16` := prettyNum(`N 16`, preserve.width = "individual", big.mark=',')]
tbl.g.ca.yr[, `N 17` := prettyNum(`N 17`, preserve.width = "individual", big.mark=',')]
tbl.g.ca.yr[, `Mean Score 16` := round(`Mean Score 16`, 2)]
tbl.g.ca.yr[, `Mean Score 17` := round(`Mean Score 17`, 2)]
tbl.g.ca.yr[, `Mean SGP 16` := round(`Mean SGP 16`, 2)]
tbl.g.ca.yr[, `Mean SGP 17` := round(`Mean SGP 17`, 2)]
tbl.g.ca.yr[, `Mean Score Prior 16` := round(`Mean Score Prior 16`, 2)]
tbl.g.ca.yr[, `Mean Score Prior 17` := round(`Mean Score Prior 17`, 2)]


save(list=c("tbl.g.ca.sgp", "tbl.g.ca.smx", "tbl.g.ca.sgp2", "tbl.g.ca", "tbl.g.ca2", "tbl.g.ca.yr"), file="Mode_Effect_Summaries.Rdata")
