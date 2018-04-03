.onLoad <- function(...) {
  if ("knitr" %in% installed.packages()) {
    knit_engines <- get("knit_engines", envir = asNamespace("knitr"))
    knit_print <- get("knit_print", envir = asNamespace("knitr"))
    engine_output <- get("engine_output", envir = asNamespace("knitr"))
    
    knit_engines$set(d3 = function(options) {
      
      if (identical(.Platform$GUI, "RStudio") && is.character(options$data)) {
        options$data <- get(options$data, envir = globalenv())
      }
      
      widget <- r2d3::r2d3(
        data = options$data,
        script = options$code,
        options = options$options,
        tag = options$tag,
        version = options$version,
        dependencies = options$dependencies,
        width = options$width,
        height = options$height
      )
      
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
    })
  }
}