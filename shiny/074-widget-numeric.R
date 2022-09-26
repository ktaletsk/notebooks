function(input, output) {

  # You can access the value of the widget with input$num, e.g.
  output$value <- renderPrint({ input$num })

}


fluidPage(
    
  # Copy the line below to make a number input box into the UI.
  numericInput("num", label = h3("Numeric input"), value = 1),
  
  hr(),
  fluidRow(column(3, verbatimTextOutput("value")))
  
)


