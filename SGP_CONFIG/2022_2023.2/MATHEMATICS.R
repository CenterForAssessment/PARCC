###############################################################################
###                                                                         ###
###    Configs for Spring 2023 Grade Level Math Cohort and Baseline SGPs    ###
###                                                                         ###
###############################################################################

MATHEMATICS.2023.config <- list(
    MATHEMATICS.2023 = list(
        sgp.content.areas = rep("MATHEMATICS", 3),
        sgp.panel.years = c("2020_2021.2", "2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(
            c("3", "4"), c("3", "4", "5"),
            c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8")
        ),
        sgp.norm.group.preference = 0L
    ),
    # Skip Year (mainly for DoDEA - no 7th grade math until 2023)
    MATHEMATICS_SKIP.2023 = list(
        sgp.content.areas = rep("MATHEMATICS", 3),
        sgp.panel.years = c("2020_2021.2", "2022_2023.2"),
        sgp.grade.sequences = list(c("6", "8")),
        sgp.projection.grade.sequences = list("NO_PROJECTIONS"),
        sgp.norm.group.preference = 1L
    )
)

ALGEBRA_I.2023.config <- list(
    # Single prior only (no viable 2 prior progressions)
    ALGEBRA_I.2023 = list(
        sgp.content.areas = c("MATHEMATICS", "ALGEBRA_I"),
        sgp.panel.years = c("2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(c("8", "EOCT")),
        # sgp.projection.grade.sequences = list("NO_PROJECTIONS"), # CANONICAL
        sgp.norm.group.preference = 0L
    ),

    ALGEBRA_I.2023 = list(
        sgp.content.areas = c("MATHEMATICS", "ALGEBRA_I"),
        sgp.panel.years = c("2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(c("6", "EOCT"), c("7", "EOCT")),
        sgp.projection.grade.sequences = as.list(rep("NO_PROJECTIONS", 2)),
        sgp.norm.group.preference = 1L
    ),
    ALGEBRA_I.2023 = list(
        sgp.content.areas = c("GEOMETRY", "ALGEBRA_I"),
        sgp.panel.years = c("2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(c("EOCT", "EOCT")),
        sgp.projection.grade.sequences = list("NO_PROJECTIONS"),
        sgp.norm.group.preference = 2L
    )
)

GEOMETRY.2023.config <- list(
    # Single prior only (no viable 2 prior progressions)
    GEOMETRY.2023 = list(
        sgp.content.areas = c("ALGEBRA_I", "GEOMETRY"),
        sgp.panel.years = c("2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(c("EOCT", "EOCT")),
        # sgp.exact.grade.progression = TRUE, # avoid multiple matrices
        # sgp.projection.grade.sequences = list("NO_PROJECTIONS"), # CANONICAL
        sgp.norm.group.preference = 0L
    ),
    # GEOMETRY.2023 = list(
    #     sgp.content.areas = c("MATHEMATICS", "ALGEBRA_I", "GEOMETRY"),
    #     sgp.panel.years = c("2020_2021.2", "2021_2022.2", "2022_2023.2"),
    #     sgp.grade.sequences = list(
    #         c("6", "EOCT", "EOCT"), c("7", "EOCT", "EOCT")
    #     ),
    #     sgp.exact.grade.progression = as.list(rep(TRUE, 2)), # multiple matrices
    #     sgp.projection.grade.sequences = as.list(rep("NO_PROJECTIONS", 2)),
    #     sgp.norm.group.preference = 1L
    # ),
    # GEOMETRY.2023 = list( # Don't need - done CANONICAL above
    #     sgp.content.areas = c("ALGEBRA_I", "GEOMETRY"),
    #     sgp.panel.years = c("2021_2022.2", "2022_2023.2"),
    #     sgp.grade.sequences = list(c("EOCT", "EOCT")),
    #     sgp.projection.grade.sequences = list("NO_PROJECTIONS"),
    #     sgp.norm.group.preference = 2L
    # ),

    GEOMETRY.2023 = list(
        sgp.content.areas = c("ALGEBRA_II", "GEOMETRY"),
        sgp.panel.years = c("2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(c("EOCT", "EOCT")),
        sgp.projection.grade.sequences = list("NO_PROJECTIONS"),
        sgp.norm.group.preference = 1L
    ),
    GEOMETRY.2023 = list(
        sgp.content.areas = c("MATHEMATICS", "GEOMETRY"),
        sgp.panel.years = c("2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(
            c("5", "EOCT"), c("6", "EOCT"),
            c("7", "EOCT"), c("8", "EOCT")
        ),
        sgp.projection.grade.sequences = as.list(rep("NO_PROJECTIONS", 4)),
        sgp.norm.group.preference = 2L
    ) # 8th & 9th grades
)

ALGEBRA_II.2023.config <- list(
    ### CANONICAL - Put first over Fall to Spring for projections/targets
    ALGEBRA_II.2023 = list(
        sgp.content.areas = c("GEOMETRY", "ALGEBRA_II"),
        sgp.panel.years = c("2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(c("EOCT", "EOCT")),
        # sgp.projection.grade.sequences = list("NO_PROJECTIONS"), # CANONICAL
        sgp.norm.group.preference = 0L
    ),
    ALGEBRA_II.2023 = list(
        sgp.content.areas = c("ALGEBRA_I", "ALGEBRA_II"),
        sgp.panel.years = c("2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(c("EOCT", "EOCT")),
        # sgp.projection.grade.sequences = as.list(rep("NO_PROJECTIONS", 2)),
        sgp.projection.grade.sequences = list("NO_PROJECTIONS"),
        sgp.norm.group.preference = 1L
    ),
    ALGEBRA_II.2023 = list( #  --  <1000 :: Include for SGP_NOTE
        sgp.content.areas = c("MATHEMATICS", "ALGEBRA_II"),
        sgp.panel.years = c("2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(
            c("6", "EOCT"), c("7", "EOCT"), c("8", "EOCT")
        ),
        sgp.projection.grade.sequences = as.list(rep("NO_PROJECTIONS", 3)),
        sgp.norm.group.preference = 2L
    ) # 8th & 9th grades
)
