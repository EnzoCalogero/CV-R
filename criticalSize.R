CriticalSize<-function(sidb=0,Mo=10,file='C:/temp/lon3/temp.csv'){
  library(ggplot2)
  library(doBy)  
  library(lubridate)
  library(igraph)
  library(dplyr)
  #library(data.table)

  AFID <- read.csv(file,sep=',')
  #AFID<-fread(file)
  View(AFID)
  
  
  AFID$DDBID<-paste(AFID$Host,"-ID-",AFID$DDBID)
  AFID$Date1<-mdy_hms(AFID$Date)
  
  ##############################################################
  ##       Time Filtering                                      #
  ##############################################################
  
  
  filterDate<-ymd_hms(now())-days(7)
  #print(filterDate)
  #print(now())
  #View(AFID)
  
  AFID<-AFID[(AFID$Date1 > filterDate) &(AFID$Date1<=ymd_hms(now())),]
  
  AFID$Date2<-floor_date(AFID$Date1, "hour")
  AFID$Date3<-floor_date(AFID$Date1, "day")
  
  # round_date
  AFID$Time.Hours<-(AFID$TimeSec/(60*60))
  AFID$timeHs<-as.integer(hour(AFID$Date1))
  AFID$timeDay<-as.integer(day(AFID$Date3))
  
  
  #View(AFID)
  AFID$days<-mday(AFID$Date1)
  ######
  # Temp Out
 # m1 <- ggplot(AFID, aes(x = Date1,y=AFID))+  geom_point() +geom_line() + facet_grid(DDBID  ~. )+ ggtitle("AFID pending Trend")
  
  
  AFID18<-subset(AFID, timeHs >=18 )
  
  #View(AFID18)
  RankALL<-aggregate(AFID~Date3+DDBID+Host, max,data=AFID)
  Rank18<-aggregate(AFID~Date3+DDBID+Host, max,data=AFID18)
  Rank18$AFID18<-Rank18$AFID
  
  #View(RankALL)
  #View(Rank18)
  #View(AFID18)
  # Temp Out
  m2 <- ggplot(AFID18, aes(x = Date1,y=AFID))+  geom_point() +geom_line() + facet_grid(DDBID  ~. )+ ggtitle("AFID pending Trend After 18")
  AFID21<-subset(AFID, timeHs >=21 )
  Rank21<-aggregate(AFID~Date3+DDBID+Host, max,data=AFID21)
  Rank21$AFID21<-Rank21$AFID
  RankALL$AFID<-NULL
  RankALL<-left_join(RankALL, Rank18, by = c("Date3","DDBID","Host"))
  RankALL<-left_join(RankALL, Rank21, by = c("Date3","DDBID","Host"))
  RankALL$AFID.y<-NULL
  RankALL$AFID.x<-NULL
  
  
  #View(AFID21)
  #View(Rank21)
  #View(RankALL)
  
  # Temp Out
  #m3 <- ggplot(AFID21, aes(x = Date1,y=AFID))+  geom_point() +geom_line() + facet_grid(DDBID  ~. )+ ggtitle("AFID pending Trend After 21")
  
  # Temp Out
#  multiplot(m1, cols=1)
  multiplot(m2, cols=1)
  #multiplot(m3, cols=1)

  #########################################################
  #
  # graphs part
  #
  ####################################################################
  #lab11<-read.csv("C:/temp2/graphlab.csv",sep=';')
  raw<-unique(as.character(RankALL$DDBID))
  #View(raw)
 
 gALL <- graph.empty()
 
 commCell<-as.character(substr(raw,1,5))
  commCell<-unique(commCell)
  #ids<-as.character(substr(raw,15,20))
  #print("id")
  #print(ids)
  
  
  for(CS in commCell){
    MAS=list()
    ids=list()
    for(r in raw){
      if(as.character(substr(r,1,5))==CS){
        MAS<-c(MAS,as.character(substr(r,6,8)))
        ids<-c(ids,as.character(substr(r,15,20)))
      }
    }
    MAS<-unique(MAS)
    ids<-unique(ids)    
    g <- graph.empty()+vertices(CS)
    g<-g+vertices(unique(MAS))
    g<-g+vertices(ids)
    
    for(r in raw){
      if(CS==substr(r,1,5)){
        g<-g+edges(c(substr(r,1,5),substr(r,6,8)))
        g<-g+edges(c(substr(r,6,8),substr(r,15,21)))
      }
    }
    
    V(g)$size=10 
    
    #V(g)[commCell]$shapes<-"rectangle"
    V(g)[CS]$color<-"blue"
    V(g)[CS]$size=25
    V(g)[CS]$label.color="black"
    for(ma in MAS){
      V(g)[ma]$color<-"lightblue"
      V(g)[ma]$size=15
      V(g)[ma]$label.color="black"
        } 
    
    V(g)$status<-0
    for(id in ids){
      #########################
     rackPartial<-subset(RankALL,id == as.character(substr(RankALL$DDBID,15,20)))
     
     V(g)[id]$color<-"green"
     V(g)[id]$size=10
     V(g)[id]$label.color="black"
     #V(g)$status<-0
     #print(rackPartial)
     count18<-sum(rackPartial$AFID18>0,na.rm=TRUE)
     count21<-sum(rackPartial$AFID21>0,na.rm=TRUE)
    # print(count18)
     #print(count21)
    
    
        if(count18>0 & count21==0){
           vertice<-paste("DDB-ID-",id,"-",count18,"/7 Days over 6pm")
           V(g)[id]$color<-"yellow"
        #   V(g)[id]$Size<-1
           g<-g+vertices(vertice)
          
           g<-g+edges(c(id,vertice))
        V(g)[vertice]$size=1
        V(g)[vertice]$label.color="red"
         }
    
    if(count21>0){
      vertice<-paste("DDB-ID-",id,"-",count18,"/7 Days over 9pm")
      V(g)[id]$color<-"red"
      V(g)[id]$status<-1
      #   V(g)[id]$Size<-1
      g<-g+vertices(vertice)
      
      g<-g+edges(c(id,vertice))
      V(g)[vertice]$size=1
      V(g)[vertice]$label.color="red"
      ###Code Added
      a<-ends(g,incident(g,V(g)[id]))
      print("neigh")
      print(get.vertex.attribute(g, "color", index=V(g)[a[[2]]]))
      print(get.vertex.attribute(g, "status", index=V(g)[a[[2]]]))
      
      if(V(g)[a[[2]]]$status>0){
        V(g)[a[[2]]]$color<-"red"
      }
      
      V(g)[a[[2]]]$status<-1
      ####Code Added
        }
     # View(rackPartial)
      
      #######################
    }
    gALL <- gALL +g
    plot.igraph(g,edge.curved=FALSE, main=paste ("DDB Critical Size Analysis for ",CS),layout=layout.fruchterman.reingold,edge.arrow.size=0.1,edge.arrow.width=0.1)
  }
 plot.igraph(gALL,edge.curved=FALSE, main=paste ("DDB Critical Size Analysis for Global"),layout=layout.fruchterman.reingold,edge.arrow.size=0.1,edge.arrow.width=0.1)
 
 #write.csv(RankALL, file = "C:/temp2/graphlab.csv",row.names=TRUE)
 # return(RankALL)
}


CriticalSizeTrend<-function(sidb=0,Mo=10,file='C:/temp/lon3/temp.csv'){
  library(ggplot2)
  #library(doBy)  
  library(lubridate)
  #library(igraph)
  library(dplyr)
  #library(data.table)
  
  AFID <- read.csv(file,sep=',')
  #AFID<-fread(file)
  # View(AFID)
  
  
  AFID$DDBID<-paste(AFID$Host,"-ID-",AFID$DDBID)
  AFID$Date1<-mdy_hms(AFID$Date)
  
  filterDate<-ymd_hms(now())-days(15)
  print(filterDate)
  #View(AFID)
  AFID<-AFID[AFID$Date1 > filterDate,]
  AFID<-AFID[AFID$Date1 < ymd_hms(now()),]
  
  AFID$Date2<-floor_date(AFID$Date1, "hour")
  AFID$Date3<-floor_date(AFID$Date1, "day")
  # round_date
  AFID$Time.Hours<-(AFID$TimeSec/(60*60))
  AFID$timeHs<-as.integer(hour(AFID$Date1))
  AFID$timeDay<-as.integer(day(AFID$Date3))
  
  
  #View(AFID)
  AFID$days<-mday(AFID$Date1)
  ######

  RankALL<-aggregate(timeHs~Date3+DDBID+Host, max,data=AFID)
  RankALL$CS<-as.character(substr(RankALL$DDBID,1,5))
  View(RankALL)

  
  
  
  m <- ggplot(RankALL, aes(x = Date3,y=timeHs))+  geom_point() +geom_line(aes(colour = DDBID)) + facet_grid(CS~.)+ ggtitle("AFID TREND OVER TIME2")
  # Temp Out
  multiplot(m, cols=1)
  
  CSs_<-unique(RankALL$CS)
  for(cs in CSs_)
  {
   tempRank<- subset(RankALL,RankALL$CS==cs)
   mt <- ggplot(tempRank, aes(x = Date3,y=timeHs))+  geom_point() +geom_line(aes(colour = DDBID)) + ggtitle(cs)
   # Temp Out
   multiplot(mt, cols=1)
    
    
  }
  
}

