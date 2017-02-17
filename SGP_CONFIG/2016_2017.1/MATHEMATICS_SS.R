#####################################################################################
###                                                                               ###
###      SGP Configurations for Fall 2016 EOCT Math subjects  -  SCALE SCORES     ###
###                                                                               ###
#####################################################################################

PARCC.Math.Subjects <- c("GEOMETRY_SS", "ALGEBRA_I_SS", "ALGEBRA_II_SS", "INTEGRATED_MATH_1_SS", "INTEGRATED_MATH_2_SS", "INTEGRATED_MATH_3_SS")

ALGEBRA_I_SS.2016_2017.1.config <- list(
	ALGEBRA_I_SS.2016_2017.1 = list( #  Fall to Fall period analyses
		sgp.content.areas=c("MATHEMATICS_SS", "ALGEBRA_I_SS"),
		sgp.panel.years=c("2015_2016.1", "2016_2017.1"),
		sgp.grade.sequences=list(c("8", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2015_2016.2", GRADE="EOCT"),
		sgp.norm.group.preference=0,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_I_SS.2016_2017.1 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "MATHEMATICS_SS", "ALGEBRA_I_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.1"),
		sgp.grade.sequences=list(c("7", "8", "EOCT")), # ~ 9th grade
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2015_2016.1", GRADE="EOCT"), # Exclusions may not be necessary, but include to be safe.
		sgp.norm.group.preference=1,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_I_SS.2016_2017.1 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "ALGEBRA_I_SS"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.1"),
		sgp.grade.sequences=list(c("7", "EOCT")), # ~ 8th grade
		sgp.norm.group.preference=2,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_I_SS.2016_2017.1 = list(
		sgp.content.areas=c("GEOMETRY_SS", "ALGEBRA_I_SS"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=3,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_I_SS.2016_2017.1 = list(
		sgp.content.areas=c("INTEGRATED_MATH_2_SS", "ALGEBRA_I_SS"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=4,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"))
)

GEOMETRY_SS.2016_2017.1.config <- list(
	GEOMETRY_SS.2016_2017.1 = list( #  Fall to Fall period analyses
		sgp.content.areas=c("ALGEBRA_I_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2015_2016.1", "2016_2017.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2015_2016.2", GRADE="EOCT"),
		sgp.norm.group.preference=0,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	GEOMETRY_SS.2016_2017.1 = list( #  Fall to Fall period analyses
		sgp.content.areas=c("ALGEBRA_II_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2015_2016.1", "2016_2017.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2015_2016.2", GRADE="EOCT"),
		sgp.norm.group.preference=1,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	GEOMETRY_SS.2016_2017.1 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "ALGEBRA_I_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.1"),
		sgp.grade.sequences=list(c("8", "EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2015_2016.1", GRADE="EOCT"), # Exlcude Fall 2015 Algebra I specifically, and all others to be safe.
		sgp.norm.group.preference=2,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	GEOMETRY_SS.2016_2017.1 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.1"),
		sgp.grade.sequences=list(c("8", "EOCT")),
		sgp.norm.group.preference=3,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	GEOMETRY_SS.2016_2017.1 = list(
		sgp.content.areas=c("ALGEBRA_II_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=4,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	GEOMETRY_SS.2016_2017.1 = list(
		sgp.content.areas=c("INTEGRATED_MATH_1_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=5,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	GEOMETRY_SS.2016_2017.1 = list(
		sgp.content.areas=c("INTEGRATED_MATH_2_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=6,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	GEOMETRY_SS.2016_2017.1 = list(
		sgp.content.areas=c("INTEGRATED_MATH_3_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=7,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"))
)

ALGEBRA_II_SS.2016_2017.1.config <- list(
	ALGEBRA_II_SS.2016_2017.1 = list( #  Fall to Fall period analyses
		sgp.content.areas=c("GEOMETRY_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2015_2016.1", "2016_2017.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2015_2016.2", GRADE="EOCT"),
		sgp.norm.group.preference=0,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_II_SS.2016_2017.1 = list(
		sgp.content.areas=c("ALGEBRA_I_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2015_2016.1", "2016_2017.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2015_2016.2", GRADE="EOCT"),
		sgp.norm.group.preference=1,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_II_SS.2016_2017.1 = list(
		sgp.content.areas=c("ALGEBRA_I_SS", "GEOMETRY_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2015_2016.1", GRADE="EOCT"), # Exlcude Fall 2015 Alg I, II and Geom specifically, and all others to be safe.
		sgp.norm.group.preference=2,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_II_SS.2016_2017.1 = list(
		sgp.content.areas=c("ALGEBRA_I_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=3,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_II_SS.2016_2017.1 = list(
		sgp.content.areas=c("INTEGRATED_MATH_2_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=4,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_II_SS.2016_2017.1 = list(
		sgp.content.areas=c("INTEGRATED_MATH_3_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=5,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_II_SS.2016_2017.1 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.1"),
		sgp.grade.sequences=list(c("8", "EOCT")),
		sgp.norm.group.preference=6,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"))
)
