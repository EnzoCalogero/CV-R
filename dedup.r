DedupRead<-function(file, sidb=0,Mo=6,Days=c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),hour=c(18,19,20,12,21,23)){
  library(ggplot2)
  library(gcookbook)
  #Read the big File######
  DDB <- read.csv(file)

  ##########Focus on the sidb##########
  if(sidb!=0){
     DDB<-subset(DDB,DDB$SIDBStoreId %in% sidb)
   }
  

  
  #DDB<-subset(DDB,DDB$AvgQITime > 0 & DDB$NumOfConnections > 0)
  DDB$trughput<-(128/(DDB$AvgQITime/100000))/1024##mg/sec 
 
  
 DDB$day<-substr(DDB$Date,1,2)
 DDB$Month<-substr(DDB$Date,4,5)
 DDB$year<-substr(DDB$Date,7,10)
 DDB$hour<-substr(DDB$Date,12,13)
 
 DDB$year<-as.numeric(DDB$year)
 DDB$Month<-as.numeric(DDB$Month)
 DDB$day<-as.numeric(DDB$day)
 DDB$hour<-as.numeric(DDB$hour)
 
 ################################################
 #                Time filtering
 ########################################
 print(Mo)
 DDB<-subset(DDB,DDB$Month == Mo)
 
 DDB<-subset(DDB,DDB$day %in% Days)
 
 ######################################
 DDB$nightImp<-DDB$day
 DDB$nightImp[DDB$hour>12]<-DDB$nightImp+1
 
 
 DDB$startsimply<-DDB$Month*10000+DDB$day*100+DDB$hour 
 
 
 #View(DDB)
return(DDB)
}

##########  Perf Analysis  ###################
DedupPerf<-function(sidb=0,Mo=6,file='C:/Users/enzo7311/Desktop/Dati/cs7ddb1506.csv',hour=c(18,19,20,12,21,23)){
  DDB<-DedupRead(file,sidb,Mo)
#print(file)
print(sidb)
View(DDB)

DDBAggr1<-aggregate(AvgQITime~nightImp + SIDBStoreId , mean,data=DDB)
View(DDBAggr1)
p1<-ggplot(DDBAggr1, aes(y=log10(AvgQITime),x=nightImp)) +  geom_point() + geom_line(aes(colour=factor(SIDBStoreId)))


DDBAggr2<-aggregate(AvgQITime~startsimply + SIDBStoreId +day + hour, min,data=DDB)
View(DDBAggr2)

DDBAggr3<-aggregate(NumOfConnections~startsimply + SIDBStoreId , min,data=DDB)
View(DDBAggr3)

p0<-ggplot(DDBAggr3, aes(y=NumOfConnections,x=startsimply)) +  geom_point() + geom_line(aes(colour=factor(SIDBStoreId)))

p2<-ggplot(DDBAggr2, aes(y=log10(AvgQITime),x=hour)) +  geom_point() + geom_line(aes(colour=factor(SIDBStoreId)))

p3<-ggplot(DDBAggr2, aes(y=log10(AvgQITime),x=day)) +  geom_point() + geom_line(aes(colour=factor(SIDBStoreId)))

p4<-ggplot(DDBAggr2, aes(y=log10(AvgQITime),x=startsimply)) +  geom_point() + geom_line(aes(colour=factor(SIDBStoreId)))
multiplot(p0,p1, p2, p3, p4, cols=2)
}
  
###################################
####################################

DedupDataAging<-function(sidb=0,Mo=6,file='C:/Users/enzo7311/Desktop/Dati/cs499ddb2006.csv',hour=c(18,19,20,12,21,23)){
  DDB<-DedupRead(file,sidb,Mo)
  #print(file)
  print(sidb)
  View(DDB)
  
  DDBAggr1<-aggregate(ZeroRefCount~startsimply + SIDBStoreId , max,data=DDB)
  View(DDBAggr1)
  p1<-ggplot(DDBAggr1, aes(y=ZeroRefCount,x=startsimply)) +  geom_point(aes(colour=factor(SIDBStoreId))) #+ geom_line(aes(colour=factor(SIDBStoreId)))
  
  
  DDBAggr2<-aggregate(AvgQITime~startsimply + SIDBStoreId +day + hour,max,data=DDB)
  View(DDBAggr2)
  
  DDBAggr3<-aggregate(NumOfConnections~startsimply + SIDBStoreId , max,data=DDB)
  View(DDBAggr3)
  
  p0<-ggplot(DDBAggr3, aes(y=NumOfConnections,x=startsimply)) +  geom_point(aes(colour=factor(SIDBStoreId))) #+ geom_line(aes(colour=factor(SIDBStoreId)))
  
  p2<-ggplot(DDBAggr2, aes(y=log10(AvgQITime),x=hour)) +  geom_point(aes(colour=factor(SIDBStoreId))) # + geom_line(aes(colour=factor(SIDBStoreId)))
  
  p3<-ggplot(DDBAggr2, aes(y=log10(AvgQITime),x=day)) +  geom_point(aes(colour=factor(SIDBStoreId))) #+ geom_line(aes(colour=factor(SIDBStoreId)))
  
  p4<-ggplot(DDBAggr2, aes(y=log10(AvgQITime),x=startsimply)) +  geom_point(aes(colour=factor(SIDBStoreId))) #+ geom_line(aes(colour=factor(SIDBStoreId)))
  
  #p0<-boxplot(log10(AvgQITime)~day,data=DDB, main="log10(AvgQITime) over time",              xlab="Time Line", ylab="log10(AvgQITime)") 
  
  multiplot(p0,p1, p2, p3, p4, cols=2)
}

DedupDataAgingINSERT<-function(sidb=0,Mo=6,file='C:/Users/enzo7311/Desktop/Dati/cs499ddb2006.csv',hour=c(18,19,20,12,21,23)){
  DDB<-DedupRead(file,sidb,Mo)
  #print(file)
  print(sidb)
  View(DDB)

  boxplot(log10(AvgQITime)~day,data=DDB, main="log10(AvgQITime) over time",              xlab="Time Line", ylab="log10(AvgQITime)") 
  abline(h=log10(mean(DDB$AvgQITime)),col = "red")
  abline(h=log10(median(DDB$AvgQITime)),col = "blue")
  

}

DedupDataAgingConnection<-function(sidb=0,Mo=6,file='C:/Users/enzo7311/Desktop/Dati/cs499ddb2006.csv',hour=c(18,19,20,12,21,23)){
  DDB<-DedupRead(file,sidb,Mo)
  #print(file)
  print(sidb)
  View(DDB)
  
  boxplot(NumOfConnections~day,data=DDB, main="numconnection over time",              xlab="Time Line", ylab="Number Connections") 
  abline(h=mean(DDB$Connections),col = "red")
  abline(h=median(DDB$Connections),col = "blue")
  
}
DedupDataAgingRefZero<-function(sidb=0,Mo=6,file='C:/Users/enzo7311/Desktop/Dati/cs499ddb2006.csv',hour=c(18,19,20,12,21,23)){
  DDB<-DedupRead(file,sidb,Mo)
  #print(file)
  print(sidb)
  View(DDB)
  
  boxplot(ZeroRefCount~day,data=DDB, main="ZeroRefCount over time",              xlab="Time Line", ylab="ZeroRefCount") 
  abline(h=mean(DDB$ZeroRefCount),col = "red")
  abline(h=median(DDB$ZeroRefCount),col = "blue")
  
}



DedupDataAgingINSERTHours<-function(sidb=0,Mo=6,file='C:/Users/enzo7311/Desktop/Dati/cs499ddb2006.csv',hour=c(18,19,20,12,21,23)){
  DDB<-DedupRead(file,sidb,Mo)
  #print(file)
  print(sidb)
  View(DDB)
  print(mean(DDB$AvgQITime))
  print(log10(mean(DDB$AvgQITime)))
  boxplot(log10(AvgQITime)~hour,data=DDB, main="log10(AvgQITime) By Hours",              xlab="Hour", ylab="log10(AvgQITime)") 
  abline(h=log10(mean(DDB$AvgQITime)),col = "red")
  abline(h=log10(median(DDB$AvgQITime)),col = "blue")
  
}






























####################################
####                    TREND

##############################################
DedupTrendAnalysis<-function(sidb=0,Mo=6,file='C:/Users/enzo7311/Desktop/Dati/cs7ddb1506.csv', hour=0){
  DDB<-DedupRead(file,sidb,Mo)
  #print(file)
  print(sidb)
  DDB<-DDB[with(DDB, order(startsimply)), ]
  View(DDB)
  #plot(DDB$NumOfConnections)

  DDB.stl = stl(DDB$NumOfConnections, s.window="periodic")
  plot(DDB.stl)
# ggplot(DDB,aes(y=NumOfConnections))+  geom_point() + geom_line(aes(colour=factor(SIDBStoreId)))
  #p2<-ggplot(DDBAggr2, aes(y=log10(AvgQITime),x=hour)) +  geom_point() + geom_line(aes(colour=factor(SIDBStoreId)))
  
  #p3<-ggplot(DDBAggr2, aes(y=log10(AvgQITime),x=day)) +  geom_point() + geom_line(aes(colour=factor(SIDBStoreId)))
  
  #p4<-ggplot(DDBAggr2, aes(y=log10(AvgQITime),x=startsimply)) +  geom_point() + geom_line(aes(colour=factor(SIDBStoreId)))
#  multiplot(p0, cols=1)
}






















##############################

regressionDDB<-function(file='C:/Users/enzo7311/Desktop/dati/cs403ddb1306.csv', sidb=0){
  DDB<-DedupRead(file,sidb)
#  DDB<-DedupReadGlobal(file)
  print("Coefficient con lo spazio usato")
  print(coef(lm(DDB$SizeOccupied~DDB$PrimaryEntries+DDB$SecondaryEntries)))
  print("Correlazione con zerRef")

print(cor(DDB$AvgQITime,DDB$ZeroRefCount))
print("mean insert time")

print(mean(DDB$AvgQITime))

  print(mean(DDB$trughput))

print("summary Troughput globale")
print(summary(DDB$trughput))

DDBP<-subset(DDB,DDB$ZeroRefCount>10)
  DDBL<-subset(DDB,DDB$ZeroRefCount<10)
print("summary con REFZero")
  #print(mean(DDBP$AvgQITime))
  #print(mean(DDBP$trughput))
  print(summary(DDBP$trughput))
  print("senza refCount")
  print(summary(DDBL$trughput))

#  print("Correlazione con zerRef Afetr Purification")
#  print(cor(DDBP$AvgQITime,DDBP$ZeroRefCount))

print("summary Zero ref only global")
   print(summary(DDBP$ZeroRefCount))

hist(DDBP$trughput)
#  hist(DDBL$trughput)
}
# Multiple plot function
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
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