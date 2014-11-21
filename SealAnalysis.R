###################
##Sealing Analysis#
###################
 

SealRead<-function(file='C:/Users/enzo7311/Desktop/Dati/a.csv'){
  library(ggplot2)
  library(gcookbook)
  library(lubridate) #Date management
    SEALDDB <- read.csv(file)
    newDDB<-DedupRead(file='C:/Users/enzo7311/Desktop/Dati/cs401ddb1107.csv',sidb=32,Mo=c(10))
  
  #SEALDDB$As.Of<-dmy_hm(SEALDDB$As.Of)
  SEALDDB$day<-substr(SEALDDB$As.Of,4,5)
  SEALDDB$Month<-substr(SEALDDB$As.Of,1,2)
  SEALDDB$year<-substr(SEALDDB$As.Of,7,10)
#  View(SEALDDB)
 # View(newDDB)
  
  p1<-ggplot(SEALDDB,aes(day )) + geom_point(aes(y=log(Number.of.Secondary.Blocks),colour=2))+ geom_point(aes(y=Number.of.Secondary.Blocks,colour=2)) + geom_point(aes(y=Number.of.Unique.Blocks,colour=3))+ ggtitle("Secondary & Primary Record for a Sealed DDB")+ xlab("Day of the Month") +ylab("Primary & Secondary Records")
  p2<-ggplot(newDDB,aes(day )) + geom_point(aes(y=SecondaryEntries,colour=2)) + geom_point(aes(y=PrimaryEntries,colour=3))+ ggtitle("Secondary & Primary Record for a New DDB")+ xlab("Day of the Month") +ylab("Primary & Secondary Records")
  p11<-ggplot(SEALDDB,aes(day )) + geom_point(aes(y=log(Number.of.Secondary.Blocks),colour=2))

  agg1<-aggregate(SEALDDB[ ,2:3], list(SEALDDB$day) ,data=SEALDDB,mean)
  AggNew<-aggregate(newDDB[ ,6:7], list(newDDB$day) ,data=newDDB,mean)
  maxvalue<-agg1$Number.of.Unique.Blocks[1]
  print(maxvalue)
  agg1$Group.1<-as.numeric(agg1$Group.1)
  AggNew$Group.1<-as.numeric(AggNew$Group.1)
  agg1$Group.1<-as.integer(agg1$Group.1)
  AggNew$Group.1<-as.integer(AggNew$Group.1)
  
  #View(agg1)
  #View(AggNew)
  
  Final<- merge(agg1,AggNew,"Group.1")
  Final$SOMMASEC<-Final$Number.of.Secondary.Blocks+Final$SecondaryEntries
  Final$SOMMAPrim<-Final$Number.of.Unique.Blocks+Final$PrimaryEntries
  Final$IndexSEC<-Final$SecondaryEntries/(Final$Number.of.Secondary.Blocks+Final$SecondaryEntries)
  Final$IndexPrim<-Final$PrimaryEntries/(Final$Number.of.Unique.Blocks+Final$PrimaryEntries)
  Final$Ratio<-Final$SOMMASEC/Final$SOMMAPrim
  #View(Final) 
  
  p3<-ggplot(Final,aes(Group.1 ))+ggtitle("Secondary & Primary Record Aggregate of the Sealed and New DDB")+ xlab("Day of the Month") +ylab("Primary & Secondary Records")+geom_abline(intercept =maxvalue,slope=0, colour=1 ) +geom_abline(intercept =2*maxvalue,slope=0 ,colour=2)+geom_point(aes(y=Number.of.Unique.Blocks,colour='yellow'))+geom_point(aes(y=PrimaryEntries,colour='blue'))+ geom_point(aes(y=SOMMAPrim, colour='green')) + geom_point(aes(y=SOMMASEC,colour='black'))

  p4<-ggplot(Final,aes(Group.1 ))+geom_point(aes(y=Ratio,colour=3)) +geom_point(aes(y=IndexSEC,colour=2))+geom_point(aes(y=IndexPrim))
  
  
  agg1$ratio<-agg1[,3]/agg1[,2]
  Final$SOMMAPrim<-ts(Final$SOMMAPrim)
  #agg1$Number.of.Secondary.Blocks<-ts(agg1$Number.of.Secondary.Blocks)

  #agg2<-names("X1")
  #agg2$X1<-ts(lag(agg1[,2],1)-agg1[,2])
  
  DUNIQU<-ts((lag(Final$SOMMAPrim,1)-Final$SOMMAPrim)/10^6)
  DDUnique<-ts((lag(DUNIQU,1)-DUNIQU))
  View(DUNIQU)
  #View(prima)
 #plot.ts(DUNIQU)
 #View(DDUnique)
 #View(prima)
 #plot.ts(DDUnique)
 
  
  #
#multiplot(p1,p2,p3,p4, cols=2)
# multiplot(p1,p11, cols=2)
multiplot(p3, cols=2)
}

coefDDB<-function(file='C:/Users/enzo7311/Desktop/sealing/coeff2.csv'){
  coef <- read.csv(file)
  coef$DDBsize.GB<-(coef$DDBsize.GB*1024*1024)
  coef$library.TB<-(coef$library.TB*1024*1024*1024)
  # coef$primary<-(coef$primary*128)
  View(coef)
  fit <-lm( DDBsize.GB~primary+secondary-1,data=coef)#+secondary
  print(coefficients(fit))
  fitted(fit)
  #coefficients(fit) # model coefficients
  #confint(fit, level=0.95) # CIs for model parameters
  fitted(fit) # predicted values
  residuals(fit) # residuals
  #anova(fit) # anova table
  #vcov(fit) # covariance matrix for model parameters
  #influence(fit) # regression diagnostics 
  plot(fit)
}

#######################
###Cofficient analysis
#######################
coef<-function(file='C:/Users/enzo7311/Desktop/sealing/coeff2.csv'){
  coef <- read.csv(file)
  coef$DDBsize.GB<-(coef$DDBsize.GB*1024*1024)
  coef$library.TB<-(coef$library.TB*1024*1024*1024)
  # coef$primary<-(coef$primary*128)
 View(coef)
 fit <-lm( library.TB~primary+secondary-1,data=coef)#+secondary
 print(coefficients(fit))
 fitted(fit)
 #coefficients(fit) # model coefficients
 #confint(fit, level=0.95) # CIs for model parameters
 fitted(fit) # predicted values
 residuals(fit) # residuals
 #anova(fit) # anova table
 #vcov(fit) # covariance matrix for model parameters
 #influence(fit) # regression diagnostics 
 plot(fit)
}


fittingGrowth<-function(file='C:/Users/enzo7311/Desktop/Dati/a.csv'){
  newDDB<-DedupRead(file='C:/Users/enzo7311/Desktop/Dati/cs401ddb1107.csv',sidb=32,Mo=c(10))
  newDDB$ModifiedTime<-(newDDB$ModifiedTime-1412486005)/(60*60)
  
  SEALDDB <- read.csv(file)
  SEALDDB$day<-substr(SEALDDB$As.Of,4,5)
  SEALDDB$Month<-substr(SEALDDB$As.Of,1,2)
  SEALDDB$year<-substr(SEALDDB$As.Of,7,10)
 SEALDDB<-aggregate(SEALDDB[ ,2:3], list(SEALDDB$day) ,data=SEALDDB,mean)
  View(newDDB)
  
  
  
  fit <-lm( log(Number.of.Unique.Blocks)~Group.1-1,data=SEALDDB)#+secondary
  print(coefficients(fit))
  fitted(fit)
  #coefficients(fit) # model coefficients
  #confint(fit, level=0.95) # CIs for model parameters
  fitted(fit) # predicted values
  residuals(fit) # residuals
  #anova(fit) # anova table
  #vcov(fit) # covariance matrix for model parameters
  #influence(fit) # regression diagnostics 
  plot(fit)
}
