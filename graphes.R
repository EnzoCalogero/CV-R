Lab<-function(){
  
  library(igraph)
  
  lab11<-read.csv("C:/temp2/graphlab.csv",sep=';')
  #View(lab11)
  raw<-unique(as.character(lab11$DDBID))
  View(raw)
  
  commCell<-as.character(substr(raw,1,5))
  commCell<-unique(commCell)
  #ids<-as.character(substr(raw,15,20))
  #print("id")
  #print(ids)
  
  
  for(CS in commCell){
    MAS=list()
    ids=list()
    for(r in raw){
      if(as.character(substr(r,1,5))==CS){
        MAS<-c(MAS,as.character(substr(r,6,8)))
        #print("CS")
        #print(CS)
        #print("MAS")
        #print(MAS)
        ids<-c(ids,as.character(substr(r,15,20)))
      }
    }
    MAS<-unique(MAS)
    ids<-unique(ids)    
    g <- graph.empty()+vertices(CS)
    g<-g+vertices(unique(MAS))
    g<-g+vertices(ids)
    
    for(r in raw){
      if(CS==substr(r,1,5)){
        # print("first")
        #print(c(substr(r,1,5),substr(r,6,8)))
        g<-g+edges(c(substr(r,1,5),substr(r,6,8)))
        g<-g+edges(c(substr(r,6,8),substr(r,15,21)))
      }
    }
    
    
    #  V(g)$size=1 
    #V(g)[commCell]$shapes<-"rectangle"
    V(g)[CS]$color<-"green"
    #V(g)[CS]$size=30
    for(ma in MAS){
      V(g)[ma]$color<-"blue"
    } 
    for(id in ids){
      V(g)[id]$color<-"red"
      ##################################
      #testing moving in teh graph...###
      ##################################
      
      a<-ends(g,incident(g,V(g)[id]))
      print("neigh")
      print(get.vertex.attribute(g, "color", index=V(g)[a[[1]]]))
      
      V(g)[a[[1]]]$color="red"
      
      print(get.vertex.attribute(g, "color", index=V(g)[a[[1]]]))  
      print(a[[1]])
      
      #print(V(g)[id])
      #V(g)[id]$size<-as.numeric('10')
    }
    V(g)$label.color="red"
    #g<-as.undirected(g)
    
    
    #g<-as.undirected(g, mode = "collapse",edge.attr.comb = igraph_opt("edge.attr.comb"))
    plot.igraph(g,layout=layout.reingold.tilford,edge.arrow.size=0.3,edge.arrow.width=0.3,edge.curved=FALSE)#,layout=layout.fruchterman.reingold)
  }
  
  
}