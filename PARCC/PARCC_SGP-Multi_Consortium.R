#################################################################################
###                                                                           ###
###   SGP analysis script for PARCC Alternative Test Consortiums - May 2019   ###
###                                                                           ###
#################################################################################

### Load Packages
require(SGP)
require(data.table)


load('/media/Data/PARCC/PARCC_ABO_Lite/Data/Archive/2018_2019.2/PARCC_SGP_LONG_Data_2018_2019.2.Rdata')
table(PARCC_SGP_LONG_Data_2018_2019.2[, StateAbbreviation, is.na(SGP)])
PARCC_SGP_LONG_Data_2018_2019.2 <- PARCC_SGP_LONG_Data_2018_2019.2[StateAbbreviation %in% c("IL", "NM", "BI")] #  c("DD", "MD", "DC")"NJ",

PARCC_ABO_Lite <- PARCC_SGP_LONG_Data_2018_2019.2[,
												c(names(PARCC_SGP_LONG_Data_2018_2019.2)[c(1:17, 19, 20, 32, 52)],
												"SGP", "SGP_ORDER", "SGP_NOTE", "SGP_NORM_GROUP"), with=FALSE]
