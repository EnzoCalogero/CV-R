
library(googleVis)

auxgRAPH <- read.csv("C:/dati/temp/auxgRAPH.csv",sep=";",stringsAsFactors=FALSE)
AUX<-gvisSankey(auxgRAPH, from='From', to='To', weight='resi',options = list(height="800px",width="1600px"))
plot(AUX,tag=NULL)
print(AUX,'chart',file="mio.html")