#####################################################################################
###                                                                               ###
###     SGP Configurations for Spring 2017 Grade Level and EOCT Math subjects     ###
###                                                                               ###
#####################################################################################

PARCC.Math.Subjects <- c("GEOMETRY", "ALGEBRA_I", "ALGEBRA_II", "INTEGRATED_MATH_1", "INTEGRATED_MATH_2", "INTEGRATED_MATH_3")


MATHEMATICS.2016_2017.2.config <- list(
	MATHEMATICS.2016_2017.2 = list(
		sgp.content.areas=rep("MATHEMATICS", 3),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("3", "4"), c("3", "4", "5"), c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8"))
	)
)


ALGEBRA_I.2016_2017.2.config <- list(
	ALGEBRA_I.2016_2017.2 = list( # Fall - Spring
		sgp.content.areas=c("GEOMETRY", "ALGEBRA_I"),
		sgp.panel.years=c("2016_2017.1", "2016_2017.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=000L),	#XX#	CHECK
	ALGEBRA_I.2016_2017.2 = list(
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "ALGEBRA_I"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("7", "8", "EOCT")), # 9th grade - CANONICAL
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=rep(PARCC.Math.Subjects, each=2),
		  YEAR=c("2015_2016.1", "2016_2017.1"), GRADE="EOCT"),
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2016_2017.1", GRADE="EOCT"),
		sgp.norm.group.preference=0),
	ALGEBRA_I.2016_2017.2 = list(
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "ALGEBRA_I"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("5", "6", "EOCT"), c("6", "7", "EOCT")), # 7th & 8th grades
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2016_2017.1", GRADE="EOCT"),
		sgp.norm.group.preference=1),

	ALGEBRA_I.2016_2017.2 = list(
		sgp.content.areas=c("ALGEBRA_I", "GEOMETRY", "ALGEBRA_I"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2016_2017.1", GRADE="EOCT"),
		sgp.norm.group.preference=2),

	ALGEBRA_I.2016_2017.2 = list(
		sgp.content.areas=c("MATHEMATICS", "INTEGRATED_MATH_1", "ALGEBRA_I"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("8", "EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2016_2017.1", GRADE="EOCT"),
		sgp.norm.group.preference=3),

	ALGEBRA_I.2016_2017.2 = list(
		sgp.content.areas=c("INTEGRATED_MATH_2", "ALGEBRA_I"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2016_2017.1", GRADE="EOCT"),
		sgp.norm.group.preference=4),

	ALGEBRA_I.2016_2017.2 = list(
		sgp.content.areas=c("INTEGRATED_MATH_3", "ALGEBRA_I"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2016_2017.1", GRADE="EOCT"),
		sgp.norm.group.preference=5)
)


GEOMETRY.2016_2017.2.config <- list(
	GEOMETRY.2016_2017.2 = list( # Fall - Spring
		sgp.content.areas=c("ALGEBRA_I", "GEOMETRY"),
		sgp.panel.years=c("2016_2017.1", "2016_2017.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2016_2017.1", GRADE="EOCT"),
		sgp.norm.group.preference=0),

	GEOMETRY.2016_2017.2 = list(
		sgp.content.areas=c("MATHEMATICS", "ALGEBRA_I", "GEOMETRY"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("8", "EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2016_2017.1", GRADE="EOCT"),
		sgp.norm.group.preference=1),

	GEOMETRY.2016_2017.2 = list(
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "GEOMETRY"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("5", "6", "EOCT"), c("6", "7", "EOCT"), c("7", "8", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2016_2017.1", GRADE="EOCT"),
		sgp.norm.group.preference=2), # 8th & 9th grades

	GEOMETRY.2016_2017.2 = list(
		sgp.content.areas=c("ALGEBRA_II", "GEOMETRY"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2016_2017.1", GRADE="EOCT"),
		sgp.norm.group.preference=3),

	GEOMETRY.2016_2017.2 = list(
		sgp.content.areas=c("INTEGRATED_MATH_1", "GEOMETRY"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2016_2017.1", GRADE="EOCT"),
		sgp.norm.group.preference=4),

	GEOMETRY.2016_2017.2 = list(
		sgp.content.areas=c("INTEGRATED_MATH_2", "GEOMETRY"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2016_2017.1", GRADE="EOCT"),
		sgp.norm.group.preference=5),

	GEOMETRY.2016_2017.2 = list(
		sgp.content.areas=c("INTEGRATED_MATH_3", "GEOMETRY"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2016_2017.1", GRADE="EOCT"),
		sgp.norm.group.preference=6)
)

ALGEBRA_II.2016_2017.2.config <- list(
	ALGEBRA_II.2016_2017.2 = list( # Fall - Spring
		sgp.content.areas=c("GEOMETRY", "ALGEBRA_II"),
		sgp.panel.years=c("2016_2017.1", "2016_2017.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2016_2017.1", GRADE="EOCT"),
		sgp.norm.group.preference=0),

	ALGEBRA_II.2016_2017.2 = list(
		sgp.content.areas=c("ALGEBRA_I", "GEOMETRY", "ALGEBRA_II"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2016_2017.1", GRADE="EOCT"),
		sgp.norm.group.preference=1),

	ALGEBRA_II.2016_2017.2 = list(
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "ALGEBRA_II"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("6", "7", "EOCT"), c("7", "8", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2016_2017.1", GRADE="EOCT"),
		sgp.norm.group.preference=2), # 8th & 9th grades

	ALGEBRA_II.2016_2017.2 = list(
		sgp.content.areas=c("MATHEMATICS", "ALGEBRA_I", "ALGEBRA_II"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("7", "EOCT", "EOCT"), c("8", "EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2016_2017.1", GRADE="EOCT"),
		sgp.norm.group.preference=3),

	ALGEBRA_II.2016_2017.2 = list(
		sgp.content.areas=c("INTEGRATED_MATH_1", "ALGEBRA_II"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2016_2017.1", GRADE="EOCT"),
		sgp.norm.group.preference=4),

	ALGEBRA_II.2016_2017.2 = list(
		sgp.content.areas=c("INTEGRATED_MATH_2", "ALGEBRA_II"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2016_2017.1", GRADE="EOCT"),
		sgp.norm.group.preference=5),

	ALGEBRA_II.2016_2017.2 = list(
		sgp.content.areas=c("INTEGRATED_MATH_3", "ALGEBRA_II"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2016_2017.1", GRADE="EOCT"),
		sgp.norm.group.preference=6)
)


INTEGRATED_MATH_1.2016_2017.2.config <- list(
	INTEGRATED_MATH_1.2016_2017.2 = list(
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "INTEGRATED_MATH_1"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("7", "8", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2016_2017.1", GRADE="EOCT"),
		sgp.norm.group.preference=0), # 9th grade - CANONICAL

	INTEGRATED_MATH_1.2016_2017.2 = list(
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "INTEGRATED_MATH_1"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("5", "6", "EOCT"), c("6", "7", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2016_2017.1", GRADE="EOCT"),
		sgp.norm.group.preference=1), # 7th & 8th grades

	INTEGRATED_MATH_1.2016_2017.2 = list(
		sgp.content.areas=c("ALGEBRA_I", "INTEGRATED_MATH_1"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2016_2017.1", GRADE="EOCT"),
		sgp.norm.group.preference=2),

	INTEGRATED_MATH_1.2016_2017.2 = list(
		sgp.content.areas=c("GEOMETRY", "INTEGRATED_MATH_1"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2016_2017.1", GRADE="EOCT"),
		sgp.norm.group.preference=3),

	INTEGRATED_MATH_1.2016_2017.2 = list(
		sgp.content.areas=c("ALGEBRA_II", "INTEGRATED_MATH_1"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2016_2017.1", GRADE="EOCT"),
		sgp.norm.group.preference=4)
)


INTEGRATED_MATH_2.2016_2017.2.config <- list(
	INTEGRATED_MATH_2.2016_2017.2 = list(
		sgp.content.areas=c("MATHEMATICS", "INTEGRATED_MATH_1", "INTEGRATED_MATH_2"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("8", "EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2016_2017.1", GRADE="EOCT"),
		sgp.norm.group.preference=0),

	INTEGRATED_MATH_2.2016_2017.2 = list(
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "INTEGRATED_MATH_2"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("6", "7", "EOCT"), c("7", "8", "EOCT")), # 8th & 9th grades,
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2016_2017.1", GRADE="EOCT"),
		sgp.norm.group.preference=1)
)


INTEGRATED_MATH_3.2016_2017.2.config <- list(
	INTEGRATED_MATH_3.2016_2017.2 = list(
		sgp.content.areas=c("INTEGRATED_MATH_1", "INTEGRATED_MATH_2", "INTEGRATED_MATH_3"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2016_2017.1", GRADE="EOCT"),
		sgp.norm.group.preference=0),

	INTEGRATED_MATH_3.2016_2017.2 = list(
		sgp.content.areas=c("INTEGRATED_MATH_1", "INTEGRATED_MATH_3"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2016_2017.1", GRADE="EOCT"),
		sgp.norm.group.preference=1),

	INTEGRATED_MATH_3.2016_2017.2 = list(
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "INTEGRATED_MATH_3"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("6", "7", "EOCT"), c("7", "8", "EOCT")), # 8th & 9th grades,
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2016_2017.1", GRADE="EOCT"),
		sgp.norm.group.preference=2)
)
