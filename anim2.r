
Animator_Analysis<-function(sidb=c(68,77,78),Mo=c(11,12),file='C:/Users/enzo7311/Desktop/Dati/CS901ddb2312.csv',hour=0){
  library(ggplot2)
  library(doBy)  
  library(lubridate)
  library("animation")
  
  DDB<-DedupRead(file,sidb,Mo)
  #View(DDB)
  
  oopt2 = ani.options(interval = 0.2, nmax = 10)
  ani.options(loop = FALSE)
  ani.record(reset = TRUE)
  ## use a loop to create images one by one
  #for (i in 1:ani.options("nmax")) {
  for(m in Mo){     #month cycles
   for (i in 0:4) {  #days cycles
        
   
    DDBTemp<-subset(DDB,month(Date) ==m )
    DDBTemp<-subset(DDBTemp,day(Date) >(i*7) & day(Date)<7+i*7 )
    #View(DDBTemp)
    if(length(DDBTemp$SIDBStoreId)>3){ 
  
      MM<-log10(DDBTemp$AvgQITime+1)
  #    print(m)
   #   print(i)
  #    print(MM)
      
      
      t1<-ggplot(DDBTemp, aes(xmin=1,xmax= 5,x = log10(AvgQITime)))+ geom_density()+ ggtitle(paste(m,MM,  i))+ facet_grid(SIDBStoreId ~.)
    
    multiplot(t1, cols=1)
    oopt = ani.options(interval = 1)
    ani.record()
  #  ani.pause() ## pause for a while (  'interval'  )
    
  } #End IF 
  }}
  ## restore the options
  #ani.options(oopt)
 # oopts = ani.options(interval = 0.5)
 #ani.replay()
  saveHTML(ani.replay(), img.name = "record_plot4")
    
  
}






