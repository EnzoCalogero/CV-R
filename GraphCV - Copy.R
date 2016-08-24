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
MAs<-c('Ma01','Ma02','Ma03','Ma04')
for(Ma in MAs){
  nodes <-  rbind(nodes,data.frame(id=Ma,label=Ma,color="red",shape = "icon", 
                                   icon = list(code = "f233", size = 50, color = "red")))
  edges <-  rbind(edges,data.frame(from =CS, to = Ma,length=100))
  }

#nodes <-  rbind(nodes,data.frame(id=MAs,label=MAs))
#edges <- data.frame(from = c('CS01','CS01'), to = MAs)
#addFontAwesome()


################
#Crezione DDB  #
################
DDBs<-c('2','3','4','5')
for(DDB in DDBs){
  Color="green"
  MA="Ma03"
  if(DDB>3){
    Color="red"
    MA="Ma01"}
  
  nodes <-  rbind(nodes,data.frame(id=DDB,label=DDB,color="blue",shape = "icon", 
                                   icon = list(code = "f1c0", size = 50, color = Color)))
  edges <-  rbind(edges,data.frame(from =MA, to = DDB,length=5))
}

#########################
#Crezione Storage Policy#
#########################


visNetwork(nodes, edges, width = "100%")%>%
  addFontAwesome()
