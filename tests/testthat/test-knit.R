context("knit")

source("utils.R")

test_succeeds("r2d3 can knit visualizations", {
  skip_on_cran()

  if (!rmarkdown::pandoc_available())
    skip("rmarkdown requires pandoc")

  output <- tempfile(fileext = ".html")
  rmarkdown::render("barchart.Rmd", output_file = output)
})
