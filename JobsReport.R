

jobsRead_Report<-function(file='C:/Users/enzo7311/Desktop/ipotesi/beta.csv', SP="all",Mo=3){
  #  library(ggplot2)
#  library(xts)
  library(dplyr)
  library(lubridate) #Date management
  library(ggplot2)
  
  InitialDAY=13
  numberdays=14
  #names(jobs)<-c("jobinitfrom","clientname","idataagent","data_sp","jobstatus","backuplevel","startdate","enddate","durationunixsec","numstreams","numbytesuncomp","numbytescomp","numobjects")
  
  Local_tz<-"Europe/London"
  #  Local_tz<-"America/Chicago"
  
  ##import the file
  jobs <- read.csv(file)
  #View(jobs)
  
  jobs$Start.Time<-mdy_hm(jobs$Start.Time)
  jobs$End.Time<-mdy_hm(jobs$End.Time)
  jobs$Duration<-jobs$End.Time - jobs$Start.Time
  jobs$Duration<as.numeric(jobs$Duration)
  
  jobs$DurationOver<-(jobs$Duration  -3600)
  jobs$DurationOver[jobs$DurationOver<0]<-0
  
  ##filter for the storag epolicy
  if(SP!='all'){
    jobs<-subset(jobs,grepl(SP,jobs$data_sp))
  }
  
  ######################################################
  ####  Filter for the month of interest ###############
  ######################################################
  
  jobs<-subset(jobs,year(jobs$Start.Time) == 2015)
  
  jobs<-subset(jobs,month(jobs$Start.Time) == 4)
  jobs<-subset(jobs,(day(jobs$Start.Time)  >= InitialDAY) & day(jobs$Start.Time) <=(InitialDAY +7))
 #View(jobs)

  #start to work on the date set 
  
 
  jobs$ScheduleTime<-floor_date(jobs$Start.Time, "hour")
  jobs$day<-floor_date(jobs$Start.Time, "day")
  
  
  
  View(jobs)
  jobs_<-jobs%>%group_by(ScheduleTime,Policy.Name)%>%summarise(DurationOver=sum(DurationOver),Duration=sum(Duration),Data.Written=sum(Data.Written),application_Size=sum(Size.of.Application),Data.Transferred=sum(Data.Transferred))
  
#  View(jobs_)
jobs_$Day<-wday(jobs_$ScheduleTime,label=TRUE)
jobs_$Duration<-as.numeric(jobs_$Duration)
jobs_$DurationOver<-as.numeric(jobs_$DurationOver)
jobs_$ratioDedup<-jobs_$application_Size/jobs_$Data.Written
jobs_$GlobalTroughput<-jobs_$Data.Written/jobs_$Duration

View(jobs_)
write.csv(jobs_, file = "C:/Users/enzo7311/Desktop/ipotesi/Output.csv")

#ggplot(jobs_, aes(x = ScheduleTime,y=Data.Written))+ geom_point()+ facet_grid(Policy.Name ~.) +ggtitle("Data written per Schedule")
ggplot(jobs_, aes(x = ScheduleTime,y=Data.Written))+ geom_point(aes(colour=factor(Policy.Name))) +ggtitle("Data written per Schedule")+ geom_line(aes(colour=factor(Policy.Name)))
#ggplot(jobs_, aes(x = ScheduleTime,y=Duration))+ geom_point(aes(colour=factor(Policy.Name))) +ggtitle("Duration Over per Schedule")+ geom_line(aes(colour=factor(Policy.Name)))
ggplot(jobs_, aes(x = GlobalTroughput))+ geom_density()+ facet_grid(Policy.Name ~.)
#ggplot(jobs_, aes(x = GlobalTroughput))+ geom_density()
}

