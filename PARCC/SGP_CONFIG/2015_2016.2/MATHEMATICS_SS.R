###########################################################################################
###                                                                                     ###
### SGP Configurations for 2015_2016 Grade Level and EOCT Math subjects - SCALE SCORES  ###
###                                                                                     ###
###########################################################################################

MATHEMATICS_SS_2015_2016.config <- list(
	MATHEMATICS.2015_2016 = list(
		sgp.content.areas=rep("MATHEMATICS_SS", 2),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(as.character(3:4), as.character(4:5), as.character(5:6), as.character(6:7), as.character(7:8)),
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 5))
	)
)

ALGEBRA_I_SS.2015_2016.config <- list(
	ALGEBRA_I.2015_2016 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "ALGEBRA_I_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("8", "EOCT")), # 9th grade - CANONICAL
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 3)),
		sgp.norm.group.preference=0),

	ALGEBRA_I.2015_2016 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "ALGEBRA_I_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("6", "EOCT"), c("7", "EOCT")), # 7th & 8th grades
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 3)),
		sgp.norm.group.preference=1),

	ALGEBRA_I.2015_2016 = list(
		sgp.content.areas=c("GEOMETRY_SS", "ALGEBRA_I_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=2,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_I.2015_2016 = list(
		sgp.content.areas=c("INTEGRATED_MATH_1_SS", "ALGEBRA_I_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=3,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_I.2015_2016 = list(
		sgp.content.areas=c("INTEGRATED_MATH_2_SS", "ALGEBRA_I_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=4,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	ALGEBRA_I.2015_2016 = list(
		sgp.content.areas=c("INTEGRATED_MATH_3_SS", "ALGEBRA_I_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=5,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"))
)

GEOMETRY_SS.2015_2016.config <- list(
	GEOMETRY.2015_2016 = list(
		sgp.content.areas=c("ALGEBRA_I_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=0,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),

	GEOMETRY.2015_2016 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("6", "EOCT"), c("7", "EOCT"), c("8", "EOCT")),
		sgp.norm.group.preference=1, # 8th & 9th grades
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 3))),

	GEOMETRY.2015_2016 = list(
		sgp.content.areas=c("ALGEBRA_II_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=2,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),

	GEOMETRY.2015_2016 = list(
		sgp.content.areas=c("INTEGRATED_MATH_1_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=3,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),

	GEOMETRY.2015_2016 = list(
		sgp.content.areas=c("INTEGRATED_MATH_2_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=4,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),

	GEOMETRY.2015_2016 = list(
		sgp.content.areas=c("INTEGRATED_MATH_3_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=5,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"))
)

ALGEBRA_II_SS.2015_2016.config <- list(
	ALGEBRA_II.2015_2016 = list(
		sgp.content.areas=c("GEOMETRY_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=0,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),

	ALGEBRA_II.2015_2016 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("7", "EOCT"), c("8", "EOCT")),
		sgp.norm.group.preference=1, # 8th & 9th grades
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 2))),

	ALGEBRA_II.2015_2016 = list(
		sgp.content.areas=c("ALGEBRA_I_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=2,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),

	ALGEBRA_II.2015_2016 = list(
		sgp.content.areas=c("INTEGRATED_MATH_1_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=3,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),

	ALGEBRA_II.2015_2016 = list(
		sgp.content.areas=c("INTEGRATED_MATH_2_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=4,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),

	ALGEBRA_II.2015_2016 = list(
		sgp.content.areas=c("INTEGRATED_MATH_3_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=5,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"))
)

INTEGRATED_MATH_1_SS.2015_2016.config <- list(
	INTEGRATED_MATH_1.2015_2016 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "INTEGRATED_MATH_1_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("8", "EOCT")),
		sgp.norm.group.preference=0, # 9th grade - CANONICAL
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 3))),

	INTEGRATED_MATH_1.2015_2016 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "INTEGRATED_MATH_1_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("6", "EOCT"), c("7", "EOCT")),
		sgp.norm.group.preference=1, # 7th & 8th grades
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 3))),

	INTEGRATED_MATH_1.2015_2016 = list(
		sgp.content.areas=c("ALGEBRA_I_SS", "INTEGRATED_MATH_1_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=2,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),

	INTEGRATED_MATH_1.2015_2016 = list(
		sgp.content.areas=c("GEOMETRY_SS", "INTEGRATED_MATH_1_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=3,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),

	INTEGRATED_MATH_1.2015_2016 = list(
		sgp.content.areas=c("ALGEBRA_II_SS", "INTEGRATED_MATH_1_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=4,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"))
)

INTEGRATED_MATH_2_SS.2015_2016.config <- list(
	INTEGRATED_MATH_2.2015_2016 = list(
		sgp.content.areas=c("INTEGRATED_MATH_1_SS", "INTEGRATED_MATH_2_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=0,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),

	INTEGRATED_MATH_2.2015_2016 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "INTEGRATED_MATH_2_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("7", "EOCT"), c("8", "EOCT")), # 8th & 9th grades,
		sgp.norm.group.preference=1,
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 2)))
)

INTEGRATED_MATH_3_SS.2015_2016.config <- list(
	INTEGRATED_MATH_3.2015_2016 = list(
		sgp.content.areas=c("INTEGRATED_MATH_2_SS", "INTEGRATED_MATH_3_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=0,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),

	INTEGRATED_MATH_3.2015_2016 = list(
		sgp.content.areas=c("INTEGRATED_MATH_1_SS", "INTEGRATED_MATH_3_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=1,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),

	INTEGRATED_MATH_3.2015_2016 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "INTEGRATED_MATH_3_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("7", "EOCT"), c("8", "EOCT")), # 8th & 9th grades,
		sgp.norm.group.preference=2,
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 2)))
)