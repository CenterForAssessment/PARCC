################################################################################
###                                                                          ###
###  SGPstateData grade specific skip-year (STRAIGHT) projection sequences   ###
###                                                                          ###
################################################################################

###   Establish required meta-data for STRAIGHT projection sequences

SGPstateData[["PARCC"]][["SGP_Configuration"]][["sgp.target.scale.scores.merge"]] <-
SGPstateData[["IL"]][["SGP_Configuration"]][["sgp.target.scale.scores.merge"]] <-
SGPstateData[["DD"]][["SGP_Configuration"]][["sgp.target.scale.scores.merge"]] <-
SGPstateData[["BI"]][["SGP_Configuration"]][["sgp.target.scale.scores.merge"]] <- NULL

SGPstateData[["PARCC"]][["SGP_Configuration"]][["grade.projection.sequence"]] <-
SGPstateData[["IL"]][["SGP_Configuration"]][["grade.projection.sequence"]] <-
SGPstateData[["DD"]][["SGP_Configuration"]][["grade.projection.sequence"]] <-
SGPstateData[["BI"]][["SGP_Configuration"]][["grade.projection.sequence"]] <- list(
      ELA_GRADE_3 = c(3, 4, 5, 6, 7, 8, 9, 10, 11),
      ELA_GRADE_4 = c(3, 4, 5, 6, 7, 8, 9, 10, 11),
      ELA_GRADE_5 = c(3, 4, 5, 6, 7, 8, 9, 10, 11),
      ELA_GRADE_6 = c(3, 4, 5, 6, 7, 8, 9, 10, 11),
      ELA_GRADE_7 = c(3, 4, 5, 6, 7, 8, 9, 10, 11),
      ELA_GRADE_8 = c(3, 4, 5, 6, 7, 8, 9, 10, 11),
      ELA_GRADE_9 = c(3, 4, 5, 6, 7, 8, 9, 10, 11),
      ELA_GRADE_10= c(3, 4, 5, 6, 7, 8, 9, 10, 11),
      MATHEMATICS_GRADE_3 = c(3, 4, 5, 6, 7, 8, "EOCT", "EOCT", "EOCT"),
      MATHEMATICS_GRADE_4 = c(3, 4, 5, 6, 7, 8, "EOCT", "EOCT", "EOCT"),
      MATHEMATICS_GRADE_5 = c(3, 4, 5, 6, 7, 8, "EOCT", "EOCT", "EOCT"),
      MATHEMATICS_GRADE_6 = c(3, 4, 5, 6, 7, 8, "EOCT", "EOCT", "EOCT"),
      MATHEMATICS_GRADE_7 = c(3, 4, 5, 6, 7, 8, "EOCT", "EOCT", "EOCT"),
      MATHEMATICS_GRADE_8 = c(3, 4, 5, 6, 7, 8, "EOCT", "EOCT", "EOCT"),
      ALGEBRA_I_GRADE_EOCT= c(3, 4, 5, 6, 7, 8, "EOCT", "EOCT", "EOCT"),
      GEOMETRY_GRADE_EOCT = c(3, 4, 5, 6, 7, 8, "EOCT", "EOCT", "EOCT"))

SGPstateData[["PARCC"]][["SGP_Configuration"]][["content_area.projection.sequence"]] <-
SGPstateData[["IL"]][["SGP_Configuration"]][["content_area.projection.sequence"]] <-
SGPstateData[["DD"]][["SGP_Configuration"]][["content_area.projection.sequence"]] <-
SGPstateData[["BI"]][["SGP_Configuration"]][["content_area.projection.sequence"]] <- list(
      ELA_GRADE_3 = rep("ELA", 9),
      ELA_GRADE_4 = rep("ELA", 9),
      ELA_GRADE_5 = rep("ELA", 9),
      ELA_GRADE_6 = rep("ELA", 9),
      ELA_GRADE_7 = rep("ELA", 9),
      ELA_GRADE_8 = rep("ELA", 9),
      ELA_GRADE_9 = rep("ELA", 9),
      ELA_GRADE_10= rep("ELA", 9),
      MATHEMATICS_GRADE_3 = c(rep("MATHEMATICS", 6), "ALGEBRA_I", "GEOMETRY", "ALGEBRA_II"),
      MATHEMATICS_GRADE_4 = c(rep("MATHEMATICS", 6), "ALGEBRA_I", "GEOMETRY", "ALGEBRA_II"),
      MATHEMATICS_GRADE_5 = c(rep("MATHEMATICS", 6), "ALGEBRA_I", "GEOMETRY", "ALGEBRA_II"),
      MATHEMATICS_GRADE_6 = c(rep("MATHEMATICS", 6), "ALGEBRA_I", "GEOMETRY", "ALGEBRA_II"),
      MATHEMATICS_GRADE_7 = c(rep("MATHEMATICS", 6), "ALGEBRA_I", "GEOMETRY", "ALGEBRA_II"),
      MATHEMATICS_GRADE_8 = c(rep("MATHEMATICS", 6), "ALGEBRA_I", "GEOMETRY", "ALGEBRA_II"),
      ALGEBRA_I_GRADE_EOCT= c(rep("MATHEMATICS", 6), "ALGEBRA_I", "GEOMETRY", "ALGEBRA_II"),
      GEOMETRY_GRADE_EOCT = c(rep("MATHEMATICS", 6), "ALGEBRA_I", "GEOMETRY", "ALGEBRA_II"))

SGPstateData[["PARCC"]][["SGP_Configuration"]][["max.forward.projection.sequence"]] <-
SGPstateData[["IL"]][["SGP_Configuration"]][["max.forward.projection.sequence"]] <-
SGPstateData[["DD"]][["SGP_Configuration"]][["max.forward.projection.sequence"]] <-
SGPstateData[["BI"]][["SGP_Configuration"]][["max.forward.projection.sequence"]] <- list(
      ELA_GRADE_3 = 3,
      ELA_GRADE_4 = 3,
      ELA_GRADE_5 = 3,
      ELA_GRADE_6 = 3,
      ELA_GRADE_7 = 3,
      ELA_GRADE_8 = 3,
      ELA_GRADE_9 = 3,
      ELA_GRADE_10= 3,
      MATHEMATICS_GRADE_3 = 3,
      MATHEMATICS_GRADE_4 = 3,
      MATHEMATICS_GRADE_5 = 3,
      MATHEMATICS_GRADE_6 = 3,
      MATHEMATICS_GRADE_7 = 3,
      MATHEMATICS_GRADE_8 = 3,
      ALGEBRA_I_GRADE_EOCT= 3,
      GEOMETRY_GRADE_EOCT = 3)
