.onLoad <- function(...) {
  if ("knitr" %in% installed.packages()) {
    knit_engines <- get("knit_engines", envir = asNamespace("knitr"))
    knit_print <- get("knit_print", envir = asNamespace("knitr"))
    engine_output <- get("engine_output", envir = asNamespace("knitr"))
    
    knit_engines$set(d3 = function(options) {
      
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
      
      widget_output <- knit_print(widget, options)
      engine_output(
        options, out = list(
          structure(list(src = options$code), class = 'source'),
          widget_output
        )
      )
    })
  }
}