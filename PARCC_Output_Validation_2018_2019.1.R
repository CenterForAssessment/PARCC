################################################################################
###                                                                          ###
###                                                                          ###
###                   Validate Fall 2018 PARCC SGP output                    ###
###                                                                          ###
###                                                                          ###
################################################################################

cat("#########################################\n", file="PARCC_Output_Validation_2018_2019.1.out")  #X#  /Users/avi/Dropbox (SGP)/Github_Repos/Projects/PARCC/PARCC_Output_Validation_2018_2019.1.out
cat("######### PARCC OUTPUT VALIDATION #######\n", file="PARCC_Output_Validation_2018_2019.1.out", append=TRUE)
cat("#########################################\n", file="PARCC_Output_Validation_2018_2019.1.out", append=TRUE)

### Load packages
require(data.table)

###  Set working directory to top level directory (PARCC) and Identify States
tmp.states <- c("Bureau_Indian_Affairs", "Maryland", "New_Jersey", "New_Mexico")

####   Function to read in individual state files
read.parcc <- function(state, tag, type="OUTPUT") {
  tmp.wd <- getwd()
  if (type=="ORIGINAL") tmp.dir <- "Data/Base_Files" else tmp.dir <- "Data/Pearson"
  tmp.files <- list.files(file.path(state, tmp.dir))
  if (any(grepl(".xls", tmp.files))) tmp.files <- tmp.files[-grep(".xls", tmp.files)]
  my.file <- gsub(".zip",  "", grep(tag, tmp.files, value=TRUE))
  if (grepl(".zip", grep(tag, tmp.files, value=TRUE))) {
    setwd(tempdir())
    system(paste0("unzip '", file.path(tmp.wd, state, tmp.dir, paste0(my.file, ".zip")), "'"))

  	TMP <- fread(my.file, sep=",", colClasses=rep("character", 57))
  	unlink(my.file, recursive = TRUE)
  	setwd(tmp.wd)
    return(TMP)
  } else return(fread(file.path(state, tmp.dir, my.file), sep=",", colClasses=rep("character", 57)))
}

### Loop over states

for (state in tmp.states) {
    tmp.ORIGINAL<-read.parcc(state, "2018-2019_SGPO_D201902", "ORIGINAL")
    tmp.OUTPUT <- read.parcc(state, "2018-2019_Fall_SGP-Results_20190224")
    # tmp.ORIGINAL1<- read.parcc("Maryland", "2018-2019_SGPO_D201902", "ORIGINAL"); state <- "Maryland"
    # tmp.ORIGINAL2<- read.parcc(state, "2018-2019_SGPO_D201903", "ORIGINAL")
    # tmp.ORIGINAL <- rbindlist(list(tmp.ORIGINAL1, tmp.ORIGINAL2))
    # tmp.OUTPUT <- read.parcc(state, "2018-2019_Fall_SGP-Results_20190307")
    setkey(tmp.ORIGINAL, PARCCStudentIdentifier)
    setkey(tmp.OUTPUT, PARCCStudentIdentifier)

    cat(paste("\n\n###", state, "Output Validation ###\n"), file="PARCC_Output_Validation_2018_2019.1.out", append=TRUE)

    ### TEST for identical PARCCStudentIdentifier
    tmp.tf <- identical(tmp.OUTPUT$PARCCStudentIdentifier, tmp.ORIGINAL$PARCCStudentIdentifier)
    cat(paste("\n### Test for Identical PARCCStudentIdentifier in BASE and OUTPUT files:", tmp.tf), file="PARCC_Output_Validation_2018_2019.1.out", append=TRUE)

    tmp.sgp.state <- paste(as.character(summary(as.numeric(tmp.OUTPUT$StudentGrowthPercentileComparedtoState))), collapse=" ")
    cat(paste("\n### Test of StudentGrowthPercentileComparedtoState:", tmp.sgp.state), file="PARCC_Output_Validation_2018_2019.1.out", append=TRUE)

    tmp.sgp.parcc <- paste(as.character(summary(as.numeric(tmp.OUTPUT$StudentGrowthPercentileComparedtoPARCC))), collapse=" ")
    cat(paste("\n### Test of StudentGrowthPercentileComparedtoPARCC:", tmp.sgp.parcc), file="PARCC_Output_Validation_2018_2019.1.out", append=TRUE)

    tmp.simex.state <- tmp.OUTPUT[!is.na(as.numeric(SGPRankedSimexState)), as.list(summary(as.numeric(SGPRankedSimexState))), keyby="TestCode"]
    tmp.simex.state.n <- tmp.OUTPUT[!is.na(as.numeric(SGPRankedSimexState)), list(.N), keyby="TestCode"]
    cat("\n\n### Test of SGPRankedSimexState:\n", file="PARCC_Output_Validation_2018_2019.1.out", append=TRUE)
    capture.output(tmp.simex.state[tmp.simex.state.n], file = "PARCC_Output_Validation_2018_2019.1.out", append=TRUE)

    tmp.simex.parcc <- tmp.OUTPUT[!is.na(as.numeric(SGPRankedSimexPARCC)), as.list(summary(as.numeric(SGPRankedSimexPARCC))), keyby="TestCode"]
    tmp.simex.parcc.n <- tmp.OUTPUT[!is.na(as.numeric(SGPRankedSimexPARCC)), list(.N), keyby="TestCode"]
    cat("\n\n### Test of SGPRankedSimexPARCC:\n", file="PARCC_Output_Validation_2018_2019.1.out", append=TRUE)
    capture.output(tmp.simex.parcc[tmp.simex.parcc.n], file = "PARCC_Output_Validation_2018_2019.1.out", append=TRUE)

    cat(paste("\n###   END ", state, "Output Validation   ###\n\n"), file="PARCC_Output_Validation_2018_2019.1.out", append=TRUE)

    gc()
}
