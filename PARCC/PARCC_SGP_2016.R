#########################################################################
###
### SGP analysis script for PARCC consortium
###
#########################################################################

### Load Packages

require(SGP)


### Load Data




### abcSGP

PARCC_SGP <- abcSGP(
		PARCC_Data_LONG,
		steps=c("prepareSGP", "analyzeSGP", "combineSGP", "visualizeSGP", "outputSGP"),
		sgp.percentiles=TRUE,
		sgp.projections=TRUE,
		sgp.projections.lagged=TRUE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline=FALSE,
		sgp.projections.lagged.baseline=FALSE,
		calculate.simex=TRUE,
		save.intermediate.results=TRUE,
		get.cohort.data.info=TRUE,
		parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=4, PROJECTIONS=4, LAGGED_PROJECTIONS=4, SGP_SCALE_SCORE_TARGETS=4)))


### Save results

save(PARCC_SGP, file="Data/PARCC_SGP.Rdata")

