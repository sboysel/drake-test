# generate some sample input data
N <- 500
G <- 5
readr::write_csv(
  x = tibble::tibble(x = runif(N * G), y = runif(N * G), g = rep(letters[1:G], N)),
  path = "input/input1.csv",
)

readr::write_csv(
  x = tibble::tibble(g = rep(letters[1:G], N), z = rnorm(N * G), d = rbinom(N * G, 1, 0.5)),
  path = "input/input2.csv"
)

# fn_first
fn_first <- function(first) {
  
  input1 <- readr::read_csv(file = first$input1)
  
  input2 <- readr::read_csv(file = first$input2) %>%
    dplyr::group_by(g) %>%
    dplyr::summarise(sum_dz = sum(d * z))
  
  dplyr::left_join(
    x = input1,
    y = input2,
    by = "g"
  )
  
}

# fn_second
fn_second <- function(second) {
  second %>%
    dplyr::mutate(w = x * y * sum_dz) %>%
    dplyr::select(g, w)
}

# fn_third
fn_third <- function(third) {
  ggplot2::ggplot(data = third, aes(x = w, fill = g, group = g)) +
    geom_density(alpha = 0.5)
}
