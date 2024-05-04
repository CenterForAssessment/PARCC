###############################################################################
###                                                                         ###
###     Configs for New Jersey Spring 2022 Grade Level ELA Cohort SGPs      ###
###                                                                         ###
###############################################################################

ELA_2021_2022.2.config <- list(
    ELA.2021_2022.2 = list(
        sgp.content.areas = c("ELA_NJSS", "ELA"),
        sgp.panel.years = c("2021_2022.1", "2021_2022.2"),
        sgp.grade.sequences = list(
            c("4", "4"), c("5", "5"),
            c("6", "6"), c("7", "7"), c("8", "8"),
            c("9", "9"), c("10", "10")
        ),
        sgp.norm.group.preference = 0L
    )
)

ELA_GPA_2021_2022.2.config <- list(
    ELA_GPA.2021_2022.2 = list(
        sgp.content.areas = c("ELA", "ELA", "ELA_GPA"),
        sgp.panel.years = c("2017_2018.2", "2018_2019.2", "2021_2022.2"),
        sgp.grade.sequences = list(c("7", "8", "EOCT")),
        sgp.norm.group.preference = 0L
    ),
    ELA_GPA.2021_2022.2 = list(
        sgp.content.areas = c("ELA_NJSS", "ELA_GPA"),
        sgp.panel.years = c("2021_2022.1", "2021_2022.2"),
        sgp.grade.sequences = list(c("10", "EOCT")),
        sgp.norm.group.preference = 1L
    )
)

##  Find viable configs
# ids <- New_Jersey_Data_LONG_2021_2022.2[CONTENT_AREA=='ELA_GPA', ID]
# ids <- CONTENT_AREA=='ELA_GPA', ID]
# tst <- NJSS_Data_LONG_2021_2022.1[ID %in% ids]
# tst <- New_Jersey_SGP@Data[YEAR == '2018_2019.2' & ID %in% ids]
# table(tst$TestCode)
