#####################################################################################
###                                                                               ###
###               Configs for Fall 2021 ELA SGPs - NJ Start Strong                ###
###                                                                               ###
#####################################################################################

ELA_2021_2022.1.config <- list(
	ELA.2021_2022.1 = list(
		sgp.content.areas=c("ELA", "ELA_NJSS"),
		sgp.panel.years=c("2018_2019.2", "2021_2022.1"),
		sgp.grade.sequences=list(c("3", "6"), c("4", "7"), c("5", "8"),  #  Note the 3 year offset!
		                         c("6", "9"), c("7", "10")),
		sgp.norm.group.preference=0L)
)


###   Reverse to simulate Spring 2022

# ELA_2021_2022.1.config <- list(
# 	ELA.2021_2022.1 = list(
# 		sgp.content.areas=c("ELA_NJSS", "ELA"),
# 		sgp.panel.years=c("2021_2022.1", "2018_2019.2"),
# 		sgp.grade.sequences=list(c("6", "3"), c("7", "4"), c("8", "5"),
# 		                         c("9", "6"), c("10", "7")),
# 		sgp.norm.group.preference=0L)
# )
