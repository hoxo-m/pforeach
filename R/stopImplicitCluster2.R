#'Stop implicit cluster
#'
#'@export
stopImplicitCluster2 <- function() {
  options <- doParallel:::.options
  if (exists(".revoDoParCluster", where = options) &&
        !is.null(get(".revoDoParCluster", envir = options))) {
    parallel::stopCluster(get(".revoDoParCluster", envir = options))
    remove(".revoDoParCluster", envir = options)
  }
}
