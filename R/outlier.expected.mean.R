outlier.expected.mean=function(original.class){
  # Calculates the expected segmentations for MOO based on an original segmentation
  
  # original.class    The class of the original segmentation

  one.time.expected=function(i,original.class,cpt,cpt.affected,orig.outlier){
    # function to calculate the expected class structure of a single timepoint across modify positions
    
    expected=rep(original.class[i],length(original.class)) # under no modifications
    if(i>1){
      if(i==2){
        expected[1:2]=expected[1:2]+1
        expected[2]=expected[2]-any(orig.outlier==i)
      }
      else{
        expected[1]=expected[1]+1
        expected[2:(i-1)]=expected[2:(i-1)]+1+cpt.affected[2:(i-1)]
        expected[i]=expected[i]+any(cpt==i)+cpt.affected[i]-any(orig.outlier==i)
      }
      expected[orig.outlier[which(orig.outlier<i)]]=expected[orig.outlier[which(orig.outlier<i)]]-1
    }
    return(expected)
  }
  
  # either side of a cpt location (i.e. class change boundary) is affected differently (+1 instead of +2)
  cpt=which(diff(original.class)!=0)
  affected=unique(c(cpt,cpt+1))
  n=length(original.class)
  cpt.affected=rep(1,n)
  cpt.affected[c(affected,n)]=0 # include n as isn't technically in the middle of a segment
  
  cpt=c(0,cpt,n) # wider def needed for short segment detection at start and end
  orig.outlier=cpt[which(diff(cpt)==1)+1] # segments of length 1 in the original data
  
  expected=matrix(NA,ncol=n,nrow=n)
  for(s in 1:n){
    expected[,s]=one.time.expected(s,original.class,cpt,cpt.affected,orig.outlier)
  }
  
  return(expected)
}