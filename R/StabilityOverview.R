StabilityOverview=function(data, original.cpts, influence,cpt.lwd=2,cpt.col=c("#009E73", "#E69F00", "#E41A1C"),cpt.lty=c("dashed","dotdash","dotted"),ylab=' ',xlab='Index', legend.args=list(display=TRUE,x="left",y=NULL,cex = 1,bty="n",horiz=TRUE,xpd=FALSE), ...){
  # plots the original changepoints with colours indicating whether they have moved within the modify/delete methods
  
  col.cpts=list()
  lty.cpts = list()
  n=length(data)
  ncpts=length(original.cpts)
  
  original.class=rep(1:(ncpts+1),times=diff(c(0,original.cpts,n)))
  names=names(influence)
  
  for(i in 1:length(influence)){
    method="Outlier"
    max=n-2
    if(names[i]=="delete"){
      method="Deletion"
      max=n-1
      index.na=which(is.na(influence[[i]]$class.del))[-1] # -1 as we will deal with the first instance separately
      influence[[i]]$class.del[index.na]=influence[[i]]$class.del[index.na-n] # replace NA with previous index
      influence[[i]]$class.del[1,1]=1 # replace the first NA with 1
    }

    plot(data,type='l',ylab=ylab,xlab=xlab,main=paste("Stability Dashboard: ", method,"method"),...) # plot the original time series
    
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
        col.cpts[[i]][j]=cpt.col[2] # orange2
        lty.cpts[[i]][j]=cpt.lty[2] # "dotdash" for "orange"
      }
    }
    col.cpts[[i]][which(diff(original.cpts)==1)]=cpt.col[3] # red or other option #661100
    col.cpts[[i]][which(diff(original.cpts)==1)+1]=cpt.col[3] 
    lty.cpts[[i]][which(diff(original.cpts)==1)]=cpt.lty[3] # "dotted" for "red
    lty.cpts[[i]][which(diff(original.cpts)==1)+1]=cpt.lty[3]
    names(col.cpts)[i]=names[i]

    abline(v=original.cpts,col=col.cpts[[i]],lty=lty.cpts[[i]],lwd=cpt.lwd) # cpt.lty
    # do we want a legend to specify the colours or just leave it to the documentation?
    
    # change colours to something meaningful to return to the user
    col.cpts[[i]][which(col.cpts[[i]]==cpt.col[1])] = "stable"
    col.cpts[[i]][which(col.cpts[[i]]==cpt.col[2])] = "unstable"
    col.cpts[[i]][which(col.cpts[[i]]==cpt.col[3])] = "outlier"
    
    if(legend.args$display){
      legend(x=legend.args$x,y=legend.args$y,
             legend=c("stable", "unstable", "outlier"),
             lty=cpt.lty, lwd = cpt.lwd,
             col = cpt.col,
             xpd=legend.args$xpd, horiz=legend.args$horiz, 
             bty=legend.args$bty, cex = legend.args$cex)
    }

  }
  return(col.cpts)
}