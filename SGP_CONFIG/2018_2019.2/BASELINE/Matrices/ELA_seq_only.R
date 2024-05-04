################################################################################
###                                                                          ###
###     ELA Baseline Configs for Consortium SGP Analyses (Single cohort)     ###
###                                                                          ###
################################################################################

order.1.years <- c("2017_2018.2", "2018_2019.2")
order.2.years <- c("2016_2017.2", "2017_2018.2", "2018_2019.2")

ELA_BASELINE.config <- list(
    list(
        sgp.baseline.content.areas = rep("ELA", 2),
        sgp.baseline.panel.years = order.1.years,
        sgp.baseline.grade.sequences = c("3", "4"),
        sgp.baseline.grade.sequences.lags = 1),

    list(
        sgp.baseline.content.areas = rep("ELA", 2),
        sgp.baseline.panel.years = order.1.years,
        sgp.baseline.grade.sequences = c("4", "5"),
        sgp.baseline.grade.sequences.lags = 1),
    list(
        sgp.baseline.content.areas = rep("ELA", 3),
        sgp.baseline.panel.years = order.2.years,
        sgp.baseline.grade.sequences = c("3", "4", "5"),
        sgp.baseline.grade.sequences.lags = c(1, 1)),

    list(
        sgp.baseline.content.areas = rep("ELA", 2),
        sgp.baseline.panel.years = order.1.years,
        sgp.baseline.grade.sequences = c("5", "6"),
        sgp.baseline.grade.sequences.lags = 1),
    list(
        sgp.baseline.content.areas = rep("ELA", 3),
        sgp.baseline.panel.years = order.2.years,
        sgp.baseline.grade.sequences = c("4", "5", "6"),
        sgp.baseline.grade.sequences.lags = c(1, 1)),

    list(
        sgp.baseline.content.areas = rep("ELA", 2),
        sgp.baseline.panel.years = order.1.years,
        sgp.baseline.grade.sequences = c("6", "7"),
        sgp.baseline.grade.sequences.lags = 1),
    list(
        sgp.baseline.content.areas = rep("ELA", 3),
        sgp.baseline.panel.years = order.2.years,
        sgp.baseline.grade.sequences = c("5", "6", "7"),
        sgp.baseline.grade.sequences.lags = c(1, 1)),

    list(
        sgp.baseline.content.areas = rep("ELA", 2),
        sgp.baseline.panel.years = order.1.years,
        sgp.baseline.grade.sequences = c("7", "8"),
        sgp.baseline.grade.sequences.lags = 1),
    list(
        sgp.baseline.content.areas = rep("ELA", 3),
        sgp.baseline.panel.years = order.2.years,
        sgp.baseline.grade.sequences = c("6", "7", "8"),
        sgp.baseline.grade.sequences.lags = c(1, 1)),

    list(
        sgp.baseline.content.areas = rep("ELA", 2),
        sgp.baseline.panel.years = order.1.years,
        sgp.baseline.grade.sequences = c("8", "9"),
        sgp.baseline.grade.sequences.lags = 1),
    list(
        sgp.baseline.content.areas = rep("ELA", 3),
        sgp.baseline.panel.years = order.2.years,
        sgp.baseline.grade.sequences = c("7", "8", "9"),
        sgp.baseline.grade.sequences.lags = c(1, 1)),

    list(
        sgp.baseline.content.areas = rep("ELA", 2),
        sgp.baseline.panel.years = order.1.years,
        sgp.baseline.grade.sequences = c("9", "10"),
        sgp.baseline.grade.sequences.lags = 1),
    list(
        sgp.baseline.content.areas = rep("ELA", 3),
        sgp.baseline.panel.years = order.2.years,
        sgp.baseline.grade.sequences = c("8", "9", "10"),
        sgp.baseline.grade.sequences.lags = c(1, 1)),

    list(
        sgp.baseline.content.areas = rep("ELA", 2),
        sgp.baseline.panel.years = order.1.years,
        sgp.baseline.grade.sequences = c("10", "11"),
        sgp.baseline.grade.sequences.lags = 1),
    list(
        sgp.baseline.content.areas = rep("ELA", 3),
        sgp.baseline.panel.years = order.2.years,
        sgp.baseline.grade.sequences = c("9", "10", "11"),
        sgp.baseline.grade.sequences.lags = c(1, 1))
)
