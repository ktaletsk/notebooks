function(input, output, session) {

  output$urlText <- renderText({
    as.character(input$my_url)
  })

  observe({
    # Run whenever reset button is pressed
    input$reset

    # Send an update to my_url, resetting its value
    updateUrlInput(session, "my_url", value = "http://www.r-project.org/")
  })
}


source("url-input.R")

fluidPage(
  titlePanel("Custom input example"),

  fluidRow(
    column(4, wellPanel(
      urlInput("my_url", "URL: ", "http://www.r-project.org/"),
      actionButton("reset", "Reset URL")
    )),
    column(8, wellPanel(
      verbatimTextOutput("urlText")
    ))
  )
)


