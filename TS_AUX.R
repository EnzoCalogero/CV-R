TS_AUX<-function(file='C:/Users/enzo7311/Desktop/timeseries/TSCS404Test.csv', SP="all"){   #file='C:/Users/enzo7311/Desktop/AUXA/jobs/cs404_Jobs_20_7.csv', SP="all"){
  #  library(xts)
  library(dplyr)
  library(lubridate) #Date management
  library(ggplot2)
  
  Local_tz<-"Europe/London"
  #  Local_tz<-"America/Chicago"
  
  ##import the file
  AUX_RAW <- read.csv(file,sep=";")
  AUX_RAW$Date.and.Time<-mdy_hm(AUX_RAW$Date.and.Time)
  View(AUX_RAW)
  AUX_Aggregate<-AUX_RAW%>%group_by(Date.and.Time)%>%summarise(Residual.Size=sum(Residual.Size))
  View(AUX_Aggregate)
  ts_AUX_AGG<-ts(AUX_Aggregate$Residual.Size, frequency=30,start = c(3, 17))
   fit<-stl(ts_AUX_AGG,s.window="periodic")
   plot(fit)
  
}