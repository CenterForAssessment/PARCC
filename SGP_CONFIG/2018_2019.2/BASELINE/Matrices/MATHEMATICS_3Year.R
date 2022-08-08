################################################################################
###                                                                          ###
###    MATH Baseline Configs for Consortium SGP Analyses (Single cohort)     ###
###                                                                          ###
################################################################################

MATHEMATICS_BASELINE.config <- list(
    list(
        sgp.baseline.content.areas = rep("MATHEMATICS", 2),
        sgp.baseline.panel.years = c("2015_2016.2", "2018_2019.2"),
        sgp.baseline.grade.sequences = c("3", "6"),
        sgp.baseline.grade.sequences.lags = 3
    ),
    list(
        sgp.baseline.content.areas = rep("MATHEMATICS", 2),
        sgp.baseline.panel.years = c("2015_2016.2", "2018_2019.2"),
        sgp.baseline.grade.sequences = c("4", "7"),
        sgp.baseline.grade.sequences.lags = 3
    ),
    list(
        sgp.baseline.content.areas = rep("MATHEMATICS", 2),
        sgp.baseline.panel.years = c("2015_2016.2", "2018_2019.2"),
        sgp.baseline.grade.sequences = c("5", "8"),
        sgp.baseline.grade.sequences.lags = 3
    )
)


#####
###   Algebra I
#####

ALGEBRA_I_BASELINE.config <- list(
    list(
        sgp.baseline.content.areas = c("MATHEMATICS", "ALGEBRA_I"),
        sgp.baseline.panel.years = c("2015_2016.2", "2018_2019.2"),
        sgp.baseline.grade.sequences = c(7, "EOCT"),
        sgp.baseline.grade.sequences.lags = 3
    ),
    list(
        sgp.baseline.content.areas = c("MATHEMATICS", "ALGEBRA_I"),
        sgp.baseline.panel.years = c("2015_2016.2", "2018_2019.2"),
        sgp.baseline.grade.sequences = c(6, "EOCT"),
        sgp.baseline.grade.sequences.lags = 3
    ),
    list(
        sgp.baseline.content.areas = c("MATHEMATICS", "ALGEBRA_I"),
        sgp.baseline.panel.years = c("2015_2016.2", "2018_2019.2"),
        sgp.baseline.grade.sequences = c(5, "EOCT"),
        sgp.baseline.grade.sequences.lags = 3
    ),
    list(
        sgp.baseline.content.areas = c("MATHEMATICS", "ALGEBRA_I"),
        sgp.baseline.panel.years = c("2015_2016.2", "2018_2019.2"),
        sgp.baseline.grade.sequences = c(4, "EOCT"),
        sgp.baseline.grade.sequences.lags = 3
    )
) ### END ALGEBRA_I_BASELINE.config


#####
###   Geometry
#####

GEOMETRY_BASELINE.config <- list(
    list(
        sgp.baseline.content.areas = c("MATHEMATICS", "GEOMETRY"),
        sgp.baseline.panel.years = c("2015_2016.2", "2018_2019.2"),
        sgp.baseline.grade.sequences = c(7, "EOCT"),
        sgp.baseline.grade.sequences.lags = 3
    ),
    list(
        sgp.baseline.content.areas = c("MATHEMATICS", "GEOMETRY"),
        sgp.baseline.panel.years = c("2015_2016.2", "2018_2019.2"),
        sgp.baseline.grade.sequences = c(6, "EOCT"),
        sgp.baseline.grade.sequences.lags = 3
    ),
    list(
        sgp.baseline.content.areas = c("MATHEMATICS", "GEOMETRY"),
        sgp.baseline.panel.years = c("2015_2016.2", "2018_2019.2"),
        sgp.baseline.grade.sequences = c(5, "EOCT"),
        sgp.baseline.grade.sequences.lags = 3
    ),
    list(
        sgp.baseline.content.areas = c("ALGEBRA_I", "GEOMETRY"),
        sgp.baseline.panel.years = c("2015_2016.2", "2018_2019.2"),
        sgp.baseline.grade.sequences = c("EOCT", "EOCT"),
        sgp.baseline.grade.sequences.lags = 3
    )
) ### END GEOMETRY_BASELINE.config


#####
###   Algebra II
#####

ALGEBRA_II_BASELINE.config <- list(
    list(
        sgp.baseline.content.areas = c("ALGEBRA_I", "ALGEBRA_II"),
        sgp.baseline.panel.years = c("2015_2016.2", "2018_2019.2"),
        sgp.baseline.grade.sequences = c("EOCT", "EOCT"),
        sgp.baseline.grade.sequences.lags = 3
    ),
    list(
        sgp.baseline.content.areas = c("GEOMETRY", "ALGEBRA_II"),
        sgp.baseline.panel.years = c("2015_2016.2", "2018_2019.2"),
        sgp.baseline.grade.sequences = c("EOCT", "EOCT"),
        sgp.baseline.grade.sequences.lags = 3
    ),
    ##    Skip Year - Grade level math priors (from Alg1 and misc.)
    list(
        sgp.baseline.content.areas = c("MATHEMATICS", "ALGEBRA_II"),
        sgp.baseline.panel.years = c("2015_2016.2", "2018_2019.2"),
        sgp.baseline.grade.sequences = c(8, "EOCT"),
        sgp.baseline.grade.sequences.lags = 3
    ),
    list(
        sgp.baseline.content.areas = c("MATHEMATICS", "ALGEBRA_II"),
        sgp.baseline.panel.years = c("2015_2016.2", "2018_2019.2"),
        sgp.baseline.grade.sequences = c(7, "EOCT"),
        sgp.baseline.grade.sequences.lags = 3
    ),
    list(
        sgp.baseline.content.areas = c("MATHEMATICS", "ALGEBRA_II"),
        sgp.baseline.panel.years = c("2015_2016.2", "2018_2019.2"),
        sgp.baseline.grade.sequences = c(6, "EOCT"),
        sgp.baseline.grade.sequences.lags = 3
    )
) ### END ALGEBRA_II_BASELINE.config
