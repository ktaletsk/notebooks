function(input, output, session) {
  
  output$selection <- renderPrint(
    input$mychooser
  )
  
}


source("chooser.R")

fluidPage(
  chooserInput("mychooser", "Available frobs", "Selected frobs",
    row.names(USArrests), c(), size = 10, multiple = TRUE
  ),
  verbatimTextOutput("selection")
)

