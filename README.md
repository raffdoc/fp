
<!-- README.md is generated from README.Rmd. Please edit that file -->

# `{fp}`

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

## Installation

You can install the development version of `{fp}` like so:

``` r
# FILL THIS IN! HOW CAN PEOPLE INSTALL YOUR DEV PACKAGE?
```

## Run

You can launch the application by running:

``` r
fp::run_app()
```

## Deployment

### Docker

To build and run the application using Docker:

1. **Build the image:**
   ```bash
   docker build -t fp-app .
   ```

2. **Run the container:**
   ```bash
   docker run -p 3838:3838 fp-app
   ```
   The app will be available at `http://localhost:3838`.

### Docker Compose (Recommended)

To simplify deployment, you can use Docker Compose:

1. **Start the application:**
   ```bash
   docker compose up -d
   ```

2. **Stop the application:**
   ```bash
   docker compose down
   ```

## About

You are reading the doc about version : 0.0.1.1

This README has been compiled on the

``` r
Sys.time()
#> [1] "2026-03-04 14:24:34 CET"
```

Here are the tests results and package coverage:

``` r
devtools::check(quiet = TRUE)
#> ℹ Loading fp
#> ── R CMD check results ─────────────────── fp 0.0.1.1 ────
#> Duration: 1m 3.7s
#> 
#> ❯ checking for missing documentation entries ... WARNING
#>   Undocumented code objects:
#>     ‘fp’ ‘fp.df.web’
#>   Undocumented data sets:
#>     ‘fp.df.web’ ‘fp’
#>   All user-level objects in a package should have documentation entries.
#>   See chapter ‘Writing R documentation files’ in the ‘Writing R
#>   Extensions’ manual.
#> 
#> ❯ checking for future file timestamps ... NOTE
#>   unable to verify current time
#> 
#> ❯ checking top-level files ... NOTE
#>   Non-standard files/directories found at top level:
#>     ‘README.html’ ‘Rplots.pdf’ ‘margaryan_flight_plan.json’
#> 
#> ❯ checking package subdirectories ... NOTE
#>   Problems with news in ‘NEWS.md’:
#>   No news entries found.
#> 
#> ❯ checking dependencies in R code ... NOTE
#>   Namespaces in Imports field not imported from:
#>     ‘DataExplorer’ ‘Hmisc’ ‘dplyr’ ‘ggplot2’ ‘ggthemes’ ‘googledrive’
#>     ‘googlesheets4’ ‘lubridate’ ‘mice’ ‘plotly’ ‘readr’ ‘scales’
#>     ‘stringr’ ‘tidyr’ ‘visdat’
#>     All declared Imports should be used.
#> 
#> ❯ checking R code for possible problems ... NOTE
#>   app_server: no visible global function definition for ‘create_plot’
#>   app_server: no visible binding for global variable ‘fp’
#>   app_server: no visible binding for global variable ‘fp.df.web’
#>   app_ui: no visible binding for global variable ‘fp’
#>   Undefined global functions or variables:
#>     create_plot fp fp.df.web
#> 
#> 0 errors ✔ | 1 warning ✖ | 5 notes ✖
#> Error:
#> ! R CMD check found WARNINGs
```

``` r
covr::package_coverage()
#> Error in `loadNamespace()`:
#> ! there is no package called 'covr'
```

## Changes

The `create_plot` function in `inst/app_code/plot_fp.r` has been
refactored for better stability and error handling:

- **Input Validation:** Now handles `NULL`, empty, or invalid patient
  IDs gracefully by returning a blank plot with an informative message.
- **Optimization:** Patient data and metadata are filtered once at the
  start of the function, reducing redundant filtering operations.
- **Compatibility:** Updated deprecated `size` arguments to `linewidth`
  for compatibility with `ggplot2` (3.4.0+).
- **Safe Calculations:** Added robust date parsing and checks for
  missing values before adding vertical lines or text annotations.
-   **Testing:** New unit tests added in `tests/testthat/test-plot_fp.R` to ensure consistent behavior across edge cases.
-   **Dependencies:** Added `lubridate` to `Imports` in the `DESCRIPTION` file.

### Docker and Secret Management Improvements (March 2026)

- **Volume Mounting:** Updated `docker-compose.yml` to mount the `.secrets/` directory at runtime, ensuring `flightplan.json` is available without being baked into the image.
- **Persistent Working Directory:** Configured `Dockerfile` and `docker-compose.yml` to use `/app` consistently, matching the expected relative paths in the code.
- **Robust Path Detection:** Refined `inst/app_code/get_data.r` to search for credentials in both the working directory and the installed package directory using `app_sys()`.
- **Environment Parity:** Improved the alignment between local development and containerized deployment by standardizing file paths.

