context("knit")

source("utils.R")

test_that("r2d3 can be used in shiny applications", {
  if (!"shinytest" %in% installed.packages()) {
    skip("Package 'shinytest' not installed.")
  }
  
  shinytest::expect_pass(shinytest::testApp("barchart"))
})
