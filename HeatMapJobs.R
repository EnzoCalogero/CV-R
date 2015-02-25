## This function is for create a head map of teh ddb insert time 
## For each hour of a given week
##
headMAp_coordinator<-function(sidb=0,file='C:/Users/enzo7311/Desktop/dati/heatmap/CS499/15_10_2014/'){
  
  files = list.files(path=file,pattern="*.csv")
  for(f in files){ 
    finale<-paste(file,f,sep="")
    
    print( finale)
    temp<-headMAp_jobs(finale)
    print (temp)
  }
  
}





headMAp_jobs<-function(file='C:/Users/enzo7311/Desktop/dati/heatmap/CS499/15_10_2014/52WeekOffsite_MA02_A.csv'){
  
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
  
  
  labelTitle<-"jobs per Hour Order by Euclidea Distance"
  heatmap.2(A,
            # cellnote = A,  # same data set for cell labels
            main = labelTitle, # heat map title
            notecol="black",      # change font color of cell labels to black
            density.info="density",  # turns off density plot inside color legend
            trace="none",         # turns off trace lines inside the heat map
           # margins =c(10,3),     # widens margins around plot
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
