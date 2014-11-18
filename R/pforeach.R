#'Parallelized foreach
#'
#'@param ... input for foreach.
#'@param .combine function that is used to process the tasks results as they generated.
#'@param .parallel if TRUE, execute parallel processing.
#'@param .debug if TRUE, execute sequential processing(not parallel).
#'@param .cores number of cores for paralell processing.
#'@param .seed random number seed.
#'@param .export character vector of variables to export.
#'@param .packages character vector of packages that the tasks depend on.
#'
#'@export
pforeach <- function(..., .combine=c, .parallel=TRUE, .debug=!.parallel, .cores, .seed=NULL, .export, .packages) {
  if(!.parallel || .debug) {
    foreach::registerDoSEQ()
    if(!is.null(.seed)) set.seed(.seed)
  } else {
    if(missing(.cores)) .cores=parallel::detectCores()
    else if(.cores <= 0) .cores=parallel::detectCores() + .cores
    doParallel::registerDoParallel(.cores)
  }
  if(missing(.export)) .export=ls(parent.frame(1000))
  if(missing(.packages)) .packages=loadedNamespaces()
  return(function(expr) {
    expr <- substitute(expr)
    on.exit(stopImplicitCluster2())
    `%doop%` <- foreach::`%dopar%`
    if(!is.null(.seed)) {
      if(!require(doRNG)) stop("install.packages('doRNG')")
      set.seed(.seed)
      `%doop%` <- doRNG::`%dorng%`
    }
    foreach(..., .combine=.combine, .export=.export, .packages=.packages) %doop% eval(expr)
  })
}
