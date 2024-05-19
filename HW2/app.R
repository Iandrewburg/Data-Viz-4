library(shiny)
library(shinydashboard)
library(DT)
library(ggplot2)
library(plotly)
library(dplyr)

source("functions.R")

all_data <- load_data()
all_data <- preprocess_data(all_data)
min_date <- min(all_data$date)
max_date <- max(all_data$date)

ui <- dashboardPage(
  dashboardHeader(title = "Climate Data Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Interactive Plot", tabName = "interactive", icon = icon("dashboard")),
      menuItem("GGPlot", tabName = "ggplot", icon = icon("bar-chart")),
      menuItem("Data Table", tabName = "data", icon = icon("table")),
      dateRangeInput("dateRange", "Select Date Range", min = min_date, max = max_date, start = min_date, end = max_date),
      selectInput("variable", "Choose a Variable", choices = c("meantemp", "humidity", "wind_speed", "meanpressure"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "interactive",
              plotlyOutput("interactivePlot")
      ),
      tabItem(tabName = "ggplot",
              plotOutput("ggplot")
      ),
      tabItem(tabName = "data",
              dataTableOutput("viewDataTable")
      )
    )
  )
)


server <- function(input, output) {
  reactive_data <- reactive({
    data <- all_data
    data <- data[data$date >= input$dateRange[1] & data$date <= input$dateRange[2], ]
    data
  })
  
  output$ggplot <- renderPlot({
    req(input$variable)  # Ensure a variable is selected
    create_ggplot(reactive_data(), "date", input$variable)
  })
  
  output$interactivePlot <- renderPlotly({
    req(input$variable)
    p <- create_ggplot(reactive_data(), "date", input$variable)
    ggplotly(p)
  })
  
  output$viewDataTable <- renderDataTable({
    reactive_data()
  })
}

shinyApp(ui, server)
