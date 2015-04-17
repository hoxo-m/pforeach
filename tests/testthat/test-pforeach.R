context("Test for pforeach")

test <- FALSE
if(test) {
  test_that("Order of loaded packages", {
    library(plyr)
    library(dplyr)
    act <- pforeach(i = 1:3)({
      iris %>% summarize(count=n())
    })$count
    expect_equal(act, 150)
  })
  
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
  
  test_that("Enclosed variable", {
    square <- function(x) x**2
    execute <- function() {
      pforeach(i = 1:3)({
        square(i)
      })
    }
    act <- execute()
    expect_equal(act, c(1, 4, 9))
  })
  
  test_that("Enclosed variable2", {
    execute <- function() {
      ppp <- 1:3
      pforeach(i = ppp)({
        i ** 2
      })
    }
    act <- execute()
    expect_equal(act, c(1, 4, 9))
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

  test_that("Triple loop", {
    act <- pforeach(i=1:2)({
      pforeach(j=3:4)({
        pforeach(k=5:6)({
          i
        })
      })
    })
    expect_equal(act, c(1, 1, 1, 1, 2, 2, 2, 2))
  })
  
}
