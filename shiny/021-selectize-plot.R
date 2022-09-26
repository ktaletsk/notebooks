# In this example, we use the method `session$registerDataObj()` to register a data object in the shiny session, which we can retrieve via the URL that this method returns (`mapurl` here). Then we update the selectize input so that the choices can be processed on the server side (`server = TRUE`), and we provide a custom rendering method via the selectize initialization options. The rendering method sends a query to `mapurl` with the query variable `state`, which takes the values of the options (`item.value`).
# 
# We also provided the `filter` function in `session$registerDataObj()`, which should return an HTTP response based on the `data` registered and the current request `req`. We can extract the query string from `req$QUERY_STRING`, and parse the `state` string. Once we have got the state name, we draw a map of the state as well as a pie chart of the urban population percentage. Finally the plot is returned as an HTTP reponse that has the MIME type `image/png`, and `<img>` tag in the selectize rendering method will get the requested image.
# 
# This app also contains a parallel coordinate plot (`renderPlot`) and a data table (`renderDataTable`) that are straightforward to understand and should be familiar to Shiny users.
# 

library(maps)

function(input, output, session) {

  mapurl <- session$registerDataObj(

    name   = 'arrests', # an arbitrary but unique name for the data object
    data   = USArrests,
    filter = function(data, req) {

      query <- parseQueryString(req$QUERY_STRING)
      state <- query$state  # state name
      # data is USArrests, the `data` argument of registerDataObj()
      urban <- data[state, 'UrbanPop']  # % urban population

      # save a map of the state and a pie of %UrbanPop to a PNG file
      image <- tempfile()
      tryCatch({
        png(image, width = 400, height = 200, bg = 'transparent')
        par(mfrow = c(1, 2), mar = c(0, 0, 0, 0))
        map('county', regions = state, mar = c(0, 0, 0, 4))
        pie(c(100 - urban, 100), col = rgb(1, c(1, 0), c(1, 0), .2), labels = NA)
      }, finally = dev.off())

      # send the PNG image back in a response
      shiny:::httpResponse(
        200, 'image/png', readBin(image, 'raw', file.info(image)[, 'size'])
      )

    }
  )

  # update the render function for selectize
  updateSelectizeInput(
    session, 'state', server = TRUE,
    # sorry, Alaska and Hawaii, I do not have maps for you
    choices = setdiff(rownames(USArrests), c('Alaska', 'Hawaii')),
    options = list(render = I(sprintf(
      "{
          option: function(item, escape) {
            return '<div><img width=\"100\" height=\"50\" ' +
                'src=\"%s&state=' + escape(item.value) + '\" />' +
                escape(item.value) + '</div>';
          }
      }",
      mapurl
    )))
  )

  # a parallel coordinate plot showing the three crime variables
  output$parcoord <- renderPlot({
    par(mar = c(2, 4, 2, .1))
    arrests <- USArrests[, -3]
    plot(c(1, 3), range(as.matrix(arrests)), type = 'n', xaxt = 'n', las = 1,
         xlab = '', ylab = 'Number of arrests (per 100,000)')
    matlines(t(arrests), type = 'l', lty = 1, col = 'gray')
    state <- input$state
    if (state != '') {
      lines(1:3, arrests[state, ], lwd = 2, col = 'red')
      text(2, arrests[state, 2], state, cex = 2)
    }
    axis(1, 1:3, colnames(arrests))
  })

  # show raw data
  output$rawdata <- DT::renderDataTable(DT::datatable(
    cbind(State = rownames(USArrests), USArrests),
    options = list(pageLength = 10), rownames = FALSE
  ))

}


fluidPage(
  title = 'Create plots in selectize input',
  fluidRow(
    column(
      5,
      plotOutput('parcoord'),
      hr(),
      selectizeInput('state', label = NULL, choices = NULL, options = list(
        placeholder = 'Type a state name, e.g. Iowa', maxOptions = 5)
      )
    ),
    column(
      7,
      DT::dataTableOutput('rawdata')
    )
  )
)


