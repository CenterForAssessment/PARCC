################################################################################
###                                                                          ###
###             New Jersey Fall 2021 (EXPLORATORY!) SGP Analyses             ###
###                                                                          ###
################################################################################

###  Set working directory to New_Jersey directory (./PARCC/New_Jersey)

###   Load packages
require(SGP)
require(data.table)

###   Load cleaned 2021 and 2022 LONG data
load("./Data/Archive/2018_2019.2/New_Jersey_Data_LONG_2018_2019.2.Rdata")
load("./Data/Archive/2021_2022.1/NJSS_Data_LONG_2021_2022.1.Rdata")

SGPstateData[["NJ"]][["Assessment_Program_Information"]][["CSEM"]] <- NULL
# SGPstateData[["NJ"]][["SGP_Configuration"]][["grade.projection.sequence"]] <- NULL # only need these steps when doing "Reverse" growth
# SGPstateData[["NJ"]][["SGP_Configuration"]][["content_area.projection.sequence"]] <- NULL
# SGPstateData[["NJ"]][["SGP_Configuration"]][["year_lags.projection.sequence"]] <- NULL

njss_kbs <- createKnotsBoundaries(NJSS_Data_LONG_2021_2022.1)
SGPstateData[["NJ"]][["Achievement"]][["Knots_Boundaries"]] <- c(SGPstateData[["PARCC"]][["Achievement"]][["Knots_Boundaries"]], njss_kbs)

New_Jersey_SStrong_SGP <- prepareSGP(
	data = rbindlist(list(New_Jersey_Data_LONG_2018_2019.2, NJSS_Data_LONG_2021_2022.1), fill = TRUE),
	state = "NJ", create.additional.variables = FALSE)


###   Read in configuration scripts and combine
source("../SGP_CONFIG/2021_2022.1/ELA.R")
source("../SGP_CONFIG/2021_2022.1/MATHEMATICS.R")

NJSS_Fall_2021_Config <- c(
	ELA_2021_2022.1.config,
	MATHEMATICS_2021_2022.1.config,
	ALGEBRA_I_2021_2022.1.config,
	GEOMETRY_2021_2022.1.config,
	ALGEBRA_II_2021_2022.1.config
)

#####
###   Run Start Strong Student Growth Percentiles
#####

New_Jersey_SStrong_SGP <- analyzeSGP(
        sgp_object = New_Jersey_SStrong_SGP,
        sgp.config = NJSS_Fall_2021_Config,
        sgp.percentiles = TRUE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = FALSE,
        sgp.projections.baseline = FALSE,
        sgp.projections.lagged.baseline = FALSE,
        parallel.config = list(
          BACKEND = "PARALLEL",
          WORKERS=list(TAUS = 12))
)

New_Jersey_SStrong_SGP <- combineSGP(New_Jersey_SStrong_SGP)

setnames(New_Jersey_SStrong_SGP@Data, "SGP", "SGP_PCA_R4")
New_Jersey_SStrong_SGP@SGP <- NULL

file.rename("./Goodness_of_Fit", "./Goodness_of_Fit_R4")


#####
###   Round PCA SCALE_SCORE to 2 decimal points
#####

New_Jersey_SStrong_SGP@Data[!is.na(SCALE_SCORE), as.list(summary(nchar(SCALE_SCORE))), keyby="YEAR"]
New_Jersey_SStrong_SGP@Data[, SS_FULL := SCALE_SCORE]
New_Jersey_SStrong_SGP@Data[YEAR == "2021_2022.1", SCALE_SCORE := round(SS_FULL, 2)]

NJSS_Data_LONG_2021_2022.1[, SS_FULL := SCALE_SCORE]
NJSS_Data_LONG_2021_2022.1[, SCALE_SCORE := round(SS_FULL, 2)]

# NJSS_Data_LONG_2021_2022.1[, list(
#           UNIQUE_PCA4 = length(unique(SS_FULL)),
# 					COR_PCA4 = round(cor(SCALE_SCORE_ACTUAL, SS_FULL, use='na.or.complete'), 3),
#           UNIQUE_PCA = length(unique(SCALE_SCORE)),
#           COR_PCA = round(cor(SCALE_SCORE_ACTUAL, SCALE_SCORE, use='na.or.complete'), 3)), keyby = c("TestCode")] #

njss_kbs <- createKnotsBoundaries(NJSS_Data_LONG_2021_2022.1)
SGPstateData[["NJ"]][["Achievement"]][["Knots_Boundaries"]] <- c(SGPstateData[["PARCC"]][["Achievement"]][["Knots_Boundaries"]], njss_kbs)


New_Jersey_SStrong_SGP <- analyzeSGP(
        sgp_object = New_Jersey_SStrong_SGP,
        sgp.config = NJSS_Fall_2021_Config,
        sgp.percentiles = TRUE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = FALSE,
        sgp.projections.baseline = FALSE,
        sgp.projections.lagged.baseline = FALSE,
        parallel.config = list(
          BACKEND = "PARALLEL",
          WORKERS=list(TAUS = 12))
)

New_Jersey_SStrong_SGP <- combineSGP(New_Jersey_SStrong_SGP)

setnames(New_Jersey_SStrong_SGP@Data, "SGP", "SGP_PCA_R2")
New_Jersey_SStrong_SGP@SGP <- NULL

file.rename("./Goodness_of_Fit", "./Goodness_of_Fit_R2")

cor(New_Jersey_SStrong_SGP@Data[, SGP_PCA_R4, SGP_PCA_R2], method = "spearman", use="complete.obs")
table(New_Jersey_SStrong_SGP@Data[, SGP_PCA_R4-SGP_PCA_R2])

#####
###   Round PCA SCALE_SCORE to 1 decimal point
#####

New_Jersey_SStrong_SGP@Data[YEAR == "2021_2022.1", SCALE_SCORE := round(SS_FULL, 1)]

NJSS_Data_LONG_2021_2022.1[, SCALE_SCORE := round(SS_FULL, 1)]
njss_kbs <- createKnotsBoundaries(NJSS_Data_LONG_2021_2022.1)
SGPstateData[["NJ"]][["Achievement"]][["Knots_Boundaries"]] <- c(SGPstateData[["PARCC"]][["Achievement"]][["Knots_Boundaries"]], njss_kbs)


New_Jersey_SStrong_SGP <- analyzeSGP(
        sgp_object = New_Jersey_SStrong_SGP,
        sgp.config = NJSS_Fall_2021_Config,
        sgp.percentiles = TRUE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = FALSE,
        sgp.projections.baseline = FALSE,
        sgp.projections.lagged.baseline = FALSE,
        parallel.config = list(
          BACKEND = "PARALLEL",
          WORKERS=list(TAUS = 12))
)

New_Jersey_SStrong_SGP <- combineSGP(New_Jersey_SStrong_SGP)

setnames(New_Jersey_SStrong_SGP@Data, "SGP", "SGP_PCA_R1")
New_Jersey_SStrong_SGP@SGP <- NULL

file.rename("./Goodness_of_Fit", "./Goodness_of_Fit_R1")

cor(New_Jersey_SStrong_SGP@Data[, SGP_PCA_R2, SGP_PCA_R1], use="complete.obs")
table(New_Jersey_SStrong_SGP@Data[, SGP_PCA_R2-SGP_PCA_R1])


#####
###   Use Raw (Count) Score
#####

New_Jersey_SStrong_SGP@Data[YEAR == "2021_2022.1", SCALE_SCORE := SCALE_SCORE_ACTUAL]

NJSS_Data_LONG_2021_2022.1[, SCALE_SCORE := SCALE_SCORE_ACTUAL]
njss_kbs <- createKnotsBoundaries(NJSS_Data_LONG_2021_2022.1)
SGPstateData[["NJ"]][["Achievement"]][["Knots_Boundaries"]] <- c(SGPstateData[["PARCC"]][["Achievement"]][["Knots_Boundaries"]], njss_kbs)


New_Jersey_SStrong_SGP <- analyzeSGP(
        sgp_object = New_Jersey_SStrong_SGP,
        sgp.config = NJSS_Fall_2021_Config,
        sgp.percentiles = TRUE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = FALSE,
        sgp.projections.baseline = FALSE,
        sgp.projections.lagged.baseline = FALSE,
        parallel.config = list(
          BACKEND = "PARALLEL",
          WORKERS=list(TAUS = 12))
)

New_Jersey_SStrong_SGP <- combineSGP(New_Jersey_SStrong_SGP)

setnames(New_Jersey_SStrong_SGP@Data, "SGP", "SGP_RAW")
New_Jersey_SStrong_SGP@SGP <- NULL

file.rename("./Goodness_of_Fit", "./Goodness_of_Fit_Rawx")

cor(New_Jersey_SStrong_SGP@Data[, SGP_PCA_R2, SGP_RAW], use="complete.obs", method = "spearman")
table(New_Jersey_SStrong_SGP@Data[, SGP_PCA_R2-SGP_RAW])


#####
###   Use Raw (RANKED) Score
#####

New_Jersey_SStrong_SGP@Data[YEAR == "2021_2022.1", SCALE_SCORE := SCALE_SCORE_RANKED]

NJSS_Data_LONG_2021_2022.1[, SCALE_SCORE := SCALE_SCORE_RANKED]
njss_kbs <- createKnotsBoundaries(NJSS_Data_LONG_2021_2022.1)
SGPstateData[["NJ"]][["Achievement"]][["Knots_Boundaries"]] <- c(SGPstateData[["PARCC"]][["Achievement"]][["Knots_Boundaries"]], njss_kbs)


New_Jersey_SStrong_SGP <- analyzeSGP(
        sgp_object = New_Jersey_SStrong_SGP,
        sgp.config = NJSS_Fall_2021_Config,
        sgp.percentiles = TRUE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = FALSE,
        sgp.projections.baseline = FALSE,
        sgp.projections.lagged.baseline = FALSE,
        parallel.config = list(
          BACKEND = "PARALLEL",
          WORKERS=list(TAUS = 12))
)

New_Jersey_SStrong_SGP <- combineSGP(New_Jersey_SStrong_SGP)

setnames(New_Jersey_SStrong_SGP@Data, "SGP", "SGP_RANKED")
New_Jersey_SStrong_SGP@SGP <- NULL

file.rename("./Goodness_of_Fit", "./Goodness_of_Fit_Ranked")

cor(New_Jersey_SStrong_SGP@Data[, SGP_PCA_R2, SGP_RANKED], use="complete.obs", method = "spearman")
table(New_Jersey_SStrong_SGP@Data[, SGP_PCA_R2-SGP_RANKED])
cor(New_Jersey_SStrong_SGP@Data[, SGP_RAW, SGP_RANKED], use="complete.obs", method = "spearman")


###   Save results
# save(New_Jersey_SStrong_SGP, file="New_Jersey_SStrong_SGP-wRank.Rdata")
