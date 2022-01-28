#####################################################################################
###                                                                               ###
###               Configs for Fall 2021 Math SGPs - NJ Start Strong               ###
###                                                                               ###
#####################################################################################

MATHEMATICS_2021_2022.1.config <- list(
	MATHEMATICS.2021_2022.1 = list(
		sgp.content.areas=c("MATHEMATICS", "MATH_NJSS"),
		sgp.panel.years=c("2018_2019.2", "2021_2022.1"),
		sgp.grade.sequences=list(c("3", "6"), c("4", "7"), c("5", "8")),  #  Note the 3 year offset!
		sgp.norm.group.preference=0L)
)

###   Reverse to simulate Spring 2022
# MATHEMATICS_2021_2022.1.config <- list(
# 	MATHEMATICS.2021_2022.1 = list(
# 		sgp.content.areas=c("MATH_NJSS", "MATHEMATICS"),
# 		sgp.panel.years=c("2021_2022.1", "2018_2019.2"),
# 		sgp.grade.sequences=list(c("6", "3"), c("7", "4"), c("8", "5")),
# 		sgp.norm.group.preference=0L)
# )


ALGEBRA_I_2021_2022.1.config <- list(
	ALGEBRA_I.2021_2022.1 = list(
		sgp.content.areas=c("MATHEMATICS", "ALG_I_NJSS"),
		sgp.panel.years=c("2018_2019.2", "2021_2022.1"),
		sgp.grade.sequences=list(c("5", "EOCT"), c("6", "EOCT"), c("7", "EOCT"), c("8", "EOCT")),
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 4)),
		sgp.norm.group.preference=0L)
)


GEOMETRY_2021_2022.1.config <- list(
	GEOMETRY.2021_2022.1 = list(
		sgp.content.areas=c("MATHEMATICS", "GEOM_NJSS"),
		sgp.panel.years=c("2018_2019.2", "2021_2022.1"),
		sgp.grade.sequences=list(c("5", "EOCT"), c("6", "EOCT"), c("7", "EOCT"), c("8", "EOCT")),
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 4)),
		sgp.norm.group.preference=0L)
)


ALGEBRA_II_2021_2022.1.config <- list(
	ALGEBRA_II.2021_2022.1 = list(
		sgp.content.areas=c("ALGEBRA_I", "ALG_II_NJSS"),
		sgp.panel.years=c("2018_2019.2", "2021_2022.1"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=0L),

	ALGEBRA_II.2021_2022.1 = list(
		sgp.content.areas=c("MATHEMATICS", "ALG_II_NJSS"),
		sgp.panel.years=c("2018_2019.2", "2021_2022.1"),
		sgp.grade.sequences=list(c("6", "EOCT"), c("7", "EOCT"), c("8", "EOCT")),
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 3)),
		sgp.norm.group.preference=5L)
)
