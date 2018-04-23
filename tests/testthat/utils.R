

test_succeeds <- function(desc, expr) {
  test_that(desc, {
    expect_error(force(expr), NA)
  })
}

