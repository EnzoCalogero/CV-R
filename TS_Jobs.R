TS_JobStatus<-function(file='C:/dati/XTS_81/test.csv'){
  library(dygraphs)
  #  library(xts)
  library(dplyr)
  library(xts)
  library(lubridate) #Date management
  library(ggplot2)
  library(tidyr)
  Local_tz<-"Europe/London"
  #  Local_tz<-"America/Chicago"
  
  ##import the file
  Jobs_RAW <- read.csv(file,sep=",")
  Jobs_RAW$Date.and.Time<-ymd_hms(Jobs_RAW$Date.and.Time)
  Jobs_RAW$Date.and.Time<-floor_date(Jobs_RAW$Date.and.Time, "hour")
  #View(Jobs_RAW)
  AUX_Aggregate<-Jobs_RAW%>%group_by(Date.and.Time,Status)%>%summarise(Number=sum(Number))
  View(AUX_Aggregate)
  
  Pending<-subset(AUX_Aggregate,AUX_Aggregate$Status=="Pending")
  Pending$Status<-NULL
  names(Pending)[2]<-"Pending"
  View(Pending)

  Running<-subset(AUX_Aggregate,AUX_Aggregate$Status=="Running")
  Running$Status<-NULL
  names(Running)[2]<-"Running"
  View(Running)
  Waiting<-subset(AUX_Aggregate,AUX_Aggregate$Status=="Waiting")
  Waiting$Status<-NULL
  names(Waiting)[2]<-"Waiting"
  View(Waiting)
  
  Queued<-subset(AUX_Aggregate,AUX_Aggregate$Status=="Queued")
  Queued$Status<-NULL
  names( Queued)[2]<-"Queued"
 
  
 
  View(Queued)
  Jobs<-full_join(Pending, Running, by = "Date.and.Time")
  
  Jobs<-full_join(Jobs, Waiting, by = "Date.and.Time")
  Jobs<-full_join(Jobs, Queued, by = "Date.and.Time")
  View(Jobs)
  summary(Jobs)
  
  xts_Jobs<-xts(Jobs[,-1],order.by=Jobs$Date.and.Time)
 
#   xts_Pending<-xts(Pending$Number,order.by=Pending$Date.and.Time)
  #xts_Pending<-names("Pending")

    View(xts_Jobs)
 # plot(xts_Jobs)
  dygraph(xts_Jobs)%>% dyRangeSelector()#%>%
    #dySeries("Number.x", label = "LON404-Pending Jobs")%>%
    #dySeries("Number.y", label = "LON404-Running Jobs")
}
