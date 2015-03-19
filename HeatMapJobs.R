
heatMAp_collect<-function(hh=21,file='C:/Users/enzo7311/Desktop/dati/heatmap/CS404/15_10_2014/'){
  
  H21<-data.frame(DAYS=c("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"))
  files = list.files(path=file,pattern="*.csv")
  flag=10
  for(f in files){
      
       finale<-paste(file,f,sep="")
    
        print( f)
        temp<-heatMAp_jobs(finale)
       
       TempH_21<-data.frame(temp[,hh+1])
       f<-gsub(".csv", "", f)
       f<-gsub("z_", "", f)
       f<-gsub("Z_", "", f)
       names(TempH_21)<-f
       #TempH_21$name<-row.names(TempH_21$f)
    
       rownames(TempH_21)<-rownames(temp)
       TempH_21$DAYS <- rownames(TempH_21) 
       
       View(temp)
      # View(TempH_21)
    
       #print (flag)
    #   print(TempH_21)
       if (flag > 1) {
         #H21$DAYS <- rownames(temp)
         H21<- merge(H21,TempH_21, by="DAYS")
       }
       if (flag==0){
         H21=TempH_21
         flag =flag+1
         }
  }
View(H21) 
H21<-as.matrix(H21[-1])
rownames(H21)<- rownames(TempH_21)
my_palette <- colorRampPalette(c( "green","yellow", "red","black"))(n = 255)
labelTitle<-paste("jobs per Storage Policy at",hh," Order by Euclidea Distance")
heatmap.2(H21,
          # cellnote = A,  # same data set for cell labels
          main = labelTitle, # heat map title
          notecol="black",      # change font color of cell labels to black
          density.info="density",  # turns off density plot inside color legend
          trace="none",         # turns off trace lines inside the heat map
         #  margins =c(10,3),     # widens margins around plot
          col=my_palette,       # use on color palette defined earlier 
          #breaks=col_breaks,    # enable color transition at specified limits
          dendrogram="both",     # only draw a row dendrogram
          #    Colv="NA",            # turn off column clustering
          #    Rowv="NA",
          margins = c(11, 6),
          cexCol=0.7,
          xlab="Storage Policy",ylab="Day"
)


labelTitle<-"jobs at 21 Order by Storage Policy"
heatmap.2(H21,
          # cellnote = A,  # same data set for cell labels
          main = labelTitle, # heat map title
          notecol="black",      # change font color of cell labels to black
          density.info="density",  # turns off density plot inside color legend
          trace="none",         # turns off trace lines inside the heat map
          # margins =c(10,3),     # widens margins around plot
          col=my_palette,       # use on color palette defined earlier 
          #breaks=col_breaks,    # enable color transition at specified limits
          dendrogram="none",     # only draw a row dendrogram
          Colv="NA",            # turn off column clustering
          Rowv="NA",
          margins = c(11, 6),
          cexCol=0.7,
          xlab="Hours",ylab="Day"
)
return(H21)
}
#Function needed to create a matrix for each storage Policy...


heatMAp_jobs<-function(file='C:/Users/enzo7311/Desktop/dati/heatmap/CS499/15_10_2014/52WeekOffsite_MA02_A.csv'){
  
  library(doBy)
  jobs<-read.csv(file)
  A<-matrix(data = NA, nrow = 7, ncol =24)
#  View(jobs)
  A<-jobs[,1:24]
  
  A<-as.matrix(A)
  rownames(A)<-c("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday")
  
 # View(A)  
  
  return(A)
}




heatMAp_SingleFilejobs<-function(file='C:/Users/enzo7311/Desktop/dati/heatmap/CS499/15_10_2014/52WeekOffsite_MA02_A.csv'){
  
  library(heatmap.plus)
  
  library(ggplot2)
  library(doBy)
  library(gplots)
  library(RColorBrewer)
  
  
  
  jobs<-read.csv(file)
  
  
  A<-matrix(data = NA, nrow = 7, ncol =24)
  
  
  View(jobs)
  A<-jobs[,1:24]
  
  A<-as.matrix(A)
  rownames(A)<-c("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday")
  
  View(A)  
  
  my_palette <- colorRampPalette(c( "green","yellow", "red","black"))(n = 255)
  
  # (optional) defines the color breaks manually for a "skewed" color transition
  #col_breaks = c(seq(35,0,length=100),      # for red
  #               seq(70,36,length=100),              # for yellow
  #               seq(120,71,length=100))          
  
  
  labelTitle<-paste("jobs per Hour Order by Euclidea Distance",file)
  heatmap.2(A,
            # cellnote = A,  # same data set for cell labels
            main = labelTitle, # heat map title
            notecol="black",      # change font color of cell labels to black
            density.info="density",  # turns off density plot inside color legend
            trace="none",         # turns off trace lines inside the heat map
          #  margins =c(10,3),     # widens margins around plot
            col=my_palette,       # use on color palette defined earlier 
            #breaks=col_breaks,    # enable color transition at specified limits
            dendrogram="both",     # only draw a row dendrogram
            #    Colv="NA",            # turn off column clustering
            #    Rowv="NA",
           
            xlab="Hours",ylab="Day"
  )
  
  
  labelTitle<-"jobs per Hour Order by Time"
  heatmap.2(A,
            # cellnote = A,  # same data set for cell labels
            main = labelTitle, # heat map title
            notecol="black",      # change font color of cell labels to black
            density.info="density",  # turns off density plot inside color legend
            trace="none",         # turns off trace lines inside the heat map
            # margins =c(10,3),     # widens margins around plot
            col=my_palette,       # use on color palette defined earlier 
            #breaks=col_breaks,    # enable color transition at specified limits
            dendrogram="none",     # only draw a row dendrogram
                Colv="NA",            # turn off column clustering
                Rowv="NA",
            
            xlab="Hours",ylab="Day"
  )
  return(A)
}
