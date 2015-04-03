#for (sp in jobs_$data_sp){
#  for(hour_ in c(0,3,6,9,18,21)){

heatMAp_jobs_workload<-function(file='C:/Users/enzo7311/Desktop/Dati/cs403JOBS15_04_03.csv', sidb=0,Mo=3){
      library(ggplot2)
      #library(doBy)
      library(lubridate)
      library(gplots)
      library(RColorBrewer)
      library(xts)
      library(dplyr)
      
      jobs<-jobsRead_workload(file,sidb,Mo)
      dayStart<-15
      #numbytescomp<-jobs[,"numbytescomp"]
    #  View(jobs)
      jobs$startdate<-ymd_hms(jobs$startdate)
           
      jobs1<-subset(jobs,(day(jobs$startdate) > dayStart-1)&((day(jobs$startdate) < dayStart+7)))
      
      #PrimaryR<-bbb[,"PrimaryR"]
      View(jobs1)
      #DPrimary<-lag(diff(PrimaryR),-1)
      #View(DPrimary)
      #print(hour(PrimaryR[3,]))
      #stop()
      print("unique")
      print(unique(jobs1$data_sp))
     
    A<-matrix(data = NA, nrow = 6, ncol =24)
      
      rownames(A)<-c("0","3","6","9","18","21")
      colnames(A)<-c(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23)
      
      #View(DDB)
      
    for (sp in jobs1$data_sp){
      for(hour_ in c(0,3,6,9,18,21)){
          temp<-0
          print(temp)
          temp<-as.numeric(jobs1%>%filter(hour(startdate)==hour_,data_sp== sp)%>%summarise(numbytescomp=sum(numbytescomp)))
          print(temp)
         
          A[day,Hour+1]=temp
          
        }
      }
      View(A)  
      
      # creates a own color palette from red to green
stop()      
      
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
    



jobsRead_workload<-function(file='C:/Users/enzo7311/Desktop/Dati/cs403JOBS15_04_03.csv', sidb=0,Mo=3){
  #  library(ggplot2)
  library(xts)
  library(dplyr)
  library(lubridate) #Date management
  
  Local_tz<-"Europe/London"
  #  Local_tz<-"America/Chicago"
  
  jobs <- read.csv(file)
  names(jobs)<-c("jobinitfrom","clientname","idataagent","data_sp","jobstatus","backuplevel","startdate","enddate","durationunixsec","numstreams","numbytesuncomp","numbytescomp","numobjects")
  ##########Focus on the sidb##########
 # if(sidb!=0){
#    DDB<-subset(DDB,DDB$SIDBStoreId %in% sidb)
#  }
  ###################
  #~New Add...
  ##################
  View(jobs)
  
  #DDB$Date<-as.POSIXct(DDB$ModifiedTime, origin="1970-01-01")
  ###Modify for the time zone
  #DDB$Date<-format(DDB$Date, tz=Local_tz,usetz=TRUE)
  #DDB$AvgQITime<-log10(DDB$AvgQITime+1)
  
  jobs$startdate<-ymd_hms(jobs$startdate)
  jobs$startdate<-floor_date(jobs$startdate, "hour")
  #floor_date(x, "day")
  
  ##Foilter for one month
 
 jobs<-subset(jobs,year(jobs$startdate) == 2015)

 jobs<-subset(jobs,month(jobs$startdate) == 3)
View(jobs)
jobs_<-jobs%>%group_by(startdate,data_sp)%>%summarise(durationunixsec=sum(durationunixsec),numbytesuncomp=sum(numbytesuncomp),numbytescomp=mean(numbytescomp))

View(jobs_)
#boxplot(numbytescomp~data_sp*startdate,data=jobs_)
return (jobs_)
}

 