# This app lets you play around with Shiny's improved `renderTable()` function. All arguments are intially set to their default values (the code chunk under the table illustrates this by omitting the arguments if they are set to their default value). A few noteworthy points:
# 
# - The first three datasets are actual datasets found in the `datasets` package. The last one (`mock`) provides you with different classes of variables (like strings and booleans), 'stringy' rownames and a few missing values to test the inputs with.
# 
# - `width` can take in any valid CSS unit of length. If a unit (like 'px', '%', 'em') is not specified, then 'px' is assumed.
# 
# - If `align` is set to `NULL`, then all numeric/integer columns (including the row names, if they are numbers) will be right-aligned and everything else will be left-aligned (`align = '?'` produces the same result). You can also specify a global alignment that will apply to all columns; for example, `align = 'c'` makes all columns centered. For finer control, you can also specify the alignment for each column, with the *i*-th character specifying the alignment for the *i*-th column (remember to include the alignment for the row names if the argument `rownames` is set to `TRUE`). In this case, besides `'l'`, `'c'` and `'r'`, `'?'` is also permitted - `'?'` is a placeholder for that particular column, indicating that it should keep its default alignment.
# 
# - `digits` specifies the number the decimal places for the numeric columns (notice that this will not apply to columns with an integer class). If `digits` is set to a negative value, then the numeric columns will be displayed in scientific format with a precision of `abs(digits)` digits.

library(datasets)

# Create a mock dataset with the three main types of variables 
# (numeric, strings and booleans), "stringy" row.names and a 
# few missing values for the user to test the renderTable() 
# inputs with
mock <- data.frame(v1 = c(    1,    2,    NA,   9,   NaN,   7 ),
                   v2 = c(  "a",  "b",   "c", "d",   "e",  NA ),
                   v3 = c( TRUE, TRUE, FALSE,  NA, FALSE, TRUE)) 
row.names(mock) <- c("uno", "dos", "tres", "cuatro", "cinco", "seis")


function(input, output, session) {
  # Source the code printing functions to improve readibility
  source("check_valid.R", local=TRUE)
  source("code_printing.R", local = TRUE)
  
  datasetInput <- reactive({
    switch(input$dataset,
           "rock" = rock,
           "pressure" = pressure,
           "cars" = cars,
           "mock" = mock)
  })
  
  # Dynamically create the `align` options, so that it displays
  # three options with the number of columns of the current
  # dataset selected (+1 for the row.names if `rownames`=TRUE)
  output$pre_align <- renderUI({
    choices <- c("NULL", "?", "c", "l")
    size <- { 
      if (as.logical(input$rownames)) ncol(datasetInput())+1 
      else ncol(datasetInput()) }
    choices <- c(choices, 
                 paste(sample(c("l", "c", "r", "?"), size = size, 
                              replace = TRUE), collapse = ""),
                 paste(sample(c("l", "c", "r", "?"), size = size, 
                              replace = TRUE), collapse = ""),
                 paste(sample(c("l", "c", "r", "?"), size = size, 
                              replace = TRUE), collapse = ""))
    selectInput("align", "Column alignment:", choices, "NULL")
  })
  
  # Display the resulting table
  output$view <- renderTable({
    head(datasetInput(), n = input$obs)}, 
    striped = striped,
    bordered = bordered,
    hover = hover,
    spacing = spacing,
    width = width,
    rownames = rownames,
    colnames = colnames,
    align = align,
    digits = digits,
    na = na
    )
  
  # Display the corresponding code for the user to generate
  # the current table in their own Shiny app
  output$code <- renderText({
    paste0( "in <strong>ui.R</strong>: "    , 
            "<br><code>tableOutput('tbl')</code><br><br>",
            "in <strong>server.R</strong>: ", 
            "<br><code>output$tbl <- ", 
            "renderTable({ head( ", dataset(), 
            ", n = ", obs(), " )}", 
            striped_code(), bordered_code(), 
            hover_code(), spacing_code(),
            width_code(), align_code(),
            rownames_code(), colnames_code(), 
            digits_code(), na_code(),
            ")&nbsp;&nbsp;</code>"
    )
  })
}


fluidPage(
  fluidRow(
    column(12,
      h2("Shiny Table Demo"),
      fluidRow(
        column(4,
          h3("Inputs"),
          hr(),
          fluidRow(
            column(6, selectInput("dataset", "Data:", 
                        c("rock", "pressure", "cars", "mock"))),
            column(6,numericInput("obs", "Rows:", 6))
          ),
          br(),
          fluidRow(
            column(6, checkboxGroupInput("format", "Options:",
                        c("striped", "bordered", "hover"))),
            column(6, radioButtons("spacing", "Spacing:",
                        c("xs", "s", "m", "l"), "s"))
          ),
          br(),
          fluidRow(
            column(6, selectInput("width", "Width:",
                        c("auto", "100%", "75%",
                          "300", "300px", "10cm"), "auto")),
            column(6, uiOutput("pre_align"))
          ),
          br(),
          fluidRow(
            column(6, radioButtons("rownames", "Include rownames:",
                        c("T", "F"), "F", inline=TRUE)),
            column(6, radioButtons("colnames", "Include colnames:",
                        c("T", "F"), "T", inline=TRUE))
          ),
          br(),
          fluidRow(
            column(6, selectInput("digits", "Number of decimal places:",
                        c("NULL", "3", "2", "0", "-2", "-3"))),
            column(6, selectInput("na", "String for missing values:",
                        c("NA", "missing", "-99"), "NA"))
          )
        ),
        column(7, offset=1,
          h3("Table and Code"),
          br(),
          tableOutput("view"),
          br(),
          h4("Corresponding R code:"),
          htmlOutput("code")
        )
      )
    )
  )
)


