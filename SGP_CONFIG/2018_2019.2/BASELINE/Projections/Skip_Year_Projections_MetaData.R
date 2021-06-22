################################################################################
###                                                                          ###
###       SGPstateData grade specific (skip-year) projection sequences       ###
###                                                                          ###
################################################################################

###  Only want 1 year projections for 2021 "Fair Trend" metric
SGPstateData[["PARCC"]][["SGP_Configuration"]][['sgp.projections.max.forward.progression.years']] <-
SGPstateData[["IL"]][["SGP_Configuration"]][['sgp.projections.max.forward.progression.years']] <-
SGPstateData[["DD"]][["SGP_Configuration"]][['sgp.projections.max.forward.progression.years']] <-
SGPstateData[["BI"]][["SGP_Configuration"]][['sgp.projections.max.forward.progression.years']] <- 1

SGPstateData[["PARCC"]][['SGP_Configuration']][['max.sgp.target.years.forward']] <-
SGPstateData[["IL"]][['SGP_Configuration']][['max.sgp.target.years.forward']] <-
SGPstateData[["DD"]][['SGP_Configuration']][['max.sgp.target.years.forward']] <-
SGPstateData[["BI"]][['SGP_Configuration']][['max.sgp.target.years.forward']] <- 1

###   Set Skip_Year_Projections to TRUE (non-NULL) to allow for skip year
SGPstateData[["PARCC"]][["SGP_Configuration"]][["Skip_Year_Projections"]] <-
SGPstateData[["IL"]][["SGP_Configuration"]][["Skip_Year_Projections"]] <-
SGPstateData[["DD"]][["SGP_Configuration"]][["Skip_Year_Projections"]] <-
SGPstateData[["BI"]][["SGP_Configuration"]][["Skip_Year_Projections"]] <- TRUE

###   Establish required meta-data for STRAIGHT projection sequences
SGPstateData[["PARCC"]][["SGP_Configuration"]][["grade.projection.sequence"]] <-
SGPstateData[["IL"]][["SGP_Configuration"]][["grade.projection.sequence"]] <-
SGPstateData[["DD"]][["SGP_Configuration"]][["grade.projection.sequence"]] <-
SGPstateData[["BI"]][["SGP_Configuration"]][["grade.projection.sequence"]] <- list(
    ELA_GRADE_3 = c(3, 5),
    ELA_GRADE_4 = c(3, 4, 6),
    ELA_GRADE_5 = c(3, 4, 5, 7),
    ELA_GRADE_6 = c(3, 4, 5, 6, 8),
    ELA_GRADE_7 = c(3, 4, 5, 6, 7, 9),
    ELA_GRADE_8 = c(3, 4, 5, 6, 7, 8, 10),
    ELA_GRADE_9 = c(3, 4, 5, 6, 7, 8, 9, 11),
    MATHEMATICS_GRADE_3 = c(3, 5),
    MATHEMATICS_GRADE_4 = c(3, 4, 6),
    MATHEMATICS_GRADE_5 = c(3, 4, 5, 7),
    MATHEMATICS_GRADE_6 = c(3, 4, 5, 6, 8),
    MATHEMATICS_GRADE_7 = c(3, 4, 5, 6, 7, "EOCT"),
    MATHEMATICS_GRADE_8 = c(3, 4, 5, 6, 7, 8, "EOCT"),
    ALGEBRA_I_GRADE_EOCT =c(3, 4, 5, 6, 7, 8, "EOCT", "EOCT"))

SGPstateData[["PARCC"]][["SGP_Configuration"]][["content_area.projection.sequence"]] <-
SGPstateData[["IL"]][["SGP_Configuration"]][["content_area.projection.sequence"]] <-
SGPstateData[["DD"]][["SGP_Configuration"]][["content_area.projection.sequence"]] <-
SGPstateData[["BI"]][["SGP_Configuration"]][["content_area.projection.sequence"]] <- list(
    ELA_GRADE_3 = rep("ELA", 2),
    ELA_GRADE_4 = rep("ELA", 3),
    ELA_GRADE_5 = rep("ELA", 4),
    ELA_GRADE_6 = rep("ELA", 5),
    ELA_GRADE_7 = rep("ELA", 6),
    ELA_GRADE_8 = rep("ELA", 7),
    ELA_GRADE_9 = rep("ELA", 8),
    MATHEMATICS_GRADE_3 = rep("MATHEMATICS", 2),
    MATHEMATICS_GRADE_4 = rep("MATHEMATICS", 3),
    MATHEMATICS_GRADE_5 = rep("MATHEMATICS", 4),
    MATHEMATICS_GRADE_6 = rep("MATHEMATICS", 5),
    MATHEMATICS_GRADE_7 = c(rep("MATHEMATICS", 5), "ALGEBRA_I"),
    MATHEMATICS_GRADE_8 = c(rep("MATHEMATICS", 6), "GEOMETRY"),
    ALGEBRA_I_GRADE_EOCT =c(rep("MATHEMATICS", 6), "ALGEBRA_I", "ALGEBRA_II"))

SGPstateData[["PARCC"]][["SGP_Configuration"]][["max.forward.projection.sequence"]] <-
SGPstateData[["IL"]][["SGP_Configuration"]][["max.forward.projection.sequence"]] <-
SGPstateData[["DD"]][["SGP_Configuration"]][["max.forward.projection.sequence"]] <-
SGPstateData[["BI"]][["SGP_Configuration"]][["max.forward.projection.sequence"]] <- list(
    ELA_GRADE_3 = 1,
    ELA_GRADE_4 = 1,
    ELA_GRADE_5 = 1,
    ELA_GRADE_6 = 1,
    ELA_GRADE_7 = 1,
    ELA_GRADE_8 = 1,
    ELA_GRADE_9 = 1,
    MATHEMATICS_GRADE_3 = 1,
    MATHEMATICS_GRADE_4 = 1,
    MATHEMATICS_GRADE_5 = 1,
    MATHEMATICS_GRADE_6 = 1,
    MATHEMATICS_GRADE_7 = 1,
    MATHEMATICS_GRADE_8 = 1,
    ALGEBRA_I_GRADE_EOCT = 1)
