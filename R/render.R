#' Render Data with D3
#'
#' Renders data with D3 as an HtmlWidget using a D3.js script.
#'
#' @param data Data to be passed to D3 script.
#' @param script 'JavaScript' file containing the D3 script.
#' @param options Options to be passed to D3 script.
#' @param container The 'HTML' container of the D3 output.
#' @param version Major D3 version to use, the latest minor version
#'   is automatically picked.
#' @param dependencies Additional javascript or css dependencies.
#' @param width Desired width for output widget.
#' @param height Desired height for output widget.
#' @param sizing Widget sizing policy (see [htmlwidgets::sizingPolicy]).
#' @param viewer "internal" to use the RStudio internal viewer pane for 
#'   output; "external" to display in an external RStudio window;
#'   "browser" to display in an external browser.
#'
#' @import htmlwidgets
#' @import tools
#'
#' @export
r2d3 <- function(
  data,
  script,
  options = NULL,
  container = "svg",
  version = c("5", "4", "3"),
  dependencies = NULL,
  width = NULL,
  height = NULL,
  sizing = default_sizing(width, height),
  viewer = c("internal", "external", "browser")
  )
{
  if (!is.null(dependencies)) {
    dependencies <- list(
      js = Filter(function(e) !identical(file_ext(e), "css"), dependencies),
      css = Filter(function(e) identical(file_ext(e), "css"), dependencies)
    )
  }
  
  # resolve version
  version <- match.arg(as.character(version), choices = c("5", "4", "3"))
  
  # convert to d3 data
  data <- as_d3_data(data)
  
  # determine type
  type <- class(data)[[1]]
  
  # forward options using x
  x <- list(
    data = data,
    type = type,
    container = container,
    options = options,
    script = script_wrap(
      script_read(c(dependencies$js, script)),
      container
    ),
    style = script_read(dependencies$css),
    version = as.integer(version)
  )
  
  # resolve viewer if it's explicitly specified
  if (!missing(viewer)) {
    viewer <- match.arg(viewer)
    if (viewer != "internal") {
      sizing$viewer$suppress <- TRUE
      sizing$browser$external <- viewer == "browser"
    }
  }
  
  # create widget
  htmlwidgets::createWidget(
    name = 'r2d3',
    x,
    width = width,
    height = height,
    package = 'r2d3',
    dependencies = list(d3_dependency(version)),
    sizingPolicy = sizing
  )
}

#' Default sizing policy for r2d3 widgets
#' 
#' @param width Desired width for output widget.
#' @param height Desired height for output widget.
#' 
#' @details Use [htmlwidgets::sizingPolicy()] to specify an
#'   alternate policy.
#' 
#' @keywords internal
#' @export
default_sizing <- function(width = NULL, height = NULL) {
  htmlwidgets::sizingPolicy(
    browser.fill = TRUE,
    defaultWidth = if (is.null(width)) NULL else "auto",
    defaultHeight = if (is.null(height)) NULL else "auto",
    knitr.figure = if (!is.null(width) || !is.null(height)) FALSE else TRUE
  )
}





