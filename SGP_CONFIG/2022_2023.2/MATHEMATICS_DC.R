###############################################################################
###                                                                         ###
###    Configs for Spring 2023 Grade Level Math Cohort and Baseline SGPs    ###
###                                                                         ###
###############################################################################

MATHEMATICS_2022_2023.2.config <- list(
    MATHEMATICS.2022_2023.2 = list(
        sgp.content.areas = rep("MATHEMATICS", 2),
        sgp.panel.years = c("2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(
            c("3", "4"), c("4", "5"),
            c("5", "6"), c("6", "7"), c("7", "8")
         ),
        sgp.norm.group.preference = 0L
    )
)

##  Don't need separate math baseline configs (only ELA due to 9 & 10 grades beginning in 2019 )

# MATHEMATICS_Baseline_2022_2023.2.config <- list(
#     MATHEMATICS.2022_2023.2 = list(
#         sgp.content.areas = rep("ELA", 2),
#         sgp.panel.years = c("2021_2022.2", "2022_2023.2"),
#         sgp.grade.sequences = list(
#             c("3", "4"), c("4", "5"),
#             c("5", "6"), c("6", "7"), c("7", "8")
#         ),...
#         sgp.norm.group.preference = 0L
#     )
# )

ALGEBRA_I.2022_2023.2.config <- list(
    ALGEBRA_I.2022_2023.2 = list(
        sgp.content.areas = c("MATHEMATICS", "ALGEBRA_I"),
        sgp.panel.years = c("2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(c("8", "EOCT")),
        # sgp.projection.grade.sequences = list("NO_PROJECTIONS"), # CANONICAL
        sgp.norm.group.preference = 0L
    ),
    ALGEBRA_I.2022_2023.2 = list(
        sgp.content.areas = c("MATHEMATICS", "ALGEBRA_I"),
        sgp.panel.years = c("2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(c("7", "EOCT")),
        sgp.projection.grade.sequences = list("NO_PROJECTIONS"),
        sgp.norm.group.preference = 1L
    )
)


ALGEBRA_I_Baseline.2022_2023.2.config <- list(
    ALGEBRA_I.2022_2023.2 = list(
        sgp.content.areas = c("MATHEMATICS", "ALGEBRA_I"),
        sgp.panel.years = c("2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(c("8", "EOCT")),
        # sgp.projection.grade.sequences = list("NO_PROJECTIONS"), # CANONICAL
        sgp.norm.group.preference = 0L
    )
)

GEOMETRY.2022_2023.2.config <- list(
    GEOMETRY.2022_2023.2 = list(
        sgp.content.areas = c("ALGEBRA_I", "GEOMETRY"),
        sgp.panel.years = c("2021_2022.2", "2022_2023.2"),
        sgp.grade.sequences = list(c("EOCT", "EOCT")),
        # sgp.projection.grade.sequences = list("NO_PROJECTIONS"), # CANONICAL
        sgp.norm.group.preference = 0L
    )
)
