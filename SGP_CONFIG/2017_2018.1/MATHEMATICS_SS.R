#####################################################################################
###                                                                               ###
###      SGP Configurations for Fall 2017 EOCT Math subjects  -  SCALE SCORES     ###
###                                                                               ###
#####################################################################################

PARCC.Math.Subjects <- c("GEOMETRY_SS", "ALGEBRA_I_SS", "ALGEBRA_II_SS", "INTEGRATED_MATH_1_SS", "INTEGRATED_MATH_2_SS", "INTEGRATED_MATH_3_SS")

ALGEBRA_I_SS.2017_2018.1.config <- list(
	###   Grade Level Priors
	ALGEBRA_I_SS.2017_2018.1 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "MATHEMATICS_SS", "ALGEBRA_I_SS"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.2", "2017_2018.1"),
		sgp.grade.sequences=list(c("7", "8", "EOCT")), # ~ 9th grade
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2016_2017.1", GRADE="EOCT"), # Exlcude Fall 2016 Math Subjects.  Include to be safe?  Bring up with PARCC State Leads
		sgp.norm.group.preference=1,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_I_SS.2017_2018.1 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "ALGEBRA_I_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.1"),
		sgp.grade.sequences=list(c("7", "EOCT")), # ~ 8th grade Alg 1  -  for SGP_NOTE only (so no need for 2nd prior)
		sgp.norm.group.preference=2,  #  SGP_NOTE
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),

	###   EOCT Priors
	ALGEBRA_I_SS.2017_2018.1 = list(
		sgp.content.areas=c("GEOMETRY_SS", "ALGEBRA_I_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=3,  #  SGP_NOTE
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_I_SS.2017_2018.1 = list(
		sgp.content.areas=c("INTEGRATED_MATH_1_SS", "ALGEBRA_I_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=4,  #  SGP_NOTE
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),

	ALGEBRA_I_SS.2017_2018.1 = list( #  Fall to Fall period analyses  (Exclude those with ANY Spring math courses)
		sgp.content.areas=c("GEOMETRY_SS", "ALGEBRA_I_SS"),
		sgp.panel.years=c("2016_2017.1", "2017_2018.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2016_2017.2", GRADE="EOCT"),
		sgp.norm.group.preference=5,  #  SGP_NOTE
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"))
)


GEOMETRY_SS.2017_2018.1.config <- list(
	###   EOCT (Primary) Priors
	GEOMETRY_SS.2017_2018.1 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "ALGEBRA_I_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.2", "2017_2018.1"),
		sgp.grade.sequences=list(c("8", "EOCT", "EOCT")),
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2016_2017.1", GRADE="EOCT"), # Exlcude Fall 2016 Math Subjects
		sgp.norm.group.preference=1,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	GEOMETRY_SS.2017_2018.1 = list(
		sgp.content.areas=c("ALGEBRA_II_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=2,  #  SGP_NOTE
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	GEOMETRY_SS.2017_2018.1 = list(
		sgp.content.areas=c("INTEGRATED_MATH_1_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=3,  #  SGP_NOTE
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	GEOMETRY_SS.2017_2018.1 = list(
		sgp.content.areas=c("INTEGRATED_MATH_2_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=4,  #  SGP_NOTE
			sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	GEOMETRY_SS.2017_2018.1 = list(
		sgp.content.areas=c("INTEGRATED_MATH_3_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=5,  #  SGP_NOTE
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),

	###   Grade Level Priors
	GEOMETRY_SS.2017_2018.1 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.1"),
		sgp.grade.sequences=list(c("8", "EOCT")),
		sgp.norm.group.preference=6,  #  SGP_NOTE
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),

	###   Fall to Fall period analyses
	GEOMETRY_SS.2017_2018.1 = list(
		sgp.content.areas=c("ALGEBRA_I_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2016_2017.1", "2017_2018.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2016_2017.2", GRADE="EOCT"),
		sgp.norm.group.preference=7,  #  SGP_NOTE
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	GEOMETRY_SS.2017_2018.1 = list( #  Fall to Fall period analyses
		sgp.content.areas=c("ALGEBRA_II_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2016_2017.1", "2017_2018.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2016_2017.2", GRADE="EOCT"),
		sgp.norm.group.preference=8,  #  SGP_NOTE
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"))
)


ALGEBRA_II_SS.2017_2018.1.config <- list(
	###   EOCT (Primary) Priors
	ALGEBRA_II_SS.2017_2018.1 = list(
		sgp.content.areas=c("GEOMETRY_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=0,  #  SGP_NOTE
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_II_SS.2017_2018.1 = list(
		sgp.content.areas=c("ALGEBRA_I_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=1,  #  SGP_NOTE
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_II_SS.2017_2018.1 = list(
		sgp.content.areas=c("INTEGRATED_MATH_2_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=2,  #  SGP_NOTE
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_II_SS.2017_2018.1 = list(
		sgp.content.areas=c("INTEGRATED_MATH_2_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=3,  #  SGP_NOTE
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_II_SS.2017_2018.1 = list(
		sgp.content.areas=c("INTEGRATED_MATH_3_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=4,  #  SGP_NOTE
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),

	###   Grade Level Priors
	ALGEBRA_II_SS.2017_2018.1 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.1"),
		sgp.grade.sequences=list(c("8", "EOCT")),
		sgp.norm.group.preference=5,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),

	###   Fall to Fall period analyses
	ALGEBRA_II_SS.2017_2018.1 = list(
		sgp.content.areas=c("GEOMETRY_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2016_2017.1", "2017_2018.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2016_2017.2", GRADE="EOCT"),
		sgp.norm.group.preference=6,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_II_SS.2017_2018.1 = list(
		sgp.content.areas=c("ALGEBRA_I_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2016_2017.1", "2017_2018.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2016_2017.2", GRADE="EOCT"),
		sgp.norm.group.preference=7,  #  SGP_NOTE
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"))
)
