#'Non-Parallelized pforeach
#'
#'@param ... input for pforeach.
#'
#'@export
npforeach <- function(...) {
  pforeach(..., .parallel=FALSE)
}
