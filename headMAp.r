headMAp_DDB<-function(sidb=0,Mo=c(10,11),file='C:/Users/enzo7311/Desktop/Dati/cs903ddb11_28.csv',Days=c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),hour=0){
  library(ggplot2)
  library(doBy)
  if (!require("gplots")) {
    install.packages("gplots", dependencies = TRUE)
    library(gplots)
  }
  if (!require("RColorBrewer")) {
    install.packages("RColorBrewer", dependencies = TRUE)
    library(RColorBrewer)
  }
  DDB<-DedupRead(file,sidb,Mo,Days)
  DDB$days<-wday(DDB$Date)
  DDB$hour[DDB$hour==0]<-24
  A<-matrix(data = NA, nrow = 7, ncol =25)
  print(sidb)
  View(DDB)
 # A[1,1]="Sunday"
#  A[2,1]="Monday"
#  A[3,1]="Tuesday"
#  A[4,1]="Wednesday"
#  A[5,1]="Thursday"
#  A[6,1]="Friday"
#  A[7,1]="Saturday"
#  A[3,3]=8
  
  mio<-aggregate(AvgQITime~days + hour, mean,data=DDB)
  View(mio)
  for(day in c(1,2,3,4,5,6,7)){#c("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday")){
    for(Hour in c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24)){
  temp<-0
  temp<-mio$AvgQITime[(mio$hour==Hour)&(mio$day==day)]
  A[day,Hour]=temp
  #temp<-mio$WDay[mio$WDay==day]
    print(temp)
    print (day)
    print(Hour)
  }}
  print(A)  

# creates a own color palette from red to green
my_palette <- colorRampPalette(c("red", "yellow", "green"))(n = 255)

# (optional) defines the color breaks manually for a "skewed" color transition
col_breaks = c(seq(,2001,length=100),      # for red
               seq(2000,1001,length=100),              # for yellow
               seq(1000,0,length=100))              # for green

# creates a 5 x 5 inch image
#png("C:/Users/enzo7311/Desktop/cv_R/CV-R/heatmaps_in_r.png",    # create PNG for the heat map        
#    width = 5*300,        # 5 x 300 pixels
#    height = 5*300,
#    res = 300,            # 300 pixels per inch
#    pointsize = 8)        # smaller font size

heatmap.2(A,
         # cellnote = A,  # same data set for cell labels
          main = "Correlation", # heat map title
          notecol="black",      # change font color of cell labels to black
  #        density.info="none",  # turns off density plot inside color legend
          trace="none",         # turns off trace lines inside the heat map
          margins =c(10,3),     # widens margins around plot
          col=my_palette,       # use on color palette defined earlier 
#          breaks=col_breaks,    # enable color transition at specified limits
          dendrogram="row",     # only draw a row dendrogram
          Colv="NA")            # turn off column clustering
#)
#dev.off()   
# close the PNG device
  #multiplot(m10,t0,t1,t4,t5,t6, cols=2)
  # multiplot(t6,t5, cols=2)
}