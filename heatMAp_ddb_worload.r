heatMAp_DDB_worload<-function(sidb="All",Mo=c(10,11),file='C:/Users/enzo7311/Desktop/Dati/cs403ddb11_28.csv',Days=c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),hour=0){
  library(ggplot2)
  library(doBy)
  library(lubridate)
  library(gplots)
  library(RColorBrewer)

  bbb<-DedupRead_workload(file)
  View(bbb)

  A<-matrix(data = NA, nrow = 7, ncol =24)
  rownames(A)<-c("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday")
  print(sidb)
  #View(DDB)
  
  for(day in c(1,2,3,4,5,6,7)){#c("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday")){
    for(Hour in c(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23)){
       #temp<-0
       
       temp<-as.numeric(bbb[hour(bbb)==Hour & wday(bbb)==day])
       print(temp)
       
       if(Hour==0){
         Hour<-24
       }
       A[day,Hour]=temp
      
  }}
  View(A)  
#A<-log10(A+1)
# creates a own color palette from red to green
#my_palette <- colorRampPalette(c( "green", "red"))(n = 255)
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


labelTitle<-"DDB Insert Time "#+as.character(sidb)
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


DedupRead_workload<-function(file='C:/Users/enzo7311/Desktop/Dati/cs403ddb11_28.csv', sidb=11,Mo=10){

  dayStart=20

  #  library(ggplot2)
  library(xts)
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
 
  DDB$Date<-as.POSIXct(DDB$ModifiedTime, origin="1970-01-01")
  ###Modify for the time zone
  DDB$Date<-format(DDB$Date, tz=Local_tz,usetz=TRUE)

#View(DDB)

  DDB$day<-substr(DDB$Date,9,10)
  DDB$Month<-substr(DDB$Date,6,7)
  DDB$year<-substr(DDB$Date,2,4)
  DDB$hour<-substr(DDB$Date,12,13)
  
  DDB$year<-as.numeric(DDB$year)
  DDB$Month<-as.numeric(DDB$Month)
  DDB$day<-as.numeric(DDB$day)
  DDB$hour<-as.numeric(DDB$hour)
###########replace stpo here##############
DDB$date1<-ymd_h(as.character(paste(DDB$year,DDB$Month,DDB$day,DDB$hour,sep="/")))
              #d_hms

################################################
  #                Time filtering
  ########################################
 # print(Mo)
  DDB<-subset(DDB,DDB$year > 13)
  if(Mo!=0){
    DDB<-subset(DDB,DDB$Month == 10)
    DDB<-subset(DDB,(DDB$day > dayStart-1)&((DDB$day < dayStart+7)))
  }
DDB_<-select(DDB,SecondaryEntries,date1)
DDB_<-aggregate(SecondaryEntries~date1, mean,data=DDB_)


#View(DDB_)

###########################
### Identify the empty slot on time and create a new replacement... 
 for (day_ in 20:26){
   for(hour_ in 0:23){
     time_<-ymd_h(as.character(paste("2014",Mo,day_,hour_,sep="/")))
     #print(time_)
     if(!(time_ %in% DDB_$date1)){
      # print (time_)
       #definisco per cercare l'ora prima
       
       hour(time_)<-hour(time_)-1
       
       temp<-filter(DDB_,time_==date1)%>%summarise(SecondaryEntries=max(SecondaryEntries))
       #print(temp)
       #ritorno all'ora originale...
       hour(time_)<-hour(time_)+1
       DFTemp<-data.frame(SecondaryEntries=temp$SecondaryEntries,date1=time_)
       DDB_<-rbind(DDB_,DFTemp)
       #print()
       
     }
   }
   }
 DDB<-subset(DDB,(DDB$day > dayStart-1)&((DDB$day < dayStart+7)))
 DDB_<-arrange(DDB_,date1)

  View(DDB_)   
  ######################################
aaa<-as.xts(DDB_$SecondaryEntries,order.by=ymd_hms(DDB_$date1),frequency=24)
#aa<-ts(DDB_$SecondaryEntries,frequency=24,start=10)#, order.by=DDB_$Date1)  
#View(aaa)
plot(aaa)
bbb<-lag(diff(aaa),-1)
plot(lag(diff(aaa),-1))
#  View(bbb)
 # return(DDB)
return (bbb)
}
