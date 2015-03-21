heatMAp_DDB_worload<-function(sidb="All",Mo=c(10,11),file='C:/Users/enzo7311/Desktop/Dati/cs403ddb11_28.csv',Days=c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),hour=0){
  library(ggplot2)
  library(doBy)
  library(lubridate)
  library(gplots)
  library(RColorBrewer)

  DDB<-DedupRead_workload(file)
  
  
  
  DDB$days<-wday(DDB$Date)
  DDB$hour[DDB$hour==0]<-24
  A<-matrix(data = NA, nrow = 7, ncol =24)
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
  View(A)  
A<-log10(A)
# creates a own color palette from red to green
my_palette <- colorRampPalette(c( "green", "red"))(n = 255)

# (optional) defines the color breaks manually for a "skewed" color transition
col_breaks = c(seq(0,1000,length=1000),      # for red
               seq(2000,1001,length=1000),              # for yellow
               seq(5000,2001,length=1000))              # for green

# creates a 5 x 5 inch image
#png("h1_simple.png",
#    width = 5*300, # 5 x 300 pixels
#    height = 5*300,
#    res = 300, # 300 pixels per inch
#    pointsize = 8) # smaller font size


labelTitle<-"DDB Insert Time "#+as.character(sidb)
heatmap.2(A,
         # cellnote = A,  # same data set for cell labels
          main = labelTitle, # heat map title
          notecol="black",      # change font color of cell labels to black
          density.info="density",  # turns off density plot inside color legend
          trace="none",         # turns off trace lines inside the heat map
          margins =c(10,10),     # widens margins around plot
        #  col=my_palette,       # use on color palette defined earlier 
         # breaks=col_breaks,    # enable color transition at specified limits
          dendrogram="both",     # only draw a row dendrogram
      #    Colv="NA")            # turn off column clustering
      xlab="Hours"
)
#dev.off()
}


DedupRead_workload<-function(file='C:/Users/enzo7311/Desktop/Dati/cs403ddb11_28.csv', sidb=0,Mo=0){
#  library(ggplot2)
  library(gcookbook)
  library(dplyr)
  library(lubridate) #Date management
  #Read the big File######
    
  Local_tz<-"Europe/London"
  #  Local_tz<-"America/Chicago"
  
  
  
  DDB <- read.csv(file)
  #View(DDB)
  ##########Focus on the sidb##########
  if(sidb!=0){
    DDB<-subset(DDB,DDB$SIDBStoreId %in% sidb)
  }
  ###################
  #~New Add...
  ##################
  DDB$Date<-as.Date(as.POSIXct(DDB$ModifiedTime, origin="1970-01-01")) 
  #DDB<-subset(DDB,DDB$AvgQITime > 0 & DDB$NumOfConnections > 0)
#  DDB$trughput<-(128/(DDB$AvgQITime/100000))/1024##mg/sec 
  DDB$Date<-as.POSIXct(DDB$ModifiedTime, origin="1970-01-01")
  ###Modify for the time zone
  DDB$Date<-format(DDB$Date, tz=Local_tz,usetz=TRUE)
######added from here  
#DDB$date1<-floor_date(Date$date,"hour")
#View(DDB)
#DDB$date1<-ymd_hms(DDB$date)
View(DDB)
#stop()
#  DDB$day<-day(DDB$date)

View(DDB)
#######Added stops here  
#############Replace Here################
  DDB$day<-substr(DDB$Date,9,10)
  DDB$Month<-substr(DDB$Date,6,7)
  DDB$year<-substr(DDB$Date,2,4)
  DDB$hour<-substr(DDB$Date,12,13)
  
  DDB$year<-as.numeric(DDB$year)
  DDB$Month<-as.numeric(DDB$Month)
  DDB$day<-as.numeric(DDB$day)
  DDB$hour<-as.numeric(DDB$hour)
###########replace stpo here##############



################################################
  #                Time filtering
  ########################################
  print(Mo)
  DDB<-subset(DDB,DDB$year > 13)
  if(Mo!=0){
    DDB<-subset(DDB,DDB$Month == Mo)
  }
  
  ######################################
  
  
  View(DDB)
  return(DDB)
}
