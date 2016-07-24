#######################################################################
###
### Script to validate output
###
#######################################################################

cat("#########################################\n", file="OUTPUT_VALIDATION.out")
cat("######### PARCC OUTPUT VALIDATION #######\n", file="OUTPUT_VALIDATION.out", append=TRUE)
cat("#########################################\n", file="OUTPUT_VALIDATION.out", append=TRUE)

### Load packages

require(data.table)


### Working directory

tmp.wd <- getwd()
tmp.states <- c("Colorado", "Illinois", "Maryland", "Massachusetts", "New_Jersey", "New_Mexico", "Rhode_Island", "Washington_DC")
tmp.states.abb <- c("CO", "IL", "MD", "MA", "NJ", "NM", "RI", "DC")

### Loop over states

for (iter in seq_along(tmp.states)) {
    setwd(file.path(tmp.states[iter], "Data/Base_Files/"))
    tmp.file.name <- tail(grep(paste("PARCC_", tmp.states.abb[iter], "_2015-2016_SGPO", sep=""), list.files(), value=TRUE), 1)
    system(paste("unzip", tmp.file.name))
    tmp.ORIGINAL <- fread(sub(".zip", "", tmp.file.name))
    setkey(tmp.ORIGINAL, PARCCStudentIdentifier)
    unlink(sub(".zip", "", tmp.file.name))
    setwd(file.path(tmp.wd, "CONSORTIUM/Data"))
    system(paste("unzip PARCC_", tmp.states.abb[iter], "_2015-2016_SGP-Results_20160723.csv.zip", sep=""))
    tmp.OUTPUT <- fread(paste("PARCC_", tmp.states.abb[iter], "_2015-2016_SGP-Results_20160723.csv", sep=""))
    setkey(tmp.OUTPUT, PARCCStudentIdentifier)
    unlink(paste("PARCC_", tmp.states.abb[iter], "_2015-2016_SGP-Results_20160723.csv", sep=""))
    setwd(tmp.wd)

    cat(paste("\n\n\n###", tmp.states[iter], "Output Validation ###\n"), file="OUTPUT_VALIDATION.out", append=TRUE)

    ### TEST for identical PARCCStudentIdentifier

    tmp.tf <- identical(tmp.OUTPUT$PARCCStudentIdentifier, tmp.ORIGINAL$PARCCStudentIdentifier)
    cat(paste("\n### Test for Identical PARCCStudentIdentifier in BASE and OUTPUT files:", tmp.tf), file="OUTPUT_VALIDATION.out", append=TRUE)

    tmp.sgp.state <- paste(as.character(summary(tmp.OUTPUT$StudentGrowthPercentileComparedtoState)), collapse=" ")
    cat(paste("\n### Test of StudentGrowthPercentileComparedtoState:", tmp.sgp.state), file="OUTPUT_VALIDATION.out", append=TRUE)

    tmp.sgp.parcc <- paste(as.character(summary(tmp.OUTPUT$StudentGrowthPercentileComparedtoPARCC)), collapse=" ")
    cat(paste("\n### Test of StudentGrowthPercentileComparedtoPARCC:", tmp.sgp.parcc), file="OUTPUT_VALIDATION.out", append=TRUE)

    gc()
}
