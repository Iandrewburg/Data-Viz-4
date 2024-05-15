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
  selectInput('stock_id', 'Select a stock', c('TSLA','AMD'), selected = 'TSLA', multiple = FALSE)
  
)

server <- function(input, output, session) {
  sp500 <- get_sp500()
  print(head(sp500))
  
}

shinyApp(ui, server)