.onLoad <- function(...) {
  if (requireNamespace("knitr", quietly = TRUE)) {
    knit_engines <- get("knit_engines", envir = asNamespace("knitr"))
    knit_engines$set(d3 = knit_d3)
  }
}
