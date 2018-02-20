#####################################################################################
###                                                                               ###
###      SGP Configurations code for Fall 2017 Grade Level ELA (SCALE SCORE)      ###
###                                                                               ###
#####################################################################################

ELA_2017_2018.1.config <- list(
	ELA.2017_2018.1 = list(
		sgp.content.areas=rep("ELA", 3),
		sgp.panel.years=c("2015_2016.2", "2016_2017.2", "2017_2018.1"),
		sgp.grade.sequences=list(c("7", "8", "9"), c("8", "9", "10"), c("9", "10", "11")),
		sgp.norm.group.preference=1,
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 3))),

	###   Fall to Fall period analyses
	ELA.2015_2016.1 = list(
		sgp.content.areas=rep("ELA", 2),
		sgp.panel.years=c("2016_2017.1", "2017_2018.1"),
		sgp.grade.sequences=list(c("9", "10"), c("10", "11")),
		sgp.norm.group.preference=2,
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 3)))
)
