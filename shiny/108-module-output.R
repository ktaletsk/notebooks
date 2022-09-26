# This small example shows a Shiny module (`linked_scatter.R`) and how it can be
# used within an application (`app.R`). The linked scatter module lets the caller
# specify the data frame (mpg) and dimensions (cty/hwy and drv/hwy) that should
# be plotted, and also returns a reactive expression that contains the data
# frame with selection info in a `selected_` column. It renders two scatter
# plots that can be brushed (click and drag to make a selection) with coordinated
# highlighting between the plots.
# 

library(shiny)

source("linked_scatter.R")

ui <- fixedPage(
  h2("Module example"),
  linkedScatterUI("scatters"),
  textOutput("summary")
)

server <- function(input, output, session) {
  df <- callModule(linkedScatter, "scatters", reactive(mpg),
    left = reactive(c("cty", "hwy")),
    right = reactive(c("drv", "hwy"))
  )

  output$summary <- renderText({
    sprintf("%d observation(s) selected", nrow(dplyr::filter(df(), selected_)))
  })
}

shinyApp(ui, server)


