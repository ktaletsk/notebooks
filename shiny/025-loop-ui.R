# When you want to create some UI elements from a loop, it is tempting to use the dark power `eval(parse())`, e.g. `for (i in 1:10)` `eval(parse(text = paste0("uiOutput('id", i, "'"))))`, but this is almost always the wrong way to go in shiny. It makes the code obscure and insecure. This example shows you how to express the logic more naturally and securely without manually constructing the program code and evaluating it using the `eval(parse())` trick.
# 

function(input, output, session) {

  # note we use the syntax input[['foo']] instead of input$foo, because we have
  # to construct the id as a character string, then use it to access the value;
  # same thing applies to the output object below
  output$a_out <- renderPrint({
    res <- lapply(1:5, function(i) input[[paste0('a', i)]])
    str(setNames(res, paste0('a', 1:5)))
  })

  lapply(1:10, function(i) {
    output[[paste0('b', i)]] <- renderUI({
      strong(paste0('Hi, this is output B#', i))
    })
  })
}


fluidPage(
  title = 'Creating a UI from a loop',

  sidebarLayout(
    sidebarPanel(
      # create some select inputs
      lapply(1:5, function(i) {
        selectInput(paste0('a', i), paste0('SelectA', i),
                    choices = sample(LETTERS, 5))
      })
    ),

    mainPanel(
      verbatimTextOutput('a_out'),

      # UI output
      lapply(1:10, function(i) {
        uiOutput(paste0('b', i))
      })
    )
  )
)


