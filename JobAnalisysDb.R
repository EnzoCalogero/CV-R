

############  JOB Analysis #########################
JOBAnalysis<-function(Mo=0,file='C:/Users/enzo7311/Desktop/dati/cs499jobs2710.csv',MAgent='all',SP='all'){
  library(ggplot2)
  library(gcookbook)
  library(lubridate)
  #Read the big File######
  
  jobs <- CleanDBData(Mo,file,MAgent)
  
  ############################   Analysis  ###################
  
  if(SP!='all'){
    jobs<-subset(jobs,jobs$data_sp %in%  SP)
  }
  

  ##########
  #Working here###
  ##############
  
  alpha<-aggregate(numbytescomp~Start_Time+data_sp,sum,data=jobs) 
  alpha$Start_Time<-ymd_hms(alpha$Start_Time)
  
  View(alpha)
  alpha1<-aggregate(durationunixsec  ~Start_Time+data_sp,sum,data=jobs) 
  alpha1$Start_Time<-ymd_hms(alpha1$Start_Time)
  
  View(alpha1)
  alpha2<-aggregate(Throughput  ~Start_Time+data_sp,mean,data=jobs) 
  alpha2$Start_Time<-ymd_hms(alpha2$Start_Time)
  
  View(alpha2)
  
  p0<-ggplot(alpha, aes(x=Start_Time,y=numbytescomp)) + ggtitle("Backup Size over Time") + geom_point(aes(colour=factor(data_sp))) +geom_line(aes(colour=factor(data_sp)))+ stat_smooth(aes(colour=factor(data_sp)))
  p1<-ggplot(alpha1, aes(x=Start_Time,y=durationunixsec  )) + ggtitle("Backup Duration over Time")+  geom_point(aes(colour=factor(data_sp))) +geom_line(aes(colour=factor(data_sp)))+ stat_smooth(aes(colour=factor(data_sp)))
  p2<-ggplot(alpha2, aes(x=Start_Time,y=Throughput  ))+ ggtitle("BackupTroughPut over Time") +  geom_point(aes(colour=factor(data_sp))) +geom_line(aes(colour=factor(data_sp)))+ stat_smooth(aes(colour=factor(data_sp)))
   
  t2<- ggplot(jobs, aes(x=WDay,y=Throughput))+ facet_grid(data_sp  ~. )+  geom_boxplot()+ stat_smooth()
  t1<- ggplot(jobs, aes(x=hour,y=Throughput))+ facet_grid(data_sp  ~. )+  geom_boxplot()+ stat_smooth()
  t3<- ggplot(jobs, aes(x=WDay,y=numbytescomp))+ facet_grid(data_sp  ~. )+  geom_boxplot()+ stat_smooth()
  g0<-ggplot(jobs, aes(x=durationunixsec,y=numbytescomp)) +  geom_point(aes(colour=factor(data_sp)))
  m1 <- ggplot(jobs, aes(x = log10(numbytescomp)))+ ggtitle("Backup Size Distribution")+ geom_density(aes(fill=factor(data_sp)))
#multiplot(p0,cols=2)
  multiplot(m1,p0,p1,p2,t1,t2,t3,g0, cols=2)
}

#########################################################################
#############Clean Data#################################################
#######################################################################


CleanDBData<-function(Mo=0,file='C:/Users/enzo7311/Desktop/dati/CS907jobs1310.csv',MAgent='all',hour=0){
#                        c(18,19,20,12,21,23)){
#  1,2,3,4,5,6,7,8,9,
#Read the big File
  library(lubridate) 
# file<-'ODBC'
  #Type of query
 
  #### FROM [commserv].[dbo].[CommCellBackupInfo] 
  
  if(file!='ODBC'){  
    jobs <- read.csv(file)
    View(jobs)
    jobs$day<-substr(jobs$startdate,1,2)
    jobs$Month<-substr(jobs$startdate,4,5)
    jobs$year<-substr(jobs$startdate,7,10)
    jobs$Start_Time<-dmy_hm(jobs$startdate)
  }
  if(file=='ODBC'){  
    jobs <- ReadODBCJobs()

    jobs$day<-substr(jobs$startdate,9,10)
    jobs$Month<-substr(jobs$startdate,6,7)
    jobs$year<-substr(jobs$startdate,1,4)
    jobs$Start_Time<-ymd_hms(jobs$startdate)
  }  
 
 ###########################
 #jobs$Start_Time<-dmy_hm(jobs$startdate)
 
 ##########################
 
 
 
  ############## Time transformation##############
  jobs<-subset(jobs,jobs$jobstatus == 'Success')
  jobs<-subset(jobs,jobs$data_sp != 'NULL')
 
  ###          FOR IMPUT TROUBLSHOOTING                  #############
 # View(jobs)
  print("MA")
  print(MAgent)
  if(MAgent!='all'){
    jobs<-subset(jobs,grepl(MAgent,jobs$data_sp))
  }
 
  ###############################################
  #                Time filtering
  ########################################
 
  
  
 
 
  ######################################
  ######################################
  
  jobs$hour<-substr(jobs$startdate,12,13)
    
  jobs$year<-as.numeric(jobs$year)
  jobs$Month<-as.numeric(jobs$Month)
  jobs$day<-as.numeric(jobs$day)
  jobs$hour<-as.numeric(jobs$hour)
  
 if(Mo!=0){
   jobs<-subset(jobs,jobs$Month == Mo)
 }
 # jobs<-subset(jobs,jobs$day<25)

  ##########################################
 ###  Start Time #########
 
 # jobs$Start_Time<-ymd_hms(jobs$startdate)

 jobs$Start_Time<-round(jobs$Start_Time,"hours")
  jobs$Start_Time<-as.character(jobs$Start_Time)
 jobs$WDay<-wday(jobs$Start_Time,label = TRUE, abbr = FALSE) 
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

 jobs$Throughput<-(jobs$numbytesuncomp/jobs$durationunixsec)
 
  
  View(jobs)
  return (jobs)
}
#################################################################
################### Data    #####################################


###########################################################

##################    Time   ##############################

AnalysDBtimeSP<-function(Mo=6,file='C:/Users/enzo7311/Desktop/dati/cs403jobs1306.csv', SP="all"){
  library(ggplot2)
  library(gcookbook)
  #Read the big File######
  
  jobs <- CleanDBData(Mo,file)
  
  ############################   Analysis  ###################
  
  
  if(SP!='all'){
    jobs<-subset(jobs,jobs$data_sp %in%  SP)
  }
  
  
  
  ###for night impact
  #  mio<-aggregate(numbytescomp~nightImp + data_sp, sum,data=jobs)
  
  #### carico a livello di CS
  mio<-aggregate(durationunixsec~nightImp , sum,data=jobs)
  mio$durationunixhours<-(mio$durationunixsec/3600)
  View(mio)
  print(SP)
  ggplot(mio, aes(y=durationunixhours,x=nightImp)) +  geom_point() + geom_line() 
  
  # return(mio)
  
}
###########################################################

##################    Troughput   ##############################

AnalysDBTroughputSP<-function(Mo=9,file='C:/Users/enzo7311/Desktop/dati/cs902jobs0809.csv', SP="all", Magent="all"){
  library(ggplot2)
  library(gcookbook)
  library(plyr)
  #Read the big File######
  
  jobs <- CleanDBData(Mo,file,Magent)
  
  ############################   Analysis  ###################
  
  
  if(SP!='all'){
    jobs<-subset(jobs,jobs$data_sp %in%  SP)
  }
  print(summary(jobs))
  pp<-ggplot(jobs,aes(x=numbytescomp, y=numobjects,z=durationunixsec))   +  stat_density2d()
  
  
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
  
  jobs<-subset(mio,jobs$numbytescomp >0)
  
  
  ################################
  ##Analysis#############
  print("Correlation data vs time")
  print(cor(mio$numbytescomp,mio$durationunixhours))
  print(lm(mio$durationunixhours~mio$numbytescomp))
  
  print("Correlation n file vs time")
  print(cor(mio$durationunixhours,mio$numobjects))
  print(lm(mio$durationunixhours~mio$numobjects))
  print("linear relation coefs")
  print(lm(mio$durationunixhours~mio$numbytescomp+mio$numobjects))
  
  
  mio<-arrange(mio,trougput)
  ##################### Linear Model###############
  a<-coef(lm(mio$durationunixhours~mio$numbytescomp+mio$numobjects))
  mio$simulation<-a[1]+a[2]*mio$numbytescomp+a[3]*mio$numobjects
  mio$Delta<-mio$durationunixhours-mio$simulation
  mio$ratio<-mio$durationunixhours-mio$simulation
  print("ratio details")
  print(summary(mio$ratio))
  Details<-mio
  View(Details)
  View(mio)
  print(SP)
  print(acf(mio$numbytescomp))
#  ggplot(mio, aes(y=trougput,x=Delta)) +  geom_point()  
#pp<-ggplot(jobs,aes(x=numbytescomp, y=numobjects,z=trougput)) +  stat_density2d()

#qplot(x=numbytescomp, y=numobjects,z=trougput, data = Details, geom = "contour")
p0<-ggplot(mio,aes(x=numbytescomp, y=numobjects))  +  geom_point(aes(colour=data_sp)) + geom_density2d()
p1<-ggplot(mio, aes(y=numbytescomp,x=nightImp)) +  geom_point()  + geom_line(aes(colour=data_sp))
p2<-ggplot(mio, aes(y=durationunixhours,x=nightImp)) +  geom_point()  + geom_line(aes(colour=data_sp))
p3<-ggplot(mio, aes(y=trougput,x=nightImp)) +  geom_point()  + geom_line(aes(colour=data_sp))
p4<-ggplot(mio, aes(x=numbytescomp,y=durationunixhours))+  geom_point(aes(colour=data_sp))
p6<-ggplot(mio, aes(x=numobjects,y=durationunixhours))+  geom_point(aes(colour=data_sp))
p5<-ggplot(mio, aes(y=numobjects,x=nightImp)) +  geom_point()  + geom_line(aes(colour=data_sp))
print(coef(lm(mio$durationunixhours~mio$numbytescomp+mio$numobjects)))
#abline(coef(lm(mio$durationunixhours~mio$numbytescomp+mio$numobjects)))
multiplot(pp,p0,p1, p2, p3, p4,p5,p6, cols=2) 
}

#####################################

###### TREND ANALYSIS

####################################

AnalysTrendJOBS<-function(Mo=0,file='C:/Users/enzo7311/Desktop/dati/cs403jobs1306.csv', SP="all", Magent="all"){
  library(ggplot2)
  library(gcookbook)
  library(plyr)
  #Read the big File######
  
  jobs <- CleanDBData(Mo,file,Magent)
  jobs<-jobs[with(jobs, order(startsimply)), ]
  ############################   Analysis  ###################
  
    
View(jobs)

jobs.stl = stl(jobs$numbytescomp)#, s.window="periodic")
plot(jobs.stl)


  
}




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

########################################################################################
############  INDEX CACHE###############################################################
########################################################################################



sortNumObjects<-function(Mo=6,file='C:/Users/enzo7311/Desktop/test_/backupinfo.csv',MAgent='all',hour=0)
{
  library(ggplot2)
  library(gcookbook)
  
  jobs<-CleanDBDataAll(Mo=7,file='C:/Users/enzo7311/Desktop/dati/cs402jobs2107.csv',MAgent='all',hour=0)  
  
  job_ORd_OBJ<-jobs[with(jobs, order(-numobjects)),]
  View(job_ORd_OBJ)
  globalNUM<-aggregate(numobjects~day+hour, sum,data=jobs)
  globalNUM<-globalNUM[with(globalNUM, order(day,hour)),]
  globalNUM_Day<-aggregate(numobjects~day, sum,data=jobs)
  globalNUM_SPDay<-aggregate(numobjects~day+data_sp, sum,data=jobs)
  globalNUM_hour<-aggregate(numobjects~hour, sum,data=jobs)
  globalNUM_idataagent<-aggregate(numobjects~idataagent, mean,data=jobs)
  
  View(globalNUM)
  View(globalNUM_idataagent)
  View(globalNUM_SPDay)
p1<-ggplot(globalNUM, aes(y=numobjects,x=day))   + geom_point() + geom_line()#colour=factors(hour) 
p2<-ggplot(globalNUM_Day, aes(y=numobjects,x=day))   +geom_point()+ geom_line() #colour=factors(hour) 
p3<-ggplot(globalNUM_hour, aes(y=numobjects,x=hour))   +geom_point()+ geom_line() #colour=factors(hour) 
p4<-ggplot(globalNUM_idataagent, aes(y=numobjects,x=idataagent))   +geom_point()#+ geom_line(
p5<-ggplot(globalNUM_SPDay, aes(y=log10(numobjects),x=day))   +geom_point() + facet_grid(. ~ data_sp)#+ geom_line(
p6<-ggplot(jobs,aes(factor(idataagent),log10(numobjects)))+geom_boxplot()
p7<-ggplot(jobs,aes(factor(idataagent),log10(numbytescomp)))+geom_boxplot()
#p8<-ggplot(jobs),aes(factor(idataagent),log10(numobjects)))+geom_boxplot()  +facet(# return(job)
multiplot(p1, p2,p3,p4,  cols=2) #  cols=2) 
plot(p5)
plot(p6)
plot(p7)
}

#########Clean Data####################

CleanDBDataAll<-function(Mo=6,file='C:/Users/enzo7311/Desktop/test_/backupinfo.csv',MAgent='all',hour=0){
  
  jobs <- read.csv(file)
  jobs<-subset(jobs,jobs$data_sp != 'zDDB 7Day DO NOT USE')
  jobs$day<-substr(jobs$enddate,1,2)
  jobs$Month<-substr(jobs$enddate,4,5)
  jobs$year<-substr(jobs$enddate,7,10)
  jobs$hour<-substr(jobs$enddate,12,13)
  
  jobs$year<-as.numeric(jobs$year)
  jobs$Month<-as.numeric(jobs$Month)
  jobs$day<-as.numeric(jobs$day)
  jobs$hour<-as.numeric(jobs$hour)
  
  jobs$nightImp<-jobs$day
  
  jobs$nightImp<-jobs$nightImp +  floor(jobs$hour/12)
  
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
  
  ######################################
  ######################################
  
  
  View(jobs)
#  return (jobs)
}


########################################
#####Density Analysis###################
########################################

DensityJobs<-function(Mo=6,file='C:/Users/enzo7311/Desktop/test_/backupinfo.csv', SP="all"){
  library(ggplot2)
  jobs <- CleanDBData(Mo,file)
  
  p4<-ggplot(jobs, aes(x = log(numobjects))) +geom_density(aes(fill=factor(idataagent)))
  p2<-ggplot(jobs, aes(x = log(numbytescomp))) +geom_density(aes(fill=factor(idataagent)))
  
  p3<-ggplot(jobs, aes(x = log(durationunixsec))) +geom_density(aes(fill=factor(idataagent)))                                                                               
  p1<-ggplot(jobs, aes(x = log(durationunixsec))) +geom_density() + facet_grid(.~hour)                                                                               
  p5<-ggplot(jobs, aes(x =durationunixsec,y=hour)) + geom_violin()+ geom_jitter(height = 0)
  p6<-ggplot(jobs, aes(x =numbytescomp,y=hour)) + geom_violin()
  p7<-ggplot(jobs, aes(y =log(durationunixsec),x=idataagent)) + geom_violin()
  
  multiplot(p1,  cols=2) #  cols=2) 
  
  multiplot(p2,p3,p4,  cols=2)
  multiplot(p5,p6,p7,  cols=2) #  cols=2) 
  
}
  