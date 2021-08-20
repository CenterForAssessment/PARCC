################################################################################
###                                                                          ###
###   Calculate multiple imputation scores and SGPs for 2021 for Illinois    ###
###                                                                          ###
################################################################################

###   Load SGP package
require(SGP)
require(data.table)
require(cfaTools)

###   Load Data
load("Data/Archive/2020_2021.2/Illinois_SGP_LONG_Data.Rdata")

# setnames(Illinois_SGP_LONG_Data,
#   c("AccountableDistrictCode", "AccountableSchoolCode"),
#   c("DISTRICT_NUMBER", "SCHOOL_NUMBER"))
Illinois_SGP_LONG_Data[, SCHOOL_NUMBER := factor(AccountableSchoolCode)]
Illinois_SGP_LONG_Data[, DISTRICT_NUMBER := factor(AccountableDistrictCode)]
sch.levels <- levels(Illinois_SGP_LONG_Data$SCHOOL_NUMBER)
dist.levels <- levels(Illinois_SGP_LONG_Data$DISTRICT_NUMBER)
Illinois_SGP_LONG_Data[, SCHOOL_NUMBER := as.integer(SCHOOL_NUMBER)]
Illinois_SGP_LONG_Data[, DISTRICT_NUMBER := as.integer(DISTRICT_NUMBER)]

Illinois_SGP_LONG_Data[, Sex := ifelse(Sex == "F", 1, 0)]
Illinois_SGP_LONG_Data[, EnglishLearnerEL := ifelse(EnglishLearnerEL == "Y", 1, 0)]
Illinois_SGP_LONG_Data[, EconomicDisadvantageStatus := ifelse(EconomicDisadvantageStatus == "Y", 1, 0)]
Illinois_SGP_LONG_Data[, StudentWithDisabilities := ifelse(StudentWithDisabilities %in% c("N", ""), 0, 1)]
Illinois_SGP_LONG_Data[, BlackOrAfricanAmerican := ifelse(BlackOrAfricanAmerican %in% "Y", 1, 0)]
Illinois_SGP_LONG_Data[, HispanicOrLatinoEthnicity := ifelse(HispanicOrLatinoEthnicity %in% "Y", 1, 0)]
Illinois_SGP_LONG_Data[, White := ifelse(White %in% "Y", 1, 0)]
Illinois_SGP_LONG_Data[, Asian := ifelse(Asian %in% "Y", 1, 0)]

###   Preliminary Partial Fill

default.vars = c("CONTENT_AREA", "GRADE", "ACHIEVEMENT_LEVEL", "SCALE_SCORE", "SGP", "SGP_BASELINE")
demographics = c("EconomicDisadvantageStatus", "StudentWithDisabilities", "EnglishLearnerEL",
                 "Sex", "BlackOrAfricanAmerican", "HispanicOrLatinoEthnicity", "White", "Asian")
institutions = c("SCHOOL_NUMBER", "DISTRICT_NUMBER", "AccountableDistrictCode", "AccountableSchoolCode")

table(Illinois_SGP_LONG_Data[, GRADE, YEAR])
Illinois_SGP_LONG_Data[, GRADE := as.integer(GRADE)]
Illinois_SGP_LONG_Data[, YEAR := factor(YEAR)]
setattr(Illinois_SGP_LONG_Data$YEAR, "levels", c("2018", "2019", "2020", "2021"))

long.to.wide.vars <- c(default.vars, institutions, demographics)
tmp.wide <- dcast(Illinois_SGP_LONG_Data, ID + CONTENT_AREA ~ YEAR, sep=".", drop=FALSE, value.var=long.to.wide.vars)

##    Trim things down - remove cases with NAs in 2 most recent years
tmp.wide <- tmp.wide[!(is.na(SCALE_SCORE.2019) & is.na(SCALE_SCORE.2021))]

##  Fill in GRADE according to our expectations of normal progression
summary(tmp.wide[, grep("GRADE", names(tmp.wide), value=T), with=FALSE])
for (i in 1:7) { # Do this a couple times - 6 should get them all - 86 left
  tmp.wide[is.na(GRADE.2018), GRADE.2018 := GRADE.2019-1L]
  tmp.wide[is.na(GRADE.2018), GRADE.2018 := GRADE.2020-2L]
  tmp.wide[is.na(GRADE.2018), GRADE.2018 := GRADE.2021-3L]
  tmp.wide[is.na(GRADE.2019), GRADE.2019 := GRADE.2020-1L]
  tmp.wide[is.na(GRADE.2019), GRADE.2019 := GRADE.2021-2L]
  tmp.wide[is.na(GRADE.2020), GRADE.2020 := GRADE.2021-1L]

  tmp.wide[is.na(GRADE.2021), GRADE.2021 := GRADE.2020+1L]
  tmp.wide[is.na(GRADE.2021), GRADE.2021 := GRADE.2019+2L]
  tmp.wide[is.na(GRADE.2021), GRADE.2021 := GRADE.2018+3L]
  tmp.wide[is.na(GRADE.2020), GRADE.2020 := GRADE.2019+1L]
  tmp.wide[is.na(GRADE.2020), GRADE.2020 := GRADE.2018+2L]
  tmp.wide[is.na(GRADE.2019), GRADE.2019 := GRADE.2018+1L]
}
summary(tmp.wide[, grep("GRADE", names(tmp.wide), value=T), with=FALSE])

meas.list <- vector(mode = "list", length = length(long.to.wide.vars))
meas.list <- lapply(long.to.wide.vars, function(f) meas.list[[f]] <- grep(paste0(f, "[.]"), names(tmp.wide)))
names(meas.list) <- long.to.wide.vars

###   First stretch out to get missings in log data
long.final <- melt(tmp.wide, id = c("ID", "CONTENT_AREA"), variable.name = "YEAR", measure=meas.list)
long.final[, CONTENT_AREA.1 := NULL]

##  Exclude non-existent GRADE levels
long.final <- long.final[GRADE %in% 3:8]
table(long.final[, GRADE, YEAR])

###   Fill in demographics
setkey(long.final, ID, YEAR)
long.final <- data.table(dplyr::ungroup(tidyr::fill(dplyr::group_by(long.final, ID),
                        tidyselect::all_of(demographics), .direction="downup")))

###   Fill in school numbers (CLUDGE) - try to figure out how to do with random forrest or something better...
tmp.long.elem <- long.final[GRADE %in% c(3:5)]
tmp.long.elem <- data.table(dplyr::ungroup(tidyr::fill(dplyr::group_by(tmp.long.elem, ID),
                              SCHOOL_NUMBER, .direction="updown")))
# tmp.long.elem[is.na(SCHOOL_NUMBER), SCHOOL_NUMBER :=
#     sample(unique(na.omit(tmp.long.elem$SCHOOL_NUMBER)), size=sum(is.na(tmp.long.elem$SCHOOL_NUMBER)), replace=TRUE)]

tmp.long.mid <- long.final[GRADE %in% c(6:8)]
tmp.long.mid <- data.table(dplyr::ungroup(tidyr::fill(dplyr::group_by(tmp.long.mid, ID),
                            SCHOOL_NUMBER, .direction="updown")))
# tmp.long.mid[is.na(SCHOOL_NUMBER), SCHOOL_NUMBER :=
#     sample(unique(na.omit(tmp.long.mid$SCHOOL_NUMBER)), size=sum(is.na(tmp.long.mid$SCHOOL_NUMBER)), replace=TRUE)]

Illinois_SGP_LONG_Data <- rbindlist(list(tmp.long.elem, tmp.long.mid))
setkey(Illinois_SGP_LONG_Data, ID, YEAR)

Illinois_SGP_LONG_Data <- data.table(dplyr::ungroup(tidyr::fill(dplyr::group_by(Illinois_SGP_LONG_Data, ID),
                                          DISTRICT_NUMBER, .direction="updown")))

setattr(Illinois_SGP_LONG_Data$YEAR, "levels", c("2017_2018.2", "2018_2019.2", "2019_2020.2", "2020_2021.2"))
Illinois_SGP_LONG_Data[, YEAR := as.character(YEAR)]

Illinois_SGP_LONG_Data <- Illinois_SGP_LONG_Data[YEAR != "2019_2020.2"]
Illinois_SGP_LONG_Data[, GRADE := as.character(GRADE)]
Illinois_SGP_LONG_Data[, VALID_CASE := "VALID_CASE"]
rm(list=c("long.final", "tmp.wide", "tmp.long.elem", "tmp.long.mid"));gc()


#####
###   Scale Score Imputation
#####

##   Read in GROWTH and STATUS imputation configs
source("../SGP_CONFIG/2020_2021.2/MULTIPLE_IMPUTATION/ELA.R")
source("../SGP_CONFIG/2020_2021.2/MULTIPLE_IMPUTATION/MATHEMATICS.R")

##    Set up a couple imputeScaleScore arguents used in message log
my.impute.method <- "2l.pan"
my.impute.long <- FALSE

dir.create("Data/Archive/2020_2021.2/Imputation/diagnostics/", recursive=TRUE)

tmp.messages <- paste("\n\t#####  BEGIN Scale Score Imputation", date(), "  #####\n")
started.impute <- proc.time()

##    Impute missing scale scores
Illinois_2021_Imputed <- imputeScaleScore(
	impute.data = Illinois_SGP_LONG_Data,
	additional.data = NULL,
	include.additional.missing = TRUE, # FALSE to just include kids in data (October Count)
	return.current.year.only = TRUE,
	compact.results = TRUE,
	diagnostics.dir = "Data/Archive/2020_2021.2/Imputation",
	growth.config = c(ela_imputation_config_2021, math_imputation_config_2021),
	# status.config = status_config_2021,
	default.vars = c("CONTENT_AREA", "GRADE", "SCALE_SCORE", "ACHIEVEMENT_LEVEL"),
  demographics = c("EconomicDisadvantageStatus", "StudentWithDisabilities", "EnglishLearnerEL",
                   "Sex", "BlackOrAfricanAmerican", "HispanicOrLatinoEthnicity", "White", "Asian"),
	institutions = c("SCHOOL_NUMBER", "DISTRICT_NUMBER", "AccountableDistrictCode", "AccountableSchoolCode"),
	impute.factors = c("DISTRICT_NUMBER", "SCALE_SCORE",
	                   "EconomicDisadvantageStatus", "StudentWithDisabilities", "EnglishLearnerEL",
                     "Sex", "BlackOrAfricanAmerican", "HispanicOrLatinoEthnicity", "White", "Asian"),
	impute.long = my.impute.long,
	impute.method = my.impute.method,
	cluster.institution = TRUE,
	partial.fill = TRUE,
	parallel.config = list(packages = "mice", cores = 15),
	seed = 2072L,
	M = 30,
	maxit = 10,
	verbose=TRUE,
	allow.na=TRUE)

tmp.messages <- c(tmp.messages, paste("\n\t\tRaw Scale Score", my.impute.method, "LONG"[my.impute.long], "Imputation completed in", SGP:::convertTime(SGP:::timetakenSGP(started.impute))))

# save(Illinois_2021_Imputed, file="Data/Archive/2020_2021.2/Imputation/Illinois_2021_Imputed.rda")
# Illinois_2021_Imputed[, SN2 := factor(SCHOOL_NUMBER, labels=sch.levels)]
# Illinois_2021_Imputed[, DN2 := factor(DISTRICT_NUMBER, labels=dist.levels)]

Illinois_2021_Imputed[, SCHOOL_NUMBER := AccountableSchoolCode]
Illinois_2021_Imputed[, DISTRICT_NUMBER := AccountableDistrictCode]

#####
###   SGP Analyses with Imputed Scale Scores
#####

started.sgp <- proc.time()

##    Create temporary pre-COVID (2018-2020) SGP Object from LONG data from above
# load("Data/Archive/2020_2021.2/Illinois_SGP_LONG_Data.Rdata")
Illinois_SGP_PreCovid <- prepareSGP(Illinois_SGP_LONG_Data[YEAR < "2020_2021.2"], create.additional.variables = FALSE)

###   Add single-cohort baseline matrices to SGPstateData
load("./Data/Illinois_Baseline_Matrices.Rdata")
SGPstateData[["IL"]][["Baseline_splineMatrix"]][["Coefficient_Matrices"]] <- Illinois_Baseline_Matrices

SGPstateData[["IL"]][["Assessment_Program_Information"]][["CSEM"]] <- NULL

###   Read in BASELINE projections configuration scripts and combine
source("../SGP_CONFIG/2020_2021.2/PART_A/ELA.R")
source("../SGP_CONFIG/2020_2021.2/PART_A/MATHEMATICS.R")

ELA_IL <- ELA_2020_2021.2.config
ELA_IL[[1]]$sgp.grade.sequences <- ELA_IL[[1]]$sgp.grade.sequences[1:4]

IL_2021_CONFIG_PART_A <- c(
	ELA_IL, # ELA_2020_2021.2.config,
	MATHEMATICS_2020_2021.2.config
)


# setwd("/home/ec2-user/SGP/PARCC_Test/Illinois")


##   Parallel processing for SGP analyses
sgp.cores <- 13
parallel.config <- list(
  BACKEND="PARALLEL",
  WORKERS=list(PERCENTILES = sgp.cores, BASELINE_PERCENTILES = sgp.cores))#,
               # PROJECTIONS = sgp.cores, LAGGED_PROJECTIONS = sgp.cores,
               # SGP_SCALE_SCORE_TARGETS = sgp.cores))

imputation.n <- length(grep("SCORE_IMP_", names(Illinois_2021_Imputed)))

variables.to.get <- c("VALID_CASE", "ID", "YEAR", "CONTENT_AREA", "GRADE",
                      "SCALE_SCORE", "ACHIEVEMENT_LEVEL", "SCHOOL_NUMBER", "DISTRICT_NUMBER")

variables.to.keep <- c("VALID_CASE", "ID", "YEAR", "CONTENT_AREA", "GRADE",
                       "SCALE_SCORE", "SGP", "SGP_BASELINE", "SCHOOL_NUMBER", "DISTRICT_NUMBER")

##    Run SGP analyses on each imputation (using `updateSGP`)
Imputed_SGP_Data <- data.table()
setwd("Data/Archive/2020_2021.2/Imputation")

for (IMP in seq(imputation.n)) {
  Illinois_Data_LONG_2021 <- copy(Illinois_2021_Imputed[, c(variables.to.get, paste0("SCORE_IMP_", IMP)), with=FALSE])
  setnames(Illinois_Data_LONG_2021, c("SCALE_SCORE", paste0("SCORE_IMP_", IMP)), c("SCALE_SCORE_OBSERVED", "SCALE_SCORE"))

  ##  Force scores outside LOSS/HOSS back into range
  for (CA in c("ELA", "MATHEMATICS")) {
    for (G in 3:8) {
      tmp.loss <- SGPstateData[["IL"]][["Achievement"]][["Knots_Boundaries"]][[CA]][[paste0("loss.hoss_", G)]][1]
      tmp.hoss <- SGPstateData[["IL"]][["Achievement"]][["Knots_Boundaries"]][[CA]][[paste0("loss.hoss_", G)]][2]
      Illinois_Data_LONG_2021[CONTENT_AREA == CA & GRADE == G & SCALE_SCORE < tmp.loss, SCALE_SCORE := tmp.loss]
      Illinois_Data_LONG_2021[CONTENT_AREA == CA & GRADE == G & SCALE_SCORE > tmp.hoss, SCALE_SCORE := tmp.hoss]
    }
  }

  TEMP_SGP <- updateSGP(
          what_sgp_object = Illinois_SGP_PreCovid,
          with_sgp_data_LONG = Illinois_Data_LONG_2021,
          steps = c("prepareSGP", "analyzeSGP", "combineSGP"),
          sgp.config = IL_2021_CONFIG_PART_A,
          sgp.percentiles = TRUE,
          sgp.projections = FALSE,
          sgp.projections.lagged = FALSE,
          sgp.percentiles.baseline = TRUE,
          sgp.projections.baseline = FALSE,
          sgp.projections.lagged.baseline = FALSE,
          simulate.sgps=FALSE,
          goodness.of.fit.print = FALSE,
          save.intermediate.results = FALSE,
          parallel.config=parallel.config
  )

  Imputed_SGP_Data <- rbindlist(list(Imputed_SGP_Data, TEMP_SGP@Data[YEAR == "2020_2021.2", variables.to.keep, with = FALSE][, IMP_N := IMP]))
  message(paste("\n\tSGP", my.impute.method, "LONG"[my.impute.long], "Imputation analysis -- IMP:", IMP, "-- completed", date()))
}  #  END IMP

Illinois_SGP_Data_Imputed <- dcast(Imputed_SGP_Data, VALID_CASE + ID + YEAR + CONTENT_AREA + GRADE ~ IMP_N,
  sep = "_IMPUTED_", drop = FALSE, value.var = c("SCHOOL_NUMBER", "DISTRICT_NUMBER", "SCALE_SCORE", "SGP", "SGP_BASELINE"))
Illinois_SGP_Data_Imputed <- Illinois_SGP_Data_Imputed[!is.na(SCALE_SCORE_IMPUTED_1)]
setnames(Illinois_SGP_Data_Imputed, c("SCHOOL_NUMBER_IMPUTED_1", "DISTRICT_NUMBER_IMPUTED_1"), c("SCHOOL_NUMBER", "DISTRICT_NUMBER"))
Illinois_SGP_Data_Imputed[, grep("SCHOOL_NUMBER_IMPUTED_|DISTRICT_NUMBER_IMPUTED_", names(Illinois_SGP_Data_Imputed)) := NULL]
tmp.messages <- c(tmp.messages, paste("\n\t\tSGP Analysis with", IMP, "imputations", "completed in", SGP:::convertTime(SGP:::timetakenSGP(started.sgp))))

setwd("../../../../")
save(Illinois_SGP_Data_Imputed, file="Data/Archive/2020_2021.2/Imputation/Illinois_SGP_Data_Imputed.rda")


#####
###   Summaries/Imputation Statistics
#####

started.smry <- proc.time()

setkeyv(Illinois_SGP_Data_Imputed, SGP:::getKey(Illinois_SGP_Data_Imputed))

##   Merge (2021 only):
Illinois_SGP_LONG_Data[, c("SCHOOL_NUMBER", "DISTRICT_NUMBER") := NULL]
Summary_Data <- Illinois_SGP_LONG_Data[Illinois_SGP_Data_Imputed]
Summary_Data[is.na(SCHOOL_NUMBER), SCHOOL_NUMBER := "MISSING"]
Summary_Data[is.na(DISTRICT_NUMBER), DISTRICT_NUMBER := "MISSING"]

setnames(Summary_Data, c("SCALE_SCORE", "SGP", "SGP_BASELINE"), c("SCALE_SCORE_OBSERVED", "SGP_OBSERVED", "SGP_BASELINE_OBSERVED"))

setDTthreads(threads = min(15, parallel::detectCores(logical = FALSE)), throttle = 1024)
if (!dir.exists("Data/Archive/2020_2021.2/Imputation/Summary_Tables")) dir.create("Data/Archive/2020_2021.2/Imputation/Summary_Tables", recursive = TRUE)

Tmp_Summaries <- list()
Tmp_Summaries[["STATE"]][["GRADE"]] <- imputationSummary(Summary_Data, summary.level = "GRADE")
Tmp_Summaries[["STATE"]][["CONTENT"]] <- imputationSummary(Summary_Data, summary.level = "CONTENT_AREA")
Tmp_Summaries[["STATE"]][["GRADE_CONTENT"]] <- imputationSummary(Summary_Data, summary.level = c("GRADE", "CONTENT_AREA"))
Tmp_Summaries[["DISTRICT"]][["GLOBAL"]] <- imputationSummary(Summary_Data, summary.level = NULL, institution.level = "DISTRICT_NUMBER")
Tmp_Summaries[["DISTRICT"]][["GRADE"]] <- imputationSummary(Summary_Data, summary.level = "GRADE", institution.level = "DISTRICT_NUMBER")
Tmp_Summaries[["DISTRICT"]][["CONTENT"]] <- imputationSummary(Summary_Data, summary.level = "CONTENT_AREA", institution.level = "DISTRICT_NUMBER")
Tmp_Summaries[["DISTRICT"]][["GRADE_CONTENT"]] <- imputationSummary(Summary_Data, summary.level = c("GRADE", "CONTENT_AREA"), institution.level = "DISTRICT_NUMBER")
Tmp_Summaries[["SCHOOL"]][["GLOBAL"]] <- imputationSummary(Summary_Data, summary.level = NULL, institution.level = "SCHOOL_NUMBER")
Tmp_Summaries[["SCHOOL"]][["GRADE"]] <- imputationSummary(Summary_Data, summary.level = "GRADE", institution.level = "SCHOOL_NUMBER")
Tmp_Summaries[["SCHOOL"]][["CONTENT"]] <- imputationSummary(Summary_Data, summary.level = "CONTENT_AREA", institution.level = "SCHOOL_NUMBER")
Tmp_Summaries[["SCHOOL"]][["GRADE_CONTENT"]] <- imputationSummary(Summary_Data, summary.level = c("GRADE", "CONTENT_AREA"), institution.level = "SCHOOL_NUMBER")
tmp.messages <- c(tmp.messages, paste("\n\t\tSGP Imputation summaries with 30 imputations completed in ", SGP:::convertTime(SGP:::timetakenSGP(started.smry))))

assign("Illinois_Imputation_Summaries", Tmp_Summaries)
save(Illinois_Imputation_Summaries, file="Data/Archive/2020_2021.2/Imputation/Summary_Tables/Illinois_Imputation_Summaries.rda")

tmp.messages <- c(tmp.messages, paste("\n\n\t#####  END FULL ANALYSES", date(), "  #####\n\n"))
messageLog(log.message = tmp.messages, logfile = "Illinois_Imputation_Analyses.txt", log.directory = "Data/Archive/2020_2021.2/Imputation/Logs")

###   Investigate summaries

nrow(Tmp_Summaries[["SCHOOL"]][["GLOBAL"]][["Summary"]][Percent_Missing == 0,]) # 796/1649
summary(Tmp_Summaries[["SCHOOL"]][["GLOBAL"]][["Summary"]][Percent_Missing == 0, N])
hist(Tmp_Summaries[["SCHOOL"]][["GLOBAL"]][["Summary"]][Percent_Missing == 0, N], breaks = 50)
nrow(Tmp_Summaries[["SCHOOL"]][["GLOBAL"]][["Summary"]][Percent_Missing == 0 & N > 9,]) # 381/1649 # 23% > 9, 3.6% > 49
length(unique(Tmp_Summaries[["SCHOOL"]][["GRADE"]][["Summary"]][Percent_Missing == 0, SCHOOL_NUMBER]))

nrow(Tmp_Summaries[["SCHOOL"]][["GLOBAL"]][["Summary"]][Percent_Missing == 100,])
summary(Tmp_Summaries[["SCHOOL"]][["GLOBAL"]][["Summary"]][Percent_Missing == 100, N])
miss.100 <- Tmp_Summaries[["SCHOOL"]][["GLOBAL"]][["Summary"]][Percent_Missing == 100, SCHOOL_NUMBER] # lots of Onlie/Virtual academies & Charters
data.table(unique(Illinois_SGP_LONG_Data[YEAR == "2020_2021.2" & SCHOOL_NUMBER %in% miss.100,
					list(DISTRICT_NUMBER, SCHOOL_NUMBER, DISTRICT_NAME, SCHOOL_NAME)]), key=c("DISTRICT_NUMBER", "SCHOOL_NUMBER"))

summary(Tmp_Summaries[["SCHOOL"]][["GLOBAL"]][["Summary"]][Percent_Missing != 0 & Percent_Missing != 100, N])
big.schools <- Tmp_Summaries[["SCHOOL"]][["GLOBAL"]][["Summary"]][N > 349, SCHOOL_NUMBER]
big.schools <- data.table(unique(Illinois_SGP_LONG_Data[YEAR == "2020_2021.2" & SCHOOL_NUMBER %in% big.schools,
                            list(DISTRICT_NUMBER, SCHOOL_NUMBER, DISTRICT_NAME, SCHOOL_NAME)]), key="DISTRICT_NUMBER")
big.schools # 4024, 5685

nrow(Tmp_Summaries[["SCHOOL"]][["GRADE"]][["Summary"]][Percent_Missing == 0,]) # 796/1649
summary(Tmp_Summaries[["SCHOOL"]][["GLOBAL"]][["Summary"]][Percent_Missing == 0, N])
nrow(Tmp_Summaries[["SCHOOL"]][["GLOBAL"]][["Summary"]][Percent_Missing == 100,])
summary(Tmp_Summaries[["SCHOOL"]][["GLOBAL"]][["Summary"]][Percent_Missing == 100, N])

###
##    Schools ELL Enrollement Changes
###

sch_size <- Illinois_SGP_LONG_Data[,
								list(SCORE_COUNT = sum(!is.na(SCALE_SCORE)),
                     TOTAL = .N),
									keyby = c("YEAR", "SCHOOL_NUMBER")]
setkey(sch_size, YEAR, SCORE_COUNT)

sch_size[, as.list(summary(TOTAL)), keyby = c("YEAR")]
sch_size[, as.list(summary(SCORE_COUNT)), keyby = c("YEAR")]

sch_size[, as.list(quantile(TOTAL, probs = seq(0, 1, 0.05))), keyby = c("YEAR")]
sch_size[, as.list(quantile(SCORE_COUNT, probs = seq(0, 1, 0.05))), keyby = c("YEAR")]

sch_size_wide <- dcast(sch_size[YEAR > 2018], SCHOOL_NUMBER ~ YEAR, value.var = c("TOTAL", "SCORE_COUNT"))
summary(sch_size_wide[, TOTAL_2021])
summary(sch_size_wide[, TOTAL_2020 - TOTAL_2021])
sch_size_wide[TOTAL_2020 > 500, SCHOOL_NUMBER]
sch_size_wide[TOTAL_2021 > 500, SCHOOL_NUMBER]
sch_size[SCHOOL_NUMBER=="6914"]

sch_size_wide[, PCT_CHANGE_1_YEAR := TOTAL_2021/TOTAL_2020]
sch_size_wide[, PCT_CHANGE_2_YEAR := TOTAL_2021/rowMeans(.SD, na.rm=TRUE), .SDcols = c("TOTAL_2019", "TOTAL_2020")]
summary(sch_size_wide[, PCT_CHANGE_1_YEAR])
summary(sch_size_wide[, PCT_CHANGE_2_YEAR])

# big.increase <- sch_size_wide[TOTAL_2020 > 29 & PCT_CHANGE_2_YEAR > 1.25, SCHOOL_NUMBER] # moderately big increase, decent size
big.increase <- sch_size_wide[PCT_CHANGE_2_YEAR > 2, SCHOOL_NUMBER]
data.table(sch_size_wide[SCHOOL_NUMBER %in% big.increase], key="SCHOOL_NUMBER")
data.table(unique(Illinois_SGP_LONG_Data[YEAR == "2020_2021.2" & SCHOOL_NUMBER %in% big.increase,
					list(DISTRICT_NUMBER, SCHOOL_NUMBER, DISTRICT_NAME, SCHOOL_NAME)]), key=c("DISTRICT_NUMBER", "SCHOOL_NUMBER"))
# All these are "Astravo Online Academy" in Byers 32J district, 6241 is another Virtual. 1176 is Byers jr/sr high - the only one that tested in 2021
sch_size_wide[SCHOOL_NUMBER %in% c(9033, 8994, 3362)]


##    DPS
dps.schools <- unique(Summary_Data[DISTRICT_NUMBER == "0880", SCHOOL_NUMBER])

DPS_GC <- Tmp_Summaries[["SCHOOL"]][["GRADE"]][["Summary"]][SCHOOL_NUMBER %in% dps.schools]
summary(DPS_GC[, Mean_SS_Observed - Mean_SS_Imputed])
summary(DPS_GC[N > 9, Mean_SS_Observed - Mean_SS_Imputed])

hist(DPS_GC[N > 9, Percent_Missing], breaks = 50)

dim(DPS_GC[Percent_Missing == 0,])
length(unique(DPS_GC[Percent_Missing == 0, SCHOOL_NUMBER]))
summary(DPS_GC[Percent_Missing == 0, N])

dim(DPS_GC[Percent_Missing != 0 & !is.na(SS_F_p_simp) & SS_F_p_simp < 0.05])
dim(DPS_GC[Percent_Missing != 0 & !is.na(SGP_F_p_simp) & SGP_F_p_simp < 0.05])
dim(DPS_GC[Percent_Missing != 0 & !is.na(SGPB_F_p_simp) & SGPB_F_p_simp < 0.05])

summary(DPS_GC[Percent_Missing != 0 & !is.na(SGPB_F_p_simp) & SGPB_F_p_simp < 0.05, N])
summary(DPS_GC[Percent_Missing != 0 & !is.na(SGPB_F_p_simp) & SGPB_F_p_simp < 0.05, Percent_Missing])


##    Adams-Arapahoe 28J
aaps.schools <- unique(Summary_Data[DISTRICT_NUMBER == "0180", SCHOOL_NUMBER])

AAPS_GC <- Tmp_Summaries[["SCHOOL"]][["GRADE"]][["Summary"]][SCHOOL_NUMBER %in% aaps.schools]


##    Charter "districts"
unique(Illinois_SGP_LONG_Data[YEAR == "2020_2021.2" & DISTRICT_NUMBER %in% c("8001"), list(DISTRICT_NUMBER, SCHOOL_NUMBER, DISTRICT_NAME, SCHOOL_NAME)])

all.dist <- unique(Illinois_SGP_LONG_Data[YEAR == "2020_2021.2", list(DISTRICT_NUMBER, DISTRICT_NAME)])
setkey(all.dist, DISTRICT_NUMBER)
tail(all.dist, 25)
all.dist[1:25,]
all.dist[26:50,]
all.dist[51:75,]

##    "Online" schools
virtual.schools <- unique(Illinois_SGP_LONG_Data[YEAR == "2020_2021.2" & grepl("ONLINE", toupper(SCHOOL_NAME)), list(DISTRICT_NUMBER, SCHOOL_NUMBER, DISTRICT_NAME, SCHOOL_NAME)])

VIRTUAL_GC <- Tmp_Summaries[["SCHOOL"]][["GRADE"]][["Summary"]][SCHOOL_NUMBER %in% virtual.schools$SCHOOL_NUMBER]
summary(VIRTUAL_GC[, Mean_SS_Observed - Mean_SS_Imputed])
summary(VIRTUAL_GC[N > 9, Mean_SS_Observed - Mean_SS_Imputed])

hist(VIRTUAL_GC[, N], breaks = 50) # No BIG ones identified
hist(VIRTUAL_GC[, Percent_Missing], breaks = 50)
