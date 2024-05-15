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
library(shiny)

source("functions.R")

ui <- fluidPage(
  h1('Stock screener'),
  uiOutput('my_ticker')
)

server <- function(input, output, session) {
  sp500 <- get_sp500()
  output$my_ticker <- renderUI({
    selectInput('stock_id', 'Select a stock', c('TSLA','AMD'), selected = 'TSLA', multiple = FALSE)})
  
}

shinyApp(ui, server)