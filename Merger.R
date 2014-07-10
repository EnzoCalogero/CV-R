Merger<-function(sp="all",sidb=0,Mo=6,fileDDP='C:/Users/enzo7311/Desktop/Dati/cs401ddb0907.csv',fileJOB='C:/Users/enzo7311/Desktop/Dati/cs401jobs0907.csv',Hour=c(18,19,20,21,22)){
  library(ggplot2)
  library(gcookbook)
  library(plyr)
  
  DDB<-DedupRead(fileDDP,sidb,Mo)
  jobs<-CleanDBData(fileJOB,Mo=6)

  print(sidb)
  print(sp)
  
  DDB<-subset(DDB,DDB$NumOfConnections > 0)
  DDB<-subset(DDB,DDB$AvgQITime > 0)
  DDB<-subset(DDB,DDB$HistoryType == 0)
  
  View(DDB)
  
  if(Hour!=99){
    DDB<-subset(DDB,DDB$hour %in% Hour)
    jobs<-subset(jobs,jobs$hour %in% Hour)
  }
  
  
  
###  Example
#### carico a livello di CS
### duration
job1<-aggregate(durationunixsec ~startsimply , mean,data=jobs)
#### data
job2<-aggregate(numbytescomp~startsimply, mean,data=jobs)
job3<-aggregate(numobjects~startsimply, mean,data=jobs)
job_ <- merge(job1,job2, by.x ="startsimply", by.y = "startsimply")
job_ <- merge(job_,job3, by.x ="startsimply", by.y = "startsimply")


####### numobjects##############

DDB1<-aggregate(AvgQITime~startsimply, mean,data=DDB)
DDB2<-aggregate(NumOfConnections~startsimply, mean,data=DDB)
DDB3<-aggregate(ZeroRefCount~startsimply, mean,data=DDB)

DDB_ <- merge(DDB1,DDB2, by.x ="startsimply", by.y = "startsimply")
DDB_ <- merge(DDB_,DDB3, by.x ="startsimply", by.y = "startsimply")

View(job_)
View(DDB_)


Mia<-merge(job1,DDB1,"startsimply")
Mia<-merge(Mia,job2,"startsimply")
Mia<-merge(Mia,job3,"startsimply")
Mia<-merge(Mia,DDB2,"startsimply")
Mia<-merge(Mia,DDB3,"startsimply")
Mia$trupt<-Mia$numbytescomp/Mia$durationunixsec

Mia$truptCALcolato<-1/(1+Mia$AvgQITime)#(128*1/(1+Mia$AvgQITime))##mg/sec 
Mia$ZeroRefCount<-Mia$ZeroRefCount+1
View(Mia)
print("Cor log zero ref vs log avgtime")
print(cor(log10(Mia$ZeroRefCount),log10(Mia$AvgQITime)))

print("Cor zero ref vs  avgtime")
print(cor((Mia$ZeroRefCount),(Mia$AvgQITime)))

print("Correlazione truput calcolato vs reale")
print(cor(Mia$truptCALcolato,Mia$trupt,use="complete.obs"))

print("Log Correlazione truput calcolato vs reale")
print(cor(log10(Mia$truptCALcolato),log10(Mia$trupt),use="complete.obs"))





# print(Mia)
#print(lm(durationunixsec~.,data=Mia))
p1<-ggplot(Mia, aes(y=numbytescomp,x=startsimply)) +  geom_point()  
p2<-ggplot(Mia, aes(y=durationunixsec,x=startsimply)) +  geom_point()  
#p3<-ggplot(Mia, aes(y=trougput,x=startsimply)) +  geom_point()  + geom_line()
p4<-ggplot(Mia, aes(y=numbytescomp,x=startsimply))+  geom_point()
p5<-ggplot(Mia, aes(y=numobjects,x=startsimply))+  geom_point()
p6<-ggplot(Mia, aes(y=numobjects,x=startsimply))+  geom_point()

p7<-ggplot(Mia, aes(y=AvgQITime,x=startsimply)) +  geom_point()  
p8<-ggplot(Mia, aes(y=NumOfConnections,x=startsimply)) +  geom_point()  
p9<-ggplot(Mia, aes(y=ZeroRefCount,x=startsimply)) +  geom_point()
p10<-ggplot(Mia, aes(y=log10(ZeroRefCount),x=log10(AvgQITime))) +  geom_point()
p11<-ggplot(Mia, aes(y=log(truptCALcolato),x=log(trupt))) +  geom_point()  
p12<-ggplot(Mia, aes(y=(truptCALcolato),x=(trupt))) +  geom_point()  
#plot(data=Mia, .~startsimply)
multiplot(p1, p2,p5,p7,p8,p9,p10,p11,p12, cols=2) 

return(Mia)

print(mean(DDB$AvgQITime))
  print(log10(mean(DDB$AvgQITime)))
  boxplot(log10(AvgQITime)~hour,data=DDB, main="log10(AvgQITime) By Hours",              xlab="Hour", ylab="log10(AvgQITime)") 
  abline(h=log10(mean(DDB$AvgQITime)),col = "red")
  abline(h=log10(median(DDB$AvgQITime)),col = "blue")
  
}
#######################################
#########################################
####################################

MergerZEROvQI<-function(sp="all",sidb=0,Mo=6,fileDDP='C:/Users/enzo7311/Desktop/Dati/cs499ddb2006.csv',fileJOB='C:/Users/enzo7311/Desktop/Dati/cs499jobs2306.csv',Hour=99){
  library(ggplot2)
  library(gcookbook)
  library(plyr)
  
  miaZvsIQ<-Merger(sp="all",sidb=0,Mo=6,fileDDP='C:/Users/enzo7311/Desktop/Dati/cs499ddb2006.csv',fileJOB='C:/Users/enzo7311/Desktop/Dati/cs499jobs2306.csv',Hour=c(18,19,20,21,22))
  
  
View( miaZvsIQ)
p1<-ggplot(miaZvsIQ, aes(y=log10(ZeroRefCount),x=log10(AvgQITime))) +  geom_point()
p2<-ggplot(miaZvsIQ, aes(y=(ZeroRefCount),x=(AvgQITime))) +  geom_point()

multiplot(p1, p2, cols=2) 
# Poisson Regression
# where count is a count and 
# x1-x3 are continuous predictors 
fit <- glm(AvgQITime ~ ZeroRefCount, data=miaZvsIQ, family=poisson())
summary(fit)# display results 

fit2 <- glm(log(AvgQITime) ~ log(ZeroRefCount), data=miaZvsIQ, family=poisson())
summary(fit2)# display results 

# Creating a Graph
attach(miaZvsIQ)
plot(log(AvgQITime), log(ZeroRefCount)) 
#abcurve(fit2)
title("Regression")

glm2 <- glm(log(miaZvsIQ$ZeroRefCount)~log(miaZvsIQ$AvgQITime),family="poisson",data=miaZvsIQ)
plot(log(miaZvsIQ$AvgQITime),log(miaZvsIQ$ZeroRefCount),col="red",pch=19)
points(log(miaZvsIQ$AvgQITime),glm2$fitted,col="blue",pch=19,xlab="Date",ylab="Fitted Counts")
#points(miaZvsIQ$ZeroRefCount,miaZvsIQ$AvgQITime,col="red",pch=19)


}


mergertru<-function(sp="all",sidb=0,Mo=6,fileDDP='C:/Users/enzo7311/Desktop/Dati/cs499ddb2006.csv',fileJOB='C:/Users/enzo7311/Desktop/Dati/cs499jobs2306.csv',Hour=99){
  library(ggplot2)
  library(gcookbook)
  library(plyr)
  
  miaZvsIQ<-Merger(sp="all",sidb=0,Mo=6,fileDDP='C:/Users/enzo7311/Desktop/Dati/cs499ddb2006.csv',fileJOB='C:/Users/enzo7311/Desktop/Dati/cs499jobs2306.csv',Hour=c(18,19,20,21,22))
  
  
  View( miaZvsIQ)
  #p1<-ggplot(miaZvsIQ, aes(y=log10(ZeroRefCount),x=log10(AvgQITime))) +  geom_point()
  #p2<-ggplot(miaZvsIQ, aes(y=(ZeroRefCount),x=(AvgQITime))) +  geom_point()
  
  #multiplot(p1, p2, cols=2) 
  # Poisson Regression
  # where count is a count and 
  # x1-x3 are continuous predictors 
  fit <- glm(trupt ~ ZeroRefCount+AvgQITime+numbytescomp+numobjects, data=miaZvsIQ, family=poisson())
  print("ecco il grande FItting")
  print(summary(fit))# display results 
  
  fit1 <- glm(trupt ~ ZeroRefCount+AvgQITime+numbytescomp+numobjects -1, data=miaZvsIQ, family=poisson())
  print("ecco il grande FItting -1")
  print(summary(fit1))# display results 
  
  print("ecco il grande FItting con il log")
  fit2 <- glm(trupt ~ log(ZeroRefCount)+log(AvgQITime)+log(numbytescomp)+log(numobjects), data=miaZvsIQ, family=poisson())
  print("ecco il grande FItting -1")
  print(summary(fit2))# display results 
  #fit2 <- glm(log(AvgQITime) ~ log(ZeroRefCount), data=miaZvsIQ, family=poisson())
  #summary(fit2)# display results 
  
  # Creating a Graph
  #attach(miaZvsIQ)
  #plot(log(AvgQITime), log(ZeroRefCount)) 
  #abcurve(fit2)
  #title("Regression")
  fitfinale <- glm(trupt ~ ZeroRefCount+AvgQITime, data=miaZvsIQ, family=poisson())
  print("ecco il FItting Finale")
  print(summary(fitfinale))# display results   
  
  
  fitfinale2 <- glm(trupt ~ log(ZeroRefCount)+AvgQITime, data=miaZvsIQ, family=poisson())
  print("ecco il FItting Finale")
  print(summary(fitfinale))# display results   
  
  fitfinale3 <- glm(trupt ~ log(ZeroRefCount)+AvgQITime -1, data=miaZvsIQ, family=poisson())
  print("ecco il FItting Finale")
  print(summary(fitfinale))# display results   
  
  #glm2 <- glm(log(miaZvsIQ$ZeroRefCount)~log(miaZvsIQ$AvgQITime),family="poisson",data=miaZvsIQ)
  plot(miaZvsIQ$trupt,fit$fitted,col="red",pch=19,xlab="Sperimental",ylab="calculated")
  points(miaZvsIQ$trupt,fitfinale$fitted,col="blue",pch=19)
  points(miaZvsIQ$trupt,fit2$fitted,col="green",pch=19)
  points(miaZvsIQ$trupt,fitfinale2$fitted,col="yellow",pch=19)
  points(miaZvsIQ$trupt,fitfinale3$fitted,col="orange",pch=19)
  #points(miaZvsIQ$ZeroRefCount,miaZvsIQ$AvgQITime,col="red",pch=19)
  abline(a=0,b=1)
  
  
}
