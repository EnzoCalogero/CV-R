AUX_Read_Logs<-function(file='C:/Users/enzo7311/Desktop/AUXA/auxcopySourceDest.csv',SP='52',MAgent='all'){
  library(lubridate)
  library(data.table)
  library(bit64)
  library(dplyr)
  library(ggplot2)
  AUX<-fread(file, sep=",")
  
  if(SP!='all'){
    AUX<-subset(AUX,grepl(SP,AUX$Storage_Policy))
  }
  View(AUX)
  AUX$date1<-mdy_hms(AUX$date)
  AUX$date1<-floor_date(AUX$date1,"hour")
  AUX$hours<-hour(AUX$date1)
  AUX$Bytes<-as.numeric(AUX$Bytes/(1024*1024*1024))
  View(AUX)
 finale<-AUX %>% group_by(Storage_Policy,date1)%>%summarise(DataMoved=sum(Bytes), StreamsSource=n_distinct(source),StreamsTarget=n_distinct( target))
 View(finale)
 finaleMA<-AUX %>% group_by(MediaAgent,date1)%>%summarise(DataMoved=sum(Bytes), StreamsSource=n_distinct(source),StreamsTarget=n_distinct( target))
 
 FIN_HOURs<-AUX %>% group_by(Storage_Policy,hours)%>%summarise(DataMoved=sum(Bytes), StreamsSource=n_distinct(source),StreamsTarget=n_distinct( target))
 View(FIN_HOURs)
 
 finaleMA_Stream<-AUX %>% group_by(MediaAgent,date1)%>%summarise(DataMoved=sum(Bytes), StoragePolicy=n_distinct(Storage_Policy),StreamsSource=n_distinct(source),StreamsTarget=n_distinct( target))
 
 
 #MA_HOURs<-AUX %>% group_by(,hours)%>%summarise(DataMoved=sum(Bytes), StreamsSource=n_distinct(source),StreamsTarget=n_distinct( target))
 #View(FIN_HOURs)
 boxplot(StreamsTarget~hours, data = FIN_HOURs)
 boxplot(StreamsSource~hours, data = FIN_HOURs)
 boxplot(DataMoved~hours, data = FIN_HOURs)
 boxplot(DataMoved~MediaAgent, data = finaleMA)
 boxplot(StreamsSource~MediaAgent, data = finaleMA)
 p1<-ggplot(finale, aes(y=DataMoved,x=date1)) +  geom_point()  + geom_line(aes(colour=factor(Storage_Policy)))#+ stat_smooth()
 p2<-ggplot(finale,aes(x=date1,y=StreamsSource)) +  geom_point()+ geom_line(aes(colour=factor(Storage_Policy)))#+ stat_smooth()
 p3<-ggplot(finaleMA, aes(y=DataMoved,x=date1)) +  geom_point()  + geom_line(aes(colour=factor(MediaAgent)))
 p4<-ggplot(finaleMA_Stream, aes(y=StoragePolicy,x=date1)) +  geom_point()  + geom_line(aes(colour=factor(MediaAgent)))
 
 
 multiplot(p1, cols=1)
 multiplot(p2, cols=1)
 multiplot(p3, cols=1)
 multiplot(p4, cols=1)
}