# Install these packages once:
# install.packages("shiny")
# install.packages("readxl")
# install.packages("ggplot2")
# install.packages("dplyr")

library(shiny)
library(readxl)
library(ggplot2)
library(dplyr)

# ---------------- UI ----------------
ui <- fluidPage(
  titlePanel("Simple Data Analysis Project (Excel Support)"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput(
        "file",
        "Upload Excel File (.xlsx)",
        accept = c(".xlsx")
      )
    ),
    
    mainPanel(
      tableOutput("data_preview"),
      verbatimTextOutput("summary_output"),
      plotOutput("plot_output")
    )
  )
)

# ---------------- SERVER ----------------
server <- function(input, output) {
  
  data <- reactive({
    req(input$file)
    read_excel(input$file$datapath)   # <-- WORKS FOR EXCEL
  })
  
  output$data_preview <- renderTable({
    head(data())
  })
  
  output$summary_output <- renderPrint({
    summary(data())
  })
  
  output$plot_output <- renderPlot({
    df <- data()
    numeric_cols <- sapply(df, is.numeric)
    
    if (any(numeric_cols)) {
      colname <- names(df)[numeric_cols][1]
      ggplot(df, aes_string(x = colname)) +
        geom_histogram(bins = 20)
    }
  })
}

# ---------------- APP ----------------
shinyApp(ui = ui, server = server)
