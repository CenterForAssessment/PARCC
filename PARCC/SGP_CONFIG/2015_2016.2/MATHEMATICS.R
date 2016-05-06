#####################################################################################
###                                                                               ###
###   SGP Configurations for 2015_2016 Grade Level Math and EOCT Math subjects    ###
###                                                                               ###
#####################################################################################

MATHEMATICS_2015_2016.config <- list(
	MATHEMATICS.2015_2016 = list(
		sgp.content.areas=rep("MATHEMATICS", 2),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(as.character(3:4), as.character(4:5), as.character(5:6), as.character(6:7), as.character(7:8))),

	ALGEBRA_I.2015_2016 = list(
		sgp.content.areas=c("MATHEMATICS", "ALGEBRA_I"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("6", "EOCT"), c("7", "EOCT"), c("8", "EOCT"))), # 7th, 8th & 9th grades

	GEOMETRY.2015_2016 = list(
		sgp.content.areas=c("MATHEMATICS", "GEOMETRY"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("7", "EOCT"), c("8", "EOCT"))), # 8th & 9th grades

	GEOMETRY.2015_2016 = list(
		sgp.content.areas=c("ALGEBRA_I", "GEOMETRY"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT"))),

	ALGEBRA_II.2015_2016 = list(
		sgp.content.areas=c("MATHEMATICS", "ALGEBRA_II"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("7", "EOCT"), c("8", "EOCT"))), # 8th & 9th grades

	ALGEBRA_II.2015_2016 = list(
		sgp.content.areas=c("ALGEBRA_I", "ALGEBRA_II"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT"))),

	ALGEBRA_II.2015_2016 = list(
		sgp.content.areas=c("GEOMETRY", "ALGEBRA_II"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT"))),

	INTEGRATED_MATH_1.2015_2016 = list(
		sgp.content.areas=c("MATHEMATICS", "INTEGRATED_MATH_1"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("6", "EOCT"), c("7", "EOCT"), c("8", "EOCT"))), # 7th, 8th & 9th grades

	INTEGRATED_MATH_2.2015_2016 = list(
		sgp.content.areas=c("MATHEMATICS", "INTEGRATED_MATH_2"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("7", "EOCT"), c("8", "EOCT"))), # 8th & 9th grades

	INTEGRATED_MATH_3.2015_2016 = list(
		sgp.content.areas=c("MATHEMATICS", "INTEGRATED_MATH_2"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("7", "EOCT"), c("8", "EOCT"))), # 8th & 9th grades

	INTEGRATED_MATH_2.2015_2016 = list(
		sgp.content.areas=c("INTEGRATED_MATH_1", "INTEGRATED_MATH_2"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT"))),

	INTEGRATED_MATH_3.2015_2016 = list(
		sgp.content.areas=c("INTEGRATED_MATH_1", "INTEGRATED_MATH_3"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT"))),

	INTEGRATED_MATH_3.2015_2016 = list(
		sgp.content.areas=c("INTEGRATED_MATH_2", "INTEGRATED_MATH_3"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT"))),
)
