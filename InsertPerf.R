#CS903_28_11.csv
#C:/dati/sealing/sidengine/CS401_22_10.csv
prune_Analysis<-function(sidb=0,Mo=10,file='C:/dati/sealing/sidengine/CS401_22_10.csv'){
  library(ggplot2)
  library(doBy)  
  library(lubridate)
  #DDB<-DedupRead(file,sidb,Mo)
  AFID <- read.csv(file)
  #print(file)
  print(sidb)
#  View(AFID)
# return(AFID)
  ###Basic
  
  AFID$Date1<-mdy_hms(AFID$Date)
  AFID$Date2<-floor_date(AFID$Date1, "hour")
 # round_date
  AFID$Time.Hours<-(AFID$TimeSec/(60*60))
  AFID$timeHs<-as.integer(hour(AFID$Date1))


####DDB filter  on the days
# AFID<-subset(AFID,DDBID==sidb)
#AFID<-subset(AFID,month(Date1) ==1)# |day(Date1)<24 )




#AFID<-subset(AFID,day(Date1) >19  | day(Date1)<3 )
# AFID<-subset(AFID,year(Date1)==2014)
 ####Time Filter
 #AFID<-subset(AFID,(month(Date1)==11)&(day(Date1)>15)|((month(Date1)==12)))
#AFID<-subset(AFID,(((month(Date1)==12))))
 #AFID<-subset(AFID,day(Date1)>20)
 View(AFID)
 #AUXDay<-aggregate(DataWritten~day, sum,data=AUX)
 AFID17<-subset(AFID, timeHs ==17 )
 #View(AFID17)
 #days<-c("2014-11-13 18:00:00","2014-11-12 18:00:00","2014-11-14 18:00:00")
 m17 <- ggplot(AFID17, aes(x = Date1,y=AFID))+ geom_point()  + facet_grid(DDBID  ~. )+ ggtitle("AFID Pending at 17 low impact")
 AFID$days<-mday(AFID$Date1)
 DDBAggr2<-aggregate(AFID~Date2+DDBID, max,data=AFID)
 #View(DDBAggr2)
 DDBAggr3<-aggregate(AFID~Date2+DDBID, min,data=AFID)
 #View(DDBAggr3)
 mio <- merge(DDBAggr2,DDBAggr3, by=c("Date2","DDBID"))

 mio$AFPerHora<-mio$AFID.x-mio$AFID.y
mio$AFPerHora[mio$AFPerHora>200]<-0
 #View(mio) 
 m23 <- ggplot(AFID, aes(x = Date1,y=AFID))+  geom_point() +geom_line() + facet_grid(DDBID  ~. )+ ggtitle("AFID pending Trend")
 
 m22 <- ggplot(mio, aes(x = Date2,y=AFPerHora))+  geom_point()  + facet_grid(DDBID  ~. )+ ggtitle("AFID pruned Per hours")
 m21 <- ggplot(mio, aes(x = Date2,y=AFID.x)) + geom_point()  + facet_grid(DDBID  ~. )+ ggtitle("D(AFID)/Dt per hours")
 
 #m21 <- ggplot(DDBAggr2, aes(x = Date2,y=AFID))+  geom_point()  + facet_grid(DDBID  ~. )+ ggtitle("AFID Pending Per hour")
 
 
 AFID18<-subset(AFID, timeHs ==18 )
 View(AFID18)
 
 m18 <- ggplot(AFID18, aes(x = Date1,y=AFID))+  geom_point()  + facet_grid(DDBID  ~. )+ ggtitle("AFID Pending at 18 low impact")
 
 AFID21<-subset(AFID, timeHs ==21 )
 #View(AFID21)
 
 m2 <- ggplot(AFID21, aes(x = Date1,y=AFID))+  geom_point()  + facet_grid(DDBID  ~. )+ ggtitle("AFID Pending at 21 medium impact")
 
 AFID23<-subset(AFID, timeHs ==23 )
 #View(AFID23)
 
 m3 <- ggplot(AFID23, aes(x = Date1,y=AFID))+  geom_point()  + facet_grid(DDBID  ~. )+ ggtitle("AFID Pending at 23 High impact")
 
 
 AFID00<-subset(AFID, timeHs ==0 )
 #View(AFID00)
 
 m4 <- ggplot(AFID00, aes(x = Date1,y=AFID))+  geom_point()  + facet_grid(DDBID  ~. )+ ggtitle("AFID Pending at 24!!!!!!!!!!!!!!!!")
 
#Derivate Analysis

AFID15<-subset(AFID, timeHs ==15)
AFID18<-subset(AFID, timeHs ==18)
#View(DDBAggr2)
DDBAggr2<-aggregate(AFID~days+DDBID, max,data=AFID15)
DDBAggr3<-aggregate(AFID~days+DDBID, max,data=AFID18)
#View(DDBAggr3)
Deltas <- merge(DDBAggr2,DDBAggr3, by=c("days","DDBID"))


AFID21<-subset(AFID, timeHs ==21 )

DDBAggr4<-aggregate(AFID~days+DDBID, max,data=AFID21)
#View(DDBAggr3)
Deltas <- merge(Deltas,DDBAggr4, by=c("days","DDBID"))

Deltas$Deltas1<-Deltas$AFID.x-Deltas$AFID.y
Deltas$Deltas2<-Deltas$AFID.y-Deltas$AFID


View(Deltas)




multiplot(m21,m22, cols=3)
multiplot(m23, cols=3)
multiplot(m18, cols=3)



#multiplot(m3, cols=3)
multiplot(m17,m2,m3,m4, cols=3)
#return(AFID)
  }

