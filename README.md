# bankr.cbi

Read and Process CBI Bank Statement Files

## Installation

You can install the development version of bankr.cbi from GitHub:

``` r
# install.packages("pak")
pak::pak("bankrr/bankr.cbi")
```

## Usage

The package provides functions to read and process CBI (Corporate Banking Interbancario) format files:

``` r
library(bankr.cbi)

# Read a CBI file
cbi_data <- read_cbi("path/to/file.cbi")

# Tidy the data into a data frame
tidy_data <- tidy_cbi(cbi_data)
```
