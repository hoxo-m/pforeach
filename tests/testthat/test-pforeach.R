context("Test for pforeach")

test <- FALSE
if(test) {
  test_that("Default action", {
    act <- pforeach(i = 1:3)({
      i**2
    })
    expect_equal(act, c(1, 4, 9))
  })
  
  test_that("Packages action", {
    library(dplyr)
    act <- pforeach(i=1:3)({
      iris[i, ] %>% select(-Species) %>% sum
    })
    expect_equal(act, c(10.2, 9.5, 9.4))
  })
  
  test_that("Rows action", {
    act <- pforeach(row=rows(iris[1:3,]))({
      sum(row[1:4])
    })
    expect_equal(act, c(10.2, 9.5, 9.4))
  })
  
  test_that("Cols action", {
    act <- pforeach(col=cols(iris[,1:4]))({
      sum(col)
    })
    expect_equal(act, c(876.5, 458.6, 563.7, 179.9))
  })
}
