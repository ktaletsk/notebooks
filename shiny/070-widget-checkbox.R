function(input, output) {

  # You can access the value of the widget with input$checkbox, e.g.
  output$value <- renderPrint({ input$checkbox })

}


fluidPage(
    
  # Copy the line below to make a checkbox
  checkboxInput("checkbox", label = "Choice A", value = TRUE),
  
  hr(),
  fluidRow(column(3, verbatimTextOutput("value")))
  
)


