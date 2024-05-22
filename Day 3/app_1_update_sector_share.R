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


######################################################################
########              Source the functions                    ########
######################################################################

source('functions.R')


######################################################################
########             dashboardPage                            ########
######################################################################

ui <-dashboardPage(
  dashboardHeader(title = 'Stock browser'),
  
  dashboardSidebar(
    sidebarMenu(
      h5('sidebar'),
      uiOutput('sector_out'),
      uiOutput('my_ticker'),
      dateRangeInput('my_date', 'Select date', start = Sys.Date()-1000, end = Sys.Date() ),
      menuItem("Plot", tabName = "plot", icon = icon("dashboard")),
      menuItem("Ggplot", tabName = "ggplot", icon = icon("dashboard")),
      menuItem("Data", tabName = "data", icon = icon("th"))
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "plot",
              plotlyOutput('data_plot')
      ),
      tabItem(tabName = "data",
              tableOutput('table_out')
      ),
      tabItem(tabName = 'ggplot',
              plotOutput('simple_plot')
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
  
  ######################################################################
  ########             ggplot output                            ########
  ######################################################################
  
  output$sector_out <- renderUI({
    selectInput('sector', 'Select a sector', choices = unique(sp500$sector), selected = unique(sp500$sector)[1], multiple = TRUE)
  })
  
  observeEvent(input$sector,{
    
    selected_data <- sp500[sp500$sector %in% input$sector, ]
    
    updateSelectInput(session = session, inputId = "stock_id", 
                      choices = setNames(selected_data$name, selected_data$description),
                      selected = NULL) 
    
  })
  
}



shinyApp(ui, server)