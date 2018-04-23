context("examples")

run_example <- function(example) {
  if (!is.na(Sys.getenv("R2D2_TEST_EXAMPLES", unset = NA))) {
    knitr::knit(
      file.path(example, "index.Rmd"), 
      output = tempfile("r2d3_example", fileext = ".md"), 
      quiet = TRUE
    )
  } else {
    skip(paste("Skipping example", basename(example)))
  }
}

examples <- list.dirs("../../vignettes/gallery", recursive = FALSE)

for (example in examples) {
  
  test_that(paste(basename(example), "example runs correctly"), {
  
    expect_error(run_example(example), NA)
  })
  
}

