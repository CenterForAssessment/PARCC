###############################################################################
###                                                                         ###
###    Configs for Spring 2023 Grade Level ELA Cohort and Baseline SGPs     ###
###                                                                         ###
###############################################################################

ELA_2022_2023.2.config <- list(
    ELA.2022_2023.2 = list(
        sgp.content.areas = rep("ELA", 2),
        sgp.panel.years = c("2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(
            c("3", "4"), c("4", "5"),
            c("5", "6"), c("6", "7"), c("7", "8"),
            c("8", "9"), c("9", "10")),
        sgp.norm.group.preference = 0L
    )
)

##  9th & 10th Grade ELA was introduced in 2019, so only up to
##  grade 9 baselines (no prior for 10)
ELA_Baseline_2022_2023.2.config <- list(
    ELA_Baseline.2022_2023.2 = list(
        sgp.content.areas = rep("ELA", 2),
        sgp.panel.years = c("2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(
            c("3", "4"), c("4", "5"),
            c("5", "6"), c("6", "7"), c("7", "8"),
            c("8", "9")
        ),
        sgp.norm.group.preference = 0L
    )
)
