chunks_Analysis<-function(file='C:/Users/enzo7311/Desktop/chunkAnalysis/cs499.csv'){
  library(ggplot2)
  library(doBy)
  chunks<-read.csv(file)
  View(chunks)
  ChunksM<-subset(chunks,chunks$physicalSize > 17179869184)
  chunkMax<-subset(ChunksM,ChunksM$physicalSize == max(ChunksM$physicalSize))
  print ("Mean")
  print(log10(mean(chunks$physicalSize)))
  print ("Max")
  print((max(chunks$physicalSize)))
  1.019319e+12
  ChunksM$Date<-as.Date(as.POSIXct(ChunksM$modifiedTime, origin="1970-01-01")) 
  #DDB<-subset(DDB,DDB$AvgQITime > 0 & DDB$NumOfConnections > 0)
  #DDB$trughput<-(128/(DDB$AvgQITime/100000))/1024##mg/sec 
  ChunksM$Date<-as.POSIXct(ChunksM$modifiedTime, origin="1970-01-01")
  ###Modify for the time zone
  View(ChunksM)
  View(chunkMax)
  m1 <- ggplot(chunks, aes(x = log10(physicalSize)))+ geom_density()+ geom_vline(xintercept = log10(17179869184),colour=2)
  multiplot(m1, cols=2)
m2 <- ggplot(ChunksM, aes(x = (physicalSize)/1024^3))+ geom_density()+ geom_vline(xintercept = (17179869184)/1024^3,colour=2)
t1<-ggplot(ChunksM,)+ geom_point(aes(x=Date,y=(physicalSize)/1024^3),colour="red") 
multiplot(t1, cols=1)

multiplot(m2, cols=2)
}