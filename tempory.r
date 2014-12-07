#######################################################
#FOR ANALISIS of insert time during the hour of the day
#######################################################
#file='C:/Users/enzo7311/Desktop/Dati/cs902ddb26_11.csv'
DDB_Analysis_hour<-function(sidb=12,Mo=c(11,10),file='C:/Users/enzo7311/Desktop/Dati/cs402ddb1128.csv',hour=0){
  library(ggplot2)
  library(doBy)
  border=100000
  DDB<-DedupRead(file,sidb,Mo)
  
  #print(file)
  print(sidb)
  
  ###Basic
  mean(DDB$AvgQITime)
  print(cor(DDB$AvgQITime,log(DDB$ZeroRefCount+1)))
  print ("go")
  av<-ts(log10(DDB$AvgQITime+1))
  zr<-ts(log10(DDB$ZeroRefCount+1))
  ccf(av,zr)
  
  print("stop")
  
  
  
  ###
  #DDB$AvgQITime
  DDBIns<-subset(DDB,(DDB$hour <18) &(DDB$hour >9))
  
  
  
  
  #DDB<-subset(DDB,(DDB$hour >17)|(DDB$hour <10))
  DDB2<-subset(DDB,DDB$ZeroRefCount ==0)
  DDB3<-subset(DDB,DDB$ZeroRefCount > border)
  print("mean global")
  print(mean(DDB$AvgQITime))
  print("mean outside backup")
  print(mean(DDBIns$AvgQITime))
  print("correlazione standard")
  print(cor(DDB$AvgQITime,DDB$ZeroRefCount))
  
  print("correlazione log standard")
  print(cor(log(DDB$AvgQITime+1),log(DDB$ZeroRefCount+1)))
  
  print("correlazione log Filter dstandard")
  print(cor(log(DDB3$AvgQITime+1),log(DDB3$ZeroRefCount+1)))
  
  print("correlazione log Primary standard")
  print(cor(log(DDB$PrimaryEntries+1),log(DDB$AvgQITime+1)))
  
  print("correlazione log Primary standard  filterd")
  print(cor(log(DDB2$PrimaryEntries+1),log(DDB2$AvgQITime+1)))
  
  print("correlazione log Secondary standard  filterd")
  print(cor(log(DDB2$SecondaryEntries+1),log(DDB2$AvgQITime+1)))
  
  print("correlazione log Secondary standard  no filterd")
  print(cor(log(DDB$SecondaryEntries+1),log(DDB$AvgQITime+1)))
  DDB<-subset(DDB,(DDB$hour >17)|(DDB$hour <10))
  DDB2<-subset(DDB,DDB$ZeroRefCount ==0)
  DDB3<-subset(DDB,DDB$ZeroRefCount > border)
  
  print("post")  
  print("mean during Backup")
  print(mean(DDB$AvgQITime))
  
  
  View(DDB2)
  View(DDB3)
  print("correlazione standard")
  print(cor(DDB$AvgQITime,DDB$ZeroRefCount))
  
  print("correlazione log standard")
  print(cor(log(DDB$AvgQITime+1),log(DDB$ZeroRefCount+1)))
  
  print("correlazione log Filter dstandard")
  print(cor(log(DDB3$AvgQITime+1),log(DDB3$ZeroRefCount+1)))
  
  print("correlazione log Primary standard")
  print(cor(log(DDB$PrimaryEntries+1),log(DDB$AvgQITime+1)))
  
  print("correlazione log Primary standard  filterd")
  print(cor(log(DDB2$PrimaryEntries+1),log(DDB2$AvgQITime+1)))
  
  print("correlazione log Secondary standard  filterd")
  print(cor(log(DDB2$SecondaryEntries+1),log(DDB2$AvgQITime+1)))
  
  print("correlazione log Secondary standard  no filterd")
  print(cor(log(DDB$SecondaryEntries+1),log(DDB$AvgQITime+1)))
  
  print("Filtered")
  #mean(DDB2$AvgQITime)
  #print(cor(DDB2$AvgQITime,DDB2$ZeroRefCount))
  View(DDB)
  m1 <- ggplot(DDB, aes(x = log10(AvgQITime)))+ geom_density()+ ggtitle("global")+ facet_grid(SIDBStoreId ~.)#aes(fill=factor(SIDBStoreId))
  m2 <- ggplot(DDB, aes(x = log10(AvgQITime)))+ geom_density()+ facet_grid(hour ~.)
  
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
  multiplot(m2, cols=2)
  multiplot(m3,m4, cols=2)
  multiplot(m5,m6, cols=2)
  #multiplot(m7,m8, cols=2)
  # multiplot(t0,t5, cols=2)
}

#######################################################
#FOR ANALISIS of Probabilistic analysis
#######################################################

DDB_Prob<-function(sidb=c(152),Mo=c(11,10),file='C:/Users/enzo7311/Desktop/Dati/cs902ddb26_11.csv',hour=0){
  library(ggplot2)
  library(doBy)
  DDB<-DedupRead(file,sidb,Mo)
  
  #print(file)
  print(sidb)
  limit=1000
  print("Limit")
  print (limit)
  DDB$AvgQITimeStatus<-DDB$AvgQITime
  DDB$AvgQITimeStatus[DDB$AvgQITimeStatus<limit]<-0
  DDB$AvgQITimeStatus[DDB$AvgQITimeStatus>limit]<-1
  ###Basic
  mean(DDB$AvgQITime)
  print(cor(DDB$AvgQITime,log(DDB$ZeroRefCount+1)))
  
  ###
  #DDB$AvgQITime
  DDBIns<-subset(DDB,(DDB$hour <18) &(DDB$hour >9))
  
  
  
  DDB<-subset(DDB,(DDB$hour >17)|(DDB$hour <10))

  #DDB<-subset(DDB,(DDB$hour >17)|(DDB$hour <10))
  DDB2<-subset(DDB,DDB$ZeroRefCount ==0)
  DDB3<-subset(DDB,(DDB$ZeroRefCount > 10)&(DDB$ZeroRefCount < 10^7))
  
  
  View(DDB)
  View(DDB2)
  View(DDB3)
  PMAG<-nrow(DDB3)
  PINTERSECT<-nrow(subset(DDB3,DDB3$AvgQITimeStatus>0))
  print(PMAG)
  print(PINTERSECT)
  print(100*PINTERSECT/PMAG)
  print(glm(formula = DDB$AvgQITimeStatus ~DDB$ZeroRefCount , family = binomial(link = "logit")))
  plot(glm(formula = DDB$AvgQITimeStatus ~DDB$ZeroRefCount , family = binomial(link = "logit")))
  m1 <- ggplot(DDB, aes(x = log10(ZeroRefCount),y=AvgQITimeStatus))+ geom_point()+ ggtitle("global")
  m2 <- ggplot(DDB3, aes(x = log10(ZeroRefCount),y=log10(AvgQITime)))+ geom_point()+ ggtitle("global")+ stat_smooth()
  
  multiplot(m1, cols=2)
  multiplot(m2, cols=2)
#multiplot(m7,m8, cols=2)
 # multiplot(t0,t5, cols=2)
}





JOBAnalysisTIME<-function(Mo=0,file='C:/Users/enzo7311/Desktop/dati/CS907jobs2110.csv',MAgent='all',SP='all', time="2014-10-12 18:00:00"){
  library(ggplot2)
  library(gcookbook)
  library(lubridate)
  #Read the big File######
  
  jobs <- CleanDBData(Mo,file,MAgent)
  #DDB$nightImp[DDB$hour>12]<-DDB$nightImp+1
  jobs$border<-jobs$Start_Time
  #2014-10-01 02:00:00
  ############################   Analysis  ###################
  
  if(SP!='all'){
    jobs<-subset(jobs,jobs$data_sp %in%  SP)
  }
  
  
  ##########
  #Working here###
  ##############
  
  alpha<-aggregate(numbytescomp~Start_Time+data_sp,sum,data=jobs) 
  alpha$Start_Time<-ymd_hms(alpha$Start_Time)
  
  View(alpha)
  alpha1<-aggregate(durationunixsec  ~Start_Time+data_sp,sum,data=jobs) 
  alpha1$Start_Time<-ymd_hms(alpha1$Start_Time)
  
  View(alpha1)
  alpha2<-aggregate(Throughput  ~Start_Time+data_sp,mean,data=jobs) 
  alpha2$Start_Time<-ymd_hms(alpha2$Start_Time)
  
  View(alpha2)
  
  p0<-ggplot(alpha, aes(x=Start_Time,y=numbytescomp)) + ggtitle("Backup Size over Time") + geom_point(aes(colour=factor(data_sp))) +geom_line(aes(colour=factor(data_sp)))+ stat_smooth(aes(colour=factor(data_sp)))
  p1<-ggplot(alpha1, aes(x=Start_Time,y=durationunixsec  )) + ggtitle("Backup Duration over Time")+  geom_point(aes(colour=factor(data_sp))) +geom_line(aes(colour=factor(data_sp)))+ stat_smooth(aes(colour=factor(data_sp)))
  p2<-ggplot(alpha2, aes(x=Start_Time,y=Throughput  ))+ ggtitle("BackupTroughPut over Time") +  geom_point(aes(colour=factor(data_sp))) +geom_line(aes(colour=factor(data_sp)))+ stat_smooth(aes(colour=factor(data_sp)))
  
  t2<- ggplot(jobs, aes(x=WDay,y=Throughput))+ facet_grid(data_sp  ~. )+  geom_boxplot()+ stat_smooth()
  t1<- ggplot(jobs, aes(x=hour,y=Throughput))+ facet_grid(data_sp  ~. )+  geom_boxplot()+ stat_smooth()
  t3<- ggplot(jobs, aes(x=WDay,y=numbytescomp))+ facet_grid(data_sp  ~. )+  geom_boxplot()+ stat_smooth()
  g0<-ggplot(jobs, aes(x=durationunixsec,y=numbytescomp)) +  geom_point(aes(colour=factor(data_sp)))
  m1 <- ggplot(jobs, aes(x = log10(numbytescomp)))+ ggtitle("Backup Size Distribution")+ geom_density(aes(fill=factor(data_sp)))
  multiplot(p2,cols=2)
  #    multiplot(m1,p0,p1,p2,t1,t2,t3,g0, cols=2)
}
