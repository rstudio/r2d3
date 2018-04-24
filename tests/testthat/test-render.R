context("render")

source("utils.R")

test_succeeds("r2d3 can render visualizations", {
  render_r2d3_barchart()
})

test_succeeds("r2d3 can specify d3_version", {
  render_r2d3_barchart(d3_version = 4)
})

test_succeeds("r2d3 can provide user options", {
  render_r2d3_barchart(options = list(foo = "bar"))
})

test_succeeds("r2d3 can specify dimensions", {
  render_r2d3_barchart(width = 800, height = 500)
})

test_succeeds("r2d3 can provide custom css", {
  render_r2d3_barchart(css = "barchart.css")
})

test_succeeds("r2d3 can provide javascript dependencies", {
  render_r2d3_barchart(dependencies = "helper.js")
})
