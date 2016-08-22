#################################################################################
###                                                                           ###
###             Create PARCC State-Specific Knots and Boundaries              ###
###                                                                           ###
#################################################################################

setwd("/media/Data/Dropbox (SGP)/SGP/PARCC")

### Load Packages

require(SGP)
require(RSQLite)
require(data.table)

parcc.db <- "./PARCC/Data/PARCC_Data_LONG.sqlite"

PARCC_Data_LONG <- rbindlist(list(
		dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select * from PARCC_Data_LONG_2015_1"),
		dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select * from PARCC_Data_LONG_2015_2"),
		dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select * from PARCC_Data_LONG_2016_1"),
		dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select * from PARCC_Data_LONG_2016_2")), fill=TRUE)

PARCC_Data_LONG[, SCALE_SCORE := as.numeric(SCALE_SCORE)]
setkey(PARCC_Data_LONG, CONTENT_AREA, GRADE)


###  Need to set all boundary knots and LOSS/HOSS values manually

PARCC_Data_LONG[grep("_SS", CONTENT_AREA, invert =TRUE),][, as.list(summary(SCALE_SCORE)), by="TestCode"]

for (state in sort(unique(PARCC_Data_LONG[, StateAbbreviation]))) {
	tmp.kbs <- createKnotsBoundaries(PARCC_Data_LONG[StateAbbreviation==state])

	for (ca in names(tmp.kbs)) {
		if (grepl("_SS", ca)){
			for (f in grep("loss.hoss_", names(tmp.kbs[[ca]]))) tmp.kbs[[ca]][f][[1]] <- c(650, 850)
			for (f in grep("boundaries_", names(tmp.kbs[[ca]]))) tmp.kbs[[ca]][f][[1]] <- c(630, 870)
		} else {
			for (f in grep("loss.hoss_", names(tmp.kbs[[ca]]))) tmp.kbs[[ca]][f][[1]] <- c(-15, 15)
			for (f in grep("boundaries_", names(tmp.kbs[[ca]]))) tmp.kbs[[ca]][f][[1]] <- c(-18, 18)
		}
	}

	if (state=="BI") state <- "BIA"
	assign(paste0("PARCC_", state, "_Knots_Boundaries"), tmp.kbs)
	save(list=paste0("PARCC_", state, "_Knots_Boundaries"), file=paste0("PARCC_", state, "_Knots_Boundaries.Rdata"))
}

load("~/Dropbox (SGP)/Github_Repos/Packages/SGPstateData/Knots_Boundaries/PARCC_Knots_Boundaries.Rdata")

for (ca in names(PARCC_Knots_Boundaries)) {
	if (grepl("_SS", ca)){
		for (f in grep("loss.hoss_", names(PARCC_Knots_Boundaries[[ca]]))) PARCC_Knots_Boundaries[[ca]][f][[1]] <- c(650, 850)
		for (f in grep("boundaries_", names(PARCC_Knots_Boundaries[[ca]]))) PARCC_Knots_Boundaries[[ca]][f][[1]] <- c(630, 870)
	} else {
		for (f in grep("loss.hoss_", names(PARCC_Knots_Boundaries[[ca]]))) PARCC_Knots_Boundaries[[ca]][f][[1]] <- c(-15, 15)
		for (f in grep("boundaries_", names(PARCC_Knots_Boundaries[[ca]]))) PARCC_Knots_Boundaries[[ca]][f][[1]] <- c(-18, 18)
	}
}

save(PARCC_Knots_Boundaries, file="~/Dropbox (SGP)/Github_Repos/Packages/SGPstateData/Knots_Boundaries/PARCC_Knots_Boundaries.Rdata")

###
###		Tests to compare A) Old Scale to New Scale and B) States to other states and PARCC Consortium
###


PARCC_Scale_1 <- rbindlist(list(
		dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select * from PARCC_Data_LONG_2015_1"),
		dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select * from PARCC_Data_LONG_2015_2"),
		dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select * from PARCC_Data_LONG_2016_1")))

PARCC_Scale_2 <- data.table(
		dbGetQuery(dbConnect(SQLite(), dbname = parcc.db), "select * from PARCC_Data_LONG_2016_2"))


x <- as.numeric(as.data.table(PARCC_Scale_1)[CONTENT_AREA=="MATHEMATICS" & GRADE==6 & !is.na(SCALE_SCORE) & VALID_CASE=='VALID_CASE']$SCALE_SCORE)
y <- as.numeric(as.data.table(PARCC_Scale_2)[CONTENT_AREA=="MATHEMATICS" & GRADE==6 & !is.na(SCALE_SCORE) & VALID_CASE=='VALID_CASE']$SCALE_SCORE)

yq <- quantile(y, probs = seq(.2, .8, by=.2))
xq <- quantile(x, probs = seq(.2, .8, by=.2))

par(bg='darkgrey')
plot(density(x), bg='gray', xlim=c(-5,5))
lines(density(y), col='red', lty=2, lwd=2)
abline(v=xq[1], col='blue')
abline(v=yq[1], col='blue', lty=2, lwd=2)

abline(v=xq[2], col='green')
abline(v=yq[2], col='green', lty=2, lwd=2)
abline(v=xq[3], col='yellow')
abline(v=yq[3], col='yellow', lty=2, lwd=2)
abline(v=xq[4], col='darkorange')
abline(v=yq[4], col='darkorange', lty=2, lwd=2)

Fn <- ecdf(x)
Fn(yq[1])
