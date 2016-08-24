library(dplyr)

library(streamgraph)



LON3AF <- read.csv("C:/Users/enzo7311/Desktop/globalLON3AF.csv")
LON3AF$nome<-paste(LON3AF$CommCell,LON3AF$DDB.ID,sep="-")
LON3AF$nome<-as.factor((LON3AF$nome))
LON3AF$DAY<-as.character((LON3AF$DAY))
#LON3AF$DAY <- as.Date(LON3AF$DAY, format="%y-%m-%d")

View(LON3AF)
streamgraph(LON3AF,'DDB.ID','DAY' 'Record_Count',,interpolate="linear") %>%
sg_fill_brewer("PuOr") %>%
  
  # sg_add_marker("01-06","test")%>%
  sg_axis_x(1, "DAY", "%d-%m")%>%
  sg_legend(show=TRUE, label="DDB Selection")


streamgraph(LON3AF,'DDB.ID', 'Size_on_Disk','DAY',interpolate="linear")%>%
 # sg_fill_brewer("PuOr") %>%
   sg_colors("Reds")%>%
  sg_axis_x(1, "DAY", "%d-%m")%>%
  sg_legend(show=TRUE, label="DDB Selection")