###############################################################################
###                                                                         ###
###              New Meridian 2022 -- Fix nameing of BASELINE               ###
###              * Includes 2019 consecutive-year baselines *               ###
###                                                                         ###
###############################################################################


###   Load packages
require(SGP)
require(data.table)

###   Load data
load( "./PARCC/Data/Archive/2021_2022.2/PARCC_SGP.Rdata")
# load("./New_Jersey/Data/Archive/2021_2022.2/New_Jersey_SGP.Rdata")
# load("./Illinois/Data/Archive/2021_2022.2/Illinois_SGP.Rdata")
# load("./Bureau_of_Indian_Education/Data/Archive/2021_2022.2/Bureau_of_Indian_Education_SGP.Rdata")
# load("./Department_Of_Defense/Data/Archive/2021_2022.2/Department_of_Defense_SGP.Rdata")

prior_data <- PARCC_SGP@Data[YEAR != "2021_2022.2",]
PARCC_SGP@Data <- PARCC_SGP@Data[YEAR == "2021_2022.2",]

###   Remove the "CONFIDENCE_BOUND" and "STANDARD_ERROR" variables in Baselines
##    Not returned to Pearson and not used in any post-analyses.

orig.cols <- ncol(PARCC_SGP@Data)

baseline.names <- grep("BASELINE", names(PARCC_SGP@Data), value = TRUE)
# baseline.names <- baseline.names[grepl("_SKIP_YEAR", baseline.names)]
addl.vars.to.rm <-
    baseline.names[grepl("CONFIDENCE_BOUND|STANDARD_ERROR", baseline.names)]

current.sgp.vars <-
    c("SGP", "SGP_0.05_CONFIDENCE_BOUND",
      "SGP_0.95_CONFIDENCE_BOUND", "SGP_STANDARD_ERROR",
      "SGP_ORDER_1", "SGP_ORDER_1_0.05_CONFIDENCE_BOUND",
      "SGP_ORDER_1_0.95_CONFIDENCE_BOUND", "SGP_ORDER_1_STANDARD_ERROR",
      "SGP_ORDER_2", "SGP_ORDER_2_0.05_CONFIDENCE_BOUND",
      "SGP_ORDER_2_0.95_CONFIDENCE_BOUND", "SGP_ORDER_2_STANDARD_ERROR",
      "SGP_SIMEX_RANKED", "SGP_SIMEX_RANKED_ORDER_1", "SGP_SIMEX_RANKED_ORDER_2",
      "SGP_TARGET_3_YEAR", "SGP_TARGET_3_YEAR_CONTENT_AREA",
      "SGP_BASELINE", "SGP_SIMEX_BASELINE", "SGP_TARGET_BASELINE_3_YEAR"
    )

all(current.sgp.vars %in% names(PARCC_SGP@Data))

vars.to.remove <- c(current.sgp.vars, addl.vars.to.rm)

prior_data[, (addl.vars.to.rm) := NULL]
PARCC_SGP@Data[, (vars.to.remove) := NULL]

##  Remove from @SGP slot as well
baseline.sgps <- grep(".BASELINE", names(PARCC_SGP@SGP[["SGPercentiles"]]))

for (bline in baseline.sgps) {
    slot.vars.to.rm <- 
        grep("CONFIDENCE_BOUND|STANDARD_ERROR",
             names(PARCC_SGP@SGP[["SGPercentiles"]][[bline]]),
             value = TRUE
        )
    if (length(slot.vars.to.rm)) {
        PARCC_SGP@SGP[["SGPercentiles"]][[bline]][, (slot.vars.to.rm) := NULL]
    }
}

gc()

PARCC_SGP <-
    combineSGP(sgp_object = PARCC_SGP)

PARCC_SGP@Data <-
    rbindlist(
        list(prior_data,
             PARCC_SGP@Data
        ),
        fill = TRUE
    )

outputSGP(
    sgp_object = PARCC_SGP,
    outputSGP.directory = "./PARCC/Data/Archive/2021_2022.2",
    output.type = c("LONG_Data", "LONG_FINAL_YEAR_Data")
)

save(PARCC_SGP, file = "./PARCC/Data/Archive/2021_2022.2/PARCC_SGP.Rdata")
# save(New_Jersey_SGP, file = "./New_Jersey/Data/Archive/2021_2022.2/New_Jersey.Rdata")
# save(Illinois_SGP, file = "./Illinois/Data/Archive/2021_2022.2/Illinois_SGP.Rdata")
# save(Bureau_of_Indian_Education_SGP,
#      file = "./Bureau_of_Indian_Education/Data/Archive/2021_2022.2/Bureau_of_Indian_Education_SGP.Rdata"
# )
# save(Department_Of_Defense_SGP,
#      file = "./Department_Of_Defense/Data/Archive/2021_2022.2/Department_Of_Defense_SGP.Rdata"
# )

rm(PARCC_SGP); gc()