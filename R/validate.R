validate_line <- function(x) {
  if (nchar(x) == 120L) {
    return(TRUE)
  }
  FALSE
}

validate_cbi <- function(x) {
  stopifnot(
    "`x` is not a character vector" = is.character(x),
    "`x` should have at least one item" = length(x) > 0
  )

  valid_len <- lgl_ply(
    x,
    validate_line
  )

  invalid_idx <- which(!valid_len)
  if (length(invalid_idx)) {
    stop(
      sprintf("The following lines does have 120 characters: %s"),
      paste0(invalid_idx, collapse = ", ")
    )
  }

  if (!is_header(x[[CBI_HEADER_IDX]])) {
    stop("First row is not a header record")
  }

  if (!is_summary(x[[CBI_SUMMARY_IDX]])) {
    stop("Second row is not a summary record")
  }

  if (!is_closing(x[[length(x) - 1]])) {
    stop("Second-last row is not a closing record")
  }

  if (!is_footer(x[[length(x)]])) {
    stop("Last row is not a footer record")
  }

  invalid_trans <- lgl_ply(
    seq_along(x),
    function(i) {
      ln <- x[[i]]
      # Skip header, summary, closing (n-1), footer (n)
      if (i < CBI_FIRST_TRANSACTION_IDX || i >= length(x) - 1L) {
        return(TRUE)
      }
      is_transaction(ln) || is_continuation(ln)
    }
  )

  invalid_trans_idx <- which(!invalid_trans)
  if (length(invalid_trans_idx)) {
    stop(
      sprintf(
        "The following lines are not valid transactions or continuation rows: %s",
        paste0(invalid_trans_idx, collapse = ", ")
      )
    )
  }

  invisible(x)
}
