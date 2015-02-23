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

test_that("enclosed", {
  execute <- function() {
    ppp <- 1:3
    npforeach(i = ppp)({
      i**2
    })
  }
  act <- execute()
  expect_equal(act, c(1,4,9))
})

test_that("Order of loaded packages", {
  library(plyr)
  library(dplyr)
  act <- npforeach(i = 1:3)({
    iris %>% summarize(count=n())
  })$count
  expect_equal(act, 150)
})

test_that("Packages action", {
  library(dplyr)
  act <- npforeach(i=1:3)({
    iris[i, ] %>% select(-Species) %>% sum
  })
  expect_equal(act, c(10.2, 9.5, 9.4))
})
