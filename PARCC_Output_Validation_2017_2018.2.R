#######################################################################
###
###                   Script to validate output
###
#######################################################################

cat("#########################################\n", file="PARCC_Output_Validation_2017_2018.2.out")
cat("######### PARCC OUTPUT VALIDATION #######\n", file="PARCC_Output_Validation_2017_2018.2.out", append=TRUE)
cat("#########################################\n", file="PARCC_Output_Validation_2017_2018.2.out", append=TRUE)

### Load packages

require(data.table)


###  Set working directory to top level directory (PARCC) and Identify States
tmp.states <- c("Colorado", "Illinois", "Maryland", "New_Jersey", "New_Mexico", "Rhode_Island", "Washington_DC", "Bureau_Indian_Affairs")

####   Function to read in individual state files
read.parcc <- function(state, tag, type="OUTPUT") {
  tmp.wd <- getwd()
  if (type=="ORIGINAL") tmp.dir <- "Data/Base_Files" else tmp.dir <- "Data/Pearson"
  tmp.files <- list.files(file.path(state, tmp.dir))
  my.file <- gsub(".zip",  "", grep(tag, tmp.files, value=TRUE))
  setwd(tempdir())
  system(paste0("unzip '", file.path(tmp.wd, state, tmp.dir, paste0(my.file, ".zip")), "'"))

	TMP <- fread(my.file, sep=",", colClasses=rep("character", 57))
	unlink(my.file, recursive = TRUE)
	setwd(tmp.wd)
	return(TMP)
}

### Loop over states

for (state in tmp.states) {
    tmp.ORIGINAL<-read.parcc(state, "2017-2018_SGPO_D2017062", "ORIGINAL")
    tmp.OUTPUT <- read.parcc(state, "2017-2018_Spring_SGP-Results_20170709")
    setkey(tmp.ORIGINAL, PARCCStudentIdentifier)
    setkey(tmp.OUTPUT, PARCCStudentIdentifier)

    cat(paste("\n\n###", state, "Output Validation ###\n"), file="PARCC_Output_Validation_2017_2018.2.out", append=TRUE)

    ### TEST for identical PARCCStudentIdentifier
    tmp.tf <- identical(tmp.OUTPUT$PARCCStudentIdentifier, tmp.ORIGINAL$PARCCStudentIdentifier)
    cat(paste("\n### Test for Identical PARCCStudentIdentifier in BASE and OUTPUT files:", tmp.tf), file="PARCC_Output_Validation_2017_2018.2.out", append=TRUE)

    tmp.sgp.state <- paste(as.character(summary(as.numeric(tmp.OUTPUT$StudentGrowthPercentileComparedtoState))), collapse=" ")
    cat(paste("\n### Test of StudentGrowthPercentileComparedtoState:", tmp.sgp.state), file="PARCC_Output_Validation_2017_2018.2.out", append=TRUE)

    tmp.sgp.parcc <- paste(as.character(summary(as.numeric(tmp.OUTPUT$StudentGrowthPercentileComparedtoPARCC))), collapse=" ")
    cat(paste("\n### Test of StudentGrowthPercentileComparedtoPARCC:", tmp.sgp.parcc), file="PARCC_Output_Validation_2017_2018.2.out", append=TRUE)

    tmp.target.state <- paste(as.character(summary(as.numeric(tmp.OUTPUT$SGPTargetState))), collapse=" ")
    cat(paste("\n### Test of SGPTargetState:", tmp.target.state), file="PARCC_Output_Validation_2017_2018.2.out", append=TRUE)

    tmp.target.parcc <- paste(as.character(summary(as.numeric(tmp.OUTPUT$SGPTargetPARCC))), collapse=" ")
    cat(paste("\n### Test of SGPTargetPARCC:", tmp.target.parcc), file="PARCC_Output_Validation_2017_2018.2.out", append=TRUE)

    tmp.simex.state <- tmp.OUTPUT[!is.na(as.numeric(SGPRankedSimexState)), as.list(summary(as.numeric(SGPRankedSimexState))), keyby="TestCode"]
    cat("\n\n### Test of SGPRankedSimexState:\n", file="PARCC_Output_Validation_2017_2018.2.out", append=TRUE)
    capture.output(tmp.simex.state, file = "PARCC_Output_Validation_2017_2018.2.out", append=TRUE)

    tmp.simex.parcc <- tmp.OUTPUT[!is.na(as.numeric(SGPRankedSimexPARCC)), as.list(summary(as.numeric(SGPRankedSimexPARCC))), keyby="TestCode"]
    cat("\n\n### Test of SGPRankedSimexPARCC:\n", file="PARCC_Output_Validation_2017_2018.2.out", append=TRUE)
    capture.output(tmp.simex.parcc, file = "PARCC_Output_Validation_2017_2018.2.out", append=TRUE)

    cat(paste("\n###   END ", state, "Output Validation   ###\n\n"), file="PARCC_Output_Validation_2017_2018.2.out", append=TRUE)

    gc()
}
