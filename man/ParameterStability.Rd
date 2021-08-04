\name{ParameterStability}
\alias{ParameterStability}
\title{
Parameter Stability Graphic
}
\description{
Plots the middle detail level of the changepoint parameter stability according to the influence measure.
}
\usage{
ParameterStability(influence,original.mean=NULL,digits=6,ylab='',xlab='Index',
  cpt.col='red',cpt.width=3,...)
}
\arguments{
  \item{influence}{
	The influence as calculated the \code{influence()} function provided within this package.  This is a list object.
}
  \item{original.mean}{
	A vector, \emph{length n}, of the mean under the original segmentation at each timepoint.
}
  \item{digits}{
  The number of significant figures to round the mean values to before plotting.  (Purely to reduce the number of points plotted to make the graphics smaller for storage and loading)
  }
  \item{ylab, xlab}{
	The labels for the x- and y-axis, character vector expected.
}
  \item{cpt.col}{
  Colour of the original parameter vector when plotted. Any values accepted by the \code{col} plotting argument are allowed.
}
  \item{cpt.width}{
  Width of the original parameter vector when plotted. Any values accepted by the \code{lwd} plotting argument are allowed.
}
  \item{...}{
  Any other arguments to be passed to the \code{plot()} function.
  }
}
\details{
	This function creates a more granular graphic to display the results of a changepoint influence analysis on the estimated segment parameter.  The graphic depicts the observed segment parameters under the "delete" or "outlier" Influence analysis.  The intensity of the grey denotes how often that parameter values was seen across all segmentations.  We overlay this with the original segment parameters.
}
\value{
  The function returns a plot (silently).
}
\references{
Wilms I, Killick R, Matteson DS (2021) Graphical Influence Diagnostics for Changepoint Models, \emph{ArxiV: 2107.10572}}
\author{
Rebecca Killick
}


\seealso{
\code{\link{influence}}, \code{\link{StabilityOverview}},\code{\link{LocationStability}},\code{\link{InfluenceMap}}
}
\examples{
#### Generate Simulated data example ####
set.seed(30)
x=c(rnorm(50),rnorm(50,mean=5),rnorm(1,mean=15),rnorm(49,mean=5),rnorm(50,mean=4))
xcpt = cpt.mean(x,method='PELT') # Get the changepoints via PELT

#### Get the influence for both delete and outlier options ####
x.inf = influence(xcpt)


#### Parameter Stability plot ####
ParameterStability(x.inf, original.mean = rep(param.est(xcpt)$mean, 
  times=diff(c(0,xcpt@cpts))), las = 1)
# note that the original mean is an n length vector and you can use the above code 
# to get this from the original changepoint locations.
}

\keyword{methods}
\keyword{models}
\keyword{influence}
\keyword{changepoint}
\keyword{segmentation}
\keyword{plot}