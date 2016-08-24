##Isilon
library(dplyr)
client.usage <- read.csv("C:/Users/enzo7311/Desktop/Isilon Analysis/client usage.csv", sep=";")

client.usage$miaData<-as.POSIXct(as.numeric(as.character(client.usage$Time..Unix...GMT.)),origin="1970-01-01",tz="GMT")

client.usage$clientTime<-as.POSIXct(as.numeric(as.character(client.usage$Time..Unix...GMT.)),origin="1970-01-01",tz="GMT")
client.usage<-select(client.usage, starts_with("clien"))

#78 --> is teh data and time
rowSums (client.usage[,1:77], na.rm = TRUE, dims = 1)
datamoved<-colSums (client.usage[,1:77], na.rm = TRUE, dims = 1)
 View(datamoved)
