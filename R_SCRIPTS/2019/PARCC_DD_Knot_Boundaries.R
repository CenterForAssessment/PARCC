#################################################################################
###                                                                           ###
###          Create PARCC Department_of_Defense Knots and Boundaries          ###
###                                                                           ###
#################################################################################

setwd("/media/Data/Dropbox (SGP)/SGP/PARCC")

### Load Packages

require(SGP)
require(data.table)

###  Load Data
load("./Department_Of_Defense/Data/Archive/2017_2018.2/Department_of_Defense_Data_LONG_2017_2018.2.Rdata")
load("./Department_Of_Defense/Data/Archive/2018_2019.2/Department_of_Defense_Data_LONG_2018_2019.2.Rdata")

Department_of_Defense_Data_LONG <- rbindlist(list(Department_of_Defense_Data_LONG_2017_2018.2, Department_of_Defense_Data_LONG_2018_2019.2), fill=TRUE)

rm(list = c("Department_of_Defense_Data_LONG_2017_2018.2", "Department_of_Defense_Data_LONG_2018_2019.2"))


###  Need to set all boundary knots and LOSS/HOSS values manually

Department_of_Defense_Data_LONG[grep("_SS", CONTENT_AREA, invert =TRUE),][, as.list(summary(SCALE_SCORE)), by="TestCode"]

	state <- "DD"
	tmp.kbs <- createKnotsBoundaries(Department_of_Defense_Data_LONG)

	for (ca in names(tmp.kbs)) {
		if (grepl("_SS", ca)){
			for (f in grep("loss.hoss_", names(tmp.kbs[[ca]]))) tmp.kbs[[ca]][f][[1]] <- c(650, 850)
			for (f in grep("boundaries_", names(tmp.kbs[[ca]]))) tmp.kbs[[ca]][f][[1]] <- c(630, 870)
		} else {
			for (f in grep("loss.hoss_", names(tmp.kbs[[ca]]))) tmp.kbs[[ca]][f][[1]] <- c(-15, 15)
			for (f in grep("boundaries_", names(tmp.kbs[[ca]]))) tmp.kbs[[ca]][f][[1]] <- c(-18, 18)
		}
	}

	assign("PARCC_DD_Knots_Boundaries", tmp.kbs)
	save(list="PARCC_DD_Knots_Boundaries", file="/media/Data/Dropbox (SGP)/Github_Repos/Packages/SGPstateData/Knots_Boundaries/PARCC_DD_Knots_Boundaries.Rdata")
