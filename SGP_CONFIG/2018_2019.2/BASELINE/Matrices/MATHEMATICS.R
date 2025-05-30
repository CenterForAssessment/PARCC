################################################################################
###                                                                          ###
###    MATH Baseline Configs for Consortium SGP Analyses (Single cohort)     ###
###                                                                          ###
################################################################################


MATHEMATICS_BASELINE.config <- list(
	list(
		sgp.baseline.content.areas=rep("MATHEMATICS", 2),
		sgp.baseline.panel.years=c("2017_2018.2", "2018_2019.2"),
		sgp.baseline.grade.sequences=c("3", "4"),
		sgp.baseline.grade.sequences.lags=1),

	list(
		sgp.baseline.content.areas=rep("MATHEMATICS", 2),
		sgp.baseline.panel.years=c("2017_2018.2", "2018_2019.2"),
		sgp.baseline.grade.sequences=c("4", "5"),
		sgp.baseline.grade.sequences.lags=1),
	list(
		sgp.baseline.content.areas=rep("MATHEMATICS", 3),
		sgp.baseline.panel.years=c("2016_2017.2", "2017_2018.2", "2018_2019.2"),
		sgp.baseline.grade.sequences=c("3", "4", "5"),
		sgp.baseline.grade.sequences.lags=c(1,1)),
	list(
		sgp.baseline.content.areas=rep("MATHEMATICS", 2),
		sgp.baseline.panel.years=c("2016_2017.2", "2018_2019.2"),
		sgp.baseline.grade.sequences=c("3", "5"),
		sgp.baseline.grade.sequences.lags=2),

	list(
		sgp.baseline.content.areas=rep("MATHEMATICS", 2),
		sgp.baseline.panel.years=c("2017_2018.2", "2018_2019.2"),
		sgp.baseline.grade.sequences=c("5", "6"),
		sgp.baseline.grade.sequences.lags=1),
	list(
		sgp.baseline.content.areas=rep("MATHEMATICS", 3),
		sgp.baseline.panel.years=c("2016_2017.2", "2017_2018.2", "2018_2019.2"),
		sgp.baseline.grade.sequences=c("4", "5", "6"),
		sgp.baseline.grade.sequences.lags=c(1,1)),
	list(
		sgp.baseline.content.areas=rep("MATHEMATICS", 2),
		sgp.baseline.panel.years=c("2016_2017.2", "2018_2019.2"),
		sgp.baseline.grade.sequences=c("4", "6"),
		sgp.baseline.grade.sequences.lags=2),
	list(
		sgp.baseline.content.areas=rep("MATHEMATICS", 3),
		sgp.baseline.panel.years=c("2015_2016.2", "2016_2017.2", "2018_2019.2"),
		sgp.baseline.grade.sequences=c("3", "4", "6"),
		sgp.baseline.grade.sequences.lags=c(1,2)),

	list(
		sgp.baseline.content.areas=rep("MATHEMATICS", 2),
		sgp.baseline.panel.years=c("2017_2018.2", "2018_2019.2"),
		sgp.baseline.grade.sequences=c("6", "7"),
		sgp.baseline.grade.sequences.lags=1),
	list(
		sgp.baseline.content.areas=rep("MATHEMATICS", 3),
		sgp.baseline.panel.years=c("2016_2017.2", "2017_2018.2", "2018_2019.2"),
		sgp.baseline.grade.sequences=c("5", "6", "7"),
		sgp.baseline.grade.sequences.lags=c(1,1)),
	list(
		sgp.baseline.content.areas=rep("MATHEMATICS", 2),
		sgp.baseline.panel.years=c("2016_2017.2", "2018_2019.2"),
		sgp.baseline.grade.sequences=c("5", "7"),
		sgp.baseline.grade.sequences.lags=2),
	list(
		sgp.baseline.content.areas=rep("MATHEMATICS", 3),
		sgp.baseline.panel.years=c("2015_2016.2", "2016_2017.2", "2018_2019.2"),
		sgp.baseline.grade.sequences=c("4", "5", "7"),
		sgp.baseline.grade.sequences.lags=c(1,2)),

	list(
		sgp.baseline.content.areas=rep("MATHEMATICS", 2),
		sgp.baseline.panel.years=c("2017_2018.2", "2018_2019.2"),
		sgp.baseline.grade.sequences=c("7", "8"),
		sgp.baseline.grade.sequences.lags=1),
	list(
		sgp.baseline.content.areas=rep("MATHEMATICS", 3),
		sgp.baseline.panel.years=c("2016_2017.2", "2017_2018.2", "2018_2019.2"),
		sgp.baseline.grade.sequences=c("6", "7", "8"),
		sgp.baseline.grade.sequences.lags=c(1,1)),
	list(
		sgp.baseline.content.areas=rep("MATHEMATICS", 2),
		sgp.baseline.panel.years=c("2016_2017.2", "2018_2019.2"),
		sgp.baseline.grade.sequences=c("6", "8"),
		sgp.baseline.grade.sequences.lags=2),
	list(
		sgp.baseline.content.areas=rep("MATHEMATICS", 3),
		sgp.baseline.panel.years=c("2015_2016.2", "2016_2017.2", "2018_2019.2"),
		sgp.baseline.grade.sequences=c("5", "6", "8"),
		sgp.baseline.grade.sequences.lags=c(1,2))
)


#####
###   Algebra I
#####

ALGEBRA_I_BASELINE.config <- list(
  list(
    sgp.baseline.content.areas=c("MATHEMATICS", "ALGEBRA_I"),
    sgp.baseline.panel.years=c("2017_2018.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c(5, "EOCT"),
    sgp.baseline.grade.sequences.lags=1),

  ###   Baseline Cohort > 1,000
    ## ran this originally in 2021 -- Saved DUPLICATE "ranked_simex_table" !!!
	# list(
    # sgp.baseline.content.areas=c("MATHEMATICS", "ALGEBRA_I"),
    # sgp.baseline.panel.years=c("2017_2018.2", "2018_2019.2"),
    # sgp.baseline.grade.sequences=c(6, "EOCT"),
    # sgp.baseline.grade.sequences.lags=1),

	##    Skip Year - 8th grade prior
	list(
    sgp.baseline.content.areas=c("MATHEMATICS", "ALGEBRA_I"),
    sgp.baseline.panel.years=c("2016_2017.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c(8, "EOCT"),
    sgp.baseline.grade.sequences.lags=2),
  list(
    sgp.baseline.content.areas=c("MATHEMATICS", "MATHEMATICS", "ALGEBRA_I"),
    sgp.baseline.panel.years=c("2015_2016.2", "2016_2017.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c(7, 8, "EOCT"),
    sgp.baseline.grade.sequences.lags=c(1,2)),

	list( # Sequential 8th grade Math to Alg1
    sgp.baseline.content.areas=c("MATHEMATICS", "ALGEBRA_I"),
    sgp.baseline.panel.years=c("2017_2018.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c(8, "EOCT"),
    sgp.baseline.grade.sequences.lags=1),
  list(
    sgp.baseline.content.areas=c("MATHEMATICS", "MATHEMATICS", "ALGEBRA_I"),
    sgp.baseline.panel.years=c("2016_2017.2", "2017_2018.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c(7, 8, "EOCT"),
    sgp.baseline.grade.sequences.lags=c(1,1)),
	# Skip-year 7th grade Math to Alg1
	list(
    sgp.baseline.content.areas=c("MATHEMATICS", "ALGEBRA_I"),
    sgp.baseline.panel.years=c("2016_2017.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c(7, "EOCT"),
    sgp.baseline.grade.sequences.lags=2),
	list(
    sgp.baseline.content.areas=c("MATHEMATICS", "MATHEMATICS", "ALGEBRA_I"),
    sgp.baseline.panel.years=c("2015_2016.2", "2016_2017.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c(6, 7, "EOCT"),
    sgp.baseline.grade.sequences.lags=c(1,2)),

	list( # Sequential 7th grade Math to Alg1
    sgp.baseline.content.areas=c("MATHEMATICS", "ALGEBRA_I"),
    sgp.baseline.panel.years=c("2017_2018.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c(7, "EOCT"),
    sgp.baseline.grade.sequences.lags=1),
  list( # Sequential 7th grade Math to Alg1
    sgp.baseline.content.areas=c("MATHEMATICS", "MATHEMATICS", "ALGEBRA_I"),
    sgp.baseline.panel.years=c("2016_2017.2", "2017_2018.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c(6, 7, "EOCT"),
    sgp.baseline.grade.sequences.lags=c(1,1)),
	# Skip-year 6th grade Math to Alg1
	list(
    sgp.baseline.content.areas=c("MATHEMATICS", "ALGEBRA_I"),
    sgp.baseline.panel.years=c("2016_2017.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c(6, "EOCT"),
    sgp.baseline.grade.sequences.lags=2),
	list(
    sgp.baseline.content.areas=c("MATHEMATICS", "MATHEMATICS", "ALGEBRA_I"),
    sgp.baseline.panel.years=c("2015_2016.2", "2016_2017.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c(5, 6, "EOCT"),
    sgp.baseline.grade.sequences.lags=c(1,2)),

	list( # Sequential 6th grade Math to Alg1
    sgp.baseline.content.areas=c("MATHEMATICS", "ALGEBRA_I"),
    sgp.baseline.panel.years=c("2017_2018.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c(6, "EOCT"),
    sgp.baseline.grade.sequences.lags=1),
  list( # Sequential 7th grade Math to Alg1
    sgp.baseline.content.areas=c("MATHEMATICS", "MATHEMATICS", "ALGEBRA_I"),
    sgp.baseline.panel.years=c("2016_2017.2", "2017_2018.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c(5, 6, "EOCT"),
    sgp.baseline.grade.sequences.lags=c(1,1)),
	# Skip-year 6th grade Math to Alg1
	list(
    sgp.baseline.content.areas=c("MATHEMATICS", "ALGEBRA_I"),
    sgp.baseline.panel.years=c("2016_2017.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c(5, "EOCT"),
    sgp.baseline.grade.sequences.lags=2),
	list(
    sgp.baseline.content.areas=c("MATHEMATICS", "MATHEMATICS", "ALGEBRA_I"),
    sgp.baseline.panel.years=c("2015_2016.2", "2016_2017.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c(4, 5, "EOCT"),
    sgp.baseline.grade.sequences.lags=c(1,2))
) ### END ALGEBRA_I_BASELINE.config


#####
###   Geometry
#####

GEOMETRY_BASELINE.config <- list(
	list( # Sequential Alg1 to Geom (CANONICAL)
    sgp.baseline.content.areas=c("ALGEBRA_I", "GEOMETRY"),
    sgp.baseline.panel.years=c("2017_2018.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c("EOCT", "EOCT"),
    sgp.baseline.grade.sequences.lags=1),
	list(
    sgp.baseline.content.areas=c("MATHEMATICS", "ALGEBRA_I", "GEOMETRY"),
    sgp.baseline.panel.years=c("2016_2017.2", "2017_2018.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c(8, "EOCT", "EOCT"),
    sgp.baseline.grade.sequences.lags=c(1,1)),
	list(
		sgp.baseline.content.areas=c("MATHEMATICS", "ALGEBRA_I", "GEOMETRY"),
		sgp.baseline.panel.years=c("2016_2017.2", "2017_2018.2", "2018_2019.2"),
		sgp.baseline.grade.sequences=c(7, "EOCT", "EOCT"),
		sgp.baseline.grade.sequences.lags=c(1,1)),
  list(
    sgp.baseline.content.areas=c("MATHEMATICS", "ALGEBRA_I", "GEOMETRY"),
    sgp.baseline.panel.years=c("2016_2017.2", "2017_2018.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c(6, "EOCT", "EOCT"),
    sgp.baseline.grade.sequences.lags=c(1,1)),
	# Skip-year Grade-Level Math to Geom
	list(
    sgp.baseline.content.areas=c("MATHEMATICS", "GEOMETRY"),
    sgp.baseline.panel.years=c("2016_2017.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c(8, "EOCT"),
    sgp.baseline.grade.sequences.lags=2),
	list(
    sgp.baseline.content.areas=c("MATHEMATICS", "MATHEMATICS", "GEOMETRY"),
    sgp.baseline.panel.years=c("2015_2016.2", "2016_2017.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c(7, 8, "EOCT"),
    sgp.baseline.grade.sequences.lags=c(1,2)),
	list(
    sgp.baseline.content.areas=c("MATHEMATICS", "GEOMETRY"),
    sgp.baseline.panel.years=c("2016_2017.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c(7, "EOCT"),
    sgp.baseline.grade.sequences.lags=2),
	list(
    sgp.baseline.content.areas=c("MATHEMATICS", "MATHEMATICS", "GEOMETRY"),
    sgp.baseline.panel.years=c("2015_2016.2", "2016_2017.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c(6, 7, "EOCT"),
    sgp.baseline.grade.sequences.lags=c(1,2)),
	list(
    sgp.baseline.content.areas=c("MATHEMATICS", "GEOMETRY"),
    sgp.baseline.panel.years=c("2016_2017.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c(6, "EOCT"),
    sgp.baseline.grade.sequences.lags=2),
	list(
    sgp.baseline.content.areas=c("MATHEMATICS", "MATHEMATICS", "GEOMETRY"),
    sgp.baseline.panel.years=c("2015_2016.2", "2016_2017.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c(5, 6, "EOCT"),
    sgp.baseline.grade.sequences.lags=c(1,2)),

	##  Misc.
	list(
    sgp.baseline.content.areas=c("MATHEMATICS", "GEOMETRY"),
    sgp.baseline.panel.years=c("2017_2018.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c(8, "EOCT"),
    sgp.baseline.grade.sequences.lags=1),
  list(
    sgp.baseline.content.areas=c("MATHEMATICS", "GEOMETRY"),
    sgp.baseline.panel.years=c("2017_2018.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c(7, "EOCT"),
    sgp.baseline.grade.sequences.lags=1),

	list(
    sgp.baseline.content.areas=c("ALGEBRA_II", "GEOMETRY"),
    sgp.baseline.panel.years=c("2017_2018.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c("EOCT", "EOCT"),
    sgp.baseline.grade.sequences.lags=1),
	list(
    sgp.baseline.content.areas=c("ALGEBRA_I", "ALGEBRA_II", "GEOMETRY"),
    sgp.baseline.panel.years=c("2016_2017.2", "2017_2018.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c("EOCT", "EOCT", "EOCT"),
    sgp.baseline.grade.sequences.lags=c(1,1)),

	##    Skip Year (from Alg 2, Alg1 repeaters, etc.)- ALG1 prior
	list(
    sgp.baseline.content.areas=c("ALGEBRA_I", "GEOMETRY"),
    sgp.baseline.panel.years=c("2016_2017.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c("EOCT", "EOCT"),
    sgp.baseline.grade.sequences.lags=2)
	# Probably some workable ( > 1000) progressions, but just keep simple for skips
	# list(
  #   sgp.baseline.content.areas=c("MATHEMATICS", "ALGEBRA_I", "GEOMETRY"),
  #   sgp.baseline.panel.years=c("2015_2016.2", "2016_2017.2", "2018_2019.2"),
  #   sgp.baseline.grade.sequences=c(8, "EOCT", "EOCT"),
  #   sgp.baseline.grade.sequences.lags=c(1,2)),
  # list(
  #   sgp.baseline.content.areas=c("MATHEMATICS", "ALGEBRA_I", "GEOMETRY"),
  #   sgp.baseline.panel.years=c("2015_2016.2", "2016_2017.2", "2018_2019.2"),
  #   sgp.baseline.grade.sequences=c(7, "EOCT", "EOCT"),
  #   sgp.baseline.grade.sequences.lags=c(1,2))
) ### END GEOMETRY_BASELINE.config


#####
###   Algebra 2
#####

ALGEBRA_II_BASELINE.config <- list(
	list( # Sequential Geom to Alg1 (CANONICAL)
    sgp.baseline.content.areas=c("GEOMETRY", "ALGEBRA_II"),
    sgp.baseline.panel.years=c("2017_2018.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c("EOCT", "EOCT"),
    sgp.baseline.grade.sequences.lags=1),
	list(
    sgp.baseline.content.areas=c("ALGEBRA_I", "GEOMETRY", "ALGEBRA_II"),
    sgp.baseline.panel.years=c("2016_2017.2", "2017_2018.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c("EOCT", "EOCT", "EOCT"),
    sgp.baseline.grade.sequences.lags=c(1,1)),
	# Skip-year Alg1 to Alg2
	list(
    sgp.baseline.content.areas=c("ALGEBRA_I", "ALGEBRA_II"),
    sgp.baseline.panel.years=c("2016_2017.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c("EOCT", "EOCT"),
    sgp.baseline.grade.sequences.lags=2),
	list(
    sgp.baseline.content.areas=c("MATHEMATICS", "ALGEBRA_I", "ALGEBRA_II"),
    sgp.baseline.panel.years=c("2015_2016.2", "2016_2017.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c(8, "EOCT", "EOCT"),
    sgp.baseline.grade.sequences.lags=c(1,2)),
	list(
    sgp.baseline.content.areas=c("MATHEMATICS", "ALGEBRA_I", "ALGEBRA_II"),
    sgp.baseline.panel.years=c("2015_2016.2", "2016_2017.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c(7, "EOCT", "EOCT"),
    sgp.baseline.grade.sequences.lags=c(1,2)),

	##  Alg1 to Alg2 directly
	list(
    sgp.baseline.content.areas=c("ALGEBRA_I", "ALGEBRA_II"),
    sgp.baseline.panel.years=c("2017_2018.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c("EOCT", "EOCT"),
    sgp.baseline.grade.sequences.lags=1),
	list(
    sgp.baseline.content.areas=c("MATHEMATICS", "ALGEBRA_I", "ALGEBRA_II"),
    sgp.baseline.panel.years=c("2016_2017.2", "2017_2018.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c(8, "EOCT", "EOCT"),
    sgp.baseline.grade.sequences.lags=c(1,1)),
	list(
    sgp.baseline.content.areas=c("MATHEMATICS", "ALGEBRA_I", "ALGEBRA_II"),
    sgp.baseline.panel.years=c("2016_2017.2", "2017_2018.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c(7, "EOCT", "EOCT"),
    sgp.baseline.grade.sequences.lags=c(1,1)),

	##    Skip Year - Grade level math priors (from Alg1 and misc.)
	list(
    sgp.baseline.content.areas=c("MATHEMATICS", "ALGEBRA_II"),
    sgp.baseline.panel.years=c("2016_2017.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c(8, "EOCT"),
    sgp.baseline.grade.sequences.lags=2),
	list(
    sgp.baseline.content.areas=c("MATHEMATICS", "ALGEBRA_II"),
    sgp.baseline.panel.years=c("2016_2017.2", "2018_2019.2"),
    sgp.baseline.grade.sequences=c(7, "EOCT"),
    sgp.baseline.grade.sequences.lags=2)
) ### END ALGEBRA_II_BASELINE.config
