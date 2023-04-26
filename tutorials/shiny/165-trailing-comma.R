# This app has a trailing comma in the UI. Historically, that would have crashed the app. But as of htmltools `0.3.6.9004`, that's now allowed.
# 

library(shiny)

ui <- fluidPage(

  titlePanel("Hello Shiny!"),

   # NOTE THE TRAILING COMMA
  textOutput(outputId = "text"),
)

server <- function(input, output) {

  output$text <- renderText({
    "If you're seeing this, things are fine."
  })
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)


