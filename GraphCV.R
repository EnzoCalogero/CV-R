GraphCV<-function(){ 
require(visNetwork, quietly = TRUE)

###################
#Crezione Commcell#
###################
CS<-"CS01"

nodes <- data.frame(id=CS,label=CS,color="darkblue",shape = "icon", 
                    icon = list(code = "f013", size = 50, color = "blue"))
edges<-NULL
#visNetwork(nodes, edges, width = "100%")
#######################
#Crezione Media Agents#
#######################
MAs<-c('Ma01','Ma02','Ma03','Ma04','Ma05')
for(Ma in MAs){
  nodes <-  rbind(nodes,data.frame(id=Ma,label=Ma,color="red",shape = "icon", 
                                   icon = list(code = "f233", size = 50, color = "red")))
  edges <-  rbind(edges,data.frame(from =CS, to = Ma,length=10))
  }


#########################
#Crezione Storage Policy#
#########################
SPs<-c("sp01","sp02","sp03","sp04","sp05","sp06","sp07","sp11","sp12","sp13")

for(SP in SPs){
  nodes <-  rbind(nodes,data.frame(id=SP,label=SP,color="blue",shape = "icon", 
                                   icon = list(code = "f07b", size = 50, color = Color)))
}


################
#Crezione DDB  #
################
DDBs<-c('2','3','4','5','6','7','8','9','10','1')

for(DDB in DDBs){
  Color="green"
  size=50
  MA="Ma03"
  if(DDB>3 && DDB<6){
    Color="red"
    size<-70
    MA="Ma01"}
  if(DDB>5){
    Color="orange"
    size<-60
    MA="Ma02"}
  if(DDB>7){
     MA="Ma04"
  }
  if(DDB==10){
    MA="Ma05"
    size<-20
    Color="darkred"
    
  }
  
  
  
  nodes <-  rbind(nodes,data.frame(id=DDB,label=DDB,color="blue",shape = "icon", 
                                   icon = list(code = "f1c0", size = size, color = Color)))
  #connections between MA and DDB
  edges <-  rbind(edges,data.frame(from =MA, to = DDB,length=5))
  #connections between Storage policy and DDB
  edges <-  rbind(edges,data.frame(from =SPs[as.numeric(DDB)], to = DDB,length=5))
# print(SPs[DDB])
 # print(DDB)
  
  }

####################
#Crezione Librerie #
####################
LIBs<-c("Libreria01","Libreria02")

for(LIB in LIBs){
  
  
  nodes <-  rbind(nodes,data.frame(id=LIB,label=LIB,color="blue",shape = "icon", 
                                   icon = list(code = "f02d", size = 90, color = "red")))
}

for(i in seq(1, 10, by=2 )){
edges <-  rbind(edges,data.frame(from =SPs[i], to = LIBs[1],length=350))
}

for(i in seq(2, 10, by=2 )){
  edges <-  rbind(edges,data.frame(from =SPs[i], to = LIBs[2],length=350))
}

visNetwork(nodes, edges, width = "100%")%>%
  visInteraction(navigationButtons = TRUE,keyboard = TRUE, tooltipDelay = 0) %>%
  visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE) %>%
  addFontAwesome()#%>%
#  visEvents(selectNode = "function(properties) {
#      alert('selected nodes ' + this.body.data.nodes.get(properties.nodes[0]).id);}")
}

GraphCV()

