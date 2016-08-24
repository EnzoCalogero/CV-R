require(visNetwork, quietly = TRUE)
# minimal example
nodes <- data.frame(id = 1:9)
edges <- data.frame(from = c(1,2), to = c(1,3))

visNetwork(nodes, edges, width = "100%")

##############################################################
nodes <- data.frame(id = 1:10,
                    
                    # add labels on nodes
                    label = paste("Node", 1:10),
                    
                    # add groups on nodes 
                    group = c("GrA", "GrB"),
                    
                    # size adding value
                    value = 1:10,          
                    
                    # control shape of nodes
                    shape = c("square", "triangle", "box", "circle", "dot", "star",
                              "ellipse", "database", "text", "diamond"),
                    
                    # tooltip (html or character), when the mouse is above
                    title = paste0("<p><b>", 1:10,"</b><br>Node !</p>"),
                    
                    # color
                    color = c("darkred", "grey", "orange", "darkblue", "purple"),
                    
                    # shadow
                    shadow = c(FALSE, TRUE, FALSE, TRUE, TRUE))             

# head(nodes)
# id  label group value    shape                     title    color shadow
#  1 Node 1   GrA     1   square <p><b>1</b><br>Node !</p>  darkred  FALSE
#  2 Node 2   GrB     2 triangle <p><b>2</b><br>Node !</p>     grey   TRUE

#edges <- data.frame(from = c(1,2,5,7,8,10), to = c(9,3,1,6,4,7))

visNetwork(nodes, edges, height = "500px", width = "100%")

######################################################
nodes <- data.frame(id = 1:4)
edges <- data.frame(from = c(2,4,3,2), to = c(1,2,4,3))

visNetwork(nodes, edges, width = "100%") %>% 
  visEdges(shadow = TRUE,
           arrows =list(to = list(enabled = TRUE, scaleFactor = 2)),
           color = list(color = "lightblue", highlight = "red")) %>%
  visLayout(randomSeed = 12) # to have always the same network    


##########################################

nodes <- data.frame(id = 1:3, group = c("B", "A", "B"))
edges <- data.frame(from = c(1,2), to = c(2,3))

visNetwork(nodes, edges) %>%
  visGroups(groupname = "A", shape = "icon", 
            icon = list(code = "f0c0", size = 75)) %>%
  visGroups(groupname = "B", shape = "icon", 
            icon = list(code = "f007", color = "red")) %>%
  addFontAwesome() %>%
  visLegend(addNodes = list(
    list(label = "Group", shape = "icon", 
         icon = list(code = "f1c0", size = 25)),
    list(label = "User", shape = "icon", 
         icon = list(code = "f233", size = 50, color = "red"))), 
    useGroups = FALSE)


##############################################
nodes <- data.frame(id = 1:3, label = LETTERS[1:3])
edges <- data.frame(from = c(1,2), to = c(1,3))

# don't look in RStudio viewer
visNetwork(nodes, edges, width = "100%") %>%
  visConfigure(enabled = TRUE)