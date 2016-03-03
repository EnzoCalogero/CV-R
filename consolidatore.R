library(lubridate)
library(dygraphs)
library(data.table)
library(dplyr)
library(xts)
library(reshape2)
library() #Date management
library(ggplot2)
library(tidyr)

file<-'C:/temp/ord1/temp.csv'
AFID <- read.csv(file,sep=',',stringsAsFactors=TRUE)
AFID$TimeSec<-NULL
AFID$Date<-mdy_hms(AFID$Date)
AFID$Date<-floor_date(AFID$Date, "hour")
#AFID$Time.Hours<-(AFID$TimeSec/(60*60))
#AFID$timeHs<-as.integer(hour(AFID$Date1))
View(AFID)
RankALL<-aggregate(AFID~Date+DDBID+Host+DC, max,data=AFID)
View(RankALL)
write.csv2(RankALL,'C:/temp/ord1/tempRank.csv')
#
# Seconda Parte.....

file<-'C:/temp/ord1/temp2.csv'
AFID <- read.csv(file,sep=',',stringsAsFactors=TRUE)
AFID$TimeSec<-NULL
AFID$Date<-mdy_hms(AFID$Date)
AFID$Date<-floor_date(AFID$Date, "hour")
View(AFID)
RankALLtemp<-aggregate(AFID~Date+DDBID+Host+DC, max,data=AFID)
View(RankALLtemp)

file<-'C:/temp/ord1/tempRank.csv'
RankALL <- read.csv(file,sep=';',stringsAsFactors=TRUE)
RankALL$X<-NULL
View(RankALL)

#RankALLfinal<-rbind(RankALL,RankALLtemp)
#View(RankALLfinal)
#write.csv2(RankALLfinal,'C:/temp/ord1/tempRank.csv')

RankALL$Date<-ymd_hms(RankALL$Date)


data_wide <- dcast(RankALL, Date  ~ DDBID,max, value.var="AFID")
View(data_wide)
data_wide<-subset(data_wide,data_wide$Date < mdy_hms("01.15.2015 00:00:00"))

xts_Prun_ddb<-xts(data_wide[,-1],order.by=data_wide$Date)



dygraph(xts_Prun_ddb,main="test")%>% dyRangeSelector()
