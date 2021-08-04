delete.expected.mean=function(original.class){
  # Calculates the expected segmentations for LOO based on an original segmentation
  
  # original.class    The class of the original segmentation
  
  n=length(original.class)
  
  cpt=c(0,which(diff(original.class)!=0),n) # wider def needed for short segment detection at start and end
  orig.outlier=cpt[which(diff(cpt)==1)+1] # segments of length 1 in the original data
  if(length(orig.outlier)!=0){
    if(orig.outlier[length(orig.outlier)]==n){orig.outlier=orig.outlier[-length(orig.outlier)]}
  }
  
  expected=matrix(rep(original.class,n),nrow=n,ncol=n,byrow=T)
  for(i in 1:n){
    expected[i,i]=NA # removing the deleted points
  }
  # need to clear up the length 1 segments
  for(i in 1:length(orig.outlier)){
    expected[orig.outlier[i],(orig.outlier[i]+1):n]=expected[orig.outlier[i],(orig.outlier[i]+1):n]-1
    # -1 as the outlier segment number has been removed
  }
  return(expected)
}