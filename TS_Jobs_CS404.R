TS_JobStatus_CS404<-function(file='C:/dati/Jobs_Analisis/globalJobs.csv',SP){#}),SP="z_2Week_MA03-A"){
  library(dygraphs)
  library(data.table)
  library(dplyr)
  library(xts)
  library(lubridate) #Date management
  library(ggplot2)
  library(tidyr)
  Local_tz<-"Europe/London"
  #  Local_tz<-"America/Chicago"
  
  ##import the file
  #Jobs_RAW <- read.csv(file,sep=",")
  Jobs_RAW <- fread(file, header = T, sep = ',')
  #View(Jobs_RAW)
  #print(summary( Jobs_RAW))
  Jobs_RAW$Date.and.Time<-ymd_hms(Jobs_RAW$Date)
  Jobs_RAW$Storage.Policy<-Jobs_RAW$Storage
  Jobs_RAW$Date.and.Time<-floor_date(Jobs_RAW$Date.and.Time, "hour")
  #View(Jobs_RAW)
  
    Jobs_RAW<-subset(Jobs_RAW,Jobs_RAW$CS=="CS401")
  
  
  #for(SP1 in SP_){
  print(SP)
  Jobs_RAW<-subset(Jobs_RAW,Jobs_RAW$Storage.Policy==SP)
  #AUX_Aggregate$CS<-NULL
  #AUX_Aggregate$CS<-NULL
  
  AUX_Aggregate<-Jobs_RAW%>%group_by(Date.and.Time,Status)%>%summarise(Number=sum(Number))
 
  #CS401
 # View(AUX_Aggregate)
  Pending<-subset(AUX_Aggregate,AUX_Aggregate$Status=="Pending")
  Pending$Status<-NULL
  names(Pending)[2]<-"Pending"
#  View(Pending)
  
  Running<-subset(AUX_Aggregate,AUX_Aggregate$Status=="Running")
  Running$Status<-NULL
  names(Running)[2]<-"Running"
  #View(Running)
  Jobs<-full_join(Pending, Running, by = "Date.and.Time")
  rm(Pending)
  rm(Running)
#  View(Jobs)
  Waiting<-subset(AUX_Aggregate,AUX_Aggregate$Status=="Waiting")
  Waiting$Status<-NULL
  names(Waiting)[2]<-"Waiting"
 # View(Waiting)
  
  Jobs<-full_join(Jobs, Waiting, by = "Date.and.Time")
  rm(Waiting)
  Queued<-subset(AUX_Aggregate,AUX_Aggregate$Status=="Queued")
  Queued$Status<-NULL
  names( Queued)[2]<-"Queued"
 # View(Jobs)
  #View(Queued)
  
  
  
  Jobs<-full_join(Jobs, Queued, by = "Date.and.Time")
 # View(Jobs)
  #summary(Jobs)
  rm(Queued)
  #Jobs<-Jobs%>%group_by(Date.and.Time,Status)%>%summarise(Number=sum(Number))
  xts_Jobs_410<-xts(Jobs[,-1],order.by=Jobs$Date.and.Time)
 
  rm(Jobs)
  View(xts_Jobs_410)
 # }
  
#  dygraph(xts_Jobs_410,main=SP)%>% dyRangeSelector()
    
 return(xts_Jobs_410)  
}

TS_JobStatus_Storagepolicy<-function(SP){
library(htmlwidgets)
  
#for(SP in SPLIST){
  print(SP)  

ts_STO<-TS_JobStatus_CS404(SP=SP)
dygraph(ts_STO,main=SP,group = "LON3")%>% dyRangeSelector()
#saveWidget(a,file=paste(SP,".html"),selfcontained = FALSE)


#}
}

ruota<-function(){
  SP='z_2Week_MA03-A'
  TS_JobStatus_Storagepolicy(SP=SP)
  
  SP='z_2Week_MA03-B'
  TS_JobStatus_Storagepolicy(SP=SP)
  
  
}

