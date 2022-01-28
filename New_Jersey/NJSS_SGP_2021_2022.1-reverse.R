################################################################################
###                                                                          ###
###        New Jersey Fall 2021 (EXPLORATORY!) "Reverse" SGP Analyses        ###
###                                                                          ###
################################################################################

###  Set working directory to Reverse_Growth
setwd("Reverse_Growth")

###   Load packages
require(SGP)
require(data.table)

###   Load cleaned 2021 and 2022 LONG data
load("./Data/Archive/2018_2019.2/New_Jersey_Data_LONG_2018_2019.2.Rdata")
load("./Data/Archive/2021_2022.1/NJSS_Data_LONG_2021_2022.1.Rdata")

SGPstateData[["NJ"]][["Assessment_Program_Information"]][["CSEM"]] <- NULL
SGPstateData[["NJ"]][["SGP_Configuration"]][["grade.projection.sequence"]] <- NULL # only need these steps when doing "Reverse" growth
SGPstateData[["NJ"]][["SGP_Configuration"]][["content_area.projection.sequence"]] <- NULL
SGPstateData[["NJ"]][["SGP_Configuration"]][["year_lags.projection.sequence"]] <- NULL

njss_kbs <- createKnotsBoundaries(NJSS_Data_LONG_2021_2022.1)
SGPstateData[["NJ"]][["Achievement"]][["Knots_Boundaries"]] <- c(SGPstateData[["PARCC"]][["Achievement"]][["Knots_Boundaries"]], njss_kbs)

New_Jersey_SStrong_SGP <- prepareSGP(
	data = rbindlist(list(New_Jersey_Data_LONG_2018_2019.2, NJSS_Data_LONG_2021_2022.1), fill = TRUE),
	state = "NJ", create.additional.variables = FALSE)


###   Read in configuration scripts and combine
ELA_2021_2022.1.config <- list(
	ELA.2021_2022.1 = list(
		sgp.content.areas=c("ELA_NJSS", "ELA"),
		sgp.panel.years=c("2021_2022.1", "2018_2019.2"),
		sgp.grade.sequences=list(c("6", "3"), c("7", "4"), c("8", "5"),
		                         c("9", "6"), c("10", "7")),
		sgp.norm.group.preference=0L)
)

MATHEMATICS_2021_2022.1.config <- list(
	MATHEMATICS.2021_2022.1 = list(
		sgp.content.areas=c("MATH_NJSS", "MATHEMATICS"),
		sgp.panel.years=c("2021_2022.1", "2018_2019.2"),
		sgp.grade.sequences=list(c("6", "3"), c("7", "4"), c("8", "5")),
		sgp.norm.group.preference=0L)
)

NJSS_Fall_2021_Config <- c(
	ELA_2021_2022.1.config,
	MATHEMATICS_2021_2022.1.config
)

#####
###   Round PCA SCALE_SCORE to 2 decimal points
#####

New_Jersey_SStrong_SGP@Data[, SS_FULL := SCALE_SCORE]
New_Jersey_SStrong_SGP@Data[YEAR == "2021_2022.1", SCALE_SCORE := round(SS_FULL, 2)]

NJSS_Data_LONG_2021_2022.1[, SS_FULL := SCALE_SCORE]
NJSS_Data_LONG_2021_2022.1[, SCALE_SCORE := round(SS_FULL, 2)]

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


#####
###   Raw (Count) Score
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

file.rename("./Goodness_of_Fit", "./Goodness_of_Fit_Raw")

cor(New_Jersey_SStrong_SGP@Data[, SGP_PCA_R2, SGP_RAW], use="complete.obs", method = "spearman")
table(New_Jersey_SStrong_SGP@Data[, SGP_PCA_R2-SGP_RAW])
hist(New_Jersey_SStrong_SGP@Data[, SGP_PCA_R2-SGP_RAW], breaks = 50)

###   Save results
# save(New_Jersey_SStrong_SGP, file="New_Jersey_SStrong_SGP-Reverse.Rdata")
