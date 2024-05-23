library(shiny)
library(jsonlite)
library(data.table)
library(httr)
library(rtsdata)
library(DT)
library(TTR)
library(plotly)
library(shinythemes)
library(shinydashboard)
library(dygraphs)
library(quantmod) 
library(dygraphs)
library(networkD3)


######################################################################
########              Source the functions                    ########
######################################################################

source('functions.R')
######################################################################
########             dashboardPage template                   ########
######################################################################



######################################################################
########             dashboardPage                            ########
######################################################################

ui <-dashboardPage(
  dashboardHeader(title = 'Stock browser'),
  
  dashboardSidebar(
    sidebarMenu(
      h5('sidebar'),
      uiOutput('my_ticker'),
      dateRangeInput('my_date', 'Select date', start = Sys.Date()-1000, end = Sys.Date() ),
      menuItem("Plot", tabName = "plot", icon = icon("dashboard")),
      menuItem("Ggplot", tabName = "ggplot", icon = icon("dashboard")),
      menuItem('Dygraph', tabName = 'dygraph'),
      menuItem("Data", tabName = "data", icon = icon("th"))
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "plot",
              plotlyOutput('data_plot')
      ),
      tabItem(tabName = "data",
              #tableOutput('table_out')
              tableOutput("table_out")
      ),
      tabItem(tabName = 'ggplot',
              plotOutput('simple_plot')
      ),
      tabItem(tabName = 'dygraph', 
              dygraphOutput("ohlc_dygraph")
      )
    )
  )
)


server <- function(input, output, session) {
  ######################################################################
  ########             data load                                ########
  ######################################################################
  
  sp500 <- get_sp500()
  setorder(sp500, -market_cap_basic)
  
  ######################################################################
  ########             stock dropdown                           ########
  ######################################################################
  
  output$my_ticker <- renderUI({
    selectInput('stock_id', 'Select a stock', setNames(sp500$name, sp500$description) , selected = 'TSLA', multiple = FALSE)
  })
  
  ######################################################################
  ########          reactive df of historical price             ########
  ######################################################################
  
  my_reactive_df <- reactive({
    get_data_by_ticker_and_date(input$stock_id, start_date = input$my_date[1], end_date =input$my_date[2] )
  })
  
  ######################################################################
  ########             table output                             ########
  ######################################################################
  
  output$table_out <- renderTable({
    my_reactive_df()
  })
  
  ######################################################################
  ########             Plotly output                            ########
  ######################################################################
  
  output$data_plot <- renderPlotly({
    get_plot_of_data(my_reactive_df())
  })
  
  ######################################################################
  ########             ggplot output                            ########
  ######################################################################
  
  output$simple_plot <- renderPlot({
    get_ggplot_plot(my_reactive_df())
  })
  
  
  output$ohlc_dygraph <- renderDygraph({
    
    ohlc_xts <- xts(my_reactive_df()[,c("open","high","low", "close")], order.by = as.Date(my_reactive_df()$date))
    graph <- dygraph(OHLC(ohlc_xts))
    return(dyCandlestick(graph))
    
  })

  
}



shinyApp(ui, server)