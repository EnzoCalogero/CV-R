
library("animation")

TTprune_Analysis<-function(sidb=c(72,60),Mo=c(11,12),file='C:/Users/enzo7311/Desktop/sealing/sidengine/CS901_23_12.csv',hour=0){
  library(ggplot2)
  library(doBy)  
  library(lubridate)
  library("animation")
  
  #DDB<-DedupRead(file,sidb,Mo)
  AFID <- read.csv(file)
  AFID$Date1<-mdy_hms(AFID$Date)
  AFID$Date2<-floor_date(AFID$Date1, "hour")
  # round_date
  AFID$Time.Hours<-(AFID$TimeSec/(60*60))
  AFID$timeHs<-as.integer(hour(AFID$Date1))
  ####DDB filter
  AFID<-subset(AFID,DDBID==sidb)
  #AFID<-subset(AFID,day(Date1) >3 |day(Date1)<24 )
  #AFID<-subset(AFID,year(Date1)==2014)
  ####Time Filter
  #AFID<-subset(AFID,(month(Date1)==11)&(day(Date1)>15)|((month(Date1)==12)))
  #AFID<-subset(AFID,(((month(Date1)==12))))
  #AFID<-subset(AFID,day(Date1)>20)
  #View(AFID)
  #AUXDay<-aggregate(DataWritten~day, sum,data=AUX)
  #AFID17<-subset(AFID, timeHs ==17 )
  #View(AFID17)
  #days<-c("2014-11-13 18:00:00","2014-11-12 18:00:00","2014-11-14 18:00:00")
  #m17 <- ggplot(AFID17, aes(x = Date1,y=AFID))+ geom_point()  + facet_grid(DDBID  ~. )+ ggtitle("AFID Pending at 17 low impact")
  AFID$days<-mday(AFID$Date1)
  #DDBAggr2<-aggregate(AFID~Date2+DDBID, max,data=AFID)
  #View(DDBAggr2)
  #DDBAggr3<-aggregate(AFID~Date2+DDBID, min,data=AFID)
  #View(DDBAggr3)
  #mio <- merge(DDBAggr2,DDBAggr3, by=c("Date2","DDBID"))
  
  #mio$AFPerHora<-mio$AFID.x-mio$AFID.y
  
  #print(summary(AFID))
  oopt = ani.options(interval = 0.2, nmax = 10)
  ## use a loop to create images one by one
  #for (i in 1:ani.options("nmax")) {
  for (i in 9:20) {
    #plot(rnorm(30))
    
    #AFID$AFID<-AFID$AFID*2
    AFIDTemp<-subset(AFID,day(Date1) >i & day(Date1)<3+i )
    t1<-ggplot(AFIDTemp, aes(x = Date1,y=AFID))+  geom_point()  + facet_grid(DDBID  ~. )+ ggtitle(i)
    multiplot(t1, cols=1)
   # oopt = ani.options(interval = 1)
    ani.record()
  #  ani.pause() ## pause for a while (  'interval'  )
    
  }
  ## restore the options
  #ani.options(oopt)
  oopts = ani.options(interval = 0.5)
  #ani.replay()
  saveHTML(ani.replay(), img.name = "record_plot")
  
  
  
  #ggplot(AFID, aes(x = Date1,y=AFID))+  geom_point()  + facet_grid(DDBID  ~. )+ ggtitle("AFID pending Trend")
  
  
  
}






