#########Clean Data####################

CleanDBData<-function(Mo=6,file='C:/Users/enzo7311/Desktop/test_/backupinfo.csv',MAgent='all',hour=0){
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
  #View(jobs)
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
  
  View(jobs)
  return (jobs)
}
#################################################################
################### Data    #####################################
AnalysDBWritenSP<-function(Mo=6,file='C:/Users/enzo7311/Desktop/test_/backupinfo.csv', SP="12WeekOffSite (DiskA-MA14)"){
  library(ggplot2)
  library(gcookbook)
  #Read the big File######
  
  jobs <- CleanDBData(Mo,file)
  
  ############################   Analysis  ###################
  
  
  if(SP!='all'){
    jobs<-subset(jobs,jobs$data_sp %in%  SP)
    }
  
   # jobs<-subset(jobs,jobs$data_sp %in%  SP)
  ###hourly impact#####
  #mio<-aggregate(numbytescomp~startsimply + data_sp, sum,data=jobs)
  #ggplot(mio, aes(y=numbytescomp,x=startsimply)) +  geom_point() + geom_line() 
  
  ###for night impact
#  mio<-aggregate(numbytescomp~nightImp + data_sp, sum,data=jobs)
#### carico a livello di CS
  mio<-aggregate(numbytescomp~nightImp , sum,data=jobs)
  View(mio)
  ggplot(mio, aes(y=numbytescomp,x=nightImp)) +  geom_point() + geom_line() 
  
  
  
 # ggplot(mio, aes(y=numbytescomp,x=startsimply)) +  geom_point() + geom_line() 
  #ggplot(mio2, aes(y=APpL.TotMB,x=Start.Time)) +  geom_point(aes(colour=Storage.Policy)) + geom_line(aes(colour=Storage.Policy)) 
 # return(mio)
  
}

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

AnalysDBTroughputSP<-function(Mo=6,file='C:/Users/enzo7311/Desktop/dati/cs403jobs1306.csv', SP="all", Magent="all"){
  library(ggplot2)
  library(gcookbook)
  library(plyr)
  #Read the big File######
  
  jobs <- CleanDBData(Mo,file,Magent)
  
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
  print(SP)
  print(acf(mio$numbytescomp))
#  ggplot(mio, aes(y=trougput,x=Delta)) +  geom_point()  

p1<-ggplot(mio, aes(y=numbytescomp,x=nightImp)) +  geom_point()  + geom_line(aes(colour=data_sp))
p2<-ggplot(mio, aes(y=durationunixhours,x=nightImp)) +  geom_point()  + geom_line(aes(colour=data_sp))
p3<-ggplot(mio, aes(y=trougput,x=nightImp)) +  geom_point()  + geom_line(aes(colour=data_sp))
p4<-ggplot(mio, aes(x=numbytescomp,y=durationunixhours))+  geom_point(aes(colour=data_sp))
p6<-ggplot(mio, aes(x=numobjects,y=durationunixhours))+  geom_point(aes(colour=data_sp))
p5<-ggplot(mio, aes(y=numobjects,x=nightImp)) +  geom_point()  + geom_line(aes(colour=data_sp))
print(coef(lm(mio$durationunixhours~mio$numbytescomp+mio$numobjects)))
#abline(coef(lm(mio$durationunixhours~mio$numbytescomp+mio$numobjects)))
multiplot(p1, p2, p3, p4,p5,p6, cols=2) 
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
