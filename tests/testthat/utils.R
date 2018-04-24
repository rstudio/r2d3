library(r2d3)

render_r2d3_barchart <- function(...) {
  r2d3(data=c(0.3, 0.6, 0.8, 0.95, 0.40, 0.20), script = "barchart.js", ...)
}

test_succeeds <- function(desc, expr) {
  test_that(desc, {
    expect_error(force(expr), NA)
  })
}

