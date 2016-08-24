jobsRead_ReportAUX<-function(file='C:/Users/enzo7311/Desktop/AUXA/jobs/cs404_jobs_06_08.csv', SP="all"){   #file='C:/Users/enzo7311/Desktop/AUXA/jobs/cs404_Jobs_20_7.csv', SP="all"){
  #  library(xts)
  library(dplyr)
  library(lubridate) #Date management
  library(ggplot2)
  #########################################################
  ####  temporal limits  ##################################
  #########################################################
  
  InitialDAY=0
  numberdays=99999
  
  #########################################################
  ####  temporal limits  ##################################
  #########################################################
  
  
  #names(jobs)<-c("jobinitfrom","clientname","idataagent","data_sp","jobstatus","backuplevel","startdate","enddate","durationunixsec","numstreams","numbytesuncomp","numbytescomp","numobjects")
  
  Local_tz<-"Europe/London"
  #  Local_tz<-"America/Chicago"
  
  ##import the file
  jobs <- read.csv(file,sep=";")
    View(jobs)
  
  
  
  
  jobs$Start.Time<-mdy_hm(jobs$Start.Time)
  jobs$End.Time<-mdy_hm(jobs$End.Time)
  jobs$Duration<-jobs$End.Time - jobs$Start.Time
  jobs$Duration<as.numeric(jobs$Duration)
  
  jobs$DurationOver<-((jobs$Duration/3600)-3)
  jobs$DurationOver[jobs$DurationOver<0]<-0
  
  jobs$DurationOverCount<-0
  jobs$DurationOverCount[jobs$DurationOver >0]<-1  
  
  ##filter for the storag epolicy
  if(SP!='all'){
    jobs<-subset(jobs,grepl(SP,jobs$data_sp))
  }
  
  ######################################################
  ####  Filter for the month of interest ###############
  ######################################################
  
  jobs<-subset(jobs,year(jobs$Start.Time) == 2015)
  
  #jobs<-subset(jobs,month(jobs$Start.Time) == 7)
  #jobs<-subset(jobs,(day(jobs$Start.Time)  >= InitialDAY) & day(jobs$Start.Time) <=(InitialDAY +numberdays))
  
  # View(jobs)
  #stop()
  #start to work on the date set 
  
  
  jobs$ScheduleTime<-floor_date(jobs$Start.Time, "hour")
  jobs$day<-floor_date(jobs$Start.Time, "day")
  jobs$dayEnd<-floor_date(jobs$End.Time, "day")
  
  
  
  ##### Dedup compression analysis ########################################
  jobs$Size.of.Application<-as.character(jobs$Size.of.Application)
  jobs$Size.of.Application<-as.numeric(jobs$Size.of.Application)
  
  jobs$Compression.Rate<-as.character(jobs$Compression.Rate)
  #jobs$Compression.Rate[jobs$Compression.Rate=="N/A"]<-"0"
  jobs$Compression.Rate<-as.numeric(jobs$Compression.Rate)
  
  
  jobs$Space.Savings<-as.character(jobs$Space.Savings)
  jobs$Space.Savings<-as.numeric(jobs$Space.Savings)
  
  jobs$deltaDedup<-(1-jobs$Space.Savings)*jobs$Size.of.Application
  
  
  
  ##################################
 #jobs$verifica<-FALSE
 
 #jobs$verifica[is.na(jobs$Compression.Rate)]<-TRUE
 #jobs$Compression.Rate2<-44
 #jobs$Compression.Rate2[is.na(jobs$Compression.Rate)]<-2
 
 
  ##################################
  
  jobs$deltacompress<-(1-jobs$Compression.Rate)*jobs$Size.of.Application
  jobs$deltacompressUPLIMIT<-(1-(jobs$Compression.Rate - 0.0001))*jobs$Size.of.Application
  
  
  ########################################################################
  
    
  View(jobs)
 #write.csv(jobs, file = "C:/Users/enzo7311/Desktop/ipotesi/test.csv")
 
  
  #stop()
  jobs_<-jobs%>%group_by(dayEnd,  Policy.Name)%>%summarise(compressData=sum(deltacompress),deltacompressUPLIMIT=sum(deltacompressUPLIMIT),Data.Written=sum(Data.Written),Size.of.Application=sum(Size.of.Application),Data.Transferred=sum(Data.Transferred))
  
  
  jobs_$Size.of.Application<-(jobs_$Size.of.Application/1024^3)
  jobs_$Data.Transferred<-(jobs_$Data.Transferred/1024^3)
  
  jobs_$compressData<-(jobs_$compressData/1024^3)
  jobs_$deltacompressUPLIMIT<-(jobs_$deltacompressUPLIMIT/1024^3)
  jobs_$Data.Written<-(jobs_$Data.Written/1024^3)
  
  
  #View(jobs_)
  
  
  View(jobs_)
  
  write.csv(jobs_, file = "C:/Users/enzo7311/Desktop/ipotesi/Output.csv")
  
  jobs_1<-jobs_%>%group_by(dayEnd)%>%summarise(compressData=sum(compressData),deltacompressUPLIMIT=sum(deltacompressUPLIMIT),Data.Written=sum(Data.Written),Size.of.Application=sum(Size.of.Application),Data.Transferred=sum(Data.Transferred))
  
  write.csv(jobs_1, file = "C:/Users/enzo7311/Desktop/ipotesi/OutputDay.csv")
  
  
  
  #ggplot(jobs_, aes(x = ScheduleTime,y=Data.Written))+ geom_point()+ facet_grid(Policy.Name ~.) +ggtitle("Data written per Schedule")
  #ggplot(jobs_, aes(x = ScheduleTime,y=Data.Written))+ geom_point(aes(colour=factor(Policy.Name))) +ggtitle("Data written per Schedule")+ geom_line(aes(colour=factor(Policy.Name)))
  #ggplot(jobs_, aes(x = ScheduleTime,y=Duration))+ geom_point(aes(colour=factor(Policy.Name))) +ggtitle("Duration Over per Schedule")+ geom_line(aes(colour=factor(Policy.Name)))
#  ggplot(jobs_, aes(x = GlobalTroughput_DW))+ geom_density()+ facet_grid(Policy.Name ~.)
  #ggplot(jobs_, aes(x = GlobalTroughput))+ geom_density()
}
