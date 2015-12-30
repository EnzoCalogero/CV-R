TS_JobStatus_SPs<-function(CS="CS404",Status="Running",filter='z_2Week_MA'){
  library(dygraphs)
  library(data.table)
  library(dplyr)
  library(xts)
  library(reshape2)
  library(lubridate) #Date management
  library(ggplot2)
  library(tidyr)
  Local_tz<-"Europe/London"
  #  Local_tz<-"America/Chicago"
  file='C:/dati/Jobs_Analisis/globalJobs.csv'
  ##import the file
  #Jobs_RAW <- read.csv(file,sep=",")
  Jobs_RAW <- fread(file, header = T, sep = ',')
  #View(Jobs_RAW)
  #print(summary( Jobs_RAW))
  Jobs_RAW$Date.and.Time<-ymd_hms(Jobs_RAW$Date)
  Jobs_RAW$Storage.Policy<-Jobs_RAW$Storage
  Jobs_RAW[,1:2]<-NULL
  Jobs_RAW$Date.and.Time<-floor_date(Jobs_RAW$Date.and.Time, "hour")
  #View(Jobs_RAW)
  
  Jobs_RAW<-subset(Jobs_RAW,Jobs_RAW$CS==CS)
  Jobs_RAW$CS<-NULL
  Jobs_RAW<-subset(Jobs_RAW,Jobs_RAW$Status==Status)
  Jobs_RAW<-subset(Jobs_RAW,Jobs_RAW$Status==Status)
  Jobs_RAW<-subset(Jobs_RAW,grepl(filter,Jobs_RAW$Storage.Policy))
  
  data_wide <- dcast(Jobs_RAW, Date.and.Time  ~ Storage.Policy, value.var="Number")
  
  View(Jobs_RAW)
  View(data_wide)
  xts_Jobs_CS<-xts(data_wide[,-1],order.by=data_wide$Date.and.Time)

  #View(xts__410)
  
  
    dygraph(xts_Jobs_CS,main=paste(CS,' - ',Status))%>% dyRangeSelector()
  
  

  }

