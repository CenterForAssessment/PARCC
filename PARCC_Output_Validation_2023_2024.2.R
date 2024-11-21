###############################################################################
###                                                                         ###
###                Validate Spring 2024 Consortia SGP output                ###
###                                                                         ###
###############################################################################

out.file <-
    file.path(
        # "/home/avi/Sync/Center/Github_Repos/Projects/PARCC/",
        "/Users/avi/SGP Dropbox/Adam Van Iwaarden/Github_Repos/Projects/PARCC/",
        "PARCC_Output_Validation_2023_2024.2.out")

cat("#########################################################################\n", file = out.file)
cat("###                    CONSORTIA OUTPUT VALIDATION                    ###\n", file = out.file, append = TRUE)
cat("#########################################################################\n", file = out.file, append = TRUE)

###   Load packages
require(data.table)

###   Set working directory to top level directory (PARCC) and Identify States
tmp.states <-
    c("Bureau_of_Indian_Education",
      "Department_Of_Defense",
      "Illinois",
      "New_Jersey",
      "Washington_DC"
    )

####  Function to read in individual state files
read.parcc <- function(state, tag, var_num) {
  tmp.wd <- getwd()
  tmp.dir <- "Data/Pearson"
  tmp.files <- list.files(file.path(state, tmp.dir))
  if (any(grepl(".xls", tmp.files))) tmp.files <- tmp.files[-grep(".xls", tmp.files)]
  my.file <- gsub(".zip",  "", grep(tag, tmp.files, value = TRUE)) |> unique()

  if (any(grepl(".zip", grep(tag, tmp.files, value = TRUE)))) {
      setwd(tempdir())
      system(paste0("unzip '", file.path(tmp.wd, state, tmp.dir, paste0(my.file, ".zip")), "'"))
      TMP <- fread(my.file, sep = ",", colClasses = rep("character", var_num))
      unlink(my.file, recursive = TRUE)
      setwd(tmp.wd)
      return(TMP)
  } else {
      return(fread(file.path(state, tmp.dir, my.file),
                   sep = ",", colClasses = rep("character", var_num)))
  }
}

###   Loop over states
for (state in tmp.states) {
    var.num <-
      ifelse(
        state %in% c("Bureau_of_Indian_Education", "Department_Of_Defense", "Washington_DC"),
        93, 90
      )
    if (state == "Bureau_of_Indian_Education")
        tmp.ORIGINAL <-
            fread("./Bureau_of_Indian_Education/Data/Base_Files/bi_24_biespr24_SGPO_20240724-2137.csv",
                  colClasses = rep("character", var.num))
     if (state == "Department_Of_Defense")
        tmp.ORIGINAL <-
            fread("./Department_Of_Defense/Data/Base_Files/pcspr24_state_Student_Growth_20240605201928380746.csv.gz",
                  colClasses = rep("character", var.num))
    if (state == "Illinois")
        tmp.ORIGINAL <-
            fread("./Illinois/Data/Base_Files/PARCC_IL_2023-2024_SGPO_D20240516.csv.gz",
                  colClasses = rep("character", var.num))
    if (state == "Washington_DC")
        tmp.ORIGINAL <-
            fread("./Washington_DC/Data/Base_Files/dc_24_dcspr24_SGPO_20240708-1557.csv.gz",
                  colClasses = rep("character", var.num))
    if (state == "New_Jersey")
        tmp.ORIGINAL <-
            fread("./New_Jersey/Data/Base_Files/PARCC_NJ_2023-2024_SGPO_D20240704.csv.gz",
                  colClasses = rep("character", var.num))

    ##  `tmp.OUTPUT` for individual (STATE_LEVEL only) results
    # tmp.OUTPUT <-
    #     fread(
    #         # "./Illinois/Data/Pearson/PARCC_IL_2023-2024_Spring_SGP-STATE_LEVEL_Results_20240530.csv.zip",
    #         # "./New_Jersey/Data/Pearson/PARCC_NJ_2023-2024_Spring_SGP-STATE_LEVEL_Results_20240719.csv.zip",
    #         "./Washington_DC/Data/Pearson/PARCC_DC_2023-2024_Spring_SGP-STATE_LEVEL_Results_20240724.csv.zip",
    #         sep = ",", colClasses = rep("character", var.num))
    tmp.OUTPUT <-
        read.parcc(state, "2023-2024_Spring_SGP-Results_20240822", var.num)
    if (state == "Washington_DC") {
        stu.id <- "StudentIndentifier"
    } else if (state == "Bureau_of_Indian_Education") {
        stu.id <- "StudentIdentifier"
    } else {
        stu.id <- "PANUniqueStudentID"
    }
    setkeyv(tmp.ORIGINAL, c(stu.id, "TestCode", "IRTTheta"))
    setkeyv(tmp.OUTPUT, c(stu.id, "TestCode", "IRTTheta"))

    cat(paste("\n\n\t\t\t###       ", state, "Output Validation       ###\n"),
        file = out.file, append = TRUE)

    ###   TEST for identical file names
    tmp.tf <- identical(names(tmp.OUTPUT), names(tmp.ORIGINAL))
    cat(paste("\n###   TEST for Identical Variable Names in BASE and OUTPUT files:", tmp.tf),
        file = out.file, append = TRUE)
    if (!tmp.tf) {
        if (!all(names(tmp.ORIGINAL) %in% names(tmp.OUTPUT))) {
            cat(paste("\n\n\t\tNames in BASE missing in OUTPUT:\n\t\t\t"), file = out.file, append = TRUE)
            cat(paste(names(tmp.ORIGINAL)[!names(tmp.ORIGINAL) %in% names(tmp.OUTPUT)], collapse = ", \n\t\t\t"),
                file = out.file, append = TRUE)
        }
        if(!all(names(tmp.OUTPUT) %in% names(tmp.ORIGINAL))) {
            cat(paste("\n\n\t\tNames in OUTPUT added to BASE:\n\t\t\t"), file = out.file, append = TRUE)
            cat(paste(names(tmp.OUTPUT)[!names(tmp.OUTPUT) %in% names(tmp.ORIGINAL)], collapse = ", \n\t\t\t"),
                file = out.file, append = TRUE)
        }
    }
    ###   TEST for identical PANUniqueStudentID
    tmp.tf <- identical(tmp.OUTPUT[, ..stu.id], tmp.ORIGINAL[, ..stu.id])
        # if (state == "Washington_DC") {
        #     identical(tmp.OUTPUT$StudentIndentifier, tmp.ORIGINAL$StudentIndentifier)
        # } else if (state == "Bureau_of_Indian_Education") {
        #     identical(tmp.OUTPUT$StudentIdentifier, tmp.ORIGINAL$StudentIdentifier)
        # } else {
        #     identical(tmp.OUTPUT$PANUniqueStudentID, tmp.ORIGINAL$PANUniqueStudentID)
        # }
    cat(paste("\n###   TEST for Identical Student ID in BASE and OUTPUT files:", tmp.tf),
        file = out.file, append = TRUE)

    ###   TEST for identical IRTTheta
    tmp.tf <- identical(as.numeric(tmp.OUTPUT$IRTTheta), as.numeric(tmp.ORIGINAL$IRTTheta))
    cat(paste("\n###   TEST for Identical IRTTheta in BASE and OUTPUT files:", tmp.tf),
        file = out.file, append = TRUE)

    ###   TEST of State SGPs
    tmp.sgp.state <- tmp.OUTPUT[,
        as.list(summary(as.numeric(StudentGrowthPercentileComparedtoState))),
        keyby = "TestCode"]
    tmp.sgp.state.n <- tmp.OUTPUT[, list(.N), keyby = "TestCode"]
    cat("\n\n###   TEST of StudentGrowthPercentileComparedtoState:\n",
        file = out.file, append = TRUE)
    # capture.output(tmp.sgp.state[tmp.sgp.state.n], file = out.file, append = TRUE)
    tmp.tbl <- tmp.sgp.state[tmp.sgp.state.n]
    if (nrow(na.omit(tmp.tbl)) > 0) {
        setnames(tmp.tbl, "NA's", "NAs")
        tmp.tbl[, SGP_Calc_Pct := round(((N - NAs)/N)*100, 1)]
        capture.output(tmp.tbl, file = out.file, append = TRUE)
    } else {
        cat("\n\t\tNo state-level SGPs calculated:\n",
            file = out.file, append = TRUE)
    }

    ###   TEST of State SGP SIMEX
    tmp.simex.state <- tmp.OUTPUT[,
        as.list(summary(as.numeric(SGPRankedSimexState))),
        keyby = "TestCode"]
    tmp.simex.state.n <- tmp.OUTPUT[, list(.N), keyby = "TestCode"]
    cat("\n\n###   TEST of SGPRankedSimexState:\n",
        file = out.file, append = TRUE)
    # capture.output(tmp.simex.state[tmp.simex.state.n], file = out.file, append = TRUE)
    tmp.tbl <- tmp.simex.state[tmp.simex.state.n]
    if (nrow(na.omit(tmp.tbl)) > 0) {
        setnames(tmp.tbl, "NA's", "NAs")
        tmp.tbl[, SGP_Calc_Pct := round(((N - NAs)/N)*100, 1)]
        capture.output(tmp.tbl, file = out.file, append = TRUE)
    } else {
        cat("\n\t\tNo state-level SIMEX SGPs calculated:\n",
            file = out.file, append = TRUE)
    }

    ###   TEST of Consortia SGPs
    tmp.sgp.parcc <- tmp.OUTPUT[,
        as.list(summary(as.numeric(StudentGrowthPercentileComparedtoConsortia))),
        keyby = "TestCode"]
    tmp.sgp.parcc.n <- tmp.OUTPUT[, list(.N), keyby = "TestCode"]
    cat("\n\n###   TEST of StudentGrowthPercentileComparedtoConsortia:\n",
        file = out.file, append = TRUE)
    # capture.output(tmp.sgp.parcc[tmp.sgp.parcc.n], file = out.file, append = TRUE)
    tmp.tbl <- tmp.sgp.parcc[tmp.sgp.parcc.n]
    if (nrow(na.omit(tmp.tbl)) > 0) {
        setnames(tmp.tbl, "NA's", "NAs")
        tmp.tbl[, SGP_Calc_Pct := round(((N - NAs)/N)*100, 1)]
        capture.output(tmp.tbl, file = out.file, append = TRUE)
    } else {
        cat("\n\t\tNo Consortia-level SGPs calculated:\n",
            file = out.file, append = TRUE)
    }

    ###   TEST of Consortia SGP SIMEX
    tmp.simex.parcc <- tmp.OUTPUT[,
        as.list(summary(as.numeric(SGPRankedSimexConsortia))), keyby = "TestCode"]
    tmp.simex.parcc.n <- tmp.OUTPUT[, list(.N), keyby = "TestCode"]
    cat("\n\n###   TEST of SGPRankedSimexConsortia:\n",
        file = out.file, append = TRUE)
    # capture.output(tmp.simex.parcc[tmp.simex.parcc.n], file = out.file, append = TRUE)
    tmp.tbl <- tmp.simex.parcc[tmp.simex.parcc.n]
    if (nrow(na.omit(tmp.tbl)) > 0) {
        setnames(tmp.tbl, "NA's", "NAs")
        tmp.tbl[, SGP_Calc_Pct := round(((N - NAs)/N)*100, 1)]
        capture.output(tmp.tbl, file = out.file, append = TRUE)
    } else {
        cat("\n\t\tNo Consortia-level SIMEX SGPs calculated:\n",
            file = out.file, append = TRUE)
    }

    ###   BASELINE - New for 2021
    ###   TEST of State Baseline SGPs
    tmp.baseline.state <- tmp.OUTPUT[,
        as.list(summary(as.numeric(StudentGrowthPercentileComparedtoStateBaseline))), keyby = "TestCode"]
    tmp.baseline.state.n <- tmp.OUTPUT[, list(.N), keyby = "TestCode"]
    cat("\n\n###   TEST of StudentGrowthPercentileComparedtoStateBaseline:\n",
        file = out.file, append = TRUE)
    tmp.tbl <- tmp.baseline.state[tmp.baseline.state.n]
    if (nrow(na.omit(tmp.tbl)) > 0) {
        setnames(tmp.tbl, "NA's", "NAs")
        tmp.tbl[, SGP_Calc_Pct := round(((N - NAs)/N)*100, 1)]
        capture.output(tmp.tbl, file = out.file, append = TRUE)
    } else {
        cat("\n\t\tNo state-level baseline SGPs calculated:\n",
            file = out.file, append = TRUE)
    }

    ###   TEST of State Baseline SGP SIMEX
    tmp.simexbaseline.state <- tmp.OUTPUT[,
        as.list(summary(as.numeric(SGPRankedSimexStateBaseline))), keyby = "TestCode"]
    tmp.simexbaseline.state.n <- tmp.OUTPUT[, list(.N), keyby = "TestCode"]
    cat("\n\n###   TEST of SGPRankedSimexStateBaseline:\n", file = out.file, append = TRUE)
    tmp.tbl <- tmp.simexbaseline.state[tmp.simexbaseline.state.n]
    if (nrow(na.omit(tmp.tbl)) > 0) {
        setnames(tmp.tbl, "NA's", "NAs")
        tmp.tbl[, SGP_Calc_Pct := round(((N - NAs)/N)*100, 1)]
        capture.output(tmp.tbl, file = out.file, append = TRUE)
    } else {
        cat("\n\t\tNo state-level SIMEX adjusted baseline SGPs calculated:\n",
            file = out.file, append = TRUE)
    }

    ###   TEST of Consortium Baseline SGPs
    tmp.baseline.parcc <- tmp.OUTPUT[,
        as.list(summary(as.numeric(StudentGrowthPercentileComparedtoConsortiaBaseline))), keyby = "TestCode"]
    tmp.baseline.parcc.n <- tmp.OUTPUT[, list(.N), keyby = "TestCode"]
    cat("\n\n###   TEST of StudentGrowthPercentileComparedtoConsortiaBaseline:\n",
        file = out.file, append = TRUE)
    tmp.tbl <- tmp.baseline.parcc[tmp.baseline.parcc.n]
    if (nrow(na.omit(tmp.tbl)) > 0) {
        setnames(tmp.tbl, "NA's", "NAs")
        tmp.tbl[, SGP_Calc_Pct := round(((N - NAs)/N)*100, 1)]
        capture.output(tmp.tbl, file = out.file, append = TRUE)
    } else {
        cat("\n\t\tNo consortium baseline SGPs calculated:\n",
            file = out.file, append = TRUE)
    }

    ###   TEST of Consortium Baseline SGP SIMEX
    tmp.simexbaseline.parcc <- tmp.OUTPUT[,
        as.list(summary(as.numeric(SGPRankedSimexConsortiaBaseline))), keyby = "TestCode"]
    tmp.simexbaseline.parcc.n <- tmp.OUTPUT[,
        list(.N), keyby = "TestCode"]
    cat("\n\n###   TEST of SGPRankedSimexConsortiaBaseline:\n",
        file = out.file, append = TRUE)
    tmp.tbl <- tmp.simexbaseline.parcc[tmp.simexbaseline.parcc.n]
    if (nrow(na.omit(tmp.tbl)) > 0) {
        setnames(tmp.tbl, "NA's", "NAs")
        tmp.tbl[, SGP_Calc_Pct := round(((N - NAs)/N)*100, 1)]
        capture.output(tmp.tbl, file = out.file, append = TRUE)
    } else {
        cat("\n\t\tNo consortium SIMEX adjusted baseline SGPs calculated:\n",
            file = out.file, append = TRUE)
    }

    cat(paste("\n\n\t\t\t###   END ", state, "Output Validation   ###\n"),
        file = out.file, append = TRUE)
    gc()
}
