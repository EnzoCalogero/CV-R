library(ggplot2)
library(lubridate) 
library(dplyr)
library(googleVis)
AUX<-read.csv("C:/dati/AUX_Analisis/globalOrd1.csv",sep=',')
AUX$Date<-ymd_hms(AUX$Date)
AUX$Dateh<-floor_date(AUX$Date, "hour")
AUX$Dated<-floor_date(AUX$Date, "day")
AUX$timeHs<-as.integer(hour(AUX$Date))
AUX$timeDay<-as.integer(day(AUX$Date))
AUX$Storage.Policy<-substr(AUX$Storage.Policy,1,36)
AUX$Storage.Policy<-paste(AUX$Storage.Policy,"-",AUX$Copy)


# AUX<-subset(AUX,!(AUX$CS == "CS498"))
CurrentTIME<-AUX  %>% summarise(CurrentTIME=max(Date))
#View(CurrentTIME)

# filterDate<-ymd_hms("2015-12-04 09:29:04 GMT")-days(1)
#  AUX0<-AUX[day(ymd_hms("2015-12-04 09:29:04 GMT")) == day(AUX$Date),]


filterDateDown<-CurrentTIME$CurrentTIME-hours(3)

AUX0<-subset(AUX,(AUX$Date > filterDateDown))
#View(AUX0)




RankALL<-aggregate(Residual.Size~Storage.Policy+CS,mean,data=AUX0)



RankCS<-aggregate(Residual.Size~+CS,sum,data=RankALL)
#View(RankCS)
RankCS$Storage.Policy<-RankCS$CS
#RankALL$timeDay<-NULL

RankCS$CS<-"Ord1"
#RankCS$timeDay<-NULL
#View(RankCS)
########################################
#           filtering area             #
########################################


RankALL<-RankALL[(RankALL$Residual.Size > 3),  ]

RankALL <- rbind( RankALL, RankCS)
#################
##Temp Adjustment
#################


#View(RankALL)

#############################################################
###                     1 day                              ##
#############################################################
filterDateDown<-CurrentTIME$CurrentTIME-days(1)-hours(3)
filterDateUP<-CurrentTIME$CurrentTIME-days(1)+hours(3)


AUX1<-subset(AUX,(AUX$Date<filterDateUP) & (AUX$Date > filterDateDown))
#View(AUX1)
RankALL1<-aggregate(Residual.Size~Storage.Policy+CS,mean,data=AUX1)
####filtering out what not in the current time...
RankALL1<-RankALL1[(RankALL1$Storage.Policy %in% RankALL$Storage.Policy),  ]


RankALL1$CS<-RankALL1$Storage.Policy
RankALL1$Storage.Policy<-paste(RankALL1$Storage.Policy,"-1-DaY")


#  View(RankCS1)
#View( RankALL1)
RankALL1 <- rbind( RankALL1, RankALL)

#AUXPlot1<-gvisSankey(RankALL1, from='Storage.Policy', to='CS', weight='Residual.Size',
#                   options = list(height="800px",width="1600px",title="AUX Copy Resiadual in TB"))
#plot(AUXPlot1) 

#############################################################
###                     7 day                              ##
#############################################################
#filterDate<-ymd_hms("2015-12-04 09:29:04 GMT")-days(7)
#AUX7<-AUX[day(ymd_hms("2015-11-28 09:29:04 GMT")) == day(AUX$Date),]

filterDateDown<-CurrentTIME$CurrentTIME-days(7)-hours(3)
filterDateUP<-CurrentTIME$CurrentTIME-days(7)+hours(3)


AUX7<-subset(AUX,(AUX$Date<filterDateUP) & (AUX$Date > filterDateDown))
#View(AUX7)



RankALL7<-aggregate(Residual.Size~Storage.Policy+CS,mean,data=AUX7)

##############################################################
###      Fixing lack of entry                               ##
##############################################################

# for(a in RankALL7$Storage.Policy) {
#    print(a)

# }
#print("Verifica")
#print(RankALL7[!(RankALL7$Storage.Policy %in% RankALL1$Storage.Policy),  ] )
RankALL7<-RankALL7[(RankALL7$Storage.Policy %in% RankALL1$Storage.Policy),  ]

#  View(missingEntry)
#  missingEntry$CS
# missingEntry$Storage.Policy
#missingEntry$Residual.Size<-0

#  View(RankCS1)
#  View( RankALL1)
#  RankALL1 <- rbind( RankALL1,  missingEntry)
#  missingEntry$CS<-missingEntry$Storage.Policy
#  missingEntry$Storage.Policy<-paste(missingEntry$Storage.Policy,"-1-DaY")
#  missingEntry$Residual.Size<-0  


RankALL7$CS<-paste(RankALL7$Storage.Policy,"-1-DaY")
RankALL7$Storage.Policy<-paste(RankALL7$Storage.Policy,"-7-DaY")


#  View(RankCS1)
#View( RankALL7)



RankALL7 <- rbind(RankALL1, RankALL7)

RankALL7 <- RankALL7[order(RankALL7$CS),] 


##############################################################
###           Final Plot                                    ##
##############################################################


AUXPlot7<-gvisSankey(RankALL7, from='Storage.Policy', to='CS', weight='Residual.Size',
                     options = list(height="600px",width="1200px",title="AUX Copy Resiadual in TB"))
#plot(AUXPlot7) 

print(AUXPlot7,'chart',file="c:/temp/SandkeyOrd1.html")