\name{StabilityOverview}
\alias{StabilityOverview}
\title{
Stability Overview Graphic
}
\description{
Plots the overview of the stability according to the influence measure.
}
\usage{
StabilityOverview(data, original.cpts, influence,cpt.lwd=2,
  cpt.col=c("#009E73", "#E69F00", "#E41A1C"),cpt.lty=c("dashed","dotdash","dotted"),
  ylab=' ',xlab='Index', legend.args=list(display=TRUE,x="left",y=NULL,cex = 1,bty="n",
  horiz=TRUE,xpd=FALSE), ...)
}
\arguments{
  \item{data}{
	A vector containing the data on which you have run your changepoint method.
}
  \item{original.cpts}{
	An ordered vector of the changepoint locations found by your favourite changepoint method.
}
  \item{influence}{
	The influence as calculated the \code{influence()} function provided within this package.  This is a list object.
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
  \item{legend.args}{
	These arguments are passed to the \code{legend()} function to control the legend position etc..
}
  \item{...}{
  Any other arguments to be passed to the \code{plot()} function.
  }
}
\details{
	This function creates a first summary graphic to display the results of a changepoint influence analysis.  The graphic is a plot of the original data with the changepoints as vertical lines at their respective positions.  The colour and line type of the changepoint vertical lines reflect their stability.  The first value of their arguments denotes a stable changepoint - which appears at the same location in all influence segmentations.  The second argument denotes an unstable changepoint - which doesn't appear at the same location in all influence segmentations, either it moves or is deleted. The third argument denotes changepoint locations which are deemed outliers as two changepoints occur at consecutive locations (surrounding the outlying observation).
}
\value{
  The function returns a plot and a list containing the labels of the \code{original.cpts} as either "stable", "unstable", or "outlier".
}
\references{
Wilms I, Killick R, Matteson DS (2022) Graphical Influence Diagnostics for Changepoint Models, \emph{Journal of Computational and Graphical Statistics},  \bold{31:3}, 753--765 \emph{DOI: 10.1080/10618600.2021.2000873}}
\author{
Rebecca Killick
}


\seealso{
\code{\link{influence-methods}}, \code{\link{LocationStability}},\code{\link{ParameterStability}},\code{\link{InfluenceMap}}
}
\examples{
#### Generate Simulated data example ####
set.seed(30)
x=c(rnorm(50),rnorm(50,mean=5),rnorm(1,mean=15),rnorm(49,mean=5),rnorm(50,mean=4))
xcpt = cpt.mean(x,method='PELT') # Get the changepoints via PELT

#### Get the influence for both delete and outlier options ####
x.inf = influence(xcpt)


#### Stability Dashboard ####
StabilityOverview(x,cpts(xcpt),x.inf,las=1,
  legend.args=list(display=TRUE,x="topright",y=NULL,cex=1.5,bty="n",horiz=FALSE,xpd=FALSE))


}

\keyword{methods}
\keyword{models}
\keyword{influence}
\keyword{changepoint}
\keyword{segmentation}
\keyword{plot}