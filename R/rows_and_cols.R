#'Iterator for data frame by row
#'
#'@param df a data frame
#'
#'@export
rows <- function(df) {
  iterators::iter(df, by="row")
}

#'Iterator for data frame by column
#'
#'@param df a data frame
#'
#'@export
cols <- function(df) {
  iterators::iter(df, by="col")
}

#'Iterator for row number of a data frame
#'
#'@param df a data frame
#'
#'@export
irows <- function(df) {
  iterators::icount(nrow(df))
}

#'Iterator for column number of a data frame
#'
#'@param df a data frame
#'
#'@export
icols <- function(df) {
  iterators::icount(ncol(df))
}
