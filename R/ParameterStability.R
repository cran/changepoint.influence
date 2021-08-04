ParameterStability=function(influence,original.mean=NULL,digits=6,ylab='',xlab='Index',cpt.col='red',cpt.width=3,...){
  # Function to plot the parameter stability across the influence modification
  # Note that this function
 
  n=nrow(influence[[1]]$class)
  names=names(influence)
  
  for(i in 1:length(influence)){
    method="Deletion"
    max=n-1
    if(names[i]=="outlier"){
      method="Outlier"
      max=n
      # remove the known outlier points
      for(j in 1:n){
        influence[[i]]$param.out[j,j]=NA
      }
    }
    counts=apply(matrix(1:n,ncol=1),1,FUN=function(x,influence,digits,i){
      counts=rle(sort(signif(influence[[i]]$param[,x],digits=digits)))
      counts.df=data.frame(index=rep(x,length(counts$values)),values=counts$values,counts=counts$lengths)
      return(counts.df)
    },influence=influence,digits=digits,i=i)
    counts=rbindlist(counts)
    
    plot(counts$index,counts$values,pch=20,col=hsv(v=0,alpha=0.3*(counts$counts/n+1)),lwd=0,#bg=hsv(v=0,alpha=0.5*(counts$counts/n+1)),
         main=paste('Parameter Stability: ',method,"method"),xlab=xlab,ylab=ylab,...)
    if(!is.null(original.mean)){
      if(length(original.mean)!=n){
        stop(paste('Length of original.mean must be',n))
      }
      rle.mean=rle(original.mean)
      rle.mean$lengths=c(0,cumsum(rle.mean$lengths))
      for(i in 1:length(rle.mean$values)){
        segments(rle.mean$lengths[i]+1,rle.mean$values[i],rle.mean$lengths[i+1],rle.mean$values[i],col=cpt.col,lwd=cpt.width)
      }
    }
  }
}