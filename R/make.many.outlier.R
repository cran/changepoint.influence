# by definition we make a datapoint an outlier by making the cost of the individual data point, in its own segment,
# larger than the cost of the existing segment it is in.

# There are two ways we could approach this:
# 1) look at the segment the datapoint is in and the penalty, make the data point an outlier.
#    thus if it is already in its own segment there is nothing to do.  This is a "whole system" approach.
# 2) we are looking at changes in mean so an outlier is either very large or very small, so take the range
#    of the data and give the datapoint the value of datapoint + 2*range. If at the lower end, +range would
#    not make it an outlier so need +2*range to ensure it is atleast one range above the data
#    (no reason why max and not min although could think about 0+ data)

make.many.outlier=function(datapoints,range.data, pos=TRUE,same=FALSE,sd=0.01){
  # given the range of the entire sample, make datapoints outliers
  # pos=TRUE is an outlier above the data size
  # pos=FALSE is an outlier below the min data
  # same=TRUE ignores the value of the original data and makes a homogeneous segment
  # sd is half the width of the symmetric jitter
  
  if(same){
    if(pos){return(jitter(rep(datapoints[1]+2*range.data,length(datapoints)),amount=sd))}
    else{return(jitter(rep(datapoints[1]-2*range.data,length(datapoints)),amount=sd))}
  }
  if(pos){return(datapoints+2*range.data)}
  else{return(datapoints-2*range.data)}
  # thus if they were all in their own segments previously then they still will be and we get 0 changes as before
  # but if they weren't all in their own segments then additional changes will be added
}
