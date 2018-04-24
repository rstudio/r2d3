context("knit")

source("utils.R")

test_succeeds("r2d3 can be used in shiny applications", {
  if (!"shinytest" %in% installed.packages()) {
    skip("Package 'shinytest' not installed.")
  }
  
  app <- shinytest::ShinyDriver$new("barchart/")
  app$snapshotInit("shinytest")
  
  app$setInputs(bar_max = 1)
  app$snapshot()
  app$setInputs(bar_max = 0.2)
  app$snapshot()
})