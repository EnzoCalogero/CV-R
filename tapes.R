
tapesF<-function(file="C:/Users/enzo7311/Desktop/test_/tapes1206.csv", dayREF=20140612){
  #Read the big File######
  library("plyr")
  #  library(lubridate)
  
  jobs <- read.csv(file)
    
  #View(jobs)
  dayREF<-as.numeric(dayREF)
  jobs$Estimated.Aging.Date<-as.character(jobs$Estimated.Aging.Date)
  jobs$Estimated.Day<-substr(jobs$Estimated.Aging.Date,1,10)
  jobs$Estimated.Day[jobs$Estimated.Day=="Now"]<-"00/00/0000"
  jobs$day<-substr(jobs$Estimated.Day,4,5)
  jobs$Month<-substr(jobs$Estimated.Day,1,2)
  jobs$year<-substr(jobs$Estimated.Day,7,10)
  
  jobs$Media<-substr(jobs$Media,1,8)
  
  jobs$year<-as.numeric(jobs$year)
  jobs$Month<-as.numeric(jobs$Month)
  jobs$day<-as.numeric(jobs$day)
  
  jobs$Estimated.Day<-jobs$year*10000+jobs$Month*100+jobs$day
  
  mio<-aggregate(Estimated.Day~Media, max,data=jobs)
   
#  print(mio)
  finale<-table(mio$Estimated.Day)
#  View(mio)
#  View(finale)
  #print(finale)
  #########Problematic analysis######################

problematic<-mio$Media[mio$Estimated.Day < dayREF & mio$Estimated.Day >0]
usefull<-mio$Media[mio$Estimated.Day < (dayREF+7) & mio$Estimated.Day >=dayREF]
useless<-mio$Media[mio$Estimated.Day > (dayREF+7)]
#print(class(mio))
#print (problematic)
View(finale)
View(problematic)
View(usefull)
View(useless)
#return(mio)
print (useless)
} 



tapes_OLD<-function(file){
  #Read the big File######
  library("plyr")
  #  library(lubridate)
  
  jobs <- read.csv(file)
  #View(jobs)
  jobs$Estimated.Aging.Date<-as.character(jobs$Estimated.Aging.Date)
  jobs$Estimated.Day<-substr(jobs$Estimated.Aging.Date,1,10)
  jobs$Estimated.Day[jobs$Estimated.Day=="Now"]<-"00/00/0000"
  jobs$day<-substr(jobs$Estimated.Day,4,5)
  jobs$Month<-substr(jobs$Estimated.Day,1,2)
  jobs$year<-substr(jobs$Estimated.Day,7,10)
  
  jobs$year<-as.numeric(jobs$year)
  jobs$Month<-as.numeric(jobs$Month)
  jobs$day<-as.numeric(jobs$day)
  
  jobs$Estimated.Day<-jobs$year*10000+jobs$Month*100+jobs$day
  
  days<-table(Day=jobs$Estimated.Day)
  print(days)
  View(days)
  View(jobs)
} 
