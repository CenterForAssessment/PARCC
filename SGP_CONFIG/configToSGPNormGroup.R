##########################################################################################
###                                                                                    ###
###       Convert SGP analysis configurations to SGP_NORM_GROUP preference table       ###
###                                                                                    ###
##########################################################################################

### Load packages

require("data.table")

### utility function

configToSGPNormGroup <- function(sgp.config) {
	if ("sgp.norm.group.preference" %in% names(sgp.config)) {
		tmp.data.all <- data.table()
		for (g in 1:length(sgp.config$sgp.grade.sequences)) {
			l <- length(sgp.config$sgp.grade.sequences[[g]])
			tmp.norm.group <- tmp.norm.group.baseline <- paste(tail(sgp.config$sgp.panel.years, l), paste(tail(sgp.config$sgp.content.areas, l), unlist(sgp.config$sgp.grade.sequences[[g]]), sep="_"), sep="/")

			tmp.data <- data.table(
				SGP_NORM_GROUP=paste(tmp.norm.group, collapse="; "),
				# SGP_NORM_GROUP_BASELINE=paste(tmp.norm.group.baseline, collapse="; "),
				PREFERENCE= sgp.config$sgp.norm.group.preference*100)

			if (length(tmp.norm.group) > 2) {
				if ("sgp.exact.grade.progression" %in% names(sgp.config)) {
					if(sgp.config$sgp.exact.grade.progression[[g]]) tmp.all.prog <- FALSE else tmp.all.prog <- TRUE
				} else tmp.all.prog <- TRUE
				if (tmp.all.prog) {
					for (n in 1:(length(tmp.norm.group)-2)) {
						tmp.data <- rbind(tmp.data, data.table(
							SGP_NORM_GROUP=paste(tail(tmp.norm.group, -n), collapse="; "),
							# SGP_NORM_GROUP_BASELINE=paste(tail(tmp.norm.group.baseline, -n), collapse="; "),
							PREFERENCE= (sgp.config$sgp.norm.group.preference*100)+n))
					}
				}
			}
			tmp.data.all <- rbind(tmp.data.all, tmp.data)
		}
		return(unique(tmp.data.all))
	} else {
		return(NULL)
	}
}

### Load EOCT Math Configurations

source("SGP_CONFIG/2015_2016.2/MATHEMATICS.R")
source("SGP_CONFIG/2015_2016.2/MATHEMATICS_SS.R")
source("SGP_CONFIG/2016_2017.1/MATHEMATICS.R")
source("SGP_CONFIG/2016_2017.1/MATHEMATICS_SS.R")


###  Compile annual configuration lists

PARCC_2015_2016.2.config <- c(
	ALGEBRA_I.2015_2016.config, GEOMETRY.2015_2016.config, ALGEBRA_II.2015_2016.config,
	INTEGRATED_MATH_1.2015_2016.config, INTEGRATED_MATH_2.2015_2016.config, INTEGRATED_MATH_3.2015_2016.config,

	ALGEBRA_I_SS.2015_2016.config, GEOMETRY_SS.2015_2016.config, ALGEBRA_II_SS.2015_2016.config,
	INTEGRATED_MATH_1_SS.2015_2016.config, INTEGRATED_MATH_2_SS.2015_2016.config, INTEGRATED_MATH_3_SS.2015_2016.config)

PARCC_2016_2017.1.config <- c(
	ALGEBRA_I.2016_2017.1.config, GEOMETRY.2016_2017.1.config, ALGEBRA_II.2016_2017.1.config,
	ALGEBRA_I_SS.2016_2017.1.config, GEOMETRY_SS.2016_2017.1.config, ALGEBRA_II_SS.2016_2017.1.config)

### Create configToNormGroup data.frame for each year

tmp.configToNormGroup <- lapply(PARCC_2015_2016.2.config, configToSGPNormGroup)
PARCC_SGP_Norm_Group_Preference_2016 <- data.table(
					YEAR="2015_2016.2", rbindlist(tmp.configToNormGroup))

tmp.configToNormGroup <- lapply(PARCC_2016_2017.1.config, configToSGPNormGroup)
PARCC_SGP_Norm_Group_Preference_2017.1 <- data.table(
					YEAR="2016_2017.1", rbindlist(tmp.configToNormGroup))

# PARCC_SGP_Norm_Group_Preference_2017.1[grep('2016_2017.1/ALGEBRA_II_EOCT', PARCC_SGP_Norm_Group_Preference_2017.1$SGP_NORM_GROUP)]

###  Combine annual preference objects into a single PARCC_SGP_Norm_Group_Preference with rbind(...)

# PARCC_SGP_Norm_Group_Preference <- PARCC_SGP_Norm_Group_Preference_2016
PARCC_SGP_Norm_Group_Preference <- rbind(PARCC_SGP_Norm_Group_Preference_2016, PARCC_SGP_Norm_Group_Preference_2017.1)

PARCC_SGP_Norm_Group_Preference$SGP_NORM_GROUP <- as.factor(PARCC_SGP_Norm_Group_Preference$SGP_NORM_GROUP)

### Save result

setkey(PARCC_SGP_Norm_Group_Preference, YEAR, SGP_NORM_GROUP)
save(PARCC_SGP_Norm_Group_Preference, file="SGP_CONFIG/PARCC_SGP_Norm_Group_Preference.Rdata")
