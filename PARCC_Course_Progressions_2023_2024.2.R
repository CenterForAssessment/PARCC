################################################################################
###                                                                          ###
###               Identify Spring 2024 Progressions for PARCC                ###
###                                                                          ###
################################################################################

require(data.table)
require(SGP)

###   Load results data from 2023
load("./Data/Archive/2021_2022.2/PARCC_SGP_LONG_Data_2021_2022.2.Rdata")
load("./Data/Archive/2022_2023.2/PARCC_SGP_LONG_Data_2022_2023.2.Rdata")

###   Load cleaned 2024 LONG data
load("../Illinois/Data/Archive/2023_2024.2/Illinois_Data_LONG_2023_2024.2.Rdata")
load("../New_Jersey/Data/Archive/2023_2024.2/New_Jersey_Data_LONG_2023_2024.2.Rdata")
load("../Department_Of_Defense/Data/Archive/2023_2024.2/Department_of_Defense_Data_LONG_2023_2024.2.Rdata")
load("../Bureau_of_Indian_Education/Data/Archive/2023_2024.2/Bureau_of_Indian_Education_Data_LONG_2023_2024.2.Rdata")
load("../Washington_DC/Data/Archive/2021_2022.2/Washington_DC_Data_LONG_2021_2022.2.Rdata")
load("../Washington_DC/Data/Archive/2023_2024.2/Washington_DC_Data_LONG_2023_2024.2.Rdata")

##    See 2023 Growth layout -- BIE blank if not enrolled in 2022.
##    Now validate as their `StateStudentIdentifier` are non-null
PARCC_SGP_LONG_Data_2022_2023.2[, VALID_CASE := "VALID_CASE"]

##    Combine prior data and cleaned 2024 data
PARCC_Data_LONG <-
    rbindlist(
        list(
            PARCC_SGP_LONG_Data_2021_2022.2[
                !CONTENT_AREA %in% c("ELA_GPA", "MATH_GPA")
            ],
            PARCC_SGP_LONG_Data_2022_2023.2,
            Illinois_Data_LONG_2023_2024.2,
            New_Jersey_Data_LONG_2023_2024.2,
            Department_of_Defense_Data_LONG_2023_2024.2,
            Bureau_of_Indian_Education_Data_LONG_2023_2024.2,
            Washington_DC_Data_LONG_2021_2022.2,
            Washington_DC_Data_LONG_2023_2024.2
        ),
        fill = TRUE
    )

PARCC_Data_LONG[, TEMP_ID := as.character(NA)]
PARCC_Data_LONG[StateAbbreviation %in% c("BI", "DC"), TEMP_ID := ID]
PARCC_Data_LONG[StateAbbreviation %in% c("BI", "DC"), ID := StateStudentIdentifier]

###   Individual states:
# ##    Load historical growth and cleaned 2024 LONG data
# load("./Data/Archive/2021_2022.2/Bureau_of_Indian_Education_SGP_LONG_Data_2021_2022.2.Rdata")
# load("./Data/Archive/2022_2023.2/Bureau_of_Indian_Education_SGP_LONG_Data_2022_2023.2.Rdata")
# load("./Data/Archive/2023_2024.2/Bureau_of_Indian_Education_Data_LONG_2023_2024.2.Rdata")

# ##    See 2023 Growth layout -- Blank if not enrolled in 2022.
# ##    Now validate as their `StateStudentIdentifier` are non-null
# Bureau_of_Indian_Education_SGP_LONG_Data_2022_2023.2[, VALID_CASE := "VALID_CASE"]
# Bureau_of_Indian_Education_SGP_LONG_Data_2022_2023.2[, PANUniqueStudentID := NULL]

# PARCC_Data_LONG <-
#     rbindlist(
#         list(
#             Bureau_of_Indian_Education_SGP_LONG_Data_2021_2022.2,
#             Bureau_of_Indian_Education_SGP_LONG_Data_2022_2023.2,
#             Bureau_of_Indian_Education_Data_LONG_2023_2024.2
#         ),
#         fill = TRUE
#     )
# setnames(
#     PARCC_Data_LONG,
#     c("StateStudentIdentifier", "ID"), # 2024
#     c("ID", "PANUniqueStudentID")
# )

rm(list = grep("2022|2023_2024", ls(), value = TRUE)); gc()


###   Get subset of PARCC_Data_LONG with only IDs from Spring 2024
ids <- unique(PARCC_Data_LONG[YEAR=="2023_2024.2", ID])
Spring_Data_LONG <- PARCC_Data_LONG[ID %in% ids,]

table(Spring_Data_LONG[!CONTENT_AREA %in% "ELA", CONTENT_AREA, YEAR])
table(Spring_Data_LONG[CONTENT_AREA %in% "ELA", as.numeric(GRADE), YEAR])
table(Spring_Data_LONG[YEAR=="2023_2024.2", GRADE, CONTENT_AREA])

###   Run courseProgressionSGP by content area subsets of the Spring_Data_LONG

ela.prog <-
  courseProgressionSGP(
    Spring_Data_LONG[CONTENT_AREA %in% "ELA"],
    # Spring_Data_LONG[CONTENT_AREA %in% c("ELA", "ELA_NJSS")],
    lag.direction = "BACKWARD", year = "2023_2024.2"
  )
math.prog<-
  courseProgressionSGP(
    Spring_Data_LONG[!CONTENT_AREA %in% "ELA"],
        # !CONTENT_AREA %in% c("ELA", "ELA_NJSS", "ELA_GPA", "MATH_GPA")],
    lag.direction = "BACKWARD", year = "2023_2024.2"
  )


####
####     Mathematics
####

###   Find out which Math related content areas are present in the Fall data
names(math.prog$BACKWARD[["2023_2024.2"]])

###
###   Algebra I (No Repeaters or Regression)
###

ALG1 <- math.prog$BACKWARD[["2023_2024.2"]]$ALGEBRA_I.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "ALGEBRA_I.EOCT" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks
# ALG1 <- ALG1[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "ALGEBRA_I.EOCT"]
ALG1 <- ALG1[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
table(ALG1$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
ALG1[COUNT > 100]  #  Major progressions

###   Viable 1 Prior ALGEBRA_I Progressions
ALG1[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 Total
# 1:                    ALGEBRA_II.EOCT    19
# 2:                      GEOMETRY.EOCT  1259
# 3:                     MATHEMATICS.05    58
# 4:                     MATHEMATICS.06  4944
# 5:                     MATHEMATICS.07 29334
# 6:                     MATHEMATICS.08 57907
###   Establish configs for the SGP_NOTE variable


###   Viable 1 Prior ALGEBRA_I Progressions (ENFORCE THAT NO Fall 2023 TEST AVAILABLE!)
# ALG1[is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2)]

###   Also establish config with INTEGRATED_MATH_1, 2 and 3 for the SGP_NOTE variables

# Exclude Fall 2023 ALGEBRA_I, GEOMETRY and ALGEBRA_II for good measure?
table(math.prog$BACKWARD[["2023_2024.2"]]$ALGEBRA_I.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "GEOMETRY.EOCT",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1])

###   Viable 2 Prior (Spring 22 + Spring 21) ALGEBRA_I Progressions
ALG1[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][Total > 100]#, "CONTENT_AREA_by_GRADE_PRIOR_YEAR.3")]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 Total
# 1:                     ALGEBRA_I.EOCT     7
# 2:                      GEOMETRY.EOCT     1
# 3:                     MATHEMATICS.05    11
# 4:                     MATHEMATICS.06   672
# 5:                     MATHEMATICS.08    13

# ALG1[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="MATHEMATICS.08" & CONTENT_AREA_by_GRADE_PRIOR_YEAR.4=="MATHEMATICS.07"] # No Fall 22 (YEAR.1) exclusions necessary


###
###   Geometry (No Repeaters)
###

GEOM <-
  math.prog$BACKWARD[["2023_2024.2"]]$GEOMETRY.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "GEOMETRY.EOCT" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks
GEOM <- GEOM[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "GEOMETRY.EOCT"]
table(GEOM$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
GEOM[COUNT > 100]  #  Major progressions

###   Viable 1 Prior (Fall 22) GEOMETRY Progressions
GEOM[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1   Total
# 1:                     ALGEBRA_I.EOCT   32240
# 2:                    ALGEBRA_II.EOCT    1019
# 3:                     MATHEMATICS.05       3
# 4:                     MATHEMATICS.06     107
# 5:                     MATHEMATICS.07     747
# 6:                     MATHEMATICS.08     832

###  NONE - Don't exclude these either?

###   Viable 1 Prior (Spring 22) GEOMETRY Progressions (ENFORCE THAT NO Fall 22 TEST AVAILABLE?)
# GEOM[is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2)]

# table(math.prog$BACKWARD[["2023_2024.2"]]$GEOMETRY.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "ALGEBRA_I.EOCT",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1])  # Exclude  GEOMETRY, ALGEBRA_I and ALGEBRA_II
# table(math.prog$BACKWARD[["2023_2024.2"]]$GEOMETRY.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "ALGEBRA_II.EOCT",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1]) # Exclude  GEOMETRY, ALGEBRA_I and ALGEBRA_II
# table(math.prog$BACKWARD[["2023_2024.2"]]$GEOMETRY.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "MATHEMATICS.08",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1]) # Exclude  ALGEBRA_I

# math.prog$BACKWARD[["2023_2024.2"]]$GEOMETRY.EOCT[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1) & CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "ALGEBRA_II.EOCT", list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")]


###   Viable 2 Prior (Spring 22 + Spring 21) GEOMETRY Progressions
GEOM[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2),# & !is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.4),
    list(Total=sum(COUNT)),
    keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][Total > 500]#, "CONTENT_AREA_by_GRADE_PRIOR_YEAR.4")]
  #  CONTENT_AREA_by_GRADE_PRIOR_YEAR.2   Total
# 1:                     MATHEMATICS.08     985

# GEOM[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ALGEBRA_I.EOCT" & CONTENT_AREA_by_GRADE_PRIOR_YEAR.4=="MATHEMATICS.08"] # Exclude 15 cases with GEOMETRY in Fall 22 (YEAR.1)?

###
###   Algebra II (No Repeaters)
###

ALG2 <- math.prog$BACKWARD[["2023_2024.2"]]$ALGEBRA_II.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "ALGEBRA_II.EOCT" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks
ALG2 <- ALG2[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "ALGEBRA_II.EOCT"]

ALG2[COUNT > 100]  #  Major progressions

###   Viable 1 Prior (Fall 22) ALGEBRA_II Progressions
ALG2[, list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 Total
# 1:                     ALGEBRA_I.EOCT   428
# 2:                      GEOMETRY.EOCT   714

###   Viable 1 Prior (Spring 22) ALGEBRA_II Progressions (NO Fall 22 TEST AVAILABLE!)
ALG2[is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2)]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 Total
# 1:                     ALGEBRA_I.EOCT 12587
# 2:                      GEOMETRY.EOCT 82165
# 3:             INTEGRATED_MATH_1.EOCT   199		XXX
# 4:             INTEGRATED_MATH_2.EOCT    11		XXX
# 5:             INTEGRATED_MATH_3.EOCT     3		XXX
# 6:                     MATHEMATICS.07     5		XXX
# 7:                     MATHEMATICS.08  1777
###   Also establish config with INTEGRATED_MATH_1 to MATHEMATICS.08 for the SGP_NOTE variables

table(math.prog$BACKWARD[["2023_2024.2"]]$ALGEBRA_II.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "ALGEBRA_I.EOCT",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1]) # Exclude  GEOMETRY, ALGEBRA_I and ALGEBRA_II
table(math.prog$BACKWARD[["2023_2024.2"]]$ALGEBRA_II.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "GEOMETRY.EOCT",  CONTENT_AREA_by_GRADE_PRIOR_YEAR.1])  # Exclude  GEOMETRY, ALGEBRA_I and ALGEBRA_II

###   Viable 2 Prior (Spring 22 + Spring 21) ALGEBRA_II Progressions
ALG2[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2) & !is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.4), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.4")][Total > 500]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 CONTENT_AREA_by_GRADE_PRIOR_YEAR.4 Total
# 1:                     ALGEBRA_I.EOCT                     ALGEBRA_I.EOCT  1273		XXX
# 2:                     ALGEBRA_I.EOCT                     MATHEMATICS.07  3634
# 3:                     ALGEBRA_I.EOCT                     MATHEMATICS.08  5888
# 4:                      GEOMETRY.EOCT                     ALGEBRA_I.EOCT 74906
# 5:                      GEOMETRY.EOCT                      GEOMETRY.EOCT   680		XXX
# 6:                      GEOMETRY.EOCT                     MATHEMATICS.08   821		XXX
# 7:                     MATHEMATICS.08                     ALGEBRA_I.EOCT  1641		XXX ???
###   Don't establish configs for XXX  -  Only viable 2 priors

ALG2[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1) & CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="GEOMETRY.EOCT" & CONTENT_AREA_by_GRADE_PRIOR_YEAR.4=="ALGEBRA_I.EOCT"] # Exclude (194 total) cases with Fall 22 (YEAR.1) scores (Alg 1, 2 and Geometry)
ALG2[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1) & CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ALGEBRA_I.EOCT"] # Exclude cases with Fall 22 (YEAR.1) GEOMETRY scores (or Give that progression the higher priority)


####
####     ELA
####

###   Find out which grades are present in the Fall ELA data
names(ela.prog$BACKWARD[["2023_2024.2"]])

###   Spring to FallBlock  -  Establish configs for the SGP_NOTE variable
sum(ela.prog$BACKWARD[["2023_2024.2"]]$ELA.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.08"]$COUNT)   #  93024
sum(ela.prog$BACKWARD[["2023_2024.2"]]$ELA.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.09"]$COUNT)   #  8887 (repeaters)
sum(ela.prog$BACKWARD[["2023_2024.2"]]$ELA.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.09"]$COUNT)   #  4008
sum(ela.prog$BACKWARD[["2023_2024.2"]]$ELA.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.10"]$COUNT)   #  93   (repeaters)
sum(ela.prog$BACKWARD[["2023_2024.2"]]$ELA.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.10"]$COUNT)   #  0
sum(ela.prog$BACKWARD[["2023_2024.2"]]$ELA.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.11"]$COUNT)   #  0    (repeaters)


###   Spring to Spring  -  Establish configs for the SGP_NOTE variable
sum(ela.prog$BACKWARD[["2023_2024.2"]]$ELA.08[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.07"]$COUNT)   #  234624
sum(ela.prog$BACKWARD[["2023_2024.2"]]$ELA.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.08"]$COUNT)   #  93024
sum(ela.prog$BACKWARD[["2023_2024.2"]]$ELA.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.09"]$COUNT)   #  888   (repeaters)
sum(ela.prog$BACKWARD[["2023_2024.2"]]$ELA.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.08"]$COUNT)   #  1655  -  2 year skip
sum(ela.prog$BACKWARD[["2023_2024.2"]]$ELA.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.09"]$COUNT)   #  4008
sum(ela.prog$BACKWARD[["2023_2024.2"]]$ELA.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.10"]$COUNT)   #  93    (repeaters)
# sum(ela.prog$BACKWARD[["2023_2024.2"]]$ELA.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.10"]$COUNT)   #  X
# sum(ela.prog$BACKWARD[["2023_2024.2"]]$ELA.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.11"]$COUNT)   #  X (repeaters)


###   Washington DC
# sum(ela.prog$BACKWARD[["2023_2024.2"]]$ELA.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.08"]$COUNT)   #  1655  -  2 year skip


ELA <- ela.prog$BACKWARD[["2023_2024.2"]]$ELA.10
table(ELA$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
ELA[COUNT > 100]  #  Major progressions

###   PARCC consortium
# ELA[CONTENT_AREA_by_GRADE_PRIOR_YEAR.4 == "ELA.08"]
# ELA[, list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.4")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.4)]
# ELA[is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1) & is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2) & is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.3),
# 			list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.4")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.4)]

# ###   Individual States
# ELA[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 == "ELA.08"]
# ELA[, list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2)]
# ELA[is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1),
# 			list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2)]
