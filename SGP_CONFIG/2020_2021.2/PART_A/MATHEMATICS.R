#####################################################################################
###                                                                               ###
###     Configs for Spring 2021 Grade Level Math BASELINE SGPs - Theta SCORES     ###
###                                                                               ###
#####################################################################################

MATHEMATICS_2020_2021.2.config <- list(
	MATHEMATICS.2020_2021.2 = list(
		sgp.content.areas=rep("MATHEMATICS", 3),
		sgp.panel.years=c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
		sgp.grade.sequences=list(c("3", "5"), c("3", "4", "6"), c("4", "5", "7"), c("5", "6", "8")),
		sgp.norm.group.preference=0L)
)


ALGEBRA_I_2020_2021.2.config <- list(
	### CANONICAL - Put first over Fall to Spring for projections/targets (Match Thetas analyses)
	ALGEBRA_I.2020_2021.2 = list(
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "ALGEBRA_I"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
		sgp.grade.sequences=list(c("6", "7", "EOCT")),
		# sgp.projection.grade.sequences=list("NO_PROJECTIONS"), # 9th grade - CANONICAL
		sgp.norm.group.preference=0L),
	ALGEBRA_I.2020_2021.2 = list(
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "ALGEBRA_I"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
		sgp.grade.sequences=list(c("4", "5", "EOCT"), c("5", "6", "EOCT"), c("7", "8", "EOCT")), # 7th, 8th & 10th graders
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 3)),
		sgp.norm.group.preference=1L)
)


GEOMETRY_2020_2021.2.config <- list(
	### CANONICAL - Put first over Fall to Spring for projections/targets (Match Thetas analyses)
	GEOMETRY.2020_2021.2 = list(
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "GEOMETRY"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
		sgp.grade.sequences=list(c("7", "8", "EOCT")),
		# sgp.projection.grade.sequences=list("NO_PROJECTIONS"), # 10th grade - CANONICAL
		sgp.norm.group.preference=0L),

	GEOMETRY.2020_2021.2 = list(
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "GEOMETRY"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
		sgp.grade.sequences=list(c("6", "7", "EOCT"), c("5", "6", "EOCT")),
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 2)),
		sgp.norm.group.preference=1L),

	GEOMETRY.2020_2021.2 = list(
		sgp.content.areas=c("ALGEBRA_I", "GEOMETRY"),
		sgp.panel.years=c("2018_2019.2", "2020_2021.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=3L)
)


ALGEBRA_II_2020_2021.2.config <- list(
	### CANONICAL
	ALGEBRA_II.2020_2021.2 = list(
		sgp.content.areas=c("ALGEBRA_I", "ALGEBRA_II"),
		sgp.panel.years=c("2018_2019.2", "2020_2021.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		# sgp.projection.grade.sequences=list("NO_PROJECTIONS"), # CANONICAL
		sgp.norm.group.preference=0L),

	ALGEBRA_II.2020_2021.2 = list(
		sgp.content.areas=c("MATHEMATICS", "ALGEBRA_I", "ALGEBRA_II"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
		sgp.grade.sequences=list(c("7", "EOCT", "EOCT"), c("8", "EOCT", "EOCT")),
		sgp.exact.grade.progression=as.list(rep(TRUE, 2)), #  Need exact to avoid multiple "ALGEBRA_I", "ALGEBRA_II" matrices
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 2)),
		sgp.norm.group.preference=3L),

	ALGEBRA_II.2020_2021.2 = list(
		sgp.content.areas=c("MATHEMATICS", "ALGEBRA_II"),
		sgp.panel.years=c("2018_2019.2", "2020_2021.2"),
		sgp.grade.sequences=list(c("7", "EOCT"), c("8", "EOCT")),
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 2)),
		sgp.norm.group.preference=5L) # 8th & 9th grades
)
