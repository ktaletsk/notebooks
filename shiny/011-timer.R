# The function `invalidateLater()` can be used to invalidate an observer or
# reactive expression in a given number of milliseconds. In this example, the
# output `currentTime` is updated every second, so it shows the current time
# on a second basis.
# 

library(shiny)

# Define UI for displaying current time ----
ui <- fluidPage(

  h2(textOutput("currentTime"))

)

# Define server logic to show current time, update every second ----
server <- function(input, output, session) {

  output$currentTime <- renderText({
    invalidateLater(1000, session)
    paste("The current time is", Sys.time())
  })

}

# Create Shiny app ----
shinyApp(ui, server)


