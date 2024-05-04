###############################################################################
###                                                                         ###
###          Configs for New Jersey Spring 2023 Math Subject SGPs           ###
###                                                                         ###
###############################################################################


###   Cohort and Baseline SGP configs (SINGLE PRIOR -- STRICTLY USED THESE)

MATHEMATICS_Baseline.2022_2023.2.config <- list(
    MATHEMATICS_Baseline.2022_2023.2 = list(
        sgp.content.areas = c("MATHEMATICS", "MATHEMATICS"),
        sgp.panel.years = c("2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(
            c("3", "4"), c("4", "5"), c("5", "6"),
            c("6", "7"), c("7", "8")
        ),
        sgp.norm.group.preference = 0L
    )
)

ALGEBRA_I_Baseline.2022_2023.2.config <- list(
    ALGEBRA_I_Baseline.2022_2023.2 = list(
        sgp.content.areas = c("MATHEMATICS", "ALGEBRA_I"),
        sgp.panel.years = c("2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(c("8", "EOCT")),
        sgp.norm.group.preference = 0L # CANONICAL
    ),
    ALGEBRA_I_Baseline.2022_2023.2 = list(
        sgp.content.areas = c("MATHEMATICS", "ALGEBRA_I"),
        sgp.panel.years = c("2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(c("6", "EOCT"), c("7", "EOCT")),
        sgp.projection.grade.sequences = as.list(rep("NO_PROJECTIONS", 2)),
        sgp.norm.group.preference = 1L
    ),
    ALGEBRA_I_Baseline.2022_2023.2 = list(
        sgp.content.areas = c("GEOMETRY", "ALGEBRA_I"),
        sgp.panel.years = c("2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(c("EOCT", "EOCT")),
        sgp.projection.grade.sequences = as.list("NO_PROJECTIONS"),
        sgp.norm.group.preference = 2L
    )
)

GEOMETRY_Baseline.2022_2023.2.config <- list(
    GEOMETRY_Baseline.2022_2023.2 = list(
        sgp.content.areas = c("ALGEBRA_I", "GEOMETRY"),
        sgp.panel.years = c("2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(c("EOCT", "EOCT")),
        sgp.norm.group.preference = 0L # CANONICAL
    ),
    GEOMETRY_Baseline.2022_2023.2 = list(
        sgp.content.areas = c("MATHEMATICS", "GEOMETRY"),
        sgp.panel.years = c("2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(
            c("6", "EOCT"), c("7", "EOCT"), c("8", "EOCT")
        ),
        sgp.projection.grade.sequences = as.list(rep("NO_PROJECTIONS", 3)),
        sgp.norm.group.preference = 1L
    )
)

ALGEBRA_II_Baseline.2022_2023.2.config <- list(
    ALGEBRA_II_Baseline.2022_2023.2 = list(
        sgp.content.areas = c("GEOMETRY", "ALGEBRA_II"),
        sgp.panel.years = c("2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(c("EOCT", "EOCT")),
        sgp.norm.group.preference = 0L
    ),
    ALGEBRA_II_Baseline.2022_2023.2 = list(
        sgp.content.areas = c("ALGEBRA_I", "ALGEBRA_II"),
        sgp.panel.years = c("2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(c("EOCT", "EOCT")),
        sgp.projection.grade.sequences = as.list("NO_PROJECTIONS"),
        sgp.norm.group.preference = 1L
    )
)


###   Cohort SGP configs (DUAL PRIOR -- NOT USED)
##    No CSEM for NJ Start Strong -->> No SIMEX, so single prior only in 2023

MATHEMATICS.2022_2023.2.config <- list(
    MATHEMATICS.2022_2023.2 = list(
        sgp.content.areas = c("MATH_NJSS", "MATHEMATICS", "MATHEMATICS"),
        sgp.panel.years = c("2021_2022.1", "2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(
            c("3", "3", "4"), c("4", "4", "5"), c("5", "5", "6"),
            c("6", "6", "7"), c("7", "7", "8")
        ),
        sgp.norm.group.preference = 0L
    )
)

ALGEBRA_I.2022_2023.2.config <- list(
    ALGEBRA_I.2022_2023.2 = list(
        sgp.content.areas = c("MATH_NJSS", "MATHEMATICS", "ALGEBRA_I"),
        sgp.panel.years = c("2021_2022.1", "2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(c("8", "8", "EOCT")),
        sgp.norm.group.preference = 0L # CANONICAL
    ),
    ALGEBRA_I.2022_2023.2 = list(
        sgp.content.areas = c("MATH_NJSS", "MATHEMATICS", "ALGEBRA_I"),
        sgp.panel.years = c("2021_2022.1", "2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(c("6", "6", "EOCT"), c("7", "7", "EOCT")),
        sgp.projection.grade.sequences = as.list(rep("NO_PROJECTIONS", 2)),
        sgp.norm.group.preference = 1L
    ),
    ALGEBRA_I.2022_2023.2 = list(
        sgp.content.areas = c("GEOM_NJSS", "GEOMETRY", "ALGEBRA_I"),
        sgp.panel.years = c("2021_2022.1", "2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(c("EOCT", "EOCT", "EOCT")),
        sgp.projection.grade.sequences = as.list("NO_PROJECTIONS"),
        sgp.norm.group.preference = 2L
    )
)

GEOMETRY.2022_2023.2.config <- list(
    GEOMETRY.2022_2023.2 = list(
        sgp.content.areas = c("ALG_I_NJSS", "ALGEBRA_I", "GEOMETRY"),
        sgp.panel.years = c("2021_2022.1", "2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(c("EOCT", "EOCT", "EOCT")),
        sgp.norm.group.preference = 0L # CANONICAL
    ),
    GEOMETRY.2022_2023.2 = list(
        sgp.content.areas = c("MATH_NJSS", "MATHEMATICS", "GEOMETRY"),
        sgp.panel.years = c("2021_2022.1", "2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(
            c("6", "6", "EOCT"), c("7", "7", "EOCT"), c("8", "8", "EOCT")
        ),
        sgp.projection.grade.sequences = as.list(rep("NO_PROJECTIONS", 3)),
        sgp.norm.group.preference = 1L
    )
)

ALGEBRA_II.2022_2023.2.config <- list(
    ALGEBRA_II.2022_2023.2 = list(
        sgp.content.areas = c("GEOM_NJSS", "GEOMETRY", "ALGEBRA_II"),
        sgp.panel.years = c("2021_2022.1", "2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(c("EOCT", "EOCT", "EOCT")),
        sgp.norm.group.preference = 0L
    ),
    ALGEBRA_II.2022_2023.2 = list(
        sgp.content.areas = c("ALG_I_NJSS", "ALGEBRA_I", "ALGEBRA_II"),
        sgp.panel.years = c("2021_2022.1", "2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(c("EOCT", "EOCT", "EOCT")),
        sgp.projection.grade.sequences = as.list("NO_PROJECTIONS"),
        sgp.norm.group.preference = 1L
    )
)
