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
  uiOutput('my_ticker'),
  uiOutput('datetime')
)

server <- function(input, output, session) {
  sp500 <- get_sp500()
  setorder(sp500, -market_cap_basic)
  output$my_ticker <- renderUI({
    selectInput('stock_id', 'Select a stock', setNames(sp500$name, sp500$description), selected = 'TSLA', multiple = FALSE)
    })
  output$datetime <- renderUI({
    dateRangeInput('date', 'Choose the Date Range', start = NULL, end = NULL, min = NULL, max = NULL, format = "yyyy-mm-dd", startview = "month", weekstart = 0, language = "en", separator = " to ")})
  
}

shinyApp(ui, server)