## This function is for create a head map of teh ddb insert time 
## For each hour of a given week
##
headMAp<-function(sidb=0,Mo=c(10,11),file='C:/Users/enzo7311/Desktop/Dati/cs403ddb11_28.csv',Days=c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),hour=0){
  library(ggplot2)
  library(heatmap.plus)
  require(Heatplus)
  DDB<-DedupRead(file,sidb,Mo,Days)
  
  DDB$days<-wday(DDB$Date)
  DDB$hour[DDB$hour==0]<-24
  A<-matrix(data = NA, nrow = 7, ncol =24)

  #colnames(dat_mat)<-c("C1","C2")
  rownames(A)<-c("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday")
   
  print(sidb)
  View(DDB)
   
   mio<-aggregate(AvgQITime~days + hour, mean,data=DDB)
  View(mio)
  for(day in c(1,2,3,4,5,6,7)){#c("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday")){
    for(Hour in c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24)){
      temp<-0
      temp<-mio$AvgQITime[(mio$hour==Hour)&(mio$day==day)]
      A[day,Hour]=temp
    }}
  A<-log10(A)
  print(A)  
  heatmap.plus(A,main="test",xlab="Hours",col=greenred(55));
 
}
