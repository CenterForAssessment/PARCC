################################################################################
###                                                                          ###
###                                                                          ###
###                   Validate Fall 2018 PARCC SGP output                    ###
###                                                                          ###
###                                                                          ###
################################################################################

out.file <- "/media/Data/Dropbox (SGP)/Github_Repos/Projects/PARCC/PARCC_Output_Validation_2018_2019.2.out"

cat("#########################################\n", file = out.file)
cat("######### PARCC OUTPUT VALIDATION #######\n", file = out.file, append=TRUE)
cat("#########################################\n", file = out.file, append=TRUE)

### Load packages
require(data.table)

###  Set working directory to top level directory (PARCC) and Identify States
tmp.states <- c("Bureau_Indian_Affairs", "Department_Of_Defense", "Illinois", "Maryland", "New_Jersey", "New_Mexico", "Washington_DC")

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
    if (state == "Maryland") tmp.ORIGINAL<-read.parcc(state, "2018-2019_SGPO_D201908", "ORIGINAL")
    if (state == "New_Jersey") tmp.ORIGINAL<-read.parcc(state, "2018-2019_SGPO_D20190812", "ORIGINAL") # D20190726
    if (state == "New_Mexico") tmp.ORIGINAL<-read.parcc(state, "2018-2019_SGPO_D201908", "ORIGINAL")
    if (!state %in% c("Maryland", "New_Mexico", "New_Jersey")) {
      tmp.ORIGINAL<-read.parcc(state, "2018-2019_SGPO_D201906", "ORIGINAL")
    }
    if (state == "Maryland") tmp.OUTPUT <- read.parcc(state, "2018-2019_Spring_SGP-Results_20190814")
    if (state == "New_Jersey") tmp.OUTPUT <- read.parcc(state, "2018-2019_Spring_SGP-Results_20190816")
    if (state == "New_Mexico") tmp.OUTPUT <- read.parcc(state, "2018-2019_Spring_SGP-Results_20190908")
    if (!state %in% c("Maryland", "New_Mexico", "New_Jersey")) {
      tmp.OUTPUT <- read.parcc(state, "2018-2019_Spring_SGP-Results_201908")
    }
    setkey(tmp.ORIGINAL, PANUniqueStudentID, TestCode, IRTTheta)
    setkey(tmp.OUTPUT, PANUniqueStudentID, TestCode, IRTTheta)

    cat(paste("\n\n###", state, "Output Validation ###\n"), file = out.file, append=TRUE)

    ### TEST for identical PANUniqueStudentID
    tmp.tf <- identical(tmp.OUTPUT$PANUniqueStudentID, tmp.ORIGINAL$PANUniqueStudentID)
    cat(paste("\n### Test for Identical PANUniqueStudentID in BASE and OUTPUT files:", tmp.tf), file = out.file, append=TRUE)

    ### TEST for identical IRTTheta
    tmp.tf <- identical(as.numeric(tmp.OUTPUT$IRTTheta), as.numeric(tmp.ORIGINAL$IRTTheta))
    cat(paste("\n### Test for Identical IRTTheta in BASE and OUTPUT files:", tmp.tf), file = out.file, append=TRUE)

    # tmp.sgp.state <- paste(as.character(summary(as.numeric(tmp.OUTPUT$StudentGrowthPercentileComparedtoState))), collapse=" ")
    tmp.sgp.state <- tmp.OUTPUT[!is.na(as.numeric(StudentGrowthPercentileComparedtoState)), as.list(summary(as.numeric(StudentGrowthPercentileComparedtoState))), keyby="TestCode"]
    tmp.sgp.state.n <- tmp.OUTPUT[!is.na(as.numeric(StudentGrowthPercentileComparedtoState)), list(.N), keyby="TestCode"]
    # cat(paste("\n### Test of StudentGrowthPercentileComparedtoState:", tmp.sgp.stat), file = out.file, append=TRUE)
    cat("\n\n### Test of StudentGrowthPercentileComparedtoState:\n", file = out.file, append=TRUE)
    capture.output(tmp.sgp.state[tmp.sgp.state.n], file = out.file, append=TRUE)

    # tmp.sgp.parcc <- paste(as.character(summary(as.numeric(tmp.OUTPUT$StudentGrowthPercentileComparedtoPARCC))), collapse=" ")
    tmp.sgp.parcc <- tmp.OUTPUT[!is.na(as.numeric(StudentGrowthPercentileComparedtoPARCC)), as.list(summary(as.numeric(StudentGrowthPercentileComparedtoPARCC))), keyby="TestCode"]
    tmp.sgp.parcc.n <- tmp.OUTPUT[!is.na(as.numeric(StudentGrowthPercentileComparedtoPARCC)), list(.N), keyby="TestCode"]
    # cat(paste("\n### Test of StudentGrowthPercentileComparedtoPARCC:", tmp.sgp.parcc), file = out.file, append=TRUE)
    cat("\n\n### Test of StudentGrowthPercentileComparedtoPARCC:\n", file = out.file, append=TRUE)
    capture.output(tmp.sgp.parcc[tmp.sgp.parcc.n], file = out.file, append=TRUE)

    tmp.simex.state <- tmp.OUTPUT[!is.na(as.numeric(SGPRankedSimexState)), as.list(summary(as.numeric(SGPRankedSimexState))), keyby="TestCode"]
    tmp.simex.state.n <- tmp.OUTPUT[!is.na(as.numeric(SGPRankedSimexState)), list(.N), keyby="TestCode"]
    cat("\n\n### Test of SGPRankedSimexState:\n", file = out.file, append=TRUE)
    capture.output(tmp.simex.state[tmp.simex.state.n], file = out.file, append=TRUE)

    tmp.simex.parcc <- tmp.OUTPUT[!is.na(as.numeric(SGPRankedSimexPARCC)), as.list(summary(as.numeric(SGPRankedSimexPARCC))), keyby="TestCode"]
    tmp.simex.parcc.n <- tmp.OUTPUT[!is.na(as.numeric(SGPRankedSimexPARCC)), list(.N), keyby="TestCode"]
    cat("\n\n### Test of SGPRankedSimexPARCC:\n", file = out.file, append=TRUE)
    capture.output(tmp.simex.parcc[tmp.simex.parcc.n], file = out.file, append=TRUE)

    cat(paste("\n###   END ", state, "Output Validation   ###\n\n"), file = out.file, append=TRUE)

    gc()
}
