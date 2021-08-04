################################################
############ Well Log Examples #################
################################################

library(changepoint.influence)

#### Load the data in the R package changepoint.influence ####
data(welldata)
welllog = welldata[1001:2000] # Extract the mid section of the data as analyzed in other papers
n = length(welllog)
var = NULL; for (i in 30:1000){var[i]=var(welllog[(i-29):i])} # rescale the data to have unit variance
welllogs = welllog/sqrt(median(var, na.rm = T))

#### Apply PELT to the welllog data ####
out.PELT = cpt.mean(welllogs, method = 'PELT')

#### Stability Dashboards ####
welllogs.inf = influence(out.PELT)
StabilityOverview(welllogs, cpts(out.PELT), welllogs.inf, las = 1, 
                  legend.args = list(display = TRUE, x = "bottomright", y = NULL, cex = 1.5, bty = "n", horiz = FALSE, xpd = FALSE), ylab = 'Nuclear-Magnetic Response') 

#### Location Stability plot ####
LocationStability(cpts(out.PELT), welllogs.inf, type = 'Difference', cpt.lwd = 4, las = 1)

#### Parameter Stability plot ####
ParameterStability(welllogs.inf, original.mean = rep(param.est(out.PELT)$mean, times=diff(c(0,out.PELT@cpts))), las = 1, ylab = 'Nuclear-Magnetic Response')

#### Influence Map ####

welllogs.inf = influence(out.PELT, method = "delete")
InfluenceMap(cpts(out.PELT), welllogs.inf, data = welllogs, include.data = T,
             ylab = 'Nuclear-Magnetic\n Response')

welllogs.inf = influence(out.PELT, method = "outlier")
InfluenceMap(cpts(out.PELT), welllogs.inf, data = welllogs, include.data = T, 
             ylab='Nuclear-Magnetic\n Response')





################################################
############ Simulated Examples ################
################################################

#### Generate Simulated data example ####
set.seed(30)
x = c(rnorm(50), rnorm(50, mean = 5), rnorm(1, mean = 15), rnorm(49, mean = 5), rnorm(50, mean = 4))
xcpt = cpt.mean(x,method='PELT') # Get the changepoints via PELT

#### Stability Dashboard ####
x.inf = influence(xcpt)
StabilityOverview(x, cpts(xcpt), x.inf, las=1, 
                  legend.args = list(display = TRUE, x ="topright", y = NULL, cex = 1.5, bty = "n", horiz = FALSE, xpd = FALSE)) 


#### Location Stability plot ####
LocationStability(cpts(xcpt), type = 'Difference', x.inf, cpt.lwd = 4, las = 1)

#### Parameter Stability plot ####
ParameterStability(x.inf, original.mean = rep(param.est(xcpt)$mean, times=diff(c(0,xcpt@cpts))), las = 1)

#### Influence Map ####
x.inf = influence(xcpt, method = "delete")
InfluenceMap(cpts(xcpt), x.inf, data = x, include.data = T)
x.inf = influence(xcpt, method = "outlier")
InfluenceMap(cpts(xcpt), x.inf, data=x, include.data = T)