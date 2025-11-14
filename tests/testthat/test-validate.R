test_that("validate_cbi() works", {
  x <- readLines(
    pkg_file("testdata", "cbi.txt")
  )
  expect_no_error(validate_cbi(x))
})