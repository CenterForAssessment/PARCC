#####################################################################################
###                                                                               ###
###     Configs for Spring 2021 Grade Level ELA BASELINE SGPs - Theta SCORES      ###
###                                                                               ###
#####################################################################################

ELA_2020_2021.2.config <- list(
	ELA.2020_2021.2 = list(
		sgp.content.areas=rep("ELA", 3),
		sgp.panel.years=c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
		sgp.grade.sequences=list(c("3", "5"), c("3", "4", "6"), c("4", "5", "7"), c("5", "6", "8"),
		                         c("6", "7", "9"), c("7", "8", "10"), c("8", "9", "11")),
		sgp.norm.group.preference=0L)
)

ELA_2021_Small_N_Baseline.config <- list(
	ELA.2020_2021.2 = list(
		sgp.content.areas=rep("ELA", 3),
		sgp.panel.years=c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
		sgp.grade.sequences=list(c("8", "9", "11")), # c("6", "7", "9"), # No data c("7", "8", "10"), # 1600 kids
		sgp.norm.group.preference=0L)
)
