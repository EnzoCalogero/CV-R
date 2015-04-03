library(gplots)
data(mtcars)
x  <- as.matrix(mtcars)
rc <- rainbow(nrow(x), start=0, end=.3)
cc <- rainbow(ncol(x), start=0, end=.3)

## Show effect of row and column label rotation
heatmap.2(x, srtCol=NULL)
heatmap.2(x, srtCol=0,   adjCol = c(0.5,1) )
heatmap.2(x, srtCol=45,  adjCol = c(1,1)   )
heatmap.2(x, srtCol=135, adjCol = c(1,0)   )
heatmap.2(x, srtCol=180, adjCol = c(0.5,0) )
heatmap.2(x, srtCol=225, adjCol = c(0,0)   ) ## not very useful
heatmap.2(x, srtCol=270, adjCol = c(0,0.5) )
heatmap.2(x, srtCol=315, adjCol = c(0,1)   )
heatmap.2(x, srtCol=360, adjCol = c(0.5,1) )

heatmap.2(x, srtRow=45, adjRow=c(0, 1) )
heatmap.2(x, srtRow=45, adjRow=c(0, 1), srtCol=45, adjCol=c(1,2) )
heatmap.2(x, srtRow=45, adjRow=c(0, 1), srtCol=270, adjCol=c(0,0.5) )
