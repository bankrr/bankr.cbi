#' Tidy CBI
#' @param x A character vector as returned by [read_cbi()].
#' @return A data frame
#' @export
tidy_cbi <- function(x) {
  stopifnot(is.character(x))

  # Extract account info from summary record
  summary_record <- x[is_summary(x)]
  trans <- x[is_transaction(x) | is_continuation(x)]

  dat <- data.frame(
    id = xtr_record_number(trans),
    cin = xtr_cin(summary_record),
    bank_code = xtr_bank_code(summary_record),
    branch_code = xtr_branch_code(summary_record),
    account_number = xtr_account_number(summary_record),
    date_transaction = as_date(xtr_transaction_date(trans)),
    date_value = as_date(xtr_value_date(trans)),
    credit_debit = xtr_debit_credit(trans),
    description = trimws(xtr_description(trans), "both"),
    amount = as.numeric(gsub(",", ".", xtr_amount(trans))),
    stringsAsFactors = FALSE
  )

  dat$amount <- ifelse(
    dat$credit_debit == "D" & !is.na(dat$credit_debit),
    -dat$amount,
    dat$amount
  )

  out <- dat[, setdiff(names(dat), "credit_debit"), drop = FALSE]

  if (is_pkg_avail("tibble")) {
    out <- tibble::as_tibble(flatten(out))
  }

  out
}
