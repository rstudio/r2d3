# Prepares a D3 script to be embedable into a widget
script_wrap <- function(contents, tag) {
  paste(
    c(
      paste("var d3Script = function(d3, r2d3, data, ", tag, ", width, height, options) {", sep = ""),
      contents,
      "};"
    ),
    collapse = "\n"
  )
}

script_read <- function(script) {
  if (is.null(script) || !file.exists(script))
    return(script)
  
  paste(
    sapply(
      script,
      function(e) paste(readLines(e), collapse = "\n")
    ),
    collapse = "\n\n"
  )
}