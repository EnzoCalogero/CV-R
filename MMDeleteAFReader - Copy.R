####################################################
##This script read teh created file AFIDSummary.csv
## create by the MMDELETEAF.R scipts...
###And analise the data...
#######################################################


MMAFDeleted_Reader<-function(day=0,file='AF.csv',escludingSIDB=c(20,12)){
  library(ggplot2)
  timeZero<-"2015-01-30"
  #escludingSIDB<-c(20,12)
  AFDEL <- read.csv(file)
 # View(AFDEL )
  Afescluded<-subset(AFDEL,(SIDBStoreId %in%  escludingSIDB))
  View(Afescluded)
 
 AfescludedAggr<-aggregate(CapacityFreedBytes~Day+SIDBStoreId, sum,data=Afescluded)
 View(AfescludedAggr)
  
 t0<-ggplot(AfescludedAggr,)+ geom_point(aes(x=Day,y=CapacityFreedBytes)) 
 t0<-t0+ geom_line(aes(x=Day,y=CapacityFreedBytes,colour=factor(SIDBStoreId)))
 t0<-t0+ facet_grid(SIDBStoreId  ~. )+ ggtitle("TBs from Corrupted From The Day 0 Per SIDB")
 t0<-t0+xlab("Days since the First Data Aging")+ylab("TBs in Pending Deletion")
 multiplot(t0, cols=1)
 
 AFDEL<-subset(AFDEL,!(SIDBStoreId %in%  escludingSIDB))
  AFDay0<-subset(AFDEL,DeletedTime==timeZero)
#  View(AFDay0 )
  
  AFDay0Aggr<-aggregate(CapacityFreedBytes~Day, sum,data=AFDay0)
  View(AFDay0Aggr)
  
  t1<-ggplot(AFDay0,)+ geom_point(aes(x=Day,y=CapacityFreedBytes)) 
  t1<-t1+ geom_line(aes(x=Day,y=CapacityFreedBytes,colour=factor(SIDBStoreId)))
  t1<-t1+ facet_grid(SIDBStoreId  ~. )+ ggtitle("TBs To Be Relase From The Day 0 Per SIDB")
  t1<-t1+xlab("Days since the First Data Aging")+ylab("TBs in Pending Deletion")
  multiplot(t1, cols=1)
  
  t2<-ggplot(AFDay0Aggr,)+ geom_point(aes(x=Day,y=CapacityFreedBytes)) 
  t2<-t2+ geom_line(aes(x=Day,y=CapacityFreedBytes))+ ggtitle("TBs to Be Relase from the Day 0 -Aggregated-")
  t2<-t2+xlab("Days since the First Data Aging")+ylab("TBs in Pending Deletion")

 multiplot(t2, cols=1)
  
  postDay0<-subset(AFDEL,DeletedTime!=timeZero)
  
  View(postDay0 )
 # t3<-ggplot(postDay0,)+ geom_point(aes(x=DeletedTime,y=CapacityFreedBytes,colour="red")) + geom_line(aes(x=Day,y=CapacityFreedBytes,colour=factor(SIDBStoreId)))+ facet_grid(SIDBStoreId  ~. )
  #multiplot(t3, cols=1)

  AFPostDay0AggrSIDB<-aggregate(CapacityFreedBytes~Day+SIDBStoreId, sum,data=postDay0)
  View(AFPostDay0AggrSIDB)
  t3<-ggplot(AFPostDay0AggrSIDB,)+ geom_point(aes(x=Day,y=CapacityFreedBytes)) 
  t3<-t3+ geom_line(aes(x=Day,y=CapacityFreedBytes))+ facet_grid(SIDBStoreId  ~. )
  t3<-t3+ ggtitle("TBs to be Relased, Accumulated After The Day 0 Per SIDB")
  t3<-t3+xlab("Days since the First Data Aging")+ylab("TBs in Pending Deletion") 
multiplot(t3, cols=1)
  
  

  AFPostDay0Aggr<-aggregate(CapacityFreedBytes~Day, sum,data=postDay0)
  View(AFPostDay0Aggr)
  t4<-ggplot(AFPostDay0Aggr,)+ geom_point(aes(x=Day,y=CapacityFreedBytes)) + geom_line(aes(x=Day,y=CapacityFreedBytes))
  t4<-t4+ ggtitle("TB To Be Relased Accumulated After the Day 0 - Aggregate-")
  t4<-t4+xlab("Days since the First Data Aging")+ylab("TBs in Pending Deletion")
  multiplot(t4, cols=1)
  
  t5<-ggplot(AFDEL,)+ geom_point(aes(x=Day,y=CapacityFreedBytes)) 
  t5<-t5+ geom_line(aes(x=Day,y=CapacityFreedBytes,colour=factor(SIDBStoreId)))+ facet_grid(SIDBStoreId  ~. )
  t5<-t5+ ggtitle("Total TBs Pending To Be Relased  Per SIDB")
  t5<-t5+xlab("Days since the First Data Aging")+ylab("TBs in Pending Deletion")
  multiplot(t5, cols=5)
  
  AFAggr<-aggregate(CapacityFreedBytes~Day, sum,data=AFDEL)
  View(AFAggr)
  t6<-ggplot(AFAggr,)+ geom_point(aes(x=Day,y=CapacityFreedBytes)) 
  t6<-t6+ ggtitle("Total TBs Pending To Be Relased")+ geom_line(aes(x=Day,y=CapacityFreedBytes))
  t6<-t6+xlab("Days since the First Data Aging")+ylab("TBs in Pending Deletion")  
multiplot(t6, cols=1)
}