setMethod("influence","cpt",function(model,method=c("delete","outlier"),pos=TRUE,same=FALSE,sd=0.01){
  # function to calculate the influence of a given set of data using different methods
  
  # object        cpt object output from the changepoint packages
  # method        method to calculate the influence according to
  # pos=TRUE      MOO: If true modification is above the data, if false then below
  # same=FALSE    MOO: If TRUE the original value doesn't matter the out.point is a new value, if true then range added to the original point
  # sd=0.01       MOO: jitter to add to the modify point
  
  
  if(class(model)!="cpt"){stop("This function takes a cpt object as the model input")}
  if(cpttype(model)!="mean"){stop("Currently only models generated from the cpt.mean function are supported.")}

  n=length(data.set(model))
  data=data.set(model)
  
  ans=list()
  
  # note that in the matrices rows are the different manipulations and the columns are the time index (the way it should be!)

  if(any(method=="delete")){
    # replicate the generation of data and application of changepoint method to the data
    ansobject.del=sapply(X=1:n,FUN=loo.ind.cpt,data=data,pen.value=pen.value(model),test.stat=test.stat(model),penalty=pen.type(model),minseglen=minseglen(model),method=method(model))

    # collate the output
    ansclass.del=matrix(NA,ncol=n,nrow=n)
    ansparam.del=matrix(NA,nrow=n,ncol=n)
    for(i in 1:n){
      # building segment vector
      class=rep(1:(ncpts(ansobject.del[[i]])+1),times=diff(c(0,cpts(ansobject.del[[i]]),n-1)))
      if(i==1){class=c(NA,class)}
      else if(i==n){class=c(class,NA)}
      else{class=c(class[1:(i-1)],NA,class[i:(n-1)])} # filling the i back in to align everything
      ansclass.del[i,]=class
      
      # building mean param vector
      param=rep(param.est(ansobject.del[[i]])$mean,times=diff(c(0,cpts(ansobject.del[[i]]),n-1)))
      if(i==1){param=c(NA,param)}
      else if(i==n){param=c(param,NA)}
      else{param=c(param[1:(i-1)],NA,param[i:(n-1)])} # filling the i back in to align everything
      ansparam.del[i,]=param
    }
    ans$delete=list(class.del=ansclass.del,param.del=ansparam.del)
    method=method[-which(method=="delete")]
  }
  if(any(method=="outlier")){
    # replicate the generation of data and application of changepoint method to the data
    ansobject.out=sapply(X=1:n,FUN=moo.ind.cpt,data=data,range=diff(range(data)),pos=pos,same=same,sd=sd,pen.value=pen.value(model),test.stat=test.stat(model),penalty=pen.type(model),minseglen=minseglen(model),method=method(model))
  
    # collate the output
    ansclass.out=matrix(NA,ncol=n,nrow=n)
    ansparam.out=matrix(NA,nrow=n,ncol=n)
    for(i in 1:n){
      # building segment vector
      ansclass.out[i,]=rep(1:(ncpts(ansobject.out[[i]])+1),times=diff(c(0,cpts(ansobject.out[[i]]),n)))
      
      # building mean param vector
      ansparam.out[i,]=rep(param.est(ansobject.out[[i]])$mean,times=diff(c(0,cpts(ansobject.out[[i]]),n)))
    }
    ans$outlier=list(class.out=ansclass.out,param.out=ansparam.out)
    method=method[-which(method=="outlier")]
  }
  
  if(length(method)>0){
    warning('method contains elements that are not recognized, must be "delete" or "outlier".')
  }
  
  return(ans)
})