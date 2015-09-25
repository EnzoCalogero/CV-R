TS_AUX<-function(file='C:/Users/enzo7311/Desktop/timeseries/TSCS404Test.csv', SP="all"){   #file='C:/Users/enzo7311/Desktop/AUXA/jobs/cs404_Jobs_20_7.csv', SP="all"){
  #  library(xts)
  library(dplyr)
  library(xts)
  library(lubridate) #Date management
  library(ggplot2)
  library(tidyr)
  Local_tz<-"Europe/London"
  #  Local_tz<-"America/Chicago"
  
  ##import the file
  AUX_RAW <- read.csv(file,sep=";")
  AUX_RAW$Date.and.Time<-mdy_hm(AUX_RAW$Date.and.Time)
  View(AUX_RAW)
  AUX_Aggregate<-AUX_RAW%>%group_by(Date.and.Time)%>%summarise(Residual.Size=sum(Residual.Size))
  View(AUX_Aggregate)
  xts_AUX_AGG<-xts(AUX_Aggregate$Residual.Size,order.by=AUX_Aggregate$Date.and.Time)#, start = c(3, 17))#frequency=30
  ts_AUX_AGG<-ts(AUX_Aggregate$Residual.Size, start = c(3, 17),frequency=7)
  
  fit<-stl(ts_AUX_AGG,s.window="periodic")
  summary(fit)
  summary(fit$trend)
  plot(fit,main="GLOBAL AUX COPY")
  plot(xts_AUX_AGG,main="GLOBAL AUX COPY non trattato")
 # fit<-stl(ts_AUX_AGG,s.window=7)
#  plot(fit)
#
#
#
#Start to scorporate the TSfor each TS....
#
SPolicy<-distinct(AUX_RAW,Storage.Policy)[,2]
View(SPolicy)
for (i in SPolicy){
  
  AUX_RAW_temp<-subset(AUX_RAW,Storage.Policy== i)
  print(i)
  print(length(AUX_RAW_temp[,1]))
  print(length(AUX_RAW_temp[,1])>20)      
  if(length(AUX_RAW_temp[,1])>20){
   #View(AUX_RAW_temp)
   ts_AUX_AGG<-ts(AUX_RAW_temp$Residual.Size, start = c(3, 17),frequency=7)
   fit<-stl(ts_AUX_AGG,s.window="periodic")
   plot(fit, main=i)
  }
  }




}