###############################################################################
###                                                                         ###
###    Configs for Spring 2022 Grade Level ELA Cohort and Baseline SGPs     ###
###                                                                         ###
###############################################################################

ELA_2022_BIE.config <- list(
    ELA.2021_2022.2 = list(
        sgp.content.areas = rep("ELA", 2),
        sgp.panel.years = c("2020_2021.2", "2021_2022.2"),
        sgp.grade.sequences = list(
            c("3", "4"), c("4", "5"),
            c("5", "6"), c("6", "7"), c("7", "8")
        ),
        sgp.norm.group.preference = 0L
    )
)

ELA_2022_DoDEA.config <- list(
    ELA.2021_2022.2 = list(
        sgp.content.areas = rep("ELA", 2),
        sgp.panel.years = c("2020_2021.2", "2021_2022.2"),
        sgp.grade.sequences = list(
            c("6", "7"), c("7", "8")
        ),
        sgp.norm.group.preference = 0L
    )
)

ELA_2022_NJ.config <- list(
    ELA.2021_2022.2 = list(
        sgp.content.areas = rep("ELA", 2),
        sgp.panel.years = c("2018_2019.2", "2021_2022.2"),
        sgp.grade.sequences = list(
            c("3", "6"), c("4", "7"), c("5", "8"), c("6", "9")
        ),
        sgp.norm.group.preference = 0L
    )
)