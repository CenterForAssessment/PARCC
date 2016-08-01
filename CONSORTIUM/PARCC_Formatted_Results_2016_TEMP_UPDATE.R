###################################################################################
###
### Temporary update of output to correct for missing value and low N flags
###
###################################################################################

### Load packages

require(data.table)


setwd("Data")

tmp.states <- c("CO", "DC", "IL", "MA", "MD", "NJ", "NM", "RI")

for (state.iter in tmp.states) {
    system(paste("unzip PARCC", state.iter, "2015-2016_SGP-Results_20160723.csv.zip", sep="_"))
    tmp <- fread(paste("PARCC", state.iter, "2015-2016_SGP-Results_20160723.csv", sep="_"))
    tmp.table <- tmp[,list(NON_MISSING_STATE_SGPs=sum(!is.na(StudentGrowthPercentileComparedtoState)), NON_MISSING_PARCC_SGPs=sum(!is.na(StudentGrowthPercentileComparedtoPARCC)), COUNT=.N), keyby=TestCode]
    tmp.table.to.change <- tmp.table[NON_MISSING_STATE_SGPs==0 & NON_MISSING_PARCC_SGPs>0]
    if (dim(tmp.table.to.change)[1] > 0) tmp[,StudentGrowthPercentileComparedtoState:=as.character(StudentGrowthPercentileComparedtoState)]
    for (test.code.iter in tmp.table.to.change$TestCode) {
        tmp[TestCode==test.code.iter & SGPPreviousTestCodePARCC!="", StudentGrowthPercentileComparedtoState:="<1000"]
    }
    fwrite(tmp, paste("PARCC", state.iter, "2015-2016_SGP-Results_20160730.csv", sep="_"), quote=FALSE, na="NA")

}
