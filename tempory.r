

#######################################################
#FOR ANALISIS of insert time during the hour of the day
#######################################################

DDB_Analysis_hour<-function(sidb=2,Mo=c(7,8,9,10),file='C:/Users/enzo7311/Desktop/Dati/cs404ddb1109.csv',hour=0){
  library(ggplot2)
  library(doBy)
  DDB<-DedupRead(file,sidb,Mo)
  
  #print(file)
  print(sidb)
  View(DDB)
  
  
  
  m1 <- ggplot(DDB, aes(x = log10(AvgQITime)))+ geom_density(aes(fill=factor(SIDBStoreId)))
  m2 <- ggplot(DDB, aes(x = log10(AvgQITime)))+ geom_density()+ facet_grid(hour ~.)
  
  DDB<-subset(DDB,DDB$AvgQITime >0) #& DDB$AvgQITime <10000)
  t0<- ggplot(DDB, aes(x=Date,y=AvgQITime))+ facet_grid(SIDBStoreId ~. ) + ylim(0,10000) + geom_point()+ stat_smooth()
  t1<- ggplot(DDB, aes(x=Date,y=(ZeroRefCount)))+ facet_grid(SIDBStoreId ~. )+ geom_point()+ stat_smooth()
  t2<- ggplot(DDB, aes(x=WDay,y=AvgQITime))+ facet_grid(SIDBStoreId ~. )+  geom_boxplot()+ stat_smooth()
  t3<- ggplot(DDB, aes(x=WDay,y=ZeroRefCount))+ facet_grid(SIDBStoreId ~. )+  geom_boxplot()+ stat_smooth()
  t4<- ggplot(DDB, aes(x=Date,y=DDBManagedSize))+ facet_grid(SIDBStoreId ~. )+ geom_point()+ stat_smooth()
  t5<- ggplot(DDB, aes(x=Date,y=PrimaryEntries))+ facet_grid(SIDBStoreId ~. )+ geom_point()+ stat_smooth()
  t6<- ggplot(DDB, aes(x=Date,y=SecondaryEntries))+ facet_grid(SIDBStoreId ~. )+ geom_point()+ stat_smooth()
  #t2
   multiplot(m2, cols=2)
  #multiplot(t0,t5, cols=2)
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
