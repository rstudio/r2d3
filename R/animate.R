#' Render Data with D3
#'
#' Renders a data with D3 as an HtmlWidget using a generic D3.js script.
#'
#' @param data A function that provides data to be passed to D3.js script.
#' @param script The 'JavaScript' file containing the D3.js script.
#' @param width The desired width of the widget.
#' @param height The desired height of the widget.
#' @param inject The variable name used to inject data into a D3 script.
#' @param version The D3 version to use.
#' @param interval The animation inverval in milliseconds.
#'
#' @import htmlwidgets
#' @import shiny
#' @import miniUI
#' 
#' @export
d3_animate <- function(
  data = function() floor(runif(6, 1, 40)),
  script = system.file("samples/barchart-animation.js", package = "d3"),
  width = NULL,
  height = NULL,
  inject = "data",
  version = "5.0.0",
  interval = 1000
) {
  ui <- miniPage(
    gadgetTitleBar("D3"),
    miniContentPanel(
      d3_shiny_output("d3")
    )
  )
  
  server <- function(input, output, session) {
    output$d3 <- d3_shiny_render(
      d3_render(data(), script, width, height, inject, version)
    )
    
    observeEvent(input$done, {
      stopApp()
    })
    
    invalidator <- reactiveTimer(interval)
    
    observe({
      invalidator()
      session$sendCustomMessage(type = "d3_update", list(
        data = data()
      ))
    })
  }
  
  runGadget(ui, server)
}