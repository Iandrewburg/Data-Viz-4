library(shiny)
library(networkD3)
library(rsconnect)ui <- fluidPage(
  simpleNetworkOutput('simple_network_out'),
  forceNetworkOutput(('force_network_out')),
  sankeyNetworkOutput('sankey_network_out')
)server <- function(input, output, session) {  # Create fake data
  src <- c("A", "A", "A", "A",
           "B", "B", "C", "C", "D")
  target <- c("B", "C", "D", "J",
              "E", "F", "G", "H", "I")
  networkData <- data.frame(src, target)  # Plot
  output$simple_network_out <- renderSimpleNetwork({
    simpleNetwork(networkData)
  })  # Load data
  data(MisLinks)
  data(MisNodes)  # Plot
  output$force_network_out <- renderForceNetwork({
    forceNetwork(Links = MisLinks, Nodes = MisNodes,
                 Source = "source", Target = "target",
                 Value = "value", NodeID = "name",
                 Group = "group", opacity = 0.8)
  })  # Load energy projection data
  # Load energy projection data
  URL <- paste0(
    "https://cdn.rawgit.com/christophergandrud/networkD3/",
    "master/JSONdata/energy.json")
  Energy <- jsonlite::fromJSON(URL)
  # Plot
  output$sankey_network_out <- renderSankeyNetwork({
    sankeyNetwork(Links = Energy$links, Nodes = Energy$nodes, Source = "source",
                  Target = "target", Value = "value", NodeID = "name",
                  units = "TWh", fontSize = 12, nodeWidth = 30)
  })}shinyApp(ui, server)