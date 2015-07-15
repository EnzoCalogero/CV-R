NetworkPerf<-function(file='C:/Users/enzo7311/Desktop/logPerfAnalysis/cs404-Ma09/LON301CS0404M09_20150707-000375/logfile.csv'){
  library(ggplot2)
  library(doBy)  
  library(lubridate)
  
  netPerf <- read.csv2(file)
  
  #summary(netPerf)
  #names(netPerf)
  netPerf[,2]<-as.numeric(netPerf[,2])
  netPerf[,3]<-as.numeric(netPerf[,3])
  netPerf[,4]<-as.numeric(netPerf[,4])
  netPerf[,5]<-as.numeric(netPerf[,5])
  netPerf[,6]<-as.numeric(netPerf[,6])
  
  View(netPerf)
  
  netPerf$tot<-netPerf[,2]+netPerf[,3]+netPerf[,4]
  return(netPerf)
}