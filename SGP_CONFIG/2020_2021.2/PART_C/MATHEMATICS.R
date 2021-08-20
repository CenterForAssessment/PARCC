################################################################################
###                                                                          ###
###      Configurations for LAGGED (skip-year) MATH projections in 2021      ###
###                                                                          ###
################################################################################

MATHEMATICS_2020_2021.2.config <- list(
   MATHEMATICS.2021 = list(
      sgp.content.areas = rep("MATHEMATICS", 2),
      sgp.baseline.content.areas = rep("MATHEMATICS", 2),
      sgp.panel.years = c("2018_2019.2", "2020_2021.2"),
      sgp.baseline.panel.years = c("2018_2019.2", "2020_2021.2"),
      sgp.grade.sequences=list(c("3", "5")),
      sgp.baseline.grade.sequences=list(c("3", "5")),
      sgp.projection.sequence="MATHEMATICS_GRADE_5"),
   MATHEMATICS.2021 = list(
      sgp.content.areas = rep("MATHEMATICS", 3),
      sgp.baseline.content.areas = rep("MATHEMATICS", 3),
      sgp.baseline.panel.years = c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
      sgp.panel.years = c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
      sgp.grade.sequences=list(c("3", "4", "6")),
      sgp.baseline.grade.sequences=list(c("3", "4", "6")),
      sgp.projection.sequence="MATHEMATICS_GRADE_6"),
   MATHEMATICS.2021 = list(
      sgp.content.areas = rep("MATHEMATICS", 3),
      sgp.baseline.content.areas = rep("MATHEMATICS", 3),
      sgp.baseline.panel.years = c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
      sgp.panel.years = c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
      sgp.grade.sequences=list(c("4", "5", "7")),
      sgp.baseline.grade.sequences=list(c("4", "5", "7")),
      sgp.projection.sequence="MATHEMATICS_GRADE_7"),
   MATHEMATICS.2021 = list(
      sgp.content.areas = rep("MATHEMATICS", 3),
      sgp.baseline.content.areas = rep("MATHEMATICS", 3),
      sgp.baseline.panel.years = c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
      sgp.panel.years = c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
      sgp.grade.sequences=list(c("5", "6", "8")),
      sgp.baseline.grade.sequences=list(c("5", "6", "8")),
      sgp.projection.sequence="MATHEMATICS_GRADE_8"))

ALGEBRA_I_2020_2021.2.config <- list(
   ALGEBRA_I.2021 = list(
     sgp.content.areas = c(rep("MATHEMATICS", 2), "ALGEBRA_I"),
     sgp.baseline.content.areas = c(rep("MATHEMATICS", 2), "ALGEBRA_I"),
     sgp.baseline.panel.years = c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
     sgp.panel.years = c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
     sgp.grade.sequences=list(c("6", "7", "EOCT")),
     sgp.baseline.grade.sequences=list(c("6", "7", "EOCT")),
     sgp.projection.sequence="ALGEBRA_I_GRADE_EOCT"))

GEOMETRY_2020_2021.2.config <- list(
   GEOMETRY.2021 = list(
     sgp.content.areas = c(rep("MATHEMATICS", 2), "GEOMETRY"),
     sgp.baseline.content.areas = c(rep("MATHEMATICS", 2), "GEOMETRY"),
     sgp.baseline.panel.years = c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
     sgp.panel.years = c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
     sgp.grade.sequences=list(c("7", "8", "EOCT")),
     sgp.baseline.grade.sequences=list(c("7", "8", "EOCT")),
     sgp.projection.sequence="GEOMETRY_GRADE_EOCT"))

ALGEBRA_II_2020_2021.2.config <- list(
   ALGEBRA_II.2021 = list(
     sgp.content.areas = c("MATHEMATICS", "ALGEBRA_I", "ALGEBRA_II"),
     sgp.baseline.content.areas = c("MATHEMATICS", "ALGEBRA_I", "ALGEBRA_II"),
     sgp.baseline.panel.years = c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
     sgp.panel.years = c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
     sgp.grade.sequences=list(c("8", "EOCT", "EOCT")),
     sgp.baseline.grade.sequences=list(c("8", "EOCT", "EOCT")),
     sgp.projection.sequence="ALGEBRA_II_GRADE_EOCT"))
