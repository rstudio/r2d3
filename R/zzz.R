.onLoad <- function(...) {
  if ("knitr" %in% installed.packages()) {
    knit_engines <- get("knit_engines", envir = asNamespace("knitr"))
    
    knit_engines$set(d3 = knit_d3)
  }
}