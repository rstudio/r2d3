

#' Save a D3 visualization as HTML
#' 
#' Save a D3 visualization to an HTML file (e.g. for sharing with others).
#'
#' @param d3 D3 visualization to save
#' @param file File to save HTML into
#' @param selfcontained Whether to save the HTML as a single self-contained file
#'   (with external resources base64 encoded) or a file with external resources
#'   placed in an adjacent directory.
#' @param libdir Directory to copy HTML dependencies into (defaults to
#'   filename_files).
#' @param background Text string giving the html background color of the widget.
#'   Defaults to white.
#' @param title Text to use as the title of the generated page.
#' @param knitrOptions A list of \pkg{knitr} chunk options.
#' 
#' @importFrom htmlwidgets saveWidget
#' @export
save_d3_html <- function(d3, file, selfcontained = TRUE, libdir = NULL, 
                         background = "white", title = "D3 Visualization", 
                         knitrOptions = list()) {
  saveWidget(
    widget = d3,
    file = file,
    selfcontained = selfcontained,
    libdir = libdir,
    background = background,
    title = title,
    knitrOptions = knitrOptions
  )
}