#'C:/Users/enzo7311/Desktop/timeseries/cs403/cs403.csv'
#'C:/Users/enzo7311/Desktop/timeseries/ma04/Ma04.csv'
#'#'C:/Users/enzo7311/Desktop/timeseries/ma05/Ma05.csv'
#'
SanDeep<-function(file='C:/Users/enzo7311/Desktop/timeseries/cs403/cs403.csv'){
      #  library(xts)
  library(dplyr)
  library(lubridate) #Date management
  library(ggplot2)
  
  dati<- read.csv(file,sep=';')
  #dati$Time.Position<-as.character(dati$Time.Position)
  dati$time<-mdy_hm(dati$time)
  dati$hour<-hour(dati$time)
  dati<-subset(dati,dati$Time.Position != "")
  dati<-subset(dati,dati$Time.Position != "NULLLLLA")
  dati$queue<-dati$Avg..Disk.Queue.Length
  dati$R<-dati$Avg..Disk.sec.Transfer
  dati$IOPS<-dati$Disk.Transfers.sec
  dati$verifica<-dati$R*dati$IOPS/dati$queue
  dati$S<-dati$R/(dati$queue+1)
  #dati<-subset(dati,dati$IOPS > 0)
  View(dati)
  DatiAgg<-dati %>% group_by(Time.Position) %>% summarise(medianQueue=median(queue),mediaQueue=mean(queue),sdQueue=sd(queue),medianR=median(R),mediaR=mean(R),sdR=sd(R),medianIOPS=median(IOPS),mediaIOPS=mean(IOPS),SdIOPS=sd(IOPS),medianS=median(S),mediaS=mean(S),sdS=sd(S))
  DatiAgg2<-dati %>% group_by(Time.Position,hour) %>% summarise(medianQueue=median(queue),mediaQueue=mean(queue),sdQueue=sd(queue),medianR=median(R),mediaR=mean(R),sdR=sd(R),medianIOPS=median(IOPS),mediaIOPS=mean(IOPS),SdIOPS=sd(IOPS),medianS=median(S),mediaS=mean(S),sdS=sd(S))
  
  #print(summary(dati))  
  View(DatiAgg)
  View(DatiAgg2)
 
#  plot(dati$Avg..Disk.Bytes.Transfer)
#g1<-ggplot(dati, aes(x=log(R))) + geom_density() +ggtitle("Response ")+ facet_grid(.~ Time.Position )
#g2<-ggplot(dati, aes(x=log(queue))) + geom_density() +ggtitle("Queue")+ facet_grid(.~ Time.Position )
#g3<-ggplot(dati, aes(x=log(IOPS))) + geom_density() +ggtitle("iops")+ facet_grid(.~ Time.Position )
#g4<-ggplot(dati, aes(x=log(S))) + geom_density() +ggtitle("S")+ facet_grid(.~ Time.Position )
boxplot(medianQueue~hour,data=DatiAgg2,main="all data Queue")
boxplot(medianIOPS~hour,data=DatiAgg2,main="IOPS")
boxplot(medianR~hour,data=DatiAgg2,main="R")
boxplot(medianS~hour,data=DatiAgg2,main="S")
#boxplot(medianIOPS~hour+Time.Position,data=DatiAgg2)
#multiplot(g1,g2,g3,g4, cols=2)
p1<-ggplot(DatiAgg2, aes(factor(hour), medianQueue)) + geom_boxplot()+ geom_point(aes(colour = factor(Time.Position)))
p2<-ggplot(DatiAgg2, aes(factor(hour), medianIOPS)) + geom_boxplot()+ geom_point(aes(colour = factor(Time.Position)))
p3<-ggplot(DatiAgg2, aes(factor(hour), medianR)) + geom_boxplot()+ geom_point(aes(colour = factor(Time.Position)))
p4<-ggplot(DatiAgg2, aes(factor(hour), medianS)) + geom_boxplot()+ geom_point(aes(colour = factor(Time.Position)))

multiplot(p1,p2,p3,p4, cols=2)
}

##In ferential analisis of the two status....
SanDeep2<-function(file='C:/Users/enzo7311/Desktop/timeseries/ma05/Ma05.csv'){
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