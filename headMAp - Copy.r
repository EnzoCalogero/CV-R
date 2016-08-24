headMAp_DDB<-function(sidb=0,Mo=c(10,11),file='C:/Users/enzo7311/Desktop/Dati/cs403ddb11_28.csv',Days=c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),hour=0){
  library(ggplot2)
  library(doBy)
  library(gplots)
  library(RColorBrewer)

  DDB<-DedupRead(file,sidb,Mo,Days)
  
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
