\name{LocationStability}
\alias{LocationStability}
\title{
Location Stability Graphic
}
\description{
Plots the middle detail level of the changepoint location stability according to the influence measure.
}
\usage{
LocationStability(original.cpts, influence, expected.class=NULL,
  type=c("Difference","Global","Local"),data=NULL,include.data=FALSE,cpt.lwd=4,
  cpt.col=c("#009E73", "#E69F00", "#E41A1C"),cpt.lty=c("dashed","dotdash","dotted"),
  ylab='',xlab='Index',...)
}
\arguments{
  \item{original.cpts}{
	An ordered vector of the changepoint locations found by your favourite changepoint method.
}
  \item{influence}{
	The influence as calculated the \code{influence()} function provided within this package.  This is a list object.
}
  \item{expected.class}{
  Only needed for \code{type="Difference"}.  An nxn matrix containing the expected class of each datapoint from the \code{original.cpts} segmentation under perturbation of each datapoint.  If this is left as \code{NULL} and \code{type="Difference"}, it will be calculated and returned to the user.
  }
  \item{type}{
  The type of Location Stability plot, can be \code{"Difference"}, \code{"Global"} or \code{"Local"}.  If all three are listed (as in the default) then three graphs will be plotted.  \code{type="Difference"} will histogram the difference between the observed and expected segmentations at each of the datapoints. \code{type="Global"} will histogram the observed segmentations. \code{type="Local"} will histogram the observed segmentations with the \code{original.cpts} locations removed.  See details for more description of the graphics.
  }
  \item{data}{
	A vector containing the data on which you have run your changepoint method.
}
  \item{include.data}{
  Is a plot of the data to be included above the histogram.  Default is \code{FALSE}.
  }
  \item{cpt.lwd}{
	The line width to be used when plotting the \code{original.cpts} on the \code{data}. Standard \code{lwd} values allowed. A single value is expected.
}
  \item{cpt.col}{
  Colour of the \code{original.cpts} lines when plotted.  We need three colours specified here, corresponding to the "stable", "unstable" and "outlier" categories respectively. Any values accepted by the \code{col} plotting argument are allowed.
}
  \item{cpt.lty}{
  Line type of the \code{original.cpts} lines when plotted.  We need three line types specified here, corresponding to the "stable", "unstable" and "outlier" categories respectively.  Any values accepted by the \code{lty} plotting argument are allowed.
}
  \item{ylab, xlab}{
	The labels for the x- and y-axis, character vector expected.
}
  \item{...}{
  Any other arguments to be passed to the \code{plot()} or equivalently \code{hist()} function.
  }
}
\details{
	This function creates a more granular graphic to display the results of a changepoint influence analysis on the location of the changepoints.  The graphic is a histogram of the observed segmentations under the "delete" or "outlier" Influence analysis.  The colour and line type of the bars at the \code{original.cpts} locations reflect their stability.  The first value of their arguments denotes a stable changepoint - which appears at the same location in all influence segmentations.  The second argument denotes an unstable changepoint - which doesn't appear at the same location in all influence segmentations, either it moves or is deleted. The third argument denotes changepoint locations which are deemed outliers as two changepoints occur at consecutive locations (surrounding the outlying observation).  Please note that the \code{type="Global"} only uses colour and not line type.
	
	\code{type="Difference"} gives the difference between the observed and expected changepoint segmentations under the "delete" or "outlier" Influence analysis.  A positive value can only occur where a changepoint is contained in the observed segmentations but is not present in the expected (an additional changepoint time).  A negative value can only occur at the original changepoint location where the changepoint is not present in atleast one of the observed segmentations.  Note that the expected segmentations take into account the fact that a changepoint at a timepoint, say 100, will move (to 99) when a timepoint prior to it is deleted.
	
	\code{type="Global"} histograms the observed segmentations.  Colour is added to the original changepoint locations and a horizontal (light grey) line is added to the plot to denote the maximum count.  Any original changepoint bars that do not meet this grey line indicates that the changepoint is unstable as it either moves or is deleted in atleast one of the observed segmentations.  For large datasets this can be difficult to view what is going on at any locations that appear as black bars as these are typically small counts.  Hence the inclusion of the "Local" option.
	
	\code{type="Local"} histograms the observed segmentations with the original changepoint locations removed.  This is to allow users to see the smaller counts that can be masked in larger datasets.  These are the locations where either original changepoints move to or additional changepoints are added.
}
\value{
  The function returns plot(s) and a list containing the labels of the \code{original.cpts} as either "stable", "unstable", or "outlier".  If \code{type="Difference"} and \code{expected.class=NULL} then the expected class is also returned as the first element of the list.
}
\references{
Wilms I, Killick R, Matteson DS (2021) Graphical Influence Diagnostics for Changepoint Models, \emph{ArxiV: 2107.10572}}
\author{
Rebecca Killick
}


\seealso{
\code{\link{influence}}, \code{\link{StabilityOverview}},\code{\link{ParameterStability}},\code{\link{InfluenceMap}}
}
\examples{
#### Generate Simulated data example ####
set.seed(30)
x = c(rnorm(50), rnorm(50, mean = 5), rnorm(1, mean = 15), rnorm(49, mean = 5), rnorm(50, mean = 4))
xcpt = cpt.mean(x,method='PELT') # Get the changepoints via PELT

#### Get the influence for both delete and outlier options ####
x.inf = influence(xcpt)


#### Location Stability Difference plot ####
exp.class=LocationStability(cpts(xcpt), type = 'Difference', x.inf, cpt.lwd = 4, las = 1)
# note that the expected.class is also returned

#### Location Stability Global plot ####
exp.class=LocationStability(cpts(xcpt), type = 'Global', x.inf, cpt.lwd = 4, las = 1)

#### Location Stability Local plot ####
exp.class=LocationStability(cpts(xcpt), type = 'Local', x.inf, cpt.lwd = 4, las = 1)
}

\keyword{methods}
\keyword{models}
\keyword{influence}
\keyword{changepoint}
\keyword{segmentation}
\keyword{plot}