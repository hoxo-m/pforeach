# Easy way to parallel processing in R
Koji MAKIYAMA  



## Overture

There is a parallel processing code using the `foreach` package:


```r
library(doParallel)
cl <- makeCluster(detectCores())
registerDoParallel(cl)
result <- foreach(i = 1:3, .combine=c) %dopar% {
  i**2
}
stopCluster(cl)
print(result)
```

```
## [1] 1 4 9
```

It can be simplified using `pforeach()` instead of `foreach()`:


```r
library(pforeach)
result <- pforeach(i = 1:3)({
  i**2
})
print(result)
```

```
## [1] 1 4 9
```

## How to install


```r
install.packages("devtools") # if you have not installed "devtools" package
devtools::install_github("hoxo-m/pforeach")
```

## To simplify!

### With other packages

Using `foreach()`:


```r
library(doParallel)
library(dplyr) # With other package
cl <- makeCluster(detectCores())
registerDoParallel(cl)
# You must indicate .packages parameter.
result <- foreach(i = 1:3, .combine=c, .packages="dplyr") %dopar% {
  iris[i, ] %>% select(-Species) %>% sum
}
stopCluster(cl)
print(result)
```

```
## [1] 10.2  9.5  9.4
```

Using `pforeach()`:


```r
library(pforeach)
library(dplyr) # With other package
# You need not to mind that.
pforeach(i = 1:3)({
  iris[i, ] %>% select(-Species) %>% sum
})
```

```
## [1] 10.2  9.5  9.4
```

### With enclosed variables

Using `foreach()`:


```r
# You must indicate .export parameter. 
square <- function(x) x**2
execute <- function() {
  cl <- makeCluster(detectCores())
  registerDoParallel(cl)
  result <- foreach(i = 1:3, .combine=c, .export="square") %dopar% {
    square(i)
  }
  stopCluster(cl)
  result
}
execute()
```

```
## [1] 1 4 9
```

Using `pforeach()`:


```r
# Need not to mind!
library(pforeach)
square <- function(x) x**2
execute <- function() {
  pforeach(i = 1:3)({
    square(i)
  })
}
execute()
```

```
## [1] 1 4 9
```

### Row and Column

## Options

### Cores

### Fix random seed

### Do not parallel
