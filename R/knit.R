knit_d3 <- function (options) {
  knit_print <- get("knit_print", envir = asNamespace("knitr"))
  engine_output <- get("engine_output", envir = asNamespace("knitr"))
  
  if (identical(.Platform$GUI, "RStudio") && is.character(options$data)) {
    options$data <- get(options$data, envir = globalenv())
  }
  
  if (is.null(options$d3_version)) {
    options$d3_version <- "5"
  }
  
  if (is.null(options$container)) {
    options$container <- "svg"
  }
  
  if ("reactive" %in% class(options$data)) {
    widget <- renderD3({
      r2d3(
        options$data(),
        options$code
      )
    })
  } else {
    widget <- r2d3(
      data = options$data,
      script = options$code,
      options = options$options,
      container = options$container,
      d3_version = options$d3_version,
      dependencies = options$dependencies,
      width = options$width,
      height = options$height
    )
  }
  
  if (identical(.Platform$GUI, "RStudio")) {
    widget
  }
  else {
    widget_output <- knit_print(widget, options = options)
    engine_output(
      options, out = list(
        structure(list(src = options$code), class = 'source'),
        widget_output
      )
    )
  }
}