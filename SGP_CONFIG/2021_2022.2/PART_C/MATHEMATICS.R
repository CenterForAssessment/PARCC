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
            c("5", "6"), c("6", "7"), c("7", "8")
        ),
        sgp.norm.group.preference = 0L
    )
)

MATHEMATICS_2022_DoDEA.config <- list(
    MATHEMATICS.2021_2022.2 = list(
        sgp.content.areas = rep("MATHEMATICS", 2),
        sgp.panel.years = c("2020_2021.2", "2021_2022.2"),
        sgp.grade.sequences = list(
            c("3", "4"), c("4", "5"), c("5", "6")
        ),
        sgp.norm.group.preference = 0L
    )
)

GEOMETRY_2022_DoDEA.config <- list(
    GEOMETRY.2021_2022.2 = list(
        sgp.content.areas = c("ALGEBRA_I", "GEOMETRY"),
        sgp.panel.years = c("2020_2021.2", "2021_2022.2"),
        sgp.grade.sequences = list(c("EOCT", "EOCT")),
        sgp.norm.group.preference = 0L
    )
)

ALGEBRA_II_2022_DoDEA.config <- list(
    ALGEBRA_II.2021_2022.2 = list(
        sgp.content.areas = c("GEOMETRY", "ALGEBRA_II"),
        sgp.panel.years = c("2020_2021.2", "2021_2022.2"),
        sgp.grade.sequences = list(c("EOCT", "EOCT")),
        sgp.norm.group.preference = 0L
    )
)

###   New Jersey
MATHEMATICS_2022_NJ.config <- list(
    MATHEMATICS.2021_2022.2 = list(
        sgp.content.areas = rep("MATHEMATICS", 2),
        sgp.panel.years = c("2018_2019.2", "2021_2022.2"),
        sgp.grade.sequences = list(
            c("3", "6"), c("4", "7"), c("5", "8")
        ),
        sgp.norm.group.preference = 0L
    )
)

ALGEBRA_I_2022_NJ.config <- list(
    ALGEBRA_I.2021_2022.2 = list(
        sgp.content.areas = c("MATHEMATICS", "ALGEBRA_I"),
        sgp.panel.years = c("2018_2019.2", "2021_2022.2"),
        sgp.grade.sequences = list(
            c("4", "EOCT"), c("5", "EOCT"),
            c("6", "EOCT"), c("7", "EOCT")
        ),
        sgp.norm.group.preference = 0L
    )
)

GEOMETRY_2022_NJ.config <- list(
    GEOMETRY.2021_2022.2 = list(
        sgp.content.areas = c("MATHEMATICS", "GEOMETRY"),
        sgp.panel.years = c("2018_2019.2", "2021_2022.2"),
        sgp.grade.sequences = list(
            c("5", "EOCT"),
            c("6", "EOCT"), c("7", "EOCT")
        ),
        sgp.norm.group.preference = 0L
    )
)

ALGEBRA_II_2022_NJ.config <- list(
    ALGEBRA_II.2021_2022.2 = list(
        sgp.content.areas = c("MATHEMATICS", "ALGEBRA_II"),
        sgp.panel.years = c("2018_2019.2", "2021_2022.2"),
        sgp.grade.sequences = list(
            c("6", "EOCT"), c("7", "EOCT"), c("8", "EOCT")
        ),
        sgp.norm.group.preference = 0L
    ),
    ALGEBRA_II.2021_2022.2 = list(
        sgp.content.areas = c("ALGEBRA_I", "ALGEBRA_II"),
        sgp.panel.years = c("2018_2019.2", "2021_2022.2"),
        sgp.grade.sequences = list(c("EOCT", "EOCT")),
        sgp.norm.group.preference = 1L
    )
)
