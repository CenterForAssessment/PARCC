###############################################################################
###                                                                         ###
###                  Validate Spring 2021 PARCC SGP output                  ###
###                                                                         ###
###############################################################################

out.file <- "/Users/avi/Dropbox (SGP)/Github_Repos/Projects/PARCC/PARCC_Output_Validation_2020_2021.2.out"

cat("#########################################\n", file = out.file)
cat("######### PARCC OUTPUT VALIDATION #######\n", file = out.file, append=TRUE)
cat("#########################################\n", file = out.file, append=TRUE)

### Load packages
require(data.table)

###  Set working directory to top level directory (PARCC) and Identify States
tmp.states <- c("Bureau_of_Indian_Education", "Department_Of_Defense", "Illinois")

####   Function to read in individual state files
read.parcc <- function(state, tag, type="OUTPUT") {
  tmp.wd <- getwd()
  if (type=="ORIGINAL") tmp.dir <- "Data/Base_Files" else tmp.dir <- "Data/Pearson"
  tmp.files <- list.files(file.path(state, tmp.dir))
  if (any(grepl(".xls", tmp.files))) tmp.files <- tmp.files[-grep(".xls", tmp.files)]
  my.file <- gsub(".zip",  "", grep(tag, tmp.files, value=TRUE))

  if (state == "Illinois") var.num <- 90 else var.num <- 92
  if (grepl(".zip", grep(tag, tmp.files, value=TRUE))) {
    setwd(tempdir())
    system(paste0("unzip '", file.path(tmp.wd, state, tmp.dir, paste0(my.file, ".zip")), "'"))
  	TMP <- fread(my.file, sep=",", colClasses=rep("character", var.num))
  	unlink(my.file, recursive = TRUE)
  	setwd(tmp.wd)
    return(TMP)
  } else return(fread(file.path(state, tmp.dir, my.file), sep=",", colClasses=rep("character", var.num)))
}

### Loop over states

for (state in tmp.states) {
    if (state == "Bureau_of_Indian_Education") tmp.ORIGINAL<-fread("./Bureau_of_Indian_Education/Data/Base_Files/bi_pcspr21_state_Student_Growth_20210723151340223283.csv", colClasses=rep("character", 92))
    # if (state == "Illinois") tmp.ORIGINAL<-fread("./Illinois/Data/Base_Files/PARCC_IL_2020-2021_SGPO_D20210623.csv", colClasses=rep("character", 90))
    if (state == "Illinois") tmp.ORIGINAL <- fread("./Illinois/Data/Base_Files/PARCC_IL_2020-2021_SGPO_D20211031.csv", colClasses=rep("character", 90))
    if (state == "Department_Of_Defense") tmp.ORIGINAL<-fread("./Department_Of_Defense/Data/Base_Files/pcspr21_dodea_state_Student_Growth_20210726153550747902.csv", colClasses=rep("character", 92))
    tmp.OUTPUT <- read.parcc(state, "2020-2021_Spring_SGP-Results_20211122")
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

    tmp.simex.state <- tmp.OUTPUT[!is.na(as.numeric(SGPRankedSimexState)), as.list(summary(as.numeric(SGPRankedSimexState))), keyby="TestCode"]
    tmp.simex.state.n <- tmp.OUTPUT[!is.na(as.numeric(SGPRankedSimexState)), list(.N), keyby="TestCode"]
    cat("\n\n### Test of SGPRankedSimexState:\n", file = out.file, append=TRUE)
    capture.output(tmp.simex.state[tmp.simex.state.n], file = out.file, append=TRUE)

    # tmp.sgp.parcc <- paste(as.character(summary(as.numeric(tmp.OUTPUT$StudentGrowthPercentileComparedtoPARCC))), collapse=" ")
    tmp.sgp.parcc <- tmp.OUTPUT[!is.na(as.numeric(StudentGrowthPercentileComparedtoPARCC)), as.list(summary(as.numeric(StudentGrowthPercentileComparedtoPARCC))), keyby="TestCode"]
    tmp.sgp.parcc.n <- tmp.OUTPUT[!is.na(as.numeric(StudentGrowthPercentileComparedtoPARCC)), list(.N), keyby="TestCode"]
    # cat(paste("\n### Test of StudentGrowthPercentileComparedtoPARCC:", tmp.sgp.parcc), file = out.file, append=TRUE)
    cat("\n\n### Test of StudentGrowthPercentileComparedtoPARCC:\n", file = out.file, append=TRUE)
    capture.output(tmp.sgp.parcc[tmp.sgp.parcc.n], file = out.file, append=TRUE)

    tmp.simex.parcc <- tmp.OUTPUT[!is.na(as.numeric(SGPRankedSimexPARCC)), as.list(summary(as.numeric(SGPRankedSimexPARCC))), keyby="TestCode"]
    tmp.simex.parcc.n <- tmp.OUTPUT[!is.na(as.numeric(SGPRankedSimexPARCC)), list(.N), keyby="TestCode"]
    cat("\n\n### Test of SGPRankedSimexPARCC:\n", file = out.file, append=TRUE)
    capture.output(tmp.simex.parcc[tmp.simex.parcc.n], file = out.file, append=TRUE)

    ###   BASELINE - New for 2021
    tmp.baseline.state <- tmp.OUTPUT[, as.list(summary(as.numeric(StudentGrowthPercentileComparedtoStateBaseline))), keyby="TestCode"]
    tmp.baseline.state.n <- tmp.OUTPUT[, list(.N), keyby="TestCode"]
    cat("\n\n### Test of StudentGrowthPercentileComparedtoStateBaseline:\n", file = out.file, append=TRUE)
    tmp.tbl <- tmp.baseline.state[tmp.baseline.state.n]
    if (nrow(na.omit(tmp.tbl)) > 0) {
      setnames(tmp.tbl, "NA's", "NAs")
      tmp.tbl[, SGP_Calc_Pct := round(((N - NAs)/N)*100, 1)]
      capture.output(tmp.tbl, file = out.file, append=TRUE)
    } else cat("\n\t\t No state-level baseline SGPs calculated:\n", file = out.file, append=TRUE)

    tmp.simexbaseline.state <- tmp.OUTPUT[, as.list(summary(as.numeric(SGPRankedSimexStateBaseline))), keyby="TestCode"]
    tmp.simexbaseline.state.n <- tmp.OUTPUT[, list(.N), keyby="TestCode"]
    cat("\n\n### Test of SGPRankedSimexStateBaseline:\n", file = out.file, append=TRUE)
    tmp.tbl <- tmp.simexbaseline.state[tmp.simexbaseline.state.n]
    if (nrow(na.omit(tmp.tbl)) > 0) {
      setnames(tmp.tbl, "NA's", "NAs")
      tmp.tbl[, SGP_Calc_Pct := round(((N - NAs)/N)*100, 1)]
      capture.output(tmp.tbl, file = out.file, append=TRUE)
    } else cat("\n\t\t No state-level SIMEX adjusted baseline SGPs calculated:\n", file = out.file, append=TRUE)

    tmp.baseline.parcc <- tmp.OUTPUT[, as.list(summary(as.numeric(StudentGrowthPercentileComparedtoPARCCBaseline))), keyby="TestCode"]
    tmp.baseline.parcc.n <- tmp.OUTPUT[, list(.N), keyby="TestCode"]
    cat("\n\n### Test of StudentGrowthPercentileComparedtoPARCCBaseline:\n", file = out.file, append=TRUE)
    tmp.tbl <- tmp.baseline.parcc[tmp.baseline.parcc.n]
    if (nrow(na.omit(tmp.tbl)) > 0) {
      setnames(tmp.tbl, "NA's", "NAs")
      tmp.tbl[, SGP_Calc_Pct := round(((N - NAs)/N)*100, 1)]
      capture.output(tmp.tbl, file = out.file, append=TRUE)
    } else cat("\n\t\t No consortium baseline SGPs calculated:\n", file = out.file, append=TRUE)

    tmp.simexbaseline.parcc <- tmp.OUTPUT[, as.list(summary(as.numeric(SGPRankedSimexPARCCBaseline))), keyby="TestCode"]
    tmp.simexbaseline.parcc.n <- tmp.OUTPUT[, list(.N), keyby="TestCode"]
    cat("\n\n### Test of SGPRankedSimexPARCCBaseline:\n", file = out.file, append=TRUE)
    tmp.tbl <- tmp.simexbaseline.parcc[tmp.simexbaseline.parcc.n]
    if (nrow(na.omit(tmp.tbl)) > 0) {
      setnames(tmp.tbl, "NA's", "NAs")
      tmp.tbl[, SGP_Calc_Pct := round(((N - NAs)/N)*100, 1)]
      capture.output(tmp.tbl, file = out.file, append=TRUE)
    } else cat("\n\t\t No consortium SIMEX adjusted baseline SGPs calculated:\n", file = out.file, append=TRUE)

    cat(paste("\n###   END ", state, "Output Validation   ###\n\n"), file = out.file, append=TRUE)
    gc()
}
