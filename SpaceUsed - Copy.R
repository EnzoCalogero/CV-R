#################################################################################################
Space_Used<-function(m=m){ 
  library(ggplot2)
  library(lubridate) 
  library(dplyr)
  library(googleVis)
  
  m<-subset(m,m$Space.Occupied.On.Disk>0)
  Tensor1<-data.frame(CS=m$CS,StoragePolicy=m$ï..Storage.Policy,DiskSpace=m$Space.Occupied.On.Disk)
  #Tensor1$DiskSpace<-(Tensor1$DiskSpace/(1024^8))
  
  Tensor2<-aggregate(DiskSpace~CS,sum,data=Tensor1)
  Tensor2$StoragePolicy<-Tensor2$CS
  Tensor2$CS<-"Commcells"
  #Tensor2$DiskSpace<-(Tensor2$DiskSpace/(1024^8))
  
  Tensor <- rbind( Tensor1, Tensor2)
  
  Tensor3<- data.frame(CS=m$ï..Storage.Policy,StoragePolicy=m$Library,DiskSpace=m$Space.Occupied.On.Disk)
  #Tensor1$DiskSpace<-(Tensor1$DiskSpace/(1024^8))
  Tensor <- rbind( Tensor, Tensor3)
  
  Tensor4<-aggregate(DiskSpace~StoragePolicy,sum,data=Tensor3)
  Tensor4$CS<-Tensor4$StoragePolicy
  #Tensor4$Library<-NULL
  Tensor4$StoragePolicy<-"Library"
  #T#ensor4$DiskSpace<-Tensor4$DiskSpace/(1024^8)
  #View(Tensor4)
  Tensor <- rbind( Tensor, Tensor4)
  
  return(Tensor)
  
 
}

rollingCS<-function(){
  library(ggplot2)
  library(lubridate) 
  library(dplyr)
  library(googleVis)
  ALL_<-NULL
  
Alllabel<-c("CS301","CS302")
for (label in Alllabel){ 
CopyPro<-read.csv(paste("C:/dati/RapSpaceUsed/",label,"CopyProperties.csv",sep=""), stringsAsFactors=FALSE)
DedupStoreInfo <- read.csv(paste("C:/dati/RapSpaceUsed/",label,"DedupStoreInfo.csv",sep=""), stringsAsFactors=FALSE)
m=merge(CopyPro,DedupStoreInfo,by=c("ï..Storage.Policy","MediaAgent"))
m<-subset(m,m$Is.Default.Data.path == "Yes")

m$CS<-label
View(m)

Tensor<-Space_Used(m)
ALL_ <- rbind( ALL_, Tensor)


AUXPlot7<-gvisSankey(Tensor, from='CS', to='StoragePolicy', weight='DiskSpace',
                     options = list(height="600px",width="1200px",title="Space consumed by STorage policy"))

plot(AUXPlot7)
AUXPlot7<-gvisSankey(Tensor, from='CS', to='StoragePolicy', weight='DiskSpace',
                     options = list(height="600px",width="1200px",title="Space consumed by STorage policy"))


}

AUXPlot<-gvisSankey(ALL_, from='CS', to='StoragePolicy', weight='DiskSpace',
                     options = list(height="600px",width="1200px",title="Space consumed by STorage policy"))
plot(AUXPlot)
}