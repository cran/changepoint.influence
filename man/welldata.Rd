\name{welldata}
\docType{data}
\alias{welldata}
\alias{welllog}
\title{
Welllog data
}
\description{
This data has been used in previous changepoint papers and is described and provided in "On-line inference for hidden Markov models via particle filters" by Fearnhead and Clifford in 2003.
The data consists of measurements of the nuclear magnetic response of underground rocks.

Please note that this is the original data.  The data analyzed in the majority of publications has been standardized and/or had the outliers removed.  Papers typically only analyze a portion of the 4050 vector too.
}
\usage{
welldata
}
\format{
	A vector of length 4050.
}
\source{https://doi.org/10.1111/1467-9868.00421}

\examples{
\donttest{
#### Load the data in the R package changepoint.influence ####
data("welldata")
welllog = welldata[1001:2000] 
# Extract the mid section of the data as analyzed in other papers
n = length(welllog)
var = NULL; for (i in 30:1000){var[i]=var(welllog[(i-29):i])} 
welllogs = welllog/sqrt(median(var, na.rm = TRUE)) 
# rescale the data to have unit variance across time, 
# note that there may still be changes in variance across the series.

#### Apply PELT to the welllog data ####
out.PELT = cpt.mean(welllogs, method = 'PELT')

#### Calculate the influence measures ####
welllogs.inf = influence(out.PELT) 
# the code extracts all the details of the original cpt.mean() function call
# and uses these in the calculation of the influence for the modified data.

#### Stability Dashboards ####
StabilityOverview(welllogs,cpts(out.PELT),welllogs.inf,las=1,ylab='Nuclear-Magnetic Response', 
    legend.args=list(display=TRUE,x="bottomright",y=NULL,cex=1.5,bty="n",horiz=FALSE,xpd=FALSE))
# We can specify where the legend will sit in the graphic via the legend.args 
# which are passed to the legend() function.  We can also include additional 
# arguments to pass to the plotting such as las=1 here.

#### Location Stability plot ####
exp.seg=LocationStability(cpts(out.PELT), welllogs.inf, type = 'Difference', cpt.lwd = 4, las = 1)
# Note that if the expected segmentation is not provided, it will be calcuated 
# and then returned so that the user can avoid calculating this again in other plot calls.

#### Parameter Stability plot ####
ParameterStability(welllogs.inf, original.mean = rep(param.est(out.PELT)$mean, 
  times=diff(c(0,out.PELT@cpts))), las = 1, ylab = 'Nuclear-Magnetic Response')
# Note that the original.mean argument is provided for each timepoint so is a length n vector.

#### Influence Map ####
welllogs.inf = influence(out.PELT, method = "delete")
inf.resid.del=InfluenceMap(cpts(out.PELT), welllogs.inf, data = welllogs, include.data = TRUE, 
  ylab = 'Nuclear-Magnetic\n Response')

welllogs.inf = influence(out.PELT, method = "outlier")
inf.resid.out=InfluenceMap(cpts(out.PELT), welllogs.inf, data = welllogs, include.data = TRUE, 
  ylab='Nuclear-Magnetic\n Response')
}
}
\keyword{datasets}
