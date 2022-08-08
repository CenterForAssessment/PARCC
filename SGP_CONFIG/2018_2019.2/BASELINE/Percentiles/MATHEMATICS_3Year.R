###############################################################################
###                                                                         ###
###     Configs for Spring 2019 MATHEMATICS BASELINE SGPs - 2-Year Skip     ###
###                                                                         ###
###############################################################################

MATHEMATICS_2018_2019.2.config <- list(
    MATHEMATICS.2018_2019.2 = list(
        sgp.content.areas = rep("MATHEMATICS", 3),
        sgp.panel.years = c("2015_2016.2", "2018_2019.2"),
        sgp.grade.sequences = list(c("3", "6"), c("4", "7"), c("5", "8")),
        sgp.norm.group.preference = 0L
    )
)


ALGEBRA_I_2018_2019.2.config <- list(
    ### CANONICAL - Put first over Fall to Spring for projections/targets (Match Thetas analyses)
    ALGEBRA_I.2018_2019.2 = list(
        sgp.content.areas = c("MATHEMATICS", "ALGEBRA_I"),
        sgp.panel.years = c("2015_2016.2", "2018_2019.2"),
        sgp.grade.sequences = list(c("6", "EOCT")),
        # sgp.projection.grade.sequences = list("NO_PROJECTIONS"), # 9th grade - CANONICAL
        sgp.norm.group.preference = 0L
    ),
    ALGEBRA_I.2018_2019.2 = list(
        sgp.content.areas = c("MATHEMATICS", "ALGEBRA_I"),
        sgp.panel.years = c("2015_2016.2", "2018_2019.2"),
        sgp.grade.sequences = list(c("4", "EOCT"), c("5", "EOCT"), c("7", "EOCT")), # 7th, 8th & 10th graders
        sgp.projection.grade.sequences = as.list(rep("NO_PROJECTIONS", 3)),
        sgp.norm.group.preference = 1L
    )
)


GEOMETRY_2018_2019.2.config <- list(
    ### CANONICAL - Put first over Fall to Spring for projections/targets (Match Thetas analyses)
    GEOMETRY.2018_2019.2 = list(
        sgp.content.areas = c("MATHEMATICS", "GEOMETRY"),
        sgp.panel.years = c("2015_2016.2", "2018_2019.2"),
        sgp.grade.sequences = list(c("7", "EOCT")),
        # sgp.projection.grade.sequences = list("NO_PROJECTIONS"), # 10th grade - CANONICAL
        sgp.norm.group.preference = 0L
    ),
    GEOMETRY.2018_2019.2 = list(
        sgp.content.areas = c("MATHEMATICS", "GEOMETRY"),
        sgp.panel.years = c("2015_2016.2", "2018_2019.2"),
        sgp.grade.sequences = list(c("6", "EOCT"), c("5", "EOCT")),
        sgp.projection.grade.sequences = as.list(rep("NO_PROJECTIONS", 2)),
        sgp.norm.group.preference = 1L
    )
)


ALGEBRA_II_2018_2019.2.config <- list(
    ALGEBRA_II.2018_2019.2 = list(
        sgp.content.areas = c("MATHEMATICS", "ALGEBRA_II"),
        sgp.panel.years = c("2015_2016.2", "2018_2019.2"),
        sgp.grade.sequences = list(c("6", "EOCT"), c("7", "EOCT"), c("8", "EOCT")),
        sgp.exact.grade.progression = as.list(rep(TRUE, 3)), #  Need exact to avoid multiple "ALGEBRA_I", "ALGEBRA_II" matrices
        sgp.projection.grade.sequences = as.list(rep("NO_PROJECTIONS", 3)),
        sgp.norm.group.preference = 0L
    ),
    ALGEBRA_II.2018_2019.2 = list(
        sgp.content.areas = c("ALGEBRA_I", "ALGEBRA_II"),
        sgp.panel.years = c("2015_2016.2", "2018_2019.2"),
        sgp.grade.sequences = list(c("EOCT", "EOCT")),
        sgp.projection.grade.sequences = list("NO_PROJECTIONS"),
        sgp.norm.group.preference = 2L
    ),
    ALGEBRA_II.2018_2019.2 = list(
        sgp.content.areas = c("GEOMETRY", "ALGEBRA_II"),
        sgp.panel.years = c("2015_2016.2", "2018_2019.2"),
        sgp.grade.sequences = list(c("EOCT", "EOCT")),
        sgp.projection.grade.sequences = list("NO_PROJECTIONS"),
        sgp.norm.group.preference = 2L
    )
)
