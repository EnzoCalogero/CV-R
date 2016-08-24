heatMAp_DDB_Ts<-function(sidb=14,Mo=3,file='C:/Users/enzo7311/Desktop/Dati/cs403DDB15_04_03.csv',Days=c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),hour=0){
  library(ggplot2)
  #library(doBy)
  library(lubridate)
  library(gplots)
  library(RColorBrewer)
  library(xts)
  library(dplyr)
    
  bbb<-DedupRead_TS(file,sidb,Mo)
  dayStart<-15+7
  PrimaryR<-bbb[,"PrimaryR"]
  View(PrimaryR)
  
  DPrimary<-lag(diff(PrimaryR),-1)
  
  DPrimary<-subset(DPrimary,(day(DPrimary) > dayStart-1)&((day(DPrimary) < dayStart+7)))
  #PrimaryR<-bbb[,"PrimaryR"]
  View(PrimaryR)
  #DPrimary<-lag(diff(PrimaryR),-1)
  #View(DPrimary)
  #print(hour(PrimaryR[3,]))
  #stop()
  A<-matrix(data = NA, nrow = 7, ncol =24)
  rownames(A)<-c("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday")
  colnames(A)<-c(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23)
  print(sidb)
  #View(DDB)
  
  for(day in c(1,2,3,4,5,6,7)){#c("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday")){
    for(Hour in c(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23)){
      #temp<-0
      
      temp<-as.numeric(DPrimary[hour(DPrimary)==Hour & wday(DPrimary)==day])
      print(temp)
      print
      if(Hour==0){
        print(wday(DPrimary))
      }
      A[day,Hour+1]=temp
      
    }
  }
  View(A)  
  
  # creates a own color palette from red to green
  
  
  my_palette <- colorRampPalette(c( "green","yellow", "red","black"))(n = 255)
  
  # (optional) defines the color breaks manually for a "skewed" color transition
  col_breaks = c(seq(-100000000,-1,length=1000),      # for red
                 seq(-1,100,length=1000),              # for yellow
                 seq(11,100,length=1000),
                 seq(100,1000,length=1000),
                 seq(1001,100000000,length=1000))              # for green
  
  # creates a 5 x 5 inch image
  #png("h1_simple.png",
  #    width = 5*300, # 5 x 300 pixels
  #    height = 5*300,
  #    res = 300, # 300 pixels per inch
  #    pointsize = 8) # smaller font size
  
  
  ###############################################################
  ###############################################################
  ################################################################
  #   .....    example   ....
  # following code limits the lowest and highest color to 5%, and 95% of your range, respectively
  #quantile.range <- quantile(random.matrix, probs = seq(0, 1, 0.01))
  #palette.breaks <- seq(quantile.range["5%"], quantile.range["95%"], 0.1)
  
  # use http://colorbrewer2.org/ to find optimal divergent color palette (or set own)
  #color.palette  <- colorRampPalette(c("#FC8D59", "#FFFFBF", "#91CF60"))(length(palette.breaks) - 1)
  
  
  #   .....    example   ....
  ####################################################################
  ####################################################################
  ###################################################################
  
  
  labelTitle<-"Delta DDB primary  Records "#+as.character(sidb)
  heatmap.2(A,
            # cellnote = A,  # same data set for cell labels
            main = labelTitle, # heat map title
            notecol="black",      # change font color of cell labels to black
            density.info="density",  # turns off density plot inside color legend
            trace="none",         # turns off trace lines inside the heat map
            margins =c(10,10),     # widens margins around plot
            col=my_palette,       # use on color palette defined earlier 
            #   breaks=col_breaks,    # enable color transition at specified limits
            dendrogram="none",     # only draw a row dendrogram
            Rowv="NA",  
            Colv="NA",            # turn off column clustering
            xlab="Hours")
  
  #dev.off()
}






DedupRead_TS<-function(file='C:/Users/enzo7311/Desktop/Dati/cs403DDB15_04_03.csv', sidb=0,Mo=3){
#  library(ggplot2)
  library(xts)
  library(dplyr)
  library(lubridate) #Date management
   
  Local_tz<-"Europe/London"
  #  Local_tz<-"America/Chicago"
    
  DDB <- read.csv(file)
  names(DDB)<-c("SIDBStoreId","SubStoreId","HistoryType","ModifiedTime","PrimaryEntries","SecondaryEntries","AvgQITime","AvgQITimeSampleCount","NumOfConnections","ZeroRefCount","DataSizeToPrune","SizeOccupied","DDBManagedSize","DeleteChunkCount")
  ##########Focus on the sidb##########
  if(sidb!=0){
    DDB<-subset(DDB,DDB$SIDBStoreId %in% sidb)
  }
  ###################
  #~New Add...
  ##################
  View(DDB)
  DDB$Date<-as.POSIXct(DDB$ModifiedTime, origin="1970-01-01")
  ###Modify for the time zone
  #DDB$Date<-format(DDB$Date, tz=Local_tz,usetz=TRUE)
  DDB$AvgQITime<-log10(DDB$AvgQITime+1)
  
  DDB$Date<-ymd_hms(DDB$Date)
  DDB$Date<-floor_date(DDB$Date, "hour")
  #floor_date(x, "day")
  
  ##Foilter for one month
  View(DDB)
 
  DDB<-subset(DDB,DDB$HistoryType != 2)
  DDB<-subset(DDB,year(DDB$Date) == 2015)
  DDB$temp<-year(DDB$Date)
  
  DDB<-subset(DDB,month(DDB$Date) == Mo)
  View(DDB)
   
  DDB_<-DDB%>%group_by(Date)%>%summarise(secondaryR=mean(SecondaryEntries),PrimaryR=mean(PrimaryEntries),ResponseTime=mean(AvgQITime))
  View(DDB_)
  
  
  DDB_<-arrange(DDB_,Date)
  
  
  ###########################
  ### Identify the empty slot on time and create a new replacement... 
  
  for (day_ in 1:27){
    for(hour_ in 0:23){
      time_<-ymd_h(as.character(paste("2015",Mo,day_,hour_,sep="/")))
      #print(time_)
      if(!(time_ %in% DDB_$Date)){
        # print (time_)
        #definisco per cercare l'ora prima
        
        hour(time_)<-hour(time_)-1
        
        temp<-filter(DDB_,time_==Date)%>%summarise(secondaryR=mean(secondaryR),PrimaryR=mean(PrimaryR))
       # print(temp)
        
        #ritorno all'ora originale...
        hour(time_)<-hour(time_)+1
        DFTemp<-data.frame(secondaryR=temp$secondaryR,PrimaryR=temp$PrimaryR,ResponseTime=0,Date=time_)
        DDB_<-rbind(DDB_,DFTemp)
        #print()
        
      }
    }
  }
  #DDB_<-subset(DDB_,day(DDB_$Date) <27)
  
  DDB_<-arrange(DDB_,Date)
  
  View(DDB_)   
  prima<-xts(DDB_[,-1],order.by=as.POSIXct(DDB_$Date))
  
  View(prima)
  plot(prima$ResponseTime)
  plot(prima$secondaryR)
  plot(prima$PrimaryR)
  
  return (prima)
}
