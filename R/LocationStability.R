LocationStability=function(original.cpts, influence, expected.class=NULL,type=c("Difference","Global","Local"),data=NULL,include.data=FALSE,cpt.lwd=4,cpt.col=c("#009E73", "#E69F00", "#E41A1C"),cpt.lty=c("dashed","dotdash","dotted"),ylab='',xlab='Index',...){
  # histograms the changepoint locations identified
  
  if(!any(type==c("Difference","Global","Local"))){
    stop("type should be Difference, Global, or Local.")
  }
  
  col.cpts=list()
  lty.cpts = list()
  
  n=nrow(influence[[1]]$class)
  ncpts=length(original.cpts)

  original.class=rep(1:(ncpts+1),times=diff(c(0,original.cpts,n)))
  names=names(influence)

  return=0
  # if the expected isn't given it needs calculating
  if((any(type=="Difference"))&(is.null(expected.class))){
    return=1
    expected=list()
    
    for(i in 1:length(influence)){
      if(eval(parse(text=paste("is.null(expected$",names[i],")",sep="")))){
        eval(parse(text=paste("expected$",names[i],"=",names[i],".expected.mean(original.class)",sep=""))) # calculated the expected
      }
    }
  }
  
  for(i in 1:length(influence)){
    method="Outlier"
    max=n-2
    if(names[i]=="delete"){
      method="Deletion"
      max=n-1
      
      # Dealing with the NAs temporarily (not returned to user) so we can plot nicely
      index.na=which(is.na(influence[[i]]$class.del))[-1] # -1 as we will deal with the first instance separately
      influence[[i]]$class.del[index.na]=influence[[i]]$class.del[index.na-n] # replace NA with previous index
      influence[[i]]$class.del[1,1]=1 # replace the first NA with 1

      if((any(type=="Difference"))&(is.null(expected.class))){
        # repeat for expected
        index.na=which(is.na(expected$delete))[-1] # -1 as we will deal with the first instance separately
        expected$delete[index.na]=expected$delete[index.na-n] # replace NA with previous index
        expected$delete[1,1]=1 # replace the first NA with 1
      }
    }
    
    cpts=unlist(apply(influence[[i]]$class,1,FUN=function(x){which(diff(x)==1)}))
    cpts=sort(cpts)
    
    if(names[i]=="delete"){
      # create an index of cpts to delete as they are just a function of the deletion process
      del.correct.index=apply(matrix(original.cpts,ncol=1),1,FUN=function(x){return(which(cpts==(x+1))[1])})
      cpts=cpts[-del.correct.index]
    }
    else{
      # create an index of cpts to delete as they are just a function of the modify process
      del.outlier.index=apply(matrix(1:(n-1),ncol=1),1,FUN=function(x){return(which(cpts==x)[1:2])})
      cpts=cpts[-del.outlier.index]
    }
    
    tcpts=table(cpts)

    col.cpts[[i]]=rep(cpt.col[1],length(original.cpts)) # "dark green"
    lty.cpts[[i]]=rep(cpt.lty[1],length(original.cpts)) # "dashed" for "green"
    for(j in 1:ncpts){
      if(tcpts[which(names(tcpts)==as.character(original.cpts[j]))]!=max){
        col.cpts[[i]][j]=cpt.col[2] # "orange2"
        lty.cpts[[i]][j]=cpt.lty[2] # "dotdash" for "orange"
      }
    }
    col.cpts[[i]][which(diff(original.cpts)==1)]=cpt.col[3] # red
    col.cpts[[i]][which(diff(original.cpts)==1)+1]=cpt.col[3]
    lty.cpts[[i]][which(diff(original.cpts)==1)]=cpt.lty[3] # "dotted" for "red
    lty.cpts[[i]][which(diff(original.cpts)==1)+1]=cpt.lty[3]
    
    names(col.cpts)[i]=names[i]
    
    if(any(type=="Difference")){
      # need to calculated the changepoints from the classes for both observed and expected
      cpts.observed=unlist(apply(influence[[i]]$class,MARGIN=1,FUN=function(x){
        return(which(diff(x)!=0))}))
      ########### note the partial matching used here (class.del or class.out)
      cpts.observed=factor(cpts.observed,levels=1:n)
      tcpts.observed=table(cpts.observed)
      cpts.expected=unlist(apply(expected[[i]],MARGIN=1,FUN=function(x){
        return(which(diff(x)!=0))}))
      cpts.expected=factor(cpts.expected,levels=1:n)
      tcpts.expected=table(cpts.expected)
      
      tresid=tcpts.observed-tcpts.expected
      tresid=as.vector(tresid)
    }

    hist.col=rep(1,n)
    hist.col[original.cpts]=col.cpts[[i]]

    if(include.data==TRUE){
      if(is.null(data)){
        stop("data argument must be supplied if include.data=TRUE.")
      }
      op <- par(no.readonly = TRUE) # read current parameters
      on.exit(par(op)) # returns options as user had them set on exit
      par(mfrow=c(2,1))
      plot(data,type='l',ylab=ylab,xlab=xlab,main=paste('Location Stability: ',method,"method"),...) # plot the original time series
      abline(v=original.cpts,col=col.cpts[[i]],lty=lty.cpts[[i]],lwd=cpt.lwd) # cpt.lty
      
      if(any(type=="Global")){
        hist(cpts,col=hist.col,border=hist.col,yaxt='n',breaks=0:n,xlim=c(0,n),xlab='Changepoint locations',ylab="Gloabl Proportion",main='',...)
        axis(side=2,at=round(c(0,max/4,max/2,3*max/4,max),2),labels=c(0,0.25,0.5,0.75,1))
        abline(h=max, col='grey')
      }
      # start breaks at 0 as define the boundaries thus 1:n is n-1 breaks, not n
      if(any(type=="Local")){
        for(j in 1:ncpts){ # remove original changepoints from plotting
          tmp=which(cpts==original.cpts[j])
          if(length(tmp)!=0){
            cpts=cpts[-tmp]
          }
        }
        hist(cpts,col=1,breaks=0:n,xlim=c(0,n),xlab='Changepoint locations',ylab="Local Count",main='',...)
        yaxplength=par("yaxp")[2]-par("yaxp")[1]
        segments(x0=original.cpts,y0=-yaxplength,y1=-0.02*yaxplength,col=col.cpts[[i]],lwd=cpt.lwd) # do -0.5 so in the middle of the bar
        abline(h=max, col='grey')
      }
      if(any(type=="Difference")){
        plot(tresid,type='n',col=hist.col,xlab='Changepoint locations',ylab="Difference from expected",main='',...)
        abline(h=0,col=1)
        to.plot=which(tresid!=0) # locations which are not 0
        for(seg in 1:length(to.plot)){
          if(any(to.plot[seg]==original.cpts)){lty.seg=lty.cpts[[i]][which(to.plot[seg]==original.cpts)]}else{lty.seg="solid"}
          segments(to.plot[seg],0,to.plot[seg],tresid[to.plot[seg]],col=hist.col[to.plot[seg]],lty=lty.seg)
        }
      }
    }
    else{ # same as above but title included on Histogram
      if(any(type=="Global")){
        hist(cpts,col=hist.col,border=hist.col,yaxt='n',breaks=0:n,xlim=c(0,n),main=paste('Location Stability: ',method,"method"),ylab="Global Proportion",xlab='Changepoint locations',...)
        axis(side=2,at=round(c(0,max/4,max/2,3*max/4,max),2),labels=c(0,0.25,0.5,0.75,1), ...)
        abline(h=max, col='grey')
      }
      # start breaks at 0 as define the boundaries thus 1:n is n-1 breaks, not n
      if(any(type=="Local")){
        for(j in 1:ncpts){ # remove original changepoints from plotting
          tmp=which(cpts==original.cpts[j])
          if(length(tmp)!=0){
            cpts=cpts[-tmp]
          }
        }
        hist(cpts,col=1,breaks=0:n,xlim=c(0,n),main=paste('Location Stability: ',method,"method"),xlab='Changepoint locations',ylab="Local Count",...)
        yaxplength=par("yaxp")[2]-par("yaxp")[1]
        segments(x0=original.cpts,y0=-yaxplength,y1=-0.02*yaxplength,col=col.cpts[[i]],lwd=cpt.lwd) # do -0.5 so in the middle of the bar
        abline(h=max, col='grey')
      }
      if(any(type=="Difference")){
        plot(tresid,type='n',col=hist.col,main=paste('Location Stability: ',method,"method"),xlab='Changepoint locations',ylab="Difference from expected",...)
        abline(h=0,col=1)
        to.plot=which(tresid!=0) # locations which are not 0
        for(seg in 1:length(to.plot)){
          if(any(to.plot[seg]==original.cpts)){lty.seg=lty.cpts[[i]][which(to.plot[seg]==original.cpts)]}else{lty.seg="solid"}
          segments(to.plot[seg],0,to.plot[seg],tresid[to.plot[seg]],col=hist.col[to.plot[seg]],lty=lty.seg)
        }
      }
    }
    # change colours to something meaningful to return to the user
    col.cpts[[i]][which(col.cpts[[i]]==cpt.col[1])] = "stable"
    col.cpts[[i]][which(col.cpts[[i]]==cpt.col[2])] = "unstable"
    col.cpts[[i]][which(col.cpts[[i]]==cpt.col[3])] = "outlier"
  }
  if(return){
    return(list(expected=expected,col.cpts=col.cpts))
  }
  return(col.cpts)
}
