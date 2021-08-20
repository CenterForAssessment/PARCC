################################################################################
###                                                                          ###
###    Configurations for STRAIGHT (skip-year) MATH projections in 2021      ###
###                                                                          ###
################################################################################

MATHEMATICS_2020_2021.2.config <- list(
    MATHEMATICS.2021 = list(
      sgp.content.areas=c("MATHEMATICS", "MATHEMATICS"),
      sgp.baseline.content.areas=c("MATHEMATICS", "MATHEMATICS"),
      sgp.panel.years=c("2018_2019.2", "2020_2021.2"),
      sgp.baseline.panel.years=c("2018_2019.2", "2020_2021.2"),
      sgp.grade.sequences=list(c("3", "5")),
      sgp.baseline.grade.sequences=list(c("3", "5")),
      sgp.projection.baseline.content.areas = c("MATHEMATICS"),
      sgp.projection.baseline.panel.years = c("2020_2021.2"),
      sgp.projection.baseline.grade.sequences=list(c("3")),
      sgp.projection.sequence="MATHEMATICS_GRADE_3"),
    MATHEMATICS.2021 = list(
      sgp.content.areas=rep("MATHEMATICS", 3),
      sgp.baseline.content.areas=rep("MATHEMATICS", 3),
      sgp.panel.years=c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
      sgp.baseline.panel.years=c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
      sgp.grade.sequences=list(c("3", "4", "6")),
      sgp.baseline.grade.sequences=list(c("3", "4", "6")),
      sgp.projection.baseline.content.areas = c("MATHEMATICS"),
      sgp.projection.baseline.panel.years = c("2020_2021.2"),
      sgp.projection.baseline.grade.sequences=list(c("4")),
      sgp.projection.sequence="MATHEMATICS_GRADE_4"),
    MATHEMATICS.2021 = list(
      sgp.content.areas=rep("MATHEMATICS", 3),
      sgp.baseline.content.areas=rep("MATHEMATICS", 3),
      sgp.panel.years=c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
      sgp.baseline.panel.years=c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
      sgp.grade.sequences=list(c("4", "5", "7")),
      sgp.baseline.grade.sequences=list(c("4", "5", "7")),
      sgp.projection.baseline.content.areas = c("MATHEMATICS"),
      sgp.projection.baseline.panel.years = c("2020_2021.2"),
      sgp.projection.baseline.grade.sequences=list(c("5")),
      sgp.projection.sequence="MATHEMATICS_GRADE_5"),
    MATHEMATICS.2021 = list(
      sgp.content.areas=rep("MATHEMATICS", 3),
      sgp.baseline.content.areas=rep("MATHEMATICS", 3),
      sgp.panel.years=c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
      sgp.baseline.panel.years=c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
      sgp.grade.sequences=list(c("5", "6", "8")),
      sgp.baseline.grade.sequences=list(c("5", "6", "8")),
      sgp.projection.baseline.content.areas = c("MATHEMATICS"),
      sgp.projection.baseline.panel.years = c("2020_2021.2"),
      sgp.projection.baseline.grade.sequences=list(c("6")),
      sgp.projection.sequence="MATHEMATICS_GRADE_6"),
    MATHEMATICS.2021 = list(
      sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "ALGEBRA_I"),
      sgp.baseline.content.areas=c("MATHEMATICS", "MATHEMATICS", "ALGEBRA_I"),
      sgp.panel.years=c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
      sgp.baseline.panel.years=c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
      sgp.grade.sequences=list(c("6", "7", "EOCT")),
      sgp.baseline.grade.sequences=list(c("6", "7", "EOCT")),
      sgp.projection.baseline.content.areas = c("MATHEMATICS"),
      sgp.projection.baseline.panel.years = c("2020_2021.2"),
      sgp.projection.baseline.grade.sequences=list(c("7")),
      sgp.projection.sequence="MATHEMATICS_GRADE_7"),

    MATHEMATICS.2021 = list(
      sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "GEOMETRY"),
      sgp.baseline.content.areas=c("MATHEMATICS", "MATHEMATICS", "GEOMETRY"),
      sgp.panel.years=c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
      sgp.baseline.panel.years=c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
      sgp.grade.sequences=list(c("7", "8", "EOCT")),
      sgp.baseline.grade.sequences=list(c("7", "8", "EOCT")),
      sgp.projection.baseline.content.areas = c("MATHEMATICS"),
      sgp.projection.baseline.panel.years = c("2020_2021.2"),
      sgp.projection.baseline.grade.sequences=list(c("8")),
      sgp.projection.sequence="MATHEMATICS_GRADE_8")
)

ALGEBRA_I_2020_2021.2.config <- list(
  ALGEBRA_I.2021 = list(
       sgp.content.areas=c("MATHEMATICS", "ALGEBRA_I", "ALGEBRA_II"),
       sgp.baseline.content.areas=c("MATHEMATICS", "ALGEBRA_I", "ALGEBRA_II"),
       sgp.panel.years=c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
       sgp.baseline.panel.years=c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
       sgp.grade.sequences=list(c("8", "EOCT", "EOCT")),
       sgp.baseline.grade.sequences=list(c("8", "EOCT", "EOCT")),
       sgp.projection.baseline.content.areas = c("ALGEBRA_I"),
       sgp.projection.baseline.panel.years = c("2020_2021.2"),
       sgp.projection.baseline.grade.sequences=list(c("EOCT")),
       sgp.projection.sequence="ALGEBRA_I_GRADE_EOCT")
)

GEOMETRY_2020_2021.2.config <- list(
  GEOMETRY.2021 = list(
       sgp.content.areas=c("ALGEBRA_I", "GEOMETRY", "ALGEBRA_II"),
       sgp.baseline.content.areas=c("ALGEBRA_I", "GEOMETRY", "ALGEBRA_II"),
       sgp.panel.years=c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
       sgp.baseline.panel.years=c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
       sgp.grade.sequences=list(c("EOCT", "EOCT", "EOCT")),
       sgp.baseline.grade.sequences=list(c("EOCT", "EOCT", "EOCT")),
       sgp.projection.baseline.content.areas = c("GEOMETRY"),
       sgp.projection.baseline.panel.years = c("2020_2021.2"),
       sgp.projection.baseline.grade.sequences=list(c("EOCT")),
       sgp.projection.sequence="GEOMETRY_GRADE_EOCT")
)
