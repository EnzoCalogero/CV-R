CriticalSize<-function(sidb=0,Mo=10,file='C:/temp/temp.csv'){
  library(ggplot2)
  library(doBy)  
  library(lubridate)

  AFID <- read.csv(file)
  AFID$DDBID<-paste(AFID$Host,"-ID-",AFID$DDBID)
  AFID$Date1<-mdy_hms(AFID$Date)
  AFID$Date2<-floor_date(AFID$Date1, "hour")
  AFID$Date3<-floor_date(AFID$Date1, "day")
  # round_date
  AFID$Time.Hours<-(AFID$TimeSec/(60*60))
  AFID$timeHs<-as.integer(hour(AFID$Date1))
  AFID$timeDay<-as.integer(day(AFID$Date3))
  
  
  View(AFID)
  AFID$days<-mday(AFID$Date1)
  DDBAggr2<-aggregate(AFID~Date2+DDBID, max,data=AFID)
  #View(DDBAggr2)
  DDBAggr3<-aggregate(AFID~Date2+DDBID, min,data=AFID)

  m1 <- ggplot(AFID, aes(x = Date1,y=AFID))+  geom_point() +geom_line() + facet_grid(DDBID  ~. )+ ggtitle("AFID pending Trend")
  
  
  AFID18<-subset(AFID, timeHs >=18 )
  Rank18<-aggregate(AFID~Date3+DDBID, max,data=AFID18)
  View(AFID18)
  View(Rank18)
  #View(AFID18)
  m2 <- ggplot(AFID18, aes(x = Date1,y=AFID))+  geom_point() +geom_line() + facet_grid(DDBID  ~. )+ ggtitle("AFID pending Trend After 18")
  AFID21<-subset(AFID, timeHs >=21 )
  Rank21<-aggregate(AFID~Date3+DDBID, max,data=AFID21)
  View(AFID21)
  View(Rank21)
  m3 <- ggplot(AFID21, aes(x = Date1,y=AFID))+  geom_point() +geom_line() + facet_grid(DDBID  ~. )+ ggtitle("AFID pending Trend After 21")
  
  multiplot(m1, cols=1)
  multiplot(m2, cols=1)
  multiplot(m3, cols=1)

}
