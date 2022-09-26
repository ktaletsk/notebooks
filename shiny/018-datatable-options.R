# We can customize DataTables through the `options` argument of
# `DT::datatable()`. Below is a brief explanation of the examples
# above:
# 
# 1. the option `pageLength = 25` changes the default number of rows to
#   display from 10 to 25;
# 
# 1. the option `lengthMenu = list(c(5, 15, -1), c('5', '15', 'All'))` sets
#   the length menu items (in the top left corner); it can be either a numeric
#   vector (e.g. `c(5, 10, 30, 100)`), or a list of length 2 -- in the latter
#   case, the first element is the length options, and the second element
#   contains their labels to be shown in the menu;
# 
# 1. `paging = FALSE` disables pagination, i.e. all records in the data are
#   shown at once; alternatively, you can set `pageLength = -1`;
# 
# 1. `searching = FALSE` disables searching, and no searching boxes will be shown;
# 
# 1. any character strings wrapped in `JS()` will be treated as literal JavaScript
#   code, and evaluated using `eval()` in JavaScript, so we can pass, for
#   example, JS functions to DataTables;
# 

function(input, output) {

  # display 10 rows initially
  output$ex1 <- DT::renderDataTable(
    DT::datatable(iris, options = list(pageLength = 25))
  )

  # -1 means no pagination; the 2nd element contains menu labels
  output$ex2 <- DT::renderDataTable(
    DT::datatable(
      iris, options = list(
        lengthMenu = list(c(5, 15, -1), c('5', '15', 'All')),
        pageLength = 15
      )
    )
  )

  # you can also use paging = FALSE to disable pagination
  output$ex3 <- DT::renderDataTable(
    DT::datatable(iris, options = list(paging = FALSE))
  )

  # turn off filtering (no searching boxes)
  output$ex4 <- DT::renderDataTable(
    DT::datatable(iris, options = list(searching = FALSE))
  )

  # write literal JS code in JS()
  output$ex5 <- DT::renderDataTable(DT::datatable(
    iris,
    options = list(rowCallback = DT::JS(
      'function(row, data) {
        // Bold cells for those >= 5 in the first column
        if (parseFloat(data[1]) >= 5.0)
          $("td:eq(1)", row).css("font-weight", "bold");
      }'
    ))
  ))
}


navbarPage(
  title = 'DataTable Options',
  tabPanel('Display length',     DT::dataTableOutput('ex1')),
  tabPanel('Length menu',        DT::dataTableOutput('ex2')),
  tabPanel('No pagination',      DT::dataTableOutput('ex3')),
  tabPanel('No filtering',       DT::dataTableOutput('ex4')),
  tabPanel('Function callback',  DT::dataTableOutput('ex5'))
)


