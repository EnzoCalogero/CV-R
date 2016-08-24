TS_JobStatus<-function(file='C:/dati/Jobs_Analisis/globalJobs.csv'){
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
  View(Jobs_RAW)
  Jobs_RAW$Date.and.Time<-ymd_hms(Jobs_RAW$Date)
  Jobs_RAW$Date.and.Time<-floor_date(Jobs_RAW$Date.and.Time, "hour")
  View(Jobs_RAW)
  
  AUX_Aggregate<-Jobs_RAW%>%group_by(Date.and.Time,Status)%>%summarise(Number=sum(Number))
  AUX_Aggregate_CS<-Jobs_RAW%>%group_by(Date.and.Time,Status,CS)%>%summarise(Number=sum(Number))
  
  View(AUX_Aggregate)
  View(AUX_Aggregate_CS)
  rm(Jobs_RAW)
  Pending<-subset(AUX_Aggregate,AUX_Aggregate$Status=="Pending")
  Pending$Status<-NULL
  names(Pending)[2]<-"Pending"
  #View(Pending)

  Running<-subset(AUX_Aggregate,AUX_Aggregate$Status=="Running")
  Running$Status<-NULL
  names(Running)[2]<-"Running"
  #View(Running)
  Jobs<-full_join(Pending, Running, by = "Date.and.Time")
  rm(Pending)
  rm(Running)
  
  Waiting<-subset(AUX_Aggregate,AUX_Aggregate$Status=="Waiting")
  Waiting$Status<-NULL
  names(Waiting)[2]<-"Waiting"
  #View(Waiting)
  
  Jobs<-full_join(Jobs, Waiting, by = "Date.and.Time")
  rm(Waiting)
  Queued<-subset(AUX_Aggregate,AUX_Aggregate$Status=="Queued")
  Queued$Status<-NULL
  names( Queued)[2]<-"Queued"
 
  #View(Queued)

  
  
  Jobs<-full_join(Jobs, Queued, by = "Date.and.Time")
  #View(Jobs)
  #summary(Jobs)
  rm(Queued)
  #Jobs<-Jobs%>%group_by(Date.and.Time,Status)%>%summarise(Number=sum(Number))
  xts_Jobs<-xts(Jobs[,-1],order.by=Jobs$Date.and.Time)
  rm(Jobs)
#   xts_Pending<-xts(Pending$Number,order.by=Pending$Date.and.Time)
  #xts_Pending<-names("Pending")

   # View(xts_Jobs)
 # plot(xts_Jobs)
  dygraph(xts_Jobs)%>% dyRangeSelector()#%>%
    #dySeries("Number.x", label = "LON404-Pending Jobs")%>%
    #dySeries("Number.y", label = "LON404-Running Jobs")
  
#########################################################################
#                                                                       #
#    for single CS                                                      #
#########################################################################
  #CS410
  AUX_Aggregate<-subset(AUX_Aggregate_CS,AUX_Aggregate_CS$CS=="CS401")
  AUX_Aggregate$CS<-NULL
  View(AUX_Aggregate)
  Pending<-subset(AUX_Aggregate,AUX_Aggregate$Status=="Pending")
  Pending$Status<-NULL
  names(Pending)[2]<-"Pending"
  #View(Pending)
  
  Running<-subset(AUX_Aggregate,AUX_Aggregate$Status=="Running")
  Running$Status<-NULL
  names(Running)[2]<-"Running"
  #View(Running)
  Jobs<-full_join(Pending, Running, by = "Date.and.Time")
  rm(Pending)
  rm(Running)
  
  Waiting<-subset(AUX_Aggregate,AUX_Aggregate$Status=="Waiting")
  Waiting$Status<-NULL
  names(Waiting)[2]<-"Waiting"
  #View(Waiting)
  
  Jobs<-full_join(Jobs, Waiting, by = "Date.and.Time")
  rm(Waiting)
  Queued<-subset(AUX_Aggregate,AUX_Aggregate$Status=="Queued")
  Queued$Status<-NULL
  names( Queued)[2]<-"Queued"
  
  #View(Queued)
  
  
  
  Jobs<-full_join(Jobs, Queued, by = "Date.and.Time")
  View(Jobs)
  #summary(Jobs)
  rm(Queued)
  #Jobs<-Jobs%>%group_by(Date.and.Time,Status)%>%summarise(Number=sum(Number))
  xts_Jobs_410<-xts(Jobs[,-1],order.by=Jobs$Date.and.Time)
  rm(Jobs)
  dygraph(xts_Jobs_410,main="401")%>% dyRangeSelector()#%>%
  
}
