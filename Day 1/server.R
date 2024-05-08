library(shiny)
library(lubridate)



server <- function(input, output) {
  
  settings <- reactiveValues(
    title = 'Data Visualization 4',
    subtitle = 'Building Dashboards',
    starts_in = 'Starts In:',
    schedule = as.POSIXct('2024-05-08 13:30:00') 
  )
  
  output$title <- renderText(settings$title)
  output$subtitle <- renderText(settings$subtitle)
  output$starts_in <- renderText(settings$starts_in)
  output$time <- renderText(as.character({
    invalidateLater(250)
    color <- ifelse(settings$schedule > Sys.time(), "black", "red")
    span(round(as.period(interval(settings$schedule, Sys.time()))),
         style=paste("color", color, sep = ":"))
  }))
  
  observeEvent(input$setting_show, {
    showModal(modalDialog(
      textInput("title", "Title", value = settings$title),
      textInput("subtitle", "Subtitle", value = settings$subtitle),
      footer = tagList(actionButton("settings_update", "Update"))
    ))
  })
  
  observeEvent(input$settings_update, {
    settings$title <- input$title
    removeModal()
  })
}