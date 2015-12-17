gisAUX<-function(){
  library(lubridate) 
  library(ggplot2)
    library(googleVis)
  AUX<-read.csv("C:/dati/AUX_Analisis/global.csv",sep=',')
  AUX$Date<-ymd_hms(AUX$Date)
  AUX$WeekDay<-as.factor(lubridate::wday(AUX$Date, label = TRUE))
#  AUX$Dateh<-floor_date(AUX$Date, "hour")
  AUX$Dated<-floor_date(AUX$Date, "day")
  #AUX$Dated<-as.factor(wday(AUX$Dated))#,label = FALSE, abbr = TRUE))
  #AUX$Dated<-as.data(AUX$Dated)
  
  AUX$timeHs<-as.integer(hour(AUX$Date))
  AUX$timeDay<-as.integer(day(AUX$Date))
  
  filterDate<-ymd_hms(now())-days(60)
#  print(filterDate)
  AUX$Storage.Policy<-paste(AUX$CS,"-",AUX$Storage.Policy,"-",AUX$Copy)
  
  AUX<-AUX[AUX$Date > filterDate,]
  #View(AUX)
  RankALL<-aggregate(Residual.Size~Dated+Storage.Policy+CS+WeekDay,mean,data=AUX)
  RankCS<-aggregate(Residual.Size~Dated+CS+WeekDay,sum,data=RankALL) 
  
  RankCS$Storage.Policy<-RankCS$CS
  #View(RankCS)
  RankALL<-rbind(RankALL,RankCS)
    RankALL$Dated<-as.Date(as.character(RankALL$Dated),format="%Y-%m-%d")
  #View(RankALL)
  
  myState<-'
  {"xLambda":1,"yAxisOption":"4","xZoomedDataMin":1440547200000,"yZoomedDataMax":700,"iconType":"LINE","dimensions":{"iconDimensions":["dim0"]},
  "yZoomedDataMin":0.5,"yLambda":1,"time":"2015-12-10","xZoomedDataMax":1449705600000,"duration":{"multiplier":1,"timeUnit":"D"},
  "uniColorForNonSelected":false,"nonSelectedAlpha":0.4,"playDuration":15000,"colorOption":"2","orderedByX":false,"xZoomedIn":false,"showTrails":false,
  "orderedByY":false,"yZoomedIn":false,"xAxisOption":"_TIME","iconKeySettings":[{"key":{"dim0":"CS499"}},{"key":{"dim0":"CSITS"}},
  {"key":{"dim0":"CS404"}},{"key":{"dim0":"CS498"}}],"sizeOption":"_UNISIZE"}
  '
  #print(myState)
  
  Motion=gvisMotionChart(RankALL, 
                         idvar="Storage.Policy", yvar="Residual.Size",
                         timevar="Dated",options = list(height="800px",width="1600px",state=myState))
  plot(Motion)
  print(Motion,'chart',file="c:/temp/mio.html")
}
