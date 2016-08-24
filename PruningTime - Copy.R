library(lubridate)
library(dygraphs)
library(data.table)
library(dplyr)
library(xts)
library(reshape2)
library(lubridate) #Date management
library(ggplot2)
library(tidyr)

file<-'C:/temp/ord1/tempRank.csv'
RankALL <- read.csv(file,sep=';',stringsAsFactors=TRUE)
RankALL$X<-NULL
View(RankALL)
RankALL$Date<-ymd_hms(RankALL$Date)
RankALL$DDBID<-paste(RankALL$Host,"-",RankALL$DDBID)
RankALL$CS<substr(RankALL$Host,1,5)
data_wide <- dcast(RankALL, Date  ~ DDBID,max, value.var="AFID")
View(data_wide)
data_wide<-subset(data_wide,data_wide$Date < mdy_hms("01.15.2015 00:00:00"))

xts_Prun_ddb<-xts(data_wide[,-1],order.by=data_wide$Date)



dygraph(xts_Prun_ddb,main="test")%>% dyRangeSelector()
