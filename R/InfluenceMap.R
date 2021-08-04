InfluenceMap=function(original.cpts, influence, resid=NULL,data=NULL,include.data=FALSE,influence.col=c("#0C4479","white","#AB9783"),cpt.col=c("#009E73", "#E69F00", "#E41A1C"),cpt.lty=c("dashed","dotdash","dotted"),ylab='',ggops=NULL){
  # images the residuals of fit-expected for class
  
  ## Setting variables used by ggplot below to avoid no visible binding error in CRAN checks:
  X1=X2=value=index=NULL
  
  col.cpts=list()
  lty.cpts = list()
  
  n=nrow(influence[[1]]$class)
  ncpts=length(original.cpts)
  
  original.class=rep(1:(ncpts+1),times=diff(c(0,original.cpts,n)))
  names=names(influence)
  
  return=0
  # if the resid isn't given it needs calculating
  if(is.null(resid)){
    return=1
    expected=list()
  
    for(i in 1:length(influence)){
      if(eval(parse(text=paste("is.null(expected$",names[i],")",sep="")))){
        eval(parse(text=paste("expected$",names[i],"=",names[i],".expected.mean(original.class)",sep=""))) # calculated the expected
      }
    }
  }
  
  if(include.data==TRUE){
    if(is.null(data)){
      stop("data argument must be supplied if include.data=TRUE.")
    }
    lay <- rbind(c(1,1,1,1,1),
                 c(2,2,2,2,2),
                 c(2,2,2,2,2),
                 c(2,2,2,2,2))
    
    data=data.frame(data=data,index=1:length(data))
  }
  
  for(i in 1:length(influence)){
    method="Outlier"
    max=n-2
    if(names[i]=="delete"){
      method="Deletion"
      max=n-1
      
      if(is.null(resid)){
        # Dealing with the NAs temporarily (not returned to user) so we can plot nicely
        index.na=which(is.na(influence[[i]]$class.del))[-1] # -1 as we will deal with the first instance separately
        influence[[i]]$class.del[index.na]=influence[[i]]$class.del[index.na-n] # replace NA with previous index
        influence[[i]]$class.del[1,1]=1 # replace the first NA with 1
      
        # repeat for expected
        index.na=which(is.na(expected$del))[-1] # -1 as we will deal with the first instance separately
        expected$del[index.na]=expected$del[index.na-n] # replace NA with previous index
        expected$del[1,1]=1 # replace the first NA with 1
      }
    }
    
    if(is.null(resid)){
      resid=influence[[i]]$class-expected[[i]]
    ########### note the partial matching used here (class.del or class.out)
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
    
    col.cpts[[i]]=rep(cpt.col[1],length(original.cpts))
    lty.cpts[[i]]=rep(cpt.lty[1],length(original.cpts))
    for(j in 1:ncpts){
      if(tcpts[which(names(tcpts)==as.character(original.cpts[j]))]!=max){
        col.cpts[[i]][j]=cpt.col[2]
        lty.cpts[[i]][j]=cpt.lty[2]
      }
    }
    col.cpts[[i]][which(diff(original.cpts)==1)]=cpt.col[3]
    col.cpts[[i]][which(diff(original.cpts)==1)+1]=cpt.col[3]
    lty.cpts[[i]][which(diff(original.cpts)==1)]=cpt.lty[3]
    lty.cpts[[i]][which(diff(original.cpts)==1)+1]=cpt.lty[3]
    names(col.cpts)[i]=names[i]
    
    ggimage=ggplot()+geom_raster(data=melt(t(resid)),aes(X1,X2,fill=value),show.legend=TRUE)+
      labs(x="Index\nFewer Cpts                        More Cpts", y = "Altered Data Point")+
      scale_fill_gradient2(low=influence.col[1],mid=influence.col[2],high=influence.col[3],midpoint=0, name="")
    ggimage=ggimage+geom_abline(slope=1,colour="grey")+geom_point(data = data.frame(X1=original.cpts,X2=original.cpts), aes(X1, X2),colour=col.cpts[[i]],alpha=0.8)
    ggimage=ggimage+theme_classic()+theme(legend.position="bottom",legend.text=element_text(size=11))
    
    if(include.data==TRUE){
      ggcpt=ggplot(data=data)+geom_line(aes(x=index,y=data))+ labs(x="Index", y = ylab)+
              geom_vline(xintercept = original.cpts, colour = col.cpts[[i]], linetype = lty.cpts[[i]]) # add cpts
      ggcpt=ggcpt+theme_classic()
      ggcpt=ggcpt+ggops # add user options at the end so can override our defaults
      ggcpt=ggplotGrob(ggcpt)
      
      ggimage=ggimage+ggops # add user options at the end so can override our defaults
      
      maxWidth = grid::unit.pmax(ggimage$widths[2:5], ggcpt$widths[2:5])
      ggimage$widths[2:5] <- as.list(maxWidth)
      ggcpt$widths[2:5] <- as.list(maxWidth)
      
      gridtitleops=list()
      class(gridtitleops)="gpar"
      gridtitleops$fontsize=14
      if(any(names(ggops)=="plot.title")){
        gridtitleops$fontfamily=ggops$plot.title$family
        gridtitleops$fontface=ggops$plot.title$face
        gridtitleops$col=ggops$plot.title$colour
        gridtitleops$fontsize=ggops$plot.title$size
      }
      grid.arrange(grobs = list(ggcpt, ggimage), layout_matrix=lay, top = textGrob(paste('Influence map:',method,"method"),gp=gridtitleops))
    }
    else{
      ggimage=ggimage+ggtitle(label=paste('Influence map: ',method,"method"))+
        theme(plot.title = element_text(hjust = 0.5))
      ggimage=ggimage+ggops # add user options at the end so can override our defaults
      print(ggimage)
    }
    col.cpts[[i]][which(col.cpts[[i]]==cpt.col[1])] = "stable"
    col.cpts[[i]][which(col.cpts[[i]]==cpt.col[2])] = "unstable"
    col.cpts[[i]][which(col.cpts[[i]]==cpt.col[3])] = "outlier"
  }
  if(return){
    return(list(resid=resid,col.cpts=col.cpts))
  }
  
  
  return(col.cpts)
}