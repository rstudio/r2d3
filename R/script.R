# Prepares a D3 script to be embedable into a widget
script_wrap <- function(deps, script, container) {
  deps_contents <- script_read(deps)
  script_contents <- script_read(script)
  
  if (is.character(script_contents) && length(script_contents) > 1)
    script_contents <- paste(script_contents, collapse = "\n")
  
  script_contents <- paste(
    # some libraries expect the container to be created from the extended d3 object.
    container, " = d3.select(", container, ".node());",
    "\n",
    script_contents,
    sep = ""
  )
  
  paste(
    "var d3Script = function(d3, r2d3, data, ", container, ", width, height, options, theme, console) {",
    "\n",
    # some libraries expect d3 to be accessible as this.d3
    "this.d3 = d3;",
    "\n",
    deps_contents,
    "\n",
    script_contents,
    "\n",
    "};",
    sep = ""
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
          paste("/* R2D3 Source File: ", e, "*/"),
          readLines(e, warn = FALSE)
        ), collapse = "\n"
      )
    ),
    collapse = "\n\n"
  )
}