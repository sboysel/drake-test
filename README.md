# drake-test

Testing a [`drake`](https://github.com/ropensci/drake)-based project workflow.

## Notes

Start by reading the master build script `build.R`.

1. Master build script is `build.R` in the project root directory.
2. Load packages in `code/packages.R`.
3. Define *all* project functions in `code/functions.R`.
4. Subdirectories:
    - `input`: input data goes here
    - `code`: any code executed in build plan is defined here
    - `temp`: write temp objects (if necessary) here
    - `output`: all final outputs should be generated here
5. Use `drake::file_in()`, `drake::file_out()`, and `drake::knitr_in()` in `drake::drake_plan()` 
6. Utility function is `subdir_file()` defined in `code/functions.R` to expand and normalize of a file located in some project subdirectory, e.g. `path/to/subdirectory/file`.  Note that the full relative path must be specified in `subdir_file()` so that `drake` correctly located the file.

## Requirements

- **Parallelism:** The `clustermq` package is required for parallel processing and requires `zeromq`.  For OS X with Homebrew, 
    
    ```bash
    brew install zeromq
    ```
    
    In R:
    
    ```r
    install.packages("clustermq")
    ``` 

## References

- [drake cheat sheet](https://github.com/krlmlr/drake-sib-zurich/blob/master/cheat-sheet.pdf)