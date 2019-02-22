# source packages
source("code/packages.R")

# source functions
source("code/functions.R")

# other setup
options(clustermq.scheduler = "multicore")

# define initial inputs / parameters from input directory
first <- list(
  input1 = "input/input1.csv",
  input2 = "input/input2.csv"
)

# define plan
plan <- drake::drake_plan(
  second = fn_first(first),
  third = second %>%
    dplyr::mutate(w = x * y * sum_dz) %>%
    dplyr::select(g, w),
  fourth = fn_third(third),
  doc = rmarkdown::render(
    input = drake::knitr_in("code/document.Rmd"),
    output_file = drake::file_out("document.pdf"),
    output_dir = "output"
  )
)

# visualize plan (before build)
config <- drake::drake_config(plan)
drake::vis_drake_graph(config)

# visualize dependencies of a target
drake::deps_target(target = doc, config = config)
drake::deps_target(target = fourth, config = config)

# execute plan
drake::make(plan, jobs = 2, parallelism = "clustermq")

# visualize plan (after build)
config <- drake::drake_config(plan)
drake::vis_drake_graph(config)

# list cached objects
drake::cached()

# load the ggplot2 object returned by fn_third()
drake::loadd(fourth)
fourth

# clean up cache after build
drake::clean(garbage_collection = TRUE)
drake::cached()
