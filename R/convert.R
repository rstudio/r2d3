#' Convert object to D3 data
#' 
#' Generic method to transform R objects into D3 friendly data.
#' 
#' @param x data
#' @param ... Additional arguments for generic methods
#' 
#' @details The value returned from `as_d3_data()` should be one of:
#' 
#'   - An R data frame. In this case the `HTMLWidgets.dataframeToD3()`
#'     JavaScript function will be called on the client to transform
#'     the data into D3 friendly (row-oriented) data; or
#'     
#'   - A JSON object created using [jsonlite::toJSON]; or
#'   
#'   - Any other R object which can be coverted to JSON using [jsonlite::toJSON].
#' 
#' @export
as_d3_data <- function(x, ...) {
  UseMethod("as_d3_data")
}

#' @rdname as_d3_data
#' @export
as_d3_data.default <- function(x, ...) {
  x
}
