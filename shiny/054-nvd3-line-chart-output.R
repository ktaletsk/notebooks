function(input, output, session) {
  
  output$mychart <- renderLineChart({
    # Return a data frame. Each column will be a series in the line chart.
    data.frame(
      Sine = sin(1:100/10 + input$sinePhase * pi/180) * input$sineAmplitude,
      Cosine = 0.5 * cos(1:100/10),
      "Sine 2" = sin(1:100/10) * 0.25 + 0.5
    )
  })
}


fluidPage(
  tags$h2("JavaScript output binding example"),
  fluidRow(
    column(width=6,
      p("This Shiny app is an adaptation of the",
        a(href="http://nvd3.org/examples/line.html", "Simple Line Chart"),
        "example for the",
        a(href="http://nvd3.org/", "NVD3.js"),
        "JavaScript charting library."
      ),
      p("Source code:",
        a(href="https://github.com/jcheng5/shiny-js-examples/tree/master/output", "@jcheng5/shiny-js-examples/output"))
    )
  ),
  fluidRow(
    column(width=9,
      lineChartOutput("mychart")
    ),
    column(width=3,
      sliderInput("sinePhase", "Sine phase", -180, 180, 0, step=10,
        animate=animationOptions(interval=100, loop=TRUE)),
      sliderInput("sineAmplitude", "Sine amplitude", -2, 2, 1, step=0.1,
        animate=animationOptions(interval=100, loop=TRUE))
    )
  )
)


