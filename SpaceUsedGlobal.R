library(lubridate) 
library(ggplot2)
suppressPackageStartupMessages(library(googleVis))

globalSpaceUsed <- read.csv("C:/Users/enzo7311/Desktop/globalSpaceUsed.csv")

globalSpaceUsed$StoragePolicy<-paste(globalSpaceUsed$CommServName,"-",globalSpaceUsed$SPName,"-",globalSpaceUsed$StoragePolicyCpy)



GS<-aggregate(sizeOnMedia~DAY+StoragePolicy+CommServName,mean,data=globalSpaceUsed)
GS2<-aggregate(totalAppSize~DAY+StoragePolicy,mean,data=globalSpaceUsed)

GS<-merge(GS, GS2, by =c("StoragePolicy","DAY"))
GS$Ratio<-round((1+GS$sizeOnMedia)/(1+GS$totalAppSize),3)
GS$flag<-0
###Assumption....
GS$Ratio[which(GS$sizeOnMedia > GS$totalAppSize)]=1
GS$flag[which(GS$sizeOnMedia > GS$totalAppSize)]=1
GS$DAY<-ymd(GS$DAY)

dfw<-subset(GS,substr(GS$StoragePolicy,0,3)=="dfw")
dfw$DAY<-ymd(dfw$DAY)
#lib<-unique(data.frame(StoragePolicy=globalSpaceUsed$StoragePolicy ,Library=globalSpaceUsed$LibraryName ))
#dfw<-merge(dfw, lib, by = "StoragePolicy")
myState<-'
{"xZoomedDataMax":92,"iconType":"BUBBLE","orderedByY":false,"dimensions":{"iconDimensions":["dim0"]},"showTrails":true,
"xZoomedDataMin":0,"xAxisOption":"_ALPHABETICAL","orderedByX":false,"nonSelectedAlpha":0.4,"playDuration":15000,"xZoomedIn":false,
"iconKeySettings":[],"yLambda":1,"yZoomedIn":false,"uniColorForNonSelected":false,"xLambda":1,"colorOption":"4",
"yZoomedDataMax":176578423200000,"yAxisOption":"3","sizeOption":"5","duration":{"multiplier":1,"timeUnit":"D"},"time":"2016-07-31",
"yZoomedDataMin":0}
'



Motion=gvisMotionChart(dfw, 
                       idvar="StoragePolicy", yvar="sizeOnMedia",
                       timevar="DAY",options = list(height="800px",width="1600px",showChartButtons=TRUE,state=myState))
plot(Motion)
print(Motion,'chart',file="c:/Apache24/htdocs/SpaceIsolon/DFW/SpaceDFW.html")
#"StoragePolicy",