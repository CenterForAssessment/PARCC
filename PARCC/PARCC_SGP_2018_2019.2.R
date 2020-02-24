#################################################################################
###                                                                           ###
###      SGP analysis script for PARCC consortium - Spring 2019 Analyses      ###
###                                                                           ###
#################################################################################

if (!exists("sgp.test")) sgp.test <- FALSE
workers <- parallel::detectCores()/2

options(error=recover)

### Load Packages

require(SGP)
require(data.table)


###  Load SGP LONG Data from FALL 2018 Analyses
load("./Data/Archive/2018_2019.1/PARCC_SGP_LONG_Data.Rdata")
load("../Bureau_Indian_Affairs/Data/Archive/2018_2019.2/Bureau_Indian_Affairs_Data_LONG_2018_2019.2.Rdata")
load("../Illinois/Data/Archive/2018_2019.2/Illinois_Data_LONG_2018_2019.2.Rdata")
load("../New_Jersey/Data/Archive/2018_2019.2/New_Jersey_Data_LONG_2018_2019.2.Rdata") # -PREEQUATED.Rdata")
load("../New_Mexico/Data/Archive/2018_2019.2/New_Mexico_Data_LONG_2018_2019.2.Rdata")
load("../Department_Of_Defense/Data/Archive/2018_2019.2/Department_of_Defense_Data_LONG_2018_2019.2.Rdata")
load("../Washington_DC/Data/Archive/2018_2019.2/Washington_DC_Data_LONG_2018_2019.2.Rdata")
load("../Maryland/Data/Archive/2018_2019.2/Maryland_Data_LONG_2018_2019.2.Rdata")

# PARCC_SGP_LONG_Data <- PARCC_SGP_LONG_Data[StateAbbreviation %in% c("IL", "NJ", "NM", "BI")] # c("DD", "MD", "DC")
PARCC_SGP_LONG_Data <- PARCC_SGP_LONG_Data[YEAR %in% c("2016_2017.2", "2017_2018.2", "2018_2019.1") & StateAbbreviation %in% c("IL", "NJ", "NM", "BI", "DD", "MD", "DC")]


###   INVALIDate duplicate prior test scores  --  4 cases in Spring 2019

setkey(PARCC_SGP_LONG_Data, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID, SCALE_SCORE, SCALE_SCORE_ACTUAL)
setkey(PARCC_SGP_LONG_Data, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID)
# dups <- PARCC_SGP_LONG_Data[c(which(duplicated(PARCC_SGP_LONG_Data, by=key(PARCC_SGP_LONG_Data)))-1, which(duplicated(PARCC_SGP_LONG_Data, by=key(PARCC_SGP_LONG_Data)))),]
# setkeyv(dups, key(PARCC_SGP_LONG_Data))
PARCC_SGP_LONG_Data[which(duplicated(PARCC_SGP_LONG_Data, by=key(PARCC_SGP_LONG_Data)))-1, VALID_CASE := "INVALID_CASE"]
table(PARCC_SGP_LONG_Data$VALID_CASE)


###  Read in the Spring 2019 configuration code and combine into a single list.

source("../SGP_CONFIG/2018_2019.2/ELA.R")
source("../SGP_CONFIG/2018_2019.2/ELA_SS.R")
source("../SGP_CONFIG/2018_2019.2/MATHEMATICS.R")
source("../SGP_CONFIG/2018_2019.2/MATHEMATICS_SS.R")

###   Modifications for Flagship SGP projections
# ELA.2018_2019.2.config[[1]]$sgp.grade.sequences <- list(c("3", "4"), c("3", "4", "5"), c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8"))
# ELA_SS.2018_2019.2.config[[1]]$sgp.grade.sequences <- list(c("3", "4"), c("3", "4", "5"), c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8"))
# ELA.2018_2019.2.config[[3]] <- ELA_SS.2018_2019.2.config[[3]] <- NULL
# ELA.2018_2019.2.config[[2]]$sgp.projection.grade.sequences <- NULL # Create projections for 8 to 10 / 2 Year skip progression.
#
# SGPstateData[["PARCC"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ELA"]] <- c("3", "4", "5", "6", "7", "8", "10")
# SGPstateData[["PARCC"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ELA"]] <- rep("ELA", 7)
# SGPstateData[["PARCC"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ELA"]] <- c(rep(1L, 5), 2)
# SGPstateData[["PARCC"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ELA_SS"]] <- c("3", "4", "5", "6", "7", "8", "10")
# SGPstateData[["PARCC"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ELA_SS"]] <- rep("ELA_SS", 7)
# SGPstateData[["PARCC"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ELA_SS"]] <- c(rep(1L, 5), 2)
###

PARCC_2018_2019.2.config <- c(
	ELA.2018_2019.2.config,
	ELA_SS.2018_2019.2.config,

	MATHEMATICS.2018_2019.2.config,
	MATHEMATICS_SS.2018_2019.2.config,

	ALGEBRA_I.2018_2019.2.config,
	ALGEBRA_I_SS.2018_2019.2.config,
	GEOMETRY.2018_2019.2.config,
	GEOMETRY_SS.2018_2019.2.config,
	ALGEBRA_II.2018_2019.2.config,
	ALGEBRA_II_SS.2018_2019.2.config,

	INTEGRATED_MATH_1.2018_2019.2.config,
	INTEGRATED_MATH_1_SS.2018_2019.2.config,
	INTEGRATED_MATH_2.2018_2019.2.config,
	INTEGRATED_MATH_2_SS.2018_2019.2.config,
	INTEGRATED_MATH_3.2018_2019.2.config,
	INTEGRATED_MATH_3_SS.2018_2019.2.config
)

###   abcSGP

PARCC_SGP <- abcSGP(
		state="PARCC",
		sgp_object=rbindlist(list(
			PARCC_SGP_LONG_Data,
			Department_of_Defense_Data_LONG_2018_2019.2,
			Maryland_Data_LONG_2018_2019.2,
			Washington_DC_Data_LONG_2018_2019.2, #), fill=TRUE),
			Bureau_Indian_Affairs_Data_LONG_2018_2019.2,
			Illinois_Data_LONG_2018_2019.2,
			New_Jersey_Data_LONG_2018_2019.2,
			New_Mexico_Data_LONG_2018_2019.2), fill=TRUE),
		sgp.config = PARCC_2018_2019.2.config,
		steps=c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
		prepareSGP.create.additional.variables=FALSE,
		sgp.percentiles=TRUE,
		sgp.projections=TRUE,
		sgp.projections.lagged=TRUE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline=FALSE,
		sgp.projections.lagged.baseline=FALSE,
		calculate.simex= if (sgp.test) list(lambda=seq(0,2,0.5), simulation.iterations=10, csem.data.vnames="SCALE_SCORE_CSEM", extrapolation="linear", save.matrices=TRUE) else TRUE,
		sgp.test.cohort.size= if (sgp.test) 1500 else NULL,     ####
		return.sgp.test.results= if (sgp.test) TRUE else FALSE, ## -- Turn OFF these 3 for real analyses
		goodness.of.fit.print= if (sgp.test) FALSE else TRUE,   ####
		save.intermediate.results=FALSE,
		sgp.target.scale.scores=TRUE,
		outputSGP.output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data"),
		outputSGP.directory= if (sgp.test) "./Data/SIM" else "Data/Archive/2018_2019.2",
    parallel.config=list(
			BACKEND = "FOREACH", TYPE = "doParallel",
			WORKERS = list(TAUS = workers, SIMEX = workers, SGP_SCALE_SCORE_TARGETS=10)))

### Save results

if (sgp.test) {
	save(PARCC_SGP, file="./Data/SIM/2018_2019.2/PARCC_SGP-Test_PARCC_2018_2019.2.Rdata")
} else save(PARCC_SGP, file="./Data/Archive/2018_2019.2/PARCC_SGP.Rdata")



### visualizeSGP

visualizeSGP(
	PARCC_SGP,
	plot.types=c("growthAchievementPlot"),
	parallel.config=list(BACKEND="PARALLEL", WORKERS=list(GA_PLOTS=workers)))

#####
###   updateSGP - used for corrected records
#####

workers <- 8
options(error=recover)

### Load Packages

require(SGP)
require(data.table)

load("./Data/Archive/2018_2019.2/PARCC_SGP.Rdata")
load("../New_Mexico/Data/Archive/2018_2019.2/New_Mexico_Data_LONG_2018_2019.2.Rdata")
# load("../New_Jersey/Data/Archive/2018_2019.2/New_Jersey_Data_LONG_2018_2019.2.Rdata")
# load("../Maryland/Data/Archive/2018_2019.2/Maryland_Data_LONG_2018_2019.2.Rdata")

#   Need to use all student records in order to recreate Ranked SIMEX values correctly
PARCC_SGP@Data <- PARCC_SGP@Data[-which(YEAR == "2018_2019.2" & StateAbbreviation == "NM")] # Remove all original STATE data
# PARCC_2019 <- PARCC_SGP@Data[YEAR == "2018_2019.2" & StateAbbreviation != "NM"] # Remove all original STATE data
# PARCC_SGP@Data <- PARCC_SGP@Data[YEAR != "2018_2019.2" & StateAbbreviation %in% c("IL", "NJ", "NM", "BI", "DD", "MD", "DC")]; gc()
# PARCC_SGP@Data <- rbindlist(list(PARCC_2019, PARCC_SGP@Data), fill = TRUE)
table(PARCC_SGP@Data[, YEAR, StateAbbreviation])
# rm(PARCC_2019);gc()

PARCC_SGP_ORIG <- PARCC_SGP@SGP[["SGPercentiles"]][-grep("INTEGRATED_MATH", names(PARCC_SGP@SGP[["SGPercentiles"]]))] # Use original SGP_SIMEX_RANKED_* for regressions to capture as much info as possible
save(PARCC_SGP_ORIG, file="Data/Archive/2018_2019.2/PARCC_SGP_2019_ORIG_NM.rda")
# tmp.ids <- unique(Maryland_Data_LONG_2018_2019.2[, ID])
tmp.ids <- unique(New_Mexico_Data_LONG_2018_2019.2[, ID])

for (pctl in names(PARCC_SGP@SGP[["SGPercentiles"]][-grep("INTEGRATED_MATH", names(PARCC_SGP@SGP[["SGPercentiles"]]))])) {
	if ("SGP_NOTE" %in% names(PARCC_SGP@SGP[["SGPercentiles"]][[pctl]])) {
		PARCC_SGP@SGP[["SGPercentiles"]][[pctl]] <- PARCC_SGP@SGP[["SGPercentiles"]][[pctl]][-setdiff(which(ID %in% tmp.ids), which(!is.na(SGP_NOTE))),]
		### DUPS removal not done, but should have for NM like this:
		dup.ids <- PARCC_SGP@SGP[["SGPercentiles"]][[pctl]][grep("DUPS", ID), ID]
		if (length(dup.ids) > 0) {
			dups.to.remove <- unique(gsub("_DUPS_1|_DUPS_2", "", dup.ids))
			dups.to.remove <- dups.to.remove[dups.to.remove %in% tmp.ids]
			dups.to.remove <- unique(grep(paste(dup.ids, collapse="|"), dup.ids, value=TRUE))
			PARCC_SGP@SGP[["SGPercentiles"]][[pctl]] <- PARCC_SGP@SGP[["SGPercentiles"]][[pctl]][-setdiff(which(ID %in% dups.to.remove), which(!is.na(SGP_NOTE))),]
			message("Dups in ", pctl, ": ", length(dups.to.remove), " of ", length(unique(dup.ids)), " removed.")
		}
	} else {
		PARCC_SGP@SGP[["SGPercentiles"]][[pctl]] <- PARCC_SGP@SGP[["SGPercentiles"]][[pctl]][-which(ID %in% tmp.ids),]
		dup.ids <- PARCC_SGP@SGP[["SGPercentiles"]][[pctl]][grep("DUPS", ID), ID]
		if (length(dup.ids) > 0) {
			dups.to.remove <- unique(gsub("_DUPS_1|_DUPS_2", "", dup.ids))
			dups.to.remove <- dups.to.remove[dups.to.remove %in% tmp.ids]
			dups.to.remove <- unique(grep(paste(dup.ids, collapse="|"), dup.ids, value=TRUE))
			PARCC_SGP@SGP[["SGPercentiles"]][[pctl]] <- PARCC_SGP@SGP[["SGPercentiles"]][[pctl]][-which(ID %in% dups.to.remove),]
			message("Dups in ", pctl, ": ", length(dups.to.remove), " of ", length(unique(dup.ids)), " removed.")
		}
	}
}

for (pjct in names(PARCC_SGP@SGP[["SGProjections"]])) {
	PARCC_SGP@SGP[["SGProjections"]][[pjct]] <- PARCC_SGP@SGP[["SGProjections"]][[pjct]][-which(ID %in% tmp.ids),]
}
for (sims in names(PARCC_SGP@SGP[["Simulated_SGPs"]])) {
	PARCC_SGP@SGP[["Simulated_SGPs"]][[sims]] <- PARCC_SGP@SGP[["Simulated_SGPs"]][[sims]][-which(ID %in% tmp.ids),]
}


###  Read in the Spring 2019 configuration code and combine into a single list.  Exclude Int Math - no SGPs produced in any progression.

PARCC_2018_2019.2.config <- c(
	ELA.2018_2019.2.config,
	ELA_SS.2018_2019.2.config,

	MATHEMATICS.2018_2019.2.config,
	MATHEMATICS_SS.2018_2019.2.config,

	ALGEBRA_I.2018_2019.2.config,
	ALGEBRA_I_SS.2018_2019.2.config,
	GEOMETRY.2018_2019.2.config,
	GEOMETRY_SS.2018_2019.2.config,
	ALGEBRA_II.2018_2019.2.config,
	ALGEBRA_II_SS.2018_2019.2.config
)

# PARCC_2018_2019.2.config <- c(ELA.2018_2019.2.config)
# Maryland_Data_LONG_2018_2019.2 <- Maryland_Data_LONG_2018_2019.2[CONTENT_AREA=="ELA"]

PARCC_SGP <- updateSGP(
		what_sgp_object = PARCC_SGP,
		# with_sgp_data_LONG = rbindlist(list(PARCC_2019, Maryland_Data_LONG_2018_2019.2), fill = TRUE),
		with_sgp_data_LONG = New_Mexico_Data_LONG_2018_2019.2,
		steps = c("prepareSGP", "analyzeSGP"),#, "combineSGP", "outputSGP"),
		sgp.config = PARCC_2018_2019.2.config, # No Int Math Configs!
		sgp.percentiles = TRUE,
		sgp.projections = TRUE,
		sgp.projections.lagged = TRUE,
		sgp.percentiles.baseline = FALSE,
		sgp.projections.baseline = FALSE,
		sgp.projections.lagged.baseline = FALSE,
		simulate.sgps=TRUE,
		sgp.use.my.coefficient.matrices = TRUE,
		calculate.simex = list(csem.data.vnames="SCALE_SCORE_CSEM", lambda=seq(0,2,0.5),
                        	 simulation.iterations=75, extrapolation="linear",
													 simex.use.my.coefficient.matrices=TRUE), # , ranked.simex.sgps=FALSE
		overwrite.existing.data=FALSE,
		update.old.data.with.new=TRUE,

		goodness.of.fit.print=FALSE,
		save.intermediate.results = FALSE,
		outputSGP.output.type=c("LONG_FINAL_YEAR_Data"), # "LONG_Data",
		outputSGP.directory="./Data/Archive/2018_2019.2",
		parallel.config=list(
			BACKEND = "FOREACH", TYPE = "doParallel",
			WORKERS = list(TAUS = workers, SIMEX = workers, SGP_SCALE_SCORE_TARGETS=10)))

PARCC_SGP_UPDATED <- copy(PARCC_SGP@SGP[["SGPercentiles"]])
# save(PARCC_SGP_UPDATED, file="/media/Data/PARCC/PARCCNM/PARCC_SGP_2019_Updated_NM.rda")
# save(PARCC_SGP, file="/media/Data/PARCC/PARCCNM/PARCC_SGP.rda")

####
###   Post Process @SGP$SGPercentiles to get SGP_SIMEX_RANKED estimated for additional cases.
####

load("Data/Archive/2018_2019.2/PARCC_SGP_2019_ORIG_NM.rda")
require(splines)
smry.diffs <- list()

for (ca in grep("INTEGRATED_MATH", names(PARCC_SGP@SGP[["SGPercentiles"]]), invert=TRUE, value=TRUE)) {
  tmp.SGP_Updated <- copy(PARCC_SGP@SGP[["SGPercentiles"]][[ca]])
	tmp.SGP_Original <- copy(PARCC_SGP_ORIG[[ca]])

  tmp.SGP_Updated[, First_Prior := as.character(NA)]
	tmp.SGP_Original[, First_Prior := as.character(NA)]
  tmp.SGP_Updated[, First_Prior := sapply(strsplit(as.character(tmp.SGP_Updated$SGP_NORM_GROUP), "; "), function(x) rev(x)[2])]
  tmp.SGP_Original[, First_Prior := sapply(strsplit(as.character(tmp.SGP_Original$SGP_NORM_GROUP), "; "), function(x) rev(x)[2])]

	scale.score.split <- strsplit(as.character(tmp.SGP_Updated$SGP_NORM_GROUP_SCALE_SCORES), "; ")
	tmp.SGP_Updated[, Current_Score := as.numeric(sapply(scale.score.split, function(x) rev(x)[1]))]
	tmp.SGP_Updated[, SCALE_SCORE_PRIOR_2 := as.numeric(sapply(scale.score.split, function(x) rev(x)[3]))]

	scale.score.split <- strsplit(as.character(tmp.SGP_Original$SGP_NORM_GROUP_SCALE_SCORES), "; ")
	tmp.SGP_Original[, Current_Score := as.numeric(sapply(scale.score.split, function(x) rev(x)[1]))]
	tmp.SGP_Original[, SCALE_SCORE_PRIOR_2 := as.numeric(sapply(scale.score.split, function(x) rev(x)[3]))]

	tmp.mrg <- merge(tmp.SGP_Updated, tmp.SGP_Original, by=c("ID", "SGP_NORM_GROUP", "Current_Score"), all=TRUE)
	setkey(tmp.mrg, ID, SGP_NORM_GROUP)
	dups <- tmp.mrg[c(which(duplicated(tmp.mrg, by=key(tmp.mrg)))-1, which(duplicated(tmp.mrg, by=key(tmp.mrg)))),]
	ids.to.correct <- unique(dups[, ID])
	add <- tmp.SGP_Updated[, ID][!tmp.SGP_Updated[, ID] %in% tmp.SGP_Original[, ID]]
	rmv <- tmp.SGP_Original[, ID][!tmp.SGP_Original[, ID] %in% tmp.SGP_Updated[, ID]]
	if (length(add) > 0) {
		ids.to.correct <- c(ids.to.correct, add)
	}
	if (length(rmv) > 0) stop("REMOVED!")

	if (length(ids.to.correct) > 0) {
		tmp.SGP_Updated[, TMP_SIMEX_RANKED_ORDER_1 := as.integer(NA)]
		for (norm.group in unique(tmp.SGP_Updated$First_Prior)) {
			tmp.data <- tmp.SGP_Updated[First_Prior == norm.group]
			tmp.orig <- tmp.SGP_Original[First_Prior == norm.group]
			if (all(is.na(tmp.data$SGP_NOTE))) {
				tmp.reg <- lm(SGP_SIMEX_RANKED_ORDER_1 ~ bs(SGP_SIMEX_ORDER_1) + bs(Current_Score) + bs(SCALE_SCORE_PRIOR), data = tmp.orig, model = FALSE)
				tmp.SGP_Updated[First_Prior == norm.group, TMP_SIMEX_RANKED_ORDER_1 := as.integer(round(predict(tmp.reg, tmp.data), 0))]
				tmp.SGP_Updated[TMP_SIMEX_RANKED_ORDER_1<=0L, TMP_SIMEX_RANKED_ORDER_1:=1L]
				tmp.SGP_Updated[TMP_SIMEX_RANKED_ORDER_1>=100L, TMP_SIMEX_RANKED_ORDER_1:=99L]
			}
		}
		smry.diffs[[ca]][["Order_1"]] <- summary(tmp.SGP_Updated[, TMP_SIMEX_RANKED_ORDER_1] - tmp.SGP_Updated[, SGP_SIMEX_RANKED_ORDER_1])
		tmp.SGP_Updated[is.na(SGP_SIMEX_RANKED), SGP_SIMEX_RANKED_ORDER_1 := TMP_SIMEX_RANKED_ORDER_1]

		tmp.SGP_Updated[, TMP_SIMEX_RANKED_ORDER_2 := as.integer(NA)]
		for (norm.group in unique(tmp.SGP_Updated$SGP_NORM_GROUP)) {
			tmp.data <- tmp.SGP_Updated[SGP_NORM_GROUP == norm.group]
			tmp.orig <- tmp.SGP_Original[SGP_NORM_GROUP == norm.group]
			if (all(is.na(tmp.data$SGP_NOTE)) & !all(is.na(tmp.data$SGP_SIMEX_RANKED_ORDER_2))) {
				tmp.reg <- lm(SGP_SIMEX_RANKED_ORDER_2 ~ bs(SGP_SIMEX_ORDER_2) + bs(Current_Score) + bs(SCALE_SCORE_PRIOR) + bs(SCALE_SCORE_PRIOR_2), data = tmp.orig)
				tmp.SGP_Updated[SGP_NORM_GROUP == norm.group, TMP_SIMEX_RANKED_ORDER_2 := as.integer(round(predict(tmp.reg, tmp.data), 0))]
				tmp.SGP_Updated[TMP_SIMEX_RANKED_ORDER_2<=0L, TMP_SIMEX_RANKED_ORDER_2:=1L]
				tmp.SGP_Updated[TMP_SIMEX_RANKED_ORDER_2>=100L, TMP_SIMEX_RANKED_ORDER_2:=99L]
			}
		}
		smry.diffs[[ca]][["Order_2"]] <- summary(tmp.SGP_Updated[, TMP_SIMEX_RANKED_ORDER_2] - tmp.SGP_Updated[, SGP_SIMEX_RANKED_ORDER_2])
		tmp.SGP_Updated[is.na(SGP_SIMEX_RANKED), SGP_SIMEX_RANKED_ORDER_2 := TMP_SIMEX_RANKED_ORDER_2]

		# table(tmp.SGP_Updated[,is.na(SGP_SIMEX_RANKED), SGP_ORDER])
		tmp.SGP_Updated[is.na(SGP_SIMEX_RANKED), SGP_SIMEX_RANKED := SGP_SIMEX_RANKED_ORDER_2]
		tmp.SGP_Updated[is.na(SGP_SIMEX_RANKED), SGP_SIMEX_RANKED := SGP_SIMEX_RANKED_ORDER_1]

		tmp.SGP_Original[, c("First_Prior", "Current_Score", "SCALE_SCORE_PRIOR_2") := NULL]
		tmp.SGP_Updated[, c("First_Prior", "Current_Score", "SCALE_SCORE_PRIOR_2", "TMP_SIMEX_RANKED_ORDER_1", "TMP_SIMEX_RANKED_ORDER_2") := NULL]

		tmp.SGP_Fixed <- rbindlist(list(tmp.SGP_Original[!ID %in% ids.to.correct], tmp.SGP_Updated[ID %in% ids.to.correct]), use.names=TRUE)
		setkey(tmp.SGP_Fixed, ID)

		tmp.SGP_Fixed -> PARCC_SGP@SGP[["SGPercentiles"]][[ca]]
	  # tmp.SGP_Fixed -> tmp_fixed[[ca]]
		smry.diffs[[ca]][["N"]] <- length(ids.to.correct)
		message(ca, " Records changed: ", length(ids.to.correct), " (", length(add), " added)")
		message("\tOriginal: ", nrow(tmp.SGP_Original))
		message("\t Updated: ", nrow(tmp.SGP_Updated))
		message("\t   Fixed: ", nrow(tmp.SGP_Fixed))
	} else {
		tmp.SGP_Original[, c("First_Prior", "Current_Score", "SCALE_SCORE_PRIOR_2") := NULL]
		tmp.SGP_Original -> PARCC_SGP@SGP[["SGPercentiles"]][[ca]]
		message(ca, " Unchanged")
	}
}

save(smry.diffs, file="Data/Archive/2018_2019.2/smry.diffs-NM.rda")

###  Fix NJ
tmp.ids <- unique(New_Jersey_Data_LONG_2018_2019.2[, ID])

for (ca in grep("INTEGRATED_MATH", names(PARCC_SGP@SGP[["SGPercentiles"]]), invert=TRUE, value=TRUE)) {
  tmp.SGP_Updated <- copy(PARCC_SGP@SGP[["SGPercentiles"]][[ca]])
	tmp.SGP_Original <- copy(PARCC_SGP_ORIG[[ca]])

	scale.score.split <- strsplit(as.character(tmp.SGP_Updated$SGP_NORM_GROUP_SCALE_SCORES), "; ")
	tmp.SGP_Updated[, Current_Score := as.numeric(sapply(scale.score.split, function(x) rev(x)[1]))]

	scale.score.split <- strsplit(as.character(tmp.SGP_Original$SGP_NORM_GROUP_SCALE_SCORES), "; ")
	tmp.SGP_Original[, Current_Score := as.numeric(sapply(scale.score.split, function(x) rev(x)[1]))]

	if (ca == "MATHEMATICS.2018_2019.2") {
		tmp.mrg <- merge(tmp.SGP_Updated, tmp.SGP_Original, by=c("ID", "SGP_NORM_GROUP", "Current_Score"), all=TRUE)
		setkey(tmp.mrg, ID, SGP_NORM_GROUP)
		dups <- tmp.mrg[c(which(duplicated(tmp.mrg, by=key(tmp.mrg)))-1, which(duplicated(tmp.mrg, by=key(tmp.mrg)))),]
		ids.to.correct <- unique(dups[GRADE.x==6, ID])
		tmp.SGP_Original <- rbindlist(list(tmp.SGP_Original[!ID %in% ids.to.correct], tmp.SGP_Updated[ID %in% ids.to.correct]))
	}
	setkey(tmp.SGP_Original, ID, SGP_NORM_GROUP, Current_Score)
	setkey(tmp.SGP_Updated, ID, SGP_NORM_GROUP, Current_Score)
  tmp.SGP_Fixed <- tmp.SGP_Original[ID %in% tmp.ids, list(ID, SGP_NORM_GROUP, Current_Score, SGP_SIMEX_RANKED)][tmp.SGP_Updated]
	tmp.SGP_Fixed[!is.na(SGP_SIMEX_RANKED), i.SGP_SIMEX_RANKED := SGP_SIMEX_RANKED]
	tmp.SGP_Fixed[, SGP_SIMEX_RANKED := NULL]
	setnames(tmp.SGP_Fixed, "i.SGP_SIMEX_RANKED", "SGP_SIMEX_RANKED")

	tmp.SGP_Fixed -> PARCC_SGP@SGP[["SGPercentiles"]][[ca]]
}

tmp.SGP_Fixed[ID %in% tmp.ids & !is.na(SGP_SIMEX_RANKED), as.list(summary(SGP_SIMEX_RANKED)), keyby="GRADE"]
# tmp.SGP_Fixed <- tmp.SGP_Original[!is.na(SGP_SIMEX_RANKED), list(ID, SGP_NORM_GROUP, Current_Score, SGP_SIMEX_RANKED)][tmp.SGP_Updated]
# tmp.SGP_Fixed[is.na(SGP_SIMEX_RANKED), SGP_SIMEX_RANKED := i.SGP_SIMEX_RANKED]
# tmp.SGP_Fixed[, i.SGP_SIMEX_RANKED := NULL]
#
# setkey(tmp.SGP_Original, ID, SGP_NORM_GROUP)
# setkey(tmp.SGP_Updated, ID, SGP_NORM_GROUP)
# tmp.SGP_Original[ID %in% ids.to.correct, SGP_SIMEX_RANKED := tmp.SGP_Updated[ID %in% ids.to.correct, SGP_SIMEX_RANKED]]
# tmp.SGP_Original[ID %in% ids.to.correct, SGP_SIMEX_RANKED_ORDER_1 := tmp.SGP_Updated[ID %in% ids.to.correct, SGP_SIMEX_RANKED_ORDER_1]]
# tmp.SGP_Original[ID %in% ids.to.correct, SGP_SIMEX_RANKED_ORDER_2 := tmp.SGP_Updated[ID %in% ids.to.correct, SGP_SIMEX_RANKED_ORDER_2]]

###   Fix NM  --  remove all DUPS - only NM had DUPS in "Original" data

for (pctl in names(PARCC_SGP@SGP[["SGPercentiles"]][-grep("INTEGRATED_MATH", names(PARCC_SGP@SGP[["SGPercentiles"]]))])) {
	if ("SGP_NOTE" %in% names(PARCC_SGP@SGP[["SGPercentiles"]][[pctl]])) {
		dup.ids <- PARCC_SGP@SGP[["SGPercentiles"]][[pctl]][grep("DUPS", ID), ID]
		if (length(dup.ids) > 0) {
			dups.to.remove <- unique(gsub("_DUPS_1|_DUPS_2", "", dup.ids))
			dups.to.remove <- dups.to.remove[dups.to.remove %in% tmp.ids]
			dups.to.remove <- unique(grep(paste(dup.ids, collapse="|"), dup.ids, value=TRUE))
			PARCC_SGP@SGP[["SGPercentiles"]][[pctl]] <- PARCC_SGP@SGP[["SGPercentiles"]][[pctl]][-setdiff(which(ID %in% dups.to.remove), which(!is.na(SGP_NOTE))),]
			message("Dups in ", pctl, ": ", length(dups.to.remove), " of ", length(unique(dup.ids)), " removed.")
		}
	} else {
		dup.ids <- PARCC_SGP@SGP[["SGPercentiles"]][[pctl]][grep("DUPS", ID), ID]
		if (length(dup.ids) > 0) {
			dups.to.remove <- unique(gsub("_DUPS_1|_DUPS_2", "", dup.ids))
			dups.to.remove <- dups.to.remove[dups.to.remove %in% tmp.ids]
			dups.to.remove <- unique(grep(paste(dup.ids, collapse="|"), dup.ids, value=TRUE))
			PARCC_SGP@SGP[["SGPercentiles"]][[pctl]] <- PARCC_SGP@SGP[["SGPercentiles"]][[pctl]][-which(ID %in% dups.to.remove),]
			message("Dups in ", pctl, ": ", length(dups.to.remove), " of ", length(unique(dup.ids)), " removed.")
		}
	}
}

for (pjct in names(PARCC_SGP@SGP[["SGProjections"]])) {
	dup.ids <- PARCC_SGP@SGP[["SGProjections"]][[pjct]][grep("DUPS", ID), ID]
	if (length(dup.ids) > 0) {
		dups.to.remove <- unique(gsub("_DUPS_1|_DUPS_2", "", dup.ids))
		dups.to.remove <- dups.to.remove[dups.to.remove %in% tmp.ids]
		dups.to.remove <- unique(grep(paste(dup.ids, collapse="|"), dup.ids, value=TRUE))
		PARCC_SGP@SGP[["SGProjections"]][[pjct]] <- PARCC_SGP@SGP[["SGProjections"]][[pjct]][-which(ID %in% dups.to.remove),]
		message("Dups in ", pjct, ": ", length(dups.to.remove), " of ", length(unique(dup.ids)), " removed.")
	}
}

for (sims in names(PARCC_SGP@SGP[["Simulated_SGPs"]])) {
	dup.ids <- PARCC_SGP@SGP[["Simulated_SGPs"]][[sims]][grep("DUPS", ID), ID]
	if (length(dup.ids) > 0) {
		dups.to.remove <- unique(gsub("_DUPS_1|_DUPS_2", "", dup.ids))
		dups.to.remove <- dups.to.remove[dups.to.remove %in% tmp.ids]
		dups.to.remove <- unique(grep(paste(dup.ids, collapse="|"), dup.ids, value=TRUE))
		PARCC_SGP@SGP[["Simulated_SGPs"]][[sims]] <- PARCC_SGP@SGP[["Simulated_SGPs"]][[sims]][-which(ID %in% dups.to.remove),]
		message("Dups in ", sims, ": ", length(dups.to.remove), " of ", length(unique(dup.ids)), " removed.")
	}
}


###   Combine and Output (Final Year only for individual states - all at the end.)

# PARCC_SGP <- combineSGP(PARCC_SGP, years = "2018_2019.2")

#     Final combineSGP run after all states are done updating:
PARCC_SGP@SGP[["SGProjections"]] <- PARCC_SGP@SGP[["SGProjections"]][-grep("TARGET_SCALE_SCORES", names(PARCC_SGP@SGP[["SGProjections"]]))]

PARCC_SGP <- combineSGP(PARCC_SGP,
    years = "2018_2019.2",
    sgp.target.scale.scores = TRUE,
    sgp.config = PARCC_2018_2019.2.config,
		parallel.config=list(
			BACKEND = "FOREACH", TYPE = "doParallel",
			WORKERS = list(SGP_SCALE_SCORE_TARGETS=10)))

save(PARCC_SGP, file="Data/Archive/2018_2019.2/PARCC_SGP.Rdata")

outputSGP(PARCC_SGP,
	output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data"),
	outputSGP.directory="./Data/Archive/2018_2019.2",)


table(PARCC_SGP@Data[YEAR == "2018_2019.2", is.na(SGP), TestCode], exclude=NULL)
	        V1
	TestCode  FALSE   TRUE
	   ALG01 335212 106964
	   ALG02 129972  14928
	   ELA03      0 661138
	   ELA04 645592  35410
	   ELA05 661822  34884
	   ELA06 661956  48724
	   ELA07 653066  38860
	   ELA08 644452  36930
	   ELA09 218312  33024
	   ELA10 334044  52582
	   ELA11  60884   9082
	   GEO01 225604  12764
	   MAT03      0 678480
	   MAT04 658606  38728
	   MAT05 673468  37710
	   MAT06 670822  41614
	   MAT07 622488  36844
	   MAT08 502482  32716
	   MAT1I      0   1688
	   MAT2I      0   1516
	   MAT3I      0    420

#  This is from updated... Was identical to orig when checked
table(PARCC_SGP@Data[YEAR == "2018_2019.2", is.na(SGP_SIMEX_RANKED), TestCode], exclude=NULL)
	       V1
	TestCode  FALSE   TRUE
	  ALG01 335218 106966
	  ALG02 129972  14928
	  ELA03      0 661146
	  ELA04 645594  35414
	  ELA05 661824  34886
	  ELA06 661976  48724
	  ELA07 653072  38862
	  ELA08 644452  36932
	  ELA09 218312  33024
	  ELA10 334052  52584
	  ELA11  60884   9082
	  GEO01 225604  12764
	  MAT03      0 678486
	  MAT04 658612  38728
	  MAT05 673470  37712
	  MAT06 670844  41614
	  MAT07 622494  36848
	  MAT08 502482  32718
	  MAT1I      0   1688
	  MAT2I      0   1516
	  MAT3I      0    420

table(PARCC_SGP@Data[YEAR == "2018_2019.2", is.na(SGP_NOTE), TestCode], exclude=NULL)
	        V1
	TestCode  FALSE   TRUE
	   ALG01    286 441890 XXX
	   ALG02   1602 143298 XXX
	   ELA03      0 661138
	   ELA04      0 681002
	   ELA05      0 696706
	   ELA06      0 710680
	   ELA07      0 691926
	   ELA08      0 681382
	   ELA09      0 251336
	   ELA10    582 386044
	   ELA11    332  69634
	   GEO01    560 237808 XXX
	   MAT03      0 678480
	   MAT04      0 697334
	   MAT05      0 711178
	   MAT06      0 712436
	   MAT07      0 659332
	   MAT08      0 535198
	   MAT1I   1276    412
	   MAT2I   1006    510
	   MAT3I    358     62


#####
#####   NJ
#####

table(PARCC_SGP@Data[YEAR == "2018_2019.2", is.na(SGP), TestCode], exclude=NULL)
        V1
TestCode  FALSE   TRUE
   ALG01 335218 106966
   ALG02 129972  14928
   ELA03      0 661146
   ELA04 645594  35414
   ELA05 661824  34886
   ELA06 661976  48724
   ELA07 653072  38862
   ELA08 644452  36932
   ELA09 218312  33024
   ELA10 334052  52584
   ELA11  60884   9082
   GEO01 225604  12764
   MAT03      0 678486
   MAT04 658612  38728
   MAT05 673470  37712
   MAT06 670844  41614
   MAT07 622494  36848
   MAT08 502482  32718
   MAT1I      0   1688
   MAT2I      0   1516
   MAT3I      0    420

table(PARCC_SGP@Data[YEAR == "2018_2019.2", is.na(SGP_SIMEX_RANKED), TestCode], exclude=NULL)
        V1
TestCode  FALSE   TRUE
   ALG01 335218 106966
   ALG02 129972  14928
   ELA03      0 661146
   ELA04 645594  35414
   ELA05 661824  34886
   ELA06 661976  48724
   ELA07 653072  38862
   ELA08 644452  36932
   ELA09 218312  33024
   ELA10 334052  52584
   ELA11  60884   9082
   GEO01 225604  12764
   MAT03      0 678486
   MAT04 658612  38728
   MAT05 673470  37712
   MAT06 670844  41614
   MAT07 622494  36848
   MAT08 502482  32718
   MAT1I      0   1688
   MAT2I      0   1516
   MAT3I      0    420

	 table(PARCC_SGP@Data[YEAR == "2018_2019.2", is.na(SGP_NOTE), TestCode], exclude=NULL)
	         V1
	 TestCode  FALSE   TRUE
	    ALG01    286 441898
	    ALG02   1602 143298
	    ELA03      0 661146
	    ELA04      0 681008
	    ELA05      0 696710
	    ELA06      0 710700
	    ELA07      0 691934
	    ELA08      0 681384
	    ELA09      0 251336
	    ELA10    582 386054
	    ELA11    332  69634
	    GEO01    560 237808
	    MAT03      0 678486
	    MAT04      0 697340
	    MAT05      0 711182
	    MAT06      0 712458
	    MAT07      0 659342
	    MAT08      0 535200
	    MAT1I   1276    412
	    MAT2I   1006    510
	    MAT3I    358     62
