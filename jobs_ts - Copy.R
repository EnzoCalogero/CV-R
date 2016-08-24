#for (sp in jobs_$data_sp){
#  for(hour_ in c(0,3,6,9,18,21)){

heatMAp_jobs_workload<-function(file='C:/Users/enzo7311/Desktop/Dati/cs403JOBS15_04_03.csv', SP="2Week",Mo=3){
      library(ggplot2)
      library(lubridate)
      library(gplots)
      library(RColorBrewer)
      library(xts)
      library(dplyr)
      
      jobs<-jobsRead_workload(file,SP,Mo)
      dayStart<-20

      jobs$startdate<-ymd_hms(jobs$startdate)
           
      jobs1<-subset(jobs,(day(jobs$startdate) > dayStart-1)&((day(jobs$startdate) < dayStart+7)))
      View(jobs1)
      
      jobs_schedule<-jobs1%>%filter(hour(startdate) %in% c("0","3","6","9","18","21"))%>%group_by(startdate,data_sp)%>%summarise(durationunixsec=sum(durationunixsec),averagenumbytescomp=mean(numbytescomp),numbytesuncomp=sum(numbytesuncomp),numbytescomp=mean(numbytescomp))
      jobs_day<-jobs1%>%group_by(daystart,data_sp)%>%summarise(durationunixsec=sum(durationunixsec),averagenumbytescomp=mean(numbytescomp/6),numbytescomp=sum(numbytescomp),numbytescomp=mean(numbytescomp))
     
      jobs_dayGlobal<-jobs1%>%group_by(daystart)%>%summarise(durationunixsec=sum(durationunixsec),numbytesuncomp=sum(numbytesuncomp),numbytescomp=mean(numbytescomp))
      View(jobs_schedule)
      

      View(jobs1)

      print("unique")
      print(unique(jobs1$data_sp))
    p2<-ggplot(jobs_schedule, aes(y=log10(numbytescomp),x=startdate)) +  geom_point()  + geom_line(aes(colour=factor(data_sp)))
    p3<-ggplot(jobs_day, aes(y=(numbytescomp),x=daystart)) +  geom_point()  + geom_line(aes(colour=factor(data_sp))) 
    p3b<-ggplot(jobs_day, aes(y=(averagenumbytescomp-numbytescomp),x=daystart)) +  geom_point()  + geom_line(aes(colour=factor(data_sp))) 
    p4<-ggplot(jobs_dayGlobal, aes(y=log10(numbytescomp),x=daystart)) +  geom_point()  + geom_line()
    multiplot(p2, cols=1)
    multiplot(p3, cols=1)
    multiplot(p3b, cols=1)
    multiplot(p4, cols=1)
    stop()
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
    



jobsRead_workload<-function(file='C:/Users/enzo7311/Desktop/Dati/cs403JOBS15_04_03.csv', SP="2Week",Mo=3){
  #  library(ggplot2)
  library(xts)
  library(dplyr)
  library(lubridate) #Date management
  
  Local_tz<-"Europe/London"
  #  Local_tz<-"America/Chicago"
  
  ##import the file
  jobs <- read.csv(file)
  names(jobs)<-c("jobinitfrom","clientname","idataagent","data_sp","jobstatus","backuplevel","startdate","enddate","durationunixsec","numstreams","numbytesuncomp","numbytescomp","numobjects")

  ##filter for the storag epolicy
  if(SP!='all'){
  jobs<-subset(jobs,grepl(SP,jobs$data_sp))
  }

  View(jobs)
  
 
  #start to work on the date set 
  
  jobs$startdate<-ymd_hms(jobs$startdate)
  jobs$startdate<-floor_date(jobs$startdate, "hour")
  jobs$daystart<-floor_date(jobs$startdate, "day")

 
  jobs<-subset(jobs,year(jobs$startdate) == 2015)

  jobs<-subset(jobs,month(jobs$startdate) == 3)
 

View(jobs)
jobs_<-jobs%>%filter()%>%group_by(startdate,data_sp)%>%summarise(durationunixsec=sum(durationunixsec),numbytesuncomp=sum(numbytesuncomp),numbytescomp=mean(numbytescomp))

View(jobs_)
#boxplot(numbytescomp~data_sp*startdate,data=jobs_)
return (jobs)
}

 