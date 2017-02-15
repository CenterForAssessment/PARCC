#####################################################################################
###                                                                               ###
###              SGP Configurations for Fall 2016 EOCT Math subjects              ###
###                                                                               ###
#####################################################################################

ALGEBRA_I.2016_2017.1.config <- list(
	ALGEBRA_I.2016_2017.1 = list(
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "ALGEBRA_I"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.1"),
		sgp.grade.sequences=list(c("7", "8", "EOCT")), # ~9th grade
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_I.2016_2017.1 = list( #  Fall to Fall period analyses
		sgp.content.areas=c("MATHEMATICS", "ALGEBRA_I"),
		sgp.panel.years=c("2015_2016.1", "2016_2017.1"),
		sgp.grade.sequences=list(c("8", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=c("GEOMETRY", "ALGEBRA_I", "ALGEBRA_II"),
			YEAR=c("2015_2016.2", "2015_2016.2", "2015_2016.2"), GRADE=c("EOCT", "EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"))

)

GEOMETRY.2016_2017.1.config <- list(
	GEOMETRY.2016_2017.1 = list(
		sgp.content.areas=c("MATHEMATICS", "ALGEBRA_I", "GEOMETRY"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.1"),
		sgp.grade.sequences=list(c("8", "EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	GEOMETRY.2016_2017.1 = list( #  Fall to Fall period analyses
		sgp.content.areas=c("ALGEBRA_I", "GEOMETRY"),
		sgp.panel.years=c("2015_2016.1", "2016_2017.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=c("GEOMETRY", "ALGEBRA_I", "ALGEBRA_II"),
			YEAR=c("2015_2016.2", "2015_2016.2", "2015_2016.2"), GRADE=c("EOCT", "EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	GEOMETRY.2016_2017.1 = list( #  Fall to Fall period analyses
		sgp.content.areas=c("ALGEBRA_II", "GEOMETRY"),
		sgp.panel.years=c("2015_2016.1", "2016_2017.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=c("GEOMETRY", "ALGEBRA_I", "ALGEBRA_II"),
			YEAR=c("2015_2016.2", "2015_2016.2", "2015_2016.2"), GRADE=c("EOCT", "EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"))
)

ALGEBRA_II.2016_2017.1.config <- list(
	ALGEBRA_II.2016_2017.1 = list(
		sgp.content.areas=c("ALGEBRA_I", "GEOMETRY", "ALGEBRA_II"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_II.2016_2017.1 = list(
		sgp.content.areas=c("ALGEBRA_I", "ALGEBRA_II"),
		sgp.panel.years=c("2015_2016.1", "2016_2017.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=c("GEOMETRY", "ALGEBRA_I", "ALGEBRA_II"),
			YEAR=c("2015_2016.2", "2015_2016.2", "2015_2016.2"), GRADE=c("EOCT", "EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_II.2016_2017.1 = list(
		sgp.content.areas=c("GEOMETRY", "ALGEBRA_II"),
		sgp.panel.years=c("2015_2016.1", "2016_2017.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=c("GEOMETRY", "ALGEBRA_I", "ALGEBRA_II"),
			YEAR=c("2015_2016.2", "2015_2016.2", "2015_2016.2"), GRADE=c("EOCT", "EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"))
)
