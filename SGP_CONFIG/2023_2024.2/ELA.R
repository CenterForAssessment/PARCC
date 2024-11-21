###############################################################################
###                                                                         ###
###    Configs for Spring 2024 Grade Level ELA Cohort and Baseline SGPs     ###
###                                                                         ###
###############################################################################

ELA.2024.config <- list(
    ELA.2024 = list(
        sgp.content.areas = rep("ELA", 3),
        sgp.panel.years = c("2021_2022.2", "2022_2023.2", "2023_2024.2"),
        sgp.grade.sequences = list(
            c("3", "4"), c("3", "4", "5"),
            c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8"),
            c("7", "8", "9"), c("8", "9", "10") #, c("10", "11")
        ),
        sgp.norm.group.preference = 0L
    )
)

    # Skip Year (DoDEA consortium baselines)
ELA_SKIP.2024.config <- list(
    ELA_SKIP.2024 = list(
        sgp.content.areas = rep("ELA", 2),
        sgp.panel.years = c("2021_2022.2", "2023_2024.2"),
        sgp.grade.sequences = list(c("8", "10")),
        sgp.projection.grade.sequences = list("NO_PROJECTIONS"),
        sgp.norm.group.preference = 1L
    )
)
