library(datasets)

function(input, output) {
  ## for the sidebarPanel
  observe({
    if (as.logical(input$sanitize) == TRUE) {
      options(shiny.sanitize.errors = TRUE)
    } else {
      options(shiny.sanitize.errors = FALSE)
    }
  })
  
  output$code <- renderText({ 
    paste0("<code>options(shiny.sanitize.errors = ", 
           as.logical(input$sanitize), ")</code>")
  })
  
  ## for the "Basic Usage" tab
  output$intentionalError <- renderText({
    input$sanitize
    stop('top secret info')
  })
  
  output$accidentalError <- renderText({
    input$sanitize
    n <- input$nTab1
    return(if (is.numeric(n)) n*100 else as.character(n)*100)
  })
  
  ## for the "Using safeError()" tab
  output$safeErrorIntentionalError <- renderText({
    input$sanitize
    stop(safeError('the user should see this no matter what'))
  })
  
  output$safeErrorAccidentalError <- renderText({
    input$sanitize
    n <- input$nTab2
    # do the checks you need (in this case: is it multipliable?)
    return(tryCatch(if (is.numeric(n)) n*100 else as.character(n)*100,
                    error = function(e) stop(safeError(e)) ))
  })
  
  observeEvent(input$show, {
    showNotification(
      HTML("The attentive reader will notice that the actual code",
           "used in <code>server.R</code> is a little more",
           "complicated than the one above. This is because R is",
           "slightly inconsistent when it comes to erroring out if",
           "binary operators are involved. In particular,", 
           "<code>NA * 100</code> returns <code>NA</code>, whereas",
           "<code>as.character(NA) * 100</code> throws an error",
           "(even though <code>is.na(as.character(NA))</code>", 
           "returns <code>TRUE</code>).<br>So, for ease of", 
           "readability, the code above just assumes that the",
           "<code>*</code> operator will always throw an error",
           "when one of the arguments is not strictly a number. But",
           "to actually make this happen, the code in",
           "<code>server.R</code> needs to coerce non-numeric",
           "arguments to character ones."), 
      duration = NULL, type = "message")
  })
  
  ## for the "Other errors" tab
  datasetInput <- reactive({
    switch(input$dataset,
           "rock" = rock,
           "pressure" = pressure,
           "cars" = cars)
  })
  output$tab <- renderTable({ head(datasetInput(), n = 6) })
  
  output$downloadData <- downloadHandler(
    filename = function() { paste(input$dataset, ".csv", sep="") },
    content = function(file) { 
      safe <- as.logical(input$safe)
      f <- if (safe) function(e) stop(safeError(e)) else stop
      write.csv(tryCatch(datasetInpute(), error = f)) 
    }
  )
}


fluidPage(
  tags$style(HTML("#shiny-notification-panel { width: 450px; }
                  .shiny-notification { opacity: 0.95; }
                  h2 { padding-left: 15px; }")),
  
  h2("Error Sanitization Demo"),
  br(),
  sidebarPanel(
    radioButtons("sanitize", "Sanitize errors?", 
                 c(TRUE, FALSE), FALSE, inline = TRUE),
    hr(),
    p("Somewhere in you app, insert: "),
    htmlOutput("code")
  ),
  mainPanel(
    tabsetPanel(
      tabPanel("Basic Usage", 
        br(),
        HTML("Let's say you have a",
             "<code>stop('top secret info')</code>", 
             "somewhere in your code that contains some", 
             "sensitive information. Toggle between sanitized and", 
             "unsanitized errors to see what error message is", 
             "displayed to the user in each scenario:"),
        br(), br(),
        textOutput("intentionalError"),
        hr(),
        HTML("Even if you're not using a <code>stop()</code> in",
             "your own code, you're probably relying on code that",
             "does. For example, see what happens when the input",
             "field below is blank (enter a number to see its",
             "normal behavior):"),
        br(), br(),
        numericInput("nTab1", "Enter a number", NA),
        "If you multiply your number by 100, you get: ",
        textOutput("accidentalError", inline = TRUE),
        br(), br(),
        p("In this case, the unsanitized error doesn't seem to",
          "reveal any sensitive information. However, in less",
          "trivial examples, the error message may contain things",
          "like the path to a file or names of databases. If you",
          "sanitize errors, you can rest assured that no sensitive",
          "information will ever be leaked through error messages.",
          "This can be especially useful in cases for which you did", 
          "not foresee that a particular error could occur (maybe", 
          "because the user entered a very strange input or a", 
          "dependency failed).")
        ), 
      
      tabPanel("Using safeError()", 
        br(),
        HTML("What if you do want to sanitize most of your errors",
             "but, for a couple of cases, you actually want to use",
             "an error message to let the user know what went wrong?",
             "In that situation, keep",
             "<code>options(shiny.sanitize.errors = TRUE)</code>",
             "and instead of <code>stop(e)</code> (with <code>e</code>",
             "being either an error or a string), use",
             "<code>stop(safeError(e))</code> to create your error", 
             "messages. Wrapping your error in <code>safeError()</code>", 
             "basically declares that it is safe for the user to see", 
             "and therefore it doesn't need to be sanitized.<br><br>", 
             "For example, if you have a <code>stop(safeError('the", 
             "user should see this no matter what')</code> somewhere", 
             "in your code, it doesn't matter whether or not you're", 
             "sanitizing errors: the user will always see the same", 
             "error message:"),
        br(), br(),
        textOutput("safeErrorIntentionalError"),
        hr(),
        HTML("If you want to use <code>safeError()</code> to show an",
             "error that does not originate in your own code (but",
             "in code you rely on), it gets a tiny bit trickier.",
             "Because you are not throwing the error yourself, you'll",
             "first need to catch it using <code>tryCatch()</code>.",
             "Through this function, you can then rethrow it to",
             "<code>safeError()</code> as desired. Using the example", 
             "from the 'Basic Usage' tab, here's what you'd need to", 
             "have inside your <code>renderText()</code> function:",
             "<br><br><code>return(tryCatch(input$n * 100, error =",
             "function(e) stop(safeError(e))))</code>"),
        br(), br(),
        numericInput("nTab2", "Enter a number", NA),
        "If you multiply your number by 100, you get:",
        textOutput("safeErrorAccidentalError", inline = TRUE),
        br(), br(),
        HTML("Notice a discrepancy between the code used above and", 
             "the one in the <code>server.R</code> code?"),
        actionLink("show", "Click here to learn more", 
                   style="display: inline-block;")
        ),

      tabPanel("Other errors", 
        br(),
        HTML("This error hiding mechanism also applies to less common",
             "errors. For example, if you have a syntax error in your",
             "<code>ui.R</code>; or if your", 
             "<code>downloadHandler()</code> function has a bug.",
             "Because these errors do not go through the websockets", 
             "set up by Shiny, they are handled differently (they", 
             "open up a new window that just displays the error",
             "message). Still, for our purposes, you can sanitize", 
             "them in the exact same way as before. You can also", 
             "use <code>safeError()</code>.",
             "<br><br>Let's say you want to give your users the", 
             "ability to download a dataset. But in the",
             "<code>downloadHandler()</code> function, you mispelled",
             "the name of the function that fetches the data (you",
             "wrote <code>datasetInpute()</code> instead of",
             "<code>datasetInput()</code>). Toggle between sanitized", 
             "and unsanitized errors and then click on the 'Download'",
             "button to see what error message is displayed to the", 
             "user in each scenario (you can also make it a",
             "<code>safeError</code> if you wish):"),
        hr(),
        fluidRow(
          column(4,
            radioButtons("dataset", "Data:", 
                        c("rock", "pressure", "cars")),
            radioButtons("safe", "Safe error?", 
                        c(TRUE, FALSE), FALSE, inline = TRUE),
            br(),
            tags$div(class = "text-center",
                    downloadButton('downloadData', 'Download', 
                                   class = "btn-primary"))),
          column(8,
            tableOutput("tab"))
        )
      )
    )
  )
)


