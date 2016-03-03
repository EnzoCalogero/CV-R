############################################################################################
###   Note                 #####
## MMAFDeleted_Analysis --> test a single file output capacity, AFID, application size
## MMAFDeleted_cond --> connected to MM_final analysed file by file 
## MM_final --> aggregate all the file  on the list on a single file.
## MMAFDeleted_TimeAnalysis --> time analysis of new AFids
#############################################################################################MMDELcs904_08_04.csv'){
MMAFDeleted_TimeAnalysis<-function(day=0,file='C:/dati/af/af.csv'){ 
  library(ggplot2)
  library(doBy)  
  library(lubridate)
  #DDB<-DedupRead(file,sidb,Mo)
  AFDEL <- read.csv(file,sep=";")
  
  nome<-c("archFileId","VolumeId","Status","Retry","copyId","cclip")
  nome<-c(nome,"CapacityFreedBytes","ArchChunkId","MountPathId","SIDBStoreId")
  nome<-c(nome,"CommCellId","DeletedTime","FailureErrorCode","subStoreBitField")
  nome<-c(nome,"sidbPruningFlag","appSizeFreedBytes","reserveInt")
  names(AFDEL)<-nome
  
  
  AFDEL$CapacityFreedBytes<-(AFDEL$CapacityFreedBytes)/(1024^4)
  AFDEL$appSizeFreedBytes<-(AFDEL$appSizeFreedBytes)/(1024^4)
  AFDEL$DeletedTime<-as.POSIXct(AFDEL$DeletedTime,origin="1970-01-01")
  #print(file)
  AFDEL$DeletedTime<-floor_date(AFDEL$DeletedTime, "day")
  View(AFDEL)
 
  AFIDAggr<-aggregate(CapacityFreedBytes~DeletedTime+SIDBStoreId, sum,data= AFDEL)
  View(AFIDAggr)
  AFIDAggrCurrent<-aggregate(CapacityFreedBytes~SIDBStoreId, sum,data= AFDEL)
  View(AFIDAggrCurrent)
  AFIDAggr<-AFIDAggr[AFIDAggr$SIDBStoreId!=12,]
  t1<-ggplot(AFIDAggr,)+ geom_point(aes(x=DeletedTime,y=CapacityFreedBytes,ylim=25))   + facet_grid(SIDBStoreId  ~. )
  multiplot(t1, cols=1)
  
}


##afdelete1_02.csv
MMAFDeleted_Analysis<-function(day=0,file='C:/Users/enzo7311/Desktop/cs406DAIssue/afdelete5_02.csv'){
  library(ggplot2)
  library(doBy)  
  library(lubridate)
  #DDB<-DedupRead(file,sidb,Mo)
  AFDEL <- read.csv(file)
  AFDEL$CapacityFreedBytes<-(AFDEL$CapacityFreedBytes)/(1024^4)
  AFDEL$appSizeFreedBytes<-(AFDEL$appSizeFreedBytes)/(1024^4)
  #print(file)
 
  View(AFDEL)
  AFDEL1<-aggregate(cbind(appSizeFreedBytes,CapacityFreedBytes)~SIDBStoreId,sum,data=AFDEL)
  View(AFDEL1)
  AFDEL2<-aggregate(appSizeFreedBytes~SIDBStoreId,sum,data=AFDEL)
  View(AFDEL2)
  Table<-(as.data.frame(table(AFDEL$SIDBStoreId)))
  View(Table)
  
  AFDEL1b<-aggregate(cbind(appSizeFreedBytes,CapacityFreedBytes)~MountPathId,sum,data=AFDEL)
  View(AFDEL1b)
  AFDEL2b<-aggregate(appSizeFreedBytes~MountPathId,sum,data=AFDEL)
  View(AFDEL2b)
  Tableb<-(as.data.frame(table(AFDEL$MountPathId)))
  View(Tableb)
  
}

MM_final<-function(){
  library(doBy)  
  library(lubridate)
  
#  AFSummary<--10000
  ### couple of days and associated files
  Current_folder<-'C:/Users/enzo7311/Desktop/cs406DAIssue/'
  
  listFiles<-list(c(day=0,file="afdelete.csv"),  c(day=1,file="afdelete31_01.csv"),  c(day=2,file="afdelete1_02.csv"),
                  c(day=3,file="afdelete2_02.csv"),
                  c(day=4,file="afdelete3_02.csv"),
                  c(day=5,file="afdelete4_02.csv"),
                  c(day=6,file="afdelete5_02.csv"),
                  c(day=7,file="afdelete6_02.csv"),
                  c(day=8,file="afdelete7_02.csv"),
                  c(day=9,file="afdelete8_02.csv"),
                  c(day=10,file="afdelete9_02.csv"),
                  c(day=11,file="afdelete10_02.csv"),
                  c(day=12,file="afdelete11_02.csv"),
                  c(day=13,file="afdelete12_02.csv"),
                  c(day=14,file="afdelete13_02.csv"))
  #listFiles<-list(c(day=1,file="afdelete8_02.csv"),c(day=2,file="afdelete7_02.csv"))#,c(day=3,file="afdelete8_02.csv"))
 
  
  print(listFiles)
  for (d in listFiles){
    
    file_<-paste(Current_folder,d[2],sep="")
    
    print(file_)
    if(exists("AFSummary"))  AFSummary<-rbind(AFSummary,MMAFDeleted_cond(day=d[1],file=file_))
       else AFSummary<-MMAFDeleted_cond(day=d[1],file=file_)
    
  }
  View(AFSummary) 
  write.csv(AFSummary, file = "AFIDSummary.csv")
}

MMAFDeleted_cond<-function(day=0,file='C:/Users/enzo7311/Desktop/cs406DAIssue/afdelete2_02.csv'){
  library(doBy)  
  library(lubridate)
  print(paste("day ", day,sep="->"))
  AFDEL <- read.csv(file)
 nome<-c("archFileId","VolumeId","Status","Retry","copyId","cclip")
 nome<-c(nome,"CapacityFreedBytes","ArchChunkId","MountPathId","SIDBStoreId")
 nome<-c(nome,"CommCellId","DeletedTime","FailureErrorCode","subStoreBitField")
 nome<-c(nome,"sidbPruningFlag","appSizeFreedBytes","reserveInt")
 names(AFDEL)<-nome
 
  AFDEL$CapacityFreedBytes<-(AFDEL$CapacityFreedBytes)/(1024^4)
  AFDEL$appSizeFreedBytes<-(AFDEL$appSizeFreedBytes)/(1024^4)
 
  AFDEL$DeletedTime<-as.POSIXct(AFDEL$DeletedTime,origin="1970-01-01")
  AFDEL$DeletedTime<-floor_date(AFDEL$DeletedTime, "day")
  
  
  
  
  AFDEL1<-aggregate(cbind(appSizeFreedBytes,CapacityFreedBytes)~SIDBStoreId+DeletedTime,sum,data=AFDEL)
  
 # View(AFDEL1)
  AFDEL2<-aggregate(cbind(appSizeFreedBytes)~SIDBStoreId+DeletedTime,length,data=AFDEL)
  names(AFDEL2)<-c("SIDBStoreId","DeletedTime","NumAFids")

 
  affinal<-merge(AFDEL1,AFDEL2,by=c("SIDBStoreId","DeletedTime"))
affinal$Day<-day
#View(affinal)
  return(affinal)
}