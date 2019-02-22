if (!"drake" %in% row.names(installed.packages())) {
  devtools::install_github("ropensci/drake")
}

if (!"here" %in% row.names(installed.packages())) {
  install.packages("here")
}

# load all packages
library(drake)
library(here)
library(tidyverse)

# other setup
here::set_here(verbose = FALSE)

# source functions
source(here::here("code", "functions.R"))

# generate some sample input data
N <- 500
G <- 5
readr::write_csv(
  x = tibble::tibble(x = runif(N * G), y = runif(N * G), g = rep(letters[1:G], N)),
  path = here::here("input", "input1.csv")
)

readr::write_csv(
  x = tibble::tibble(g = rep(letters[1:G], N), z = rnorm(N * G), d = rbinom(N * G, 1, 0.5)),
  path = here::here("input", "input2.csv")
)

# define initial inputs / parameters from input directory
first <- list(
  input1 = here::here("input", "input1.csv"),
  input2 = here::here("input", "input2.csv")
)

# define plan
plan <- drake::drake_plan(
  second = fn_first(first),
  third = second %>%
    dplyr::mutate(w = x * y * sum_dz) %>%
    dplyr::select(g, w),
  fourth = fn_third(third)
)

# execute plan
drake::make(plan)

# load the ggplot2 object returned by fn_third()
drake::loadd(fourth)
fourth
