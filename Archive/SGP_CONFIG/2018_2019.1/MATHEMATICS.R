################################################################################
###                                                                          ###
###            SGP Configurations for Fall 2018 EOCT Math subjects           ###
###                                                                          ###
################################################################################

PARCC.Math.Subjects <- c("GEOMETRY", "ALGEBRA_I", "ALGEBRA_II", "INTEGRATED_MATH_1", "INTEGRATED_MATH_2", "INTEGRATED_MATH_3")

ALGEBRA_I.2018_2019.1.config <- list(
	###   Grade Level Priors
	ALGEBRA_I.2018_2019.1 = list(
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "ALGEBRA_I"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2", "2018_2019.1"),
		sgp.grade.sequences=list(c("7", "8", "EOCT")), # ~ 9th grade
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2017_2018.1", GRADE="EOCT"), # Exlcude Fall 2016 Math Subjects.  Include to be safe?  Bring up with PARCC State Leads
		sgp.norm.group.preference=1,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_I.2018_2019.1 = list(  #  SGP_NOTE
		sgp.content.areas=c("MATHEMATICS", "ALGEBRA_I"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.1"),
		sgp.grade.sequences=list(c("7", "EOCT")), # ~ 8th grade Alg 1  -  for SGP_NOTE only (so no need for 2nd prior)
		sgp.norm.group.preference=2,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),

	###   EOCT Priors
	ALGEBRA_I.2018_2019.1 = list(  #  SGP_NOTE
		sgp.content.areas=c("GEOMETRY", "ALGEBRA_I"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=3,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_I.2018_2019.1 = list(  #  SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_1", "ALGEBRA_I"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=4,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),

	ALGEBRA_I.2018_2019.1 = list( #  Fall to Fall period analyses  (Exclude those with ANY Spring math courses)  #  SGP_NOTE
		sgp.content.areas=c("GEOMETRY", "ALGEBRA_I"),
		sgp.panel.years=c("2017_2018.1", "2018_2019.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2017_2018.2", GRADE="EOCT"),  #  Use exclusions for SGP_NOTE
		sgp.norm.group.preference=5,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"))
)


GEOMETRY.2018_2019.1.config <- list(
	###   EOCT (Primary) Priors
	GEOMETRY.2018_2019.1 = list(
		sgp.content.areas=c("MATHEMATICS", "ALGEBRA_I", "GEOMETRY"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2", "2018_2019.1"),
		sgp.grade.sequences=list(c("8", "EOCT", "EOCT")),
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2017_2018.1", GRADE="EOCT"), # Exlcude Fall 2016 Math Subjects
		sgp.norm.group.preference=1,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	GEOMETRY.2018_2019.1 = list(  #  SGP_NOTE
		sgp.content.areas=c("ALGEBRA_II", "GEOMETRY"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=2,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	GEOMETRY.2018_2019.1 = list(  #  SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_1", "GEOMETRY"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=3,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	GEOMETRY.2018_2019.1 = list(  #  SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_2", "GEOMETRY"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=4,
			sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	GEOMETRY.2018_2019.1 = list(  #  SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_3", "GEOMETRY"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=5,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),

	###   Grade Level Priors
	GEOMETRY.2018_2019.1 = list(  #  SGP_NOTE
		sgp.content.areas=c("MATHEMATICS", "GEOMETRY"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.1"),
		sgp.grade.sequences=list(c("8", "EOCT")),
		sgp.norm.group.preference=6,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),

	###   Fall to Fall period analyses
	GEOMETRY.2018_2019.1 = list(  #  SGP_NOTE
		sgp.content.areas=c("ALGEBRA_I", "GEOMETRY"),
		sgp.panel.years=c("2017_2018.1", "2018_2019.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2017_2018.2", GRADE="EOCT"),  #  Leave exclusions for SGP_NOTE
		sgp.norm.group.preference=7,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	GEOMETRY.2018_2019.1 = list(  #  SGP_NOTE
		sgp.content.areas=c("ALGEBRA_II", "GEOMETRY"),
		sgp.panel.years=c("2017_2018.1", "2018_2019.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2017_2018.2", GRADE="EOCT"),  #  Leave exclusions for SGP_NOTE
		sgp.norm.group.preference=8,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"))
)


ALGEBRA_II.2018_2019.1.config <- list(
	###   EOCT (Primary) Priors
	ALGEBRA_II.2018_2019.1 = list(
		sgp.content.areas=c("ALGEBRA_I", "GEOMETRY", "ALGEBRA_II"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2", "2018_2019.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT", "EOCT")),
		sgp.norm.group.preference=0,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_II.2018_2019.1 = list(  #  SGP_NOTE
		sgp.content.areas=c("ALGEBRA_I", "ALGEBRA_II"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=1,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_II.2018_2019.1 = list(  #  SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_1", "ALGEBRA_II"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=2,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_II.2018_2019.1 = list(  #  SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_2", "ALGEBRA_II"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=3,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_II.2018_2019.1 = list(  #  SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_3", "ALGEBRA_II"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=4,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),

	###   Grade Level Priors
	ALGEBRA_II.2018_2019.1 = list(  #  SGP_NOTE   XXX  2019 No grade???  Leave for next year
		sgp.content.areas=c("MATHEMATICS", "ALGEBRA_II"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.1"),
		sgp.grade.sequences=list(c("8", "EOCT")),
		sgp.norm.group.preference=5,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),

	###   Fall to Fall period analyses
	ALGEBRA_II.2018_2019.1 = list(
		sgp.content.areas=c("GEOMETRY", "ALGEBRA_II"),
		sgp.panel.years=c("2017_2018.1", "2018_2019.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2017_2018.2", GRADE="EOCT"),  #  Don't exclude anything from actual analyses (non-SGP_NOTE)
		sgp.norm.group.preference=6,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_II.2018_2019.1 = list(  #  SGP_NOTE
		sgp.content.areas=c("ALGEBRA_I", "ALGEBRA_II"),
		sgp.panel.years=c("2017_2018.1", "2018_2019.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2017_2018.2", GRADE="EOCT"),  #  Leave exclusions for SGP_NOTE
		sgp.norm.group.preference=7,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"))
)
