context("Test for pforeach")

test_that("Default action", {
  act <- pforeach(i = 1:3)({
    i**2
  })
  expect_equal(act, c(1,4,9))
})

test_that("Packages action", {
  library(dplyr)
  act <- pforeach(i=1:3)({
    iris[i, ] %>% select(-Species) %>% sum
  })
  expect_equal(act, c(10.2, 9.5, 9.4))
})
