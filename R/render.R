#' Render Data with D3
#'
#' Renders data with D3 as an HtmlWidget using a D3.js script.
#'
#' @param data The data to be passed to D3 script.
#' @param script The 'JavaScript' file containing the D3 script.
#' @param options The options to be passed to D3 script.
#' @param tag The html tag to create for the D3 script.
#' @param version The D3 version to use.
#' @param dependencies Additional javascript or css dependencies.
#'
#' @import htmlwidgets
#'
#' @export
r2d3 <- function(
  data = floor(runif(6, 1, 40)),
  script = system.file("samples/barchart-variable.js", package = "r2d3"),
  options = NULL,
  tag = "svg",
  version = "5.0.0",
  dependencies = NULL
  )
{
  if (!file.exists(script))
    stop("D3 script '", script, "' does not exist.")
  
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
    tag = tag,
    options = options
  )
  
  wrapped_d3 <- script_wrap(script)

  # create widget
  htmlwidgets::createWidget(
    name = 'r2d3',
    x,
    package = 'r2d3',
    dependencies = list(
      htmltools::htmlDependency(
        name = "d3",
        version = version,
        src = system.file(file.path("d3", version), package = "r2d3"),
        script = "d3.js"
      ),
      htmltools::htmlDependency(
        name = "r2d3-rendering",
        version = "1.0.0",
        src = dirname(wrapped_d3),
        script = basename(wrapped_d3)
      )
    )
  )
}
