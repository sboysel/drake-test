# source packages
source(file.path(PROJHOME, "code", "packages.R"))

# source functions
source(file.path(PROJHOME, "code", "functions.R"))

# other setup
options(clustermq.scheduler = "multicore")

# define initial inputs / parameters from input directory
first <- list(
  input1 = subdir_file("input/input1.csv"),
  input2 = subdir_file("input/input2.csv")
)

# define plan
plan <- drake::drake_plan(
  second = fn_first(first),
  third = second %>%
    dplyr::mutate(w = x * y * sum_dz) %>%
    dplyr::select(g, w),
  fourth = fn_third(third),
  doc = rmarkdown::render(
    drake::knitr_in(subdir_file("code/document.Rmd")),
    output_file = drake::file_out(subdir_file("output/document.pdf")))
)

# visualize plan (before build)
config <- drake::drake_config(plan)
drake::vis_drake_graph(config)

# execute plan
drake::make(plan, jobs = 2, parallelism = "clustermq")

# visualize plan (after build)
config <- drake::drake_config(plan)
drake::vis_drake_graph(config)

# load the ggplot2 object returned by fn_third()
drake::loadd(fourth)
fourth
