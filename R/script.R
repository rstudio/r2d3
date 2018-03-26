# Prepares a D3 script to be embedable into a widget
script_wrap <- function(script, inject) {
  contents <- readLines(script)
  
  wrapped <- c(
    paste("var d3Script = function(", inject, ", r2) {", sep = ""),
    contents,
    "};"
  )
  
  temp_dir <- tempfile()
  if (dir.exists(temp_dir)) unlink(temp_dir, recursive = TRUE)
  dir.create(temp_dir)
  
  wrapped_script <- file.path(temp_dir, "d3-wrapper.js")
  writeLines(wrapped, wrapped_script)
  
  wrapped_script
}