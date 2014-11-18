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
