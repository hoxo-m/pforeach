#'Parallelized foreach
#'
#'@param ... input for foreach.
#'@param .combine function that is used to process the tasks results as they generated.
#'@param .c the relief of .combine parameter. Additionally .c=list means list combine that is deafault on foreach.
#'@param .parallel if TRUE, execute parallel processing.
#'@param .debug if TRUE, execute sequential processing(not parallel).
#'@param .cores number of cores for paralell processing.
#'@param .seed random number seed.
#'@param .export character vector of variables to export.
#'@param .packages character vector of packages that the tasks depend on.
#'
#'@export
pforeach <- function(..., .c, .combine=c, 
                     .parallel=TRUE, .debug=!.parallel, 
                     .cores, .seed=NULL,
                     .init, .final=NULL, .inorder=TRUE,
                     .multicombine=FALSE,
                     .maxcombine=if (.multicombine) 100 else 2,
                     .errorhandling=c('pass', 'stop', 'remove'),
                     .packages=NULL, .export=NULL, .noexport=NULL,
                     .verbose=FALSE) {
  if(!.parallel || .debug) {
    foreach::registerDoSEQ()
    if(!is.null(.seed)) set.seed(.seed)
  } else {
    if(missing(.cores)) .cores=parallel::detectCores()
    else if(.cores <= 0) .cores=parallel::detectCores() + .cores
    doParallel::registerDoParallel(.cores)
    if(is.null(.packages)) {
      namespaces <- loadedNamespaces()
      dplyr_pos <- Position(function(x) x=="dplyr", namespaces)
      if(is.na(dplyr_pos)) {
        .packages=namespaces
      } else {
        .packages=c(namespaces[-dplyr_pos], "dplyr")
      }
    }
  }
  .frames <- rev(Map(sys.frame, sys.parents()))
  for(.frame in .frames) {
    .var_names <- ls(.frame)
    if(identical(.var_names, c("enclos","envir","expr"))) {
      break
    }
    for(.name in .var_names) {
      if(!exists(.name, inherits = FALSE)) {
        assign(.name, get(.name, envir = .frame))
      }
    }
  }
  if(is.null(.export)) .export=ls()
  .export <- c(.export, ".my_var_list")
  if(missing(.init)) .init=NULL
  if(!missing(.c)) {
    if(identical(.c, list) || identical(.c, "list")) {
      .combine=foreach:::defcombine
      .init=list()
    } else {
      .combine=.c
    }
  }
  .errorhandling = match.arg(.errorhandling)
  return(function(.expr) {
    .my_env <- parent.frame()
    .my_var_list <- Filter(function(x) !grepl("%", x), ls(env=.my_env))
    .my_var_list <- Map(function(name) eval(parse(text=name), env=.my_env) ,.my_var_list)
    .expr <- paste(deparse(substitute(.expr)), collapse="\n")
    .expr <- parse(text=sprintf(".my_env <- environment(); Map(function(x, y, z) assign(x, y, envir=z), names(.my_var_list), .my_var_list, rep(list(.my_env), length(.my_var_list))); %s", .expr))
    on.exit(stopImplicitCluster2())
    .doop <- foreach::`%dopar%`
    if(!is.null(.seed)) {
      if(!require(doRNG)) stop("install.packages('doRNG')")
      set.seed(.seed)
      .doop <- doRNG::`%dorng%`
    }
    if(is.null(.init)) {
      .doop(foreach(..., .combine=.combine, 
              .final=.final, .inorder=.inorder,
              .multicombine=.multicombine,
              .maxcombine=.maxcombine,
              .errorhandling=.errorhandling,
              .packages=.packages, .export=.export, .noexport=.noexport,
              .verbose=.verbose) , eval(.expr))
    } else {
      .doop(foreach(..., .combine=.combine,
              .init=.init, .final=.final, .inorder=.inorder,
              .multicombine=.multicombine,
              .maxcombine=.maxcombine,
              .errorhandling=.errorhandling,
              .packages=.packages, .export=.export, .noexport=.noexport,
              .verbose=.verbose), eval(.expr))
    }
  })
}
