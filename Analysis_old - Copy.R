#########Clean Data####################
CleanData<-function(file){
#Read the big File######
library("plyr")
library(lubridate)
 
jobs <- read.csv(file)
############## Time transformation##############
#jobs$Start.Time <- as.Date(jobs$Start.Time, "%d/%m/%Y %H:%M")

jobs$Start.Time<-strptime(jobs$Start.Time,"%d/%m/%Y %H:%M")
jobs$End.Time<-strptime(jobs$End.Time,"%d/%m/%Y %H:%M")
#Duration in minutes

jobs$Duration<-difftime(jobs$End.Time,jobs$Start.Time,units="mins")
jobs$Duration<-as.numeric(jobs$Duration)
#####Creation simple time###########

jobs$Start.Time.h<-hour(jobs$Start.Time)
jobs$Start.Time.h<-as.numeric(jobs$Start.Time.h)
jobs$Start.Time.d<-day(jobs$Start.Time)
jobs$Start.Time.d<-as.numeric(jobs$Start.Time.d)
jobs$Start.Time.m<-month(jobs$Start.Time)
jobs$Start.Time.m<-as.numeric(jobs$Start.Time.m)


#jobs$Start.Time.simply<-as.character(jobs$Start.Time.simply)
jobs$Start.Time.simply<-(10000*month(jobs$Start.Time)+100*(day(jobs$Start.Time))+ hour(jobs$Start.Time))

#jobs$Start.Time.simply[jobs$Start.Time.h >9]<-paste(day(jobs$Start.Time), jobs$Start.Time.h,sep="")
#jobs$Start.Time.simply[jobs$Start.Time.h <10]<-paste(day(jobs$Start.Time), jobs$Start.Time.h,sep="0")
#jobs$Start.Time.simply<-as.numeric(jobs$Start.Time.simply)
#jobs$Start.Time.simply<-paste(day(jobs$End.Time), hour(jobs$End.Time),sep="")


#########  Finish   ###############


#### Transform the Written Data in the same unit###############
jobs$Data.Written<-as.character(jobs$Data.Written)

jobs$Data.Written<-sub("MB","1",jobs$Data.Written)
jobs$Data.Written<-sub("GB","1024",jobs$Data.Written)
jobs$Data.Written<-sub("KB","0.001",jobs$Data.Written)
jobs$Data.Written<-sub("Bytes","0.001",jobs$Data.Written)

#return (jobs)


list <- strsplit(jobs$Data.Written, " ")
#return(list)
colnames(df) <- c("DataW.valore", "DataW.size")
df <- ldply(list)
colnames(df) <- c("DataW.valore", "DataW.size")
jobs<-cbind(jobs,df)


jobs$DataW.valore<-as.numeric(jobs$DataW.valore)
jobs$DataW.size<-as.numeric(jobs$DataW.size)
jobs$DataW.valore<-jobs$DataW.valore*jobs$DataW.size
#############Finish##############
#### Transform the Application size in the same unit###############
jobs$Size.of.Application<-as.character(jobs$Size.of.Application)

jobs$Size.of.Application<-sub("MB","1",jobs$Size.of.Application)
jobs$Size.of.Application<-sub("GB","1024",jobs$Size.of.Application)
jobs$Size.of.Application<-sub("KB","0.001",jobs$Size.of.Application)
jobs$Size.of.Application<-sub("Bytes","0.001",jobs$Size.of.Application)

list <- strsplit(jobs$Size.of.Application, " ")
#return(list)
#colnames(df) <- c("DataAPLSIZE.valore", "DataAPLSIZE.size")
df <- ldply(list)
colnames(df) <- c("DataAPLSIZE.valore", "DataAPLSIZE.size")
jobs<-cbind(jobs,df)


jobs$DataAPLSIZE.valore<-as.numeric(jobs$DataAPLSIZE.valore)
jobs$DataAPLSIZE.size<-as.numeric(jobs$DataAPLSIZE.size)
jobs$DataAPLSIZE.valore<-jobs$DataAPLSIZE.valore*jobs$DataAPLSIZE.size
#############Finish##############

View(jobs)
return (jobs)
}



####################Time Consuming analysis########################
analyseDurata<-function(file){
  library(ggplot2)
  library(gcookbook)
  #Read the big File######
  jobs<-CleanData(file)
  #jobs <-read.csv(file)
 
 
 ############################   TESTING  ###################
 
  mio<-aggregate(Duration~Start.Time.simply + Storage.Policy, sum,data=jobs)
  
 
print(mio)
 ggplot(mio, aes(y=Duration,x=Start.Time.simply)) +  geom_line(aes(colour=Storage.Policy))
}
######################################################
analyseDurata_Inside_SP<-function(file){
  library(ggplot2)
  library(gcookbook)
  #Read the big File######
  jobs<-CleanData(file)
  #jobs <-read.csv(file)
  
  
  ############################   TESTING  ###################
  
  mio<-aggregate(Duration~Start.Time.simply, sum,data=jobs)
  
  
  print(mio)
  ggplot(mio, aes(y=Duration,x=Start.Time.simply)) +  geom_line()
}
######################################################

######################################################
analyseDurataSP<-function(file,SP="z_2Week_MA09-B"){
  library(ggplot2)
  library(gcookbook)
  #Read the big File######
  
  jobs <- read.csv(file)
  
  
  ############################   TESTING  ###################
  
  mio<-aggregate(DurSec~Start.Time + Storage.Policy, sum,data=jobs)
  
  
  #print(mio)
  
  mio2<-subset(mio,mio$Storage.Policy ==  SP)
  print(mio2)
 
 ggplot(mio2, aes(y=DurSec,x=Start.Time)) +  geom_line()
}

##################### FREQUENCY Analysis #########
analyseFrequenze<-function(file){
  library(ggplot2)
  library(gcookbook)
  #Read the big File######
  
  jobs <- read.csv(file)
  #"C:/Users/enzo7311/Desktop/test_/406.csv")  
  # summary(jobs)
  
  ############################   TESTING  ###################
  
  mio<-aggregate(DurSec~Start.Time + Storage.Policy, sum,data=jobs)
  print(table(jobs$Start.Time, jobs$Storage.Policy))
  print("for starting data")
  print(table(jobs$Start.Time))
    
}

##############################Dimensional Analysis ##########################################

analysAPTot<-function(file){
  library(ggplot2)
  library(gcookbook)
  #Read the big File######
 
  jobs <- read.csv(file)
 
 ############################   Analysis  ###################
 
  mio<-aggregate(APpL.TotMB~Start.Time + Storage.Policy, sum,data=jobs)
  ##################  Outout  ################################
  
  print(mio)
  ggplot(mio, aes(y=APpL.TotMB,x=Start.Time)) +  geom_line(aes(colour=Storage.Policy))
}

analysAPTotSP<-function(file, SP="z_2Week_MA09-B"){
  library(ggplot2)
  library(gcookbook)
  #Read the big File######
  
  jobs <- read.csv(file)
  
  ############################   Analysis  ###################
  
  mio<-aggregate(APpL.TotMB~Start.Time + Storage.Policy, sum,data=jobs)
  # mio2<-mio[mio$Storage.Policy ==  "z_2Week_MA09-B"]

  #
  ##################  Outout  ################################
  
  
  mio2<-subset(mio,mio$Storage.Policy %in%  SP)
  mio3<-aggregate(APpL.TotMB~Start.Time, sum,data=mio2)
  print(mio2)
  #ggplot(mio3, aes(y=APpL.TotMB,x=Start.Time)) +  geom_point() + geom_line() 
  ggplot(mio2, aes(y=APpL.TotMB,x=Start.Time)) +  geom_point(aes(colour=Storage.Policy)) + geom_line(aes(colour=Storage.Policy)) 
}
