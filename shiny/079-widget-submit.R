function(input, output) {

  # submit buttons do not have a value of their own, 
  # they control when the app accesses values of other widgets.
  # input$num is the value of the number widget.
  output$value <- renderPrint({ input$num })

}


fluidPage(
    
  numericInput("num", label = "Make changes", value = 1),
  
  # Copy the line below to place a submit into the UI.
  submitButton("Apply Changes"),
  
  hr(),
  fluidRow(column(3, verbatimTextOutput("value")))
  
)


