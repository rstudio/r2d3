context("examples")

run_example <- function(example) {
  if (file_test("-d", example)) {
    knitr::knit(
      file.path(example, "index.Rmd"), 
      output = tempfile("r2d3_example", fileext = ".md"), 
      quiet = TRUE
    )
  }
}

examples <- file.path("../../vignettes/gallery", 
  c("bubbles", "cartogram", "chord")
)

for (example in examples) {
  test_that(paste(basename(example), "example runs correctly"), {
    expect_error(run_example(example), NA)
  })
  
}

