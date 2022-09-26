function(input, output) {

  # You can access the values of the widget (as a vector of Dates)
  # with input$dates, e.g.
  output$value <- renderPrint({ input$dates })

}


fluidPage(
    
  # Copy the line below to make a date range selector
  dateRangeInput("dates", label = h3("Date range")),

  hr(),
  fluidRow(column(4, verbatimTextOutput("value")))
  
)


