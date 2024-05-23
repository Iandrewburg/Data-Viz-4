library(sf)
library(shiny)
library(shinydashboard)
library(rsconnect)

ui <- dashboardPage(
  dashboardHeader(title = 'Leaflet'),
  dashboardSidebar(),
  dashboardBody(
    leafletOutput("austriamap"),
    textOutput("map_clicked"),
    textOutput("map_mouse_over")

  )
)

server <- function(input, output, session) {

  austria <- st_read("https://raw.githubusercontent.com/ginseng666/GeoJSON-TopoJSON-Austria/master/2021/siedlungseinheiten/siedlungseinheiten_75_geo.json")

  output$austriamap <- renderLeaflet({
    
    leaflet(austria) %>%
      addTiles() %>%
      addPolygons(label = ~name, layerId = ~name)
    
    
  })
  
  output$map_clicked <- renderText({input$austriamap_shape_click$id})
  output$map_mouse_over <- renderText({input$austriamap_shape_mouseover$id})
}

shinyApp(ui, server)