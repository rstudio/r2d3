

#' D3 HTML dependency
#' 
#' Create an HTML dependency for the D3 library.
#' 
#' @param version Major version of D3
#' 
#' @details Create an HTML dependency for a version of D3. Each version has 
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
#' @export
d3_dependency <- function(version = c("5", "4", "3")) {
  
  # validate version and determine full version number
  version <- match.arg(version)
  version_long <- version_complete(version)
  
  # determine unique name so we can host multiple versions of d3 on a single page
  # note that d3 v3 has no suffix so it can be compatible with existing htmlwidgets
  # that use d3
  name <- "d3"
  if (version != "3")
    name <- paste0(name, "v", version)
  
  # return dependency
  htmlDependency(
    name = name,
    version = version_long,
    src = system.file(file.path("d3", version_long), package = "r2d3"),
    script = "d3.js"
  )
}


