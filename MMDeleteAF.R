##afdelete1_02.csv
MMAFDeleted_Analysis<-function(sidb=0,Mo=11,file='C:/Users/enzo7311/Desktop/cs406DAIssue/afdelete2_02.csv',hour=0){
  library(ggplot2)
  library(doBy)  
  library(lubridate)
  #DDB<-DedupRead(file,sidb,Mo)
  AFDEL <- read.csv(file)
  AFDEL$CapacityFreedBytes<-(AFDEL$CapacityFreedBytes)/(1024^4)
  AFDEL$appSizeFreedBytes<-(AFDEL$appSizeFreedBytes)/(1024^4)
  #print(file)
  print(sidb)
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