#' Render Data with D3
#'
#' Renders a data with D3 as an HtmlWidget using a generic D3.js script.
#'
#' @param data The data to be passed to D3.js script, currently only data frames supported.
#' @param script The 'JavaScript' file containing the D3.js script.
#' @param width The desired width of the widget.
#' @param height The desired height of the widget.
#'
#' @import htmlwidgets
#'
#' @export
d3_render <- function(
  data = islands,
  script = system.file("samples/bubbles.js", package = "d3"),
  width = NULL,
  height = NULL,
  version = "5.0.0")
{
  
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
    message = df
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'd3',
    x,
    width = width,
    height = height,
    package = 'd3',
    dependencies = htmltools::htmlDependency(
      "d3",
      version,
      system.file(
        file.path("d3", version),
        package = "d3"
      ),
      script = "d3.js"
    )
  )
}

#' Shiny bindings for d3
#'
#' Output and render functions for using d3 within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a d3
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name d3-shiny
#'
#' @export
d3Output <- function(outputId, width = '100%', height = '400px')
{
  htmlwidgets::shinyWidgetOutput(outputId, 'd3', width, height, package = 'd3')
}

#' @rdname d3-shiny
#' @export
renderD3 <- function(expr, env = parent.frame(), quoted = FALSE)
{
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, d3Output, env, quoted = TRUE)
}
