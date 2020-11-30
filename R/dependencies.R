

#' D3 HTML dependencies
#'
#' Create HTML dependencies for D3 and optional extensions
#'
#' @param version Major version of D3
#' @param extensions D3 extensions to include. Currently the only supported
#'   extension is "jetpack" (<https://github.com/gka/d3-jetpack>).
#'
#' @details Create list of HTML dependencies for D3. Each version has
#'   a distinct root D3 object so it's possible to combine multiple versions
#'   of D3 on a single page. For example, D3 v5 is accessed via `d3v5` and
#'   D3 v4 is accessed via `d3v4`. Note however that D3 v3 is accessed via
#'   simply `d3` (for compabibilty with existing htmlwidgets that use
#'   this form).
#'
#' @note This function is exported for use by htmlwidgets. If you are
#'  using the `r2d3()` function to include D3 code within a document
#'  or application this dependency is included automatically so calling
#'  this function is unnecessary.
#'
#' @importFrom htmltools htmlDependency
#'
#' @examples
#'
#' library(r2d3)
#' r2d3(
#'   data = c (0.3, 0.6, 0.8, 0.95, 0.40, 0.20),
#'   script = system.file("examples/barchart.js", package = "r2d3"),
#'   dependencies = "d3-jetpack"
#' )
#'
#' @export
html_dependencies_d3 <- function(version = c("6", "5", "4", "3"), extensions = NULL) {

  # validate version and determine full version number
  version <- match.arg(version)
  version_long <- version_complete(version)

  # determine unique name so we can host multiple versions of d3 on a single page
  # note that d3 v3 has no suffix so it can be compatible with existing htmlwidgets
  # that use d3
  name <- "d3"
  if (version != "3")
    name <- paste0(name, "v", version)

  # base dependency on d3
  html_dependencies <- list(
    htmlDependency(
      name = name,
      version = version_long,
      src = system.file(file.path("www/d3", version_long), package = "r2d3"),
      script = "d3.min.js"
    )
  )

  # validate extensions
  if (!is.null(extensions) && length(extensions) > 0) {
    # validate valid list of extensions
    extensions <- match.arg(extensions, choices = all_extensions(), several.ok = TRUE)
    # validate jetpack version requirements
    if ("d3-jetpack" %in% extensions && as.integer(version) <= 3)
      stop("d3-jetpack requires d3 version 4 or higher")
  }

  # apply extensions
  append(html_dependencies, lapply(extensions, function(extension) {
    switch(extension,
      `d3-jetpack` = htmlDependency(
        name = "d3-jetpack",
        version = "2.0.9",
        src = system.file("www/d3-jetpack", package = "r2d3"),
        script = "d3-jetpack.js"
      )
    )
  }))
}

all_extensions <- function() {
  c("d3-jetpack")
}
