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

fn_second <- function(second) {
  second %>%
    dplyr::mutate(w = x * y * sum_dz) %>%
    dplyr::select(g, w)
}

fn_third <- function(third) {
  ggplot2::ggplot(data = third, aes(x = w, fill = g, group = g)) +
    geom_density(alpha = 0.5)
}