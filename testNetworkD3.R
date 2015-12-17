library(networkD3)
data(MisLinks)
data(MisNodes)

# Plot
forceNetwork(Links = MisLinks, Nodes = MisNodes,NodeID = "name",Group = "group")
#             Source = "source", Target = "target",
#             Value = "value", NodeID = "name",
#             Group = "group", opacity = 0.8)

View(MisLinks)
View(MisNodes)