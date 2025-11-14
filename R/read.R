#' Read CBI
#' @param path A path.
#' @return A character vector
#' @export
read_cbi <- function(path) {
  if (!(is.character(path) && length(path) == 1)) {
    stop("Path is not a character of length one.")
  }
  x <- readLines(path)

  out <- validate_cbi(x)

  out
}
