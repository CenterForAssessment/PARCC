################################################################################
###                                                                          ###
###    SGP Configurations for Fall 2018 EOCT Math subjects - SCALE SCORES    ###
###                                                                          ###
################################################################################

PARCC.Math.Subjects <- c("GEOMETRY_SS", "ALGEBRA_I_SS", "ALGEBRA_II_SS", "INTEGRATED_MATH_1_SS", "INTEGRATED_MATH_2_SS", "INTEGRATED_MATH_3_SS")

ALGEBRA_I_SS.2018_2019.1.config <- list(
	###   Grade Level Priors
	ALGEBRA_I_SS.2018_2019.1 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "MATHEMATICS_SS", "ALGEBRA_I_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2", "2018_2019.1"),
		sgp.grade.sequences=list(c("7", "8", "EOCT")), # ~ 9th grade
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2017_2018.1", GRADE="EOCT"), # Exlcude Fall 2017 Math Subjects.  Include to be safe?  Bring up with PARCC State Leads
		sgp.norm.group.preference=1,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_I_SS.2018_2019.1 = list(  #  SGP_NOTE
		sgp.content.areas=c("MATHEMATICS_SS", "ALGEBRA_I_SS"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.1"),
		sgp.grade.sequences=list(c("7", "EOCT")), # ~ 8th grade Alg 1  -  for SGP_NOTE only (so no need for 2nd prior)
		sgp.norm.group.preference=2,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),

	###   EOCT Priors
	ALGEBRA_I_SS.2018_2019.1 = list(  #  SGP_NOTE
		sgp.content.areas=c("GEOMETRY_SS", "ALGEBRA_I_SS"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=3,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_I_SS.2018_2019.1 = list(  #  SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_1_SS", "ALGEBRA_I_SS"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=4,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),

	ALGEBRA_I_SS.2018_2019.1 = list( #  Fall to Fall period analyses  (Exclude those with ANY Spring math courses)  #  SGP_NOTE
		sgp.content.areas=c("GEOMETRY_SS", "ALGEBRA_I_SS"),
		sgp.panel.years=c("2017_2018.1", "2018_2019.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2017_2018.2", GRADE="EOCT"),  #  Use exclusions for SGP_NOTE
		sgp.norm.group.preference=5,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"))
)


GEOMETRY_SS.2018_2019.1.config <- list(
	###   EOCT (Primary) Priors
	GEOMETRY_SS.2018_2019.1 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "ALGEBRA_I_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2", "2018_2019.1"),
		sgp.grade.sequences=list(c("8", "EOCT", "EOCT")),
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2017_2018.1", GRADE="EOCT"), # Exlcude Fall 2017 Math Subjects
		sgp.norm.group.preference=1,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	GEOMETRY_SS.2018_2019.1 = list(  #  SGP_NOTE
		sgp.content.areas=c("ALGEBRA_II_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=2,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	GEOMETRY_SS.2018_2019.1 = list(  #  SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_1_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=3,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	GEOMETRY_SS.2018_2019.1 = list(  #  SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_2_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=4,
			sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	GEOMETRY_SS.2018_2019.1 = list(  #  SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_3_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=5,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),

	###   Grade Level Priors
	GEOMETRY_SS.2018_2019.1 = list(  #  SGP_NOTE
		sgp.content.areas=c("MATHEMATICS_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.1"),
		sgp.grade.sequences=list(c("8", "EOCT")),
		sgp.norm.group.preference=6,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),

	###   Fall to Fall period analyses
	GEOMETRY_SS.2018_2019.1 = list(  #  SGP_NOTE
		sgp.content.areas=c("ALGEBRA_I_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2017_2018.1", "2018_2019.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2017_2018.2", GRADE="EOCT"),  #  Leave exclusions for SGP_NOTE
		sgp.norm.group.preference=7,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	GEOMETRY_SS.2018_2019.1 = list(  #  SGP_NOTE
		sgp.content.areas=c("ALGEBRA_II_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2017_2018.1", "2018_2019.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2017_2018.2", GRADE="EOCT"),  #  Leave exclusions for SGP_NOTE
		sgp.norm.group.preference=8,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"))
)


ALGEBRA_II_SS.2018_2019.1.config <- list(
	###   EOCT (Primary) Priors
	ALGEBRA_II_SS.2018_2019.1 = list(
		sgp.content.areas=c("ALGEBRA_I_SS", "GEOMETRY_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2", "2018_2019.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT", "EOCT")),
		sgp.norm.group.preference=0,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_II_SS.2018_2019.1 = list(  #  SGP_NOTE
		sgp.content.areas=c("ALGEBRA_I_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=1,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_II_SS.2018_2019.1 = list(  #  SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_1_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=2,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_II_SS.2018_2019.1 = list(  #  SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_2_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=3,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_II_SS.2018_2019.1 = list(  #  SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_3_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=4,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),

	###   Grade Level Priors
	ALGEBRA_II_SS.2018_2019.1 = list(  #  SGP_NOTE   XXX  2019 No grade???  Leave for next year
		sgp.content.areas=c("MATHEMATICS_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.1"),
		sgp.grade.sequences=list(c("8", "EOCT")),
		sgp.norm.group.preference=5,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),

	###   Fall to Fall period analyses
	ALGEBRA_II_SS.2018_2019.1 = list(
		sgp.content.areas=c("GEOMETRY_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2017_2018.1", "2018_2019.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2017_2018.2", GRADE="EOCT"),  #  Don't exclude anything from actual analyses (non-SGP_NOTE)
		sgp.norm.group.preference=6,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_II_SS.2018_2019.1 = list(  #  SGP_NOTE
		sgp.content.areas=c("ALGEBRA_I_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2017_2018.1", "2018_2019.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2017_2018.2", GRADE="EOCT"),  #  Leave exclusions for SGP_NOTE
		sgp.norm.group.preference=7,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"))
)
