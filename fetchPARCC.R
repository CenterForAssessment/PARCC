###  fetchPARCC function
fetchPARCC <- function(state=NULL, parcc.db, prior.years, current.year, fields="*") {

		if (!is.null(state)) {
			pull_priors <-
				paste0("prior_data <- rbindlist(list(",
					paste0("dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), \"select ", fields, " from ", paste0("PARCC_Data_LONG_", prior.years), " where StateAbbreviation in ('", state, "')\")", collapse=","), "), fill=TRUE)")
			eval(parse(text=pull_priors))
			###   INVALIDate duplicate prior test scores - keep highest THETA/SCALE_SCORE
			setkey(prior_data, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID, SCALE_SCORE, SCALE_SCORE_ACTUAL)
			setkey(prior_data, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID)
			prior_data[which(duplicated(prior_data, by=key(prior_data)))-1, VALID_CASE := "INVALID_CASE"]

			###  Current year
			pull_current <- paste0("current_data <- data.table(dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), \"select ", fields, " from ", paste0("PARCC_Data_LONG_", current.year), " where StateAbbreviation in ('", state, "')\"))")
			eval(parse(text=pull_current))
			###   INVALIDate EXACT duplicate current test scores - create an indicator for subsequent data merge.
			current_data[, EXACT_DUPLICATE := as.numeric(NA)]

			setkey(current_data, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID, SCALE_SCORE_ACTUAL, SCALE_SCORE)
			current_data[which(duplicated(current_data, by=key(current_data)))-1, EXACT_DUPLICATE := 1]
			current_data[which(duplicated(current_data, by=key(current_data))), EXACT_DUPLICATE := 2]
			current_data[which(duplicated(current_data, by=key(current_data))), VALID_CASE := "INVALID_CASE"]

			tmp_data <- rbindlist(list(prior_data, current_data), fill=TRUE)
			tmp_data <- SGP:::getAchievementLevel(tmp_data, state="PARCC")
			return(tmp_data)
		}

		###  Else ...  PARCC consortium
		pull_priors <-
			paste0("prior_data <- rbindlist(list(",
				paste0("dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), \"select ", fields, " from ", paste0("PARCC_Data_LONG_", prior.years), "\")", collapse=","), "), fill=TRUE)")
		eval(parse(text=pull_priors))

		###   INVALIDate duplicate prior test scores - keep highest THETA/SCALE_SCORE
		setkey(prior_data, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID, SCALE_SCORE, SCALE_SCORE_ACTUAL)
		setkey(prior_data, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID)
		prior_data[which(duplicated(prior_data, by=key(prior_data)))-1, VALID_CASE := "INVALID_CASE"]

		###  Current year
		pull_current <- paste0("current_data <- dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), \"select ", fields, " from ", paste0("PARCC_Data_LONG_", current.year), "\")")
		eval(parse(text=pull_current))

		tmp_data <- rbindlist(list(prior_data, current_data), fill=TRUE)
		tmp_data <- SGP:::getAchievementLevel(tmp_data, state="PARCC")
		return(tmp_data)
}
