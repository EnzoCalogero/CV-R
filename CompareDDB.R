#########################################################################
## Ddedup Analysis of DDB Comparing Two Different Time Interval #########
#########################################################################

#########################################################################
### DDB_Compare() consider all the sidb on thesubject ###################
#########################################################################
### roundDDB_Compare() iterate the previous function to a given set #####
#########################################################################

roundDDB_Compare<-function(sidb=c(63,77,70,68)){
  for (ddb in sidb ){
    DDB_Compare(sidb=ddb)    
  }
}

DDB_Compare<-function(sidb=c(63,77,70,68),Mo=c(12,11),file='C:/Users/enzo7311/Desktop/Dati/CS901ddb2312.csv',Days=c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),hour=0){
  library(ggplot2)
  library(doBy)
  DDB<-DedupRead(file,sidb,Mo,Days)
 # DDB<-subset(DDB,(day>15))
  
  ###Filter 
  
  DDB<-subset(DDB,(HistoryType==0))
  DDB<-subset(DDB,DDB$day >5)
  
  DDB<-subset(DDB,(DDB$hour >17)|(DDB$hour <10))
  
  DDB_After<-subset(DDB,(DDB$day<21)&(DDB$Month==12))
  DDB_Before<-subset(DDB,(DDB$day>15)&(DDB$Month==11))
  
  DDB<-subset(DDB,((DDB$day>15)&(DDB$Month==11))|(DDB$Month==12))
  
  
  #print(file)
  print(sidb)
  View(DDB)
  View(DDB_After)
  View(DDB_Before)
  
  
  m1 <- ggplot(DDB, aes(x = log10(AvgQITime)))+ geom_vline(xintercept = 3.3,colour="green", linetype = "longdash")+ geom_density(aes(fill=factor(SIDBStoreId)))
  print("average global:")
  print(mean(DDB$AvgQITime))
  m1a <- ggplot(DDB_After, aes(x = log10(AvgQITime)))+ geom_density(aes(fill=factor(SIDBStoreId)))+  ggtitle("QITime After")+ geom_vline(xintercept = 3.3, colour="red", linetype = "longdash")
  
  
  print("average After:")
  print(mean(DDB_After$AvgQITime))
  print(aggregate( AvgQITime~SIDBStoreId, DDB_After, mean ))
  print("MAX")
  print(aggregate( AvgQITime~SIDBStoreId, DDB_After, max ))
  m1b <- ggplot(DDB_Before, aes(x = log10(AvgQITime)))+ geom_density(aes(fill=factor(SIDBStoreId)))+  ggtitle("QITime Before")+ geom_vline(xintercept = 3.3, colour="red", linetype = "longdash")
  print("average before:")
  print(mean(DDB_Before$AvgQITime))
  print(aggregate( AvgQITime~SIDBStoreId, DDB_Before, mean ))
  print("MAX")
  print(aggregate( AvgQITime~SIDBStoreId, DDB_Before, max ))
  
  p1a <- ggplot(DDB_After, aes(x = log10(ZeroRefCount)))+ geom_density(aes(fill=factor(SIDBStoreId)))+  ggtitle("ZeroRefCount After")
  print("average ZeroRefCount After:")
  print(mean(DDB_After$ZeroRefCount))
  print(aggregate( ZeroRefCount~SIDBStoreId, DDB_After, mean ))
  print("MAX")
  print(aggregate( ZeroRefCount~SIDBStoreId, DDB_After, max ))
  p1b <- ggplot(DDB_Before, aes(x = log10(ZeroRefCount)))+ geom_density(aes(fill=factor(SIDBStoreId)))+  ggtitle("ZeroRefCount Before")
  print("average ZeroRefCountbefore:")
  print(mean(DDB_Before$ZeroRefCount))
  print(aggregate( ZeroRefCount~SIDBStoreId, DDB_Before, mean ))
  print("MAX")
  print(aggregate( ZeroRefCount~SIDBStoreId, DDB_Before, max ))
  
  
  
  
  
  #DDB<-subset(DDB,DDB$AvgQITime >0) #& DDB$AvgQITime <10000)
  t0AF<- ggplot(DDB_After, aes(x=Date,y=AvgQITime))+ stat_smooth()+ facet_grid(SIDBStoreId ~. ) + ylim(0,10000) + geom_point()+ggtitle("QITime After")
  t0bf<- ggplot(DDB_Before, aes(x=Date,y=AvgQITime))+ stat_smooth()+ facet_grid(SIDBStoreId ~. ) + ylim(0,10000) + geom_point()+ggtitle("QITime Before")
  
  c0AF<- ggplot(DDB_After, aes(x=Date,y=NumOfConnections))+ stat_smooth()+ facet_grid(SIDBStoreId ~. )  + geom_point()+ggtitle("N Connections After")
  c0bf<- ggplot(DDB_Before, aes(x=Date,y=NumOfConnections))+ stat_smooth()+ facet_grid(SIDBStoreId ~. ) + geom_point()+ggtitle("N Connections Before")
  
  t1AF<- ggplot(DDB_After, aes(x=Date,y=(ZeroRefCount)))+ facet_grid(SIDBStoreId ~. )+ geom_point()+ stat_smooth() +ggtitle("ZeroRef After")
  t1bf<- ggplot(DDB_Before, aes(x=Date,y=(ZeroRefCount)))+ facet_grid(SIDBStoreId ~. )+ geom_point()+ stat_smooth()+ggtitle("ZeroRef Before")
  
  multiplot(m1b,m1a, cols=2)
 # multiplot(p1b,p1a, cols=2)
  multiplot(t0bf,t0AF, cols=2)
  multiplot(t1bf,t1AF, cols=2)
#  multiplot(c0bf,c0AF, cols=2)
}