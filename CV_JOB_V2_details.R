library(dygraphs)
library(data.table)
library(dplyr)
library(xts)
library(lubridate) #Date management
library(ggplot2)
library(tidyr)
library(reshape)
CS_Detail="CS401"
Jobs_RAW <- read.csv("C:/Users/enzo7311/Desktop/globalJobspandav4.csv")
Jobs_RAW$Date.and.Time<-ymd_hms(Jobs_RAW$Date)
Jobs_RAW$Date.and.Time<-floor_date(Jobs_RAW$Date.and.Time, "hour")
#View(Jobs_RAW)
#################
##Filtering by time
filterDate<-ymd_hms(now())-days(2)

Jobs_RAW<-Jobs_RAW[Jobs_RAW$Date.and.Time > filterDate,]
Jobs_RAW<-subset(Jobs_RAW,Jobs_RAW$CS==CS_Detail)
Jobs_RAW[is.na(Jobs_RAW)]=0


Jobs_RAW<-subset(Jobs_RAW,Jobs_RAW$Status=="Waiting")
Jobs_RAW$Status<-NULL
Jobs_RAW$Waiting<-as.numeric(Jobs_RAW$Number)
Jobs_RAW$Number<-NULL
Jobs_RAW$Storage.Policy<-as.factor(Jobs_RAW$Storage.Policy)

m <-reshape(Jobs_RAW, direction = "wide", timevar = "Storage.Policy", idvar = "Date.and.Time")          
View(m)
xts_Jobs_402<-xts(m[,-1],order.by=m$Date.and.Time)
dygraph(xts_Jobs_402,main="CS402") %>% dyOptions(useDataTimezone = TRUE)%>% dyRangeSelector()%>% dyRangeSelector()%>%
  dyHighlight(highlightSeriesOpts = list(strokeWidth = 3))
