#' Convert object to D3 data
#' 
#' Generic method to transform R objects into D3 friendly data.
#' 
#' @param x data
#' @param ... Additional arguments for generic methods
#' 
#' @details The value returned from `as_d3_data()` should be one of:
#' 
#'   - An R data frame or an R object which is convertable to a data frame. 
#'     In this case the `HTMLWidgets.dataframeToD3()`
#'     JavaScript function will be called on the client to transform
#'     the data into D3 friendly (row-oriented) data; or
#'     
#'   - A JSON object created using [jsonlite::toJSON]  
#' 
#' @export
as_d3_data <- function(x, ...) {
  UseMethod("as_d3_data")
}

#' @rdname as_d3_data
#' @export
as_d3_data.default <- function(x, ...) {
  x <- as.data.frame(x)
  if (length(row.names(x)) > 0 && !"names" %in% colnames(x)) {
    x$names <- rownames(x)
  }
  x
}

#' @rdname as_d3_data
#' @export
as_d3_data.data.frame <- function(x, ...) {
  x
}

#' @rdname as_d3_data
#' @export
as_d3_data.json <- function(x, ...) {
  x
}







