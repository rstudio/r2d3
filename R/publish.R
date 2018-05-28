

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
#' 
#' @examples
#' library(r2d3)
#' viz <- r2d3(data=c(0.3, 0.6, 0.8, 0.95, 0.40, 0.20), script = "barchart.js")
#' save_d3_html(viz, file = tempfile(fileext = ".html"))
#' 
#' @seealso [save_d3_png()]
#' 
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

#' Save a D3 visualization as a PNG image
#'
#' Save a D3 visualization to PNG (e.g. for including in another document).
#'
#' @details PNG versions of D3 visualizations are created by displaying them in
#'   an offscreen web browser and taking a screenshot of the rendered web page.
#'
#'   Using the `save_d3_png()` function requires that you install the
#'   \pkg{webshot} package, as well as the phantom.js headless browser (which
#'   you can install using the function `webshot::install_phantomjs()`).
#'
#' @inheritParams save_d3_html
#'
#' @param width	Image width
#' @param height Image height
#' @param delay Time to wait before taking screenshot, in seconds. Sometimes a
#'   longer delay is needed for all assets to display properly.
#' @param zoom A number specifying the zoom factor. A zoom factor of 2 will
#'   result in twice as many pixels vertically and horizontally. Note that
#'   using 2 is not exactly the same as taking a screenshot on a HiDPI (Retina)
#'   device: it is like increasing the zoom to 200 doubling the height and
#'   width of the browser window. This differs from using a HiDPI device
#'   because some web pages load different, higher-resolution images when they
#'   know they will be displayed on a HiDPI device (but using zoom will not
#'   report that there is a HiDPI device).
#'   
#' @seealso [save_d3_html()]
#'   
#' @export
save_d3_png <- function(d3, file, background = "white", width = 992, height = 744, delay = 0.2, zoom = 1) {
  tmp_html <- tempfile("save_d3_png", fileext = ".html")
  on.exit(unlink(tmp_html))
  save_d3_html(d3, file = tmp_html, background = background)
  if (requireNamespace("webshot", quietly = TRUE)) {
    webshot::webshot(tmp_html, file, vwidth = width, vheight = height, delay = delay, zoom = zoom)
  } else {
    stop("The webshot package is required to save D3 visualizations to PNG files.")
  }
  invisible(file)
}