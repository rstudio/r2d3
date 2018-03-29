#' Render Data with D3
#'
#' Renders data with D3 as an HtmlWidget using a D3.js script.
#'
#' @param data The data to be passed to D3 script.
#' @param script The 'JavaScript' file containing the D3 script.
#' @param options The options to be passed to D3 script.
#' @param tag The html tag to create for the D3 script.
#' @param version The major D3 version to use, the latest minor version
#'   is automatically picked.
#' @param dependencies Additional javascript or css dependencies.
#'
#' @import htmlwidgets
#' @import tools
#'
#' @export
r2d3 <- function(
  data,
  script,
  options = NULL,
  tag = "svg",
  version = c(5, 4, 3),
  dependencies = NULL
  )
{
  if (!file.exists(script))
    stop("D3 script '", script, "' does not exist.")
  
  if (!is.null(dependencies)) {
    if (any(!file.exists(dependencies)))
      stop("Not all dependency files exist.")
    
    dependencies <- list(
      js = Filter(function(e) identical(file_ext(e), "js"), dependencies),
      css = Filter(function(e) identical(file_ext(e), "css"), dependencies)
    )
  }
  
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
  
  wrapped_d3 <- script_wrap(script, tag)

  # forward options using x
  x <- list(
    data = data,
    type = class(data)[[1]],
    tag = tag,
    options = options,
    script = script_read(c(wrapped_d3, dependencies$js)),
    styles = script_read(dependencies$css)
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'r2d3',
    x,
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
