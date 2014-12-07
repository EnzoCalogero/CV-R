PrunMerger<-function(sidb=62,Mo=c(11,10),fileDDB='C:/Users/enzo7311/Desktop/Dati/cs903ddb11_28.csv',fileAF='C:/Users/enzo7311/Desktop/sealing/sidengine/CS903_28_11.csv',hour=0){
  library(ggplot2)
  library(doBy)
  library(lubridate)
  border=1000000
  DDB1<-DedupRead(file<-fileDDB,sidb,Mo=11)
  DDB1$Date2<-as.POSIXct(DDB1$ModifiedTime, origin="1970-01-01",tz ="America/Chicago")
  AFID1<-prune_Analysis(sidb,Mo=c(11),file<-fileAF)
  
  AFID1<-subset(AFID1,DDBID==sidb)
 # DDB1<-subset(DDB1,(day>20)&(day<30))
  #DDB1<-subset(DDB1,(hour>17)|(hour<10))
  
  DDB1$Date2<-floor_date(DDB1$Date, "hour")
  #print(file)
 # DDB1$Date2<-DDB1$Date2-hour(1)
  
 
 
 
  AFIDAggr<-aggregate(AFID~Date2, max,data=AFID1)
  DDBAggr<-aggregate(AvgQITime~Date2, max,data=DDB1)
  DDBAggr1<-aggregate(ZeroRefCount~Date2, max,data=DDB1)
  
 print ("go")
 af<-ts((AFIDAggr$AFID+1))
 av<-ts(log10(DDBAggr$AvgQITime+1))
 zrc<-ts(log10(DDBAggr1$ZeroRefCount+1))
 ccf(av,zrc)
 ccf(zrc,af)
 
 print("stop")
 
 
 
 Aggr <- merge(AFIDAggr,DDBAggr, by.x ="Date2", by.y = "Date2",all = TRUE)
  Aggr$AFID[is.na(Aggr$AFID)] <- 0
 Aggr$AvgQITime[is.na(Aggr$AvgQITime)] <- 0
 
  print(sidb)
  View(DDB1)
#  View(AFID1)
#  View(AFIDAggr)
#  View(DDBAggr)
  View(Aggr)
print ("Corr")
  print(cor(log(Aggr$AvgQITime+1),(Aggr$AFID/100),use="pairwise.complete.obs"))
 # t<-ggplot(Aggr, aes(x=AFID,y=log10(AvgQITime)))+ geom_point() 
 t1<-ggplot(Aggr,)+ geom_point(aes(x=Date2,y=(AFID/100)),colour="red") + geom_point(aes(x=Date2,y=log(AvgQITime))) 
  multiplot(t1, cols=1)
return (Aggr)
}