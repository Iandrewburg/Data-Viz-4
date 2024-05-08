library(shiny)
library(particlesjs)

ui <- basicPage(
  tags$head(tags$link(rel = "stylesheet", 
                      type = "text/css", 
                      href = "app.css")),
  particles(),
  actionButton("setting_show", "Settings"),
  div(
    h1(uiOutput('title')),
    h2(uiOutput('subtitle')),
    h2(uiOutput('starts_in')),
    uiOutput('time'),
    class = "center")
)