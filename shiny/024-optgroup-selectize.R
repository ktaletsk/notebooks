# Sometimes it is more convenient to group all options into a few categories for the select/selectize input. To enable option groups, just use a nested list as the value of the `choices` argument of `selectInput()` / `selectizeInput()`. At least one of the child elements of the list must be of length >= 2, in other words, at least one option group should contain more than one option.
# 
# Note this feature requires **shiny** >= 0.10.1.
# 

function(input, output, session) {

  updateSelectizeInput(session, 'x2', choices = list(
    Eastern = c(`Rhode Island` = 'RI', `New Jersey` = 'NJ'),
    Western = c(`Oregon` = 'OR', `Washington` = 'WA'),
    Middle = list(Iowa = 'IA')
  ), selected = 'IA')

  output$values <- renderPrint({
    list(x1 = input$x1, x2 = input$x2, x3 = input$x3, x4 = input$x4)
  })
}


fluidPage(sidebarLayout(
  sidebarPanel(
    # use regions as option groups
    selectizeInput('x1', 'X1', choices = list(
      Eastern = c(`New York` = 'NY', `New Jersey` = 'NJ'),
      Western = c(`California` = 'CA', `Washington` = 'WA')
    ), multiple = TRUE),

    # use updateSelectizeInput() to generate options later
    selectizeInput('x2', 'X2', choices = NULL),

    # an ordinary selectize input without option groups
    selectizeInput('x3', 'X3', choices = setNames(state.abb, state.name)),

    # a select input
    selectInput('x4', 'X4', choices = list(
      Eastern = c(`New York` = 'NY', `New Jersey` = 'NJ'),
      Western = c(`California` = 'CA', `Washington` = 'WA')
    ), selectize = FALSE)
  ),
  mainPanel(
    verbatimTextOutput('values')
  )
), title = 'Options groups for select(ize) input')


