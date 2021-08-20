################################################################################
###                                                                          ###
###     Configurations for STRAIGHT (skip-year) ELA projections in 2021      ###
###                                                                          ###
################################################################################

ELA_2020_2021.2.config <- list(
    ELA.2021 = list(
      sgp.content.areas=c("ELA", "ELA"),
      sgp.baseline.content.areas=c("ELA", "ELA"),
      sgp.panel.years=c("2018_2019.2", "2020_2021.2"),
      sgp.baseline.panel.years=c("2018_2019.2", "2020_2021.2"),
      sgp.grade.sequences=list(c("3", "5")),
      sgp.baseline.grade.sequences=list(c("3", "5")),
      sgp.projection.baseline.content.areas = c("ELA"),
      sgp.projection.baseline.panel.years = c("2020_2021.2"),
      sgp.projection.baseline.grade.sequences=list(c("3")),
      sgp.projection.sequence="ELA_GRADE_3"),
    ELA.2021 = list(
      sgp.content.areas=rep("ELA", 3),
      sgp.baseline.content.areas=rep("ELA", 3),
      sgp.panel.years=c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
      sgp.baseline.panel.years=c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
      sgp.grade.sequences=list(c("3", "4", "6")),
      sgp.baseline.grade.sequences=list(c("3", "4", "6")),
      sgp.projection.baseline.content.areas = c("ELA"),
      sgp.projection.baseline.panel.years = c("2020_2021.2"),
      sgp.projection.baseline.grade.sequences=list(c("4")),
      sgp.projection.sequence="ELA_GRADE_4"),
    ELA.2021 = list(
      sgp.content.areas=rep("ELA", 3),
      sgp.baseline.content.areas=rep("ELA", 3),
      sgp.panel.years=c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
      sgp.baseline.panel.years=c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
      sgp.grade.sequences=list(c("4", "5", "7")),
      sgp.baseline.grade.sequences=list(c("4", "5", "7")),
      sgp.projection.baseline.content.areas = c("ELA"),
      sgp.projection.baseline.panel.years = c("2020_2021.2"),
      sgp.projection.baseline.grade.sequences=list(c("5")),
      sgp.projection.sequence="ELA_GRADE_5"),
    ELA.2021 = list(
      sgp.content.areas=rep("ELA", 3),
      sgp.baseline.content.areas=rep("ELA", 3),
      sgp.panel.years=c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
      sgp.baseline.panel.years=c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
      sgp.grade.sequences=list(c("5", "6", "8")),
      sgp.baseline.grade.sequences=list(c("5", "6", "8")),
      sgp.projection.baseline.content.areas = c("ELA"),
      sgp.projection.baseline.panel.years = c("2020_2021.2"),
      sgp.projection.baseline.grade.sequences=list(c("6")),
      sgp.projection.sequence="ELA_GRADE_6"),
    ELA.2021 = list(
      sgp.content.areas=rep("ELA", 3),
      sgp.baseline.content.areas=rep("ELA", 3),
      sgp.panel.years=c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
      sgp.baseline.panel.years=c("2017_2018.2", "2018_2019.2", "2020_2021.2"),
      sgp.grade.sequences=list(c("5", "6", "8")),
      sgp.baseline.grade.sequences=list(c("5", "6", "8")),
      sgp.projection.baseline.content.areas = c("ELA"),
      sgp.projection.baseline.panel.years = c("2020_2021.2"),
      sgp.projection.baseline.grade.sequences=list(c("7")),
      sgp.projection.sequence="ELA_GRADE_7")
)
