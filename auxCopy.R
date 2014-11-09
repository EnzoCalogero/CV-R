
AUXDataAnalysis<-function(Mo=10,file='C:/Users/enzo7311/Desktop/dati/AUXCS499_11_04.csv',hour=0,Day=0,SP='all'){
  #                        c(18,19,20,12,21,23)){
  #  1,2,3,4,5,6,7,8,9,
  #Read the big File
  
  #Type of query
  library(ggplot2)
  library(gcookbook)
  library(lubridate)
  #### FROM [commserv].[dbo].[CommCellBackupInfo] 
  AUX<-CleanAUXData(Mo=10,file,hour,Day)
    
  
  
  print ("here")
  View(AUX)
  AUXDay<-aggregate(DataWritten~day, sum,data=AUX)
  AUXDay$DataWritten<-(AUXDay$DataWritten/(1024))
  View(AUXDay)
  p1<-ggplot(AUXDay, aes(y=DataWritten,x=day)) +  geom_point()  + geom_line() + stat_smooth()
  ### Here for not touch teh global value...#
  if(SP!='all'){
    AUX<-subset(AUX,grepl(SP,AUX$storagepolicy))
  }
  t0<- ggplot(AUX, aes(x=day+(hour/100),y=DataWritten))+ geom_line()+ facet_grid(storagepolicy ~. )  + geom_point()+ stat_smooth()
  
  
  
  AUXDUr<-aggregate(ElapsedTime~day+storagepolicy, sum,data=AUX)
  p2<-ggplot(AUXDUr, aes(y=ElapsedTime,x=day)) +  geom_point()  + geom_line(aes(colour=factor(storagepolicy)))+ stat_smooth()
  
  AUX2<-aggregate(DataWritten~day + storagepolicy, sum,data=AUX)
  AUX2$DataWritten<-(AUX2$DataWritten/(1024))
  
  p3<-ggplot(AUX2, aes(y=DataWritten,x=day)) +  geom_point()  + geom_line(aes(colour=factor(storagepolicy)))+ stat_smooth()
  
  AUX_h<-aggregate(DataWritten~hour + storagepolicy, sum,data=AUX)
  p4<-ggplot(AUX_h, aes(y=DataWritten,x=hour)) +  geom_point()  + geom_line(aes(colour=factor(storagepolicy)))+ stat_smooth()
  
  #abline(coef(lm(mio$durationunixhours~mio$numbytescomp+mio$numobjects)))
   
  complessive<-aggregate(DataWritten~storagepolicy+day, median,data=AUX)
  finale<-aggregate(DataWritten~storagepolicy, median,data=complessive)
  # abline(h=mean(finale$DataWritten))
  #  print(finale)
  boxplot(complessive$DataWritten~complessive$storagepolicy,las=2,par(mar = c(12, 5, 4, 2)+ 0.3))
  multiplot(p1,t0,p3,p2, cols=2)
}
AUXJOBsDataAnalysis<-function(Mo=c(10),fileJOB='C:/Users/enzo7311/Desktop/dati/cs499jobs0411.csv',fileAUX='C:/Users/enzo7311/Desktop/dati/AUXCS499_11_04.csv',hour=0,Day=0,SP='52WeekOffsite_MA02_A'){
  #                        c(18,19,20,12,21,23)){
  #  1,2,3,4,5,6,7,8,9,
  #Read the big File
  
  #Type of query
  library(ggplot2)
  library(gcookbook)
  library(lubridate)
  ############################
  # JOBAnalysis<-function(Mo=0,fileJOB='C:/Users/enzo7311/Desktop/dati/cs499jobs2610.csv',MAgent='all',SP='all'){
  
  jobs <- CleanDBData(Mo,fileJOB)
  
  ############################   Analysis  ###################
  
  if(SP!='all'){
    jobs<-subset(jobs,grepl(SP,jobs$data_sp ))
  }
  ####################################################################
  ##On the AUX copy we have to consider the end time of the backups...
  ###################################################################
  
  jobs$day<-substr(jobs$enddate,1,2)
  jobs$day<-as.numeric(jobs$day)
  
  
  alpha<-aggregate(numbytescomp~enddate+data_sp,sum,data=jobs) 
  alpha$enddate<-dmy_hm(alpha$enddate)
  
  View(alpha)
  alphaDay<-aggregate(numbytescomp~day+data_sp,sum,data=jobs) 
  
  j0<-ggplot(alpha, aes(x=enddate,y=numbytescomp)) + ggtitle("Backup Size over Time ") + geom_point(aes(colour=factor(data_sp))) +geom_line(aes(colour=factor(data_sp)))+ stat_smooth()
  j1<-ggplot(alphaDay, aes(x=day,y=numbytescomp)) + ggtitle("Backup Size over Time Aggregate per Days")+ geom_line(aes(colour=factor(data_sp))) + geom_point(aes(colour=factor(data_sp))) + stat_smooth()
  View(alphaDay)
  AUX<-CleanAUXData(Mo,fileAUX,hour,Day)
  
  ########################################################################### 
  
  print ("here")
  View(AUX)
  AUXDay<-aggregate(DataWritten~day, sum,data=AUX)
  AUXDay$DataWritten<-(AUXDay$DataWritten/(1024))
  View(AUXDay)
  p1<-ggplot(AUXDay, aes(y=DataWritten,x=day)) +  geom_point()  + geom_line() + stat_smooth()
  ### Here for not touch teh global value...#
  if(SP!='all'){
    AUX<-subset(AUX,grepl(SP,AUX$storagepolicy))
  }
  t0<- ggplot(AUX, aes(x=day+(hour/100),y=DataWritten))+ geom_line()+ facet_grid(storagepolicy ~. )  + geom_point()+ stat_smooth()
  
  
  
  AUXDUr<-aggregate(ElapsedTime~day+storagepolicy, sum,data=AUX)
  p2<-ggplot(AUXDUr, aes(y=ElapsedTime,x=day)) +  geom_point()  + geom_line(aes(colour=factor(storagepolicy)))+ stat_smooth()
  
  AUX2<-aggregate(DataWritten~day + storagepolicy, sum,data=AUX)
  AUX2$DataWritten<-(AUX2$DataWritten/(1024))
  
  p3<-ggplot(AUX2, aes(y=DataWritten,x=day)) +  geom_point()  + geom_line(aes(colour=factor(storagepolicy)))+ stat_smooth()
  #########Test.....
  AUX$truput<-(AUX$DataWritten*3600/AUX$ElapsedTime)
  AUXTru<-aggregate(truput~day+storagepolicy, mean,data=AUX)
  
  p6<-ggplot(AUXTru, aes(y=truput,x=day)) +  geom_point()  + geom_line(aes(colour=factor(storagepolicy)))+ stat_smooth() 
  View(AUXTru)
  #a<-coef(lm(mio$durationunixhours~mio$numbytescomp+mio$numobjects))
  
  multiplot(j0,j1,p1,t0,p3,p6, cols=2)
}




################################################
#### This clean from the DB JOBS Query##########
#####   Jobs      ##############################
################################################
CleanDBDataFORAUXJOB<-function(Mo=10,file='C:/Users/enzo7311/Desktop/dati/cs404jobs1107.csv',MAgent='all',SP=0){
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
  
  
  jobs$Endsimply<-jobs$eday*100+jobs$ehour  ###Simpolyfide
  
  ##########################################
  ####SchedulerFilter####################
  
  #to be amend
  # jobs<-subset(jobs,jobs$hour >17) 
  #%in% hour)
  View(jobs)
  
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
  
#  job2<-aggregate(numbytescomp~ Endsimply+data_sp, sum,data=jobs)
 # ggplot(job2, aes(y=numbytescomp,x=Endsimply))+  geom_point(aes(colour=data_sp))+geom_line(aes(colour=data_sp))
  
  hour<-aggregate(numbytescomp~ ehour+data_sp, sum,data=jobs)
 View(hour)
p2<-ggplot(hour, aes(x=numbytescomp,y=ehour))+  geom_point(aes(colour=factor(data_sp)))
 
  View(job2)
p1<-ggplot(job2, aes(x=numbytescomp,y=Endsimply))+  geom_point(aes(colour=data_sp))
  #return (job2)
 
h2<-subset(hour,data_sp=='52WeekOffSite (DiskA-MA15)')
p3<-ggplot(h2, aes(y=numbytescomp,x=ehour))+  geom_point()+ geom_line() + geom_hline(yintercept=2500)
print(p3)
p4<-ggplot(hour, aes(x=numbytescomp,y=ehour)) +geom_point()+  facet_grid(data_sp~. )
print(p4)

 multiplot(p1, p2,p3,p4, cols=2) 
 
 
}




################################################
#### This clean from the AUX Query##############

#### USE this               ####################
################################################


CleanAUXData<-function(Mo=7,file='C:/Users/enzo7311/Desktop/dati/AUXCS404_11_07.csv',hour=0,Day=0){
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
  AUX<-subset(AUX,AUX$sourcecopyid != 'NULL')
  
  AUX$day<-substr(AUX$enddate,1,2)
  AUX$Month<-substr(AUX$enddate,4,5)
  AUX$year<-substr(AUX$enddate,7,10)
  AUX$hour<-substr(AUX$enddate,12,13)
  
  AUX$year<-as.numeric(AUX$year)
  AUX$Month<-as.numeric(AUX$Month)
  AUX$day<-as.numeric(AUX$day)
  AUX$hour<-as.numeric(AUX$hour)
  #View(AUX)
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
  
  #AUX2<-aggregate(DataWritten~day + storagepolicy, sum,data=AUX)
  #p1<-ggplot(AUX2, aes(y=DataWritten,x=day)) +  geom_point()  + geom_line(aes(colour=storagepolicy))
 
  #abline(coef(lm(mio$durationunixhours~mio$numbytescomp+mio$numobjects)))
  #multiplot(p1, cols=2) 
#  View(AUX)
 # View(AUX2)
  return (AUX)
}






#############################
##Visualizzation#############
#############################







multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  require(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}