.globals <- new.env(parent = emptyenv())

#' Available D3 Extensions
#' 
#' Provides a data frame of available D3 extensions that can be 
#' used as input to `d3_extension()`.
#' 
#' @param name The name of the extension. Defaults to \code{NULL} to
#'   enumerate all available extensions.
#' @param latest Attempt to retrieve the latest extensions from repo?
#' 
#' @seealso [d3_extension()]
#' 
#' @export
d3_available_extensions <- function(name = NULL, latest = TRUE) {
  if (!exists("d3_extensions_data", envir = .globals))
  {
    if (latest) {
      extensions_data <- tryCatch({
        suppressWarnings(
          read.csv(d3_extensions_url(), stringsAsFactors = FALSE)
        )
      }, error = function(e) {
      })
    }
    
    if (!latest || is.null(extensions_data)) {
      extensions_data <- read.csv(
        system.file(file.path("extdata", "extensions.csv"), package = "r2d3"),
        stringsAsFactors = FALSE
      )
    }
    
    assign("d3_extensions_data", extensions_data, envir = .globals)
  }
  
  extensions_data <- .globals$d3_extensions_data
  
  if (is.null(name))
    extensions_data[, c("name", "description")]
  else
    extensions_data[extensions_data$name == name, ]
}

d3_extensions_url <- function() {
  "https://raw.githubusercontent.com/rstudio/r2d3/master/inst/extdata/extensions.csv"
}

#' D3 Extension
#' 
#' Create a R2D3 dependency from a D3 extension, a list of available
#' extensions can be retrieved using `d3_available_extensions()`.
#' 
#' @param name The name of the D3 extension
#' @param target Target path to download the extension to, defaults to \code{tempdir()}.
#' 
#' @importFrom htmltools htmlDependency
#' 
#' @seealso [d3_available_extensions()]
#' 
#' @export
d3_extension <- function(name, target = tempdir()) {
  extension_info <- d3_available_extensions(name)
  target_file <- file.path(target, basename(extension_info$download))
  
  if (!file.exists(target_file)) {
    download.file(extension_info$download, target_file)
  }
  
  normalizePath(target_file)
}
