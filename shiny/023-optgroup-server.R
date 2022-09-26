# We can use `updateSelectizeInput(server = TRUE)` to make use of the server-side selectize input, but it is not straightforward to obtain the `<optgroup>` info from the server side dynamically. In this case, we just predefine the option groups in the initialization configurations.
# 
# Note this feature requires **shiny** >= 0.10.1.
# 

function(input, output, session) {

  Titanic2 <- as.data.frame(Titanic, stringsAsFactors = FALSE)
  Titanic2 <- cbind(Titanic2, value = seq_len(nrow(Titanic2)))
  Titanic2$label <- apply(Titanic2[, 2:4], 1, paste, collapse = ', ')
  updateSelectizeInput(session, 'group', choices = Titanic2, server = TRUE)

  output$row <- renderPrint({
    validate(need(
      input$group, 'Please type and search (e.g. Female)'
    ))
    Titanic2[as.integer(input$group), -(6:7)]
  })
}


fluidPage(
  selectizeInput('group', NULL, NULL, multiple = TRUE, options = list(

    placeholder = 'Select a category',

    # predefine all option groups
    optgroups = list(
      list(value = '1st', label = 'First Class'),
      list(value = '2nd', label = 'Second Class'),
      list(value = '3rd', label = 'Third Class'),
      list(value = 'Crew', label = 'Crew')
    ),

    # 'Class' is a field in Titanic2 created in server.R
    optgroupField = 'Class',

    optgroupOrder = c('1st', '2nd', '3rd', 'Crew'),

    # you can type and search in these fields in Titanic2
    searchField = c('Sex', 'Age', 'Survived'),

    # how to render the options (each item is a row in Titanic2)
    render = I("{
      option: function(item, escape) {
        return '<div>' + escape(item.Age) + ' (' +
                (item.Sex == 'Male' ? '&male;' : '&female;') + ', ' +
                (item.Survived == 'Yes' ? '&hearts;' : '&odash;') + ')' +
               '</div>';
      }
    }")
  )),

  verbatimTextOutput('row'),
  title = 'Using options groups for server-side selectize input'
)


