# 这个例子展示了Shiny应用中的中文字符。多字节字符在Windows上一直都是让人头疼的问题，因为Windows不像Linux或苹果系统那样统一使用UTF-8编码，而是有自己的成百上千种编码，不同的系统语言环境有不同的默认字符编码，每次涉及到多字节字符的读写问题的时候，开发者或用户都要问自己一个问题：我应该用什么编码？从shiny版本0.10.1开始，我们强制跟shiny应用有关的文件都使用UTF-8编码，包括ui.R / server.R / global.R / DESCRIPTION / README.md文件（不是所有文件都是shiny应用必需的）。如果你使用RStudio编辑器，你可以从菜单File -> Save with Encoding选择UTF-8编码保存你的shiny应用文件。
# 
# If you do not understand Chinese, please take a look at [this article](http://shiny.rstudio.com/articles/unicode.html).
# 

library(datasets)

# 定义服务器逻辑
function(input, output) {

  cars2 <- cars
  cars2$random <- sample(
    strsplit("随意放一些中文字符", "")[[1]], nrow(cars2), replace = TRUE
  )

  # 返回数据集，注意input$dataset返回的结果可能是中文“岩石”
  datasetInput <- reactive({
    if (input$dataset == "岩石") return(rock2)
    if (input$dataset == "pressure") return(pressure)
    if (input$dataset == "cars") return(cars2)
  })

  output$rockvars <- renderUI({
    if (input$dataset != "岩石") return()
    selectInput("vars", "从岩石数据中选择一列作为自变量", names(rock2)[-1])
  })

  output$rockplot <- renderPlot({
    validate(need(input$vars, ""))
    par(mar = c(4, 4, .1, .1))
    plot(as.formula(paste("面积 ~ ", input$vars)), data = rock2)
  })

  # 数据概要信息
  output[['summary这里也可以用中文']] <- renderPrint({
    if (!input$summary) return(cat("数据概要信息被隐藏了！"))
    dataset <- datasetInput()
    summary(dataset)
  })

  # 显示前"n"行数据
  output$view <- renderTable({
    head(datasetInput(), n = input$obs)
  })
}


# 定义用户界面
fluidPage(

  # 标题
  titlePanel("麻麻再也不用担心我的Shiny应用不能显示中文了"),

  # 侧边栏布局
  sidebarLayout(
    sidebarPanel(
      selectInput("dataset", "请选一个数据：",
                  choices = c("岩石", "pressure", "cars")),

      uiOutput("rockvars"),

      numericInput("obs", "查看多少行数据？", 5),

      checkboxInput("summary", "显示概要", TRUE)
    ),

    # 展示一个HTML表格
    mainPanel(
      conditionalPanel("input.dataset === '岩石'", plotOutput("rockplot")),

      verbatimTextOutput("summary这里也可以用中文"),

      tableOutput("view")
    )
  )
)


