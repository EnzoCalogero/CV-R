#########Clean Data####################

CleanDBData_web<-function(Mo=6,file='C:/Users/enzo7311/Desktop/test_/backupinfo.csv',MAgent='all',hour=0){
  #                        c(18,19,20,12,21,23)){
  #  1,2,3,4,5,6,7,8,9,
  #Read the big File
  
  #Type of query
  
  #### FROM [commserv].[dbo].[CommCellBackupInfo] 
  
  jobs <- read.csv(file)
  ############## Time transformation##############
  jobs<-subset(jobs,jobs$jobstatus == 'Success')
  jobs<-subset(jobs,jobs$data_sp != 'NULL')
  
  ###          FOR IMPUT TROUBLSHOOTING                  #############
  
  print("MA")
  print(MAgent)
  if(MAgent!='all'){
    jobs<-subset(jobs,grepl(MAgent,jobs$data_sp))
  }
  
  jobs$day<-substr(jobs$startdate,1,2)
  jobs$Month<-substr(jobs$startdate,4,5)
  jobs$year<-substr(jobs$startdate,7,10)
  jobs$hour<-substr(jobs$startdate,12,13)
  
  jobs$year<-as.numeric(jobs$year)
  jobs$Month<-as.numeric(jobs$Month)
  jobs$day<-as.numeric(jobs$day)
  jobs$hour<-as.numeric(jobs$hour)
  
  ##########################################
  ####SchedulerFilter####################
  print("Hour")
  print(hour)
  #to be amend
  # jobs<-subset(jobs,jobs$hour >17) 
  #%in% hour)
  
  
  jobs$nightImp<-jobs$day
  
  jobs$nightImp<-jobs$nightImp +  floor(jobs$hour/12)
  #ifelse(jobs$hour>12, jobs$nightImp<-120,jobs$nightImp<-240)
  # ifelse(jobs$hour>12, jobs$nightImp<-(1+jobs$day),jobs$nightImp<-jobs$day)
  
  #if(jobs$hour>12) jobs$nightImp<-10
  #,jobs$nightImp<-20)
  
  #View(jobs)
  
  #jobs$startsimply<-jobs$year*1000000+jobs$Month*10000+jobs$day*100+jobs$hour
  jobs$startsimply<-jobs$Month*10000+jobs$day*100+jobs$hour  ###Simpolyfide
  
  ###########################################################
  jobs$numbytescomp<-jobs$numbytescomp/(1024^3) ###transform in Gb
  jobs$numbytesuncomp<-jobs$numbytesuncomp/(1024^3)
  
  ###############################################
  #                Time filtering
  ########################################
  if(Mo!=0){
    jobs<-subset(jobs,jobs$Month == Mo)
  }
  # jobs<-subset(jobs,jobs$day<25)
  
  ######################################
  ######################################
  
#  View(jobs)
  return (jobs)
}
#################################################################
################### Data    #####################################

AnalysDBTroughputSP_web<-function(Mo=6,file='C:/Users/enzo7311/Desktop/dati/cs403jobs1306.csv', SP="all", Magent="all"){
  library(ggplot2)
  library(gcookbook)
  library(plyr)
  #Read the big File######
  
  jobs <- CleanDBData_web(Mo,file,Magent)
  
  ############################   Analysis  ###################
  
  
  if(SP!='all'){
    jobs<-subset(jobs,jobs$data_sp %in%  SP)
  }
  
  
  #### carico a livello di CS
  ### duration
  mio1<-aggregate(durationunixsec~nightImp + data_sp , sum,data=jobs)
  global1<-aggregate(durationunixsec~nightImp, sum,data=jobs)
  mio1$durationunixhours<-(mio1$durationunixsec/3600)
  global1$durationunixhours<-(global1$durationunixsec/3600)
  #### data
  mio2<-aggregate(numbytescomp~nightImp + data_sp, sum,data=jobs)
  global2<-aggregate(numbytescomp~nightImp, sum,data=jobs)
  
  mio <- merge(mio1,mio2, by.x =c( "nightImp","data_sp"), by.y = c("nightImp","data_sp"))
  global<-merge(global1,global2, by.x ="nightImp", by.y = "nightImp")
  mio$trougput<-mio$numbytescomp/mio$durationunixhours
  global$trougput<-global$numbytescomp/global$durationunixhours
  
  ####### numobjects##############
  mio3<-aggregate(numobjects~nightImp + data_sp, sum,data=jobs)
  global3<-aggregate(numobjects~nightImp, sum,data=jobs)
  mio <- merge(mio,mio3, by.x =c( "nightImp","data_sp"), by.y = c("nightImp","data_sp"))
  global<- merge(global,global3, by.x ="nightImp", by.y = "nightImp")
  View(global)
  View(mio)
 # jobs<-subset(mio,jobs$numbytescomp >0)
  
  
  
  
  mio<-arrange(mio,trougput)
  
#  p1<-ggplot(mio, aes(y=numbytescomp,x=nightImp)) +  geom_point()  + geom_line(aes(colour=data_sp))
#  p2<-ggplot(mio, aes(y=durationunixhours,x=nightImp)) +  geom_point()  + geom_line(aes(colour=data_sp))
#  p3<-ggplot(mio, aes(y=trougput,x=nightImp)) +  geom_point()  + geom_line(aes(colour=data_sp))
#  p4<-ggplot(mio, aes(x=numbytescomp,y=durationunixhours))+  geom_point(aes(colour=data_sp))
#  p6<-ggplot(mio, aes(x=numobjects,y=durationunixhours))+  geom_point(aes(colour=data_sp))
#  p5<-ggplot(mio, aes(y=numobjects,x=nightImp)) +  geom_point()  + geom_line(aes(colour=data_sp))
#  multiplot(p1, p2, p3, p4,p5,p6, cols=2) 
  return(mio)
}