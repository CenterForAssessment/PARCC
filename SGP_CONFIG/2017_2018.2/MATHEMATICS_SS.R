################################################################################################
###                                                                                          ###
###   SGP Configurations for Spring 2018 Grade Level and EOCT Math subjects - SCALE SCORES   ###
###                                                                                          ###
################################################################################################

PARCC.Math.Subjects <- c("GEOMETRY_SS", "ALGEBRA_I_SS", "ALGEBRA_II_SS", "INTEGRATED_MATH_1_SS", "INTEGRATED_MATH_2_SS", "INTEGRATED_MATH_3_SS")

MATHEMATICS_SS.2017_2018.2.config <- list(
	MATHEMATICS_SS.2017_2018.2 = list(
		sgp.content.areas=rep("MATHEMATICS_SS", 3),
		sgp.panel.years=c("2015_2016.2", "2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("3", "4"), c("3", "4", "5"), c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8")),
		# sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 5)),
		sgp.norm.group.preference=1L)
)


ALGEBRA_I_SS.2017_2018.2.config <- list(
	### CANONICAL - Put first over Fall to Spring for projections/targets (Match Thetas analyses)
	ALGEBRA_I_SS.2017_2018.2 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "MATHEMATICS_SS", "ALGEBRA_I_SS"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("7", "8", "EOCT")),
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=rep(PARCC.Math.Subjects, each=2),
		#   YEAR=c("2016_2017.1", "2017_2018.1"), GRADE="EOCT"),
		# sgp.projection.grade.sequences=list("NO_PROJECTIONS"), # 9th grade - CANONICAL
		sgp.norm.group.preference=0L),
	ALGEBRA_I_SS.2017_2018.2 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "MATHEMATICS_SS", "ALGEBRA_I_SS"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("5", "6", "EOCT"), c("6", "7", "EOCT")), # 7th & 8th grades
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA="ALGEBRA_I_SS",
		# 	YEAR="2017_2018.1", GRADE="EOCT"),
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 2)),
		sgp.norm.group.preference=1L),
	ALGEBRA_I_SS.2017_2018.2 = list(
		sgp.content.areas=c("GEOMETRY_SS", "ALGEBRA_I_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA="ALGEBRA_I_SS",
		# 	YEAR="2017_2018.1", GRADE="EOCT"),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=2L),

	ALGEBRA_I_SS.2017_2018.2 = list( # Fall - Spring  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("GEOMETRY_SS", "ALGEBRA_I_SS"),
		sgp.panel.years=c("2017_2018.1", "2017_2018.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=3L),

	ALGEBRA_I_SS.2017_2018.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_1_SS", "ALGEBRA_I_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA="ALGEBRA_I_SS",
		# 	YEAR="2017_2018.1", GRADE="EOCT"),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=4L),

	ALGEBRA_I_SS.2017_2018.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_2_SS", "ALGEBRA_I_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA="ALGEBRA_I_SS",
		# 	YEAR="2017_2018.1", GRADE="EOCT"),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=5L),

	ALGEBRA_I_SS.2017_2018.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_3_SS", "ALGEBRA_I_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA="ALGEBRA_I_SS",
		# 	YEAR="2017_2018.1", GRADE="EOCT"),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=6L)
)


GEOMETRY_SS.2017_2018.2.config <- list(
	### CANONICAL - Put first over Fall to Spring for projections/targets (Match Thetas analyses)
	GEOMETRY_SS.2017_2018.2 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "ALGEBRA_I_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("8", "EOCT", "EOCT")),
		# sgp.exact.grade.progression=TRUE, #  NO exact - use to calculate "ALGEBRA_I_SS", "GEOMETRY_SS" matrices AND avoid duplicate projections (Thetas).
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2017_2018.1", GRADE="EOCT"),
		# sgp.projection.grade.sequences=list("NO_PROJECTIONS"), # 10th grade - CANONICAL
		sgp.norm.group.preference=0L),

	GEOMETRY_SS.2017_2018.2 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "ALGEBRA_I_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("6", "EOCT", "EOCT"), c("7", "EOCT", "EOCT")),  # Singular design matrix for 6th graders in test runs
		sgp.exact.grade.progression=as.list(rep(TRUE, 2)), #  YES exact to avoid multiple "ALGEBRA_I_SS", "GEOMETRY_SS" matrices
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2017_2018.1", GRADE="EOCT"),
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 2)),
		sgp.norm.group.preference=1L),

	# GEOMETRY_SS.2017_2018.2 = list( ##  NOT NEEDED if canonical progression run without exact above.
	# 	sgp.content.areas=c("ALGEBRA_I_SS", "GEOMETRY_SS"),
	# 	sgp.panel.years=c("2016_2017.2", "2017_2018.2"),
	# 	sgp.grade.sequences=list(c("EOCT", "EOCT")),
	# 	# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
	# 	# 	YEAR="2017_2018.1", GRADE="EOCT"),
	# 	sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
	# 	sgp.norm.group.preference=2L),
	#
	GEOMETRY_SS.2017_2018.2 = list( # Fall - Spring  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("ALGEBRA_I_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2017_2018.1", "2017_2018.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=3L),

	GEOMETRY_SS.2017_2018.2 = list( # Fall - Spring  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("ALGEBRA_II_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2017_2018.1", "2017_2018.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=4L),

	GEOMETRY_SS.2017_2018.2 = list(
		sgp.content.areas=c("ALGEBRA_I_SS", "ALGEBRA_II_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT", "EOCT")),
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2017_2018.1", GRADE="EOCT"),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=5L),

	GEOMETRY_SS.2017_2018.2 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "MATHEMATICS_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("5", "6", "EOCT"), c("6", "7", "EOCT"), c("7", "8", "EOCT")),
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2017_2018.1", GRADE="EOCT"),
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 3)),
		sgp.norm.group.preference=6L), # 8th & 9th grades

	GEOMETRY_SS.2017_2018.2 = list(  #  Skip year progression for Washington DC
		sgp.content.areas=c("ALGEBRA_I_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2015_2016.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exact.grade.progression=TRUE,
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 3)),
		sgp.norm.group.preference=7L), # 10th grade - ignore 9th Grade (Alg 1 in 8th grade)

	GEOMETRY_SS.2017_2018.2 = list(  #  Skip year progression for Washington DC
		sgp.content.areas=c("MATHEMATICS_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2015_2016.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("8", "EOCT")),
		sgp.exact.grade.progression=TRUE,
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 3)),
		sgp.norm.group.preference=8L), # 10th grade - ignore 9th Grade

	GEOMETRY_SS.2017_2018.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_1_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2017_2018.1", GRADE="EOCT"),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=9L),

	GEOMETRY_SS.2017_2018.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_2_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2017_2018.1", GRADE="EOCT"),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=10L),

	GEOMETRY_SS.2017_2018.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_3_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2017_2018.1", GRADE="EOCT"),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=11L)
)


ALGEBRA_II_SS.2017_2018.2.config <- list(
	### CANONICAL - Put first over Fall to Spring for projections/targets (Match Thetas analyses)
	ALGEBRA_II_SS.2017_2018.2 = list(
		sgp.content.areas=c("ALGEBRA_I_SS", "GEOMETRY_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT", "EOCT")),
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2017_2018.1", GRADE="EOCT"),
		# sgp.projection.grade.sequences=list("NO_PROJECTIONS"), # CANONICAL
		sgp.norm.group.preference=0L),

	ALGEBRA_II_SS.2017_2018.2 = list( # Fall - Spring
		sgp.content.areas=c("GEOMETRY_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2017_2018.1", "2017_2018.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=1L),

	ALGEBRA_II_SS.2017_2018.2 = list( # Fall - Spring  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("ALGEBRA_I_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2017_2018.1", "2017_2018.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=2L),

	ALGEBRA_II_SS.2017_2018.2 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "ALGEBRA_I_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("7", "EOCT", "EOCT"), c("8", "EOCT", "EOCT")),
		sgp.exact.grade.progression=as.list(rep(TRUE, 2)), #  Need exact to avoid multiple "ALGEBRA_I_SS", "ALGEBRA_II_SS" matrices
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2017_2018.1", GRADE="EOCT"),
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 2)),
		sgp.norm.group.preference=3L),

	ALGEBRA_II_SS.2017_2018.2 = list(
		sgp.content.areas=c("ALGEBRA_I_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exact.grade.progression=TRUE, #  Need exact to avoid multiple "ALGEBRA_I_SS", "ALGEBRA_II_SS" matrices
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2017_2018.1", GRADE="EOCT"),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=4L),

	ALGEBRA_II_SS.2017_2018.2 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "MATHEMATICS_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("5", "6", "EOCT"), c("6", "7", "EOCT"), c("7", "8", "EOCT")),
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2017_2018.1", GRADE="EOCT"),
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 3)),
		sgp.norm.group.preference=5L), # 8th & 9th grades

	ALGEBRA_II_SS.2017_2018.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_1_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2017_2018.1", GRADE="EOCT"),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=6L),

	ALGEBRA_II_SS.2017_2018.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_2_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2017_2018.1", GRADE="EOCT"),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=7L),

	ALGEBRA_II_SS.2017_2018.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_3_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2017_2018.1", GRADE="EOCT"),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=8L)
)


INTEGRATED_MATH_1_SS.2017_2018.2.config <- list(
	INTEGRATED_MATH_1.2017_2018.2 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "MATHEMATICS_SS", "INTEGRATED_MATH_1_SS"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("7", "8", "EOCT")),
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2017_2018.1", GRADE="EOCT"),
		# sgp.projection.grade.sequences=list("NO_PROJECTIONS"), # 9th grade - CANONICAL
		sgp.norm.group.preference=0L),

	INTEGRATED_MATH_1.2017_2018.2 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "MATHEMATICS_SS", "INTEGRATED_MATH_1_SS"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("5", "6", "EOCT"), c("6", "7", "EOCT")),
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2017_2018.1", GRADE="EOCT"),
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 2)),
		sgp.norm.group.preference=1L), # 7th & 8th grades

	INTEGRATED_MATH_1.2017_2018.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("ALGEBRA_I_SS", "INTEGRATED_MATH_1_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2017_2018.1", GRADE="EOCT"),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=2L),

	INTEGRATED_MATH_1.2017_2018.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("GEOMETRY_SS", "INTEGRATED_MATH_1_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2017_2018.1", GRADE="EOCT"),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=3L),

	INTEGRATED_MATH_1.2017_2018.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("ALGEBRA_II_SS", "INTEGRATED_MATH_1_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2017_2018.1", GRADE="EOCT"),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=4L)
)


INTEGRATED_MATH_2_SS.2017_2018.2.config <- list(
	### CANONICAL - Put first over Fall to Spring for projections/targets (Match Thetas analyses)
	INTEGRATED_MATH_2.2017_2018.2 = list(
		sgp.content.areas=c("INTEGRATED_MATH_1_SS", "INTEGRATED_MATH_2_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2017_2018.1", GRADE="EOCT"),
		# sgp.projection.grade.sequences=list("NO_PROJECTIONS"), # CANONICAL
		sgp.norm.group.preference=0L),

	INTEGRATED_MATH_2.2017_2018.2 = list( # Fall - Spring  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("GEOMETRY_SS", "INTEGRATED_MATH_2_SS"),
		sgp.panel.years=c("2017_2018.1", "2017_2018.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=1L),

	INTEGRATED_MATH_2.2017_2018.2 = list( # Fall - Spring  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("ALGEBRA_II_SS", "INTEGRATED_MATH_2_SS"),
		sgp.panel.years=c("2017_2018.1", "2017_2018.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=2L),

	INTEGRATED_MATH_2.2017_2018.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("ALGEBRA_I_SS", "INTEGRATED_MATH_2_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2017_2018.1", GRADE="EOCT"),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=3L),

	INTEGRATED_MATH_2.2017_2018.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("GEOMETRY_SS", "INTEGRATED_MATH_2_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2017_2018.1", GRADE="EOCT"),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=4L),

	INTEGRATED_MATH_2.2017_2018.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("ALGEBRA_II_SS", "INTEGRATED_MATH_2_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2017_2018.1", GRADE="EOCT"),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=5L),

	INTEGRATED_MATH_2.2017_2018.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("MATHEMATICS_SS", "INTEGRATED_MATH_2_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("6", "EOCT"), c("7", "EOCT"), c("8", "EOCT")), # 8th & 9th grades,
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2017_2018.1", GRADE="EOCT"),
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 3)),
		sgp.norm.group.preference=6L)
)


INTEGRATED_MATH_3_SS.2017_2018.2.config <- list(
	### CANONICAL - Put first over Fall to Spring for projections/targets (Match Thetas analyses)
	INTEGRATED_MATH_3.2017_2018.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_2_SS", "INTEGRATED_MATH_3_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2017_2018.1", GRADE="EOCT"),
		# sgp.projection.grade.sequences=list("NO_PROJECTIONS"), # CANONICAL
		sgp.norm.group.preference=0L),

	INTEGRATED_MATH_3.2017_2018.2 = list( # Fall - Spring  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("ALGEBRA_II_SS", "INTEGRATED_MATH_3_SS"),
		sgp.panel.years=c("2017_2018.1", "2017_2018.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=1L),

	INTEGRATED_MATH_3.2017_2018.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_1_SS", "INTEGRATED_MATH_3_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2017_2018.1", GRADE="EOCT"),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=2L),

	INTEGRATED_MATH_3.2017_2018.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("ALGEBRA_I_SS", "INTEGRATED_MATH_3_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2017_2018.1", GRADE="EOCT"),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=3L),

	INTEGRATED_MATH_3.2017_2018.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("GEOMETRY_SS", "INTEGRATED_MATH_3_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2017_2018.1", GRADE="EOCT"),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=4L),

	INTEGRATED_MATH_3.2017_2018.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("ALGEBRA_II_SS", "INTEGRATED_MATH_3_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2017_2018.1", GRADE="EOCT"),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=5L),

	INTEGRATED_MATH_3.2017_2018.2 = list( #  --  <1000 :: Include for SGP_NOTE
		sgp.content.areas=c("MATHEMATICS_SS", "INTEGRATED_MATH_3_SS"),
		sgp.panel.years=c("2016_2017.2", "2017_2018.2"),
		sgp.grade.sequences=list(c("7", "EOCT"), c("8", "EOCT")), # 8th & 9th grades,
		# sgp.exclude.sequences = data.table(VALID_CASE = "VALID_CASE", CONTENT_AREA=PARCC.Math.Subjects,
		# 	YEAR="2017_2018.1", GRADE="EOCT"),
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 2)),
		sgp.norm.group.preference=6L)
)
