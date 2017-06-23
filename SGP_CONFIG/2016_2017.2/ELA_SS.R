#####################################################################################
###                                                                               ###
###    SGP Configurations code for Spring 2017  Grade Level ELA - SCALE SCORES    ###
###                                                                               ###
#####################################################################################

ELA_SS.2016_2017.2.config <- list(
	ELA_SS.2016_2017.2 = list(
		sgp.content.areas=rep("ELA_SS", 3),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("3", "4"), c("3", "4", "5"), c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8"), c("7", "8", "9"), c("8", "9", "10"), c("9", "10", "11")),
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 8)),
		sgp.norm.group.preference=0L),

	ELA_SS.2016_2017.2 = list(
		sgp.content.areas=rep("ELA_SS", 2),
		sgp.panel.years=c("2016_2017.1", "2016_2017.2"),
		sgp.grade.sequences=list(c("9", "10"), c("10", "11")),
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 2)),
		sgp.norm.group.preference=1L)
)
