################################################################################
###                                                                          ###
###    SGP Configurations code for Fall 2018 Grade Level ELA - SCALE SCORE   ###
###                                                                          ###
################################################################################

ELA_SS_2018_2019.1.config <- list(
	ELA_SS.2018_2019.1 = list(
		sgp.content.areas=rep("ELA_SS", 3),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2", "2018_2019.1"),
		sgp.grade.sequences=list(c("7", "8", "9"), c("8", "9", "10"), c("9", "10", "11")),
		sgp.norm.group.preference=1,
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 3))),

	###   Fall to Fall period analyses
	ELA_SS.2018_2019.1 = list(
		sgp.content.areas=rep("ELA_SS", 2),
		sgp.panel.years=c("2017_2018.1", "2018_2019.1"),
		sgp.grade.sequences=list(c("9", "10"), c("10", "11")),
		sgp.norm.group.preference=2,
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 3)))
)
