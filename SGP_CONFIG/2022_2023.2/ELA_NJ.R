###############################################################################
###                                                                         ###
###         Configs for New Jersey Spring 2023 Grade Level ELA SGPs         ###
###                                                                         ###
###############################################################################

###   Cohort and Baseline SGP configs (SINGLE PRIOR -- STRICTLY USED THESE)

ELA_Baseline.2022_2023.2.config <- list(
    ELA_Baseline.2022_2023.2 = list(
        sgp.content.areas = c("ELA", "ELA"),
        sgp.panel.years = c("2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(
            c("3", "4"), c("4", "5"), c("5", "6"),
            c("6", "7"), c("7", "8"), c("8", "9")
        ),
        sgp.norm.group.preference = 0L
    )
)

###   Cohort SGP configs (DUAL PRIOR -- NOT USED)
##    No CSEM for NJ Start Strong -->> No SIMEX, so single prior only in 2023

ELA.2022_2023.2.config <- list(
    ELA.2022_2023.2 = list(
        sgp.content.areas = c("ELA_NJSS", "ELA", "ELA"),
        sgp.panel.years = c("2021_2022.1", "2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(
            c("3", "3", "4"), c("4", "4", "5"), c("5", "5", "6"),
            c("6", "6", "7"), c("7", "7", "8"), c("8", "8", "9")
        ),
        sgp.norm.group.preference = 0L
    )
)
