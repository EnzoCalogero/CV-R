################################################
#### This clean from the DB JOBS Query##########
################################################
CleanDBDataFORAUXJOB<-function(Mo=6,file='C:/Users/enzo7311/Desktop/test_/backupinfo.csv',MAgent='MA13',SP=0){
  #                        
  #Read the big File
  
  #Type of query
  library(ggplot2)
  library(gcookbook)
  
  #### FROM [commserv].[dbo].[CommCellBackupInfo] 
  
  jobs <- read.csv(file)
  ############## Time transformation##############
  jobs<-subset(jobs,jobs$jobstatus == 'Success')
  jobs<-subset(jobs,jobs$data_sp != 'NULL')
  
  ###          FOR IMPUT TROUBLSHOOTING                  #############
  #View(jobs)
  print("MA")
  print(MAgent)
  if(MAgent!='all'){
    jobs<-subset(jobs,grepl(MAgent,jobs$data_sp))
  }
  
  jobs$eday<-substr(jobs$enddate,1,2)
  jobs$eMonth<-substr(jobs$enddate,4,5)
  jobs$eyear<-substr(jobs$enddate,7,10)
  jobs$ehour<-substr(jobs$enddate,12,13)
  
  jobs$eyear<-as.numeric(jobs$eyear)
  jobs$eMonth<-as.numeric(jobs$eMonth)
  jobs$eday<-as.numeric(jobs$eday)
  jobs$ehour<-as.numeric(jobs$ehour)
  
  
  jobs$Endsimply<-jobs$eday*24+jobs$ehour  ###Simpolyfide
  
  ##########################################
  ####SchedulerFilter####################
  
  #to be amend
  # jobs<-subset(jobs,jobs$hour >17) 
  #%in% hour)
  
  
  ###########################################################
  jobs$numbytescomp<-jobs$numbytescomp/(1024^3) ###transform in Gb
  jobs$numbytesuncomp<-jobs$numbytesuncomp/(1024^3)
  
  ###############################################
  #                Time filtering
  ########################################
  if(Mo!=0){
    jobs<-subset(jobs,jobs$eMonth == Mo)
  }
  # jobs<-subset(jobs,jobs$day<25)
  
  ######################################
  ######################################
  
  job2<-aggregate(numbytescomp~ Endsimply+data_sp, sum,data=jobs)
  ggplot(job2, aes(y=numbytescomp,x=Endsimply))+  geom_point(aes(colour=data_sp))+geom_line(aes(colour=data_sp))
  
  
  View(job2)
  ggplot(job2, aes(x=numbytescomp,y=Endsimply))+  geom_point(aes(colour=data_sp))
  #return (job2)
}




################################################
#### This clean from the AUX Query##############
################################################


CleanAUXData<-function(Mo=6,file='C:/Users/enzo7311/Desktop/dati/AUXCS404.csv',hour=0,Day=0){
  #                        c(18,19,20,12,21,23)){
  #  1,2,3,4,5,6,7,8,9,
  #Read the big File
  
  #Type of query
  library(ggplot2)
  #### FROM [commserv].[dbo].[CommCellBackupInfo] 
  
  AUX <- read.csv(file)
  ############## Time transformation##############
  
  ###          FOR IMPUT TROUBLSHOOTING                  #############
  #View(AUX)
  
  AUX$day<-substr(AUX$startdate,1,2)
  AUX$Month<-substr(AUX$startdate,4,5)
  AUX$year<-substr(AUX$startdate,7,10)
  AUX$hour<-substr(AUX$startdate,12,13)
  
  AUX$year<-as.numeric(AUX$year)
  AUX$Month<-as.numeric(AUX$Month)
  AUX$day<-as.numeric(AUX$day)
  AUX$hour<-as.numeric(AUX$hour)
  
  ##########################################
  ####SchedulerFilter####################
  print("Hour")
  print(hour)
  #to be amend
  # AUX<-subset(AUX,AUX$hour >17) 
  #%in% hour)
  
  AUX$DataWritten<-AUX$DataWritten/(1024*1024*1024)
  AUX$nightImp<-AUX$day
  
  AUX$nightImp<-AUX$nightImp +  floor(AUX$hour/12)
  #ifelse(AUX$hour>12, AUX$nightImp<-120,AUX$nightImp<-240)
  # ifelse(AUX$hour>12, AUX$nightImp<-(1+AUX$day),AUX$nightImp<-AUX$day)
  
  #if(AUX$hour>12) AUX$nightImp<-10
  #,AUX$nightImp<-20)
  
  #View(AUX)
  
  #AUX$startsimply<-AUX$year*1000000+AUX$Month*10000+AUX$day*100+AUX$hour
  AUX$startsimply<-AUX$Month*10000+AUX$day*100+AUX$hour  ###Simpolyfide
  
  ###########################################################
  
  
  ###############################################
  #                Time filtering
  ########################################
  if(Mo!=0){
    AUX<-subset(AUX,AUX$Month == Mo)
  }
  # AUX<-subset(AUX,AUX$day<25)
  
  ######################################
  ######################################
  
  AUX2<-aggregate(DataWritten~day + storagepolicy, sum,data=AUX)
  p1<-ggplot(AUX2, aes(y=DataWritten,x=day)) +  geom_point()  + geom_line(aes(colour=storagepolicy))
 
  #abline(coef(lm(mio$durationunixhours~mio$numbytescomp+mio$numobjects)))
  multiplot(p1, cols=2) 
  View(AUX)
  View(AUX2)
  return (AUX)
}


AUXDataAnalysis<-function(Mo=6,file='C:/Users/enzo7311/Desktop/dati/AUXCS404.csv',hour=0,Day=0){
  #                        c(18,19,20,12,21,23)){
  #  1,2,3,4,5,6,7,8,9,
  #Read the big File
  
  #Type of query
  library(ggplot2)
  #### FROM [commserv].[dbo].[CommCellBackupInfo] 
  AUX<-CleanAUXData(Mo,file,hour,Day)
  
  AUXDay<-aggregate(DataWritten~day, sum,data=AUX)
  AUXDay$DataWritten<-(AUXDay$DataWritten/(1024))
  p1<-ggplot(AUXDay, aes(y=DataWritten,x=day)) +  geom_point()  + geom_line()
  
  
  AUXDUr<-aggregate(ElapsedTime~day+storagepolicy, sum,data=AUX)
  p2<-ggplot(AUXDUr, aes(y=ElapsedTime,x=day)) +  geom_point()  + geom_line(aes(colour=storagepolicy))
  
  AUX2<-aggregate(DataWritten~day + storagepolicy, sum,data=AUX)
  AUX2$DataWritten<-(AUX2$DataWritten/(1024))
  
  p3<-ggplot(AUX2, aes(y=DataWritten,x=day)) +  geom_point()  + geom_line(aes(colour=storagepolicy))
  
  
  
  
  #abline(coef(lm(mio$durationunixhours~mio$numbytescomp+mio$numobjects)))
  multiplot(p1,p2,p3, cols=2) 
  
}