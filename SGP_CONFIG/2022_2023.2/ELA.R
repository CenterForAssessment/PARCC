###############################################################################
###                                                                         ###
###    Configs for Spring 2023 Grade Level ELA Cohort and Baseline SGPs     ###
###                                                                         ###
###############################################################################

ELA.2023.config <- list(
    ELA.2023 = list(
        sgp.content.areas = rep("ELA", 3),
        sgp.panel.years = c("2020_2021.2", "2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(
            c("3", "4"), c("3", "4", "5"),
            c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8"),
            c("8", "9"), c("9", "10") #, c("10", "11")
        ),
        sgp.norm.group.preference = 0L
    ),
    # Skip Year (mainly for DoDEA consortium baselines)
    ELA_SKIP.2023 = list(
        sgp.content.areas = rep("ELA", 2),
        sgp.panel.years = c("2020_2021.2", "2022_2023.2"),
        sgp.grade.sequences = list(c("8", "10")),
        sgp.projection.grade.sequences = list("NO_PROJECTIONS"),
        sgp.norm.group.preference = 1L
    )
)
