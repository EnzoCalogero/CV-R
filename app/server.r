library(shiny)
global<-AnalysDBTroughputSP_web() 

# Define server logic required to draw a histogram
shinyServer(function(input,  output) {
  
 
  
  output$distPlot <- renderPlot({
    x <- global$nightImp  # Old Faithful Geyser data
    y<-global[,input$var]
 #   bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    plot(x, y)
  })
})
  