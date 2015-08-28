
jobsRead_Report<-function(file='C:/Users/enzo7311/Desktop/ipotesi/cs901_08_05_temp.csv', SP="all"){
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
  jobs <- read.csv(file)
#  View(jobs)
  
  jobs$Start.Time<-dmy_hm(jobs$Start.Time)
  jobs$End.Time<-dmy_hm(jobs$End.Time)
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
  
  jobs<-subset(jobs,month(jobs$Start.Time) == 4)
  jobs<-subset(jobs,(day(jobs$Start.Time)  >= InitialDAY) & day(jobs$Start.Time) <=(InitialDAY +numberdays))
  
 # View(jobs)
 #stop()
  #start to work on the date set 
  
 
  jobs$ScheduleTime<-floor_date(jobs$Start.Time, "hour")
  jobs$day<-floor_date(jobs$Start.Time, "day")





##### Dedup compression analysis ########################################
jobs$Size.of.Application<-as.character(jobs$Size.of.Application)
jobs$Size.of.Application<-as.numeric(jobs$Size.of.Application)

jobs$Compression.Rate<-as.character(jobs$Compression.Rate)
jobs$Compression.Rate<-as.numeric(jobs$Compression.Rate)


jobs$Space.Savings<-as.character(jobs$Space.Savings)
jobs$Space.Savings<-as.numeric(jobs$Space.Savings)

jobs$deltaDedup<-(1-jobs$Space.Savings)*jobs$Size.of.Application
jobs$deltacompress<-(1-jobs$Compression.Rate)*jobs$Size.of.Application
jobs$deltacompressUPLIMIT<-(1-(jobs$Compression.Rate - 0.0001))*jobs$Size.of.Application

  
 
 
 
########################################################################
 
  
  
  View(jobs)
 
 
 
 
 #stop()
  jobs_<-jobs%>%group_by(ScheduleTime,Policy.Name)%>%summarise(clientOver3H=sum(DurationOverCount),compressData=sum(deltacompress),deltacompressUPLIMIT=sum(deltacompressUPLIMIT),DurationOver=sum(DurationOver),Duration=sum(Duration),Data.Written=sum(Data.Written),Size.of.Application=sum(Size.of.Application),Data.Transferred=sum(Data.Transferred))
  
 # View(jobs_)

jobs_$Day<-wday(jobs_$ScheduleTime,label=TRUE)
jobs_$Duration<-as.numeric(jobs_$Duration)
jobs_$DurationOver<-as.numeric(jobs_$DurationOver)

jobs_$ratioDedup<-jobs_$Size.of.Application/jobs_$Data.Written
jobs_$Data.Written<-(jobs_$Data.Written/1024^3)

jobs_$Size.of.Application<-(jobs_$Size.of.Application/1024^3)
jobs_$Data.Transferred<-(jobs_$Data.Transferred/1024^3)
#View(jobs_)





jobs_$dedup<-100*(1-1/jobs_$ratioDedup)

jobs_$GlobalTroughput_DW<-3600*jobs_$Data.Written/jobs_$Duration
jobs_$GlobalTroughput_AS<-3600*jobs_$Size.of.Application/jobs_$Duration
#jobs_$MA<-"None"
jobs_$MA<-regexpr("M",jobs_$Policy.Name)

jobs_$MA<-substr(jobs_$Policy.Name,jobs_$MA,jobs_$MA+3)
jobs_$scheduleTIME<-hour(jobs_$ScheduleTime)


View(jobs_)

write.csv(jobs_, file = "C:/Users/enzo7311/Desktop/ipotesi/Output.csv")
stop()
jobs_MA<-jobs_%>%group_by(ScheduleTime,MA)%>%summarise(clientOver3H=sum(clientOver3H),DurationOver=sum(DurationOver),Duration=sum(Duration),Data.Written=sum(Data.Written),Size.of.Application=sum(Size.of.Application),Data.Transferred=sum(Data.Transferred))
jobs_MA$Day<-wday(jobs_MA$ScheduleTime,label=TRUE)
jobs_MA$Duration<-as.numeric(jobs_MA$Duration)
jobs_MA$DurationOver<-as.numeric(jobs_MA$DurationOver)

jobs_MA$ratioDedup<-jobs_MA$Size.of.Application/jobs_MA$Data.Written
jobs_MA$Data.Written<-(jobs_MA$Data.Written/1024^3)

jobs_MA$Size.of.Application<-(jobs_MA$Size.of.Application/1024^3)
jobs_MA$Data.Transferred<-(jobs_MA$Data.Transferred/1024^3)
jobs_MA$scheduleTIME<-hour(jobs_MA$ScheduleTime)

jobs_MA$dedup<-100*(1-1/jobs_MA$ratioDedup)

jobs_MA$GlobalTroughput_DW<-3600*jobs_MA$Data.Written/jobs_MA$Duration
jobs_MA$GlobalTroughput_AS<-3600*jobs_MA$Size.of.Application/jobs_MA$Duration

write.csv(jobs_MA, file = "C:/Users/enzo7311/Desktop/ipotesi/OutputMA.csv")






#ggplot(jobs_, aes(x = ScheduleTime,y=Data.Written))+ geom_point()+ facet_grid(Policy.Name ~.) +ggtitle("Data written per Schedule")
ggplot(jobs_, aes(x = ScheduleTime,y=Data.Written))+ geom_point(aes(colour=factor(Policy.Name))) +ggtitle("Data written per Schedule")+ geom_line(aes(colour=factor(Policy.Name)))
#ggplot(jobs_, aes(x = ScheduleTime,y=Duration))+ geom_point(aes(colour=factor(Policy.Name))) +ggtitle("Duration Over per Schedule")+ geom_line(aes(colour=factor(Policy.Name)))
ggplot(jobs_, aes(x = GlobalTroughput_DW))+ geom_density()+ facet_grid(Policy.Name ~.)
#ggplot(jobs_, aes(x = GlobalTroughput))+ geom_density()
}

