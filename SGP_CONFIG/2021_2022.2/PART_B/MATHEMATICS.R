###############################################################################
###                                                                         ###
###    Configs for Spring 2022 Grade Level Math Cohort and Baseline SGPs    ###
###                                                                         ###
###############################################################################

MATHEMATICS_2021_2022.2.config <- list(
    MATHEMATICS.2021_2022.2 = list(
        sgp.content.areas = rep("MATHEMATICS", 2),
        sgp.panel.years = c("2020_2021.2", "2021_2022.2"),
        sgp.grade.sequences = list(
            c("3", "4"), c("4", "5"),
            c("5", "6"), c("6", "7"), c("7", "8")),
        sgp.norm.group.preference = 0L
    )
)

ALGEBRA_I.2021_2022.2.config <- list(
    ### CANONICAL - Put first over Fall to Spring for projections/targets (Match Thetas analyses)
    ALGEBRA_I.2021_2022.2 = list(
        sgp.content.areas = c("MATHEMATICS", "ALGEBRA_I"),
        sgp.panel.years = c("2020_2021.2", "2021_2022.2"),
        sgp.grade.sequences = list(c("8", "EOCT")),
        # sgp.projection.grade.sequences = list("NO_PROJECTIONS"), # 9th grade - CANONICAL
        sgp.norm.group.preference = 0L),

    ALGEBRA_I.2021_2022.2 = list(
        sgp.content.areas = c("MATHEMATICS", "ALGEBRA_I"),
        sgp.panel.years = c("2020_2021.2", "2021_2022.2"),
        sgp.grade.sequences = list(c("6", "EOCT"), c("7", "EOCT")), # 7th & 8th grades
        sgp.projection.grade.sequences = as.list(rep("NO_PROJECTIONS", 2)),
        sgp.norm.group.preference = 1L),

    ALGEBRA_I.2021_2022.2 = list(
        sgp.content.areas = c("GEOMETRY", "ALGEBRA_I"),
        sgp.panel.years = c("2020_2021.2", "2021_2022.2"),
        sgp.grade.sequences = list(c("EOCT", "EOCT")),
        sgp.projection.grade.sequences = list("NO_PROJECTIONS"),
        sgp.norm.group.preference = 2L)
)


GEOMETRY.2021_2022.2.config <- list(
    ### CANONICAL - Put first over Fall to Spring for projections/targets (Match Thetas analyses)
    GEOMETRY.2021_2022.2 = list(
        sgp.content.areas = c("ALGEBRA_I", "GEOMETRY"),
        sgp.panel.years = c("2020_2021.2", "2021_2022.2"),
        sgp.grade.sequences = list(c("EOCT", "EOCT")),
        # sgp.projection.grade.sequences = list("NO_PROJECTIONS"), # 10th grade - CANONICAL
        sgp.norm.group.preference = 0L),

    GEOMETRY.2021_2022.2 = list(
        sgp.content.areas = c("ALGEBRA_II", "GEOMETRY"),
        sgp.panel.years = c("2020_2021.2", "2021_2022.2"),
        sgp.grade.sequences = list(c("EOCT", "EOCT")),
        sgp.projection.grade.sequences = list("NO_PROJECTIONS"),
        sgp.norm.group.preference = 1L),

    GEOMETRY.2021_2022.2 = list(
        sgp.content.areas = c("MATHEMATICS", "GEOMETRY"),
        sgp.panel.years = c("2020_2021.2", "2021_2022.2"),
        sgp.grade.sequences = list(c("5", "EOCT"), c("6", "EOCT"),
                                   c("7", "EOCT"), c("8", "EOCT")),
        sgp.projection.grade.sequences = as.list(rep("NO_PROJECTIONS", 4)),
        sgp.norm.group.preference = 2L) # 8th & 9th grades
)


ALGEBRA_II.2021_2022.2.config <- list(
    ### CANONICAL - Put first over Fall to Spring for projections/targets
    ALGEBRA_II.2021_2022.2 = list(
        sgp.content.areas = c("GEOMETRY", "ALGEBRA_II"),
        sgp.panel.years = c("2020_2021.2", "2021_2022.2"),
        sgp.grade.sequences = list(c("EOCT", "EOCT")),
        # sgp.projection.grade.sequences = list("NO_PROJECTIONS"), # CANONICAL
        sgp.norm.group.preference = 0L),

    ALGEBRA_II.2021_2022.2 = list(
        sgp.content.areas = c("ALGEBRA_I", "ALGEBRA_II"),
        sgp.panel.years = c("2020_2021.2", "2021_2022.2"),
        sgp.grade.sequences = list(c("EOCT", "EOCT")),
        sgp.projection.grade.sequences = list("NO_PROJECTIONS"),
        sgp.norm.group.preference = 1L),

    ALGEBRA_II.2021_2022.2 = list( #  --  <1000 :: Include for SGP_NOTE (except 9th grade)
        sgp.content.areas = c("MATHEMATICS", "ALGEBRA_II"),
        sgp.panel.years = c("2020_2021.2", "2021_2022.2"),
        sgp.grade.sequences = list(c("6", "EOCT"), c("7", "EOCT"), c("8", "EOCT")),
        sgp.projection.grade.sequences = as.list(rep("NO_PROJECTIONS", 3)),
        sgp.norm.group.preference = 2L) # 8th & 9th grades
)
