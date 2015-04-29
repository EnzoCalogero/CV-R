jobs_workload<-function(file='C:/Users/enzo7311/Desktop/Dati/cs403JOBS15_04_03.csv', SP="2Week",Mo=3){
  library(ggplot2)
  library(lubridate)
  library(gplots)
  library(RColorBrewer)
  library(xts)
  library(dplyr)
  
  jobs<-jobsRead_workload(file,SP,Mo)
  
  dayStart<-15
  # jobs--> original set of jobs
  # jobs1--> set of jobs filterd by time 
  # jobs_schedule --> aggregate jobs per schedule and ST
  # jobs_day --> aggregate jobs per day and ST
  # jobs_dayGlobal--> aggregate jobs only per day
  
  
  
  jobs$startdate<-ymd_hms(jobs$startdate)
  
  jobs1<-subset(jobs,(day(jobs$startdate) > dayStart-1)&((day(jobs$startdate) < dayStart+14)))
  
  jobs1$troughput<-jobs1$numbytescomp/jobs1$durationunixsec
  View(jobs1)
  jobs_schedule<-jobs1%>%filter(hour(startdate) %in% c("0","3","6","9","18","21"))%>%group_by(startdate,data_sp)%>%summarise(durationunixmin=(sum(durationunixsec)/60),averagetroughput=mean(troughput),averagenumbytescomp=mean(numbytescomp),numbytesuncomp=sum(numbytesuncomp),numbytescomp=mean(numbytescomp))
  jobs_day<-jobs1%>%group_by(daystart,data_sp)%>%summarise(durationunixmin=(sum(durationunixsec)/60),averagenumbytescomp=mean(numbytescomp/6),numbytescomp=sum(numbytescomp),averagetroughput=mean(troughput),numbytescomp=mean(numbytescomp))
  
  jobs_dayGlobal<-jobs1%>%group_by(daystart)%>%summarise(durationunixmin=(sum(durationunixsec)/60),numbytesuncomp=sum(numbytesuncomp),averagetroughput=mean(troughput),numbytescomp=mean(numbytescomp))
  View(jobs_schedule)
  
  
  View(jobs1)
  
  print("unique")
  print(unique(jobs1$data_sp))
  p2<-ggplot(jobs_schedule, aes(y=log10(numbytescomp),x=startdate)) +  geom_point()  + geom_line(aes(colour=factor(data_sp)))
  p2b<-ggplot(jobs_schedule, aes(y=durationunixmin,x=startdate)) +  geom_point()  + geom_line(aes(colour=factor(data_sp)))
  p2c<-ggplot(jobs_schedule, aes(y=averagetroughput,x=startdate)) +  geom_point()  + geom_line(aes(colour=factor(data_sp)))
  
  p3<-ggplot(jobs_day, aes(y=(numbytescomp),x=daystart)) +  geom_point()  + geom_line(aes(colour=factor(data_sp))) 
  p3b<-ggplot(jobs_day, aes(y=(numbytescomp),x=daystart)) +  geom_point()  + geom_line(aes(colour=factor(data_sp))) 
  
  p4<-ggplot(jobs_dayGlobal, aes(y=log10(numbytescomp),x=daystart)) +  geom_point()  + geom_line()
  multiplot(p2,p2b, cols=1)
  multiplot(p3, cols=1)
  multiplot(p3b, cols=1)
  multiplot(p4, cols=1)
  multiplot(p2c, cols=1)
}