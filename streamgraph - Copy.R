library(dplyr)
library(babynames)
library(streamgraph)

# babynames %>%
#   filter(grepl("^Kr", name)) %>%
#   group_by(year, name) %>%
#   tally(wt=n) %>%
#   streamgraph("name", "n", "year")
# 
# #http://rpubs.com/hrbrmstr/59200
# 
# 
# aa<-babynames %>%  filter(grepl("^Kr", name)) %>%  group_by(year, name) %>%  tally(wt=n) 

LON3AF <- read.csv("C:/Users/enzo7311/Desktop/globalLON3AF.csv")
LON3AF$nome<-paste(LON3AF$CommCell,LON3AF$DDB.ID,sep="-")
View(LON3AF)
streamgraph(LON3AF,'nome', 'Record_Count','DAY',interpolate="linear")
sg_fill_brewer("PuOr") %>%
  # sg_add_marker("01-06","test")%>%
  sg_axis_x(1, "DAY", "%d-%m")%>%
  sg_legend(show=TRUE, label="DDB Selection")


streamgraph(LON3AF,'nome', 'Size_on_Disk','DAY',interpolate="linear")%>%
  sg_fill_brewer("PuOr") %>%
 # sg_add_marker("01-06","test")%>%
  sg_axis_x(1, "DAY", "%d-%m")%>%
  sg_legend(show=TRUE, label="DDB Selection")