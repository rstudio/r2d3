context("shiny")

source("utils.R")

test_that("r2d3 can be used in shiny applications", {
  skip_on_cran()
  
  shinytest::expect_pass(shinytest::testApp("barchart", compareImages = FALSE))
})
