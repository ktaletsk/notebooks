function(input, output) {

  # You can access the values of the widget (as a vector)
  # with input$radio, e.g.
  output$value <- renderPrint({ input$radio })

}


fluidPage(
    
  # Copy the line below to make a set of radio buttons
  radioButtons("radio", label = h3("Radio buttons"),
    choices = list("Choice 1" = 1, "Choice 2" = 2, "Choice 3" = 3), 
    selected = 1),
  
  hr(),
  fluidRow(column(3, verbatimTextOutput("value")))
  
)


