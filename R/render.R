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
#' @param sizing The default 'HtmlWidgets' sizing policy.
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
  sizing = default_sizing()
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
  if (is.data.frame(data)) {
    type <- "data.frame"
  } else if (inherits(data, "json")) {
    type <- "json"
  } else {
    stop("D3 data must be either JSON or an R object convertable to a data frame.")
  }
  
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
#' @details Use [htmlwidgets::sizingPolicy()] to specify an
#'   alternate policy.
#' 
#' @keywords internal
#' @export
default_sizing <- function() {
  htmlwidgets::sizingPolicy(browser.fill = TRUE)
}





