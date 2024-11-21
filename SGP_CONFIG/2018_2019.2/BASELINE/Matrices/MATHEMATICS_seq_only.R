################################################################################
###                                                                          ###
###    MATH Baseline Configs for Consortium SGP Analyses (Single cohort)     ###
###                                                                          ###
################################################################################

order.1.years <- c("2017_2018.2", "2018_2019.2")
order.2.years <- c("2016_2017.2", "2017_2018.2", "2018_2019.2")

MATHEMATICS_BASELINE.config <- list(
    list(
        sgp.baseline.content.areas = rep("MATHEMATICS", 2),
        sgp.baseline.panel.years = order.1.years,
        sgp.baseline.grade.sequences = c("3", "4"),
        sgp.baseline.grade.sequences.lags = 1),

    list(
        sgp.baseline.content.areas = rep("MATHEMATICS", 2),
        sgp.baseline.panel.years = order.1.years,
        sgp.baseline.grade.sequences = c("4", "5"),
        sgp.baseline.grade.sequences.lags = 1),
    list(
        sgp.baseline.content.areas = rep("MATHEMATICS", 3),
        sgp.baseline.panel.years = order.2.years,
        sgp.baseline.grade.sequences = c("3", "4", "5"),
        sgp.baseline.grade.sequences.lags = c(1, 1)),

    list(
        sgp.baseline.content.areas = rep("MATHEMATICS", 2),
        sgp.baseline.panel.years = order.1.years,
        sgp.baseline.grade.sequences = c("5", "6"),
        sgp.baseline.grade.sequences.lags = 1),
    list(
        sgp.baseline.content.areas = rep("MATHEMATICS", 3),
        sgp.baseline.panel.years = order.2.years,
        sgp.baseline.grade.sequences = c("4", "5", "6"),
        sgp.baseline.grade.sequences.lags = c(1, 1)),

    list(
        sgp.baseline.content.areas = rep("MATHEMATICS", 2),
        sgp.baseline.panel.years = order.1.years,
        sgp.baseline.grade.sequences = c("6", "7"),
        sgp.baseline.grade.sequences.lags = 1),
    list(
        sgp.baseline.content.areas = rep("MATHEMATICS", 3),
        sgp.baseline.panel.years = order.2.years,
        sgp.baseline.grade.sequences = c("5", "6", "7"),
        sgp.baseline.grade.sequences.lags = c(1, 1)),

    list(
        sgp.baseline.content.areas = rep("MATHEMATICS", 2),
        sgp.baseline.panel.years = order.1.years,
        sgp.baseline.grade.sequences = c("7", "8"),
        sgp.baseline.grade.sequences.lags = 1),
    list(
        sgp.baseline.content.areas = rep("MATHEMATICS", 3),
        sgp.baseline.panel.years = order.2.years,
        sgp.baseline.grade.sequences = c("6", "7", "8"),
        sgp.baseline.grade.sequences.lags = c(1, 1))
)


#####
###   Algebra I
#####

ALGEBRA_I_BASELINE.config <- list(
    list(
        sgp.baseline.content.areas = c("MATHEMATICS", "ALGEBRA_I"),
        sgp.baseline.panel.years = order.1.years,
        sgp.baseline.grade.sequences = c(5, "EOCT"),
        sgp.baseline.grade.sequences.lags = 1),

    ###   Baseline Cohort > 1,000

   ###
  #####     This config is DUPLICATED!!!  Messed up NJ analyses (noticed/commented out in 2024) -- NOT RERUN as of 7/17/2024
    # list(
    #     sgp.baseline.content.areas = c("MATHEMATICS", "ALGEBRA_I"),
    #     sgp.baseline.panel.years = order.1.years,
    #     sgp.baseline.grade.sequences = c(6, "EOCT"),
    #     sgp.baseline.grade.sequences.lags = 1),
  #####
   ###

    list( # Sequential 8th grade Math to Alg1
        sgp.baseline.content.areas = c("MATHEMATICS", "ALGEBRA_I"),
        sgp.baseline.panel.years = order.1.years,
        sgp.baseline.grade.sequences = c(8, "EOCT"),
        sgp.baseline.grade.sequences.lags = 1),
    list(
        sgp.baseline.content.areas = c("MATHEMATICS", "MATHEMATICS", "ALGEBRA_I"),
        sgp.baseline.panel.years = order.2.years,
        sgp.baseline.grade.sequences = c(7, 8, "EOCT"),
        sgp.baseline.grade.sequences.lags = c(1, 1)),

    list( # Sequential 7th grade Math to Alg1
        sgp.baseline.content.areas = c("MATHEMATICS", "ALGEBRA_I"),
        sgp.baseline.panel.years = order.1.years,
        sgp.baseline.grade.sequences = c(7, "EOCT"),
        sgp.baseline.grade.sequences.lags = 1),
    list( # Sequential 7th grade Math to Alg1
        sgp.baseline.content.areas = c("MATHEMATICS", "MATHEMATICS", "ALGEBRA_I"),
        sgp.baseline.panel.years = order.2.years,
        sgp.baseline.grade.sequences = c(6, 7, "EOCT"),
        sgp.baseline.grade.sequences.lags = c(1, 1)),

    list( # Sequential 6th grade Math to Alg1
        sgp.baseline.content.areas = c("MATHEMATICS", "ALGEBRA_I"),
        sgp.baseline.panel.years = order.1.years,
        sgp.baseline.grade.sequences = c(6, "EOCT"),
        sgp.baseline.grade.sequences.lags = 1),
    list( # Sequential 7th grade Math to Alg1
        sgp.baseline.content.areas = c("MATHEMATICS", "MATHEMATICS", "ALGEBRA_I"),
        sgp.baseline.panel.years = order.2.years,
        sgp.baseline.grade.sequences = c(5, 6, "EOCT"),
        sgp.baseline.grade.sequences.lags = c(1, 1))
) ### END ALGEBRA_I_BASELINE.config


#####
###   Geometry
#####

GEOMETRY_BASELINE.config <- list(
    list( # Sequential Alg1 to Geom (CANONICAL)
        sgp.baseline.content.areas = c("ALGEBRA_I", "GEOMETRY"),
        sgp.baseline.panel.years = order.1.years,
        sgp.baseline.grade.sequences = c("EOCT", "EOCT"),
        sgp.baseline.grade.sequences.lags = 1),
    list(
        sgp.baseline.content.areas = c("MATHEMATICS", "ALGEBRA_I", "GEOMETRY"),
        sgp.baseline.panel.years = order.2.years,
        sgp.baseline.grade.sequences = c(8, "EOCT", "EOCT"),
        sgp.baseline.grade.sequences.lags = c(1, 1)),
    list(
        sgp.baseline.content.areas = c("MATHEMATICS", "ALGEBRA_I", "GEOMETRY"),
        sgp.baseline.panel.years = order.2.years,
        sgp.baseline.grade.sequences = c(7, "EOCT", "EOCT"),
        sgp.baseline.grade.sequences.lags = c(1, 1)),
    list(
        sgp.baseline.content.areas = c("MATHEMATICS", "ALGEBRA_I", "GEOMETRY"),
        sgp.baseline.panel.years = order.2.years,
        sgp.baseline.grade.sequences = c(6, "EOCT", "EOCT"),
        sgp.baseline.grade.sequences.lags = c(1, 1)),

        ##  Misc.
    list(
        sgp.baseline.content.areas = c("MATHEMATICS", "GEOMETRY"),
        sgp.baseline.panel.years = order.1.years,
        sgp.baseline.grade.sequences = c(8, "EOCT"),
        sgp.baseline.grade.sequences.lags = 1),
    list(
        sgp.baseline.content.areas = c("MATHEMATICS", "GEOMETRY"),
        sgp.baseline.panel.years = order.1.years,
        sgp.baseline.grade.sequences = c(7, "EOCT"),
        sgp.baseline.grade.sequences.lags = 1),

    list(
        sgp.baseline.content.areas = c("ALGEBRA_II", "GEOMETRY"),
        sgp.baseline.panel.years = order.1.years,
        sgp.baseline.grade.sequences = c("EOCT", "EOCT"),
        sgp.baseline.grade.sequences.lags = 1),
    list(
        sgp.baseline.content.areas = c("ALGEBRA_I", "ALGEBRA_II", "GEOMETRY"),
        sgp.baseline.panel.years = order.2.years,
        sgp.baseline.grade.sequences = c("EOCT", "EOCT", "EOCT"),
        sgp.baseline.grade.sequences.lags = c(1, 1))
) ### END GEOMETRY_BASELINE.config


#####
###   Algebra 2
#####

ALGEBRA_II_BASELINE.config <- list(
    list( # Sequential Geom to Alg1 (CANONICAL)
      sgp.baseline.content.areas = c("GEOMETRY", "ALGEBRA_II"),
      sgp.baseline.panel.years = order.1.years,
      sgp.baseline.grade.sequences = c("EOCT", "EOCT"),
      sgp.baseline.grade.sequences.lags = 1),
    list(
      sgp.baseline.content.areas = c("ALGEBRA_I", "GEOMETRY", "ALGEBRA_II"),
      sgp.baseline.panel.years = order.2.years,
      sgp.baseline.grade.sequences = c("EOCT", "EOCT", "EOCT"),
      sgp.baseline.grade.sequences.lags = c(1, 1)),

      ##  Alg1 to Alg2 directly
    list(
      sgp.baseline.content.areas = c("ALGEBRA_I", "ALGEBRA_II"),
      sgp.baseline.panel.years = order.1.years,
      sgp.baseline.grade.sequences = c("EOCT", "EOCT"),
      sgp.baseline.grade.sequences.lags = 1),
    list(
      sgp.baseline.content.areas = c("MATHEMATICS", "ALGEBRA_I", "ALGEBRA_II"),
      sgp.baseline.panel.years = order.2.years,
      sgp.baseline.grade.sequences = c(8, "EOCT", "EOCT"),
      sgp.baseline.grade.sequences.lags = c(1, 1)),
    list(
      sgp.baseline.content.areas = c("MATHEMATICS", "ALGEBRA_I", "ALGEBRA_II"),
      sgp.baseline.panel.years = order.2.years,
      sgp.baseline.grade.sequences = c(7, "EOCT", "EOCT"),
      sgp.baseline.grade.sequences.lags = c(1, 1))
) ### END ALGEBRA_II_BASELINE.config
