###############################################################################
###                                                                         ###
###    Configs for Spring 2022 Grade Level Math Cohort and Baseline SGPs    ###
###                                                                         ###
###############################################################################

MATHEMATICS_2022_BIE.config <- list(
    MATHEMATICS.2021_2022.2 = list(
        sgp.content.areas = rep("MATHEMATICS", 2),
        sgp.panel.years = c("2020_2021.2", "2021_2022.2"),
        sgp.grade.sequences = list(
            c("3", "4"), c("4", "5"),
            c("5", "6"), c("6", "7"), c("7", "8")),
        sgp.norm.group.preference = 0L
    )
)

MATHEMATICS_2022_DoDEA.config <- list(
    MATHEMATICS.2021_2022.2 = list(
        sgp.content.areas = rep("MATHEMATICS", 2),
        sgp.panel.years = c("2020_2021.2", "2021_2022.2"),
        sgp.grade.sequences = list(
            c("3", "4"), c("4", "5"), c("5", "6")),
        sgp.norm.group.preference = 0L
    )
)

GEOMETRY_2022_DoDEA.config <- list(
    ### CANONICAL - Put first over Fall to Spring for projections/targets (Match Thetas analyses)
    GEOMETRY.2021_2022.2 = list(
        sgp.content.areas = c("ALGEBRA_I", "GEOMETRY"),
        sgp.panel.years = c("2020_2021.2", "2021_2022.2"),
        sgp.grade.sequences = list(c("EOCT", "EOCT")),
        sgp.norm.group.preference = 0L
    )
)

ALGEBRA_II_2022_DoDEA.config <- list(
    ### CANONICAL - Put first over Fall to Spring for projections/targets
    ALGEBRA_II.2021_2022.2 = list(
        sgp.content.areas = c("GEOMETRY", "ALGEBRA_II"),
        sgp.panel.years = c("2020_2021.2", "2021_2022.2"),
        sgp.grade.sequences = list(c("EOCT", "EOCT")),
        sgp.norm.group.preference = 0L
    )
)
