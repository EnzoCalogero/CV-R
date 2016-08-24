AUXQueryDetails<-function(day=0,file='C:/Users/enzo7311/Desktop/cs404/q.csv'){
  library(ggplot2)
  library(doBy)  
  library(lubridate)
  #DDB<-DedupRead(file,sidb,Mo)
  AUXSPOLICY <- read.csv(file,sep=",",header=FALSE)
  
  AA<-data.frame(amount=AUXSPOLICY$V3)
 # View(AA)
  AA<-as.data.frame(t(AA))
#  bb<-as.data.frame(bb)
   names(AA)<-AUXSPOLICY[,1]
AA$Day<-2  
  View(AA)

AUXSPOLICY <- read.csv(file,sep=",",header=FALSE)

AA1<-data.frame(amount=AUXSPOLICY$V3)
# View(AA)
AA1<-as.data.frame(t(AA1))
#  bb<-as.data.frame(bb)
names(AA1)<-AUXSPOLICY[,1]
AA1$Day<-1

View(AA1)
BB<-union(AA,AA1)

View(BB)
}
  