#' Render Data with D3
#'
#' Renders a data with D3 as an HtmlWidget using a generic D3.js script.
#'
#' @param data The data to be passed to D3.js script.
#' @param script The 'JavaScript' file containing the D3.js script.
#' @param width The desired width of the widget.
#' @param height The desired height of the widget.
#' @param inject The variable name used to inject data into a D3 script.
#' @param version The D3 version to use.
#'
#' @import htmlwidgets
#'
#' @export
d3_render <- function(
  data = floor(runif(6, 1, 40)),
  script = system.file("samples/barchart-variable.js", package = "d3"),
  width = NULL,
  height = NULL,
  inject = "data",
  version = "5.0.0")
{
  
  if (!file.exists(script))
    stop("File ", script, " does not exist.")
  
  # convert to data frames
  df <- data
  if (!is.data.frame(df)) {
    df <- as.data.frame(df)
    if (length(row.names(df)) > 0 && !"names" %in% colnames(df)) {
      df$names <- rownames(df)
    }
  }

  # forward options using x
  x <- list(
    data = data
  )
  
  wrapped_script <- d3_wrap_script(script, inject)

  # create widget
  htmlwidgets::createWidget(
    name = 'd3',
    x,
    width = width,
    height = height,
    package = 'd3',
    dependencies = list(
      htmltools::htmlDependency(
        name = "d3",
        version = version,
        src = system.file(file.path("d3", version), package = "d3"),
        script = "d3.js"
      ),
      htmltools::htmlDependency(
        name = "d3-rendering",
        version = "1.0.0",
        src = dirname(wrapped_script),
        script = basename(wrapped_script)
      )
    )
  )
}
