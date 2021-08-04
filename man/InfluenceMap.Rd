\name{InfluenceMap}
\alias{InfluenceMap}
\title{
Influence Map Graphic
}
\description{
Plots the highest detail level of the changepoint location stability according to the influence measure.
}
\usage{
InfluenceMap(original.cpts, influence, resid=NULL,data=NULL,include.data=FALSE,
influence.col=c("#0C4479","white","#AB9783"),cpt.col=c("#009E73", "#E69F00", "#E41A1C"),
cpt.lty=c("dashed","dotdash","dotted"),ylab='',ggops=NULL)
}
\arguments{
  \item{original.cpts}{
	An ordered vector of the changepoint locations found by your favourite changepoint method.
}
  \item{influence}{
	The influence as calculated the \code{influence()} function provided within this package.  This is a list object.
}
  \item{resid}{
  An nxn matrix containing the difference of the observed class (\code{influence}) from the expected class at each datapoint.  If this is left as \code{NULL}, it will be calculated and returned to the user.
  }
  \item{data}{
	A vector containing the data on which you have run your changepoint method.
}
  \item{include.data}{
  Is a plot of the data to be included above the histogram.  Default is \code{FALSE}.
  }
  \item{influence.col}{
  A length 3 vector giving the lower, middle (0) and upper bounds for the influence map colour grading.  Note that you should choose these colours to not conflict with the colours used for \code{cpt.col}.  We advise using "white" for the middle choice as this provides a clean (majority white) heatmap.
  }
  \item{cpt.col}{
  Colour of the \code{original.cpts} lines when plotted.  We need three colours specified here, corresponding to the "stable", "unstable" and "outlier" categories respectively. These are plotted on the Influence Map as well as the original data if \code{include.data=TRUE}.  Any values accepted by the \code{col} plotting argument are allowed.
}
  \item{cpt.lty}{
  Line type of the \code{original.cpts} lines when plotted.  We need three line types specified here, corresponding to the "stable", "unstable" and "outlier" categories respectively.  Any values accepted by the \code{lty} plotting argument are allowed. Only used if \code{include.data=TRUE}.
}
  \item{ylab}{
	The label for the y-axis, character vector expected.
}
  \item{ggops}{
  Any other settings to be passed to the \code{ggplot()} function.  Note that you will need to \code{library(ggplot2)} if calling ggplot functions in arguments. See examples.
  }
}
\details{
	This function creates the highest detail graphic to display the results of a changepoint influence analysis on the location of the changepoints.  The graphic is an nxn heatmap of the difference between the observed segmentations under the "delete" or "outlier" Influence analysis and the expected segmentation.  Note that the expected segmentations take into account the fact that a changepoint at a timepoint, say 100, will move (to 99) when a timepoint prior to it is deleted and that adding an outlier will introduce new changepoints.
	
	Datapoints on  the  vertical  axis  without  a  single  coloured  co-ordinate  on  the  horizontal  axis  can  be considered as non-influential since they do not trigger any changepoint instability.  Rows with coloured pixels correspond to data points which are instability triggers.
	
How to interpret the Influence Map (please also read the paper in the references for fuller details):

\itemize{
\item{colouring:}{Colouring above the diagonal indicates that an al-teration of the corresponding data point (on the vertical axis) affects earlier data points,colouring below the diagonal indicates that subsequent data points are affected.}
\item{horizonal span:}{A stop in colouring indicates that change-points have moved, while a continuation of colouring to the last data point indicates that, in  total,  fewer  or  additional  changepoints  are  detected.}
\item{local vs global:}{Most colouring originates on the diagonal,thereby indicating that a data point's alteration mainly affects neighbouring data points that most often belong to the same segment.  By contrast, in some cases a coloured pixel may  originate  away  from  the  diagonal,  thereby  exercising  global  influence.}
\item{height:}{All data points (on the vertical axis) that appear in the  coloured area are influential and assert influence over the corresponding data points on the horizontal axis.  The height can be seen as the extent to which instability arises in this influential region.}
}
}
\value{
  The function returns a plot denoted the Influence Map. If \code{resid=NULL} then the residuals (observed class - expected class) are also returned.
}
\references{
Wilms I, Killick R, Matteson DS (2021) Graphical Influence Diagnostics for Changepoint Models, \emph{ArxiV: 2107.10572}}
\author{
Rebecca Killick
}


\seealso{
\code{\link{influence}}, \code{\link{StabilityOverview}}, \code{\link{ParameterStability}}, \code{\link{LocationStability}}
}
\examples{
#### Generate Simulated data example ####
set.seed(30)
x=c(rnorm(50),rnorm(50,mean=5),rnorm(1,mean=15),rnorm(49,mean=5),rnorm(50,mean=4))
xcpt = cpt.mean(x,method='PELT') # Get the changepoints via PELT


#### Influence Map ####
\dontrun{
library(ggplot2)
x.inf = influence(xcpt, method = "delete")
InfluenceMap(cpts(xcpt), x.inf, data = x, include.data = TRUE, 
   ggops = theme(axis.text = element_text(size=15), axis.title = element_text(size=20),
   plot.title = element_text(size=25)))


x.inf = influence(xcpt, method = "outlier")
InfluenceMap(cpts(xcpt), x.inf, data=x, include.data = TRUE,
    ggops = theme(axis.text = element_text(size=15), axis.title = element_text(size=20),
    plot.title = element_text(size=25)))
}
}

\keyword{methods}
\keyword{models}
\keyword{influence}
\keyword{changepoint}
\keyword{segmentation}
\keyword{plot}