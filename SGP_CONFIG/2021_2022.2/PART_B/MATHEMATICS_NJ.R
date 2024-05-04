###############################################################################
###                                                                         ###
###     Configs for New Jersey Spring 2022 Math Subjects - Cohort SGPs      ###
###                                                                         ###
###############################################################################

MATHEMATICS_2021_2022.2.config <- list(
    MATHEMATICS.2021_2022.2 = list(
        sgp.content.areas = c("MATH_NJSS", "MATHEMATICS"),
        sgp.panel.years = c("2021_2022.1", "2021_2022.2"),
        sgp.grade.sequences = list(
            c("4", "4"), c("5", "5"),
            c("6", "6"), c("7", "7"), c("8", "8")
        ),
        sgp.norm.group.preference = 0L
    )
)

ALGEBRA_I.2021_2022.2.config <- list(
    ALGEBRA_I.2021_2022.2 = list(
        sgp.content.areas = c("ALG_I_NJSS", "ALGEBRA_I"),
        sgp.panel.years = c("2021_2022.1", "2021_2022.2"),
        sgp.grade.sequences = list(c("EOCT", "EOCT")),
        sgp.norm.group.preference = 0L
    ),
    ALGEBRA_I.2021_2022.2 = list(
        sgp.content.areas = c("MATH_NJSS", "ALGEBRA_I"),
        sgp.panel.years = c("2021_2022.1", "2021_2022.2"),
        sgp.grade.sequences = list(c("8", "EOCT")),
        sgp.projection.grade.sequences = as.list(rep("NO_PROJECTIONS", 2)),
        sgp.norm.group.preference = 1L
    )
)

GEOMETRY.2021_2022.2.config <- list(
    GEOMETRY.2021_2022.2 = list(
        sgp.content.areas = c("GEOM_NJSS", "GEOMETRY"),
        sgp.panel.years = c("2021_2022.1", "2021_2022.2"),
        sgp.grade.sequences = list(c("EOCT", "EOCT")),
        sgp.norm.group.preference = 0L
    )
)

ALGEBRA_II.2021_2022.2.config <- list(
    ALGEBRA_II.2021_2022.2 = list(
        sgp.content.areas = c("ALG_II_NJSS", "ALGEBRA_II"),
        sgp.panel.years = c("2021_2022.1", "2021_2022.2"),
        sgp.grade.sequences = list(c("EOCT", "EOCT")),
        sgp.norm.group.preference = 0L
    )
)

MATH_GPA.2021_2022.2.config <- list(
    MATH_GPA.2021_2022.2 = list(
        sgp.content.areas = c("MATHEMATICS", "MATHEMATICS", "MATH_GPA"),
        sgp.panel.years = c("2017_2018.2", "2018_2019.2", "2021_2022.2"),
        sgp.grade.sequences = list(c("7", "8", "EOCT")),
        sgp.norm.group.preference = 0L
    ),
    MATH_GPA.2021_2022.2 = list(
        sgp.content.areas = c("ALG_II_NJSS", "MATH_GPA"),
        sgp.panel.years = c("2021_2022.1", "2021_2022.2"),
        sgp.grade.sequences = list(c("EOCT", "EOCT")),
        sgp.norm.group.preference = 1L
    ),
   MATH_GPA.2021_2022.2 = list(
        sgp.content.areas = c("GEOM_NJSS", "MATH_GPA"),
        sgp.panel.years = c("2021_2022.1", "2021_2022.2"),
        sgp.grade.sequences = list(c("EOCT", "EOCT")),
        sgp.norm.group.preference = 2L
    ),
    MATH_GPA.2021_2022.2 = list(
        sgp.content.areas = c("ALG_I_NJSS", "MATH_GPA"),
        sgp.panel.years = c("2021_2022.1", "2021_2022.2"),
        sgp.grade.sequences = list(c("EOCT", "EOCT")),
        sgp.norm.group.preference = 3L
    )
)

##  Find viable configs
# ids <- NJSS_Data_LONG_2021_2022.1[CONTENT_AREA=='ALG_II_NJSS', ID]
# tst <- New_Jersey_Data_LONG_2021_2022.2[ID %in% ids]
# table(tst$TestCode)

# ids <- New_Jersey_Data_LONG_2021_2022.2[CONTENT_AREA=='GEOMETRY', ID]
# tst <- NJSS_Data_LONG_2021_2022.1[ID %in% ids]
# table(tst$TestCode)
