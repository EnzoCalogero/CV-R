dedupOvertime<-function(sidb=0,Mo=c(12,9,10,11),file='C:/Users/enzo7311/Desktop/Dati/CS901ddb2312.csv',Days=c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),hour=0){
  for (mese in 10:12) {
    DDB_Analysis(sidb=76,Mo=mese)
    print(mese)
  }
  
  
 for (mese in 10:12) {
   DDB_Analysis_hourMod(sidb=76,Mo=mese)
   print(mese)
   }
 
  
  
  
}

DDB_Analysis_hourMod<-function(sidb=12,Mo=c(11,10),file='C:/Users/enzo7311/Desktop/Dati/CS903ddb2312.csv',hour=0){
  library(ggplot2)
  library(doBy)
  #The border is where to define pending records relevant
  border=100000
  DDB<-DedupRead(file,sidb,Mo)
  
  #print(file)
  print(sidb)
  
  ###Basic
  mean(DDB$AvgQITime)
  print(cor(DDB$AvgQITime,log(DDB$ZeroRefCount+1)))
  print ("go")
  #av<-ts(log10(DDB$AvgQITime+1))
  #zr<-ts(log10(DDB$ZeroRefCount+1))
  #ccf(av,zr)
  
  print("stop")
  
  
  
  ###
  #DDB$AvgQITime
  DDBIns<-subset(DDB,(DDB$hour <18) &(DDB$hour >9))
  
  
  
  
  #DDB<-subset(DDB,(DDB$hour >17)|(DDB$hour <10))
  DDB2<-subset(DDB,DDB$ZeroRefCount ==0)
  DDB3<-subset(DDB,DDB$ZeroRefCount > border)
#   print("mean global")
#   print(mean(DDB$AvgQITime))
#   print("mean outside backup")
#   print(mean(DDBIns$AvgQITime))
#   print("correlazione standard")
#   print(cor(DDB$AvgQITime,DDB$ZeroRefCount))
#   
#   print("correlazione log standard")
#   print(cor(log(DDB$AvgQITime+1),log(DDB$ZeroRefCount+1)))
#   
#   print("correlazione log Filter dstandard")
#   print(cor(log(DDB3$AvgQITime+1),log(DDB3$ZeroRefCount+1)))
#   
#   print("correlazione log Primary standard")
#   print(cor(log(DDB$PrimaryEntries+1),log(DDB$AvgQITime+1)))
#   
#   print("correlazione log Primary standard  filterd")
#   print(cor(log(DDB2$PrimaryEntries+1),log(DDB2$AvgQITime+1)))
#   
#   print("correlazione log Secondary standard  filterd")
#   print(cor(log(DDB2$SecondaryEntries+1),log(DDB2$AvgQITime+1)))
#   
#   print("correlazione log Secondary standard  no filterd")
#   print(cor(log(DDB$SecondaryEntries+1),log(DDB$AvgQITime+1)))
#   DDB<-subset(DDB,(DDB$hour >17)|(DDB$hour <10))
  DDB2<-subset(DDB,DDB$ZeroRefCount ==0)
  DDB3<-subset(DDB,DDB$ZeroRefCount > border)
  
#   print("post")  
#   print("mean during Backup")
#   print(mean(DDB$AvgQITime))
#   
#   
#   View(DDB2)
#   View(DDB3)
#   print("correlazione standard")
#   print(cor(DDB$AvgQITime,DDB$ZeroRefCount))
#   
#   print("correlazione log standard")
#   print(cor(log(DDB$AvgQITime+1),log(DDB$ZeroRefCount+1)))
#   
#   print("correlazione log Filter dstandard")
#   print(cor(log(DDB3$AvgQITime+1),log(DDB3$ZeroRefCount+1)))
#   
#   print("correlazione log Primary standard")
#   print(cor(log(DDB$PrimaryEntries+1),log(DDB$AvgQITime+1)))
#   
#   print("correlazione log Primary standard  filterd")
#   print(cor(log(DDB2$PrimaryEntries+1),log(DDB2$AvgQITime+1)))
#   
#   print("correlazione log Secondary standard  filterd")
#   print(cor(log(DDB2$SecondaryEntries+1),log(DDB2$AvgQITime+1)))
#   
#   print("correlazione log Secondary standard  no filterd")
#   print(cor(log(DDB$SecondaryEntries+1),log(DDB$AvgQITime+1)))
#   
#   print("Filtered")
#   #mean(DDB2$AvgQITime)
#   #print(cor(DDB2$AvgQITime,DDB2$ZeroRefCount))
#  View(DDB)

  m1 <- ggplot(DDB, aes(x = log10(AvgQITime)))+ geom_density()+ ggtitle(Mo)+ facet_grid(SIDBStoreId ~.)#aes(fill=factor(SIDBStoreId))
  m2 <- ggplot(DDB, aes(x = log10(AvgQITime)))+ geom_density()+ facet_grid(hour ~.)+ ggtitle( Mo)
  
  m3 <- ggplot(DDB2, aes(x = log10(AvgQITime)))+ geom_density()+ facet_grid(hour ~.) +ggtitle("non pending")
  m4 <- ggplot(DDB3, aes(x = log10(AvgQITime)))+ geom_density()+ facet_grid(hour ~.) +ggtitle(" pending")
  m5 <- ggplot(DDB2, aes(x = log10(AvgQITime)))+ geom_density()+ggtitle("non pending")
  m6 <- ggplot(DDB3, aes(x = log10(AvgQITime)))+ geom_density() +ggtitle(" pending")
  
  
  m7 <- ggplot(DDBIns, aes(x = log10(AvgQITime)))+ geom_density(aes(fill=factor(SIDBStoreId)))+ ggtitle("global Outside Backup Window")
  m8 <- ggplot(DDBIns, aes(x = log10(AvgQITime)))+ geom_density()+ facet_grid(hour ~.) +ggtitle("global Outside Backup Window")
  
  DDB<-subset(DDB,DDB$AvgQITime >0) #& DDB$AvgQITime <10000)
  t0<- ggplot(DDB, aes(x=Date,y=AvgQITime))+ facet_grid(SIDBStoreId ~. ) + ylim(0,10000) + geom_point()+ stat_smooth()
  t1<- ggplot(DDB, aes(x=Date,y=(ZeroRefCount)))+ facet_grid(SIDBStoreId ~. )+ geom_point()+ stat_smooth()
  t2<- ggplot(DDB, aes(x=WDay,y=AvgQITime))+ facet_grid(SIDBStoreId ~. )+  geom_boxplot()+ stat_smooth()
  t3<- ggplot(DDB, aes(x=WDay,y=ZeroRefCount))+ facet_grid(SIDBStoreId ~. )+  geom_boxplot()+ stat_smooth()
  t4<- ggplot(DDB, aes(x=Date,y=DDBManagedSize))+ facet_grid(SIDBStoreId ~. )+ geom_point()+ stat_smooth()
  t5<- ggplot(DDB, aes(x=Date,y=PrimaryEntries))+ facet_grid(SIDBStoreId ~. )+ geom_point()+ stat_smooth()
  t6<- ggplot(DDB, aes(x=Date,y=SecondaryEntries))+ facet_grid(SIDBStoreId ~. )+ geom_point()+ stat_smooth()
  #t2
  multiplot(m1, cols=2)
  #multiplot(m2, cols=2)
  #multiplot(m3,m4, cols=2)
  multiplot(m5,m6, cols=2)
  #multiplot(m7,m8, cols=2)
  # multiplot(t0,t5, cols=2)
}
