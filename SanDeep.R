#'C:/Users/enzo7311/Desktop/timeseries/cs403/cs403.csv'
#'C:/Users/enzo7311/Desktop/timeseries/ma04/Ma04.csv'
#'C:/Users/enzo7311/Desktop/timeseries/ma05/Ma05.csv'
#'C:/Users/enzo7311/Desktop/timeseries/ma06/Ma06.csv'
#''C:/Users/enzo7311/Desktop/timeseries/ma05/Ma05.csv'
#''C:/dati/timeseries/cs403/cs403V2.csv'
#'Ma04V2
SanDeep<-function(file='C:/dati/timeseries/cs403/cs403V2.csv'){
      #  library(xts)
  library(dplyr)
  library(lubridate) #Date management
  library(ggplot2)
  
  dati<- read.csv(file,sep=';')
  View(dati)
  #dati$Time.Position<-as.character(dati$Time.Position)
  dati$time<-mdy_hm(dati$time)
  dati$hour<-as.factor(hour(dati$time))
  dati<-subset(dati,dati$Time.Position != "")
  dati<-subset(dati,dati$Time.Position != "NULLLLLA")
  dati$queue<-dati$Avg..Disk.Queue.Length
  dati$R<-dati$Avg..Disk.sec.Transfer
  dati$IOPS<-dati$Disk.Transfers.sec
 # dati$verifica<-dati$R*dati$IOPS/dati$queue
  dati$S<-dati$R/(dati$queue+1)
  #dati<-subset(dati,dati$IOPS > 0)
 dati$Time.Position<-factor(dati$Time.Position,level=c("BEFORE","AFTER1","AFTER2"))
 dati$Disk.Transfers.sec<-NULL
 dati$Avg..Disk.sec.Transfer<-NULL
 dati$Avg..Disk.Queue.Length<-NULL
  View(dati)
 
 ##Test
 
 p4<-ggplot(dati, aes(x=(IOPS),y=(queue))) +ggtitle("Scattrer Plot ") +geom_point(aes(colour = Time.Position))
 
 multiplot(p4, cols=1)
 
 p4<-ggplot(dati, aes(x=(IOPS),y=(R))) +ggtitle("Scattrer Plot ") +geom_point(aes(colour = Time.Position))
 
 multiplot(p4, cols=1)
 
  DatiAgg<-dati %>% group_by(Time.Position) %>% summarise(medianQueue=median(queue),mediaQueue=mean(queue),sdQueue=sd(queue),medianR=median(R),mediaR=mean(R),sdR=sd(R),medianIOPS=median(IOPS),mediaIOPS=mean(IOPS),SdIOPS=sd(IOPS),medianS=median(S),mediaS=mean(S),sdS=sd(S))
  DatiAgg2<-dati %>% group_by(Time.Position,hour) %>% summarise(medianQueue=median(queue),mediaQueue=mean(queue),sdQueue=sd(queue),medianR=median(R),mediaR=mean(R),sdR=sd(R),medianIOPS=median(IOPS),mediaIOPS=mean(IOPS),SdIOPS=sd(IOPS),medianS=median(S),mediaS=mean(S),sdS=sd(S))
  
  #print(summary(dati))  
  View(DatiAgg)
  View(DatiAgg2)

dati$Time.Position<-factor(dati$Time.Position,level=c("BEFORE","AFTER1","AFTER2"))

g1<-ggplot(dati, aes(x=log(R))) + geom_density(aes(color=Time.Position)) +ggtitle("Response Time ")+xlab("Response Time in log scale")#+ facet_grid(.~ Time.Position )
g2<-ggplot(dati, aes(x=log10(queue))) + geom_density(aes(color=Time.Position)) +ggtitle("Queue Length")+xlab("Queue Length in log scale")#+ facet_grid(.~ Time.Position )
g3<-ggplot(dati, aes(x=log(IOPS))) + geom_density(aes(color=Time.Position)) +ggtitle("IOPS")+xlab("IOPS in log scale")#+ facet_grid(.~ Time.Position )
g4<-ggplot(dati, aes(x=log10(S))) + geom_density(aes(color=Time.Position)) +ggtitle("Service Time")+xlab("Service Time in log scale")#+ facet_grid(.~ Time.Position )




#boxplot(medianQueue~hour,data=DatiAgg2,main="all data Queue")
#boxplot(medianIOPS~hour,data=DatiAgg2,main="IOPS")
#boxplot(medianR~hour,data=DatiAgg2,main="R")
#boxplot(medianS~hour,data=DatiAgg2,main="S")




#boxplot(medianIOPS~hour+Time.Position,data=DatiAgg2)
multiplot(g3,g1,g2,g4, cols=2)

p1<-ggplot(DatiAgg2, aes(hour, medianQueue))+ggtitle("Queue Length ")+ylab("Median value for Queue Length ") + geom_boxplot()+ geom_point(size=5,aes(colour = Time.Position))
p2<-ggplot(DatiAgg2, aes(hour, medianIOPS))+ggtitle("IOPS- Workload ")+ylab("Median value for IOPS ") + geom_boxplot()+ geom_point(aes(colour = Time.Position),size=5)
p3<-ggplot(DatiAgg2, aes(hour, medianR)) +ggtitle("Response Time ")+ylab("Median value for Response Time ")+ geom_boxplot()+ geom_point(aes(colour = Time.Position),size=5)
p4<-ggplot(DatiAgg2, aes(hour, medianS)) +ggtitle("Service Time ")+ylab("Median value for Service Time ")+ geom_boxplot()+ geom_point(aes(colour = Time.Position),size=5)

multiplot(p2,p1,p3,p4, cols=2)

#l1<-ggplot(dati, aes(factor(hour), queue)) + geom_boxplot()+ geom_point(aes(colour = factor(Time.Position)))
#l2<-ggplot(dati, aes(factor(hour), IOPS)) + geom_boxplot()+ geom_point(aes(colour = factor(Time.Position)))
#l3<-ggplot(dati, aes(factor(hour), R)) + geom_boxplot()+ geom_point(aes(colour = factor(Time.Position)))
#l4<-ggplot(dati, aes(factor(hour), S)) + geom_boxplot()+ geom_point(aes(colour = factor(Time.Position)))

#multiplot(l1,l2,l3,l4, cols=2)


}


##In ferential analisis of the two status....
SanDeep2<-function(file='C:/Users/enzo7311/Desktop/timeseries/cs403/cs403.csv'){
  #  library(xts)
  library(dplyr)
  library(lubridate) #Date management
  library(ggplot2)
  
  dati<-read.csv(file,sep=';')
  dati$time<-mdy_hm(dati$time)
  dati$Time.Position<-as.character(dati$Time.Position)
  dati<-subset(dati,dati$Time.Position != "")
  dati<-subset(dati,dati$Time.Position != "NULLLLLA")
  dati$queue<-dati$Avg..Disk.Queue.Length
  dati$R<-dati$Avg..Disk.sec.Transfer
  dati$IOPS<-dati$Disk.Transfers.sec
  dati$S<-dati$R/(dati$queue+1)
  
  View(dati)
  Before<-subset(dati,dati$Time.Position == "Before")
  After<-subset(dati,dati$Time.Position == "After")
  print("Before")
  print(summary(Before))
  print("After")
  print(summary(After))
  print("iops")
  print(t.test(Before$IOPS[1:40297], After$IOPS[1:40297], paired=TRUE) )
  print("Response")
  print(t.test(Before$R[1:40297], After$R[1:40297], paired=TRUE) )
  print("Queue")
  print(t.test(Before$queue[1:40297], After$queue[1:40297], paired=TRUE) )
  
  print("wilcox.test")
   
  print("iops")
  print(wilcox.test(Before$IOPS[1:40297], After$IOPS[1:40297], paired=TRUE) )
  print("Response")
  print(wilcox.test(Before$R[1:40297], After$R[1:40297], paired=TRUE) )
  print("Queue")
  print(wilcox.test(Before$queue[1:40297], After$queue[1:40297], paired=TRUE) )
  
  print("Before")
  print(summary(lm(queue[1:40297]~IOPS[1:40297]-1 , Before)))
  print("After")
  A<-lm(queue[1:40297]~IOPS[1:40297]-1 , After)
  print(summary(A))
  plot(After$queue[1:40297],After$IOPS[1:40297])
  plot(Before$queue[1:40297],Before$IOPS[1:40297])
  plot(Before$queue[1:40297],Before$R[1:40297])
  plot(Before$R[1:40297],Before$IOPS[1:40297])
  plot(Before$queue[1:40297],After$queue[1:40297])
  plot(Before$IOPS[1:40297],After$IOPS[1:40297])
  plot(Before$R[1:40297],After$R[1:40297])
  plot(log(After$queue),log(After$S))
  plot(log(Before$queue),log(Before$S))
  pairs(~queue+R+S+IOPS,data=dati,log="xy",main="Dati")
  pairs(~queue+R+S+IOPS,data=dati,main="Dati")
  pairs(~queue+R+S+IOPS,data=dati,log="xy",main="Before")
  pairs(~queue+R+S+IOPS,data=dati,log="xy",main="After")
  #pairs(After)
  #plot(dati$S)
  #plot(A)
  
  
}


SanDeep3<-function(file='C:/Users/enzo7311/Desktop/timeseries/ma04/Ma04.csv'){
  #  library(xts)
  library(dplyr)
  library(lubridate) #Date management
  library(ggplot2)
  freq<-4*60*24#4*60*24*7
  dati<-read.csv(file,sep=';')
  dati$queue<-dati$Avg..Disk.Queue.Length
  dati$R<-dati$Avg..Disk.sec.Transfer
  dati$IOPS<-dati$Disk.Transfers.sec
  dati$S<-dati$R/(dati$queue+1)   
  dati$Time.Position<-as.character(dati$Time.Position)
  dati<-subset(dati,dati$Time.Position != "")
  #dati<-subset(dati,dati$Time.Position != "NULLLLLA")
  View(dati)
  
  Queue<-ts(dati$queue, start = c(3, 17),frequency=(freq))
  #plot( Queue)
  fit<-stl(Queue,s.window="periodic")
  summary(fit)
  plot(fit,main="QUEue")
  
  response<-ts(dati$R, start = c(3, 17),frequency=(freq))
  #plot( response)
  fit<-stl(response,s.window="periodic")
  summary(fit)
  plot(fit,main="Response")
 
  iops<-ts(dati$IOPS, start = c(3, 17),frequency=(freq))
  #plot( iops)
  fit<-stl(iops,s.window="periodic")
  summary(fit)
  plot(fit,main="iops") 
  
  S<-ts(dati$S, start = c(3, 17),frequency=(freq))
  #plot( Queue)
  fit<-stl(S,s.window="periodic")
  summary(fit)
  plot(fit,main="S",col.range="red",labels=c("Data","Daily cycle","Trend","Noise"))
  
  
}

multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  require(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}