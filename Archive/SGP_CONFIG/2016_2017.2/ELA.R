################################################################################
###                                                                          ###
###  SGP Configurations code for PARCC 2016_2017.2 Grade Level ELA           ###
###                                                                          ###
################################################################################

###  Fall to Spring.  No viable progression establish configs for the SGP_NOTE variable
ELA.2016_2017.2.config <- list(
	ELA.2016_2017.2 = list(
		sgp.content.areas=rep("ELA", 3),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("3", "4"), c("3", "4", "5"), c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8"), c("7", "8", "9"), c("8", "9", "10"), c("9", "10", "11")),
		sgp.norm.group.preference=0L), #  CANONICAL

	ELA.2017_2018.2 = list(  #  Skip year progression for Washington DC/ Maryland in 2019 Alt Consortium Analyses!!!
		sgp.content.areas=rep("ELA", 2),
		sgp.panel.years=c("2014_2015.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("8", "10")),
		sgp.exact.grade.progression=TRUE,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=1L),

	ELA.2016_2017.2 = list(
		sgp.content.areas=rep("ELA", 2),
		sgp.panel.years=c("2016_2017.1", "2016_2017.2"),
		sgp.grade.sequences=list(c("9", "10"), c("10", "11")),
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 2)),
		sgp.norm.group.preference=1L)
)
