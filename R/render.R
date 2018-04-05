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
  version = c(5, 4, 3),
  dependencies = NULL,
  width = NULL,
  height = NULL
  )
{
  if (!is.null(dependencies)) {
    dependencies <- list(
      js = Filter(function(e) !identical(file_ext(e), "css"), dependencies),
      css = Filter(function(e) identical(file_ext(e), "css"), dependencies)
    )
  }
  
  if (is.null(container)) container = "svg"
  if (is.null(version)) version <- 5
  
  version <- version[[1]]
  version_long <- version_complete(version)
  
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
    data = data,
    type = class(data)[[1]],
    container = container,
    options = options,
    script = script_wrap(script_read(c(dependencies$js, script)), container),
    style = script_read(dependencies$css),
    version = version
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'r2d3',
    x,
    width = width,
    height = height,
    package = 'r2d3',
    dependencies = list(
      htmltools::htmlDependency(
        name = paste("d3", "-v", version, sep = ""),
        version = version_long,
        src = system.file(file.path("d3", version_long), package = "r2d3"),
        script = "d3.js"
      )
    )
  )
}
