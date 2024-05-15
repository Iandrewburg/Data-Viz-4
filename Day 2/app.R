library(shiny)
library(jsonlite)
library(data.table)
library(httr)
library(rtsdata)
library(DT)
library(TTR)
library(plotly)
library(dygraphs)
library(shinythemes)
library(shinydashboard)


source("functions.R")

# ui <- fluidPage(
#   h1('Stock Screener'),
#   sidebarLayout(
#     sidebarPanel(
#       uiOutput('my_ticker'),
#       dateRangeInput('my_date', 'Select date', start = Sys.Date()-1000, end = Sys.Date()),
#     ),
#     mainPanel(
#       tabsetPanel(
#         tabPanel('panel', plotlyOutput('data_plot')),
#         tabPanel('ggplot', plotlyOutput('simple_plot')),
#         tabPanel('data', tableOutput('table_out'))
#       )
#     )
#   )
# )

ui <- fluidPage(
  tabsetPanel(
    tabPanel('control', uiOutput('my_ticker'), dateRangeInput('my_date', 'Select date', start = Sys.Date()-1000, end = Sys.Date())),
    tabPanel('plot', plotlyOutput('data_plot'), plotlyOutput('simple_plot')),
    tabPanel('data', tableOutput('table_out'))
    
  )
  
  
)


server <- function(input, output, session) {
  sp500 <- get_sp500()
  sp500_dates <- get_data_by_ticker_and_date(sp500$name, start_date = Sys.Date()-1000, end_date = Sys.Date())
  setorder(sp500, -market_cap_basic)
  output$my_ticker <- renderUI({
    selectInput('stock_id', 'Select a stock', setNames(sp500$name, sp500$description), selected = 'TSLA', multiple = FALSE)
    })
  
  observeEvent(input$stock_id, {
    print(input$my_date)
    print(input$stock_id)
  })
  
  my_reactive_df <- reactive({
    get_data_by_ticker_and_date(input$stock_id, start_date = input$my_date[1], end_date = input$my_date[2])
    
  })
  
  output$table_out <- renderTable({
    my_reactive_df()
  })
  
  output$data_plot <- renderPlotly({
    get_plot_of_data(my_reactive_df())
  })
  
  output$simple_plot <- renderPlotly({
    ggplotly(get_ggplot_plot(my_reactive_df()))
  })
  
}

shinyApp(ui, server)