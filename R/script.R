# Prepares a D3 script to be embedable into a widget
script_wrap <- function(contents, container) {
  paste(
    c(
      paste("var d3Script = function(d3, r2d3, data, ", container, ", width, height, options, theme, console) {", sep = ""),
      contents,
      "};"
    ),
    collapse = "\n"
  )
}

script_read <- function(script) {
  if (is.null(script) || length(script) == 0 || !file.exists(script))
    return(script)
  
  paste(
    sapply(
      script,
      function(e) paste(
        c(
          paste("// R2D3 Source File: ", e, ":", 0),
          readLines(e, warn = FALSE)
        ), collapse = "\n"
      )
    ),
    collapse = "\n\n"
  )
}