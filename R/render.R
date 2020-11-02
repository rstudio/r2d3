#' D3 visualization
#'
#' Visualize data using a custom D3 visualization script
#'
#' @param data Data to be passed to D3 script.
#' @param script JavaScript file containing the D3 script.
#' @param css CSS file containing styles. The default value "auto" will use any CSS file
#'   located alongside the script file with the same stem (e.g. "barplot.css" would be
#'   used for "barplot.js") as well as any CSS file with the name "styles.css".
#' @param options Options to be passed to D3 script.
#' @param container The 'HTML' container of the D3 output.
#' @param elementId Use an explicit element ID for the widget (rather than an
#'   automatically generated one). Useful if you have other JavaScript that needs to
#'   explicitly discover and interact with a specific widget instance.
#' @param d3_version Major D3 version to use, the latest minor version is automatically
#'   picked.
#' @param dependencies Additional HTML dependencies. These can take the form of paths to
#'   JavaScript or CSS files, or alternatively can be fully specified dependencies created
#'   with [htmltools::htmlDependency].
#' @param width Desired width for output widget.
#' @param height Desired height for output widget.
#' @param sizing Widget sizing policy (see [htmlwidgets::sizingPolicy]).
#' @param viewer "internal" to use the RStudio internal viewer pane for output; "external"
#'   to display in an external RStudio window; "browser" to display in an external
#'   browser.
#'
#' @import htmlwidgets
#' @import tools
#'
#' @details
#'
#' In order to scope CSS styles when multiple widgets are rendered, the Shadow DOM and
#' the wecomponents polyfill is used, this feature can be turned off by setting the
#' \code{r2d3.shadow} option to \code{FALSE}.
#'
#' @examples
#'
#' library(r2d3)
#' r2d3(
#'   data = c (0.3, 0.6, 0.8, 0.95, 0.40, 0.20),
#'   script = system.file("examples/barchart.js", package = "r2d3")
#' )
#'
#' @export
r2d3 <- function(
  data,
  script,
  css = "auto",
  dependencies = NULL,
  options = NULL,
  d3_version = c("6", "5", "4", "3"),
  container = "svg",
  elementId = NULL,
  width = NULL,
  height = NULL,
  sizing = default_sizing(),
  viewer = c("internal", "external", "browser")
  )
{
  # allow data to be missing
  if (missing(data))
    data <- c()

  # resolve version
  version <- match.arg(as.character(d3_version), choices = c("6", "5", "4", "3"))

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
      js = Filter(function(e) is.character(e) && identical(file_ext(e), "js"), dependencies),
      css = Filter(function(e) is.character(e) && identical(file_ext(e), "css"), dependencies)
    )
    inline_dependencies$js <- as.character(inline_dependencies$js)
    inline_dependencies$css <- as.character(c(inline_dependencies$css, css))
  }

  # resolve extension dependencies
  extension_dependencies <- as.character(Filter(function(e) is.character(e) && e %in% all_extensions(), dependencies))

  # resolve html dependencies
  html_dependencies <- Filter(function(e) inherits(e, "html_dependency"), dependencies)
  html_dependencies <- append(html_dependencies, html_dependencies_d3(version, extensions = extension_dependencies))

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
      inline_dependencies$js,
      script,
      container
    ),
    style = script_read(inline_dependencies$css),
    version = as.integer(version),
    theme = list(
      default = default_theme(),
      runtime = runtime_theme()
    ),
    useShadow = getOption("r2d3.shadow", TRUE)
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
    elementId = elementId,
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
  htmlwidgets::sizingPolicy(
    browser.fill = TRUE
  )
}

default_theme <- function() {
  getOption(
    "r2d3.theme",
    list(
      background = "#FFFFFF",
      foreground = "#000000"
    )
  )
}

runtime_theme <- function() {
  if (exists(".rs.api.getThemeInfo")) {
    rstudio_default <- get(".rs.api.getThemeInfo")()

    # https://github.com/rstudio/rstudio/issues/4055
    list(
      background = "#FFFFFF",
      foreground = "#000000"
    )
  } else {
    NULL
  }
}