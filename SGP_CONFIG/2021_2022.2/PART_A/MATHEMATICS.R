##############################################################################
###                                                                        ###
###         Spring 2019 Math consecutive-year baseline SGP configs         ###
###                                                                        ###
##############################################################################

MATHEMATICS_2018_2019.2.config <- list(
    MATHEMATICS.2018_2019.2 = list(
        sgp.content.areas = rep("MATHEMATICS", 3),
        sgp.panel.years = c("2016_2017.2", "2017_2018.2", "2018_2019.2"),
        sgp.grade.sequences = list(
            c("3", "4"), c("3", "4", "5"),
            c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8")
        ),
        sgp.norm.group.preference = 0L
    )
)


ALGEBRA_I_2018_2019.2.config <- list(
    ALGEBRA_I.2018_2019.2 = list( ### CANONICAL
        sgp.content.areas = c("MATHEMATICS", "MATHEMATICS", "ALGEBRA_I"),
        sgp.panel.years = c("2016_2017.2", "2017_2018.2", "2018_2019.2"),
        sgp.grade.sequences = list(c("7", "8", "EOCT")),
        sgp.norm.group.preference = 0L
    )
)


GEOMETRY_2018_2019.2.config <- list(
    GEOMETRY.2018_2019.2 = list( ### CANONICAL
        sgp.content.areas = c("MATHEMATICS", "ALGEBRA_I", "GEOMETRY"),
        sgp.panel.years = c("2016_2017.2", "2017_2018.2", "2018_2019.2"),
        sgp.grade.sequences = list(c("EOCT", "EOCT", "EOCT")),
        sgp.norm.group.preference = 0L
    )
)


ALGEBRA_II_2018_2019.2.config <- list(
    ALGEBRA_II.2018_2019.2 = list( ### CANONICAL
        sgp.content.areas = c("ALGEBRA_I", "GEOMETRY", "ALGEBRA_II"),
        sgp.panel.years = c("2016_2017.2", "2017_2018.2", "2018_2019.2"),
        sgp.grade.sequences = list(c("EOCT", "EOCT", "EOCT")),
        sgp.norm.group.preference = 0L
    )
)
