#####################################################################################
###                                                                               ###
###              SGP Configurations for Fall 2016 EOCT Math subjects              ###
###                                                                               ###
#####################################################################################

PARCC.Math.Subjects <- c("GEOMETRY", "ALGEBRA_I", "ALGEBRA_II", "INTEGRATED_MATH_1", "INTEGRATED_MATH_2", "INTEGRATED_MATH_3")

ALGEBRA_I.2016_2017.1.config <- list(
	ALGEBRA_I.2016_2017.1 = list( #  Fall to Fall period analyses
		sgp.content.areas=c("MATHEMATICS", "ALGEBRA_I"),
		sgp.panel.years=c("2015_2016.1", "2016_2017.1"),
		sgp.grade.sequences=list(c("8", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2015_2016.2", GRADE="EOCT"),
		sgp.norm.group.preference=0,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_I.2016_2017.1 = list(
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "ALGEBRA_I"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.1"),
		sgp.grade.sequences=list(c("7", "8", "EOCT")), # ~ 9th grade
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2015_2016.1", GRADE="EOCT"), # Exclusions may not be necessary, but include to be safe.
		sgp.norm.group.preference=1,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_I.2016_2017.1 = list(
		sgp.content.areas=c("MATHEMATICS", "ALGEBRA_I"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.1"),
		sgp.grade.sequences=list(c("7", "EOCT")), # ~ 8th grade
		sgp.norm.group.preference=2,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_I.2016_2017.1 = list(
		sgp.content.areas=c("GEOMETRY", "ALGEBRA_I"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=3,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_I.2016_2017.1 = list(
		sgp.content.areas=c("INTEGRATED_MATH_2", "ALGEBRA_I"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=4,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"))
)

GEOMETRY.2016_2017.1.config <- list(
	GEOMETRY.2016_2017.1 = list( #  Fall to Fall period analyses
		sgp.content.areas=c("ALGEBRA_I", "GEOMETRY"),
		sgp.panel.years=c("2015_2016.1", "2016_2017.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2015_2016.2", GRADE="EOCT"),
		sgp.norm.group.preference=0,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	GEOMETRY.2016_2017.1 = list( #  Fall to Fall period analyses
		sgp.content.areas=c("ALGEBRA_II", "GEOMETRY"),
		sgp.panel.years=c("2015_2016.1", "2016_2017.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2015_2016.2", GRADE="EOCT"),
		sgp.norm.group.preference=1,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	GEOMETRY.2016_2017.1 = list(
		sgp.content.areas=c("MATHEMATICS", "ALGEBRA_I", "GEOMETRY"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.1"),
		sgp.grade.sequences=list(c("8", "EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2015_2016.1", GRADE="EOCT"), # Exlcude Fall 2015 Algebra I specifically, and all others to be safe.
		sgp.norm.group.preference=2,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	GEOMETRY.2016_2017.1 = list(
		sgp.content.areas=c("MATHEMATICS", "GEOMETRY"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.1"),
		sgp.grade.sequences=list(c("8", "EOCT")),
		sgp.norm.group.preference=3,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	GEOMETRY.2016_2017.1 = list(
		sgp.content.areas=c("ALGEBRA_II", "GEOMETRY"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=4,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	GEOMETRY.2016_2017.1 = list(
		sgp.content.areas=c("INTEGRATED_MATH_1", "GEOMETRY"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=5,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	GEOMETRY.2016_2017.1 = list(
		sgp.content.areas=c("INTEGRATED_MATH_2", "GEOMETRY"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=6,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	GEOMETRY.2016_2017.1 = list(
		sgp.content.areas=c("INTEGRATED_MATH_3", "GEOMETRY"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=7,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"))
)

ALGEBRA_II.2016_2017.1.config <- list(
	ALGEBRA_II.2016_2017.1 = list( #  Fall to Fall period analyses
		sgp.content.areas=c("GEOMETRY", "ALGEBRA_II"),
		sgp.panel.years=c("2015_2016.1", "2016_2017.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2015_2016.2", GRADE="EOCT"),
		sgp.norm.group.preference=0,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_II.2016_2017.1 = list(
		sgp.content.areas=c("ALGEBRA_I", "ALGEBRA_II"),
		sgp.panel.years=c("2015_2016.1", "2016_2017.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2015_2016.2", GRADE="EOCT"),
		sgp.norm.group.preference=1,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_II.2016_2017.1 = list(
		sgp.content.areas=c("ALGEBRA_I", "GEOMETRY", "ALGEBRA_II"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
			YEAR="2015_2016.1", GRADE="EOCT"), # Exlcude Fall 2015 Alg I, II and Geom specifically, and all others to be safe.
		sgp.norm.group.preference=2,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_II.2016_2017.1 = list(
		sgp.content.areas=c("ALGEBRA_I", "ALGEBRA_II"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=3,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_II.2016_2017.1 = list(
		sgp.content.areas=c("INTEGRATED_MATH_2", "ALGEBRA_II"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=4,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_II.2016_2017.1 = list(
		sgp.content.areas=c("INTEGRATED_MATH_3", "ALGEBRA_II"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=5,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_II.2016_2017.1 = list(
		sgp.content.areas=c("MATHEMATICS", "ALGEBRA_II"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.1"),
		sgp.grade.sequences=list(c("8", "EOCT")),
		sgp.norm.group.preference=6,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"))
)
