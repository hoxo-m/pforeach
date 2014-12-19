#'Non-Parallelized pforeach
#'
#'@param ... input for pforeach.
#'
#'@export
npforeach <- function(..., .c, .combine=c, 
                      .cores, .seed=NULL,
                      .init, .final=NULL, .inorder=TRUE,
                      .multicombine=FALSE,
                      .maxcombine=if (.multicombine) 100 else 2,
                      .errorhandling=c('pass', 'stop', 'remove'),
                      .packages=NULL, .export=NULL, .noexport=NULL,
                      .verbose=FALSE) {
  pforeach(..., .c=.c, .combine=.combine,
           .parallel=FALSE,
           .cores=.cores, .seed=.seed,
           .init=.init, .final=.final, .inorder=.inorder,
           .multicombine=.multicombine,
           .maxcombine=.maxcombine,
           .errorhandling=.errorhandling,
           .packages=.packages, .export=.export, .noexport=.noexport,
           .verbose=.verbose)
}
