################################################################################################
###                                                                                          ###
###   SGP Configurations for Spring 2019 Grade Level and EOCT Math subjects - Theta SCORES   ###
###                                                                                          ###
################################################################################################

PARCC.Math.Subjects <- c("GEOMETRY", "ALGEBRA_I", "ALGEBRA_II", "INTEGRATED_MATH_1", "INTEGRATED_MATH_2", "INTEGRATED_MATH_3")

MATHEMATICS.2018_2019.2.config <- list(
	MATHEMATICS.2018_2019.2 = list(
		sgp.content.areas=rep("MATHEMATICS", 3),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("3", "4"), c("3", "4", "5"), c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8")),
		# sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 5)),
		sgp.norm.group.preference=1L)
)


ALGEBRA_I.2018_2019.2.config <- list(
	### CANONICAL - Put first over Fall to Spring for projections/targets (Match Thetas analyses)
	ALGEBRA_I.2018_2019.2 = list(
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "ALGEBRA_I"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("7", "8", "EOCT")),
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=rep(PARCC.Math.Subjects, each=2),
		#   YEAR=c("2016_2017.1", "2018_2019.1"), GRADE="EOCT"),
		# sgp.projection.grade.sequences=list("NO_PROJECTIONS"), # 9th grade - CANONICAL
		sgp.norm.group.preference=0L),
	ALGEBRA_I.2018_2019.2 = list(
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "ALGEBRA_I"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("5", "6", "EOCT"), c("6", "7", "EOCT")), # 7th & 8th grades
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 2)),
		sgp.norm.group.preference=1L),
	ALGEBRA_I.2018_2019.2 = list(
		sgp.content.areas=c("GEOMETRY", "ALGEBRA_I"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=2L),

	ALGEBRA_I.2018_2019.2 = list( # Fall - Spring  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("GEOMETRY", "ALGEBRA_I"),
		sgp.panel.years=c("2018_2019.1", "2018_2019.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=3L),

	ALGEBRA_I.2018_2019.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_1", "ALGEBRA_I"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=4L),

	ALGEBRA_I.2018_2019.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_2", "ALGEBRA_I"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=5L),

	ALGEBRA_I.2018_2019.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_3", "ALGEBRA_I"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=6L)
)


GEOMETRY.2018_2019.2.config <- list(
	### CANONICAL - Put first over Fall to Spring for projections/targets (Match Thetas analyses)
	GEOMETRY.2018_2019.2 = list(
		sgp.content.areas=c("MATHEMATICS", "ALGEBRA_I", "GEOMETRY"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("8", "EOCT", "EOCT")),
		# sgp.projection.grade.sequences=list("NO_PROJECTIONS"), # 10th grade - CANONICAL
		sgp.norm.group.preference=0L),

	GEOMETRY.2018_2019.2 = list(
		sgp.content.areas=c("MATHEMATICS", "ALGEBRA_I", "GEOMETRY"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("6", "EOCT", "EOCT"), c("7", "EOCT", "EOCT")),  # Singular design matrix for 6th graders in test runs
		sgp.exact.grade.progression=as.list(rep(TRUE, 2)), #  YES exact to avoid multiple "ALGEBRA_I", "GEOMETRY" matrices
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 2)),
		sgp.norm.group.preference=1L),

	GEOMETRY.2018_2019.2 = list( # Fall - Spring  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("ALGEBRA_I", "GEOMETRY"),
		sgp.panel.years=c("2018_2019.1", "2018_2019.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=3L),

	GEOMETRY.2018_2019.2 = list( # Fall - Spring  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("ALGEBRA_II", "GEOMETRY"),
		sgp.panel.years=c("2018_2019.1", "2018_2019.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=4L),

	GEOMETRY.2018_2019.2 = list(
		sgp.content.areas=c("ALGEBRA_I", "ALGEBRA_II", "GEOMETRY"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=5L),

	GEOMETRY.2018_2019.2 = list(
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "GEOMETRY"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("4", "5", "EOCT"), c("5", "6", "EOCT"), c("6", "7", "EOCT"), c("7", "8", "EOCT")),
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 4)),
		sgp.norm.group.preference=6L), # 8th & 9th grades

	GEOMETRY.2018_2019.2 = list(  #  Skip year progression for Washington DC
		sgp.content.areas=c("ALGEBRA_I", "GEOMETRY"),
		sgp.panel.years=c("2016_2017.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exact.grade.progression=TRUE,
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 3)),
		sgp.norm.group.preference=7L), # 10th grade - ignore 9th Grade (Alg 1 in 8th grade)

	GEOMETRY.2018_2019.2 = list(  #  Skip year progression for Washington DC
		sgp.content.areas=c("MATHEMATICS", "GEOMETRY"),
		sgp.panel.years=c("2016_2017.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("8", "EOCT")),
		sgp.exact.grade.progression=TRUE,
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 3)),
		sgp.norm.group.preference=8L), # 10th grade - ignore 9th Grade

	GEOMETRY.2018_2019.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_1", "GEOMETRY"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=9L),

	GEOMETRY.2018_2019.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_2", "GEOMETRY"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=10L),

	GEOMETRY.2018_2019.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_3", "GEOMETRY"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=11L)
)


ALGEBRA_II.2018_2019.2.config <- list(
	### CANONICAL - Put first over Fall to Spring for projections/targets (Match Thetas analyses)
	ALGEBRA_II.2018_2019.2 = list(
		sgp.content.areas=c("ALGEBRA_I", "GEOMETRY", "ALGEBRA_II"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT", "EOCT")),
		# sgp.projection.grade.sequences=list("NO_PROJECTIONS"), # CANONICAL
		sgp.norm.group.preference=0L),

	ALGEBRA_II.2018_2019.2 = list( # Fall - Spring
		sgp.content.areas=c("GEOMETRY", "ALGEBRA_II"),
		sgp.panel.years=c("2018_2019.1", "2018_2019.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=1L),

	ALGEBRA_II.2018_2019.2 = list( # Fall - Spring  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("ALGEBRA_I", "ALGEBRA_II"),
		sgp.panel.years=c("2018_2019.1", "2018_2019.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=2L),

	ALGEBRA_II.2018_2019.2 = list(
		sgp.content.areas=c("MATHEMATICS", "ALGEBRA_I", "ALGEBRA_II"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("7", "EOCT", "EOCT"), c("8", "EOCT", "EOCT")),
		sgp.exact.grade.progression=as.list(rep(TRUE, 2)), #  Need exact to avoid multiple "ALGEBRA_I", "ALGEBRA_II" matrices
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 2)),
		sgp.norm.group.preference=3L),

	ALGEBRA_II.2018_2019.2 = list(
		sgp.content.areas=c("ALGEBRA_I", "ALGEBRA_II"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exact.grade.progression=TRUE, #  Need exact to avoid multiple "ALGEBRA_I", "ALGEBRA_II" matrices
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=4L),

	ALGEBRA_II.2018_2019.2 = list( #  --  <1000 :: Include for SGP_NOTE (except 9th grade)
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "ALGEBRA_II"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("5", "6", "EOCT"), c("6", "7", "EOCT"), c("7", "8", "EOCT")),
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 3)),
		sgp.norm.group.preference=5L), # 8th & 9th grades

	ALGEBRA_II.2018_2019.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_1", "ALGEBRA_II"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=6L),

	ALGEBRA_II.2018_2019.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_2", "ALGEBRA_II"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=7L),

	ALGEBRA_II.2018_2019.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_3", "ALGEBRA_II"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=8L)
)


INTEGRATED_MATH_1.2018_2019.2.config <- list(
	INTEGRATED_MATH_1.2018_2019.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "INTEGRATED_MATH_1"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("7", "8", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"), # 9th grade - CANONICAL - No INTEGRATED_MATH_* SGPs in Spring 2019
		sgp.norm.group.preference=0L),

	INTEGRATED_MATH_1.2018_2019.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "INTEGRATED_MATH_1"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("5", "6", "EOCT"), c("6", "7", "EOCT")),
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 2)),
		sgp.norm.group.preference=1L), # 7th & 8th grades

	INTEGRATED_MATH_1.2018_2019.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("ALGEBRA_I", "INTEGRATED_MATH_1"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=2L),

	INTEGRATED_MATH_1.2018_2019.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("GEOMETRY", "INTEGRATED_MATH_1"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=3L)
)


INTEGRATED_MATH_2.2018_2019.2.config <- list(
	### CANONICAL - Put first over Fall to Spring for projections/targets (Match Thetas analyses)
	INTEGRATED_MATH_2.2018_2019.2 = list(
		sgp.content.areas=c("INTEGRATED_MATH_1", "INTEGRATED_MATH_2"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"), # CANONICAL - No INTEGRATED_MATH_* SGPs in Spring 2019
		sgp.norm.group.preference=0L),

	INTEGRATED_MATH_2.2018_2019.2 = list( # Fall - Spring  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("ALGEBRA_II", "INTEGRATED_MATH_2"),
		sgp.panel.years=c("2018_2019.1", "2018_2019.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=1L),

	INTEGRATED_MATH_2.2018_2019.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("ALGEBRA_I", "INTEGRATED_MATH_2"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=2L),

	INTEGRATED_MATH_2.2018_2019.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("GEOMETRY", "INTEGRATED_MATH_2"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=3L),

	INTEGRATED_MATH_2.2018_2019.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("ALGEBRA_II", "INTEGRATED_MATH_2"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=4L),

	INTEGRATED_MATH_2.2018_2019.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("MATHEMATICS", "INTEGRATED_MATH_2"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("7", "EOCT"), c("8", "EOCT")), # 8th & 9th grades,
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 2)),
		sgp.norm.group.preference=5L)
)


INTEGRATED_MATH_3.2018_2019.2.config <- list(
	### CANONICAL - Put first over Fall to Spring for projections/targets (Match Thetas analyses)
	INTEGRATED_MATH_3.2018_2019.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_2", "INTEGRATED_MATH_3"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"), # CANONICAL - No INTEGRATED_MATH_* SGPs in Spring 2019
		sgp.norm.group.preference=0L),

	INTEGRATED_MATH_3.2018_2019.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_1", "INTEGRATED_MATH_3"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=1L),

	INTEGRATED_MATH_3.2018_2019.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("ALGEBRA_I", "INTEGRATED_MATH_3"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=2L),

	INTEGRATED_MATH_3.2018_2019.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("GEOMETRY", "INTEGRATED_MATH_3"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=3L),

	INTEGRATED_MATH_3.2018_2019.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("ALGEBRA_II", "INTEGRATED_MATH_3"),
		sgp.panel.years=c("2017_2018.2", "2018_2019.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=4L)
)
