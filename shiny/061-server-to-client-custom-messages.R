function(input, output, session) {
  # An observer is used to send messages to the client.
  # The message is converted to JSON
  observe({
    session$sendCustomMessage(type = 'testmessage',
      message = list(a = 1, b = 'text',
                     controller = input$controller))
  })
}


fluidPage(
  titlePanel("sendCustomMessage example"),

  fluidRow(
    column(4, wellPanel(
      sliderInput("controller", "Controller:",
        min = 1, max = 20, value = 15),
      
      # This makes web page load the JS file in the HTML head.
      # The call to singleton ensures it's only included once
      # in a page. It's not strictly necessary in this case, but
      # it's good practice.
      singleton(
        tags$head(tags$script(src = "message-handler.js"))
      )
    ))
  )
)


