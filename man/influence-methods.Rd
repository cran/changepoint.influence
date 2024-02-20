\name{influence-methods}
\docType{methods}
\alias{influence-methods}\alias{influence,cpt-method}

\title{ ~~ Methods for Function influence  ~~}
\description{
 ~~ Methods for function \code{influence}  ~~
}
\usage{
\S4method{influence}{cpt}(model,method=c("delete","outlier"),pos=TRUE,same=FALSE,sd=0.01)
}
\arguments{
  \item{model}{
	Depending on the class of \code{model} depends on the method used (and if one exists).  For \code{cpt} objects this is the original output from a call to the \code{cpt.*()} suite of functions in the "changepoint" package.
}
  \item{method}{
  Either \code{"delete"} or \code{"outlier"}.  These control what happens to the individual observations when the data is perturbed. See details for further information on the difference between the two.
  }
  \item{pos}{For \code{method="outlier"} this is whether the outlier is positive (TRUE) or negative (FALSE).}
  \item{same}{For \code{method="outlier"} and multiple outliers, this is whether we want the outliers to have the same mean (TRUE) (takes the first outlier, adds 2*range(data), then jitters the others around this value) or whether we add 2*range(data) to the existing value of each datapoint (FALSE).}
  \item{sd}{For \code{method="outlier"}, the standard deviation of the jitter, see \code{same} argument.}
}

\section{Methods}{
\describe{

\item{\code{signature(model = "cpt",method=c("delete","outlier"),pos=TRUE,same=FALSE,sd=0.01)}}{
For \code{model="cpt"} objects this is the original output from a call to the \code{cpt.*()} suite of functions in the "changepoint" package.
}
}}

\details{
Calculates the influence of the data on the observed segmentation.  There are currently two methods implemented for this \code{method="delete"} and \code{method="outlier"}.

Both methods sequentially take each data point, modify it and then run the same changepoint algorithm on the modified data as the original data.  We record the new segmentations in an nxn matrix output of the segment number for each location 1,...,n for each of the 1,...,n data modifications.

If a datapoint has no undue influence on the overall segmentation then the segmentation with that datapoint modified will be the same as the original segmentation.  We define undue influence as any unexpected variation in the segmentations when data points are modified.

The \code{method="delete"} modifies a datapoint by deleting it.  This is recorded as an NA value in the returned nxn matrix to preserve indexing.  The \code{method="outlier"} modifies a datapoint by making it an outlier (+/- 2*range(data)).  When we make a datapoint an outlier we force it to be in its own segment and thus expect to introduce two new changepoints to the resulting segmentation.
}
\value{
A list containing the following elements:

$delete, if the \code{modify="delete"}
  $class.del, an nxn matrix of the class at each time point (NA along the diagonal) 
  $param.del, an nxn matrix of the parameter at each time point (NA along the diagonal)
$outlier, if the \code{modify="outlier"}
  $class.out, an nxn matrix of the class at each time point (NA along the diagonal) 
  $param.out, an nxn matrix of the parameter at each time point (NA along the diagonal)
}
\seealso{
 \code{\link{StabilityOverview}}, \code{\link{LocationStability}},\code{\link{ParameterStability}},\code{\link{InfluenceMap}}
}

\examples{
#### Generate Simulated data example ####
set.seed(30)
x = c(rnorm(50), rnorm(50, mean = 5), rnorm(1, mean = 15), rnorm(49, mean = 5), rnorm(50, mean = 4))
xcpt = cpt.mean(x,method='PELT') # Get the changepoints via PELT

#### Get the influence for both delete and outlier options ####
x.inf = influence(xcpt)

#### Get the influence using delete method ####
x.inf = influence(xcpt, method="delete")

#### Get the influence using outlier method ####
x.inf = influence(xcpt, method="outlier", pos=FALSE,same=FALSE) 
# no sd required as no jitter used.

}

\keyword{methods}
\keyword{influence}
\keyword{internal} 