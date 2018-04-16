#' D3 visualization
#'
#' Visualize data using a custom D3 visualization script
#'
#' @param data Data to be passed to D3 script.
#' @param script JavaScript file containing the D3 script.
#' @param css CSS file containing styles. The default value "auto" will use
#'   any CSS file located alongside the script file with the same stem 
#'   (e.g. "barplot.css" would be used for "barplot.js") as well as any
#'   CSS file with the name "styles.css".
#' @param options Options to be passed to D3 script.
#' @param container The 'HTML' container of the D3 output.
#' @param d3_version Major D3 version to use, the latest minor version
#'   is automatically picked.
#' @param dependencies Additional HTML dependencies. These can take the 
#'   form of paths to JavaScript or CSS files, or alternatively can be
#'   fully specified dependencies created with [htmltools::htmlDependency].
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
  css = "auto",
  dependencies = NULL,
  options = NULL,
  d3_version = c("5", "4", "3"),
  container = "svg",
  width = NULL,
  height = NULL,
  sizing = default_sizing(),
  viewer = c("internal", "external", "browser")
  )
{
  # resolve version
  version <- match.arg(as.character(d3_version), choices = c("5", "4", "3"))
  
  # auto-detect css styles
  if (identical(css, "auto")) {
    # auto-detect based on js filename and "styles.css"
    css_paths <- c(paste0(tools::file_path_sans_ext(script), ".css"),
                   file.path(dirname(script), "styles.css"))
    css <- css_paths[file.exists(css_paths)]
    if (length(css) == 0)
      css <- NULL
  }
  
  # resolve inline dependencies
  inline_dependencies <- NULL
  if (!is.null(dependencies) || !is.null(css)) {
    
    # force dependencies to list if necessary
    if (inherits(dependencies, "html_dependency"))
      dependencies <- list(dependencies)
    
    inline_dependencies <- list(
      js = Filter(function(e) is.character(e) && !identical(file_ext(e), "css"), dependencies),
      css = Filter(function(e) is.character(e) && identical(file_ext(e), "css"), dependencies)
    )
    inline_dependencies$js <- as.character(inline_dependencies$js)
    inline_dependencies$css <- as.character(c(inline_dependencies$css, css))
  }
  
  # resolve html dependencies
  html_dependencies <- Filter(function(e) inherits(e, "html_dependency"), dependencies)
  html_dependencies <- append(html_dependencies, list(html_dependency_d3(version)))

  # convert to d3 data
  data <- as_d3_data(data)
  
  # determine type
  type <- if (inherits(data, "data.frame")) "data.frame" else class(data)[[1]]
  
  # forward options using x
  x <- list(
    data = data,
    type = type,
    container = container,
    options = options,
    script = script_wrap(
      script_read(c(inline_dependencies$js, script)),
      container
    ),
    style = script_read(inline_dependencies$css),
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
    dependencies = html_dependencies,
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





