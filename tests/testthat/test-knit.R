context("knit")

source("utils.R")

test_succeeds("r2d3 can knit visualizations", {
  output <- tempfile(fileext = ".html")
  rmarkdown::render("barchart.Rmd", output_file = output)
})