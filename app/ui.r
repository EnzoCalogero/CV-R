library(shiny)
global<-AnalysDBTroughputSP_web() 
# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Job Abnalysis view"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(      
    
    # Define the sidebar with one input
    sidebarPanel(
      selectInput("var", "Variable:", 
                  choices=colnames(global[-1,-2])),
      hr(),
      selectInput("Sp", "Storage Policy:", 
                  choices=global$data_sp),
      hr(),
      helpText("segli quello che ti pare")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
))
