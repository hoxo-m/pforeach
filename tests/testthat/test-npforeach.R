context("Test for npforeach")

test_that("Default action", {
  act <- npforeach(i = 1:3)({
    i**2
  })
  expect_equal(act, c(1, 4, 9))
})

test_that(".init", {
  act <- npforeach(i = 1:3, .init=0)({
    i**2
  })
  expect_equal(act, c(0, 1, 4, 9))
})

test_that("list combine", {
  act <- npforeach(i = 1:3, .c=list)({
    1:i
  })
  expect_equal(act, list(1:1, 1:2, 1:3))
})

test_that("list combine", {
  act <- npforeach(i = 1:3, .c="list")({
    1:i
  })
  expect_equal(act, list(1:1, 1:2, 1:3))
})

test_that("default combine", {
  act <- npforeach(i = 1:3, .c=c)({
    1:i
  })
  expect_equal(act, c(1,1,2,1,2,3))
})
